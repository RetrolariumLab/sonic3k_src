"""Compose independently validated content spans without losing adjacent owners."""

import hashlib
from pathlib import Path

from scripts.authoring.assembly_content import _path
from scripts.build.project import ROOT, atomic


def compose(originals, patches):
    """Validate all identities and intervals before producing complete source files."""
    if not isinstance(originals, dict) or not isinstance(patches, list) or len(patches) > 65536:
        raise ValueError("Source fragment composition needs bounded owners and patches")
    grouped, identities = {}, set()
    for patch in patches:
        if set(patch) != {"path", "owner", "first_line", "last_line", "original_sha256", "source"}:
            raise ValueError("Source patch fields differ from the fragment contract")
        name = _path(patch["path"])
        if name not in originals or not isinstance(originals[name], bytes) or len(originals[name]) > 0x800000:
            raise ValueError("Source fragment has no bounded original source owner")
        owner = patch["owner"]
        if not isinstance(owner, str) or not owner or len(owner) > 512 or (name, owner) in identities:
            raise ValueError("Source fragment owner is invalid or duplicated")
        identities.add((name, owner))
        first, last = patch["first_line"], patch["last_line"]
        lines = originals[name].decode("utf-8").splitlines(keepends=True)
        if type(first) is not int or type(last) is not int or not 1 <= first <= last <= len(lines):
            raise ValueError("Source fragment leaves its physical source interval")
        prior = "".join(lines[first - 1 : last]).encode()
        if hashlib.sha256(prior).hexdigest() != patch["original_sha256"]:
            raise ValueError("Source fragment original changed before composition")
        source = patch["source"]
        if not isinstance(source, str) or not source or len(source) > 0x100000 or not source.endswith("\n"):
            raise ValueError("Encoded source fragment must be bounded complete lines")
        grouped.setdefault(name, []).append(patch)
    outputs, evidence = {}, []
    for name, items in sorted(grouped.items()):
        ordered = sorted(items, key=lambda item: item["first_line"])
        end = 0
        for item in ordered:
            if item["first_line"] <= end:
                raise ValueError("Content families overlap the same original source lines")
            end = item["last_line"]
        lines = originals[name].decode("utf-8").splitlines(keepends=True)
        for item in reversed(ordered):
            lines[item["first_line"] - 1 : item["last_line"]] = [item["source"]]
        outputs[name] = "".join(lines).encode()
        evidence.extend(
            {
                "path": name,
                "owner": item["owner"],
                "first_line": item["first_line"],
                "last_line": item["last_line"],
                "original_sha256": item["original_sha256"],
                "encoded_span_sha256": hashlib.sha256(item["source"].encode()).hexdigest(),
            }
            for item in ordered
        )
    return outputs, evidence


def write(workspace, originals, patches):
    workspace = Path(workspace).resolve()
    if not workspace.is_relative_to((ROOT / "build/authoring").resolve()):
        raise ValueError("Source fragments leave ignored authoring storage")
    outputs, spans = compose(originals, patches)
    destinations = {}
    for name in outputs:
        destination = (workspace / name).resolve()
        if not destination.is_relative_to(workspace / "src"):
            raise ValueError("Encoded fragment owner leaves the workspace source tree")
        destinations[name] = destination
    # No fragment can write until every family, interval and destination is valid.
    for name, data in outputs.items():
        atomic(destinations[name], data)
    return {
        "source_files": len(outputs),
        "fragments": spans,
        "outputs": {name: hashlib.sha256(data).hexdigest() for name, data in outputs.items()},
    }

"""Read-only local candidate and annotated-release identity checks."""

import json
import re
import subprocess

from scripts.build.project import ROOT


def git(root, *args):
    return subprocess.check_output(["git", *args], cwd=root, text=True).strip()


def parse_tag(text, identity):
    header, separator, message = text.partition("\n\n")
    fields = dict(line.split(" ", 1) for line in header.splitlines() if " " in line)
    return {
        "kind": "tag",
        "object": identity,
        "target": fields.get("object"),
        "target_type": fields.get("type"),
        "name": fields.get("tag"),
        "message": message.strip() if separator else "",
    }


def read_tag(root, name):
    if not re.fullmatch(r"source-reconstruction-[12]\.0", name):
        raise ValueError("Unsupported release tag identity")
    ref = "refs/tags/" + name
    result = subprocess.run(["git", "show-ref", "--verify", "--quiet", ref], cwd=root)
    if result.returncode == 1:
        return None
    result.check_returncode()
    identity = git(root, "rev-parse", ref)
    kind = git(root, "cat-file", "-t", ref)
    if kind != "tag":
        return {"kind": kind, "object": identity}
    return parse_tag(git(root, "cat-file", "-p", ref), identity)


def check_tag(row, name, target):
    if (
        row is None
        or row.get("kind") != "tag"
        or row.get("target_type") != "commit"
        or row.get("target") != target
        or row.get("name") != name
        or not row.get("message", "").strip()
        or not re.fullmatch(r"[0-9a-f]{40}", row.get("object", ""))
    ):
        raise ValueError("Annotated release tag needs its exact commit, name and summary: " + name)


def validate_state(manifest, head, tags, post_tag=False):
    if manifest.get("status") not in {"tag-ready", "tagged"}:
        raise ValueError("Release must be tag-ready or tagged")
    name = manifest["tag"]
    predecessor = manifest.get("predecessor")
    previous = None
    if predecessor:
        previous = tags.get(predecessor["tag"])
        if previous is not None or post_tag:
            check_tag(previous, predecessor["tag"], predecessor["commit"])
    current = tags.get(name)
    if post_tag:
        check_tag(current, name, head)
    elif current is not None or manifest["status"] == "tagged":
        raise ValueError("Pre-tag acceptance requires the future release tag to be absent")
    return {
        "mode": "post-tag" if post_tag else "pre-tag",
        "commit": head,
        "tag": name,
        "tag_object": current["object"] if current else None,
        "predecessor_tag_object": previous["object"] if previous else None,
        "remote_refs_checked": False,
    }


def audit_tags(preservation, post_tag=False, root=ROOT):
    manifest, path = preservation, "config/source_reconstruction_1_0.json"
    candidate = root / "config/source_reconstruction_2_0.json"
    if candidate.is_file():
        second = json.loads(candidate.read_text())
        if second.get("status") in {"tag-ready", "tagged"}:
            manifest, path = second, "config/source_reconstruction_2_0.json"
    head = git(root, "rev-parse", "HEAD")
    if not post_tag and git(root, "remote"):
        raise ValueError("Pre-tag acceptance requires a checkout without publishing remotes")
    predecessor = manifest.get("predecessor")
    names = [manifest["tag"]]
    if predecessor:
        base = predecessor["commit"]
        if not re.fullmatch(r"[0-9a-f]{40}", base) or base == head:
            raise ValueError("Predecessor must identify an earlier exact commit")
        subprocess.run(["git", "merge-base", "--is-ancestor", base, head], cwd=root, check=True)
        historical = json.loads(git(root, "show", base + ":" + predecessor["manifest"]))
        if historical.get("tag") != predecessor["tag"] or historical.get("release_line") != "1.0":
            raise ValueError("Predecessor manifest and release identity differ")
        names.append(predecessor["tag"])
    result = validate_state(manifest, head, {name: read_tag(root, name) for name in names}, post_tag)
    if post_tag and json.loads(git(root, "show", head + ":" + path)) != manifest:
        raise ValueError("Working manifest differs from the tagged commit")
    return result

"""Review the complete public Markdown corpus without private inputs."""

import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urlsplit

from scripts.build.project import ROOT, atomic

LINK = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")


def tracked(root):
    return sorted(
        set(
            subprocess.check_output(["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"], cwd=root)
            .decode()
            .split("\0")
        )
        - {""}
    )


def document_inventory(root, names, review):
    """Fail on omissions, broken/escaping local links or unreachable documents."""
    root = root.resolve()
    documents = {name for name in names if name.endswith(".md")}
    rows = review.get("documents", [])
    if review.get("schema_version") != 1 or not review.get("review_scope"):
        raise ValueError("Documentation review identity is missing")
    if len(rows) != len(documents) or {row["path"] for row in rows} != documents:
        raise ValueError("Documentation review omits or duplicates a public document")
    if any(row.get("decision") not in {"kept", "reworked", "added", "merged"} or not row.get("reason") for row in rows):
        raise ValueError("Documentation decisions need a substantive reason")
    graph, inventory, paragraphs = {}, [], defaultdict(list)
    for name in sorted(documents):
        path = root / name
        if not path.resolve().is_relative_to(root):
            raise ValueError("Documentation path escapes the repository")
        data = path.read_bytes()
        text = data.decode("utf-8")
        # Code examples may contain placeholder links, which are not navigation.
        prose = re.sub(r"```.*?```", "", text, flags=re.S)
        links = []
        for match in LINK.finditer(prose):
            target = match.group(1).strip()
            if target.startswith("<"):
                target = target[1 : target.index(">")]
            parsed = urlsplit(target)
            if parsed.scheme or target.startswith("//"):
                continue
            local = (path.parent / unquote(parsed.path)).resolve() if parsed.path else path.resolve()
            if not local.is_relative_to(root) or not local.exists():
                raise ValueError("Broken or escaping documentation link: " + name + " -> " + target)
            relative = local.relative_to(root).as_posix()
            if relative not in names and local.is_file():
                raise ValueError("Documentation links to an untracked file: " + relative)
            links.append(relative)
        graph[name] = set(links) & documents
        for paragraph in re.split(r"\n\s*\n", prose):
            normalized = " ".join(paragraph.split())
            if len(normalized) >= 180 and not normalized.startswith(("#", "|", "- ")):
                paragraphs[normalized].append(name)
        inventory.append(
            {
                "path": name,
                "bytes": len(data),
                "lines": len(text.splitlines()),
                "words": len(text.split()),
                "sha256": hashlib.sha256(data).hexdigest(),
                "local_links": sorted(set(links)),
            }
        )
    pending, reachable = ["README.md", "CONTRIBUTING.md"], set()
    while pending:
        name = pending.pop()
        if name not in reachable:
            reachable.add(name)
            pending.extend(graph.get(name, set()) - reachable)
    if documents - reachable:
        raise ValueError("Unreachable documentation: " + ", ".join(sorted(documents - reachable)))
    repeats = [
        {"sha256": hashlib.sha256(text.encode()).hexdigest(), "documents": sorted(set(owners))}
        for text, owners in paragraphs.items()
        if len(set(owners)) > 1
    ]
    return {
        "schema_version": 1,
        "complete": True,
        "documents": inventory,
        "repeated_substantial_paragraphs": repeats,
        "repeated_filename_prefixes": [
            {"prefix": prefix, "documents": owners}
            for prefix in sorted({Path(name).stem.split("_")[0] for name in documents})
            if len(owners := sorted(name for name in documents if Path(name).stem.split("_")[0] == prefix)) > 1
        ],
    }


def check(root=ROOT):
    review = json.loads((root / "config/reconstruction/documentation_review.json").read_text())
    report = document_inventory(root, tracked(root), review)
    atomic(root / "build/release/documentation.json", (json.dumps(report, indent=2) + "\n").encode())
    print("[OK] Reviewed documentation corpus: " + str(len(report["documents"])) + " documents")
    return report


def main(argv=None):
    argparse.ArgumentParser(description=__doc__).parse_args(argv)
    check()
    return 0

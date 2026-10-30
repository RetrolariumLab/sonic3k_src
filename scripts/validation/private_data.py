"""Reject private payloads and undeclared binaries at every historical path."""

import argparse
from pathlib import Path, PurePosixPath
import hashlib
import json
import subprocess

from scripts.build.project import ROOT
from scripts.validation.audio_source import validate_audio_source

BINARY_SUFFIXES = frozenset(
    (
        ".bin",
        ".gen",
        ".smd",
        ".rom",
        ".nes",
        ".fds",
        ".chr",
        ".nem",
        ".kos",
        ".kosm",
        ".eni",
        ".unc",
        ".wav",
        ".pcm",
        ".dpcm",
        ".pcx",
        ".bmp",
        ".png",
        ".jpg",
        ".jpeg",
        ".gif",
        ".webp",
        ".exe",
        ".dll",
        ".so",
        ".o",
        ".obj",
        ".p",
        ".zip",
        ".7z",
        ".gz",
    )
)


def validate_blob(data, payload_hashes, allowed, path, *, binary_suffixes=BINARY_SUFFIXES, forbidden_prefixes=()):
    if hashlib.sha1(data).hexdigest() in payload_hashes:
        raise ValueError("Private asset bytes in Git: " + path)
    normalized = path.replace("\\", "/")
    if any(normalized.casefold().startswith(prefix.casefold()) for prefix in forbidden_prefixes):
        raise ValueError("Private/generated tree in Git history: " + path)
    validate_audio_source(data, path)
    if path in allowed:
        if hashlib.sha256(data).hexdigest() != allowed[path]:
            raise ValueError("Binary allowlist hash mismatch: " + path)
        return
    if PurePosixPath(normalized).suffix.lower() in binary_suffixes:
        raise ValueError("Binary suffix absent from explicit allowlist: " + path)
    if b"\0" in data:
        raise ValueError("Binary file absent from explicit allowlist: " + path)
    try:
        data.decode("utf-8-sig")
    except UnicodeDecodeError as exc:
        raise ValueError("Non-text file absent from explicit allowlist: " + path) from exc


def git(repo, *args):
    return subprocess.check_output(["git", "-C", str(repo), *args])


def read_objects(repo, ids):
    names = list(dict.fromkeys(ids))
    batch = subprocess.run(
        ["git", "-C", str(repo), "cat-file", "--batch"],
        input=("\n".join(names) + "\n").encode(),
        capture_output=True,
        check=True,
    ).stdout
    cursor = 0
    objects = {}
    for oid in names:
        end = batch.index(b"\n", cursor)
        header = batch[cursor:end].split()
        if len(header) != 3 or header[0].decode() != oid:
            raise ValueError("Unexpected Git batch response")
        size = int(header[2])
        data = batch[end + 1 : end + 1 + size]
        if len(data) != size:
            raise ValueError("Truncated Git object")
        objects[oid] = (header[1].decode(), data)
        cursor = end + size + 2
    return objects


def audit_repository(repo):
    manifest = json.loads((repo / "assets/manifest.json").read_text(encoding="utf-8"))
    policy = json.loads((repo / "config/binary_allowlist.json").read_text(encoding="utf-8"))
    payloads = {a["sha1"] for a in manifest["assets"]} | {a["sha1"] for a in manifest["images"]}
    derived = repo / "config/audio_driver_payloads.json"
    if derived.is_file():
        payloads.update(a["sha1"] for a in json.loads(derived.read_text())["assets"])
    records = git(repo, "rev-list", "--objects", "--all", "HEAD").decode().splitlines()
    names = {}
    for record in records:
        oid, _, path = record.partition(" ")
        names.setdefault(oid, set())
        if path:
            names[oid].add(path)
    refs = git(repo, "for-each-ref", "--format=%(objectname)").decode().splitlines()
    index = git(repo, "ls-files", "-s", "-z").decode().split("\0")
    for record in index:
        if not record:
            continue
        info, path = record.split("\t", 1)
        names.setdefault(info.split()[1], set()).add(path)
    objects = read_objects(repo, [*names, *refs])
    roots = {data.splitlines()[0].split()[1].decode() for kind, data in objects.values() if kind == "commit"}
    for oid in refs:
        while objects[oid][0] == "tag":
            oid = objects[oid][1].splitlines()[0].split()[1].decode()
        if objects[oid][0] == "tree":
            roots.add(oid)
    # rev-list chooses just one name per blob. Inspect every distinct root
    # tree too, so a .bin renamed to .txt (or deleted) cannot hide its old path.
    for tree in roots:
        for record in git(repo, "ls-tree", "-r", "-z", tree).decode().split("\0"):
            if not record:
                continue
            info, path = record.split("\t", 1)
            mode, kind, oid = info.split()
            if kind == "blob":
                names.setdefault(oid, set()).add(path)
    checked = aliases = 0
    for oid, (kind, data) in objects.items():
        if kind != "blob":
            continue
        paths = names.get(oid) or {"<unpathed-blob>"}
        for path in paths:
            validate_blob(
                data,
                payloads,
                policy["files"],
                path,
                binary_suffixes=set(policy.get("binary_suffixes", BINARY_SUFFIXES)),
                forbidden_prefixes=policy.get("forbidden_prefixes", []),
            )
            aliases += 1
        checked += 1
    return {"blobs": checked, "historical_paths": aliases, "root_trees": len(roots)}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args(argv)
    result = audit_repository(args.root.resolve())
    print(
        "[OK] Private-data audit: "
        + str(result["blobs"])
        + " blobs, "
        + str(result["historical_paths"])
        + " historical paths; no private payloads"
    )
    return 0

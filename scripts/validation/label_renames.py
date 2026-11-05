"""Validate reviewed, physically scoped symbol migrations against Git source."""

from collections import defaultdict
from functools import lru_cache
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import tarfile

from scripts.build.project import ROOT
from scripts.validation.semantic_labels import INDEX, source_moves
from scripts.validation.semantic_labels import profile_maps as semantic_maps
from scripts.validation.semantic_labels import validate as validate_semantics

REGISTRY = "config/reconstruction/label_renames.json"
POLICY = "config/reconstruction/relocation.json"
OLD = re.compile(r"sub_[0-9A-Fa-f]+(?:_[A-Za-z_0-9]+)?$")
NAME = re.compile(r"[A-Za-z_][A-Za-z_0-9]*$")
DEFINITION = re.compile(r"^\s*(sub_[0-9A-Fa-f]+(?:_[A-Za-z_0-9]+)?)\s*:")
LABEL = re.compile(r"^\s*([A-Za-z_][A-Za-z_0-9]*)\s*:")


def read(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise ValueError("Missing or escaping label-migration source: " + name)
    return json.loads(path.read_text(encoding="utf-8"))


@lru_cache(maxsize=8)
def historical_scope(root, revision):
    """Read the original complete definition set; never trust a reduced registry."""
    subprocess.run(
        ["git", "merge-base", "--is-ancestor", revision, "HEAD"],
        cwd=root,
        check=True,
        capture_output=True,
    )
    payload = subprocess.check_output(["git", "archive", "--format=tar", revision, "src", POLICY], cwd=root)
    definitions = []
    policy = None
    with tarfile.open(fileobj=io.BytesIO(payload), mode="r:") as archive:
        for member in archive:
            if not member.isfile():
                continue
            stream = archive.extractfile(member)
            text = stream.read().decode("utf-8")
            if member.name == POLICY:
                policy = json.loads(text)
            if member.name.startswith("src/") and Path(member.name).suffix.lower() in (".s", ".inc", ".asm"):
                for number, line in enumerate(text.splitlines(), 1):
                    match = DEFINITION.match(line)
                    if match:
                        definitions.append((member.name, number, match[1]))
    if not definitions or policy is None:
        raise ValueError("Migration baseline has no complete address-named source scope")
    profiles = defaultdict(set)
    for profile, engine in policy["engines"].items():
        for name in engine["sources"]:
            profiles[name].add(profile)
    return tuple(sorted(definitions)), dict(profiles)


def validate_registry(root=ROOT, registry=None):
    root = Path(root).resolve()
    value = read(root, REGISTRY) if registry is None else registry
    if (
        not isinstance(value, dict)
        or not re.fullmatch(r"[0-9a-f]{40}", value.get("upstream_commit", ""))
        or not isinstance(value.get("note"), str)
        or not value["note"].strip()
        or not isinstance(value.get("renames"), list)
    ):
        raise ValueError("Invalid label rename registry identity")
    if value.get("schema_version") == 1 and value["renames"] == []:
        return value
    if (
        value.get("schema_version") != 2
        or value.get("state") != "complete"
        or not re.fullmatch(r"[0-9a-f]{40}", value.get("baseline_commit", ""))
        or type(value.get("target_count")) is not int
        or value["target_count"] <= 0
    ):
        raise ValueError("A nonempty migration needs a complete version-two source binding")
    original, original_profiles = historical_scope(str(root), value["baseline_commit"])
    original_ids = [path + ":" + str(line) + ":" + name for path, line, name in original]
    scope_hash = hashlib.sha256("\n".join(original_ids).encode()).hexdigest()
    if value["target_count"] != len(original) or value.get("original_scope_sha256") != scope_hash:
        raise ValueError("Label migration changed or reduced the historical physical scope")
    if len(value["renames"]) != len(original):
        raise ValueError("Label migration omits or duplicates an original definition")
    policy = read(root, POLICY)
    moves = source_moves(root)
    profiles = defaultdict(set)
    for profile, engine in policy["engines"].items():
        for name in engine["sources"]:
            profiles[name].add(profile)
    original_set = set(original)
    seen = set()
    proposed = set()
    expected_definitions = {}
    for row in value["renames"]:
        if not isinstance(row, dict):
            raise ValueError("A rename must be a physical definition record")
        path, line, old, new = (row.get(key) for key in ("source", "original_line", "old", "new"))
        if (
            not isinstance(path, str)
            or type(line) is not int
            or not isinstance(old, str)
            or not OLD.fullmatch(old)
            or not isinstance(new, str)
            or not NAME.fullmatch(new)
            or OLD.fullmatch(new)
            or not isinstance(row.get("meaning"), str)
            or not row["meaning"].strip()
        ):
            raise ValueError("Invalid reviewed label mapping")
        identity = path, line, old
        if identity not in original_set or identity in seen:
            raise ValueError("Rename is not a unique original physical definition")
        seen.add(identity)
        expected_profiles = sorted(original_profiles.get(path, set()))
        if (
            not expected_profiles
            or row.get("profiles") != expected_profiles
            or profiles[moves.get(path, path)] != set(expected_profiles)
        ):
            raise ValueError("Rename compilation scope differs from its historical source")
        for profile in expected_profiles:
            key = profile, new.lower()
            if key in proposed:
                raise ValueError("Proposed label collides in one compilation namespace")
            proposed.add(key)
            expected_definitions[key] = moves.get(path, path)
    if seen != original_set:
        raise ValueError("Label migration lacks an original physical identity")
    old_tokens = re.compile(r"\b(?:" + "|".join(re.escape(r["old"]) for r in value["renames"]) + r")\b", re.I)
    actual_definitions = defaultdict(list)
    for path, applicable in profiles.items():
        source = (root / path).resolve()
        if not source.is_relative_to(root) or not source.is_file():
            raise ValueError("Migration source leaves the project or is missing: " + path)
        text = source.read_text(encoding="utf-8")
        if old_tokens.search(text):
            raise ValueError("Original migrated symbol still occurs in assembly: " + path)
        for line in text.splitlines():
            match = LABEL.match(line)
            if match:
                for profile in applicable:
                    key = profile, match[1].lower()
                    if key in expected_definitions:
                        actual_definitions[key].append(path)
    if set(actual_definitions) != set(expected_definitions) or any(
        actual_definitions[key] != [path] for key, path in expected_definitions.items()
    ):
        raise ValueError("Renamed definitions are missing, duplicated or in the wrong source")
    if value.get("continuation") is not None or (root / INDEX).exists():
        if value.get("continuation") != INDEX:
            raise ValueError("Semantic continuation must belong to the canonical label registry")
        value = {**value, "semantic_migration": validate_semantics(root)}
    return value


def profile_maps(registry):
    """One simultaneous mapping per assembler namespace, including duplicate spellings."""
    result = defaultdict(dict)
    for row in registry["renames"]:
        for profile in row["profiles"]:
            if row["old"] in result[profile]:
                raise ValueError("Original spelling is ambiguous in one compilation namespace")
            result[profile][row["old"]] = row["new"]
    if "semantic_migration" in registry:
        for profile, mappings in semantic_maps(registry["semantic_migration"]).items():
            for old, new in mappings.items():
                if old in result[profile] and result[profile][old] != new:
                    raise ValueError("Semantic continuation conflicts with the completed procedure migration")
                result[profile][old] = new
    return dict(result)

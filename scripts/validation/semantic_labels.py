"""Validate an incremental semantic-label migration against immutable Git source."""

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
from scripts.validation.numeric_operands import code_part
from scripts.validation.semantic_label_edits import apply_edits, code_fingerprint, code_lines

INDEX = "config/reconstruction/semantic_labels.json"
SHARDS = "config/reconstruction/semantic_labels"
PROFILES = frozenset(("s3-us", "s3-eu", "s3-jp", "sk"))
NAME = re.compile(r"\.?[A-Za-z_][A-Za-z_0-9]*$")
DECLARATION = re.compile(r"^\s*([A-Za-z_.][A-Za-z_0-9.]*)\s*(?::|\s+(?:equ|set|equs|=)\s+)", re.I)
FAMILIES = (
    "AniRaw ChildObj ChildObjDat ChildObjDat3 ChildSpriteDat Frame Knuckles_Load_PLC "
    "LevelList Map MapPtr Obj ObjDat ObjDat2 ObjDat3 ObjSlot Obj_Competition "
    "Obj_Continue_EggRobo Obj_SStage Obj_SphereResults Obj_Sphere_Results "
    "Obj_SpheresTitle Pal RawAni SSMagic_TestLoc SStage_PLCLoad VRAMDatList "
    "byte dword loc locret off unk word"
).split()
ADDRESS = re.compile(r"^\.?(?:" + "|".join(map(re.escape, FAMILIES)) + r")_([0-9A-Fa-f]+)(?:_[A-Za-z_0-9]+)?$")
RAM = re.compile(r"_(?:unk|temp)[0-9A-Fa-f]+(?:_[A-Za-z_0-9]+)?$")
NUMERIC = re.compile(r"\._?[0-9]+$")


def inherited(name):
    match = ADDRESS.fullmatch(name)
    # These inherited palette names describe fading, rather than ROM addresses.
    return bool(
        (match and name not in {"Pal_fade_delay", "Pal_fade_delay2"}) or RAM.fullmatch(name) or NUMERIC.fullmatch(name)
    )


def declarations(text):
    result, scope = [], ""
    for number, line in enumerate(text.splitlines(), 1):
        match = DECLARATION.match(code_part(line))
        if not match:
            continue
        name = match[1]
        if not name.startswith("."):
            scope = name
        result.append(
            {"line": number, "name": name, "scope": scope, "qualified": scope + name if name.startswith(".") else name}
        )
    return result


def scope_hash(identities):
    return hashlib.sha256("\n".join(sorted(identities)).encode()).hexdigest()


def destination_hash(rows):
    return scope_hash(
        row["source"] + ":" + str(row["original_line"]) + ":" + row["old"] + "\0" + row["new"] for row in rows
    )


def read(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise ValueError("Missing or escaping semantic-label registry: " + name)
    return json.loads(path.read_text(encoding="utf-8"))


@lru_cache(maxsize=4)
def historical_texts(root, revision):
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Semantic labels require a full historical Git identity")
    subprocess.run(["git", "merge-base", "--is-ancestor", revision, "HEAD"], cwd=root, check=True, capture_output=True)
    payload = subprocess.check_output(["git", "archive", "--format=tar", revision, "src"], cwd=root)
    sources = {}
    with tarfile.open(fileobj=io.BytesIO(payload), mode="r:") as archive:
        for member in archive:
            if not member.isfile() or Path(member.name).suffix.lower() not in (".s", ".inc", ".asm"):
                continue
            sources[member.name] = archive.extractfile(member).read().decode("utf-8")
    return sources


@lru_cache(maxsize=4)
def historical_source(root, revision):
    sources, targets = {}, {}
    for name, text in historical_texts(root, revision).items():
        rows = declarations(text)
        sources[name] = rows
        for row in rows:
            if inherited(row["name"]):
                identity = name + ":" + str(row["line"]) + ":" + row["name"]
                targets[identity] = {"source": name, **row}
    if not targets:
        raise ValueError("Semantic baseline has no inherited physical labels")
    return sources, targets


def _legacy_edits(originals, previous, current, policy):
    """Project a change in a legacy destination onto the immutable source tokens."""

    def identities(rows):
        return {(row["source"], row["original_line"], row["old"]): row for row in rows}

    before = identities(previous)
    after = identities(current)
    if set(before) != set(after) or len(before) != len(previous) or len(after) != len(current):
        raise ValueError("Legacy registry no longer has its frozen physical identities")
    changed = {key for key in before if before[key]["new"] != after[key]["new"]}
    if not changed:
        return {}, {}
    engine_files = defaultdict(set)
    for profile, engine in policy["engines"].items():
        for path in engine["sources"]:
            engine_files[path].add(profile)
    by_name = defaultdict(list)
    definitions = defaultdict(dict)
    for key, row in before.items():
        name = row["new"]
        by_name[name.casefold()].append(key)
        if key not in changed:
            continue
        path = row["source"]
        if name in definitions[path] or after[key]["profiles"] != row["profiles"]:
            raise ValueError("Legacy change is ambiguous or changes profiles")
        definitions[path][name] = after[key]["new"]
    affected = {before[key]["new"].casefold() for key in changed}
    edits = defaultdict(list)
    found = set()
    for path, original in originals.items():
        applicable = engine_files.get(path, set())
        if not applicable:
            continue
        for number, (_, tokens) in enumerate(code_lines(original), 1):
            for index, token in enumerate(tokens):
                if token.kind != "symbol":
                    continue
                name, dot, suffix = token.text.partition(".")
                if name.casefold() not in affected:
                    continue
                matches = [key for key in by_name[name.casefold()] if applicable.intersection(before[key]["profiles"])]
                if not matches:
                    continue
                replacements = {after[key]["new"] if key in changed else name for key in matches}
                if len(replacements) != 1:
                    raise ValueError("Legacy token has incompatible profile destinations: " + path + ":" + token.text)
                new = replacements.pop()
                if new == name:
                    continue
                edits[path].append({"code_line": number, "token": index, "old": token.text, "new": new + dot + suffix})
                if index == 0 and not dot and len(tokens) > 1 and tokens[1].text == ":":
                    found.update(key for key in matches if key[0] == path and key in changed)
    if found != changed:
        raise ValueError("A legacy destination does not resolve to its frozen physical source")
    return dict(edits), dict(definitions)


def validate(root=ROOT, index=None):
    """Require an exact partition and a complete mapping for every applied packet."""
    root = Path(root).resolve()
    value = read(root, INDEX) if index is None else index
    if (
        not isinstance(value, dict)
        or value.get("schema_version") != 1
        or value.get("state") not in {"in-progress", "complete"}
    ):
        raise ValueError("Invalid incremental semantic-label registry")
    if not isinstance(value.get("packets"), list) or not value["packets"]:
        raise ValueError("Semantic migration has no subsystem partition")
    sources, targets = historical_source(str(root), value.get("baseline_commit", ""))
    if (
        type(value.get("target_count")) is not int
        or value["target_count"] != len(targets)
        or value.get("scope_sha256") != scope_hash(targets)
    ):
        raise ValueError("Semantic migration reduced or changed its historical scope")
    by_path = defaultdict(set)
    for identity, row in targets.items():
        by_path[row["source"]].add(identity)
    seen_ids, seen_files, seen_packets, shard_names = set(), set(), set(), set()
    profiles, mappings, transforms = {}, {}, {}
    edited_coordinates = set()
    applied_count = 0
    for packet in value["packets"]:
        key = packet.get("id", "")
        if (
            not re.fullmatch(r"[0-9][A-Za-z_0-9-]*", key)
            or key in seen_packets
            or packet.get("state") not in {"pending", "applied"}
        ):
            raise ValueError("Invalid or duplicate semantic subsystem")
        seen_packets.add(key)
        shard = SHARDS + "/" + key + ".json"
        if packet.get("registry") != shard or not isinstance(packet.get("sources"), list) or not packet["sources"]:
            raise ValueError("Subsystem registry must have one owned shard and source list")
        if not re.fullmatch(r"[0-9a-f]{64}", packet.get("destination_sha256", "")):
            raise ValueError("Subsystem lacks its frozen reviewed destination binding")
        owned = set()
        for source in packet["sources"]:
            path, applicable = source.get("path"), source.get("profiles")
            if path not in by_path or path in seen_files or not isinstance(applicable, list) or not applicable:
                raise ValueError("Subsystem source is missing, foreign or multiply owned")
            if any(p not in PROFILES for p in applicable) or applicable != sorted(set(applicable)):
                raise ValueError("Invalid semantic source compilation profiles")
            seen_files.add(path)
            profiles[path] = applicable
            owned.update(by_path[path])
        if (
            type(packet.get("target_count")) is not int
            or packet["target_count"] != len(owned)
            or packet.get("scope_sha256") != scope_hash(owned)
        ):
            raise ValueError("Subsystem omits or changes its historical physical targets")
        seen_ids.update(owned)
        if packet["state"] == "pending":
            if (root / shard).exists():
                raise ValueError("Pending subsystem already has an unapproved mapping shard")
            continue
        shard_names.add(shard)
        document = read(root, shard)
        if (
            document.get("schema_version") != 1
            or document.get("packet") != key
            or not isinstance(document.get("mappings"), list)
        ):
            raise ValueError("Invalid subsystem mapping shard")
        actual = set()
        for row in document["mappings"]:
            if not isinstance(row, dict):
                raise ValueError("A semantic mapping must be a physical record")
            path, number, old, new = (row.get(k) for k in ("source", "original_line", "old", "new"))
            if not isinstance(path, str) or type(number) is not int or not isinstance(old, str):
                raise ValueError("Invalid semantic mapping identity")
            identity = path + ":" + str(number) + ":" + old
            if identity not in owned or identity in actual:
                raise ValueError("Mapping is foreign, duplicated or belongs to another subsystem")
            if (
                not isinstance(new, str)
                or not NAME.fullmatch(new)
                or inherited(new)
                or new.startswith(".") != old.startswith(".")
            ):
                raise ValueError("Semantic name is invalid or changes local/global scope")
            if (
                row.get("profiles") != profiles[path]
                or not isinstance(row.get("meaning"), str)
                or not row["meaning"].strip()
            ):
                raise ValueError("Semantic mapping lacks its profiles or reviewed meaning")
            actual.add(identity)
            mappings[identity] = {
                **row,
                "original_scope": targets[identity]["scope"],
                "qualified_old": targets[identity]["qualified"],
            }
        if actual != owned:
            raise ValueError("Applied subsystem has missing physical mappings")
        if destination_hash(document["mappings"]) != packet["destination_sha256"]:
            raise ValueError("Applied subsystem changed its reviewed semantic destinations")
        if not isinstance(document.get("source_edits"), list) or not document["source_edits"]:
            raise ValueError("Applied subsystem lacks its exact source-token edits")
        transforms[key] = []
        seen_consumers = set()
        for consumer in document["source_edits"]:
            path = consumer.get("source")
            if (
                path not in sources
                or path in seen_consumers
                or not isinstance(consumer.get("tokens"), list)
                or not consumer["tokens"]
            ):
                raise ValueError("Invalid or duplicate semantic edit consumer")
            seen_consumers.add(path)
            explicit = []
            for entry in consumer["tokens"]:
                if not isinstance(entry, list) or len(entry) != 4:
                    raise ValueError("Semantic edit needs code-line, token, mapping index and symbol suffix")
                line, token, mapping, suffix = entry
                if (
                    type(line) is not int
                    or type(token) is not int
                    or type(mapping) is not int
                    or not 0 <= mapping < len(document["mappings"])
                    or not isinstance(suffix, str)
                ):
                    raise ValueError("Invalid semantic source-token edit")
                coordinate = path, line, token
                if coordinate in edited_coordinates:
                    raise ValueError("Semantic source-token edits overlap")
                edited_coordinates.add(coordinate)
                selected = document["mappings"][mapping]
                if suffix not in ("", ".b", ".w", ".l", ".B", ".W", ".L"):
                    if (
                        not suffix.startswith(".")
                        or not NAME.fullmatch(suffix)
                        or selected["old"].startswith(".")
                        or not any(
                            row["scope"] == selected["old"] and row["name"] == suffix
                            for row in sources[selected["source"]]
                        )
                    ):
                        raise ValueError("Semantic edit does not reference a local of the selected label")
                explicit.append(
                    {
                        "code_line": line,
                        "token": token,
                        "old": selected["old"] + suffix,
                        "new": selected["new"] + suffix,
                    }
                )
            transforms[key].append({"source": path, "edits": explicit})
        applied_count += len(actual)
    if seen_ids != set(targets) or seen_files != set(by_path):
        raise ValueError("Subsystem partition omits historical source or physical targets")
    actual_shards = (
        {p.relative_to(root).as_posix() for p in (root / SHARDS).rglob("*.json")} if (root / SHARDS).exists() else set()
    )
    if actual_shards != shard_names:
        raise ValueError("Unowned or missing semantic mapping shard")
    if type(value.get("applied_targets")) is not int or value["applied_targets"] != applied_count:
        raise ValueError("Semantic migration progress is stale")
    if (value["state"] == "complete") != (applied_count == len(targets)):
        raise ValueError("Semantic completion disagrees with applied physical scope")
    order = value.get("applied_order")
    if not isinstance(order, list) or len(order) != len(set(order)) or set(order) != set(transforms):
        raise ValueError("Semantic edit order omits or duplicates an applied subsystem")
    originals = historical_texts(str(root), value["baseline_commit"])
    views = defaultdict(list)
    legacy_definitions = {}
    # The semantic baseline already contains the original reviewed destinations
    # of the earlier procedure migration. Undo later short names at exact tokens.
    from scripts.validation.label_renames import POLICY, REGISTRY

    if (root / REGISTRY).is_file():
        earlier_registry = json.loads(
            subprocess.check_output(["git", "show", value["baseline_commit"] + ":" + REGISTRY], cwd=root)
        )
        current_registry = read(root, REGISTRY)
        legacy_views, legacy_definitions = _legacy_edits(
            originals, earlier_registry["renames"], current_registry["renames"], read(root, POLICY)
        )
        for path, edits in legacy_views.items():
            if any((path, row["code_line"], row["token"]) in edited_coordinates for row in edits):
                raise ValueError("Legacy and semantic source-token edits overlap: " + path)
            views[path].append(edits)
    for key in order:
        for consumer in transforms[key]:
            views[consumer["source"]].append(consumer["edits"])
    result = {
        "index": value,
        "source_views": dict(views),
        "target_count": len(targets),
        "applied_targets": applied_count,
    }

    # Physical declaration order survives inserted comments. Do not bind current
    # locations to old line numbers or accept a renamed pending definition.
    records = []
    candidates = defaultdict(set)
    for path, original in sources.items():
        source = (root / path).resolve()
        if not source.is_relative_to(root) or not source.is_file():
            raise ValueError("Missing or escaping semantic source: " + path)
        text = source.read_text(encoding="utf-8")
        current = declarations(text)
        if len(current) != len(original):
            raise ValueError("Semantic migration added or removed declarations: " + path)
        scope = ""
        earlier_names = legacy_definitions.get(path, {})
        for before, after in zip(original, current):
            identity = path + ":" + str(before["line"]) + ":" + before["name"]
            mapping = mappings.get(identity)
            expected = mapping["new"] if mapping else earlier_names.get(before["name"], before["name"])
            if after["name"] != expected:
                raise ValueError("Unregistered or missing semantic declaration: " + identity)
            if not expected.startswith("."):
                scope = expected
            qualified = scope + expected if expected.startswith(".") else expected
            for profile in profiles.get(path, []):
                candidates[profile, qualified.lower()].add((path, after["line"]))
            if mapping:
                records.append({**mapping, "qualified_new": qualified, "current_line": after["line"]})
        restored = original_view(path, text, result)
        if restored != originals[path] and code_fingerprint(restored) != code_fingerprint(originals[path]):
            raise ValueError("Unregistered code, literal or context change in semantic source: " + path)
    for row in records:
        for profile in row["profiles"]:
            if len(candidates[profile, row["qualified_new"].lower()]) != 1:
                raise ValueError("Semantic destination collides in its compilation scope")
    return {**result, "mappings": records}


def original_view(path, text, result):
    """Reverse only registered tokens; retain a strict historical statement view."""
    for edits in reversed(result["source_views"].get(path, [])):
        text = apply_edits(text, [{**row, "old": row["new"], "new": row["old"]} for row in edits])
    return text


def profile_maps(result):
    """Use fully qualified local names for historical symbol comparisons."""
    maps = defaultdict(dict)
    for row in result["mappings"]:
        for profile in row["profiles"]:
            old, new = row["qualified_old"], row["qualified_new"]
            if old in maps[profile] and maps[profile][old] != new:
                raise ValueError("A historical symbol has conflicting semantic destinations")
            maps[profile][old] = new
    return dict(maps)

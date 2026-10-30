"""Extract and validate private FM/PSG payloads from original driver containers."""

import argparse
from collections import Counter
import hashlib
import re
from pathlib import PurePosixPath

from scripts.authoring.kosinski import decode_stream
from scripts.build.project import ROOT, atomic, inside, load, profiles, source_fingerprint, source_names
from scripts.validation.audio_source import validate_audio_source
from scripts.validation.audio_storage import profile_uses
from scripts.validation.symbols import parse_symbols

LABELS = (
    {"z80_UniVoiceBank"}
    | {"ModEnv_" + format(i, "02X") for i in range(8)}
    | {"VolEnv_" + format(i, "02X") for i in range(1, 40)}
)


def resolve_contract(contract, source_assets, engines):
    if (
        contract.get("schema_version") != 1
        or contract.get("address_space") != "z80-driver-ram"
        or contract.get("virtual_base") != 0x1300
        or contract.get("address_limit") != 0x1C00
    ):
        raise ValueError("Unsupported driver payload address space")
    if set(contract["containers"]) != set(engines):
        raise ValueError("Driver container ownership is incomplete")
    for owner, container in contract["containers"].items():
        source = source_assets.get(container["asset"])
        if not source or source["image"] != owner or container["codec"] not in ("raw", "kos"):
            raise ValueError("Driver container has no matching ROM asset")
        if (
            any(type(container.get(k)) is not int for k in ("decoded_size", "slot_capacity"))
            or not 0 < container["decoded_size"] <= 0x900
            or not 0 < source["size"] <= container["slot_capacity"] <= 0x8000
        ):
            raise ValueError("Driver container exceeds its physical or virtual capacity")
        if not re.fullmatch(r"[0-9a-f]{64}", container["decoded_sha256"]):
            raise ValueError("Driver container lacks a decoded content hash")
    paths, coverage, result = set(), set(), []
    for row in contract["assets"]:
        relative = PurePosixPath(row["path"])
        if relative.is_absolute() or ".." in relative.parts or "\\" in row["path"] or ":" in row["path"]:
            raise ValueError("Driver payload path leaves its private data root")
        inside(row["path"], ROOT / "data")
        if not row["path"].startswith("Sound/Driver/Payloads/") or row["path"] in paths:
            raise ValueError("Duplicate or invalid driver payload path")
        paths.add(row["path"])
        label = row["label"]
        kind = (
            "fm-voice-bank"
            if label == "z80_UniVoiceBank"
            else "modulation-envelope"
            if label.startswith("ModEnv_")
            else "volume-envelope"
        )
        if label not in LABELS or row["format"] != kind or not row["origins"]:
            raise ValueError("Unknown driver payload format or binding")
        if not re.fullmatch(r"[0-9a-f]{40}", row["sha1"]) or not re.fullmatch(r"[0-9a-f]{64}", row["sha256"]):
            raise ValueError("Driver payload lacks content hashes")
        if isinstance(row["size"], bool) or not isinstance(row["size"], int) or row["size"] <= 0:
            raise ValueError("Invalid driver payload size")
        if kind == "fm-voice-bank" and row["size"] != 35 * 25:
            raise ValueError("The universal FM bank needs 35 complete voices")
        for owner, offset in row["origins"].items():
            key = owner, label
            if owner not in engines or key in coverage:
                raise ValueError("Duplicate or unsupported driver ABI binding")
            if (
                isinstance(offset, bool)
                or not isinstance(offset, int)
                or offset < 0
                or offset + row["size"] > contract["containers"][owner]["decoded_size"]
            ):
                raise ValueError("Driver payload leaves its decoded container")
            coverage.add(key)
        result.append(row)
    if coverage != {(owner, label) for owner in engines for label in LABELS}:
        raise ValueError("Driver payload catalog omits a label or engine")
    for owner in engines:
        ranges = sorted((r["origins"][owner], r["origins"][owner] + r["size"]) for r in result if owner in r["origins"])
        if any(b[0] < a[1] for a, b in zip(ranges, ranges[1:])):
            raise ValueError("Driver payload allocations overlap")
    return result


def validate_write(row, owner, target_profile, target_abi, payload, engines, registry):
    if (
        target_profile not in registry
        or owner not in row["origins"]
        or owner not in engines
        or target_abi != engines[owner]["abi"]
        or not profile_uses(target_profile, owner, registry)
    ):
        raise ValueError("Driver payload target has another audio ABI")
    if not payload or len(payload) > row["size"] or row["format"] == "fm-voice-bank" and len(payload) != row["size"]:
        raise ValueError("Driver payload write exceeds its fixed allocation")


def _hashes(data, row):
    return (
        len(data) == row["size"]
        and hashlib.sha1(data).hexdigest() == row["sha1"]
        and ("sha256" not in row or hashlib.sha256(data).hexdigest() == row["sha256"])
    )


def decoded_containers(contract, source_assets):
    result = {}
    for owner, row in contract["containers"].items():
        source = source_assets[row["asset"]]
        packed = inside(row["asset"], ROOT / "data").read_bytes()
        if not _hashes(packed, source):
            raise ValueError("Driver container does not match its ROM extraction")
        if row["codec"] == "kos":
            raw, consumed = decode_stream(packed, max_output=row["decoded_size"])
            if consumed != len(packed):
                raise ValueError("Driver compressed container has unchecked trailing bytes")
        else:
            raw = packed
        if len(raw) != row["decoded_size"] or hashlib.sha256(raw).hexdigest() != row["decoded_sha256"]:
            raise ValueError("Decoded driver container differs from its identity")
        result[owner] = raw
    return result


def check(*, split=False, built=False, catalog_only=False):
    source_assets = {r["path"]: r for r in load("assets/manifest.json")["assets"]}
    engines = load("config/audio_streams.json")["engines"]
    contract = load("config/audio_driver_payloads.json")
    rows = resolve_contract(contract, source_assets, engines)
    includes = Counter()
    for name in source_names():
        text = (ROOT / name).read_text(encoding="utf-8")
        validate_audio_source(text, name)
        includes.update(re.findall(r'\bbinclude\s+"data/(Sound/Driver/Payloads/[^"\r\n]+)"', text, re.I))
    if includes != Counter(row["path"] for row in rows):
        raise ValueError("Driver source includes omit or duplicate a payload owner")
    if not catalog_only:
        containers = decoded_containers(contract, source_assets)
        prepared = []
        for row in rows:
            values = [containers[owner][offset : offset + row["size"]] for owner, offset in row["origins"].items()]
            if any(not _hashes(value, row) for value in values):
                raise ValueError("Driver payload differs between its declared ROM origins")
            prepared.append((inside("data/" + row["path"]), values[0]))
    if built:
        binding = load("build/source_binding.json")
        registry = profiles()
        if (
            binding["source_sha256"] != source_fingerprint()
            or not binding["byte_identity_checked"]
            or set(binding["profiles"]) != set(registry)
        ):
            raise ValueError("Driver payload assembly binding is stale")
        for profile, revision in registry.items():
            if "compose" in revision:
                continue
            symbols = parse_symbols((ROOT / "build/objects" / profile / "main.lst").read_text(errors="replace"))
            for row in rows:
                for owner, offset in row["origins"].items():
                    if (
                        profile_uses(profile, owner, registry)
                        and symbols[row["label"]] != contract["virtual_base"] + offset
                    ):
                        raise ValueError("Driver payload virtual address differs from independent AS output")
            if symbols["zDataStart"] != contract["address_limit"]:
                raise ValueError("Driver payload RAM boundary differs from AS output")
    if not catalog_only:
        if split:
            for path, data in prepared:
                atomic(path, data)
        else:
            for path, data in prepared:
                if path.read_bytes() != data:
                    raise ValueError("Private driver payload does not match its ROM origins")
    scope = (
        "driver payload contracts; source includes, capacities and ABIs checked"
        if catalog_only
        else "private driver payloads; both ROM origins, capacities and ABIs checked"
    )
    print("[OK] " + str(len(rows)) + " " + scope)
    return rows


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("split", "check"))
    parser.add_argument("--built", action="store_true")
    parser.add_argument("--catalog-only", action="store_true")
    args = parser.parse_args(argv)
    if args.catalog_only and (args.command != "check" or args.built):
        parser.error("catalog-only cannot extract files or claim assembled bindings")
    check(split=args.command == "split", built=args.built, catalog_only=args.catalog_only)
    return 0

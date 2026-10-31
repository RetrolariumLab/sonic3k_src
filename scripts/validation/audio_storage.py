"""Check ROM-owned SMPS stream storage, target ABI and fixed allocation bounds."""

import argparse
from collections import Counter
import re
import subprocess

from scripts.build.project import ROOT, image_records, load, profiles, source_fingerprint
from scripts.validation.numeric_operands import code_part
from scripts.validation.audio_source import validate_audio_source
from scripts.validation.data_macros import definition_blocks
from scripts.validation.symbols import parse_symbols


def profile_uses(profile, owner, registry):
    row = registry[profile]
    if "compose" in row:
        return any(profile_uses(child, owner, registry) for child in row["compose"])
    return row["entry"] == registry[owner]["entry"]


def resolve_catalog(policy, assets, registry):
    if (
        policy.get("schema_version") != 1
        or policy.get("bank_bytes") != 32768
        or policy.get("window_base") != 32768
        or policy.get("address_space") != "z80-rom-window"
    ):
        raise ValueError("Unsupported audio address-space contract")
    streams = policy["streams"]
    if len({r["id"] for r in streams}) != len(streams) or len({r["asset"] for r in streams}) != len(streams):
        raise ValueError("Duplicate SMPS stream or storage owner")
    if {r["asset"] for r in streams} != {p for p in assets if p.startswith("Sound/SMPS/")}:
        raise ValueError("Audio catalog omits or invents stored streams")
    owners = {assets[r["asset"]]["image"] for r in streams}
    if owners != set(policy["engines"]):
        raise ValueError("Audio engine ownership is incomplete")
    for owner, engine in policy["engines"].items():
        if owner not in registry or "compose" in registry[owner]:
            raise ValueError("Audio storage needs a base image owner")
        expected = {key for key in registry if profile_uses(key, owner, registry)}
        if set(engine["profiles"]) != expected or len(engine["profiles"]) != len(expected) or not engine["abi"]:
            raise ValueError("Audio ABI applicability differs from profile composition")
    result = []
    symbols = set()
    for row in streams:
        asset = assets[row["asset"]]
        owner = asset["image"]
        offset, size = asset["offset"], asset["size"]
        if (
            not isinstance(offset, int)
            or not isinstance(size, int)
            or offset < 0
            or size <= 0
            or offset % 32768 + size > 32768
        ):
            raise ValueError("SMPS stream crosses a fixed Z80 bank window")
        if asset.get("format") not in ("smps3", "smps4"):
            raise ValueError("Missing SMPS dialect")
        key = (owner, row["base_symbol"])
        if key in symbols or not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", row["base_symbol"]):
            raise ValueError("Invalid or duplicate stream symbol owner")
        symbols.add(key)
        result.append(
            dict(
                row,
                image=owner,
                offset=offset,
                size=size,
                format=asset["format"],
                abi=policy["engines"][owner]["abi"],
                profiles=policy["engines"][owner]["profiles"],
                bank_base=offset // 32768 * 32768,
                bank_offset=offset % 32768,
                capacity=size,
            )
        )
    return result


def validate_write(stream, target_profile, target_abi, payload):
    """Validate before any write; storage remains within its original fixed slot."""
    if target_profile not in stream["profiles"] or target_abi != stream["abi"]:
        raise ValueError("SMPS target profile has another audio ABI")
    if not payload or len(payload) > stream["capacity"] or stream["bank_offset"] + len(payload) > 32768:
        raise ValueError("SMPS write exceeds its declared allocation or bank")


def validate_no_score_macros(text, path):
    """Current source needs driver code and extracted payloads, not score encoders."""
    if any(name.startswith("smps") for name, _, _, _ in definition_blocks(text)):
        raise ValueError("Score encoder macro remains in current source: " + path)


def check(built=False):
    assets = {r["path"]: r for r in load("assets/manifest.json")["assets"]}
    registry = profiles()
    streams = resolve_catalog(load("config/audio_streams.json"), assets, registry)
    files = (
        subprocess.check_output(
            ["git", "-C", str(ROOT), "ls-files", "-z", "--cached", "--others", "--exclude-standard"]
        )
        .decode()
        .split("\0")
    )
    includes = Counter()
    for name in files:
        if not name.endswith((".s", ".inc", ".asm")):
            continue
        if name.startswith(("Sound/Music/", "Sound/SFX/")) or name == "Sound/_smps2asm_inc.s":
            raise ValueError("Legacy score assembly remains in the final source")
        text = (ROOT / name).read_text(encoding="utf-8")
        validate_audio_source(text, name)
        validate_no_score_macros(text, name)
        for line in text.splitlines():
            for path in re.findall(r'\bbinclude\s+"data/(Sound/SMPS/[^\"]+)"', code_part(line), re.I):
                includes[path] += 1
    if includes != Counter(r["asset"] for r in streams):
        raise ValueError("SMPS source includes do not match catalog ownership")
    if built:
        binding = load("build/source_binding.json")
        if (
            binding["source_sha256"] != source_fingerprint()
            or not binding["byte_identity_checked"]
            or set(binding["profiles"]) != set(registry)
        ):
            raise ValueError("Audio assembly binding is stale")
        tables = {
            key: parse_symbols(
                (ROOT / "build/objects" / key / "main.lst").read_text(encoding="utf-8", errors="replace")
            )
            for key, p in registry.items()
            if "compose" not in p
        }
        for row in streams:
            for key in row["profiles"]:
                if key not in tables:
                    continue
                symbols = tables[key]
                if symbols[row["base_symbol"]] != row["offset"] or row["format"] != "smps" + str(
                    symbols["SonicDriverVer"]
                ):
                    raise ValueError("SMPS stream differs from the independently assembled address or driver dialect")
            image = image_records()[row["image"]]
            if row["offset"] + row["size"] > image["size"]:
                raise ValueError("Audio storage leaves its legal source image")
    print("[OK] " + str(len(streams)) + " ROM-owned SMPS streams; ABI and bank bounds checked")
    return streams


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", action="store_true")
    args = parser.parse_args(argv)
    check(args.built)
    return 0

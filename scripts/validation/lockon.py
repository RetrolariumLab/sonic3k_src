"""Prove every external S3 export against independently assembled source labels."""

import argparse
import re

from scripts.build.project import ROOT, image_records, load, sha, source_fingerprint
from scripts.validation.symbols import parse_symbols


def source_exports(text):
    return set(re.findall(r"^([A-Za-z_][A-Za-z_0-9]*):", text, re.MULTILINE))


def check_exports(contract, declared, internal, external, size):
    entries = contract["exports"]
    names = [row["external"] for row in entries]
    if len(names) != len(set(names)) or set(names) != declared:
        raise ValueError("Lock-on export registry is incomplete, duplicated, or stale")
    base = int(contract["base"], 0)
    for row in entries:
        name, target = row["external"], row["target"]
        if name not in external or target not in internal:
            raise ValueError("Missing source symbol for external export " + name)
        value = internal[target] + row.get("addend", 0)
        if not 0 <= value <= size:
            raise ValueError("External export leaves the second cartridge: " + name)
        if base + value != external[name]:
            raise ValueError("External export differs from S3 source: " + name)
    return len(entries)


def check_fixed(registry, symbols, profile=None):
    for item in registry["regions"]:
        if profile is not None and "profiles" in item and profile not in item["profiles"]:
            continue
        if "value" in item and symbols[item["symbol"]] != int(item["value"], 0):
            raise ValueError("Fixed comparison boundary moved: " + item["id"])
        for field in ("base", "end"):
            if field + "_symbol" in item and symbols[item[field + "_symbol"]] != int(item[field], 0):
                raise ValueError("Fixed interface moved: " + item["id"])
        if "owner" in item and symbols[item["owner"]] != int(item["base"], 0):
            raise ValueError("Hardware region moved: " + item["id"])
        if "tail_aligned_start" in item:
            end = symbols[item["tail_aligned_start"]] + symbols[item["tail_allocation"]]
            if end % item["window_bytes"]:
                raise ValueError("Z80 bank allocation lost its fixed window alignment")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.parse_args(argv)
    contract = load("config/reconstruction/lockon_abi.json")
    binding = load("build/source_binding.json")
    selected = [contract["external_profile"], *contract["second_cartridge_profiles"]]
    if binding["source_sha256"] != source_fingerprint() or not binding["byte_identity_checked"]:
        raise ValueError("Assembly evidence is stale or unverified; run make verify-all")
    if not set(selected) <= set(binding["profiles"]):
        raise ValueError("Assembly evidence lacks lock-on profiles; run make verify-all")
    images = image_records()
    values = {}
    for key in selected:
        image = images[key]
        data = (ROOT / "build/images" / (key + ".bin")).read_bytes()
        if len(data) != image["size"] or sha(data) != image["sha256"]:
            raise ValueError("Assembly image no longer matches its evidence: " + key)
        path = ROOT / "build/objects" / key / "main.lst"
        values[key] = parse_symbols(path.read_text(encoding="utf-8", errors="replace"))
    for key in selected:
        check_fixed(load("config/reconstruction/fixed_regions.json"), values[key], profile=key)
    declared = source_exports((ROOT / contract["pointer_source"]).read_text(encoding="utf-8"))
    for key in contract["second_cartridge_profiles"]:
        count = check_exports(
            contract, declared, values[key], values[contract["external_profile"]], images[key]["size"]
        )
        print("[OK] " + key + ": " + str(count) + " lock-on exports equal S3 source + " + contract["base"])
    return 0

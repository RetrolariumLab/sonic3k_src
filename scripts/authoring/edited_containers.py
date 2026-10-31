"""Prove bounded palette edits reach actual ROMs and change exactly their owned bytes."""

import argparse
from copy import deepcopy
import json
from pathlib import Path
import tempfile

from scripts.authoring import content_profiles
from scripts.authoring.formats_workflow import load_catalog, tooling_fingerprint
from scripts.build.pipeline import build_selected
from scripts.build.project import (
    ROOT,
    atomic,
    image_records,
    inside,
    load,
    profiles,
    read_reference,
    sha,
    source_fingerprint,
    source_names,
)
from scripts.build.source_inputs import stage
from scripts.validation.symbols import parse_symbols

CONFIG = "config/authoring/edit_probes.json"
REPORT = "build/authoring/edited-containers.json"


def save(report):
    atomic(ROOT / REPORT, (json.dumps(report, indent=2) + "\n").encode())


def changed_ranges(before, after):
    if len(before) != len(after):
        raise ValueError("Edited image changes its preservation allocation")
    result = []
    start = None
    for offset, (left, right) in enumerate(zip(before, after)):
        if left != right and start is None:
            start = offset
        elif left == right and start is not None:
            result.append({"start": start, "end": offset})
            start = None
    if start is not None:
        result.append({"start": start, "end": len(before)})
    return result


def probe_definitions(catalog, assets):
    config = load(CONFIG)
    probes = config.get("probes", [])
    if config.get("schema_version") != 1 or len(probes) != 2 or {row["profile"] for row in probes} != {"s3-us", "sk"}:
        raise ValueError("Edit proof requires one independently owned palette from each engine")
    for row in probes:
        if set(row) != {"asset", "profile", "color", "channel"}:
            raise ValueError("Invalid palette edit declaration fields")
        name, key = row["asset"], row["profile"]
        spec = catalog._select(name, key)
        if spec["codec"] != "palette" or spec["compression"] != "none" or spec["address_spaces"] != ["cartridge-rom"]:
            raise ValueError("Edit probe must use a fixed uncompressed cartridge palette")
        if assets[name]["image"] != key or assets[name]["size"] % 2:
            raise ValueError("Palette probe does not belong to its independent extraction owner")
        if (
            type(row["color"]) is not int
            or not 0 <= row["color"] < assets[name]["size"] // 2
            or row["channel"] not in ("red", "green", "blue")
        ):
            raise ValueError("Invalid palette edit coordinate")
    if probes[0]["asset"] == probes[1]["asset"]:
        raise ValueError("Sibling edit probes must have independent storage owners")
    return probes


def prepare_changes(catalog, assets, locations):
    changes = []
    for row in probe_definitions(catalog, assets):
        name, key = row["asset"], row["profile"]
        spec = catalog._select(name, key)
        original = (ROOT / "data" / name).read_bytes()
        packet = catalog.decode(name, key, original)
        index, channel = row["color"], row["channel"]
        if type(index) is not int or not 0 <= index < len(packet["model"]) or channel not in ("red", "green", "blue"):
            raise ValueError("Invalid palette edit coordinate")
        packet["model"][index][channel] ^= 1
        encoded = catalog.encode(packet, target_profile=key, original=original)
        if encoded == original or len(encoded) != len(original) or len(changed_ranges(original, encoded)) != 1:
            raise ValueError("Palette proof did not make a bounded nonzero edit")
        sites = locations[name]
        if not sites or any(site["space"] != "cartridge-rom" for site in sites):
            raise ValueError("Palette edit has no independently assembled cartridge consumer")
        if {site["profile"] for site in sites} != set(spec["profiles"]):
            raise ValueError("Palette edit omits an applicable profile")
        changes.append({"probe": row, "original": original, "encoded": encoded, "packet": packet, "sites": sites})
    return changes


def expected_images(changes):
    references = {key: read_reference(row) for key, row in image_records().items()}
    edited = {key: bytearray(value) for key, value in references.items()}
    intervals = {key: [] for key in references}
    for change in changes:
        for site in change["sites"]:
            key, start, end = site["profile"], site["start"], site["end"]
            if end - start != len(change["original"]) or bytes(edited[key][start:end]) != change["original"]:
                raise ValueError("Assembled palette consumer disagrees with its immutable original")
            if any(start < other["end"] and other["start"] < end for other in intervals[key]):
                raise ValueError("Palette edit consumer allocations overlap")
            edited[key][start:end] = change["encoded"]
            intervals[key].append({"start": start, "end": end, "asset": change["probe"]["asset"]})
    for key, profile in profiles().items():
        if "compose" not in profile:
            data = edited[key]
            if len(data) % 2:
                raise ValueError("Cartridge checksum needs complete big-endian words")
            checksum = (
                sum(int.from_bytes(data[offset : offset + 2], "big") for offset in range(0x200, len(data), 2)) & 0xFFFF
            )
            # Compute the format checksum independently of the build pipeline.
            data[0x18E:0x190] = checksum.to_bytes(2, "big")
            edited[key] = bytes(data)
    for key, profile in profiles().items():
        if "compose" in profile:
            composed = b"".join(edited[child] for child in profile["compose"])
            # The source-derived composite sites must agree with component edits.
            candidate = bytearray(edited[key])
            shift = 0
            for child in profile["compose"]:
                candidate[shift + 0x18E : shift + 0x190] = edited[child][0x18E:0x190]
                shift += len(edited[child])
            if candidate != composed:
                raise ValueError("Composite consumer evidence disagrees with independent sibling composition")
            edited[key] = composed
    return references, edited, intervals


def compare_images(outputs, changes):
    references, expected, intervals = expected_images(changes)
    if set(outputs) != set(profiles()):
        raise ValueError("Actual edit proof lacks a preservation profile")
    result = {}
    for key, output in outputs.items():
        actual = output.read_bytes()
        if actual != expected[key]:
            raise ValueError("Actual rebuilt ROM differs outside the exact typed edit and checksum: " + key)
        ranges = changed_ranges(references[key], actual)
        if not ranges:
            raise ValueError("Actual edit proof silently retained an original image")
        for change in changes:
            for site in change["sites"]:
                if site["profile"] == key and actual[site["start"] : site["end"]] != change["encoded"]:
                    raise ValueError("Rebuilt palette differs from the edited semantic model")
        result[key] = {
            "reference_sha256": sha(references[key]),
            "edited_sha256": sha(actual),
            "size": len(actual),
            "changed_ranges": ranges,
            "consumer_allocations": intervals[key],
        }
    return result


def verify_symbols(work):
    result = {}
    for key, profile in profiles().items():
        if "compose" in profile:
            continue
        before = ROOT / "build/objects" / key / "main.lst"
        after = work / "rebuilt/objects" / key / "main.lst"
        original = parse_symbols(before.read_text(errors="replace"))
        actual = parse_symbols(after.read_text(errors="replace"))
        if original != actual:
            raise ValueError("A fixed palette edit moved or changed an assembler symbol")
        result[key] = {"symbols": len(actual), "listing_sha256": sha(after.read_bytes())}
    return result


def check():
    source, tooling = source_fingerprint(), tooling_fingerprint()
    save({"complete": False, "source_sha256": source, "tooling_sha256": tooling})
    baseline = load("build/authoring/roundtrip.json")
    zero = load("build/authoring/zero-edit-containers.json")
    if (
        baseline.get("complete") is not True
        or zero.get("complete") is not True
        or any(
            report.get("source_sha256") != source or report.get("tooling_sha256") != tooling
            for report in (baseline, zero)
        )
    ):
        raise ValueError("Real edit proof requires current complete zero-edit containers")
    encoded = inside(baseline["workspace"])
    if not encoded.is_relative_to((ROOT / "build/authoring").resolve()) or set(baseline["source_outputs"]) != set(
        source_names()
    ):
        raise ValueError("Real edit proof lacks a bounded complete encoded source tree")
    sources = {}
    for name, expected in baseline["source_outputs"].items():
        data = inside(name, encoded).read_bytes()
        if sha(data) != expected:
            raise ValueError("Encoded source changed before the real edit proof")
        sources[name] = data
    catalog, assets = load_catalog()
    if set(baseline["outputs"]) != set(assets):
        raise ValueError("Real edit proof lacks the complete encoded private input set")
    for name, expected in baseline["outputs"].items():
        if sha(inside("data/" + name, encoded).read_bytes()) != expected:
            raise ValueError("Encoded input changed before the real edit proof")
    locations = content_profiles.check(catalog, assets)
    changes = prepare_changes(catalog, assets, locations)
    work = Path(tempfile.mkdtemp(prefix="edited-", dir=ROOT / "build/authoring")).resolve()
    stage(work, list(assets.values()), source_root=encoded / "data")
    for name, data in sources.items():
        atomic(inside(name, work), data)
    rejection_checks = []
    for change in changes:
        packet, key, original = change["packet"], change["probe"]["profile"], change["original"]
        target = inside("data/" + packet["asset"], work)
        wrong_profile = "sk" if key == "s3-us" else "s3-us"
        overflow = deepcopy(packet)
        overflow["model"].append(deepcopy(packet["model"][0]))
        for label, candidate, profile in (("foreign-profile", packet, wrong_profile), ("overflow", overflow, key)):
            try:
                catalog.write(work / "data", candidate, target_profile=profile, original=original)
            except ValueError:
                if target.read_bytes() != original:
                    raise ValueError("Rejected content edit changed its actual workspace allocation")
                rejection_checks.append({"asset": packet["asset"], "rejected": label, "allocation_unchanged": True})
            else:
                raise ValueError("Invalid real content edit was accepted")
        catalog.write(work / "data", packet, target_profile=key, original=original)
        if target.read_bytes() != change["encoded"]:
            raise ValueError("Actual content writer differs from the typed palette encoder")
    outputs = build_selected(list(profiles()), source_root=work, output_root=work / "rebuilt/images")
    result = compare_images(outputs, changes)
    symbols = verify_symbols(work)
    if source_fingerprint() != source or tooling_fingerprint() != tooling:
        raise ValueError("Real edit contract changed during rebuilding")
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source,
        "tooling_sha256": tooling,
        "workspace": work.relative_to(ROOT).as_posix(),
        "baseline_workspace": baseline["workspace"],
        "probes": load(CONFIG)["probes"],
        "profiles": result,
        "symbols": symbols,
        "rejected_edits": rejection_checks,
    }
    save(report)
    print(
        "[OK] Two nonzero typed palette edits rebuilt all five ROMs with exact consumer/checksum changes and unchanged symbols"
    )
    return report


def audit():
    report = load(REPORT)
    if (
        report.get("schema_version") != 1
        or report.get("complete") is not True
        or report.get("source_sha256") != source_fingerprint()
        or report.get("tooling_sha256") != tooling_fingerprint()
        or report.get("probes") != load(CONFIG)["probes"]
    ):
        raise ValueError("Actual edited-container evidence is stale or incomplete")
    work = inside(report["workspace"])
    if not work.is_relative_to((ROOT / "build/authoring").resolve()):
        raise ValueError("Actual edited-container workspace leaves ignored authoring storage")
    baseline = load("build/authoring/roundtrip.json")
    if report.get("baseline_workspace") != baseline["workspace"]:
        raise ValueError("Actual edited-container baseline changed")
    catalog, assets = load_catalog()
    changes = prepare_changes(catalog, assets, content_profiles.check(catalog, assets))
    outputs = {key: work / "rebuilt/images" / (key + ".bin") for key in profiles()}
    if compare_images(outputs, changes) != report["profiles"] or verify_symbols(work) != report["symbols"]:
        raise ValueError("Actual edited artifacts changed after acceptance")
    for name, expected in baseline["source_outputs"].items():
        if sha(inside(name, work).read_bytes()) != expected:
            raise ValueError("Actual edited workspace changed a source owner")
    edited_inputs = {change["probe"]["asset"]: sha(change["encoded"]) for change in changes}
    for name, expected in baseline["outputs"].items():
        if sha(inside("data/" + name, work).read_bytes()) != edited_inputs.get(name, expected):
            raise ValueError("Actual edited workspace changed an unrelated private input")
    expected_rejections = [
        {"asset": change["probe"]["asset"], "rejected": reason, "allocation_unchanged": True}
        for change in changes
        for reason in ("foreign-profile", "overflow")
    ]
    if report.get("rejected_edits") != expected_rejections:
        raise ValueError("Actual edit proof omits a required unchanged-allocation rejection")
    print("[OK] Current actual edited-container evidence, exact differences and unchanged source/ABI")
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("check", "audit"))
    args = parser.parse_args(argv)
    check() if args.command == "check" else audit()
    return 0

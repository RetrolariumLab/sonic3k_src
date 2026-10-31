"""Bind retained source content to AS output and produce semantic source encodings."""

import hashlib
import json
from pathlib import Path
import re

from scripts.authoring import assembly_data
from scripts.authoring.assembly_content import AssemblyCatalog
from scripts.build.project import ROOT, atomic, image_records, load, profiles, source_fingerprint, source_names
from scripts.validation.source_layout import parse_include_ranges
from scripts.validation.symbols import parse_symbols

CATALOG = "config/authoring/assembly_formats.json"


def catalog():
    if load("config/authoring/data_formats.json").get("assembly_catalog") != CATALOG:
        raise ValueError("Main format registry does not own the assembly content catalog")
    result = AssemblyCatalog(load(CATALOG), profiles())
    expected = {name for name in source_names() if Path(name).name.startswith(("map_", "dplc_", "anim_"))}
    if {row["path"] for row in result.rows()} != expected:
        raise ValueError("Assembly resource registry omits or duplicates retained content")
    for row in result.rows():
        text = (ROOT / row["path"]).read_text()
        result._original(row, text, {name: 0 for name in row["external_symbols"]})
    return result


def bind(result):
    binding = load("build/source_binding.json")
    if not binding.get("byte_identity_checked") or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Assembly content binding needs a current byte-exact build")
    rows = {row["path"]: row for row in result.rows()}
    output, declarations = {name: [] for name in rows}, {}
    images = image_records()
    for profile, spec in profiles().items():
        if "compose" in spec:
            continue
        listing = (ROOT / "build/objects" / profile / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        if hashlib.sha256(image).hexdigest() != images[spec["image"]]["sha256"]:
            raise ValueError("Assembly resource proof image is not the preservation image")
        ranges = parse_include_ranges(listing, set(rows))
        seen = set()
        for item in ranges:
            name = item["path"]
            if name in seen:
                raise ValueError("Assembly resource is included twice in one profile")
            seen.add(name)
            row = rows[name]
            external = {}
            for symbol in row["external_symbols"]:
                if symbol not in symbols:
                    raise ValueError("Assembly content external symbol is absent from its active profile")
                external[symbol] = symbols[symbol] - item["start"]
            records, data, labels = result._original(row, (ROOT / name).read_text(), external)
            if len(data) != item["end"] - item["start"] or image[item["start"] : item["end"]] != data:
                raise ValueError("Semantic assembly resource differs from actual AS image bytes")
            if any(symbols.get(label) != item["start"] + offset for label, offset in labels.items()):
                raise ValueError("Assembly resource label differs from active AS output")
            output[name].append(
                {"profile": profile, "start": item["start"], "end": item["end"], "external_symbols": external}
            )
            declarations[(profile, name)] = (data, labels)
        # Each external target must enter another registered semantic frame/sequence;
        # an external base must be the real outer alias of the current source unit.
        intervals = {name: item for name in rows for item in output[name] if item["profile"] == profile}
        starts = {
            intervals[name]["start"] + block["offset"]
            for name in intervals
            for block in rows[name]["blocks"]
            if block["kind"] not in ("relative-word", "alignment")
        }
        for name, item in intervals.items():
            row = rows[name]
            for block in row["blocks"]:
                if block["kind"] != "relative-word":
                    continue
                if block["base"] in row["external_symbols"] and symbols[block["base"]] != item["start"]:
                    raise ValueError("External assembly table base is not its checked source alias")
                if block["target"] in row["external_symbols"] and symbols[block["target"]] not in starts:
                    raise ValueError("External source pointer leaves registered semantic resource entries")
    for name, entries in output.items():
        for item in list(entries):
            if item["profile"] in ("s3-us", "sk"):
                offset = 0x200000 if item["profile"] == "s3-us" else 0
                entries.append(
                    item
                    | {
                        "profile": "s3k",
                        "component": item["profile"],
                        "start": item["start"] + offset,
                        "end": item["end"] + offset,
                    }
                )
        if {item["profile"] for item in entries} != set(rows[name]["profiles"]):
            raise ValueError("Assembly content applicability differs from actual active AS includes")
    return output


def roundtrip(workspace):
    result = catalog()
    locations = bind(result)
    encoded, evidence = {}, []
    for row in result.rows():
        name = row["path"]
        original = (ROOT / name).read_text()
        source = None
        for item in locations[name]:
            component = item.get("component")
            packet = result.decode(
                name, item["profile"], original, external_symbols=item["external_symbols"], component=component
            )
            rendered, data = result.encode(
                packet,
                target_profile=item["profile"],
                original=original,
                external_symbols=item["external_symbols"],
                component=component,
            )
            if source is not None and source != rendered:
                raise ValueError("Shared source semantic encodings differ between accepted profiles")
            source = rendered
        encoded[name] = source.encode()
        evidence.append(
            {
                "path": name,
                "bindings": locations[name],
                "semantic_blocks": len(row["blocks"]),
                "encoded_source_sha256": hashlib.sha256(encoded[name]).hexdigest(),
                "byte_exact": True,
            }
        )
    # Every model, profile, source expression and fixed footprint is checked before writes.
    destination_root = workspace.resolve()
    if not destination_root.is_relative_to((ROOT / "build/authoring").resolve()):
        raise ValueError("Assembly content workspace leaves ignored authoring storage")
    for name, data in encoded.items():
        destination = (destination_root / name).resolve()
        if not destination.is_relative_to(destination_root / "src"):
            raise ValueError("Encoded source leaves the workspace source tree")
        atomic(destination, data)
    report = {
        "complete": True,
        "resources": len(encoded),
        "artifacts": evidence,
        "outputs": {name: hashlib.sha256(data).hexdigest() for name, data in encoded.items()},
    }
    print("[OK] All " + str(len(encoded)) + " source resources passed semantic encode/decode", flush=True)
    return report

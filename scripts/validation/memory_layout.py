"""Typed non-emitting declarations, inherited ABI symbols and AS emission bounds."""

import hashlib
import json
import re

from scripts.build.project import ROOT, atomic, image_records, load, profiles, source_fingerprint
from scripts.validation.as_object import decode
from scripts.validation.data_macros import definition_blocks
from scripts.validation.definitions import NAMED
from scripts.validation.numeric_operands import code_part
from scripts.validation.object_contexts import DriverSlot, validate
from scripts.validation.symbols import parse_declaration_symbols

LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*):\s*")
PHASE_KINDS = {"ram", "sram", "overlay", "enumerations"}
KINDS = PHASE_KINDS | {"offsets", "hardware", "cursor"}
PRIMITIVES = {"ds", "ds.b", "ds.w", "ds.l", "phase", "dephase", "enum", "padding"}


def _compact(value):
    return re.sub(r"\s+", "", value)


def declarations(text, contract):
    if set(contract) != {"kind", "phases", "rewind", "profiles"} or contract["kind"] not in KINDS:
        raise ValueError("Unknown memory declaration contract")
    if (
        not isinstance(contract["phases"], list)
        or any(not isinstance(x, str) or not x for x in contract["phases"])
        or type(contract["rewind"]) is not bool
    ):
        raise ValueError("Invalid memory phase or cursor contract")
    phase, phases, names, fields, rewinds, guard = None, [], set(), [], 0, 0
    started = False
    for line in text.splitlines():
        raw = code_part(line).strip()
        if not raw:
            continue
        if not started:
            if _compact(raw).lower() != "paddingoff":
                raise ValueError("Memory declarations must explicitly disable emitted padding first")
            started = True
            continue
        label = LABEL.match(raw)
        name = label[1] if label else None
        body = raw[label.end() :].strip() if label else raw
        named = NAMED.fullmatch(raw)
        if guard:
            if guard == 1 and re.fullmatch(r'fatal\s+"[^"\r\n]+"', body, re.I):
                guard = 2
                continue
            if guard == 2 and body.lower() == "endif":
                guard = 0
                continue
            raise ValueError("Memory capacity guard may contain only one fatal diagnostic")
        if named:
            if named[1].lower() not in ("equ", "set"):
                raise ValueError("Memory definitions cannot declare executable helpers")
            # The declaration name precedes EQU/SET, with or without a colon.
            name = re.match(r"[A-Za-z_.][A-Za-z_0-9.]*", raw)[0]
            if not name.startswith("."):
                names.add(name)
                if phase is not None and _compact(named[2]) == "*":
                    fields.append({"name": name, "phase": phase})
            continue
        if name and not name.startswith("."):
            names.add(name)
            if phase is not None:
                fields.append({"name": name, "phase": phase})
        if not body:
            if name is None:
                raise ValueError("Empty unnamed memory declaration")
            continue
        parts = body.split(None, 1)
        op, args = parts[0].lower(), parts[1].strip() if len(parts) == 2 else ""
        if op == "phase":
            if phase is not None or not args or contract["kind"] not in PHASE_KINDS:
                raise ValueError("Memory allocation has a nested or unsupported phase")
            phase = len(phases)
            phases.append(_compact(args))
        elif op == "dephase" and not args and phase is not None:
            phase = None
        elif op in ("ds.b", "ds.w", "ds.l"):
            if phase is None or not args or "," in args or not re.fullmatch(r"[A-Za-z_0-9.$*()+/#<>&|~^ -]+", args):
                raise ValueError("Memory reservation needs one uninitialized expression inside a phase")
            if contract["kind"] == "sram" and op != "ds.w":
                raise ValueError("Odd-byte SRAM declarations require word strides")
        elif op == "enum":
            if phase is not None or contract["kind"] != "offsets":
                raise ValueError("Offset enumeration used outside its declaration domain")
            for field in args.split(","):
                item = re.fullmatch(r"([A-Za-z_][A-Za-z_0-9]*)\s*=\s*(?:\$[0-9A-Fa-f]+|[0-9]+)", field.strip())
                if not item:
                    raise ValueError("Offset enumeration requires explicit literal assignments")
                names.add(item[1])
        elif op == "!org" and args == "0" and phase is None and contract["rewind"]:
            rewinds += 1
        elif op == "if" and re.fullmatch(r"\((\.check2?)>0\)&\(\1<\$FF0000\)", _compact(args), re.I):
            guard = 1
        else:
            raise ValueError("Emitting, executable or unchecked memory syntax: " + body)
    if (
        not started
        or phase is not None
        or guard
        or phases != [_compact(x) for x in contract["phases"]]
        or rewinds != int(contract["rewind"])
    ):
        raise ValueError("Memory phase, guard or cursor closure differs from its contract")
    if contract["kind"] == "sram" and phases != ["$200001"]:
        raise ValueError("SRAM starts at the fixed odd cartridge address")
    if contract["kind"] == "ram" and phases != ["$FFFF0000"]:
        raise ValueError("68000 RAM starts at the fixed high memory address")
    return {"symbols": sorted(names), "fields": fields, "phases": phases}


def check_primitives(texts):
    for text in texts.values():
        if any(name in PRIMITIVES for name, first, last, body in definition_blocks(text)):
            raise ValueError("Memory allocation primitive has an unchecked override")


def _domain(name, value, kind):
    if type(value) is not int:
        raise ValueError("Allocated memory address must be an AS integer")
    address = value & 0xFFFFFF
    endpoint = name.lower().endswith("end")
    if kind == "sram":
        if not 0x200001 <= address <= 0x200801 or not address & 1 or (address == 0x200801 and not endpoint):
            raise ValueError("SRAM symbol leaves its odd-byte one-KiB allocation")
    elif kind in ("ram", "overlay"):
        if not 0xFF0000 <= address <= 0xFFFFFF and not (endpoint and value == 0):
            raise ValueError("RAM symbol leaves the fixed 64-KiB memory domain")
    elif kind == "enumerations":
        if not 0 <= value <= 256 or (value == 256 and not endpoint):
            raise ValueError("Sound identifier exceeds its byte domain")


def check_built(rows):
    selected = [row for row in rows if row["role"] == "memory"]
    if not selected:
        return {}
    witness = load("build/provenance/preservation-comparison.json")
    from scripts.authoring.formats_workflow import tooling_fingerprint

    if (
        not witness.get("complete")
        or witness["source_sha256"] != source_fingerprint()
        or witness.get("tooling_sha256") != tooling_fingerprint()
        or witness["baseline_commit"] != load("config/reconstruction/source_layout.json")["baseline_commit"]
    ):
        raise ValueError("Memory ABI check needs a current historical preservation witness")
    baseline = witness["historical_symbols"]
    evidence, counts = {}, {}
    wanted = {row["path"] for row in selected}
    active = {name: set() for name in wanted}
    include = re.compile(r'\binclude\s+"([^"]+)"', re.I)
    for key, profile in profiles().items():
        if "compose" in profile:
            continue
        listing = (ROOT / "build/objects" / key / "main.lst").read_text(errors="replace")
        symbols = parse_declaration_symbols(listing)
        for line in listing.splitlines():
            match = re.match(r"^(?:\(\d+\))?\s*\d+/\s*[A-Fa-f0-9]+\s*:(.*)$", line)
            item = include.search(match[1]) if match else None
            if item and item[1] in wanted:
                active[item[1]].add(key)
        image = (ROOT / "build/images" / (key + ".bin")).read_bytes()
        expected = image_records()[key]
        if hashlib.sha256(image).hexdigest() != expected["sha256"]:
            raise ValueError("Memory proof image is not a verified preservation build")
        payload = (ROOT / "build/objects" / key / "main.p").read_bytes()
        records, entries, creator = decode(payload)
        codec = "raw" if profile["driver_compression"] == "uncompressed" else "kosinski"
        slots = [
            DriverSlot("code", symbols["Z80_SoundDriver"], symbols["Size_of_Snd_driver_guess"], 0, 0x1300, codec),
            DriverSlot(
                "tables", symbols["Z80_SoundDriverData"], symbols["Size_of_Snd_driver2_guess"], 0x1300, 0x1C00, codec
            ),
        ]
        proof = validate(records, image, slots)
        proof["object_sha256"] = hashlib.sha256(payload).hexdigest()
        evidence[key] = proof
        for row in selected:
            if key not in row["memory_contract"]["profiles"]:
                continue
            model = declarations((ROOT / row["path"]).read_text(), row["memory_contract"])
            for name in model["symbols"]:
                if name not in symbols or name not in baseline[key] or symbols[name] != baseline[key][name]:
                    raise ValueError("Historical memory ABI symbol changed: " + key + " " + name)
            for field in model["fields"]:
                _domain(field["name"], symbols[field["name"]], row["memory_contract"]["kind"])
            counts[key] = counts.get(key, 0) + len(model["symbols"])
    for row in selected:
        if active[row["path"]] != set(row["memory_contract"]["profiles"]):
            raise ValueError("Memory declaration applicability differs from active AS includes")
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source_fingerprint(),
        "tooling_sha256": tooling_fingerprint(),
        "baseline_commit": witness["baseline_commit"],
        "historical_symbol_counts": counts,
        "object_contexts": evidence,
    }
    atomic(ROOT / "build/memory_layout.json", (json.dumps(report, indent=2) + "\n").encode())
    return report


def main(argv=None):
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", action="store_true")
    args = parser.parse_args(argv)
    rows = load("config/reconstruction/source_layout.json")["files"]
    texts = {row["path"]: (ROOT / row["path"]).read_text() for row in rows}
    check_primitives(texts)
    selected = [row for row in rows if row["role"] == "memory"]
    for row in selected:
        declarations(texts[row["path"]], row["memory_contract"])
    if args.built:
        check_built(rows)
    print("[OK] Typed memory declarations: " + str(len(selected)) + " modules")
    return 0

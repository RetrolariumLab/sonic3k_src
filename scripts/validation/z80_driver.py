"""Check Z80 source semantics, RAM allocation and explicit cartridge/virtual contexts."""

import argparse
from collections import Counter
import hashlib
import json
import re
import subprocess

from scripts.build.project import ROOT, atomic, load, profiles, source_fingerprint
from scripts.validation.data_macros import HEADER, body_statement, definition_blocks
from scripts.validation.definitions import named_declaration
from scripts.validation.numeric_operands import code_part
from scripts.validation.symbols import parse_symbols

LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*):\s*")
INSTRUCTIONS = frozenset(
    "adc add and bit call cp dec di djnz ei ex exx im inc jp jr ld ldi ldir neg nop "
    "or pop push res ret rlca rra rrca rst set sra srl sub xor".split()
)
BANKING = frozenset("bankswitch1 bankswitch2 bankswitch3 bankswitchtomusic bankswitchtomusics3 bankswitchtosfx".split())
TABLE_MACROS = frozenset("zmake68kbanks zmake68kptrs zmakepsgfrequencies zmakefmfrequencies zmakesongbanks".split())
MACROS = BANKING | TABLE_MACROS | {"rsttarget"}
CONTROL = frozenset("if else endif".split())


def lines(text):
    return [code_part(line).strip() for line in text.splitlines() if code_part(line).strip()]


def normalize(text):
    # Preserve quoted operands while ignoring indentation and spacing between tokens.
    return ["".join(re.findall(r'"[^"]*"|\'[^\']*\'|[^\s]', line)) for line in lines(text)]


def preserve_statements(expected, actual, owner):
    if normalize(expected) != normalize(actual):
        raise ValueError("Driver instructions, labels or context changed: " + owner)


def literal(text):
    if re.fullmatch(r"\$[0-9A-Fa-f]+", text):
        return int(text[1:], 16)
    if re.fullmatch(r"[0-9][0-9A-Fa-f]*h", text, re.I):
        return int(text[:-1], 16)
    if re.fullmatch(r"[0-9]+", text):
        return int(text)
    raise ValueError("RAM allocation needs a literal bounded integer")


def ram_declarations(text):
    rows = lines(text)
    if not rows or normalize(rows[0]) != ["paddingoff"]:
        raise ValueError("Z80 RAM declarations require explicit non-emitting padding")
    symbols, fields, phases, allocations = {}, {}, [], []
    cursor, structure, phase, guard = 0, False, None, 0
    instances = 0

    def put(name, value):
        if name in symbols:
            raise ValueError("Duplicate Z80 RAM symbol")
        symbols[name] = value

    for raw in rows[1:]:
        match = LABEL.match(raw)
        name = match[1] if match else None
        code = raw[match.end() :].strip() if match else raw
        parts = code.split(None, 1)
        op, args = (parts[0].lower(), parts[1].strip() if len(parts) == 2 else "") if parts else ("", "")
        if guard:
            if guard == 1 and op == "fatal" and re.fullmatch(r'"[^"\r\n]+"', args):
                guard = 2
                continue
            if guard == 2 and op == "endif" and not args:
                guard = 0
                continue
            raise ValueError("RAM capacity guard contains more than a fatal diagnostic")
        if op == "struct" and name == "zTrack" and args == "DOTS" and not structure and not symbols:
            structure, cursor = True, 0
            continue
        if op == "endstruct" and name == "zTrack" and not args and structure:
            if cursor != 0x30:
                raise ValueError("Z80 track structure must occupy 48 bytes")
            put("zTrack.len", cursor)
            structure = False
            continue
        if name and op not in ("equ", "struct", "endstruct"):
            if structure:
                fields[name] = cursor
                put("zTrack." + name, cursor)
            elif phase is not None:
                put(name, cursor)
            else:
                raise ValueError("Unallocated Z80 RAM label")
        if not op:
            continue
        if op == "equ" and name and not structure and phase is None:
            match = re.fullmatch(r"(z80_stack)(-\$[0-9A-Fa-f]+)", args)
            value = symbols[match[1]] - literal(match[2][1:]) if match else literal(args)
            put(name, value)
        elif op == "ds.b" and (structure or phase is not None):
            size = literal(args)
            if not 0 < size <= 0x60:
                raise ValueError("Z80 RAM field exceeds bounded allocation")
            cursor += size
        elif op == "ztrack" and not args and name and phase is not None:
            for field, offset in fields.items():
                put(name + "." + field, cursor + offset)
            allocations.append([cursor, cursor + 0x30])
            cursor += 0x30
            instances += 1
        elif op == "phase" and phase is None and not structure:
            if args not in ("zDataStart", "zTracksSFXStart") or args in phases:
                raise ValueError("Unknown or duplicate Z80 RAM phase")
            phases.append(args)
            phase, cursor = args, symbols[args]
        elif op == "dephase" and phase is not None and not args:
            if cursor > 0x1FA0:
                raise ValueError("Z80 variables overlap the reserved stack")
            phase = None
        elif op == "if" and phase == "zTracksSFXStart" and normalize(args) == ["*>z80_stack_end"]:
            guard = 1
        else:
            raise ValueError("Emitting, executable or unknown Z80 RAM syntax: " + raw)
        if structure and cursor > 0x30 or phase is not None and not 0x1C00 <= cursor <= 0x1FA0:
            raise ValueError("Z80 allocation leaves its structure or variable domain")
    expected = {
        "z80_stack": 0x2000,
        "z80_stack_end": 0x1FA0,
        "zDataStart": 0x1C00,
        "zYM2612_A0": 0x4000,
        "zYM2612_D0": 0x4001,
        "zYM2612_A1": 0x4002,
        "zYM2612_D1": 0x4003,
        "zBankRegister": 0x6000,
        "zPSG": 0x7F11,
        "zROMWindow": 0x8000,
    }
    if structure or phase is not None or guard or phases != ["zDataStart", "zTracksSFXStart"] or instances != 25:
        raise ValueError("Incomplete track structure or RAM allocation contexts")
    if any(symbols.get(k) != v for k, v in expected.items()):
        raise ValueError("Z80 hardware, stack or variable base changed")
    if symbols["zTracksSaveStart"] != symbols["zTracksSFXStart"] or symbols["zTracksSaveEnd"] != 0x1FA0:
        raise ValueError("Song backup must explicitly overlay effects and end below the stack")
    return {"symbols": symbols, "track_fields": len(fields), "track_instances": instances, "allocations": allocations}


def _check_controls(rows, allowed, macros=False):
    stack, executable = [], 0
    for raw in rows:
        code = named_declaration(raw) or body_statement(raw)
        if not code:
            continue
        parts = code.split(None, 1)
        op, args = parts[0].lower(), parts[1].strip() if len(parts) == 2 else ""
        if op == "if":
            stack.append(["if", False])
        elif op == "else":
            if not stack or stack[-1] != ["if", False] or args:
                raise ValueError("Unbalanced Z80 assembly conditional")
            stack[-1][1] = True
        elif op == "endif":
            if not stack or stack.pop()[0] != "if" or args:
                raise ValueError("Unbalanced Z80 assembly conditional closure")
        elif op in ("rept", "irp") and macros:
            if op == "rept" and args not in ("3", "7", "9"):
                raise ValueError("Z80 helper repetition requires its small literal bound")
            if op == "irp" and normalize(args) != ["op,ALLARGS"]:
                raise ValueError("Z80 table iteration requires its finite argument list")
            stack.append(["loop", False])
        elif op == "endm" and macros:
            if not stack or stack.pop()[0] != "loop" or args:
                raise ValueError("Unbalanced Z80 helper iteration closure")
        elif op not in allowed:
            raise ValueError("Unchecked Z80 source operation: " + op)
        executable += op in INSTRUCTIONS
    if stack:
        raise ValueError("Unclosed Z80 conditional or iteration")
    return executable


def check_module(text, contract):
    if set(contract) != {"kind", "context"}:
        raise ValueError("Invalid Z80 driver source contract")
    kind, context = contract["kind"], contract["context"]
    if kind == "memory" and context == "declarations":
        return ram_declarations(text)
    if kind == "wrapper" and context == "container":
        # The complete wrapper is checked against historical source in check_sources.
        if any(HEADER.match(line) for line in lines(text)):
            raise ValueError("Driver container cannot override assembly primitives")
        return {}
    if kind not in ("definitions", "code", "data") or context not in ("code", "tables"):
        raise ValueError("Unknown Z80 leaf kind or context")
    rows = lines(text)
    if normalize("\n".join(rows[:2])) != ["CPUZ80", "listingpurecode"]:
        raise ValueError("Z80 leaf needs explicit CPU and listing context")
    blocks = definition_blocks(text)
    hidden = {i for name, first, last, body in blocks for i in range(first, last)}
    for name, first, last, body in blocks:
        if name not in MACROS:
            raise ValueError("Unknown Z80 helper macro")
        allowed = {"equ", "set", "label", "fatal", "db", "dw", "function"}
        if name in BANKING:
            allowed |= INSTRUCTIONS | BANKING
        elif name == "rsttarget":
            allowed = {"label", "fatal"}
        _check_controls(lines("\n".join(body.splitlines()[1:-1])), allowed, macros=True)
    outer = [raw for i, raw in enumerate(text.splitlines()) if i not in hidden and code_part(raw).strip()]
    # Remove only the mandatory CPU/listing prefix, never arbitrary directives.
    outer = outer[2:]
    for raw in outer:
        code = body_statement(raw)
        match = re.fullmatch(r'binclude\s+"([^"]+)"', code, re.I)
        if match:
            target = match[1]
            if context == "code" and (kind != "code" or target != "data/Sound/DAC/deltas.bin"):
                raise ValueError("Z80 code may only include its extracted delta codebook")
            if context == "tables" and target not in {
                "data/" + row["path"] for row in load("config/audio_driver_payloads.json")["assets"]
            }:
                raise ValueError("Z80 table resource has no private extraction recipe")
    allowed = {"equ", "function"}
    if kind != "definitions":
        allowed |= {"db", "dw", "align", "binclude", "fatal"} | TABLE_MACROS
    if kind == "code":
        allowed |= INSTRUCTIONS | BANKING | {"rsttarget"}
    count = _check_controls(outer, allowed)
    if kind == "code" and count == 0:
        raise ValueError("Executable Z80 owner contains no real instructions")
    if kind == "data" and any(name not in TABLE_MACROS for name, a, b, body in blocks):
        raise ValueError("Z80 data source defines a runtime helper")
    return {"instructions": count, "macros": len(blocks)}


def check_sources(rows):
    from scripts.validation.label_renames import validate_registry
    from scripts.validation.semantic_labels import original_view

    migration = validate_registry().get("semantic_migration")
    registry = load("config/reconstruction/z80_driver.json")
    if (
        registry["schema_version"] != 1
        or registry["code_window"] != [0, 0x1300]
        or registry["tables_window"] != [0x1300, 0x1C00]
    ):
        raise ValueError("Driver virtual windows differ from the original memory layout")
    if registry["ram_window"] != [0x1C00, 0x1FA0] or registry["stack_window"] != [0x1FA0, 0x2000]:
        raise ValueError("Driver variables or stack leave their fixed RAM window")
    revision = registry["baseline_commit"]
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Z80 source preservation needs a full historical commit")
    subprocess.run(["git", "merge-base", "--is-ancestor", revision, "HEAD"], cwd=ROOT, check=True, capture_output=True)
    baseline = subprocess.check_output(["git", "show", revision + ":" + registry["baseline_path"]], cwd=ROOT).decode()
    if hashlib.sha256(baseline.encode()).hexdigest() != registry["baseline_sha256"]:
        raise ValueError("Historical Z80 source hash differs from its contract")
    modules = registry["modules"]
    paths = [m["path"] for m in modules]
    selected = {r["path"]: r for r in rows if r["role"] == "z80-driver"}
    if len(paths) != len(set(paths)) or set(selected) != set(paths) | {registry["wrapper"]}:
        raise ValueError("Driver owner registry omits or duplicates a source")
    original = baseline.splitlines(keepends=True)
    projected, next_line = [], 1
    evidence = {}
    for module in modules:
        path = module["path"]
        first, last = module["first_line"], module["last_line"]
        if not next_line <= first <= last <= len(original):
            raise ValueError("Overlapping or invalid historical driver source range")
        projected.extend(original[next_line - 1 : first - 1])
        projected.append('include "' + path + '"\n')
        next_line = last + 1
        row = selected[path]
        contract = {key: module[key] for key in ("kind", "context")}
        expected_space = "declarations" if module["kind"] == "memory" else "z80-driver-" + module["context"]
        if row["driver_contract"] != contract or row["address_space"] != expected_space:
            raise ValueError("Z80 owner has no matching kind or assembly namespace")
        text = (ROOT / path).read_text()
        evidence[path] = check_module(text, contract)
        historical_text = original_view(path, text, migration) if migration else text
        body = lines(historical_text)[1 if module["kind"] == "memory" else 2 :]
        preserve_statements("".join(original[first - 1 : last]), "\n".join(body), path)
    projected.extend(original[next_line - 1 :])
    row = selected[registry["wrapper"]]
    if (
        row["driver_contract"] != {"kind": "wrapper", "context": "container"}
        or row["address_space"] != "driver-container"
    ):
        raise ValueError("Driver wrapper has no explicit physical/virtual contract")
    wrapper = (ROOT / registry["wrapper"]).read_text()
    if migration:
        wrapper = original_view(registry["wrapper"], wrapper, migration)
    preserve_statements("".join(projected), wrapper, registry["wrapper"])
    return registry, evidence


def compare_symbol_addresses(ram_symbols, labels, symbols, historical, renames):
    """Resolve current spellings through the validated profile's rename registry."""
    originals = {}
    for old, new in renames.items():
        if new in originals:
            raise ValueError("Registered Z80 historical names collide")
        originals[new] = old
    for name, expected in ram_symbols.items():
        old = originals.get(name, name)
        if symbols.get(name) != expected or historical.get(old) != expected:
            raise ValueError("Z80 RAM field differs from its independent byte cursor or historical ABI: " + name)
    active_labels = {name for name in labels if originals.get(name, name) in historical}
    for name in active_labels:
        if name not in symbols or symbols[name] != historical[originals.get(name, name)]:
            raise ValueError("Historical Z80 code or table entry changed: " + name)
    return len(active_labels)


def check_built(rows):
    registry, evidence = check_sources(rows)
    from scripts.authoring.formats_workflow import tooling_fingerprint
    from scripts.validation.label_renames import profile_maps, validate_registry
    from scripts.validation.source_layout import parse_include_ranges

    mappings = profile_maps(validate_registry())
    witness = load("build/provenance/preservation-comparison.json")
    binding = load("build/source_binding.json")
    if (
        not witness.get("complete")
        or not binding.get("byte_identity_checked")
        or witness["source_sha256"] != source_fingerprint()
        or binding["source_sha256"] != source_fingerprint()
        or witness.get("tooling_sha256") != tooling_fingerprint()
        or witness["baseline_commit"] != load("config/reconstruction/source_layout.json")["baseline_commit"]
    ):
        raise ValueError("Z80 layout needs current byte identity and historical preservation proofs")
    modules = registry["modules"]
    leaf_paths = {m["path"] for m in modules if m["kind"] != "memory"}
    ram = next(m for m in modules if m["kind"] == "memory")
    ram_model = ram_declarations((ROOT / ram["path"]).read_text())
    profile_evidence = {}
    # Source labels are compared with the independently rebuilt accepted 1.0 tree.
    labels = set()
    for module in modules:
        for raw in lines((ROOT / module["path"]).read_text()):
            match = LABEL.match(raw)
            if match and not match[1].startswith("."):
                labels.add(match[1])
    labels.discard("zTrack")  # AS exports its fields and size rather than this type name.
    for key, profile in profiles().items():
        if "compose" in profile:
            continue
        listing = (ROOT / "build/objects" / key / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        ranges = parse_include_ranges(listing, leaf_paths)
        if Counter(r["path"] for r in ranges) != Counter({path: 1 for path in leaf_paths}):
            raise ValueError("A driver leaf is missing, duplicated or inactive in AS output")
        by_path = {r["path"]: r for r in ranges}
        for module in modules:
            if module["kind"] == "memory":
                continue
            item = by_path[module["path"]]
            low, high = registry[module["context"] + "_window"]
            if not low <= item["start"] <= item["end"] <= high:
                raise ValueError("Z80 owner leaves its explicit virtual window")
            if module["kind"] == "definitions" and item["start"] != item["end"]:
                raise ValueError("Z80 helper definitions emit bytes")
        # Keep the historical profile's observed scope, including renamed entries.
        entries = compare_symbol_addresses(
            ram_model["symbols"], labels, symbols, witness["historical_symbols"][key], mappings.get(key, {})
        )
        profile_evidence[key] = {
            "ranges": ranges,
            "historical_entry_symbols": entries,
            "independent_ram_symbols": len(ram_model["symbols"]),
        }
    # Physical record coverage, both compression slots and final cartridge bytes
    # are independently reconciled by the mandatory memory/object-context gate.
    contexts = load("build/memory_layout.json")
    if (
        not contexts.get("complete")
        or contexts["source_sha256"] != source_fingerprint()
        or contexts["tooling_sha256"] != tooling_fingerprint()
    ):
        raise ValueError("Z80 virtual ranges lack a current physical object coverage proof")
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source_fingerprint(),
        "tooling_sha256": tooling_fingerprint(),
        "baseline_commit": registry["baseline_commit"],
        "source_owners": len(evidence) + 1,
        "modules": evidence,
        "profiles": profile_evidence,
        "object_contexts": contexts["object_contexts"],
    }
    atomic(ROOT / "build/z80_driver.json", (json.dumps(report, indent=2) + "\n").encode())
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", action="store_true")
    args = parser.parse_args(argv)
    rows = load("config/reconstruction/source_layout.json")["files"]
    registry, evidence = check_sources(rows)
    if args.built:
        check_built(rows)
    print("[OK] Z80 driver: " + str(len(evidence) + 1) + " typed source owners")
    return 0

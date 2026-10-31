"""Check semantic ownership without treating pending modules as accepted layout."""

import argparse
import json
import re

from scripts.build.project import ROOT, atomic, image_records, load, profiles, source_fingerprint
from scripts.build.relocation import source_names
from scripts.validation.numeric_operands import code_part
from scripts.validation.cohorts import INSTRUCTIONS, TERMINALS, collect_file, statements
from scripts.validation.definitions import check_definitions, check_nonemitting_range, named_declaration
from scripts.validation.data_macros import DATA_MACROS, HEADER as MACRO_HEADER, check_data_macros
from scripts.validation import memory_layout, composition_sources, z80_driver
from scripts.validation.source_names import check_source_names
from scripts.validation.documentation import tracked

DATA_OPS = (
    frozenset(("dc.b", "dc.w", "dc.l", "even", "align", "align0", "cnop", "cnop0", "macro", "endm", "equ", "label"))
    | DATA_MACROS
)


def check_literal_padding(code):
    parts = code.split(None, 1)
    name = parts[0].lower()
    fields = parts[1].split(",") if len(parts) == 2 else []
    expected = 2 if name.startswith("cnop") else 1
    if len(fields) != expected or any(not re.fullmatch(r"-?(?:\$[0-9A-Fa-f]+|[0-9]+)", f.strip()) for f in fields):
        raise ValueError("Data padding needs bounded literal alignment and offset")
    values = []
    for field in fields:
        field = field.strip()
        token = field.removeprefix("-")
        value = int(token[1:], 16) if token.startswith("$") else int(token)
        values.append(-value if field.startswith("-") else value)
    alignment = values[-1]
    if not 2 <= alignment <= 0x8000 or alignment & (alignment - 1):
        raise ValueError("Data alignment leaves its bounded power-of-two domain")
    if expected == 2 and not -alignment < values[0] < alignment:
        raise ValueError("Data padding offset leaves its alignment domain")


def check_ledger(text, source_includes=(), binary_includes=()):
    dependencies = []
    depth = 0
    state_depth = 0
    for line in text.splitlines():
        raw = code_part(line).strip()
        macro = MACRO_HEADER.match(raw)
        code = named_declaration(raw) or re.sub(r"^[A-Za-z_.][A-Za-z_0-9.]*:\s*", "", raw)
        if macro:
            if macro[1].lower() not in DATA_MACROS:
                raise ValueError("Data ledger defines an implementation-only or unknown macro")
            code = "macro"
        if not code:
            continue
        parts = code.split(None, 1)
        op = parts[0].lower()
        if op == "macro" and not macro:
            raise ValueError("Data macro definition needs a named canonical header")
        if op in ("save", "restore", "codepage"):
            if op == "codepage":
                if not state_depth or len(parts) != 2 or parts[1] != "LEVELSELECT":
                    raise ValueError("Data code page lacks a bounded known encoding context")
            else:
                state_depth += 1 if op == "save" else -1
                if state_depth < 0:
                    raise ValueError("Unbalanced data encoding restore")
            continue
        if op in ("include", "binclude"):
            target = re.fullmatch(r'(?:include|binclude)\s+"([^"\r\n]+)"', code, re.I)
            accepted = source_includes if op == "include" else binary_includes
            if not target or target[1] not in accepted:
                raise ValueError("Data include has no checked source or extracted-asset owner")
            if op == "include":
                dependencies.append(target[1])
            continue
        if op == "even":
            if code.lower() != "even":
                raise ValueError("Even alignment takes no data arguments")
        if op in ("align", "align0", "cnop", "cnop0"):
            check_literal_padding(code)
        if op == "dbglistinclude":
            item = re.fullmatch(r'dbglistinclude\s+"([^"\r\n]+)"', code, re.I)
            if not item or item[1] not in source_includes:
                raise ValueError("Debug list needs a literal checked data-source owner")
            dependencies.append(item[1])
        if op == "palscriptfile":
            item = re.fullmatch(r'palscriptfile\s+(\$[0-9A-Fa-f]+|[0-9]+)\s*,\s*"([^"\r\n]+)"', code, re.I)
            if not item:
                raise ValueError("Palette script file needs a literal frame count and manifest asset")
            frames = int(item[1][1:], 16) if item[1].startswith("$") else int(item[1])
            if not 1 <= frames <= 65536 or item[2] not in binary_includes:
                raise ValueError("Palette script file has invalid frames or no checked asset owner")
        if op not in DATA_OPS:
            raise ValueError("A data ledger contains executable or unknown syntax: " + op)
        depth += (op == "macro") - (op == "endm")
        if depth < 0:
            raise ValueError("Unbalanced data macro")
    if depth:
        raise ValueError("Unclosed data macro")
    if state_depth:
        raise ValueError("Unclosed data encoding context")
    return dependencies


def check_data_graph(dependencies):
    remaining = {name: len(set(children)) for name, children in dependencies.items()}
    parents = {name: set() for name in dependencies}
    for name, children in dependencies.items():
        for child in set(children):
            if child not in parents:
                raise ValueError("Included source has no data contract")
            parents[child].add(name)
    ready = [name for name, count in remaining.items() if not count]
    visited = 0
    while ready:
        child = ready.pop()
        visited += 1
        for parent in parents[child]:
            remaining[parent] -= 1
            if not remaining[parent]:
                ready.append(parent)
    if visited != len(dependencies):
        raise ValueError("Cyclic assembler data includes")


def check_added_annotations(row, text, source_includes=(), binary_includes=()):
    annotations = row.get("added_annotations", [])
    if not annotations:
        return
    if row.get("role") != "code" or len({a["name"] for a in annotations}) != len(annotations):
        raise ValueError("Invalid or duplicate terminal annotation owner")
    rows = statements(text)
    lines = text.splitlines(keepends=True)
    origin = row["origin"]
    for item in annotations:
        name = item["name"]
        if (
            item.get("kind") != "terminal-tail"
            or not item.get("reason")
            or not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", name)
        ):
            raise ValueError("Invalid terminal annotation contract")
        if (
            not origin["first_line"]
            <= item["origin_first_line"]
            <= item["origin_terminal_line"]
            <= item["origin_end_line"]
            <= origin["last_line"]
        ):
            raise ValueError("Terminal annotation leaves its historical source range")
        starts = [r["line"] for r in rows if r["label"] == name]
        ends = [r["line"] for r in rows if r["end"] == name]
        if len(starts) != 1 or len(ends) != 1 or starts[0] >= ends[0]:
            raise ValueError("Terminal annotation has no unique entry and closure")
        body = [r for r in rows if starts[0] <= r["line"] < ends[0]]
        if any(r["end"] for r in body):
            raise ValueError("Terminal annotation overlaps an existing procedure")
        instructions = [r for r in body if r["cpu"] == "68000" and r["op"].split(".")[0] in INSTRUCTIONS]
        if not instructions or instructions[-1]["op"].split(".")[0] not in TERMINALS:
            raise ValueError("Terminal annotation does not follow a terminal instruction")
        check_ledger("".join(lines[instructions[-1]["line"] : ends[0] - 1]), source_includes, binary_includes)


def validate_entry(row, text, inventory=False, source_includes=(), binary_includes=(), source_owners=None):
    lines = len(text.splitlines())
    if not row.get("owner") or not row.get("responsibility") or row.get("physical_lines") != lines:
        raise ValueError("Missing ownership or stale physical line count: " + row["path"])
    origin = row.get("origin", {})
    if (
        not origin.get("commit")
        or not origin.get("path")
        or origin.get("first_line", 0) < 1
        or origin.get("last_line", 0) < origin["first_line"]
    ):
        raise ValueError("Missing source range provenance")
    if row.get("status") != "owned":
        if inventory and row.get("status") == "pending":
            return False
        raise ValueError("Semantic extraction is pending: " + row["path"])
    if not row["path"].startswith("src/"):
        raise ValueError("Owned source is outside src")
    if re.fullmatch(r"(?:code|routine|room_part|part)_[0-9a-f]+", row["path"].rsplit("/", 1)[-1].split(".")[0], re.I):
        raise ValueError("Source module has only an address or page number")
    if row["role"] == "z80-driver":
        z80_driver.check_module(text, row.get("driver_contract", {}))
    elif row["role"] == "composition":
        contract = row.get("composition_contract", {})
        expected_space = "assembly-order" if contract.get("kind") == "entry" else "cartridge-rom"
        if row.get("address_space") != expected_space or source_owners is None:
            raise ValueError("Structural source needs its checked composition domain")
        composition_sources.check(text, contract, source_owners, binary_includes)
    elif row["role"] == "memory":
        if row.get("address_space") != "declarations":
            raise ValueError("Memory ownership needs its non-emitting declaration domain")
        memory_layout.declarations(text, row.get("memory_contract", {}))
    else:
        if row["role"] not in ("code", "data", "definitions"):
            raise ValueError("Unknown source ownership role")
        if row.get("address_space", "cartridge-rom") != "cartridge-rom":
            raise ValueError("Unsupported source address space requires an explicit checked contract")
    if row["role"] == "definitions":
        check_definitions(text)
    if row["role"] == "data":
        check_ledger(text, source_includes, binary_includes)
    check_added_annotations(row, text, source_includes, binary_includes)
    exception = row.get("size_exception", {})
    if lines > 900 and (not exception.get("kind") or not exception.get("reason") or not exception.get("proof_target")):
        raise ValueError("Large module needs a checkable cohesion exception")
    if lines > 2000 and (row["role"] != "data" or exception.get("kind") != "data-ledger"):
        raise ValueError("Executable module exceeds the hard review boundary")
    if (
        lines < 25
        and row["role"] != "data"
        and exception.get("kind")
        not in (
            ("vectors", "profile-entry", "fixed-address-tail", "include-order")
            if row["role"] == "composition"
            else ("vectors", "profile-entry", "fixed-address-tail")
        )
    ):
        raise ValueError("Tiny executable module needs a structural contract")
    if row["role"] == "code":
        document = collect_file(row["path"], text)
        if not document["returns"] and not document["procedures"]:
            raise ValueError("Executable ownership needs a real return or terminal procedure")
    return True


def parse_include_ranges(text, wanted):
    record = re.compile(r"^(?:\((\d+)\))?\s*(\d+)/\s*([A-Fa-f0-9]+)\s*:\s*(.*)$")
    include = re.compile(r'\binclude\s+"([^\"]+)"', re.I)
    active, result = [], []
    for line in text.splitlines():
        match = record.match(line)
        if not match:
            continue
        depth, address = int(match[1] or 0), int(match[3], 16)
        while active and depth <= active[-1]["depth"]:
            row = active.pop()
            if address < row["start"]:
                raise ValueError("ROM-owned data changes address space")
            result.append({"path": row["path"], "start": row["start"], "end": address})
        child = include.search(match[4])
        if child and child[1] in wanted:
            active.append({"path": child[1], "depth": depth, "start": address})
    if active:
        raise ValueError("Unclosed data include in AS listing")
    return result


def check_ranges(rows):
    binding = load("build/source_binding.json")
    if binding["source_sha256"] != source_fingerprint() or not binding["byte_identity_checked"]:
        raise ValueError("Source layout assembly binding is stale")
    owned = {
        r["path"]: r
        for r in rows
        if r["status"] == "owned" and r.get("address_space", "cartridge-rom") == "cartridge-rom"
    }
    actual = {name: [] for name in owned}
    registry = profiles()
    images = image_records()
    for key, profile in registry.items():
        if "compose" in profile:
            continue
        listing = (ROOT / "build/objects" / key / "main.lst").read_text(encoding="utf-8", errors="replace")
        for item in parse_include_ranges(listing, set(owned)):
            if item["end"] > images[key]["size"]:
                raise ValueError("Source data leaves its preservation image")
            if owned[item["path"]]["role"] == "definitions":
                check_nonemitting_range(item["start"], item["end"])
            actual[item["path"]].append({"profile": key, "start": item["start"], "end": item["end"]})
    for key, profile in registry.items():
        if "compose" not in profile:
            continue
        offset = 0
        for component in profile["compose"]:
            for values in actual.values():
                for item in list(values):
                    if item["profile"] == component:
                        values.append(
                            {
                                "profile": key,
                                "component": component,
                                "start": item["start"] + offset,
                                "end": item["end"] + offset,
                            }
                        )
            offset += images[component]["size"]
    order = lambda r: (r["profile"], r.get("component", ""), r["start"], r["end"])
    for path, row in owned.items():
        if sorted(row.get("rom_ranges", []), key=order) != sorted(actual[path], key=order):
            raise ValueError("Source data range differs from independent AS output: " + path)
    memory_layout.check_built(rows)
    composition_sources.check_built(rows)
    if any(row["role"] == "z80-driver" for row in rows):
        z80_driver.check_built(rows)


def check(inventory=False, built=False):
    registry = load("config/reconstruction/source_layout.json")
    rows = registry["files"]
    check_source_names(rows, tracked(ROOT))
    paths = [r["path"] for r in rows]
    if len(paths) != len(set(paths)) or set(paths) != set(source_names()):
        raise ValueError("Source ownership registry omits or duplicates files")
    texts = {row["path"]: (ROOT / row["path"]).read_text(encoding="utf-8") for row in rows}
    macro_count = check_data_macros(texts, load("config/reconstruction/data_macros.json"))
    memory_layout.check_primitives(texts)
    source_includes = {r["path"] for r in rows if r["status"] == "owned" and r["role"] == "data"}
    assets = load("assets/manifest.json")
    binary_includes = {assets["output"] + "/" + r["path"] for r in assets["assets"]}
    from scripts.authoring.driver_payloads import resolve_contract

    derived = resolve_contract(
        load("config/audio_driver_payloads.json"),
        {r["path"]: r for r in assets["assets"]},
        load("config/audio_streams.json")["engines"],
    )
    binary_includes.update(assets["output"] + "/" + r["path"] for r in derived)
    dependencies = {}
    structural = {}
    owners = {row["path"]: row for row in rows}
    if any(row["role"] == "composition" for row in rows):
        composition_sources.check_macros(texts, load("config/reconstruction/bank_macros.json"))
    accepted = 0
    for row in rows:
        text = texts[row["path"]]
        accepted += validate_entry(row, text, inventory, source_includes, binary_includes, source_owners=owners)
        if row["role"] == "composition":
            structural[row["path"]] = composition_sources.check(
                text, row["composition_contract"], owners, binary_includes
            )
        if row["path"] in source_includes:
            dependencies[row["path"]] = check_ledger(text, source_includes, binary_includes)
    if any(row["role"] == "z80-driver" for row in rows):
        z80_driver.check_sources(rows)
    check_data_graph(dependencies)
    composition_sources.check_order_graph(structural)
    pending = len(rows) - accepted
    if not inventory and (registry["state"] != "complete" or pending):
        raise ValueError("Semantic source layout is incomplete")
    if built:
        check_ranges(rows)
    report = {
        "complete": not pending and registry["state"] == "complete",
        "owned": accepted,
        "pending": pending,
        "data_macro_definitions": macro_count,
    }
    atomic(ROOT / "build/source_layout.json", (json.dumps(report, indent=2) + "\n").encode())
    print(
        ("[INCOMPLETE] " if pending else "[OK] ") + str(accepted) + " owned source files; " + str(pending) + " pending"
    )
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", action="store_true")
    parser.add_argument("--built", action="store_true")
    args = parser.parse_args(argv)
    check(args.inventory, args.built)
    return 0

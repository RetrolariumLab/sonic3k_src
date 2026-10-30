"""Check semantic ownership without treating pending modules as accepted layout."""

import argparse
import json
import re

from scripts.build.project import ROOT, atomic, image_records, load, profiles, source_fingerprint
from scripts.build.relocation import source_names
from scripts.validation.numeric_operands import code_part

DATA_OPS = frozenset(("dc.b", "dc.w", "dc.l", "even", "dbglistobj", "palptr", "macro", "endm", "equ"))


def check_ledger(text):
    depth = 0
    for line in text.splitlines():
        code = re.sub(r"^[A-Za-z_.][A-Za-z_0-9.]*:\s*", "", code_part(line).strip())
        if not code:
            continue
        op = code.split()[0].lower()
        if op not in DATA_OPS:
            raise ValueError("A data ledger contains executable or unknown syntax: " + op)
        depth += (op == "macro") - (op == "endm")
        if depth < 0:
            raise ValueError("Unbalanced data macro")
    if depth:
        raise ValueError("Unclosed data macro")


def validate_entry(row, text, inventory=False):
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
    if row["role"] == "data":
        check_ledger(text)
    exception = row.get("size_exception", {})
    if lines > 900 and (not exception.get("kind") or not exception.get("reason") or not exception.get("proof_target")):
        raise ValueError("Large module needs a checkable cohesion exception")
    if lines > 2000 and (row["role"] != "data" or exception.get("kind") != "data-ledger"):
        raise ValueError("Executable module exceeds the hard review boundary")
    if (
        lines < 25
        and row["role"] != "data"
        and exception.get("kind") not in ("vectors", "profile-entry", "fixed-address-tail")
    ):
        raise ValueError("Tiny executable module needs a structural contract")
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


def check(inventory=False, built=False):
    registry = load("config/reconstruction/source_layout.json")
    rows = registry["files"]
    paths = [r["path"] for r in rows]
    if len(paths) != len(set(paths)) or set(paths) != set(source_names()):
        raise ValueError("Source ownership registry omits or duplicates files")
    accepted = 0
    for row in rows:
        accepted += validate_entry(row, (ROOT / row["path"]).read_text(encoding="utf-8"), inventory)
    pending = len(rows) - accepted
    if not inventory and (registry["state"] != "complete" or pending):
        raise ValueError("Semantic source layout is incomplete")
    if built:
        check_ranges(rows)
    report = {"complete": not pending and registry["state"] == "complete", "owned": accepted, "pending": pending}
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

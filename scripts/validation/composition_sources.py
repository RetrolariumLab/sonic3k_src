"""Checked include order, original sound-bank wrappers and fixed cartridge tails."""

import argparse
import hashlib
import json
import re

from scripts.build.project import ROOT, atomic, load, profiles, source_fingerprint
from scripts.validation.data_macros import definition_blocks, body_statement
from scripts.validation.numeric_operands import code_part
from scripts.validation.symbols import parse_symbols
from scripts.validation.source_sharing import project_includes, shared_sources

LABEL = re.compile(r"^([A-Za-z_][A-Za-z_0-9]*):\s*")
MACROS = {"startbank", "finishbank", "startdacbank", "dac_setup", "offsetbanktableentry"}


def _compact(text):
    return re.sub(r"\s+", "", text).lower()


def _lines(text):
    return [code_part(line).strip() for line in text.splitlines() if code_part(line).strip()]


def check(text, contract, source_owners, binary_owners):
    kind = contract.get("kind")
    applicable = contract.get("profiles")
    if (
        not isinstance(applicable, list)
        or not applicable
        or len(set(applicable)) != len(applicable)
        or set(applicable) - {"s3-us", "s3-eu", "s3-jp", "sk"}
    ):
        raise ValueError("Structural source contract has invalid product applicability")
    lines = _lines(text)
    if kind in ("order", "entry"):
        if set(contract) != {"kind", "profiles"} or not lines:
            raise ValueError("Invalid source-order contract")
        includes = []
        for index, line in enumerate(lines):
            match = re.fullmatch(r'include\s+"([^"]+)"', line, re.I)
            if match and match[1] in source_owners:
                includes.append(match[1])
            elif kind == "entry" and index == len(lines) - 1 and line.lower() == "end":
                continue
            else:
                raise ValueError("Source order contains executable, binary or unchecked syntax")
        if not includes or (kind == "entry" and lines[-1].lower() != "end"):
            raise ValueError("Profile entry has no complete include order and END")
        return includes
    if kind == "tail":
        if set(contract) != {"kind", "product", "profiles"}:
            raise ValueError("Invalid cartridge-tail contract")
        expected = (
            ["org$200000", "endofrom:"]
            if contract["product"] == "s3"
            else ["if(*)&(*-1)", "cnop-1,2<<lastbit(*)", "dc.b$ff", "else", "even", "endif", "endofrom:", "org$200000"]
            if contract["product"] == "sk"
            else None
        )
        if [_compact(line) for line in lines] != expected:
            raise ValueError("Cartridge tail differs from its bounded original product template")
        return []
    if kind != "bank" or set(contract) != {
        "kind",
        "alignment",
        "start_symbol",
        "end_symbol",
        "profiles",
    }:
        raise ValueError("Unknown structural source contract")
    if contract["alignment"] not in ("start", "end"):
        raise ValueError("Unknown sound-bank alignment policy")
    count_start = count_finish = 0
    guards, guard, targets = [], 0, []
    for index, raw in enumerate(lines):
        label = LABEL.match(raw)
        name = label[1] if label else None
        body = raw[label.end() :].strip() if label else raw
        if guard:
            if guard == 1 and re.fullmatch(r'fatal\s+"[^"\r\n]+"', body, re.I):
                guard = 2
                continue
            if guard == 2 and body.lower() == "endif":
                guard = 0
                continue
            raise ValueError("Bank capacity guards can only contain a fatal diagnostic")
        if not body:
            if name not in {contract["start_symbol"], contract["end_symbol"]}:
                raise ValueError("Bank boundary has an undeclared label")
            continue
        match = re.fullmatch(r'(include|binclude)\s+"([^"]+)"', body, re.I)
        if match:
            if match[1].lower() == "include":
                owner = source_owners.get(match[2])
                if not owner or owner["role"] != "data":
                    raise ValueError("Bank source include has no data owner")
                targets.append(match[2])
            elif match[2] not in binary_owners:
                raise ValueError("Bank binary include has no extracted resource owner")
            continue
        parts = body.split(None, 1)
        op, args = parts[0].lower(), parts[1].strip() if len(parts) == 2 else ""
        if op in ("startbank", "startdacbank") and not args:
            if index != 0 or name != contract["start_symbol"] or contract["alignment"] != "start":
                raise ValueError("Bank start is not its declared aligned first statement")
            count_start += 1
        elif op == "finishbank" and not args:
            count_finish += 1
        elif op == "align" and args in ("2", "$10", "$1000"):
            continue
        elif (
            op == "cnop"
            and index == 0
            and contract["alignment"] == "end"
            and _compact(args) == "-size_of_snd_bank1,$8000"
        ):
            continue
        elif op == "if" and contract["alignment"] == "end":
            guards.append(_compact(args))
            guard = 1
        else:
            raise ValueError("Sound bank contains executable or unchecked syntax: " + body)
    if guard:
        raise ValueError("Unclosed sound-bank capacity guard")
    if contract["alignment"] == "start":
        if count_start != 1 or count_finish != 1 or guards:
            raise ValueError("Aligned bank lacks one start and finish")
    elif (
        count_start
        or count_finish
        or guards != ["snd_bank1_end-snd_bank1_start>$8000", "snd_bank1_end-snd_bank1_start>size_of_snd_bank1"]
    ):
        raise ValueError("End-aligned bank lacks its complete fixed-window capacity checks")
    return targets


def check_order_graph(dependencies):
    visiting, complete = set(), set()

    def visit(name):
        if name in visiting:
            raise ValueError("Cyclic canonical source order")
        if name in complete:
            return
        visiting.add(name)
        for child in dependencies.get(name, []):
            if child in dependencies:
                visit(child)
        visiting.remove(name)
        complete.add(name)

    for name in dependencies:
        visit(name)


def check_macros(texts, contract):
    if contract.get("schema_version") != 1 or {row["name"] for row in contract["definitions"]} != MACROS:
        raise ValueError("Sound-bank macro closure is missing or unsupported")
    actual = {}
    for source, text in texts.items():
        for name, first, last, body in definition_blocks(text):
            if name in MACROS:
                key = (source, name)
                if key in actual:
                    raise ValueError("Duplicate sound-bank helper definition")
                actual[key] = hashlib.sha256(body.encode()).hexdigest()
                statements = []
                for line in body.splitlines()[1:]:
                    code = body_statement(line)
                    if not code:
                        continue
                    op, *rest = code.split(None, 1)
                    op = op.lower()
                    allowed = {
                        "align",
                        "label",
                        "set",
                        "equ",
                        "if",
                        "elseif",
                        "else",
                        "endif",
                        "fatal",
                        "message",
                        "dc.b",
                        "dc.w",
                        "dc.attribute",
                        "endm",
                        "startbank",
                        "offsetbanktableentry.w",
                        "dac_setup",
                    }
                    if op not in allowed:
                        raise ValueError("Reviewed bank helper contains executable or unchecked syntax")
                    statements.append(_compact(code))
                if name == "dac_setup":
                    if (
                        statements[:3] != ['if"sampleratescale"==""', "dac_setupdacptr,1.0", "else"]
                        or sum(x.startswith("dac_setup") for x in statements) != 1
                    ):
                        raise ValueError("DAC setup recursion is not its bounded default-argument branch")
                elif any(x.startswith("dac_setup") for x in statements) and name != "startdacbank":
                    raise ValueError("Unexpected sound-bank helper dependency")
    expected = {(row["source"], row["name"]): row["sha256"] for row in contract["definitions"]}
    if len(expected) != len(contract["definitions"]) or actual != expected:
        raise ValueError("Sound-bank macro bodies differ from the reviewed declaration closure")
    return len(actual)


def check_bank_bounds(start, end, outer_start, outer_end, *, alignment, reservation=None):
    if any(type(value) is not int for value in (start, end, outer_start, outer_end)):
        raise ValueError("Bank bounds must be AS integers")
    if not outer_start <= start < end <= outer_end or end - start > 32768 or start // 32768 != (end - 1) // 32768:
        raise ValueError("Sound bank crosses its fixed Z80 32-KiB storage window")
    if alignment == "start":
        if start % 32768:
            raise ValueError("Sound bank start is not window aligned")
    elif alignment == "end":
        if (
            type(reservation) is not int
            or not 0 < reservation <= 32768
            or (start + reservation) % 32768
            or end > start + reservation
        ):
            raise ValueError("Initial music bank exceeds its end-aligned reservation")
    else:
        raise ValueError("Unknown sound-bank alignment policy")


def check_built(rows):
    selected = [row for row in rows if row["role"] == "composition"]
    if not selected:
        return {}
    binding = load("build/source_binding.json")
    if not binding["byte_identity_checked"] or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Composition proof requires current preservation assemblies")
    from scripts.authoring.formats_workflow import tooling_fingerprint

    witness = load("build/provenance/preservation-comparison.json")
    if (
        not witness.get("complete")
        or witness["source_sha256"] != source_fingerprint()
        or witness.get("tooling_sha256") != tooling_fingerprint()
    ):
        raise ValueError("Composition proof requires its current historical entry witness")
    result = {}
    configured = profiles()
    for row in selected:
        contract = row["composition_contract"]
        if contract["kind"] == "entry":
            actual = {key for key, profile in configured.items() if profile.get("entry") == row["path"]}
        else:
            actual = {use["profile"] for use in row.get("rom_ranges", []) if use["profile"] != "s3k"}
        if actual != set(contract["profiles"]):
            raise ValueError("Structural source applicability differs from active AS output")
    for key, profile in configured.items():
        if "compose" in profile:
            continue
        listing = (ROOT / "build/objects" / key / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        for row in selected:
            contract = row["composition_contract"]
            if key not in contract["profiles"]:
                continue
            if contract["kind"] == "entry":
                if profile["entry"] != row["path"]:
                    raise ValueError("Structural entry is not the profile's configured assembly root")
                continue
            uses = [use for use in row.get("rom_ranges", []) if use["profile"] == key]
            if len(uses) != 1:
                raise ValueError("Composition module has no unique current AS range")
            start, end = uses[0]["start"], uses[0]["end"]
            if contract["kind"] == "bank":
                actual_start = symbols[contract["start_symbol"]]
                actual_end = symbols[contract["end_symbol"]] if contract["end_symbol"] else end
                check_bank_bounds(
                    actual_start,
                    actual_end,
                    start,
                    end,
                    alignment=contract["alignment"],
                    reservation=symbols["Size_of_Snd_Bank1"] if contract["alignment"] == "end" else None,
                )
            elif contract["kind"] == "tail" and (end != 0x200000 or symbols["EndOfROM"] != 0x200000):
                raise ValueError("Cartridge tail does not finish at the original physical boundary")
        result[key] = True
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source_fingerprint(),
        "tooling_sha256": tooling_fingerprint(),
        "profiles": result,
        "modules": len(selected),
    }
    atomic(ROOT / "build/composition_sources.json", (json.dumps(report, indent=2) + "\n").encode())
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--built", action="store_true")
    args = parser.parse_args(argv)
    layout = load("config/reconstruction/source_layout.json")
    rows = layout["files"]
    variants = shared_sources(ROOT, layout)
    owners = {row["path"]: row for row in rows}
    assets = load("assets/manifest.json")
    binaries = {assets["output"] + "/" + row["path"] for row in assets["assets"]}
    texts = {row["path"]: (ROOT / row["path"]).read_text() for row in rows}
    check_macros(texts, load("config/reconstruction/bank_macros.json"))
    for row in rows:
        if row["role"] == "composition":
            text = project_includes(row["path"], texts[row["path"]], variants)
            check(text, row["composition_contract"], owners, binaries)
    if args.built:
        check_built(rows)
    print("[OK] Canonical source composition and fixed bank contracts")
    return 0

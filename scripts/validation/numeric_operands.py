"""Audit explicit numeric control, address-register, absolute and PC operands."""

import argparse
import json
from collections import Counter
import re

from scripts.build.project import ROOT, atomic, load, source_names

LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*):\s*")
NUMBER = re.compile(r"(?:\$[0-9a-f]+|0x[0-9a-f]+|[0-9][0-9a-f]*h|%[01]+|[0-9]+)", re.I)
MEMORY_OPS = frozenset(
    "add adda addi addq addx and andi asl asr bchg bclr bset btst chk clr cmp cmpa cmpi cmpm divs divu eor eori exg ext lea lsl lsr move movea movem movep muls mulu nbcd neg negx not or ori pea rol ror roxl roxr sbcd scc scs seq sf sge sgt shi sle slo sls slt smi sne spl st sub suba subi subq subx swap tas tst".split()
)
BRANCH = re.compile(r"(?:b(?:ra|sr|cc|cs|eq|ge|gt|hi|hs|le|lo|ls|lt|mi|ne|pl|vc|vs)|db\w+|jmp|jsr)(?:\.[swl])?$")


def code_part(line):
    quote = None
    for i, char in enumerate(line):
        if char in ("'", '"'):
            if quote is None:
                quote = char
            elif quote == char:
                quote = None
        elif char == ";" and quote is None:
            return line[:i]
    return line


def operands(text):
    result, start, depth, quote = [], 0, 0, None
    for i, char in enumerate(text):
        if char in ("'", '"'):
            if quote is None:
                quote = char
            elif quote == char:
                quote = None
        elif quote is None:
            depth += (char == "(") - (char == ")")
            if char == "," and depth == 0:
                result.append(text[start:i].strip())
                start = i + 1
    result.append(text[start:].strip())
    return result


def numeric_expression(text):
    """A literal arithmetic expression, without labels or current-PC symbols."""
    text = re.sub(r"\.[wl]$", "", text.strip(), flags=re.I).lstrip("#")
    remainder = NUMBER.sub("0", text)
    return bool(NUMBER.search(text)) and re.fullmatch(r"[0\s()+*/%&|^~<>+-]+", remainder) is not None


def integer(text):
    text = text.strip()
    if re.fullmatch(r"\$[0-9a-f]+", text, re.I):
        return int(text[1:], 16)
    if re.fullmatch(r"[0-9]+", text):
        return int(text)
    return None


def candidates(path, text):
    owner, cpu = "<file>", "68000"
    saved_cpus = []
    for number, line in enumerate(text.splitlines(), 1):
        code = code_part(line).strip()
        match = LABEL.match(code)
        if match:
            owner = match[1]
            code = code[match.end() :].strip()
        if not code:
            continue
        parts = code.split(None, 1)
        op = parts[0].lower()
        args = operands(parts[1]) if len(parts) == 2 else []
        if op == "save":
            saved_cpus.append(cpu)
        elif op == "restore":
            if not saved_cpus:
                raise ValueError("Unbalanced AS restore in " + path)
            cpu = saved_cpus.pop()
        elif op == "cpu" and args:
            cpu = args[0].lower()
        kinds = []
        if cpu in ("68000", "68010", "68020"):
            if BRANCH.fullmatch(op) and args and numeric_expression(args[-1]):
                kinds.append(("control", args[-1]))
            if op in ("lea", "pea") and args and numeric_expression(args[0]):
                kinds.append(("address-register", args[0]))
            if re.fullmatch(r"movea?\.[wl]", op) and len(args) == 2 and re.fullmatch(r"a[0-7]", args[1], re.I):
                if args[0].startswith("#") and numeric_expression(args[0]):
                    kinds.append(("immediate-address-register", args[0]))
            for arg in args:
                if op.split(".")[0] in MEMORY_OPS and not arg.startswith("#") and numeric_expression(arg):
                    kinds.append(("absolute-memory", arg))
                elif re.fullmatch(r"\(.+\)\.[wl]", arg, re.I) and numeric_expression(arg):
                    kinds.append(("absolute-memory", arg))
                match = re.fullmatch(r"(.+)\(pc(?:,.*)?\)", arg, re.I)
                if match and numeric_expression(match[1]):
                    kinds.append(("pc-displacement", arg))
            if op == "dc.l":
                for arg in args:
                    value = integer(arg)
                    if value is not None and 0x8000 <= value < 0x400000:
                        kinds.append(("rom-range-long", arg))
        elif cpu == "z80":
            if op in ("call", "jp", "jr", "djnz") and args and numeric_expression(args[-1]):
                kinds.append(("z80-control", args[-1]))
            if op == "ld" and len(args) == 2:
                for arg in args:
                    if arg.startswith("(") and numeric_expression(arg):
                        kinds.append(("z80-absolute-memory", arg))
        for kind, operand in kinds:
            yield {
                "path": path,
                "line": number,
                "owner": owner,
                "kind": kind,
                "operand": operand,
                "code": " ".join(code.split()),
            }


def check_records(records, exceptions):
    actual = Counter((r["path"], r["owner"], r["kind"], r["operand"]) for r in records)
    expected = Counter()
    for row in exceptions:
        key = (row["path"], row["owner"], row["kind"], row["operand"])
        if (
            key in expected
            or not row.get("reason")
            or not row.get("type")
            or row["count"] < 1
            or row["kind"] != "rom-range-long"
        ):
            raise ValueError("Invalid numeric scalar exception: " + str(key))
        expected[key] = row["count"]
    unexpected, stale = actual - expected, expected - actual
    if unexpected or stale:
        raise ValueError(
            "Numeric operand audit failed; unexpected=" + str(dict(unexpected)) + "; stale=" + str(dict(stale))
        )


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", action="store_true")
    args = parser.parse_args(argv)
    sources = source_names()
    rows = [row for p in sources for row in candidates(p, (ROOT / p).read_text(encoding="utf-8"))]
    atomic(
        ROOT / "build/audits/numeric_operands.json",
        (json.dumps({"sources": len(sources), "candidates": rows}, indent=2) + "\n").encode(),
    )
    if not args.inventory:
        check_records(rows, load("config/reconstruction/numeric_scalars.json")["exceptions"])
    print(
        "[OK] Numeric operand inventory: "
        + str(len(sources))
        + " sources, "
        + str(len(rows))
        + " classified candidates"
    )
    return 0

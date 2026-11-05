"""Audit explicit numeric control, address-register, absolute and PC operands."""

import argparse
import json
from collections import Counter
import re

from scripts.build.project import ROOT, atomic, load, source_names
from scripts.validation.constant_expressions import Resolver, merge_constants, qualify

LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*):\s*")
NUMBER = re.compile(r"(?:\$[0-9a-f]+|0x[0-9a-f]+|[0-9][0-9a-f]*h|%[01]+|[0-9]+)", re.I)
MEMORY_OPS = frozenset(
    "add adda addi addq addx and andi asl asr bchg bclr bset btst chk clr cmp cmpa cmpi cmpm divs divu eor eori exg ext lea lsl lsr move movea movem movep muls mulu nbcd neg negx not or ori pea rol ror roxl roxr sbcd scc scs seq sf sge sgt shi sle slo sls slt smi sne spl st sub suba subi subq subx swap tas tst".split()
)
BRANCH = re.compile(
    r"(?:b(?:ra|sr|cc|cs|eq|ge|gt|hi|hs|le|lo|ls|lt|mi|ne|pl|vc|vs)|"
    r"db(?:ra|t|f|hi|ls|cc|hs|cs|lo|ne|eq|vc|vs|pl|mi|ge|lt|gt|le)|jmp|jsr)(?:\.[swl])?$"
)
CONSTANT = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*)(?::\s*|\s+)(equ|set|:=|=)\s*(.+)$", re.I)
REGISTER = re.compile(r"(?<![\w.])(?:[ad][0-7]|pc|sp)(?![\w.])", re.I)
EXACT_TYPES = {
    "immediate-address-register": {"address-register-scalar"},
    "control": {"fixed-cartridge-interface"},
    "absolute-memory": {"fixed-cartridge-interface", "preserved-original-read"},
    "rom-range-long": {"external-cartridge-pointer", "cartridge-header-boundary", "bitmap-scanline"},
}


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


def constant_definitions(text):
    result, scope = {}, ""
    for line in text.splitlines():
        code = code_part(line).strip()
        definition = CONSTANT.fullmatch(code)
        label = LABEL.match(code)
        if definition:
            name = definition[1]
            if not name.startswith("."):
                scope = name
            name = qualify(name, scope).casefold()
            value = qualify(definition[3], scope)
            if value not in result.setdefault(name, []):
                result[name].append(value)
        elif label and not label[1].startswith("."):
            scope = label[1]
    return result


def physical(value, width="l"):
    if width.lower() == "w":
        value &= 0xFFFF
        if value & 0x8000:
            value -= 0x10000
    return value & 0xFFFFFF


def candidates(path, text, *, aliases=None):
    owner, cpu = "<file>", "68000"
    scope = ""
    resolver = Resolver(merge_constants(aliases or {}, constant_definitions(text)))
    saved_cpus = []

    def numeric_address(expression, width="l"):
        if REGISTER.search(expression) or re.fullmatch(r"[+-]+", expression.strip()):
            return False
        if numeric_expression(expression):
            return True
        if re.search(r"\.[wl]$", expression, re.I):
            width = expression[-1]
        expression = qualify(expression.lstrip("#"), scope)
        result = resolver.resolve(expression)
        return any(0 <= physical(value, width) < 0x400000 for value in result.values) or (
            result.unresolved and not result.symbolic
        )

    for number, line in enumerate(text.splitlines(), 1):
        code = code_part(line).strip()
        definition = CONSTANT.fullmatch(code)
        if definition:
            if not definition[1].startswith("."):
                owner = scope = definition[1]
            continue
        match = LABEL.match(code)
        if match:
            if not match[1].startswith("."):
                scope = match[1]
            owner = qualify(match[1], scope)
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
            if BRANCH.fullmatch(op) and args and numeric_address(args[-1]):
                kinds.append(("control", args[-1]))
            if op in ("lea", "pea") and args and numeric_address(args[0]):
                kinds.append(("address-register", args[0]))
            if re.fullmatch(r"movea?\.[wl]", op) and len(args) == 2 and re.fullmatch(r"a[0-7]|sp", args[1], re.I):
                if args[0].startswith("#") and numeric_address(args[0], op[-1]):
                    kinds.append(("immediate-address-register", args[0]))
            for arg in args:
                if op.split(".")[0] in MEMORY_OPS and not arg.startswith("#") and numeric_address(arg):
                    kinds.append(("absolute-memory", arg))
                elif re.fullmatch(r"\(.+\)\.[wl]", arg, re.I) and numeric_address(arg, arg[-1]):
                    kinds.append(("absolute-memory", arg))
                match = re.fullmatch(r"(.+)\(pc(?:,.*)?\)", arg, re.I)
                if match and numeric_address(match[1]):
                    kinds.append(("pc-displacement", arg))
            if op == "dc.l":
                for arg in args:
                    result = resolver.resolve(qualify(arg, scope))
                    if any(0x8000 <= value < 0x400000 for value in result.values):
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
                "values": sorted(resolver.resolve(qualify(operand.lstrip("#"), scope)).values),
            }


def check_records(records, exceptions):
    records = list(records)
    actual = Counter((r["path"], r["owner"], r["kind"], r["operand"]) for r in records)
    expected = Counter()
    for row in exceptions:
        key = (row["path"], row["owner"], row["kind"], row["operand"])
        if (
            key in expected
            or not row.get("reason")
            or not row.get("type")
            or type(row["count"]) is not int
            or row["count"] < 1
        ):
            raise ValueError("Invalid numeric scalar exception: " + str(key))
        exact = row["type"] in EXACT_TYPES.get(row["kind"], set())
        if exact:
            if (
                not isinstance(row.get("code"), str)
                or not row["code"].strip()
                or not isinstance(row.get("values"), list)
                or not row["values"]
                or any(type(value) is not int for value in row["values"])
                or sorted(set(row["values"])) != row["values"]
            ):
                raise ValueError("Invalid exact numeric exception: " + str(key))
            for record in records:
                if (record["path"], record["owner"], record["kind"], record["operand"]) == key:
                    if record["code"] != row["code"] or record.get("values") != row["values"]:
                        raise ValueError("Exact numeric exception changed instruction or value: " + str(key))
        elif row["kind"] != "rom-range-long" or row["type"] not in {
            "decimal-digit-weight",
            "signed-16.16-position-step",
        }:
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
    texts = {path: (ROOT / path).read_text(encoding="utf-8") for path in sources}
    aliases = merge_constants(*(constant_definitions(text) for text in texts.values()))
    rows = [row for path, text in texts.items() for row in candidates(path, text, aliases=aliases)]
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

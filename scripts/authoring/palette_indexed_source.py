"""Bounded byte/word/long declarations for indexed palette source."""

import re
from scripts.authoring import raw_source


def parse(text):
    if not isinstance(text, str) or len(text) > 0x100000:
        raise ValueError("Palette source must be bounded text")
    records = []
    for line in text.splitlines():
        code = line.split(";", 1)[0].strip()
        if not code:
            continue
        m = re.match("(" + raw_source.NAME.pattern + r"):\s*", code)
        if m:
            records.append({"label": m[1]})
            code = code[m.end() :].strip()
        if not code:
            continue
        if code.lower() == "even":
            records.append({"align": 2})
            continue
        m = re.fullmatch(r"dc\.([bwl])\s+(.+)", code, re.I)
        if not m:
            raise ValueError("Executable or unknown alternate palette declaration")
        operands = m[2].split(",")
        if not 0 < len(operands) <= 4096:
            raise ValueError("Palette operand capacity exceeded")
        records.append(
            {"width": {"b": 1, "w": 2, "l": 4}[m[1].lower()], "values": [raw_source.expression(x) for x in operands]}
        )
    if not 0 < len(records) <= 65536:
        raise ValueError("Palette declaration capacity exceeded")
    return records


def assemble(records, *, scope, base, external):
    if not isinstance(records, list) or not 0 < len(records) <= 65536:
        raise ValueError("Palette declaration list is unbounded")
    if (
        not isinstance(scope, str)
        or not raw_source.NAME.fullmatch(scope)
        or scope.startswith(".")
        or type(base) is not int
        or not 0 <= base < 0x400000
        or base % 2
    ):
        raise ValueError("Palette source base is not an aligned cartridge address")
    if not isinstance(external, dict) or any(
        not isinstance(n, str)
        or not raw_source.NAME.fullmatch(n)
        or n.startswith(".")
        or type(v) is not int
        or not 0 <= v <= 0xFFFFFFFF
        for n, v in external.items()
    ):
        raise ValueError("Palette external context is invalid")
    labels = {}
    cursor = 0
    current = scope
    for r in records:
        if not isinstance(r, dict):
            raise ValueError("Invalid palette declaration record")
        if set(r) == {"label"}:
            n = r["label"]
            if not isinstance(n, str) or not raw_source.NAME.fullmatch(n):
                raise ValueError("Invalid palette source label")
            name = raw_source.qualify(n, current)
            if name in labels:
                raise ValueError("Duplicate palette source label")
            labels[name] = base + cursor
            if not n.startswith("."):
                current = n
        elif set(r) == {"align"} and type(r["align"]) is int and r["align"] == 2:
            cursor += (base + cursor) & 1
        elif set(r) == {"width", "values"}:
            if (
                type(r["width"]) is not int
                or r["width"] not in (1, 2, 4)
                or not isinstance(r["values"], list)
                or not 0 < len(r["values"]) <= 4096
            ):
                raise ValueError("Invalid palette field width or capacity")
            for x in r["values"]:
                raw_source.validate_expression(x)
            cursor += r["width"] * len(r["values"])
        else:
            raise ValueError("Unknown palette source record fields")
        if cursor > 65536 or base + cursor > 0x400000:
            raise ValueError("Palette source byte allocation exceeded")
    symbols = external | labels
    out = bytearray()
    padding = []
    current = scope
    for r in records:
        if "label" in r:
            if not r["label"].startswith("."):
                current = r["label"]
        elif "align" in r:
            if (base + len(out)) & 1:
                padding.append(len(out))
                out.append(0)
        else:
            width = r["width"]
            bits = width * 8
            for expr in r["values"]:
                value = raw_source.evaluate(expr, symbols, current)
                if not -(1 << (bits - 1)) <= value < (1 << bits):
                    raise ValueError("Palette field exceeds its signed or unsigned width")
                out.extend((value & ((1 << bits) - 1)).to_bytes(width, "big"))
    if len(out) != cursor:
        raise ValueError("Palette source cursor differs from emitted length")
    return bytes(out), labels, padding


def render(records):
    lines = []
    for record in records:
        if "label" in record:
            lines.append(record["label"] + ":")
        elif "align" in record:
            lines.append("                even")
        else:
            lines.append(
                "                dc."
                + {1: "b", 2: "w", 4: "l"}[record["width"]]
                + " "
                + ",".join(raw_source._expression_source(x) for x in record["values"])
            )
    return "\n".join(lines) + "\n"


def rewrite(original, encoded, *, scope, base):
    from copy import deepcopy

    records = parse(original)
    prior, labels, padding = assemble(records, scope=scope, base=base, external={})
    if len(encoded) != len(prior):
        raise ValueError("Indexed palette source changes its byte allocation")
    rewritten = deepcopy(records)
    cursor = 0
    for record in rewritten:
        if "label" in record:
            continue
        if "align" in record:
            cursor += (base + cursor) & 1
            continue
        width = record["width"]
        for i, expr in enumerate(record["values"]):
            value = encoded[cursor : cursor + width]
            if raw_source._has_symbol(expr):
                if value != prior[cursor : cursor + width]:
                    raise ValueError("Indexed palette edit changes a structural symbol expression")
            else:
                record["values"][i] = {"integer": int.from_bytes(value, "big")}
            cursor += width
    text = render(rewritten)
    actual, names, pad = assemble(parse(text), scope=scope, base=base, external={})
    if actual != encoded or names != labels or pad != padding:
        raise ValueError("Indexed palette rendering changes labels, alignment or bytes")
    return text

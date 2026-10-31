"""Strict non-executable data declarations for retained content assembly.

Only labels, dc.b/dc.w and even are accepted. Expressions are bounded sums or
differences of integers and labels. There is no assembler control or include.
"""

import re

from scripts.authoring.graphics import _integer

NAME = re.compile(r"[A-Za-z_][A-Za-z_0-9]*")
ATOM = re.compile(r"(?:\$[0-9A-Fa-f]+|[0-9]+|[A-Za-z_][A-Za-z_0-9]*)")
TERM = re.compile(r"([+-]?)(\$[0-9A-Fa-f]+|[0-9]+|[A-Za-z_][A-Za-z_0-9]*)")


def _expression(text):
    if re.search(r"[A-Za-z_0-9$]\s+[A-Za-z_0-9$]", text):
        raise ValueError("Adjacent content expression operands")
    text = text.replace(" ", "").replace("\t", "")
    terms, cursor = [], 0
    for match in TERM.finditer(text):
        if match.start() != cursor or (cursor and not match[1]):
            raise ValueError("Unsupported content expression")
        token = match[2]
        value = int(token[1:], 16) if token.startswith("$") else int(token) if token.isdecimal() else token
        terms.append({"sign": -1 if match[1] == "-" else 1, "value": value})
        cursor = match.end()
    if not terms or cursor != len(text) or len(terms) > 16:
        raise ValueError("Unsupported or overlong content expression")
    return terms


def decode_source(text, *, external_symbols=None):
    if not isinstance(text, str) or len(text) > 0x100000:
        raise ValueError("Content assembly must be bounded text")
    records = []
    for line in text.splitlines():
        body = line.split(";", 1)[0].strip()
        if not body:
            continue
        label = re.match(r"([A-Za-z_][A-Za-z_0-9]*):", body)
        if label:
            records.append({"label": label[1]})
            body = body[label.end() :].strip()
            if not body:
                continue
        if body.lower() == "even":
            records.append({"align": 2})
            continue
        match = re.fullmatch(r"dc\.([bw])\s+(.+)", body, re.I)
        if not match:
            raise ValueError("Executable or unsupported content syntax: " + body)
        expressions = match[2].split(",")
        if len(expressions) > 4096:
            raise ValueError("Too many data operands")
        records.append(
            {"width": 1 if match[1].lower() == "b" else 2, "values": [_expression(value) for value in expressions]}
        )
    assemble(records, external_symbols=external_symbols)
    return records


def assemble(records, *, external_symbols=None):
    """Return bytes and local symbols without executing an assembler."""
    if not isinstance(records, list) or len(records) > 0x20000:
        raise ValueError("Content declaration count exceeds capacity")
    external_symbols = external_symbols or {}
    if not isinstance(external_symbols, dict) or any(
        not isinstance(k, str) or not NAME.fullmatch(k) or type(v) is not int or not -0xFFFFFFFF <= v <= 0xFFFFFFFF
        for k, v in external_symbols.items()
    ):
        raise ValueError("External content symbols must be named bounded integers")
    labels, size = {}, 0
    for record in records:
        if set(record) == {"label"}:
            name = record["label"]
            if not isinstance(name, str) or not NAME.fullmatch(name) or name in labels:
                raise ValueError("Invalid or duplicated content label")
            labels[name] = size
        elif set(record) == {"align"} and type(record["align"]) is int and record["align"] == 2:
            size += size & 1
        elif set(record) == {"width", "values"}:
            width = _integer(record["width"], 3, "Content field width")
            if not width or not isinstance(record["values"], list) or not record["values"]:
                raise ValueError("Content declaration needs byte or word operands")
            size += width * len(record["values"])
        else:
            raise ValueError("Unsupported content record")
        if size > 0x100000:
            raise ValueError("Content assembly exceeds allocation")
    output = bytearray()
    for record in records:
        if "label" in record:
            continue
        if "align" in record:
            output.extend(bytes(len(output) & 1))
            continue
        width = record["width"]
        for expression in record["values"]:
            if not isinstance(expression, list) or not 1 <= len(expression) <= 16:
                raise ValueError("Content expression must be a bounded term list")
            value = 0
            for term in expression:
                if set(term) != {"sign", "value"} or type(term["sign"]) is not int or term["sign"] not in (-1, 1):
                    raise ValueError("Invalid expression term")
                operand = term["value"]
                if isinstance(operand, str):
                    if operand not in labels and operand not in external_symbols:
                        raise ValueError("Unknown content label: " + operand)
                    operand = labels.get(operand, external_symbols.get(operand))
                elif type(operand) is not int or not 0 <= operand <= 0x100000:
                    raise ValueError("Content expression integer exceeds capacity")
                value += term["sign"] * operand
            bits = 8 * width
            if not -(1 << (bits - 1)) <= value < (1 << bits):
                raise ValueError("Content expression exceeds its field")
            output.extend((value & ((1 << bits) - 1)).to_bytes(width, "big"))
    return bytes(output), labels


def encode_source(records, *, external_symbols=None):
    """Render a validated model; comments are not part of the data encoding."""
    assemble(records, external_symbols=external_symbols)
    lines = []
    for record in records:
        if "label" in record:
            lines.append(record["label"] + ":")
        elif "align" in record:
            lines.append("                even")
        else:
            values = []
            for expression in record["values"]:
                text = ""
                for index, term in enumerate(expression):
                    sign = "-" if term["sign"] < 0 else "+" if index else ""
                    text += sign + str(term["value"])
                values.append(text)
            lines.append("                dc." + ("b" if record["width"] == 1 else "w") + "    " + ",".join(values))
    return "\n".join(lines) + "\n"

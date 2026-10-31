"""Bounded raw byte declarations with scoped labels and explicit bit flags."""

import re

TOKEN = re.compile(
    r"\$[A-Fa-f0-9]+|[0-9]+|(?:[A-Za-z_][A-Za-z_0-9]*|\.[A-Za-z_][A-Za-z_0-9]*)(?:\.[A-Za-z_][A-Za-z_0-9]*)*|[()+\-|]"
)
NAME = re.compile(r"(?:[A-Za-z_][A-Za-z_0-9]*|\.[A-Za-z_][A-Za-z_0-9]*)(?:\.[A-Za-z_][A-Za-z_0-9]*)*")


def expression(text):
    tokens, end = [], 0
    for match in TOKEN.finditer(text):
        if text[end : match.start()].strip():
            raise ValueError("Unsupported raw source expression")
        tokens.append(match[0])
        end = match.end()
    if text[end:].strip() or not tokens or len(tokens) > 128:
        raise ValueError("Raw source expression is empty, malformed or overlong")
    position = 0

    def atom(depth):
        nonlocal position
        if depth > 24 or position == len(tokens):
            raise ValueError("Raw expression nesting or operand is invalid")
        value = tokens[position]
        position += 1
        if value in ("+", "-"):
            return {"unary": value, "value": atom(depth + 1)}
        if value == "(":
            result = binary(0, depth + 1)
            if position == len(tokens) or tokens[position] != ")":
                raise ValueError("Unclosed raw expression parenthesis")
            position += 1
            return result
        if value.startswith("$"):
            return {"integer": int(value[1:], 16)}
        if value.isdecimal():
            return {"integer": int(value)}
        if NAME.fullmatch(value):
            return {"symbol": value}
        raise ValueError("Invalid raw expression operand")

    def binary(minimum, depth):
        nonlocal position
        result = atom(depth)
        precedence = {"|": 1, "+": 2, "-": 2}
        while position < len(tokens) and precedence.get(tokens[position], -1) >= minimum:
            op = tokens[position]
            rank = precedence[op]
            position += 1
            result = {"op": op, "left": result, "right": binary(rank + 1, depth + 1)}
        return result

    result = binary(0, 0)
    if position != len(tokens):
        raise ValueError("Adjacent operands or trailing raw expression tokens")
    return result


def parse(text):
    if not isinstance(text, str) or len(text) > 0x100000:
        raise ValueError("Raw source must be bounded declaration text")
    records = []
    for line in text.splitlines():
        body = line.split(";", 1)[0].strip()
        if not body:
            continue
        label = re.match("(" + NAME.pattern + r"):\s*", body)
        if label:
            records.append({"label": label[1]})
            body = body[label.end() :].strip()
        if not body:
            continue
        if body.lower() == "even":
            records.append({"align": 2})
            continue
        match = re.fullmatch(r"dc\.b\s+(.+)", body, re.I)
        if not match:
            raise ValueError("Raw source contains executable or unknown declarations")
        items = match[1].split(",")
        if len(items) > 4096:
            raise ValueError("Raw source byte declaration exceeds its operand capacity")
        records.append({"bytes": [expression(item) for item in items]})
    if not records or len(records) > 65536:
        raise ValueError("Raw source declaration count leaves its capacity")
    return records


def qualify(name, scope):
    return scope + name if name.startswith(".") else name


def evaluate(expr, symbols, scope):
    if "integer" in expr:
        value = expr["integer"]
        if not 0 <= value <= 0xFFFFFFFF:
            raise ValueError("Raw literal exceeds its bounded arithmetic domain")
        return value
    if "symbol" in expr:
        name = qualify(expr["symbol"], scope)
        if name not in symbols:
            raise ValueError("Undefined raw source symbol: " + name)
        return symbols[name]
    if "unary" in expr:
        value = evaluate(expr["value"], symbols, scope)
        return -value if expr["unary"] == "-" else value
    left, right = evaluate(expr["left"], symbols, scope), evaluate(expr["right"], symbols, scope)
    return left + right if expr["op"] == "+" else left - right if expr["op"] == "-" else left | right


def validate_expression(expr, depth=0, budget=None):
    if budget is None:
        budget = [0]
    budget[0] += 1
    if not isinstance(expr, dict) or depth > 24 or budget[0] > 128:
        raise ValueError("Raw expression exceeds its bounded tree shape")
    fields = set(expr)
    if fields == {"integer"}:
        if type(expr["integer"]) is not int or not 0 <= expr["integer"] <= 0xFFFFFFFF:
            raise ValueError("Raw literal exceeds its unsigned arithmetic domain")
    elif fields == {"symbol"}:
        if not isinstance(expr["symbol"], str) or not NAME.fullmatch(expr["symbol"]):
            raise ValueError("Invalid raw expression symbol")
    elif fields == {"unary", "value"} and expr["unary"] in ("+", "-"):
        validate_expression(expr["value"], depth + 1, budget)
    elif fields == {"op", "left", "right"} and expr["op"] in ("+", "-", "|"):
        validate_expression(expr["left"], depth + 1, budget)
        validate_expression(expr["right"], depth + 1, budget)
    else:
        raise ValueError("Unknown raw expression operation or fields")


def assemble(records, *, scope, base, external):
    if not isinstance(records, list) or not 0 < len(records) <= 65536:
        raise ValueError("Raw source record capacity exceeded")
    if not isinstance(external, dict) or any(
        not isinstance(k, str) or not NAME.fullmatch(k) or type(v) is not int or not 0 <= v <= 0xFFFFFFFF
        for k, v in external.items()
    ):
        raise ValueError("Raw external symbols must be bounded named integers")
    for record in records:
        if not isinstance(record, dict):
            raise ValueError("Raw declaration is not a record")
        if set(record) == {"label"}:
            if not isinstance(record["label"], str) or not NAME.fullmatch(record["label"]):
                raise ValueError("Invalid raw source label")
        elif set(record) == {"bytes"} and isinstance(record["bytes"], list) and 0 < len(record["bytes"]) <= 4096:
            for expr in record["bytes"]:
                validate_expression(expr)
        elif record != {"align": 2}:
            raise ValueError("Unknown raw source record fields")
    if (
        not isinstance(scope, str)
        or not NAME.fullmatch(scope)
        or scope.startswith(".")
        or type(base) is not int
        or not 0 <= base < 0x400000
    ):
        raise ValueError("Raw source has no bounded cartridge context")
    labels, cursor, current = {}, 0, scope
    for record in records:
        if "label" in record:
            name = qualify(record["label"], current)
            if name in labels:
                raise ValueError("Duplicate raw source label")
            labels[name] = base + cursor
            if not record["label"].startswith("."):
                current = record["label"]
        elif "bytes" in record:
            cursor += len(record["bytes"])
        elif record == {"align": 2}:
            cursor += (base + cursor) & 1
        else:
            raise ValueError("Unknown raw source record")
        if cursor > 65536:
            raise ValueError("Raw source allocation exceeds its fixed capacity")
    symbols = external | labels
    output, padding, current = bytearray(), [], scope
    for record in records:
        if "label" in record:
            if not record["label"].startswith("."):
                current = record["label"]
        elif "bytes" in record:
            for item in record["bytes"]:
                value = evaluate(item, symbols, current)
                if not -128 <= value <= 255:
                    raise ValueError("Raw source value exceeds its signed/unsigned byte")
                output.append(value & 255)
        else:
            if (base + len(output)) & 1:
                padding.append(len(output))
                output.append(0)
    if len(output) != cursor:
        raise ValueError("Raw source cursor and emitted size differ")
    return bytes(output), labels, padding


def _expression_source(expr):
    if "integer" in expr:
        return str(expr["integer"])
    if "symbol" in expr:
        return expr["symbol"]
    if "unary" in expr:
        return expr["unary"] + "(" + _expression_source(expr["value"]) + ")"
    return "(" + _expression_source(expr["left"]) + expr["op"] + _expression_source(expr["right"]) + ")"


def _has_symbol(expr):
    return (
        "symbol" in expr
        or "value" in expr
        and _has_symbol(expr["value"])
        or "left" in expr
        and (_has_symbol(expr["left"]) or _has_symbol(expr["right"]))
    )


def render(records):
    lines = []
    for record in records:
        if "label" in record:
            lines.append(record["label"] + ":")
        elif "bytes" in record:
            lines.append("                dc.b " + ",".join(_expression_source(x) for x in record["bytes"]))
        else:
            lines.append("                even")
    return "\n".join(lines) + "\n"


def encode_graph_source(original, model, *, entries, scope, base, external, stored=()):
    """Re-encode semantic byte fields while keeping every label and control edge."""
    from copy import deepcopy
    from scripts.authoring import raw_graph

    records = parse(original)
    data, labels, padding = assemble(records, scope=scope, base=base, external=external)
    prior = raw_graph.decode(data, entries, padding, stored)
    if raw_graph.structure(prior) != raw_graph.structure(model):
        raise ValueError("Raw source edits cannot change the original control or layout shape")
    encoded = raw_graph.encode(model)
    rewritten, cursor = deepcopy(records), 0
    for record in rewritten:
        if "label" in record:
            continue
        if "bytes" in record:
            for index, item in enumerate(record["bytes"]):
                if _has_symbol(item):
                    if encoded[cursor] != data[cursor]:
                        raise ValueError("Raw source edits cannot change structural symbol expressions")
                else:
                    record["bytes"][index] = {"integer": encoded[cursor]}
                cursor += 1
        else:
            cursor += (base + cursor) & 1
    text = render(rewritten)
    actual, actual_labels, actual_padding = assemble(parse(text), scope=scope, base=base, external=external)
    if actual != encoded or actual_labels != labels or actual_padding != padding:
        raise ValueError("Rendered raw source changes its semantic bytes, labels or alignment")
    return text, encoded

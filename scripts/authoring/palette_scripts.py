"""Strict palette-script declarations and their actual macro/runtime encoding."""

from copy import deepcopy
import re
from scripts.authoring.graphics import decode_palette, encode_palette

NAME = r"[A-Za-z_.][A-Za-z_0-9.]*"
TERM = re.compile(r"([+-]?)(\$[A-Fa-f0-9]+|[0-9]+|" + NAME + r")")
OPS = {
    "palscriptptr",
    "palscripthdr",
    "palscriptdata",
    "palscriptfile",
    "palscriptrept",
    "palscriptloop",
    "palscriptrun",
}


def expression(text):
    if re.search(r"[A-Za-z_0-9.$]\s+[A-Za-z_0-9.$]", text):
        raise ValueError("Adjacent palette expression operands")
    text = re.sub(r"\s+", "", text)
    tokens, cursor = [], 0
    for match in TERM.finditer(text):
        if match.start() != cursor or cursor and not match[1]:
            raise ValueError("Unsupported palette expression")
        value = match[2]
        value = int(value[1:], 16) if value.startswith("$") else int(value) if value.isdecimal() else value
        tokens.append({"sign": -1 if match[1] == "-" else 1, "value": value})
        cursor = match.end()
    if not tokens or cursor != len(text) or len(tokens) > 16:
        raise ValueError("Invalid or overlong palette expression")
    return tokens


def parse(text):
    if not isinstance(text, str) or len(text) > 0x100000:
        raise ValueError("Palette declarations must be bounded source text")
    records = []
    for line in text.splitlines():
        raw = line.split(";", 1)[0].strip()
        if not raw:
            continue
        label = re.match("(" + NAME + r"):\s*", raw)
        if label:
            records.append({"label": label[1]})
            raw = raw[label.end() :].strip()
        if not raw:
            continue
        parts = raw.split(None, 1)
        op, tail = parts[0].lower(), parts[1] if len(parts) == 2 else ""
        if op == "dc.w" and tail == "0":
            records.append({"op": "reserved-zero"})
        elif op == "even" and not tail:
            records.append({"op": "even"})
        elif op in ("palscriptrept", "palscriptrun") and not tail:
            records.append({"op": op})
        elif op == "palscriptfile":
            match = re.fullmatch(r'([^,]+),\s*"(data/[^"\r\n]+)"', tail)
            if not match or ".." in match[2].split("/") or "\\" in match[2]:
                raise ValueError("Palette frame include has no bounded literal data path")
            records.append({"op": op, "ticks": expression(match[1]), "path": match[2]})
        elif op in OPS:
            args = [expression(x.strip()) for x in tail.split(",")]
            if (
                op == "palscriptptr"
                and len(args) != 2
                or op == "palscripthdr"
                and len(args) != 3
                or op == "palscriptdata"
                and len(args) < 2
                or op == "palscriptloop"
                and len(args) != 1
            ):
                raise ValueError("Palette macro argument count differs from its ABI")
            records.append({"op": op, "args": args})
        else:
            raise ValueError("Executable or unknown palette source syntax")
    if not any(r.get("op") == "palscriptptr" for r in records):
        raise ValueError("A palette script needs at least one state initializer")
    if len(records) > 65536:
        raise ValueError("Palette declaration count exceeds its capacity")
    return records


def qualify(name, scope):
    return scope + name if name.startswith(".") else name


def _evaluate(terms, symbols, scope):
    value = 0
    for term in terms:
        atom = term["value"]
        if isinstance(atom, str):
            atom = qualify(atom, scope)
            if atom not in symbols:
                raise ValueError("Undefined palette symbol: " + atom)
            atom = symbols[atom]
        value += term["sign"] * atom
    return value


def assemble(records, *, scope, base, symbols, files):
    if not re.fullmatch(NAME, scope) or type(base) is not int or not 0 <= base < 0x400000:
        raise ValueError("Palette script has no bounded cartridge context")
    values, labels, cursor = dict(symbols), {}, 0
    current = scope
    sizes = []
    for record in records:
        if "label" in record:
            name = qualify(record["label"], current)
            if not record["label"].startswith("."):
                current = record["label"]
            if name in labels:
                raise ValueError("Duplicate palette source label")
            labels[name] = base + cursor
            sizes.append(0)
            continue
        op = record["op"]
        if op == "palscriptptr":
            size = 8
        elif op in ("palscripthdr", "palscriptloop"):
            size = 4
        elif op == "palscriptdata":
            size = len(record["args"]) * 2
        elif op == "palscriptfile":
            if record["path"] not in files:
                raise ValueError("Palette file frame has no checked resource context")
            size = len(files[record["path"]]) + 2
        elif op == "even":
            size = (base + cursor) & 1
        else:
            size = 2
        cursor += size
        sizes.append(size)
    if cursor > 0x10000:
        raise ValueError("Palette script exceeds its signed displacement storage")
    values.update(labels)
    output, models, current, header, entries = bytearray(), [], scope, None, None
    after_terminal = False
    for record, size in zip(records, sizes):
        if "label" in record:
            if not record["label"].startswith("."):
                current = record["label"]
            models.append({"label": record["label"]})
            continue
        op = record["op"]
        args = [_evaluate(x, values, current) for x in record.get("args", [])]
        if op == "palscriptptr":
            first, data = args
            delta = data - first
            if not 0 < delta < 32768 or not 0 <= first < 0x400000:
                raise ValueError("Palette initializer leaves its fixed cartridge ABI")
            output.extend(delta.to_bytes(2, "big") + b"\0\0" + first.to_bytes(4, "big"))
            header = first
            model = {"op": "initializer", "header": first, "data": data}
        elif op == "palscripthdr":
            destination, entries, limit = args
            after_terminal = False
            origin = symbols["Normal_palette"]
            if (
                destination % 2
                or not 1 <= entries <= 64
                or not origin <= destination <= origin + 128 - 2 * entries
                or not 0 <= limit <= 255
            ):
                raise ValueError("Palette destination, width or counter limit exceeds normal CRAM staging")
            output.extend((destination & 65535).to_bytes(2, "big") + bytes((entries - 1, limit)))
            model = {
                "op": "header",
                "color_offset": (destination - origin) // 2,
                "entries": entries,
                "counter_limit": limit,
            }
        elif op in ("palscriptdata", "palscriptfile"):
            ticks = args[0] if op == "palscriptdata" else _evaluate(record["ticks"], values, current)
            if op == "palscriptdata" and any(type(value) is not int or not 0 <= value <= 65535 for value in args[1:]):
                raise ValueError("Palette color leaves its unsigned word")
            raw = (
                b"".join(value.to_bytes(2, "big") for value in args[1:])
                if op == "palscriptdata"
                else files[record["path"]]
            )
            if not 2 <= len(raw) <= 128 or len(raw) % 2:
                raise ValueError("Stored palette frame exceeds the CRAM color capacity")
            if (
                entries is None
                or len(raw) != entries * 2
                and not after_terminal
                or not 1 <= ticks <= 128
                or int.from_bytes(raw[:2], "big") & 0x8000
            ):
                raise ValueError("Palette frame width, signed delay or first color collides with a command")
            colors = decode_palette(raw)
            if encode_palette(colors) != raw:
                raise ValueError("Palette color model differs from the original words")
            output.extend(encode_palette(colors) + (ticks - 1).to_bytes(2, "big"))
            model = {
                "op": "frame" if op == "palscriptdata" else "file-frame",
                "ticks": ticks,
                "colors": colors,
                "after_terminal": after_terminal,
            }
            if op == "palscriptfile":
                model["path"] = record["path"]
        elif op == "palscriptloop":
            target = args[0]
            delta = target - header
            if not -32768 <= delta <= 32767:
                raise ValueError("Palette next-header displacement exceeds its signed word")
            output.extend(bytes.fromhex("fff8") + (delta & 65535).to_bytes(2, "big"))
            header = target
            model = {"op": "next-header", "target": target}
        elif op in ("palscriptrept", "palscriptrun"):
            output.extend(bytes.fromhex("fffc" if op == "palscriptrept" else "fff4"))
            model = {"op": "repeat" if op == "palscriptrept" else "custom-routine"}
            after_terminal = True
        elif op == "reserved-zero":
            output.extend(b"\0\0")
            model = {"op": "reserved-zero"}
        elif op == "even":
            output.extend(bytes(size))
            model = {"op": "even"}
        else:
            raise ValueError("Unsupported palette record")
        models.append(model)
    if len(output) != cursor:
        raise ValueError("Palette semantic bytes leave their declaration allocation")
    return bytes(output), labels, models


def _literal(value):
    return [{"sign": 1, "value": value}]


def _expression_source(terms):
    output = ""
    for index, term in enumerate(terms):
        output += ("-" if term["sign"] < 0 else "+" if index else "") + str(term["value"])
    return output


def render(records):
    """Retain original local label spellings and the macro-local scope."""
    output = []
    for record in records:
        if "label" in record:
            output.append(record["label"] + ":")
            continue
        op = record["op"]
        if op == "reserved-zero":
            text = "dc.w 0"
        elif op == "palscriptfile":
            text = op + " " + _expression_source(record["ticks"]) + ',"' + record["path"] + '"'
        else:
            text = op + (" " + ",".join(_expression_source(x) for x in record["args"]) if "args" in record else "")
        output.append("                " + text)
    return "\n".join(output) + "\n"


def encode_models(records, models, *, scope, base, symbols, files):
    """Edit colors, delays and bounded destinations within the original graph."""
    original, labels, expected = assemble(records, scope=scope, base=base, symbols=symbols, files=files)
    if not isinstance(models, list) or len(models) != len(expected):
        raise ValueError("Palette semantic records differ from their original layout")
    rewritten = deepcopy(records)
    for record, model, prior in zip(rewritten, models, expected):
        if not isinstance(model, dict) or set(model) != set(prior):
            raise ValueError("Palette model fields differ from their declared operation")
        op = prior.get("op")
        if op in ("frame", "file-frame"):
            permitted = {"ticks", "colors"} if op == "frame" else {"ticks"}
            if any(model[key] != prior[key] for key in prior if key not in permitted):
                raise ValueError("Palette file ownership or stored-record status cannot change")
            ticks = model["ticks"]
            if type(ticks) is not int or not 1 <= ticks <= 128:
                raise ValueError("Palette delay exceeds its signed runtime counter")
            if op == "frame":
                if not isinstance(model["colors"], list) or len(model["colors"]) != len(prior["colors"]):
                    raise ValueError("Palette edit changes its stored color width")
                colors = encode_palette(model["colors"])
                if int.from_bytes(colors[:2], "big") & 0x8000:
                    raise ValueError("The first palette color collides with command dispatch")
                record["args"] = [_literal(ticks)] + [
                    _literal(int.from_bytes(colors[i : i + 2], "big")) for i in range(0, len(colors), 2)
                ]
            else:
                record["ticks"] = _literal(ticks)
        elif op == "header":
            if any(model[key] != prior[key] for key in prior if key != "color_offset"):
                raise ValueError("Palette width and counter graph are structural fields")
            offset = model["color_offset"]
            if type(offset) is not int or not 0 <= offset <= 64 - prior["entries"]:
                raise ValueError("Palette destination exceeds its normal staging allocation")
            record["args"][0] = [{"sign": 1, "value": "Normal_palette"}, {"sign": 1, "value": offset * 2}]
        elif model != prior:
            raise ValueError("Palette labels, initializer and transition graph cannot change")
    encoded, actual_labels, actual_models = assemble(rewritten, scope=scope, base=base, symbols=symbols, files=files)
    if len(encoded) != len(original) or actual_labels != labels or actual_models != models:
        raise ValueError("Palette edit changes an immutable footprint, label or semantic boundary")
    text = render(rewritten)
    if assemble(parse(text), scope=scope, base=base, symbols=symbols, files=files) != (encoded, labels, models):
        raise ValueError("Rendered palette source does not reproduce its semantic model")
    return text, encoded

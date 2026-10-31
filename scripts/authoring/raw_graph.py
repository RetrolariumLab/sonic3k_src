"""Closed raw animation graphs with typed overlapping views and explicit padding."""

from copy import deepcopy
from scripts.authoring.graphics import _bytes, _integer
from scripts.authoring import raw_animations as linear


def _entries(entries, size):
    if not isinstance(entries, (list, tuple)) or not entries or len(entries) > 4096:
        raise ValueError("Raw graph needs bounded explicit entry views")
    result = []
    for item in entries:
        if not isinstance(item, (list, tuple)) or len(item) != 2:
            raise ValueError("Raw graph entry must name a byte offset and ABI")
        offset, abi = item
        _integer(offset, size, "Raw graph entry")
        if abi not in linear.ABIS or (offset, abi) in result:
            raise ValueError("Raw graph entry ABI is unknown or duplicated")
        result.append((offset, abi))
    return sorted(result)


def _padding(padding, size):
    if not isinstance(padding, (list, tuple)) or len(padding) > size:
        raise ValueError("Raw graph padding must be an explicit bounded offset list")
    values = [_integer(x, size, "Raw alignment offset") for x in padding]
    if len(values) != len(set(values)):
        raise ValueError("Raw alignment offsets are duplicated")
    return sorted(values)


def node(data, start, abi):
    pairs, extended, flip = linear._mode(abi)
    header = (
        2
        if abi in ("accelerating", "decelerating")
        else 1
        if abi != "sentinel" and (abi.startswith("external-player") or not pairs)
        else 0
    )
    cursor = start + header
    if not 0 <= start < len(data) or cursor > len(data):
        raise ValueError("Raw graph header leaves its allocation")
    # D0 may transiently reach 256 after the byte cursor is widened. Extended
    # opcodes/jump operands are read after the frame byte at that position.
    maximum = (
        255
        if abi == "sentinel" or abi.startswith("external-player")
        else 256
        if pairs or abi == "decelerating"
        else 257
    )
    target = None
    while cursor < len(data):
        if cursor - start > maximum:
            raise ValueError("Raw runtime cursor wraps before reaching a command")
        value = data[cursor]
        cursor += 1
        if abi == "sentinel":
            if value == 255:
                break
            continue
        if abi in ("accelerating", "decelerating"):
            if value & 128:
                break
            continue
        if abi.startswith("external-player"):
            if value == (255 if abi == "external-player-s3" else 0):
                break
            cursor += 1
        else:
            command = value == 255 if extended else bool(value & 128)
            if command:
                if extended:
                    if cursor == len(data):
                        raise ValueError("Missing extended raw opcode")
                    value = data[cursor]
                    cursor += 1
                if value not in linear.COMMANDS:
                    raise ValueError("Unknown raw dispatch slot")
                if value == 248:
                    if cursor == len(data):
                        raise ValueError("Missing raw base displacement")
                    value = data[cursor]
                    target = start + (value - 256 if value & 128 else value)
                    cursor += 1
                break
            if pairs:
                cursor += 1
        if cursor > len(data):
            raise ValueError("Raw graph ends inside a frame")
    raw = data[start:cursor]
    model = linear.decode(raw, abi=abi)
    return {"offset": start, "abi": abi, "model": model, "target": target}


def decode(data, entries, padding=()):
    raw = _bytes(data)
    if not 0 < len(raw) <= 65536:
        raise ValueError("Raw graph allocation is empty or overlong")
    entries = _entries(entries, len(raw))
    padding = _padding(padding, len(raw))
    pending, seen, nodes = list(entries), set(), []
    while pending:
        start, abi = pending.pop()
        if (start, abi) in seen:
            continue
        seen.add((start, abi))
        if len(seen) > 4096:
            raise ValueError("Raw graph node capacity exceeded")
        item = node(raw, start, abi)
        nodes.append(item)
        if item["target"] is not None:
            _integer(item["target"], len(raw), "Raw jump target")
            pending.append((item["target"], abi))
    model = {
        "size": len(raw),
        "entries": [list(x) for x in entries],
        "padding": padding,
        "nodes": sorted(nodes, key=lambda x: (x["offset"], x["abi"])),
    }
    if _encode(model) != raw:
        raise ValueError("Raw semantic encoding differs from the original allocation")
    return model


def _encode(model):
    if not isinstance(model, dict) or set(model) != {"size", "entries", "padding", "nodes"}:
        raise ValueError("Raw graph model fields differ from the format")
    size = _integer(model["size"], 65537, "Raw graph allocation")
    if not size:
        raise ValueError("Raw graph allocation is empty")
    _entries(model["entries"], size)
    padding = _padding(model["padding"], size)
    if not isinstance(model["nodes"], list) or not 0 < len(model["nodes"]) <= 4096:
        raise ValueError("Raw graph node count exceeds its capacity")
    output = [None] * size

    def put(start, raw):
        if type(start) is not int or not 0 <= start <= start + len(raw) <= size:
            raise ValueError("Raw graph record exceeds its allocation")
        for index, value in enumerate(raw, start):
            if output[index] is not None and output[index] != value:
                raise ValueError("Aliased raw graph views disagree")
            output[index] = value

    for offset in padding:
        put(offset, b"\0")
    seen = set()
    for item in model["nodes"]:
        if not isinstance(item, dict) or set(item) != {"offset", "abi", "model", "target"}:
            raise ValueError("Raw graph node fields differ from the format")
        identity = (item["offset"], item["abi"])
        if identity in seen:
            raise ValueError("Raw graph node is duplicated")
        seen.add(identity)
        raw = linear.encode(item["model"], target_abi=item["abi"])
        put(item["offset"], raw)
    if any(value is None for value in output):
        raise ValueError("Raw graph has unmodeled stored bytes")
    return bytes(output)


def encode(model):
    result = _encode(model)
    if decode(result, model["entries"], model["padding"]) != model:
        raise ValueError("Raw graph edits change its declared topology or node boundaries")
    return result


def structure(model):
    """Immutable control/layout shape for value-only source edits."""
    result = deepcopy(model)
    for item in result["nodes"]:
        body = item["model"]
        body["header"] = sorted(body["header"])
        body["tokens"] = [
            {"op": "frame", "fields": sorted(token)} if token["op"] == "frame" else token for token in body["tokens"]
        ]
    return result

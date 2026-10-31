"""Typed standard, player and per-frame-delay animation command streams."""

from scripts.authoring.graphics import _bytes, _integer

ABIS = frozenset(("object-delay", "player-delay", "frame-delay"))
PARAMETERS = {"rewind": 0xFE, "change-animation": 0xFD}
SIMPLE = {"restart": 0xFF, "advance-routine": 0xFC, "move-offscreen": 0xFB}


def decode(data, *, abi):
    if abi not in ABIS:
        raise ValueError("Unknown animation interpreter ABI")
    raw = _bytes(data)
    if not raw or len(raw) > 65536:
        raise ValueError("Animation script is empty or exceeds its fixed allocation")
    timing, cursor = None, 0
    if abi != "frame-delay":
        timing = (
            {"mode": "selector", "value": raw[0] - 256}
            if abi == "player-delay" and raw[0] >= 0x80
            else {"mode": "ticks", "value": raw[0]}
        )
        cursor = 1
    tokens = []
    while cursor < len(raw):
        value = raw[cursor]
        cursor += 1
        threshold = 0xFC if abi == "player-delay" else 0x80
        if value < threshold:
            token = {"op": "frame", "frame": value}
            if abi == "frame-delay":
                if cursor == len(raw):
                    raise ValueError("Animation frame has no delay")
                token["ticks"] = raw[cursor]
                cursor += 1
        elif value in (0xFE, 0xFD):
            if cursor == len(raw):
                raise ValueError("Animation command has no argument")
            token = {"op": "rewind" if value == 0xFE else "change-animation", "value": raw[cursor]}
            cursor += 1
        elif value == 0xFF:
            token = {"op": "restart"}
        elif value == 0xFC and abi != "player-delay":
            token = {"op": "advance-routine"}
            # Irregular-delay indexing advances by pairs, including commands.
            # A final command may be followed only by external even alignment.
            if abi == "frame-delay" and cursor < len(raw):
                token["skipped_byte"] = raw[cursor]
                cursor += 1
        elif value == 0xFB and abi == "object-delay":
            token = {"op": "move-offscreen"}
        else:
            token = {"op": "hold", "code": value}
        tokens.append(token)
    return {"abi": abi, "timing": timing, "tokens": tokens}


def encode(model, *, target_abi):
    if target_abi not in ABIS or set(model) != {"abi", "timing", "tokens"} or model["abi"] != target_abi:
        raise ValueError("Animation model differs from its target interpreter ABI")
    output = bytearray()
    timing = model["timing"]
    if target_abi == "frame-delay":
        if timing is not None:
            raise ValueError("Per-frame timing has no shared delay header")
    else:
        if not isinstance(timing, dict) or set(timing) != {"mode", "value"}:
            raise ValueError("Animation delay header is malformed")
        value = timing["value"]
        if timing["mode"] == "ticks":
            _integer(value, 128 if target_abi == "player-delay" else 256, "Animation delay")
        elif timing["mode"] == "selector" and target_abi == "player-delay":
            if type(value) is not int or not -128 <= value < 0:
                raise ValueError("Dynamic player timing selector leaves its signed byte")
        else:
            raise ValueError("Unsupported animation timing mode")
        output.append(value & 255)
    if not isinstance(model["tokens"], list) or len(model["tokens"]) > 65536:
        raise ValueError("Animation token capacity exceeded")
    for token in model["tokens"]:
        op = token.get("op")
        if op == "frame":
            expected = {"op", "frame", "ticks"} if target_abi == "frame-delay" else {"op", "frame"}
            if set(token) != expected:
                raise ValueError("Animation frame fields differ from their timing ABI")
            output.append(_integer(token["frame"], 252 if target_abi == "player-delay" else 128, "Animation frame"))
            if target_abi == "frame-delay":
                output.append(_integer(token["ticks"], 256, "Animation frame delay"))
        elif op in PARAMETERS and set(token) == {"op", "value"}:
            output.extend((PARAMETERS[op], _integer(token["value"], 256, "Animation command argument")))
        elif op == "restart" and set(token) == {"op"}:
            output.append(0xFF)
        elif op == "advance-routine" and target_abi != "player-delay":
            if (
                set(token) not in ({"op"}, {"op", "skipped_byte"})
                or "skipped_byte" in token
                and target_abi != "frame-delay"
            ):
                raise ValueError("Routine command has an invalid skipped delay byte")
            output.append(0xFC)
            if "skipped_byte" in token:
                output.append(_integer(token["skipped_byte"], 256, "Skipped animation command byte"))
        elif op == "move-offscreen" and target_abi == "object-delay" and set(token) == {"op"}:
            output.append(0xFB)
        elif op == "hold" and set(token) == {"op", "code"}:
            code = _integer(token["code"], 256, "Animation no-progress opcode")
            if (
                not 128
                <= code
                <= (252 if target_abi == "player-delay" else 251 if target_abi == "frame-delay" else 250)
            ):
                raise ValueError("No-progress opcode overlaps a defined command")
            output.append(code)
        else:
            raise ValueError("Unknown or malformed animation command")
    if not output or len(output) > 65536:
        raise ValueError("Animation output is empty or exceeds its fixed allocation")
    # Adjacent commands cannot change how a skipped byte or argument is consumed.
    if decode(bytes(output), abi=target_abi) != model:
        raise ValueError("Animation token boundaries do not match the interpreter")
    return bytes(output)

"""Explicit ABIs for the retained raw sprite animation interpreters."""

from scripts.authoring.graphics import _bytes, _integer
from scripts.authoring import raw_special

ABIS = frozenset(
    (
        "fixed",
        "fixed-flip-x",
        "fixed-flip-y",
        "pairs",
        "pairs-flip-x",
        "pairs-flip-y",
        "extended-fixed",
        "extended-pairs",
        "accelerating",
        "decelerating",
        "external-player-sk",
        "external-player-s3",
        "sentinel",
        "counted",
        "delta-frames",
        "negative-sentinel",
        "paired-lanes",
    )
)
COMMANDS = {0xFC: "restart", 0xF8: "jump", 0xF4: "custom-routine"}


def _mode(abi):
    if abi not in ABIS:
        raise ValueError("Unknown raw animation interpreter ABI")
    pairs = abi in ("pairs", "pairs-flip-x", "pairs-flip-y", "extended-pairs") or abi.startswith("external-player")
    extended = abi.startswith("extended-")
    flip = "x" if abi.endswith("-x") else "y" if abi.endswith("-y") else None
    return pairs, extended, flip


def decode(data, *, abi):
    if abi in raw_special.ABIS:
        return raw_special.decode(data, abi=abi)
    pairs, extended, flip = _mode(abi)
    raw = _bytes(data)
    if not raw or len(raw) > 65536:
        raise ValueError("Raw animation must occupy a bounded nonempty source span")
    header, cursor = {}, 0
    if abi == "accelerating":
        if len(raw) < 3:
            raise ValueError("Accelerating animation lacks its two control bytes and frames")
        header = {"initial_counter": raw[0], "completion_limit": raw[1]}
        cursor = 2
    elif abi == "decelerating":
        if len(raw) < 3:
            raise ValueError("Decelerating animation lacks its shared limit/frame byte")
        header = {"maximum_counter": raw[0], "completion_limit_and_restart_frame": raw[1]}
        cursor = 2
    elif abi != "sentinel" and (abi.startswith("external-player") or not pairs):
        header = {"delay_counter": raw[0]}
        cursor = 1
    tokens = []
    while cursor < len(raw):
        code = raw[cursor]
        cursor += 1
        if abi == "sentinel":
            token = {"op": "restart"} if code == 255 else {"op": "frame", "frame": code}
            tokens.append(token)
            if code == 255:
                break
            continue
        if abi in ("accelerating", "decelerating"):
            if code & 0x80:
                tokens.append({"op": "cycle-end", "marker": code})
                break
            else:
                tokens.append({"op": "frame", "frame": code})
            continue
        if abi.startswith("external-player"):
            if code == (255 if abi == "external-player-s3" else 0):
                tokens.append({"op": "custom-routine"})
                break
            else:
                if cursor == len(raw):
                    raise ValueError("External-player frame lacks its flip flag byte")
                tokens.append({"op": "frame", "frame": code, "flip_flag": raw[cursor]})
                cursor += 1
            continue
        command = code == 0xFF if extended else bool(code & 0x80)
        if command:
            if extended:
                if cursor == len(raw):
                    raise ValueError("Extended raw animation has a lone command prefix")
                code = raw[cursor]
                cursor += 1
            if code not in COMMANDS:
                raise ValueError("Raw animation opcode enters an unregistered dispatch slot")
            token = {"op": COMMANDS[code]}
            if code == 0xF8:
                if cursor == len(raw):
                    raise ValueError("Raw animation jump lacks its signed base displacement")
                token["base_displacement"] = raw[cursor] - 256 if raw[cursor] & 128 else raw[cursor]
                cursor += 1
            tokens.append(token)
            break
        token = {"op": "frame", "frame": code & 63 if flip else code}
        if flip:
            token["toggle_" + flip] = bool(code & 64)
        if pairs:
            if cursor == len(raw):
                raise ValueError("Raw animation frame lacks its delay counter")
            token["delay_counter"] = raw[cursor]
            cursor += 1
        tokens.append(token)
    if cursor != len(raw) or not tokens or tokens[-1]["op"] == "frame":
        raise ValueError("A raw substream must end at its command; use the graph codec for continuations")
    return {"abi": abi, "header": header, "tokens": tokens}


def encode(model, *, target_abi):
    if target_abi in raw_special.ABIS:
        return raw_special.encode(model, target_abi=target_abi)
    pairs, extended, flip = _mode(target_abi)
    if set(model) != {"abi", "header", "tokens"} or model["abi"] != target_abi:
        raise ValueError("Raw animation model differs from its target interpreter")
    header = model["header"]
    keys = (
        ("initial_counter", "completion_limit")
        if target_abi == "accelerating"
        else ("maximum_counter", "completion_limit_and_restart_frame")
        if target_abi == "decelerating"
        else ("delay_counter",)
        if target_abi != "sentinel" and (target_abi.startswith("external-player") or not pairs)
        else ()
    )
    if not isinstance(header, dict) or set(header) != set(keys):
        raise ValueError("Raw animation header differs from its consumer ABI")
    output = bytearray(_integer(header[key], 256, "Raw animation control byte") for key in keys)
    if not isinstance(model["tokens"], list) or len(model["tokens"]) > 65536:
        raise ValueError("Raw animation token capacity exceeded")
    commands = {value: key for key, value in COMMANDS.items()}
    for token in model["tokens"]:
        op = token.get("op")
        if op == "frame":
            fields = {"op", "frame"}
            if target_abi.startswith("external-player"):
                fields.add("flip_flag")
            elif pairs:
                fields.add("delay_counter")
            if flip:
                fields.add("toggle_" + flip)
            if set(token) != fields:
                raise ValueError("Raw animation frame fields differ from the target ABI")
            limit = (
                (255 if target_abi == "external-player-s3" else 256)
                if target_abi.startswith("external-player")
                else 255
                if extended or target_abi == "sentinel"
                else 64
                if flip
                else 128
            )
            value = _integer(token["frame"], limit, "Raw animation frame")
            if target_abi.startswith("external-player") and value == (255 if target_abi == "external-player-s3" else 0):
                raise ValueError("External-player frame collides with its custom routine sentinel")
            if flip:
                flag = token["toggle_" + flip]
                if type(flag) is not bool:
                    raise ValueError("Raw animation flip toggle must be boolean")
                value |= int(flag) << 6
            output.append(value)
            if target_abi.startswith("external-player"):
                output.append(_integer(token["flip_flag"], 256, "Raw external-player flip flag"))
            elif pairs:
                output.append(_integer(token["delay_counter"], 256, "Raw animation delay counter"))
        elif op == "cycle-end" and target_abi in ("accelerating", "decelerating") and set(token) == {"op", "marker"}:
            value = _integer(token["marker"], 256, "Raw animation cycle marker")
            if value < 128:
                raise ValueError("Raw animation cycle marker must be negative")
            output.append(value)
        elif target_abi == "sentinel" and token == {"op": "restart"}:
            output.append(255)
        elif target_abi.startswith("external-player") and op == "custom-routine" and set(token) == {"op"}:
            output.append(255 if target_abi == "external-player-s3" else 0)
        elif (
            target_abi not in ("accelerating", "decelerating")
            and not target_abi.startswith("external-player")
            and op in commands
        ):
            if set(token) != ({"op", "base_displacement"} if op == "jump" else {"op"}):
                raise ValueError("Raw command fields differ from their dispatch ABI")
            if extended:
                output.append(0xFF)
            output.append(commands[op])
            if op == "jump":
                value = token["base_displacement"]
                if type(value) is not int or not -128 <= value <= 127:
                    raise ValueError("Raw animation base displacement exceeds its signed byte")
                output.append(value & 255)
        else:
            raise ValueError("Unknown raw animation command")
    if not output or len(output) > 65536 or decode(bytes(output), abi=target_abi) != model:
        raise ValueError("Raw animation token boundaries differ from its consumer")
    return bytes(output)

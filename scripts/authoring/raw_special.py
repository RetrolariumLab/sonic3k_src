"""Counted plane frames and four-byte moving frames used by dedicated readers."""

from scripts.authoring.graphics import _bytes, _integer

ABIS = frozenset(("counted", "delta-frames", "negative-sentinel", "paired-lanes"))


def length(data, start, abi):
    raw = _bytes(data)
    _integer(start, len(raw), "Dedicated raw source entry")
    if abi in ("negative-sentinel", "paired-lanes"):
        end = next((i for i in range(start, len(raw)) if raw[i] & 128), None)
        if end is None or end == start:
            raise ValueError("Particle animation lacks frames or a negative restart marker")
        size = end - start + 1 if abi == "negative-sentinel" else 2 * (end - start) + 1
        if start + size > len(raw):
            raise ValueError("Particle animation secondary lane leaves its storage")
        return size
    if abi == "counted":
        if start + 2 > len(raw) or raw[start + 1] == 0:
            raise ValueError("Counted animation needs a nonzero frame count")
        end = start + 2 + raw[start + 1]
        if end > len(raw):
            raise ValueError("Counted animation exceeds its declared frame storage")
        return end - start
    if abi != "delta-frames":
        raise ValueError("Unknown dedicated raw ABI")
    cursor = start
    while cursor < len(raw) and cursor - start <= 252:
        if raw[cursor] & 128:
            return cursor - start + 1
        cursor += 4
    raise ValueError("Moving animation has no terminator before its byte cursor wraps")


def decode(data, *, abi):
    raw = _bytes(data)
    if length(raw, 0, abi) != len(raw):
        raise ValueError("Dedicated raw substream includes bytes beyond its reader")
    if abi in ("negative-sentinel", "paired-lanes"):
        count = next(i for i, value in enumerate(raw) if value & 128)
        header = {"secondary_offset": count + 1} if abi == "paired-lanes" else {}
        tokens = [
            {"op": "frame", "frame": value} | ({"secondary_frame": raw[count + 1 + i]} if abi == "paired-lanes" else {})
            for i, value in enumerate(raw[:count])
        ]
        tokens.append({"op": "restart", "marker": raw[count]})
    elif abi == "counted":
        header = {"delay_counter": raw[0], "frame_count": raw[1]}
        tokens = [{"op": "frame", "frame": value} for value in raw[2:]] + [{"op": "count-loop"}]
    else:
        header, tokens = {}, []
        for cursor in range(0, len(raw) - 1, 4):
            tokens.append(
                {
                    "op": "frame",
                    "frame": raw[cursor],
                    "delay_counter": raw[cursor + 1],
                    "dx": raw[cursor + 2] - 256 if raw[cursor + 2] & 128 else raw[cursor + 2],
                    "dy": raw[cursor + 3] - 256 if raw[cursor + 3] & 128 else raw[cursor + 3],
                }
            )
        tokens.append({"op": "delete", "marker": raw[-1]})
    return {"abi": abi, "header": header, "tokens": tokens}


def _encode_particles(model, target_abi):
    if (
        not isinstance(model, dict)
        or set(model) != {"abi", "header", "tokens"}
        or model["abi"] != target_abi
        or not isinstance(model["tokens"], list)
        or not 1 < len(model["tokens"]) <= 32768
    ):
        raise ValueError("Particle frame model is malformed or exceeds its bounded cursor")
    frames, end = model["tokens"][:-1], model["tokens"][-1]
    expected_header = {"secondary_offset": len(frames) + 1} if target_abi == "paired-lanes" else {}
    if model["header"] != expected_header:
        raise ValueError("Particle secondary offset differs from the physical primary lane")
    output, secondary = bytearray(), bytearray()
    for frame in frames:
        fields = {"op", "frame", "secondary_frame"} if target_abi == "paired-lanes" else {"op", "frame"}
        if not isinstance(frame, dict) or set(frame) != fields or frame["op"] != "frame":
            raise ValueError("Particle frame fields differ from their reader")
        output.append(_integer(frame["frame"], 128, "Particle primary frame"))
        if target_abi == "paired-lanes":
            secondary.append(_integer(frame["secondary_frame"], 256, "Particle secondary frame"))
    if not isinstance(end, dict) or set(end) != {"op", "marker"} or end["op"] != "restart":
        raise ValueError("Particle animation needs a negative restart marker")
    marker = _integer(end["marker"], 256, "Particle restart marker")
    if marker < 128:
        raise ValueError("Particle restart marker must be negative")
    output.append(marker)
    output.extend(secondary)
    result = bytes(output)
    if decode(result, abi=target_abi) != model:
        raise ValueError("Particle frame encoding changed its lane boundaries")
    return result


def encode(model, *, target_abi):
    if target_abi in ("negative-sentinel", "paired-lanes"):
        return _encode_particles(model, target_abi)
    if (
        target_abi not in ABIS
        or not isinstance(model, dict)
        or set(model) != {"abi", "header", "tokens"}
        or model["abi"] != target_abi
        or not isinstance(model["tokens"], list)
        or not 1 < len(model["tokens"]) <= 256
    ):
        raise ValueError("Dedicated raw model differs from its bounded reader ABI")
    tokens, output = model["tokens"], bytearray()
    if target_abi == "counted":
        if not isinstance(model["header"], dict) or set(model["header"]) != {"delay_counter", "frame_count"}:
            raise ValueError("Counted raw header fields differ from the reader")
        count = _integer(model["header"]["frame_count"], 256, "Counted raw frame count")
        if not count or count != len(tokens) - 1 or tokens[-1] != {"op": "count-loop"}:
            raise ValueError("Counted raw frame count differs from its physical sequence")
        output.extend((_integer(model["header"]["delay_counter"], 256, "Counted raw counter"), count))
        for token in tokens[:-1]:
            if not isinstance(token, dict) or set(token) != {"op", "frame"} or token["op"] != "frame":
                raise ValueError("Counted raw frame fields differ from the reader")
            output.append(_integer(token["frame"], 256, "Counted raw frame"))
    else:
        if model["header"] != {} or len(tokens) > 64:
            raise ValueError("Moving raw sequence exceeds its byte cursor capacity")
        for token in tokens[:-1]:
            if (
                not isinstance(token, dict)
                or set(token) != {"op", "frame", "delay_counter", "dx", "dy"}
                or token["op"] != "frame"
            ):
                raise ValueError("Moving raw frame fields differ from the reader")
            output.extend(
                (
                    _integer(token["frame"], 128, "Moving raw frame"),
                    _integer(token["delay_counter"], 256, "Moving raw counter"),
                )
            )
            for key in ("dx", "dy"):
                value = token[key]
                if type(value) is not int or not -128 <= value <= 127:
                    raise ValueError("Moving raw displacement exceeds its signed byte")
                output.append(value & 255)
        end = tokens[-1]
        if not isinstance(end, dict) or set(end) != {"op", "marker"} or end["op"] != "delete":
            raise ValueError("Moving raw sequence needs its deletion marker")
        marker = _integer(end["marker"], 256, "Moving raw deletion marker")
        if marker < 128:
            raise ValueError("Moving raw deletion marker must be negative")
        output.append(marker)
    result = bytes(output)
    if decode(result, abi=target_abi) != model:
        raise ValueError("Dedicated raw model differs from its encoded frame sequence")
    return result

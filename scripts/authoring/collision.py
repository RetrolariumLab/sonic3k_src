"""Product-specific collision indices, signed height profiles and flagged angles."""

from scripts.authoring.graphics import _boolean, _bytes, _integer


ABIS = {"s3-planar16": (512, 3072), "sk-interleaved8": (256, 1536)}


def _abi(abi):
    if abi not in ABIS:
        raise ValueError("Unknown collision index ABI")
    return ABIS[abi]


def decode_indices(data, *, abi):
    limit, size = _abi(abi)
    raw = _bytes(data)
    if len(raw) != size:
        raise ValueError("Collision index allocation differs from its target ABI")
    if abi == "s3-planar16":
        words = [int.from_bytes(raw[i : i + 2], "big") for i in range(0, size, 2)]
        model = [{"path_a": a, "path_b": b} for a, b in zip(words[:768], words[768:])]
    else:
        model = [{"path_a": raw[i], "path_b": raw[i + 1]} for i in range(0, size, 2)]
    for row in model:
        for value in row.values():
            _integer(value, limit, "collision shape index")
    return model


def encode_indices(records, *, abi):
    limit, _ = _abi(abi)
    if len(records) != 768:
        raise ValueError("Collision indices must cover the complete 768-block allocation")
    paths = [[], []]
    for row in records:
        if set(row) != {"path_a", "path_b"}:
            raise ValueError("Collision path fields differ from the format")
        for index, name in enumerate(("path_a", "path_b")):
            paths[index].append(_integer(row[name], limit, "collision shape index"))
    if abi == "s3-planar16":
        return b"".join(value.to_bytes(2, "big") for path in paths for value in path)
    return bytes(value for pair in zip(*paths) for value in pair)


def _shape_count(value):
    if isinstance(value, bool) or not isinstance(value, int) or value not in (256, 512):
        raise ValueError("Collision shape allocation must be 256 or 512")


def decode_heights(data, *, shape_count):
    _shape_count(shape_count)
    raw = _bytes(data)
    if len(raw) != shape_count * 16:
        raise ValueError("Height profile allocation differs from its target ABI")
    return [[value if value < 128 else value - 256 for value in raw[i : i + 16]] for i in range(0, len(raw), 16)]


def encode_heights(shapes, *, shape_count):
    _shape_count(shape_count)
    if len(shapes) != shape_count or any(len(row) != 16 for row in shapes):
        raise ValueError("Each collision shape needs sixteen signed height samples")
    output = bytearray()
    for row in shapes:
        for value in row:
            if isinstance(value, bool) or not isinstance(value, int) or not -128 <= value <= 127:
                raise ValueError("Collision height is outside its signed byte range")
            output.append(value & 255)
    return bytes(output)


def decode_angles(data, *, shape_count):
    _shape_count(shape_count)
    raw = _bytes(data)
    if len(raw) != shape_count:
        raise ValueError("Angle allocation differs from its target ABI")
    # Odd angles select the caller's fallback surface angle in the game.
    return [{"angle": value & 254, "use_fallback": bool(value & 1)} for value in raw]


def encode_angles(angles, *, shape_count):
    _shape_count(shape_count)
    if len(angles) != shape_count:
        raise ValueError("Angle count differs from its target shape allocation")
    output = bytearray()
    for row in angles:
        if set(row) != {"angle", "use_fallback"}:
            raise ValueError("Collision angle fields differ from the format")
        angle = _integer(row["angle"], 256, "surface angle")
        if angle & 1:
            raise ValueError("Surface angle overlaps its fallback flag")
        output.append(angle | int(_boolean(row["use_fallback"], "fallback angle flag")))
    return bytes(output)


def check_shape_references(records, *, shape_count):
    """Validate consumer capacity, including SK's low-byte view of S3 planar data."""
    _shape_count(shape_count)
    for row in records:
        if set(row) != {"path_a", "path_b"}:
            raise ValueError("Collision path fields differ from the format")
        for value in row.values():
            _integer(value, shape_count, "collision target shape index")

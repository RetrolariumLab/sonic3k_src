"""Big-endian player start coordinates selected by zone, act and character."""

from scripts.authoring.graphics import _bytes, _integer


def decode_start(data):
    raw = _bytes(data)
    if len(raw) != 4:
        raise ValueError("A player start record must contain two coordinate words")
    return {"x": int.from_bytes(raw[:2], "big"), "y": int.from_bytes(raw[2:], "big")}


def encode_start(position):
    if set(position) != {"x", "y"}:
        raise ValueError("Player start fields differ from the format")
    return b"".join(_integer(position[name], 65536, "start " + name).to_bytes(2, "big") for name in ("x", "y"))

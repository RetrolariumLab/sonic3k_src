"""Guarded S3/SK ring coordinates with two- or four-byte terminal records."""

from scripts.authoring.graphics import _bytes, _integer


def _capacity(value):
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value <= 511:
        raise ValueError("Ring capacity must be an integer between zero and 511")


def decode(data, *, max_rings=511):
    raw = _bytes(data)
    _capacity(max_rings)
    if len(raw) < 6 or len(raw) > 4 + max_rings * 4 + 4:
        raise ValueError("Ring layout exceeds its allocation or has no guard and terminator")

    def word(offset):
        if offset + 2 > len(raw):
            raise ValueError("Truncated ring coordinate")
        return int.from_bytes(raw[offset : offset + 2], "big")

    guard = {"x": word(0), "y": word(2)}
    rings, offset = [], 4
    while True:
        x = word(offset)
        if x & 0x8000:
            remaining = len(raw) - offset
            if remaining not in (2, 4):
                raise ValueError("Ring terminal record has an unsupported trailing extent")
            terminator = {"x": x, "y": word(offset + 2) if remaining == 4 else None}
            return {"guard": guard, "rings": rings, "terminator": terminator}
        if len(rings) == max_rings:
            raise ValueError("Ring count exceeds its declared capacity")
        rings.append({"x": x, "y": word(offset + 2)})
        offset += 4


def encode(model, *, max_rings=511):
    _capacity(max_rings)
    if set(model) != {"guard", "rings", "terminator"} or len(model["rings"]) > max_rings:
        raise ValueError("Ring layout fields or count differ from the format")
    output = bytearray()
    for index, row in enumerate([model["guard"], *model["rings"]]):
        if set(row) != {"x", "y"}:
            raise ValueError("Ring position fields differ from the format")
        x = _integer(row["x"], 65536 if index == 0 else 32768, "ring X")
        y = _integer(row["y"], 65536, "ring Y")
        output.extend(x.to_bytes(2, "big") + y.to_bytes(2, "big"))
    last = model["terminator"]
    if set(last) != {"x", "y"}:
        raise ValueError("Ring terminator fields differ from the format")
    x = _integer(last["x"], 65536, "ring terminator X")
    if not x & 0x8000:
        raise ValueError("Ring terminal X must have its sign bit set")
    output.extend(x.to_bytes(2, "big"))
    if last["y"] is not None:
        output.extend(_integer(last["y"], 65536, "ring terminator Y").to_bytes(2, "big"))
    return bytes(output)


def check_order(model, axis="x"):
    if axis not in ("x", "y"):
        raise ValueError("Unknown ring streaming axis")
    values = [row[axis] for row in model["rings"]]
    if values != sorted(values):
        raise ValueError("Ring positions are not ordered for their streaming axis")

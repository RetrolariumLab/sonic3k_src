"""Six-byte S3K placed objects with contextual type IDs and packed Y flags."""

from scripts.authoring.graphics import _boolean, _bytes, _integer

FIELDS = frozenset(("x", "y", "flip_x", "flip_y", "ignore_y_range", "reserved_bit12", "type_id", "subtype"))


def _capacity(value):
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value <= 768:
        raise ValueError("Object capacity must be an integer between zero and 768")


def decode(data, *, max_objects=768):
    raw = _bytes(data)
    _capacity(max_objects)
    if len(raw) < 6 or len(raw) > max_objects * 6 + 10:
        raise ValueError("Object layout exceeds its allocation or lacks its terminal record")
    rows, offset = [], 0
    while True:
        if offset + 2 > len(raw):
            raise ValueError("Object layout has no terminal X word")
        x = int.from_bytes(raw[offset : offset + 2], "big")
        if x == 65535:
            padding = raw[offset + 2 :]
            if len(padding) not in (4, 8) or any(padding):
                raise ValueError("Object terminal padding differs from the accepted layout variants")
            return {"objects": rows, "end_padding_bytes": len(padding)}
        if len(rows) == max_objects or offset + 6 > len(raw):
            raise ValueError("Object count exceeds capacity or ends inside a record")
        packed_y = int.from_bytes(raw[offset + 2 : offset + 4], "big")
        rows.append(
            {
                "x": x,
                "y": packed_y & 4095,
                "flip_x": bool(packed_y & 0x2000),
                "flip_y": bool(packed_y & 0x4000),
                "ignore_y_range": bool(packed_y & 0x8000),
                "reserved_bit12": bool(packed_y & 0x1000),
                "type_id": raw[offset + 4],
                "subtype": raw[offset + 5],
            }
        )
        offset += 6


def encode(model, *, max_objects=768):
    _capacity(max_objects)
    if set(model) != {"objects", "end_padding_bytes"} or len(model["objects"]) > max_objects:
        raise ValueError("Object layout fields or count differ from its contract")
    padding = model["end_padding_bytes"]
    if isinstance(padding, bool) or not isinstance(padding, int) or padding not in (4, 8):
        raise ValueError("Object layout terminal padding must be four or eight zero bytes")
    output = bytearray()
    for row in model["objects"]:
        if set(row) != FIELDS:
            raise ValueError("Placed-object fields differ from the format")
        x, y = _integer(row["x"], 65535, "object X"), _integer(row["y"], 4096, "object Y")
        for name, shift in (("reserved_bit12", 12), ("flip_x", 13), ("flip_y", 14), ("ignore_y_range", 15)):
            y |= int(_boolean(row[name], name)) << shift
        output.extend(x.to_bytes(2, "big") + y.to_bytes(2, "big"))
        output.extend(
            (
                _integer(row["type_id"], 256, "contextual object type ID"),
                _integer(row["subtype"], 256, "object subtype"),
            )
        )
    output.extend(b"\xff\xff" + bytes(padding))
    return bytes(output)


def check_order(model):
    values = [row["x"] for row in model["objects"]]
    if values != sorted(values):
        raise ValueError("Placed objects are not sorted for horizontal streaming")

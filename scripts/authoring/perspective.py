"""Special-stage 16x15 projection grids, SK RAM views and Q14 angle scalars."""

from scripts.authoring.graphics import _bytes, _integer

FRAME_BYTES = 16 * 15 * 6
FRAME_COUNT = 15
SK_VIEW_COUNT = 23
SK_RAM_BASE = 0x00FF0000


def _word(value, name):
    if isinstance(value, bool) or not isinstance(value, int) or not -32768 <= value <= 32767:
        raise ValueError(name + " is outside its signed coordinate word")
    return value.to_bytes(2, "big", signed=True)


def _product(value):
    if value not in ("s3", "sk"):
        raise ValueError("Unknown special-stage perspective ABI")


def decode(data, *, product):
    _product(product)
    raw = _bytes(data)
    header_size = SK_VIEW_COUNT * 4 if product == "sk" else 0
    if len(raw) != header_size + FRAME_COUNT * FRAME_BYTES:
        raise ValueError("Perspective bank differs from its product's frame allocation")
    model = {"product": product, "frames": []}
    if product == "sk":
        views = []
        for offset in range(0, header_size, 4):
            pointer = int.from_bytes(raw[offset : offset + 4], "big")
            displacement = pointer - SK_RAM_BASE - header_size
            if displacement < 0 or displacement % FRAME_BYTES or displacement // FRAME_BYTES >= FRAME_COUNT:
                raise ValueError("Perspective view pointer does not address a complete frame in 24-bit RAM")
            views.append(displacement // FRAME_BYTES)
        model["views"] = views
    for frame in range(FRAME_COUNT):
        rows = []
        for row in range(16):
            cells = []
            for column in range(15):
                offset = header_size + frame * FRAME_BYTES + (row * 15 + column) * 6
                cells.append(
                    {
                        "scale_code": int.from_bytes(raw[offset : offset + 2], "big"),
                        "x": int.from_bytes(raw[offset + 2 : offset + 4], "big", signed=True),
                        "y": int.from_bytes(raw[offset + 4 : offset + 6], "big", signed=True),
                    }
                )
            rows.append(cells)
        model["frames"].append(rows)
    return model


def encode(bank, *, target_product):
    _product(target_product)
    expected = {"product", "frames", "views"} if target_product == "sk" else {"product", "frames"}
    if set(bank) != expected or bank["product"] != target_product or len(bank["frames"]) != FRAME_COUNT:
        raise ValueError("Perspective model and target have different product ABIs or frame counts")
    output = bytearray()
    if target_product == "sk":
        if len(bank["views"]) != SK_VIEW_COUNT:
            raise ValueError("SK perspective bank needs 23 view pointers")
        for index in bank["views"]:
            offset = SK_VIEW_COUNT * 4 + _integer(index, FRAME_COUNT, "perspective frame index") * FRAME_BYTES
            output.extend((SK_RAM_BASE + offset).to_bytes(4, "big"))
    for frame in bank["frames"]:
        if len(frame) != 16 or any(len(row) != 15 for row in frame):
            raise ValueError("Perspective frame must retain its sixteen by fifteen grid")
        for row in frame:
            for cell in row:
                if set(cell) != {"scale_code", "x", "y"}:
                    raise ValueError("Perspective cell fields differ from scale/X/Y words")
                output.extend(_integer(cell["scale_code"], 65536, "projection scale code").to_bytes(2, "big"))
                output.extend(_word(cell["x"], "projection X"))
                output.extend(_word(cell["y"], "projection Y"))
    return bytes(output)


def decode_scalars(data):
    raw = _bytes(data)
    if len(raw) != 512:
        raise ValueError("Special-stage Q14 scalar table needs 256 signed words")
    return [int.from_bytes(raw[i : i + 2], "big", signed=True) for i in range(0, 512, 2)]


def encode_scalars(scalars):
    if len(scalars) != 256:
        raise ValueError("Special-stage Q14 scalar table needs 256 angular samples")
    return b"".join(_word(value, "Q14 scalar") for value in scalars)

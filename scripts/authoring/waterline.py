"""Waterline row-selection matrices and the sixteen-zone initial water-height table."""

from scripts.authoring.graphics import _bytes, _integer

WIDTHS = {"hcz": 96, "lbz": 64}


def _width(zone):
    if zone not in WIDTHS:
        raise ValueError("Unknown waterline matrix consumer ABI")
    return WIDTHS[zone]


def _active(width, row):
    # The equilibrium and endpoint rows are not used. For other rows the game
    # reads only abs(camera/water equilibrium difference) leading selectors.
    return width - row if 0 < row < width else 0


def decode(data, *, zone):
    width = _width(zone)
    raw = _bytes(data)
    if len(raw) != (width + 1) * width:
        raise ValueError("Waterline selector matrix differs from its zone allocation")
    rows = []
    for index in range(width + 1):
        row = raw[index * width : (index + 1) * width]
        active = _active(width, index)
        if any(value >= width for value in row[:active]):
            raise ValueError("Active waterline selector escapes the generated source-word span")
        rows.append({"source_words": list(row[:active]), "unused_selectors": list(row[active:])})
    return {"zone": zone, "rows": rows}


def encode(matrix, *, target_zone):
    width = _width(target_zone)
    if set(matrix) != {"zone", "rows"} or matrix["zone"] != target_zone or len(matrix["rows"]) != width + 1:
        raise ValueError("Waterline matrix and target have different zone ABIs or row counts")
    output = bytearray()
    for index, row in enumerate(matrix["rows"]):
        active = _active(width, index)
        if (
            set(row) != {"source_words", "unused_selectors"}
            or len(row["source_words"]) != active
            or len(row["unused_selectors"]) != width - active
        ):
            raise ValueError("Waterline row active/inactive columns differ from the consumer")
        output.extend(_integer(value, width, "waterline source word") for value in row["source_words"])
        output.extend(_integer(value, 256, "unused waterline selector") for value in row["unused_selectors"])
    return bytes(output)


def selectors_for_distance(matrix, distance):
    width = _width(matrix["zone"])
    if isinstance(distance, bool) or not isinstance(distance, int) or not -32768 <= distance <= 32767:
        raise ValueError("Waterline distance must be a signed camera word")
    if not 0 < abs(distance) < width:
        return []
    return list(matrix["rows"][width - abs(distance)]["source_words"])


def decode_starting_heights(data):
    raw = _bytes(data)
    if len(raw) != 64:
        raise ValueError("Initial water-height table must contain sixteen zone/act pairs")
    return [
        {"act1": int.from_bytes(raw[i : i + 2], "big"), "act2": int.from_bytes(raw[i + 2 : i + 4], "big")}
        for i in range(0, 64, 4)
    ]


def encode_starting_heights(zones):
    if len(zones) != 16:
        raise ValueError("Initial water-height table needs sixteen zones")
    output = bytearray()
    for row in zones:
        if set(row) != {"act1", "act2"}:
            raise ValueError("Initial water-height fields differ from the two-act ABI")
        for name in ("act1", "act2"):
            output.extend(_integer(row[name], 65536, "water height").to_bytes(2, "big"))
    return bytes(output)

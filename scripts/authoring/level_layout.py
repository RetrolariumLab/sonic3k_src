"""S3K foreground/background chunk grids with canonical RAM row pointers."""

from scripts.authoring.graphics import _bytes, _integer

HEADER_SIZE = 136
RAM_BASE = 0x8000
CAPACITY = 0x1000


def encode(layout):
    if set(layout) != {"foreground", "background"}:
        raise ValueError("Level layout needs foreground and background planes")
    output = bytearray(HEADER_SIZE)
    for layer, name in enumerate(("foreground", "background")):
        plane = layout[name]
        if set(plane) != {"width", "rows"}:
            raise ValueError("Level plane fields differ from the format")
        width = _integer(plane["width"], 65536, "layout row width")
        height = len(plane["rows"])
        if height > 32 or (height and not width):
            raise ValueError("Level layout exceeds 32 rows or has an empty row width")
        output[layer * 2 : layer * 2 + 2] = width.to_bytes(2, "big")
        output[4 + layer * 2 : 6 + layer * 2] = height.to_bytes(2, "big")
        for index, row in enumerate(plane["rows"]):
            if len(row) != width:
                raise ValueError("Chunk row differs from its declared width")
            if len(output) + width > CAPACITY:
                raise ValueError("Level layout exceeds its 4 KiB RAM allocation")
            offset = 8 + index * 4 + layer * 2
            output[offset : offset + 2] = (RAM_BASE + len(output)).to_bytes(2, "big")
            output.extend(_integer(value, 256, "layout chunk index") for value in row)
    if len(output) & 1:
        output.append(0)
    return bytes(output)


def decode(data):
    raw = _bytes(data)
    if not HEADER_SIZE <= len(raw) <= CAPACITY or len(raw) & 1:
        raise ValueError("Level layout is truncated, unaligned or exceeds RAM capacity")
    words = [int.from_bytes(raw[i : i + 2], "big") for i in range(0, HEADER_SIZE, 2)]
    model = {}
    for layer, name in enumerate(("foreground", "background")):
        width, height = words[layer], words[layer + 2]
        if height > 32 or (height and not width):
            raise ValueError("Level plane dimensions exceed the row pointer table")
        rows = []
        for index in range(32):
            pointer = words[4 + index * 2 + layer]
            if index >= height:
                if pointer:
                    raise ValueError("Unused level row pointer is nonzero")
                continue
            offset = pointer - RAM_BASE
            if offset < HEADER_SIZE or offset + width > len(raw):
                raise ValueError("Level row pointer escapes its data allocation")
            rows.append(list(raw[offset : offset + width]))
        model[name] = {"width": width, "rows": rows}
    # All accepted original layouts use contiguous FG rows followed by BG rows.
    # Reject alternate aliases/padding explicitly rather than silently losing them.
    if encode(model) != raw:
        raise ValueError("Level layout uses a noncanonical pointer order or padding")
    return model


def check_chunk_references(layout, chunk_count):
    if isinstance(chunk_count, bool) or not isinstance(chunk_count, int) or not 0 <= chunk_count <= 256:
        raise ValueError("Target chunk table exceeds its 256-entry allocation")
    for plane in layout.values():
        if any(value >= chunk_count for row in plane["rows"] for value in row):
            raise ValueError("Level row references a chunk outside its target table")

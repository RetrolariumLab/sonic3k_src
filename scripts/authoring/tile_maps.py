"""Structured VDP map rectangles, frame banks and horizontally interleaved glyph atlases."""

from scripts.authoring.graphics import _bytes, decode_tile_words, encode_tile_words


def _layout(layout):
    if set(layout) != {"columns", "rows", "frames", "packing"}:
        raise ValueError("Tile-map layout must declare dimensions, frames and packing")
    for name, maximum in (("columns", 128), ("rows", 128), ("frames", 256)):
        value = layout[name]
        if isinstance(value, bool) or not isinstance(value, int) or not 1 <= value <= maximum:
            raise ValueError("Tile-map " + name + " exceeds its bounded dimension")
    if layout["packing"] not in ("frames", "horizontal-atlas"):
        raise ValueError("Unknown VDP map frame packing")
    size = layout["columns"] * layout["rows"] * layout["frames"] * 2
    if size > 0x400000:
        raise ValueError("Tile-map layout exceeds its bounded input allocation")
    return size


def _positions(layout):
    columns, rows, frames = (layout[name] for name in ("columns", "rows", "frames"))
    if layout["packing"] == "frames":
        return ((frame, row, column) for frame in range(frames) for row in range(rows) for column in range(columns))
    return ((frame, row, column) for row in range(rows) for frame in range(frames) for column in range(columns))


def decode(data, *, layout):
    expected = _layout(layout)
    raw = _bytes(data)
    if len(raw) != expected:
        raise ValueError("VDP map bytes differ from the consumer's complete rectangle allocation")
    tiles = decode_tile_words(raw)
    frames = [
        [[None for _ in range(layout["columns"])] for _ in range(layout["rows"])] for _ in range(layout["frames"])
    ]
    for position, tile in zip(_positions(layout), tiles):
        frame, row, column = position
        frames[frame][row][column] = tile
    return {"layout": dict(layout), "frames": frames}


def encode(model, *, target_layout):
    _layout(target_layout)
    if set(model) != {"layout", "frames"} or model["layout"] != target_layout:
        raise ValueError("VDP map and target have different rectangle or glyph-packing ABIs")
    _layout(model["layout"])
    frames = model["frames"]
    if len(frames) != target_layout["frames"] or any(
        len(frame) != target_layout["rows"] or any(len(row) != target_layout["columns"] for row in frame)
        for frame in frames
    ):
        raise ValueError("VDP map frame shape differs from its fixed consumer layout")
    return encode_tile_words([frames[frame][row][column] for frame, row, column in _positions(target_layout)])

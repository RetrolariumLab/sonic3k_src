"""Structured Mega Drive CRAM colors, 4bpp tiles and VDP tile attributes."""


def _bytes(data):
    if not isinstance(data, (bytes, bytearray, memoryview)):
        raise ValueError("Content must be bytes")
    return bytes(data)


def _integer(value, limit, name):
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value < limit:
        raise ValueError(name + " is outside its field range")
    return value


def _boolean(value, name):
    if not isinstance(value, bool):
        raise ValueError(name + " must be boolean")
    return value


def decode_palette(data):
    raw = _bytes(data)
    if len(raw) % 2:
        raise ValueError("CRAM palette ends inside a color word")
    colors = []
    for offset in range(0, len(raw), 2):
        word = int.from_bytes(raw[offset : offset + 2], "big")
        colors.append(
            {"red": (word >> 1) & 7, "green": (word >> 5) & 7, "blue": (word >> 9) & 7, "reserved": word & 0xF111}
        )
    return colors


def encode_palette(colors):
    output = bytearray()
    for color in colors:
        if set(color) != {"red", "green", "blue", "reserved"}:
            raise ValueError("Palette color fields differ from the format")
        word = sum(_integer(color[name], 8, name) << shift for name, shift in (("red", 1), ("green", 5), ("blue", 9)))
        reserved = _integer(color["reserved"], 65536, "reserved color bits")
        if reserved & ~0xF111:
            raise ValueError("Reserved color bits overlap RGB channels")
        output.extend((word | reserved).to_bytes(2, "big"))
    return bytes(output)


def decode_tiles(data):
    raw = _bytes(data)
    if len(raw) % 32:
        raise ValueError("4bpp graphics ends inside an 8 by 8 tile")
    tiles = []
    for offset in range(0, len(raw), 32):
        pixels = [pixel for value in raw[offset : offset + 32] for pixel in (value >> 4, value & 15)]
        tiles.append([pixels[row : row + 8] for row in range(0, 64, 8)])
    return tiles


def encode_tiles(tiles):
    output = bytearray()
    for tile in tiles:
        if len(tile) != 8 or any(len(row) != 8 for row in tile):
            raise ValueError("A 4bpp tile must have eight rows of eight pixels")
        for row in tile:
            for column in range(0, 8, 2):
                output.append(_integer(row[column], 16, "pixel") << 4 | _integer(row[column + 1], 16, "pixel"))
    return bytes(output)


def decode_tile_words(data):
    raw = _bytes(data)
    if len(raw) % 2:
        raise ValueError("VDP tile data ends inside an attribute word")
    result = []
    for offset in range(0, len(raw), 2):
        word = int.from_bytes(raw[offset : offset + 2], "big")
        result.append(
            {
                "pattern": word & 0x7FF,
                "flip_x": bool(word & 0x800),
                "flip_y": bool(word & 0x1000),
                "palette": (word >> 13) & 3,
                "priority": bool(word & 0x8000),
            }
        )
    return result


def encode_tile_words(records):
    output = bytearray()
    for record in records:
        if set(record) != {"pattern", "flip_x", "flip_y", "palette", "priority"}:
            raise ValueError("VDP tile attribute fields differ from the format")
        word = _integer(record["pattern"], 2048, "tile pattern") | _integer(record["palette"], 4, "tile palette") << 13
        for name, shift in (("flip_x", 11), ("flip_y", 12), ("priority", 15)):
            word |= int(_boolean(record[name], name)) << shift
        output.extend(word.to_bytes(2, "big"))
    return bytes(output)

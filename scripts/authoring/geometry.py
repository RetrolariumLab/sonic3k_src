"""Snowboard trajectories, streamed foreground rocks and their sprite templates."""

from scripts.authoring.graphics import _bytes, _integer, decode_tile_words, encode_tile_words


def _limit(value, maximum, name):
    if isinstance(value, bool) or not isinstance(value, int) or not 1 <= value <= maximum:
        raise ValueError(name + " exceeds its bounded index domain")


def _signed(value, name):
    if isinstance(value, bool) or not isinstance(value, int) or not -32768 <= value < 32768:
        raise ValueError(name + " exceeds a signed word")
    return value.to_bytes(2, "big", signed=True)


def decode_slope(data, *, max_samples=33):
    _limit(max_samples, 10922, "Snowboard sample capacity")
    raw = _bytes(data)
    if len(raw) < 8 or len(raw) % 6 != 2 or (len(raw) - 2) // 6 > max_samples:
        raise ValueError("Snowboard path exceeds its sample slot or ends inside a record")
    terminal = int.from_bytes(raw[-2:], "big")
    if terminal < 32768:
        raise ValueError("Snowboard path lacks its negative-X terminator")
    rows = []
    for offset in range(0, len(raw) - 2, 6):
        x = int.from_bytes(raw[offset : offset + 2], "big")
        if x >= 32768:
            raise ValueError("Snowboard path contains an early negative-X terminator")
        rows.append(
            {
                "x": x,
                "y": int.from_bytes(raw[offset + 2 : offset + 4], "big"),
                "frame": raw[offset + 5],
                "ignored_frame_high": raw[offset + 4],
            }
        )
    return {"samples": rows, "terminal_x": terminal}


def encode_slope(path, *, max_samples=33):
    _limit(max_samples, 10922, "Snowboard sample capacity")
    if set(path) != {"samples", "terminal_x"} or not 1 <= len(path["samples"]) <= max_samples:
        raise ValueError("Snowboard path fields or count differ from its slot")
    terminal = _integer(path["terminal_x"], 65536, "snowboard terminator")
    if terminal < 32768:
        raise ValueError("Snowboard terminator must have its sign bit set")
    output = bytearray()
    for row in path["samples"]:
        if set(row) != {"x", "y", "frame", "ignored_frame_high"}:
            raise ValueError("Snowboard sample needs X, Y and its complete frame word")
        output.extend(_integer(row["x"], 32768, "snowboard X").to_bytes(2, "big"))
        output.extend(_integer(row["y"], 65536, "snowboard Y").to_bytes(2, "big"))
        output.extend(
            (
                _integer(row["ignored_frame_high"], 256, "ignored frame byte"),
                _integer(row["frame"], 256, "snowboard mapping frame"),
            )
        )
    return bytes(output) + terminal.to_bytes(2, "big")


def decode_rocks(data, *, max_rocks=10922):
    _limit(max_rocks, 10922, "Rock record capacity")
    raw = _bytes(data)
    if len(raw) < 4 or len(raw) % 6 != 4 or (len(raw) - 4) // 6 > max_rocks or raw[-4:] != b"\xff" * 4:
        raise ValueError("Rock placement needs complete style/X/Y records and its four-byte terminator")
    rows = []
    for offset in range(0, len(raw) - 4, 6):
        style, x, y = (int.from_bytes(raw[offset + i : offset + i + 2], "big") for i in (0, 2, 4))
        if style == 65535 or x == 65535:
            raise ValueError("Rock placement contains an early terminal style or X")
        rows.append({"style": style, "x": x, "y": y})
    return rows


def encode_rocks(rocks, *, max_rocks=10922):
    _limit(max_rocks, 10922, "Rock record capacity")
    if len(rocks) > max_rocks:
        raise ValueError("Rock placement exceeds its target allocation")
    output = bytearray()
    for row in rocks:
        if set(row) != {"style", "x", "y"}:
            raise ValueError("Rock placement fields differ from style/X/Y words")
        for name, limit in (("style", 65535), ("x", 65535), ("y", 65536)):
            output.extend(_integer(row[name], limit, "rock " + name).to_bytes(2, "big"))
    return bytes(output) + b"\xff" * 4


def check_rock_styles(rocks, style_count):
    _limit(style_count, 8192, "Rock sprite style count")
    if any(row["style"] >= style_count for row in rocks):
        raise ValueError("Rock placement references a style outside its consumer's sprite table")


def check_rock_order(rocks):
    values = [row["x"] for row in rocks]
    if values != sorted(values):
        raise ValueError("Rock placement is not sorted for front/back horizontal cursors")


def decode_rock_sprites(data):
    raw = _bytes(data)
    if not raw or len(raw) % 8 or len(raw) > 65536:
        raise ValueError("Rock sprite table needs bounded eight-byte template records")
    rows = []
    for offset in range(0, len(raw), 8):
        size = raw[offset + 3]
        rows.append(
            {
                "offset_y": int.from_bytes(raw[offset : offset + 2], "big", signed=True),
                "width_tiles": ((size >> 2) & 3) + 1,
                "height_tiles": (size & 3) + 1,
                "size_reserved": size >> 4,
                "ignored_size_high": raw[offset + 2],
                "tile": decode_tile_words(raw[offset + 4 : offset + 6])[0],
                "offset_x": int.from_bytes(raw[offset + 6 : offset + 8], "big", signed=True),
            }
        )
    return rows


def encode_rock_sprites(sprites):
    if not 1 <= len(sprites) <= 8192:
        raise ValueError("Rock sprite table exceeds its template index domain")
    output = bytearray()
    for row in sprites:
        if set(row) != {
            "offset_y",
            "width_tiles",
            "height_tiles",
            "size_reserved",
            "ignored_size_high",
            "tile",
            "offset_x",
        }:
            raise ValueError("Rock sprite template fields differ from its VDP transfer format")
        width = _integer(row["width_tiles"], 5, "sprite tile width")
        height = _integer(row["height_tiles"], 5, "sprite tile height")
        if not width or not height:
            raise ValueError("VDP sprite dimensions must be one through four tiles")
        size = (width - 1) << 2 | (height - 1) | _integer(row["size_reserved"], 16, "reserved sprite-size bits") << 4
        output.extend(_signed(row["offset_y"], "sprite Y offset"))
        output.extend((_integer(row["ignored_size_high"], 256, "ignored sprite-size high byte"), size))
        output.extend(encode_tile_words([row["tile"]]))
        output.extend(_signed(row["offset_x"], "sprite X offset"))
    return bytes(output)

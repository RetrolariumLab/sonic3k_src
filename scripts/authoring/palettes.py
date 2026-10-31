"""CRAM frame arrays and the original special-stage/Pachinko palette cycle layouts."""

from scripts.authoring.graphics import _bytes, decode_palette, encode_palette


def _width(value):
    if isinstance(value, bool) or not isinstance(value, int) or not 1 <= value <= 64:
        raise ValueError("A palette frame must contain between one and 64 CRAM colors")


def decode_frames(data, *, colors_per_frame):
    _width(colors_per_frame)
    colors = decode_palette(data)
    if not colors or len(colors) % colors_per_frame:
        raise ValueError("Palette data ends inside its declared color frame")
    return [colors[i : i + colors_per_frame] for i in range(0, len(colors), colors_per_frame)]


def encode_frames(frames, *, colors_per_frame):
    _width(colors_per_frame)
    if not frames or any(len(row) != colors_per_frame for row in frames):
        raise ValueError("Palette frame width differs from the consumer allocation")
    return encode_palette([color for frame in frames for color in frame])


def decode_special_stage(data):
    raw = _bytes(data)
    if len(raw) != 38 or raw[:16] != raw[16:32]:
        raise ValueError("Special-stage palette needs eight repeated cycle colors and three HUD colors")
    return {"cycle": decode_palette(raw[:16]), "hud_patch": decode_palette(raw[32:])}


def encode_special_stage(palette):
    if set(palette) != {"cycle", "hud_patch"} or len(palette["cycle"]) != 8 or len(palette["hud_patch"]) != 3:
        raise ValueError("Special-stage palette fields or color counts differ from the consumer ABI")
    cycle = encode_palette(palette["cycle"])
    return cycle * 2 + encode_palette(palette["hud_patch"])


def decode_pachinko(data):
    raw = _bytes(data)
    if len(raw) != 1332:
        raise ValueError("Decoded Pachinko palette bank differs from its original allocation")
    # First cycle: 18 frames of seven colors, transferred every tick. Second:
    # 100 positions plus eight lookahead frames, five colors per frame; the
    # game displays frames n+8, n+4 and n, advancing every fourth tick.
    return {
        "line4_cycle": decode_frames(raw[:252], colors_per_frame=7),
        "line3_cycle": decode_frames(raw[252:], colors_per_frame=5),
    }


def encode_pachinko(bank):
    if set(bank) != {"line4_cycle", "line3_cycle"} or len(bank["line4_cycle"]) != 18 or len(bank["line3_cycle"]) != 108:
        raise ValueError("Pachinko palette cycles differ from their consumer capacities")
    return encode_frames(bank["line4_cycle"], colors_per_frame=7) + encode_frames(
        bank["line3_cycle"], colors_per_frame=5
    )

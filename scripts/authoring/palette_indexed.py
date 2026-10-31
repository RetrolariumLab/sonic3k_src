"""Indexed palette frames selected by the object's alternate rotation reader."""

from copy import deepcopy
from scripts.authoring.graphics import _bytes, _integer, decode_palette, encode_palette


def layout(*, base, palette_count, step_count, color_count):
    if type(base) is not int or base % 2 or not 0 <= base < 0x400000:
        raise ValueError("Indexed palette base is not an aligned cartridge address")
    for value, limit, name in (
        (palette_count, 129, "Palette frame count"),
        (step_count, 128, "Palette step count"),
        (color_count, 65, "Palette color count"),
    ):
        if not _integer(value, limit, name):
            raise ValueError(name + " cannot be zero")
    table = 6 + 2 * step_count + 2
    offsets = [2 * palette_count + 2 * color_count * i for i in range(palette_count)]
    size = table + 2 * palette_count + 2 * color_count * palette_count
    if size > 65536 or offsets[-1] > 32767 or base + size > 0x400000:
        raise ValueError("Indexed palette exceeds its word-relative allocation")
    return table, offsets, size


def decode(data, *, base, palette_count, step_count, color_count):
    table, offsets, size = layout(
        base=base, palette_count=palette_count, step_count=step_count, color_count=color_count
    )
    raw = _bytes(data)
    if (
        len(raw) != size
        or int.from_bytes(raw[:4], "big") != base + table
        or int.from_bytes(raw[4:6], "big") != color_count - 1
    ):
        raise ValueError("Indexed palette header differs from its declared table and color width")
    steps = []
    for at in range(6, table - 2, 2):
        if raw[at] >= palette_count:
            raise ValueError("Palette step selects an unavailable frame")
        steps.append({"palette_index": raw[at], "delay_counter": raw[at + 1]})
    if raw[table - 2] < 128 or raw[table - 1] < 128:
        raise ValueError("Indexed palette lacks its negative restart and stored terminal marker")
    actual = [int.from_bytes(raw[at : at + 2], "big", signed=True) for at in range(table, table + 2 * palette_count, 2)]
    if actual != offsets:
        raise ValueError("Indexed palette frame offsets differ from their dense fixed storage")
    frames = [decode_palette(raw[table + offset : table + offset + 2 * color_count]) for offset in offsets]
    return {
        "palette_table": base + table,
        "color_count": color_count,
        "relative_offsets": offsets,
        "steps": steps,
        "restart_marker": raw[table - 2],
        "stored_marker": raw[table - 1],
        "frames": frames,
    }


def encode(model, *, base, palette_count, step_count, color_count):
    table, offsets, size = layout(
        base=base, palette_count=palette_count, step_count=step_count, color_count=color_count
    )
    if not isinstance(model, dict) or set(model) != {
        "palette_table",
        "color_count",
        "relative_offsets",
        "steps",
        "restart_marker",
        "stored_marker",
        "frames",
    }:
        raise ValueError("Indexed palette model fields differ from the reader")
    if (
        type(model["palette_table"]) is not int
        or model["palette_table"] != base + table
        or type(model["color_count"]) is not int
        or model["color_count"] != color_count
        or not isinstance(model["relative_offsets"], list)
        or any(type(n) is not int for n in model["relative_offsets"])
        or model["relative_offsets"] != offsets
    ):
        raise ValueError("Indexed palette structural pointers or color width changed")
    if (
        not isinstance(model["steps"], list)
        or len(model["steps"]) != step_count
        or not isinstance(model["frames"], list)
        or len(model["frames"]) != palette_count
    ):
        raise ValueError("Indexed palette step or frame count changed")
    output = bytearray((base + table).to_bytes(4, "big") + (color_count - 1).to_bytes(2, "big"))
    for step in model["steps"]:
        if not isinstance(step, dict) or set(step) != {"palette_index", "delay_counter"}:
            raise ValueError("Unknown palette step fields")
        output.extend(
            (
                _integer(step["palette_index"], palette_count, "Palette index"),
                _integer(step["delay_counter"], 256, "Palette delay counter"),
            )
        )
    for key in ("restart_marker", "stored_marker"):
        value = _integer(model[key], 256, "Palette terminal marker")
        if value < 128:
            raise ValueError("Palette terminal marker must be negative")
        output.append(value)
    for value in offsets:
        output.extend(value.to_bytes(2, "big", signed=True))
    for colors in model["frames"]:
        if not isinstance(colors, list) or len(colors) != color_count or any(not isinstance(c, dict) for c in colors):
            raise ValueError("Palette frame changes its color capacity")
        output.extend(encode_palette(colors))
    result = bytes(output)
    if (
        len(result) != size
        or decode(result, base=base, palette_count=palette_count, step_count=step_count, color_count=color_count)
        != model
    ):
        raise ValueError("Indexed palette encoding changes its semantic field boundaries")
    return result


def structure(model):
    result = deepcopy(model)
    result["steps"] = [sorted(step) for step in model["steps"]]
    result["frames"] = [len(colors) for colors in model["frames"]]
    return result


def state_copy(data):
    raw = _bytes(data)
    if len(raw) < 8:
        raise ValueError("Palette RAM state copy requires eight bytes")
    return {
        "displacement": int.from_bytes(raw[:2], "big"),
        "delay_counter": raw[2],
        "counter": raw[3],
        "script_pointer": int.from_bytes(raw[4:8], "big"),
    }

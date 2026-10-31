"""Special-stage records and the SK Blue Sphere quadrant resource bank."""

from scripts.authoring.graphics import _bytes, _integer

CELLS = ("empty", "red_sphere", "blue_sphere", "bumper", "ring", "yellow_sphere")


def _grid(raw, size, cell_limit):
    if len(raw) != size * size or any(value >= cell_limit for value in raw):
        raise ValueError("Special-stage grid dimensions or cell types are invalid")
    return [[CELLS[value] for value in raw[i : i + size]] for i in range(0, len(raw), size)]


def _pack_grid(grid, size, cell_limit):
    if len(grid) != size or any(len(row) != size for row in grid):
        raise ValueError("Special-stage grid must retain its square dimensions")
    output = bytearray()
    for row in grid:
        for cell in row:
            if cell not in CELLS[:cell_limit]:
                raise ValueError("Sphere type is not supported by the target product")
            output.append(CELLS.index(cell))
    return bytes(output)


def _cell_limit(product):
    if product not in ("s3", "sk"):
        raise ValueError("Unknown special-stage product ABI")
    return 5 if product == "s3" else 6


def decode_record(data, *, product):
    limit = _cell_limit(product)
    raw = _bytes(data)
    if len(raw) != 1032:
        raise ValueError("A special-stage record must be 1024 cells and four words")
    model = {"cells": _grid(raw[:1024], 32, limit)}
    for offset, name in enumerate(("angle", "x_8_8", "y_8_8", "rings_left")):
        model[name] = int.from_bytes(raw[1024 + offset * 2 : 1026 + offset * 2], "big")
    return model


def encode_record(record, *, product):
    limit = _cell_limit(product)
    if set(record) != {"cells", "angle", "x_8_8", "y_8_8", "rings_left"}:
        raise ValueError("Special-stage fields differ from the record ABI")
    return _pack_grid(record["cells"], 32, limit) + b"".join(
        _integer(record[name], 65536, name).to_bytes(2, "big") for name in ("angle", "x_8_8", "y_8_8", "rings_left")
    )


def decode_sk_set(data):
    raw = _bytes(data)
    if len(raw) != 8 * 1032:
        raise ValueError("SK's first special-stage set must contain eight records")
    return [decode_record(raw[i : i + 1032], product="sk") for i in range(0, len(raw), 1032)]


def encode_sk_set(records):
    if len(records) != 8:
        raise ValueError("SK's first special-stage set must contain eight records")
    return b"".join(encode_record(row, product="sk") for row in records)


def decode_blue_sphere_bank(data):
    raw = _bytes(data)
    if len(raw) != 256 + 128 * 256:
        raise ValueError("Blue Sphere bank must contain two metadata arrays and 128 quadrants")
    return [
        {
            "rings_left": raw[index],
            "difficulty": raw[128 + index],
            "cells": _grid(raw[256 + index * 256 : 512 + index * 256], 16, 6),
        }
        for index in range(128)
    ]


def encode_blue_sphere_bank(quadrants):
    if len(quadrants) != 128 or any(set(row) != {"rings_left", "difficulty", "cells"} for row in quadrants):
        raise ValueError("Blue Sphere bank needs 128 complete quadrant definitions")
    header = bytes(_integer(row[name], 256, name) for name in ("rings_left", "difficulty") for row in quadrants)
    return header + b"".join(_pack_grid(row["cells"], 16, 6) for row in quadrants)


def compose_blue_sphere_stage(quadrants, stage_bytes):
    """Mirror four selected 16x16 resources into the game's 32x32 toroidal grid."""
    # Validate the resource bank before using it, including all cell types.
    encode_blue_sphere_bank(quadrants)
    if len(stage_bytes) != 4:
        raise ValueError("Blue Sphere stage selection needs four bytes")
    selected = [quadrants[_integer(value, 256, "stage selection byte") & 127] for value in stage_bytes]
    grid = [["empty"] * 32 for _ in range(32)]
    for index, quadrant in enumerate(selected):
        mirror_x, mirror_y = bool(index & 1), bool(index & 2)
        x_base, y_base = 16 * int(mirror_x), 16 * int(mirror_y)
        for y in range(16):
            for x in range(16):
                grid[y_base + y][x_base + x] = quadrant["cells"][15 - y if mirror_y else y][15 - x if mirror_x else x]
    return {
        "cells": grid,
        "angle": 0x4000,
        "x_8_8": 0x1000,
        "y_8_8": 0x300,
        "rings_left": sum(row["rings_left"] for row in selected),
        "difficulty": sum(row["difficulty"] for row in selected),
    }

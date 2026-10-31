"""Slots bonus 32x32 block-ID layout and its adjacent big-endian player start."""

from scripts.authoring.graphics import _bytes, _integer
from scripts.authoring.level_coordinates import decode_start, encode_start

# The consumer allocates entry zero plus nineteen eight-byte map descriptors.
BLOCK_COUNT = 20


def decode_layout(data):
    raw = _bytes(data)
    if len(raw) != 1024 or any(value >= BLOCK_COUNT for value in raw):
        raise ValueError("Slots bonus layout must be a 32 by 32 grid of allocated map IDs")
    return [list(raw[i : i + 32]) for i in range(0, 1024, 32)]


def encode_layout(rows):
    if len(rows) != 32 or any(len(row) != 32 for row in rows):
        raise ValueError("Slots bonus layout dimensions differ from its fixed RAM copy")
    return bytes(_integer(value, BLOCK_COUNT, "slots bonus map ID") for row in rows for value in row)

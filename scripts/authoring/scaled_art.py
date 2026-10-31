"""Software-scaling art: 64x64 raster frames with each palette nibble duplicated."""

from scripts.authoring.graphics import _bytes, _integer


def _capacity(value):
    if isinstance(value, bool) or not isinstance(value, int) or not 1 <= value <= 16:
        raise ValueError("Scaled-art frame capacity must fit the animation nibble")


def decode(data, *, max_frames=16):
    _capacity(max_frames)
    raw = _bytes(data)
    if not raw or len(raw) % 4096 or len(raw) > max_frames * 4096:
        raise ValueError("Scaled art must contain bounded complete 64 by 64 frames")
    if any(value >> 4 != value & 15 for value in raw):
        raise ValueError("Scaled-art pixels must duplicate their palette index in both nibbles")
    frames = []
    for offset in range(0, len(raw), 4096):
        frames.append([[value & 15 for value in raw[offset + row : offset + row + 64]] for row in range(0, 4096, 64)])
    return frames


def encode(frames, *, max_frames=16):
    _capacity(max_frames)
    if not 1 <= len(frames) <= max_frames:
        raise ValueError("Scaled art exceeds its target frame allocation")
    output = bytearray()
    for frame in frames:
        if len(frame) != 64 or any(len(row) != 64 for row in frame):
            raise ValueError("Scaled-art frame must retain its 64 by 64 raster")
        for row in frame:
            output.extend(_integer(pixel, 16, "scaled-art palette index") * 17 for pixel in row)
    return bytes(output)

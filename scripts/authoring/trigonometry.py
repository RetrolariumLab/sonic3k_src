"""Q8 sine/cosine samples and the normalized first-octant arctangent byte table."""

from scripts.authoring.graphics import _bytes, _integer


def decode_sine(data):
    raw = _bytes(data)
    if len(raw) != 640 or raw[512:] != raw[:128]:
        raise ValueError("Sine table needs 256 signed samples and its repeated cosine lookahead")
    return [int.from_bytes(raw[i : i + 2], "big", signed=True) for i in range(0, 512, 2)]


def encode_sine(samples):
    if len(samples) != 256:
        raise ValueError("Q8 sine table must cover 256 angular positions")
    output = bytearray()
    for value in samples:
        if isinstance(value, bool) or not isinstance(value, int) or not -32768 <= value < 32768:
            raise ValueError("Q8 sine sample exceeds its signed word")
        output.extend(value.to_bytes(2, "big", signed=True))
    return bytes(output) + bytes(output[:128])


def sine_cosine(samples, angle):
    encode_sine(samples)
    angle = _integer(angle, 65536, "angle word") & 255
    return samples[angle], samples[(angle + 64) & 255]


def decode_arctan(data):
    raw = _bytes(data)
    if len(raw) != 258 or any(value > 32 for value in raw[:257]):
        raise ValueError("Arctangent table needs 257 normalized first-octant angles and alignment")
    return {"angles": list(raw[:257]), "alignment_byte": raw[257]}


def encode_arctan(table):
    if set(table) != {"angles", "alignment_byte"} or len(table["angles"]) != 257:
        raise ValueError("Arctangent ratio samples must cover zero through 256")
    return bytes(_integer(value, 33, "first-octant angle") for value in table["angles"]) + bytes(
        [_integer(table["alignment_byte"], 256, "ignored arctangent alignment")]
    )


def vector_angle(table, x, y):
    """Return the original angle WORD, including 0x100 wrap and zero-vector 0x40."""
    encode_arctan(table)
    for value in (x, y):
        if isinstance(value, bool) or not isinstance(value, int) or not -32768 <= value < 32768:
            raise ValueError("Angle vector input must be a signed word")
    ax, ay = abs(x), abs(y)
    if not (ax or ay):
        return 64
    if ay < ax:
        result = table["angles"][(ay << 8) // ax]
    else:
        result = 64 - table["angles"][(ax << 8) // ay]
    if x < 0:
        result = 128 - result
    if y < 0:
        result = 256 - result
    return result

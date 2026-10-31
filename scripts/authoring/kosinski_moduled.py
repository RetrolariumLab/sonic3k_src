"""Bounded Kosinski Moduled archives with independent 4 KiB stream histories."""

from scripts.authoring import kosinski

MODULE_SIZE = 0x1000


def _raw(value):
    if not isinstance(value, (bytes, bytearray, memoryview)):
        raise ValueError("Kosinski Moduled input must be bytes")
    return bytes(value)


def _size(value):
    if isinstance(value, bool) or not isinstance(value, int) or not 0 < value <= 0xFFFE or value & 1:
        raise ValueError("Kosinski Moduled size must be a nonzero even 16-bit byte count")


def decode_stream(data, *, max_output=0xFFFE):
    """Return complete archive content and byte count before optional final padding."""
    source = _raw(data)
    if isinstance(max_output, bool) or not isinstance(max_output, int) or max_output < 0:
        raise ValueError("Kosinski Moduled output capacity must be a nonnegative integer")
    if len(source) < 2:
        raise ValueError("Truncated Kosinski Moduled header")
    size = int.from_bytes(source[:2], "big")
    _size(size)
    # The retained game clips the prototype placeholder header to eight modules.
    if size == 0xA000:
        size = 0x8000
    if size > max_output:
        raise ValueError("Kosinski Moduled output exceeds its declared capacity")
    output, position = bytearray(), 2
    while len(output) < size:
        expected = min(MODULE_SIZE, size - len(output))
        plain, consumed = kosinski.decode_stream(source[position:], max_output=MODULE_SIZE)
        if len(plain) < expected:
            raise ValueError("Kosinski module length differs from the archive header")
        # The game decompresses into a complete 4 KiB buffer but DMAs only
        # the declared final prefix. Three original Starpost archives have
        # 192 decoded bytes while the header transfers just 96 to VRAM.
        output.extend(plain[:expected])
        position += consumed
        if len(output) < size:
            # Alignment is relative to the first module, AFTER the two-byte header.
            position = 2 + ((position - 2 + 15) // 16) * 16
            if position >= len(source):
                raise ValueError("Truncated Kosinski Moduled alignment or next stream")
    return bytes(output), position


def decode(data, *, max_output=0xFFFE):
    return decode_stream(data, max_output=max_output)[0]


def encode(data):
    """Emit independent bounded streams, padding each non-final stream to 16 bytes."""
    plain = _raw(data)
    _size(len(plain))
    if len(plain) == 0xA000:
        raise ValueError("The game clips a 0xA000 size header to 0x8000 bytes")
    output = bytearray(len(plain).to_bytes(2, "big"))
    for offset in range(0, len(plain), MODULE_SIZE):
        output.extend(kosinski.encode(plain[offset : offset + MODULE_SIZE]))
        if offset + MODULE_SIZE < len(plain):
            output.extend(bytes((-(len(output) - 2)) % 16))
    return bytes(output)


def encode_preserving(data, original, *, max_output=0xFFFE):
    plain, reference = _raw(data), _raw(original)
    _size(len(plain))
    if len(plain) > max_output:
        raise ValueError("Kosinski Moduled output exceeds its declared capacity")
    decoded = decode(reference, max_output=max_output)
    return reference if decoded == plain else encode(plain)

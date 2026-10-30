"""Bounded Kosinski streams, following the retained 68000 decompressor.

Descriptor words are little endian and read least-significant bit first. The
next word is fetched immediately after bit 16, before any following payload.
The encoder is deterministic, but does not reproduce the original compressor.
"""

from collections import defaultdict, deque


def _bytes(value):
    if not isinstance(value, (bytes, bytearray, memoryview)):
        raise ValueError("Kosinski input must be bytes")
    return bytes(value)


class _Reader:
    def __init__(self, data):
        self.data, self.position = data, 0
        self.word, self.remaining = self.byte() | self.byte() << 8, 16

    def byte(self):
        if self.position >= len(self.data):
            raise ValueError("Truncated Kosinski stream")
        value = self.data[self.position]
        self.position += 1
        return value

    def bit(self):
        value = self.word & 1
        self.word >>= 1
        self.remaining -= 1
        if not self.remaining:
            self.word, self.remaining = self.byte() | self.byte() << 8, 16
        return value


def decode_stream(data, *, max_output=0x1000000):
    """Return decoded bytes and consumed input length, leaving container padding."""
    if isinstance(max_output, bool) or not isinstance(max_output, int) or max_output < 0:
        raise ValueError("Kosinski output limit must be a nonnegative integer")
    source = _Reader(_bytes(data))
    output = bytearray()
    while True:
        if source.bit():
            if len(output) == max_output:
                raise ValueError("Kosinski output exceeds its declared capacity")
            output.append(source.byte())
            continue
        if source.bit():
            low, high = source.byte(), source.byte()
            displacement = ((high & 0xF8) << 5 | low) - 0x2000
            count = high & 7
            if count:
                length = count + 2
            else:
                count = source.byte()
                if count == 0:
                    return bytes(output), source.position
                if count == 1:
                    continue
                length = count + 1
        else:
            high, low = source.bit(), source.bit()
            length = (high << 1 | low) + 2
            displacement = source.byte() - 256
        if -displacement > len(output):
            raise ValueError("Kosinski match precedes the decoded history")
        if len(output) + length > max_output:
            raise ValueError("Kosinski output exceeds its declared capacity")
        for _ in range(length):
            output.append(output[len(output) + displacement])


def decode(data, *, max_output=0x1000000):
    return decode_stream(data, max_output=max_output)[0]


class _Writer:
    def __init__(self):
        self.data, self.word, self.bits = bytearray(2), 0, 0

    def bit(self, value):
        self.data[self.word + self.bits // 8] |= value << (self.bits % 8)
        self.bits += 1
        if self.bits == 16:
            self.word, self.bits = len(self.data), 0
            self.data.extend(b"\0\0")

    def payload(self, *values):
        self.data.extend(values)


def encode(data):
    """Encode with a bounded greedy 8 KiB dictionary and overlapping matches."""
    raw = _bytes(data)
    writer, positions, index = _Writer(), defaultdict(deque), 0
    while index < len(raw):
        length, distance = 1, 0
        candidates = positions.get(raw[index : index + 2], ())
        for checked, previous in enumerate(reversed(candidates)):
            if index - previous > 8192 or checked == 96:
                break
            count, limit = 0, min(256, len(raw) - index)
            while count < limit and raw[previous + count] == raw[index + count]:
                count += 1
            if count == 2 and index - previous > 256:
                continue
            if count > length:
                length, distance = count, index - previous
                if count == limit:
                    break
        if length == 1:
            writer.bit(1)
            writer.payload(raw[index])
        elif distance <= 256 and length <= 5:
            writer.bit(0)
            writer.bit(0)
            writer.bit((length - 2) >> 1)
            writer.bit((length - 2) & 1)
            writer.payload((-distance) & 0xFF)
        else:
            writer.bit(0)
            writer.bit(1)
            displacement = (-distance) & 0x1FFF
            count = length - 2 if length <= 9 else 0
            writer.payload(displacement & 0xFF, (displacement >> 8) << 3 | count)
            if not count:
                writer.payload(length - 1)
        for position in range(index, index + length):
            if position + 1 < len(raw):
                queue = positions[raw[position : position + 2]]
                while queue and position - queue[0] > 8192:
                    queue.popleft()
                queue.append(position)
        index += length
    writer.bit(0)
    writer.bit(1)
    writer.payload(0, 0, 0)
    return bytes(writer.data)


def encode_preserving(data, original, *, max_output=0x1000000):
    """Preserve the original stream and padding when its decoded content agrees."""
    plain, original = _bytes(data), _bytes(original)
    if len(plain) > max_output:
        raise ValueError("Kosinski output exceeds its declared capacity")
    if decode(original, max_output=max_output) == plain:
        return original
    return encode(plain)

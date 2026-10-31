"""S3K Enigma packets and all five PCCVH flags from the retained 68000 decoder."""

from collections import Counter


def _bytes(value):
    if not isinstance(value, (bytes, bytearray, memoryview)):
        raise ValueError("Enigma input must be bytes")
    return bytes(value)


class _Reader:
    def __init__(self, data):
        self.data, self.bit = data, 48

    def read(self, width):
        if self.bit + width > len(self.data) * 8:
            raise ValueError("Truncated Enigma packet")
        value = 0
        for _ in range(width):
            value = value << 1 | (self.data[self.bit // 8] >> (7 - self.bit % 8) & 1)
            self.bit += 1
        return value


def decode_stream(data, *, max_output=0x10000, base_tile=0):
    raw = _bytes(data)
    if len(raw) < 6:
        raise ValueError("Truncated Enigma header")
    if isinstance(max_output, bool) or not isinstance(max_output, int) or max_output < 0:
        raise ValueError("Enigma output capacity must be a nonnegative integer")
    if isinstance(base_tile, bool) or not isinstance(base_tile, int) or not 0 <= base_tile <= 65535:
        raise ValueError("Enigma base tile must be a 16-bit word")
    width, flags = raw[0], raw[1] & 31
    if width > 16:
        raise ValueError("Enigma inline value is wider than a tile word")
    incremental = (int.from_bytes(raw[2:4], "big") + base_tile) & 65535
    static = (int.from_bytes(raw[4:6], "big") + base_tile) & 65535
    reader, output = _Reader(raw), bytearray()

    def emit(word):
        if len(output) + 2 > max_output:
            raise ValueError("Enigma output exceeds its declared capacity")
        output.extend((word & 65535).to_bytes(2, "big"))

    def inline():
        if width == 0:
            raise ValueError("S3K inline packets require a nonzero tile field width")
        word = base_tile
        for mask, value, addition in (
            (16, 0x8000, False),
            (8, 0x4000, True),
            (4, 0x2000, True),
            (2, 0x1000, False),
            (1, 0x800, False),
        ):
            if flags & mask and reader.read(1):
                word = ((word + value) & 65535) if addition else word | value
        return (word + reader.read(width)) & 65535

    while True:
        if reader.read(1) == 0:
            kind, count = reader.read(1), reader.read(4) + 1
            for _ in range(count):
                emit(static if kind else incremental)
                if not kind:
                    incremental = (incremental + 1) & 65535
        else:
            kind, repeat = reader.read(2), reader.read(4)
            if kind == 3 and repeat == 15:
                return bytes(output), (reader.bit + 7) // 8
            if kind == 3:
                for _ in range(repeat + 1):
                    emit(inline())
            else:
                value, delta = inline(), (0, 1, -1)[kind]
                for _ in range(repeat + 1):
                    emit(value)
                    value = (value + delta) & 65535


def decode(data, *, max_output=0x10000, base_tile=0):
    return decode_stream(data, max_output=max_output, base_tile=base_tile)[0]


class _Writer:
    def __init__(self):
        self.data, self.bit = bytearray(), 0

    def write(self, value, width):
        for shift in range(width - 1, -1, -1):
            if self.bit % 8 == 0:
                self.data.append(0)
            self.data[-1] |= ((value >> shift) & 1) << (7 - self.bit % 8)
            self.bit += 1

    def finish(self):
        # Keep the engine's word prefetch inside the emitted stream.
        return bytes(self.data) + bytes(len(self.data) % 2) + b"\0\0"


def encode(data):
    plain = _bytes(data)
    if len(plain) % 2 or len(plain) > 65536:
        raise ValueError("Enigma content must be complete tile words within 64 KiB")
    words = [int.from_bytes(plain[offset : offset + 2], "big") for offset in range(0, len(plain), 2)]
    initial = incremental = words[0] if words else 0
    static = Counter(words).most_common(1)[0][0] if words else 0
    writer, index = _Writer(), 0

    def run(start, delta):
        count = 1
        while (
            count < 16 and start + count < len(words) and words[start + count] == (words[start] + count * delta) & 65535
        ):
            count += 1
        return count

    while index < len(words):
        if words[index] == incremental:
            count = run(index, 1)
            writer.write(0, 2)
            writer.write(count - 1, 4)
            incremental = (incremental + count) & 65535
        elif words[index] == static:
            count = run(index, 0)
            writer.write(1, 2)
            writer.write(count - 1, 4)
        else:
            count, kind = max((run(index, delta), -kind) for kind, delta in enumerate((0, 1, -1)))
            kind = -kind
            if count >= 2:
                writer.write(4 + kind, 3)
                writer.write(count - 1, 4)
                writer.write(words[index], 16)
            else:
                count = 1
                while count < 15 and index + count < len(words):
                    next_index = index + count
                    if (
                        words[next_index] in (incremental, static)
                        or max(run(next_index, delta) for delta in (0, 1, -1)) >= 2
                    ):
                        break
                    count += 1
                writer.write(7, 3)
                writer.write(count - 1, 4)
                for word in words[index : index + count]:
                    writer.write(word, 16)
        index += count
    writer.write(127, 7)
    return b"\x10\0" + initial.to_bytes(2, "big") + static.to_bytes(2, "big") + writer.finish()


def encode_preserving(data, original, *, max_output=0x10000):
    plain, reference = _bytes(data), _bytes(original)
    if len(plain) > max_output:
        raise ValueError("Edited Enigma content exceeds its decoded capacity")
    decoded = decode(reference, max_output=max_output)
    return reference if plain == decoded else encode(plain)

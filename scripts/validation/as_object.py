"""Read pinned AS absolute code records without inferring address space from CPU."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Record:
    ordinal: int
    cpu: int
    segment: int
    granularity: int
    address: int
    data: bytes

    @property
    def end(self):
        return self.address + len(self.data)


def decode(data, *, max_file_size=0x1000000):
    """Return ordered code records, entry addresses and the final creator identity."""
    if isinstance(max_file_size, bool) or not isinstance(max_file_size, int) or max_file_size < 2:
        raise ValueError("AS object size bound must be an integer of at least two bytes")
    if not isinstance(data, (bytes, bytearray, memoryview)) or len(data) > max_file_size:
        raise ValueError("AS object must be bytes within its declared size bound")
    raw, position, records, entries, ordinal = bytes(data), 0, [], [], 0

    def take(size):
        nonlocal position
        if position + size > len(raw):
            raise ValueError("Truncated AS object record")
        value = raw[position : position + size]
        position += size
        return value

    def number(size):
        return int.from_bytes(take(size), "little")

    if number(2) != 0x1489:
        raise ValueError("AS object magic differs from the pinned format")
    while True:
        kind = number(1)
        if kind == 0:
            creator = raw[position:]
            if len(creator) > 1024 or any(value < 32 or value > 126 for value in creator):
                raise ValueError("Unexpected AS object creator trailer")
            return tuple(records), tuple(entries), creator.decode("ascii")
        if kind == 0x80:
            entries.append(number(4))
            ordinal += 1
            continue
        if kind == 0x81:
            cpu, segment, granularity = number(1), number(1), number(1)
        elif 0 < kind < 0x80:
            cpu, segment, granularity = kind, 1, 1
        else:
            raise ValueError("Unsupported symbolic or relocatable AS record")
        if cpu not in (1, 0x51) or segment != 1 or granularity != 1:
            raise ValueError("AS object uses an unreviewed CPU, segment or granularity")
        address, size = number(4), number(2)
        if not size or address + size > 0x100000000:
            raise ValueError("Invalid AS code record extent")
        records.append(Record(ordinal, cpu, segment, granularity, address, take(size)))
        ordinal += 1

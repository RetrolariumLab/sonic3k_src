"""Independently reconcile physical AS records, virtual Z80 segments and linked ROM."""

from dataclasses import dataclass
import hashlib

from scripts.authoring import kosinski


@dataclass(frozen=True)
class DriverSlot:
    name: str
    physical: int
    capacity: int
    virtual: int
    limit: int
    codec: str


def validate(records, image, slots):
    """Prove all emitted bytes without treating a CPU ID as an address-space flag.

    The caller must derive physical slots from the actual build's AS symbols,
    validate the source context and bind the proof to that source and object.
    This primitive does not grant ownership to any assembly file by itself.
    """
    if not isinstance(image, (bytes, bytearray, memoryview)) or len(image) < 512 or len(image) & 1:
        raise ValueError("Physical cartridge image must contain a complete aligned header")
    image = bytes(image)
    if len(slots) != 2 or [(s.name, s.virtual, s.limit) for s in slots] != [
        ("code", 0, 0x1300),
        ("tables", 0x1300, 0x1C00),
    ]:
        raise ValueError("Driver context needs its bounded code and table virtual segments")
    if {s.codec for s in slots} not in ({"raw"}, {"kosinski"}):
        raise ValueError("Driver slots must share the product's supported storage ABI")
    ranges = []
    for slot in slots:
        if (
            any(isinstance(v, bool) or not isinstance(v, int) for v in (slot.physical, slot.capacity))
            or slot.physical < 512
            or slot.capacity <= 0
            or slot.physical + slot.capacity > len(image)
        ):
            raise ValueError("Driver physical slot escapes its cartridge allocation")
        ranges.append((slot.physical, slot.physical + slot.capacity))
    if max(ranges[0][0], ranges[1][0]) < min(ranges[0][1], ranges[1][1]):
        raise ValueError("Driver physical slots overlap")
    virtual, groups, physical = {}, [], []
    index = 0
    while index < len(records):
        row = records[index]
        matching = next((s for s in slots if row.cpu == 0x51 and row.address == s.virtual), None)
        if matching is None:
            physical.append(row)
            index += 1
            continue
        if matching.name in virtual:
            raise ValueError("Duplicate virtual driver segment")
        payload = bytearray()
        start, previous = index, None
        while index < len(records) and records[index].cpu == 0x51:
            row = records[index]
            if (
                row.address != matching.virtual + len(payload)
                or row.end > matching.limit
                or (previous is not None and row.ordinal != previous + 1)
            ):
                raise ValueError("Virtual driver records overlap, have holes or exceed RAM")
            payload.extend(row.data)
            previous = row.ordinal
            index += 1
        if not payload:
            raise ValueError("Empty virtual driver segment")
        virtual[matching.name] = bytes(payload)
        groups.append(
            {
                "name": matching.name,
                "first_ordinal": records[start].ordinal,
                "records": index - start,
                "start": matching.virtual,
                "end": matching.virtual + len(payload),
            }
        )
    if [row["name"] for row in groups] != ["code", "tables"]:
        raise ValueError("Missing or reordered virtual driver segments")
    reconstructed, coverage = bytearray(len(image)), bytearray(len(image))
    for row in physical:
        if row.address < 0 or row.end > len(image) or any(coverage[row.address : row.end]):
            raise ValueError("Physical AS emission overlaps or escapes the cartridge")
        reconstructed[row.address : row.end] = row.data
        coverage[row.address : row.end] = b"\1" * len(row.data)
    if not all(coverage):
        raise ValueError("Physical AS emission leaves holes in the cartridge")
    accepted_difference = bytearray(len(image))
    containers = []
    for slot in slots:
        start, end = slot.physical, slot.physical + slot.capacity
        if reconstructed[start:end] != b"\xff" * slot.capacity:
            raise ValueError("Driver physical AS reservation is not the declared FF fill")
        stored = image[start:end]
        if slot.codec == "kosinski":
            decoded, consumed = kosinski.decode_stream(stored, max_output=slot.limit - slot.virtual)
            padding = 0
        else:
            consumed, padding = len(virtual[slot.name]), 255
            decoded = stored[:consumed]
        if decoded != virtual[slot.name]:
            raise ValueError("Physical driver container differs from raw virtual AS emission")
        if consumed > slot.capacity or stored[consumed:] != bytes([padding]) * (slot.capacity - consumed):
            raise ValueError("Driver container tail differs from declared product padding")
        accepted_difference[start:end] = b"\1" * slot.capacity
        containers.append(
            {
                "name": slot.name,
                "physical": start,
                "capacity": slot.capacity,
                "decoded_size": len(decoded),
                "consumed": consumed,
                "padding": slot.capacity - consumed,
                "decoded_sha256": hashlib.sha256(decoded).hexdigest(),
            }
        )
    checksum = sum(int.from_bytes(image[i : i + 2], "big") for i in range(512, len(image), 2)) & 65535
    if (
        int.from_bytes(image[0x18E:0x190], "big") != checksum
        or int.from_bytes(image[0x1A4:0x1A8], "big") != len(image) - 1
    ):
        raise ValueError("Cartridge header checksum or physical end differs from final image")
    accepted_difference[0x18E:0x190] = b"\1" * 2
    accepted_difference[0x1A4:0x1A8] = b"\1" * 4
    if any(a != b and not permitted for a, b, permitted in zip(reconstructed, image, accepted_difference)):
        raise ValueError("Unexplained difference between physical AS emission and linked ROM")
    return {
        "all_physical_bytes_accounted_once": True,
        "all_virtual_bytes_match_containers": True,
        "header_patches_independently_checked": True,
        "physical_sha256": hashlib.sha256(image).hexdigest(),
        "virtual_groups": groups,
        "containers": containers,
    }

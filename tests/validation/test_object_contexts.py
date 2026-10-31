"""Physical bootstrap, virtual Z80 emission, compression and accounting negatives."""

from dataclasses import replace
import unittest

from scripts.authoring import kosinski
from scripts.validation.as_object import Record
from scripts.validation.object_contexts import DriverSlot, validate


def fix_header(image):
    image[0x1A4:0x1A8] = (len(image) - 1).to_bytes(4, "big")
    checksum = sum(int.from_bytes(image[i : i + 2], "big") for i in range(512, len(image), 2)) & 65535
    image[0x18E:0x190] = checksum.to_bytes(2, "big")


def fixture(codec="raw"):
    physical = bytes([255]) * 1024
    code, tables = b"ABC", b"DATA"
    rows = [
        Record(0, 1, 1, 1, 0, physical[:256]),
        Record(1, 0x51, 1, 1, 256, physical[256:258]),
        Record(2, 1, 1, 1, 258, physical[258:528]),
        Record(3, 0x51, 1, 1, 0, code),
        Record(4, 1, 1, 1, 528, physical[528:]),
        Record(5, 0x51, 1, 1, 0x1300, tables),
    ]
    slots = [DriverSlot("code", 512, 16, 0, 0x1300, codec), DriverSlot("tables", 528, 16, 0x1300, 0x1C00, codec)]
    image = bytearray(physical)
    for slot, raw in zip(slots, (code, tables)):
        packed = kosinski.encode(raw) if codec == "kosinski" else raw
        image[slot.physical : slot.physical + slot.capacity] = packed + bytes([0 if codec == "kosinski" else 255]) * (
            slot.capacity - len(packed)
        )
    fix_header(image)
    return rows, image, slots


class ObjectContextTests(unittest.TestCase):
    def test_same_cpu_can_emit_physical_bootstrap_and_virtual_driver(self):
        rows, image, slots = fixture()
        result = validate(rows, image, slots)
        self.assertTrue(result["all_physical_bytes_accounted_once"])
        self.assertEqual([x["start"] for x in result["virtual_groups"]], [0, 0x1300])
        self.assertEqual([x["decoded_size"] for x in result["containers"]], [3, 4])

    def test_kosinski_slots_match_raw_as_and_require_zero_tails(self):
        rows, image, slots = fixture("kosinski")
        self.assertTrue(validate(rows, image, slots)["all_virtual_bytes_match_containers"])
        image[527] = 255
        fix_header(image)
        with self.assertRaisesRegex(ValueError, "padding"):
            validate(rows, image, slots)

    def test_physical_holes_overlaps_and_missing_virtual_segments_fail(self):
        rows, image, slots = fixture()
        for invalid in (rows[:1] + rows[2:], rows[:2] + [replace(rows[2], address=257)] + rows[3:], rows[:-1]):
            with self.subTest(records=len(invalid)), self.assertRaises(ValueError):
                validate(invalid, image, slots)

    def test_unexplained_rom_change_and_header_changes_cannot_be_skipped(self):
        rows, image, slots = fixture()
        image[700] = 0
        fix_header(image)
        with self.assertRaisesRegex(ValueError, "Unexplained"):
            validate(rows, image, slots)
        rows, image, slots = fixture()
        image[0x18E] ^= 1
        with self.assertRaisesRegex(ValueError, "header"):
            validate(rows, image, slots)

    def test_virtual_payload_and_physical_reservation_are_both_checked(self):
        rows, image, slots = fixture()
        bad = list(rows)
        bad[3] = replace(bad[3], data=b"XYZ")
        with self.assertRaisesRegex(ValueError, "raw virtual"):
            validate(bad, image, slots)
        bad = list(rows)
        payload = bytearray(bad[2].data)
        payload[512 - 258] = 0
        bad[2] = replace(bad[2], data=bytes(payload))
        with self.assertRaisesRegex(ValueError, "reservation"):
            validate(bad, image, slots)

    def test_unknown_contexts_overlapping_slots_and_virtual_overflow_fail(self):
        rows, image, slots = fixture()
        for invalid in (
            [replace(slots[0], limit=0x8000), slots[1]],
            [slots[0], replace(slots[1], physical=520)],
            [replace(slots[0], codec="other"), slots[1]],
        ):
            with self.assertRaises(ValueError):
                validate(rows, image, invalid)
        rows[3] = replace(rows[3], data=bytes(0x1301))
        with self.assertRaisesRegex(ValueError, "exceed RAM"):
            validate(rows, image, slots)

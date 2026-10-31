"""Virtual AS contexts are selected explicitly and must be complete."""

import unittest
from scripts.authoring import driver_inputs as codec
from scripts.validation.as_object import Record


class DriverInputTests(unittest.TestCase):
    def test_physical_z80_bootstrap_is_not_a_virtual_table(self):
        records = [
            Record(0, 0x51, 1, 1, 718, b"x"),
            Record(1, 0x51, 1, 1, 0x1300, b"ab"),
            Record(2, 0x51, 1, 1, 0x1302, b"cd"),
            Record(3, 1, 1, 1, 0x10000, b"rest"),
        ]
        self.assertEqual(codec.virtual_tables(records), b"abcd")

    def test_holes_overlaps_duplicate_cpu_contexts_and_ram_crossings_fail(self):
        good = Record(0, 0x51, 1, 1, 0x1300, b"ab")
        for records in (
            [],
            [Record(0, 1, 1, 1, 0x1300, b"ab")],
            [good, Record(1, 0x51, 1, 1, 0x1303, b"x")],
            [good, Record(1, 0x51, 1, 1, 0x1301, b"x")],
            [good, Record(2, 0x51, 1, 1, 0x1302, b"x")],
            [good, Record(1, 0x51, 1, 1, 0x1300, b"ab")],
            [Record(0, 0x51, 1, 1, 0x1300, bytes(0x901))],
        ):
            with self.subTest(records=records), self.assertRaises(ValueError):
                codec.virtual_tables(records)

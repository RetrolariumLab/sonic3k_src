"""Absolute AS record grammar, ordering, truncation and CPU/context separation."""

import struct
import unittest
from scripts.validation import as_object as codec


def record(cpu, address, data, *, extended=False, segment=1, granularity=1):
    header = bytes((0x81, cpu, segment, granularity)) if extended else bytes((cpu,))
    return header + struct.pack("<IH", address, len(data)) + data


class AsObjectTests(unittest.TestCase):
    def test_absolute_and_explicit_records_preserve_original_order(self):
        data = (
            b"\x89\x14"
            + record(1, 0, b"\x4e\x75")
            + record(0x51, 718, b"\xf3\0")
            + record(0x51, 0, b"\xc3\0\0", extended=True)
            + record(0x51, 0x1300, b"abcd")
            + b"\x80\0\x02\0\0\0AS fixture"
        )
        rows, entries, creator = codec.decode(data)
        self.assertEqual([row.address for row in rows], [0, 718, 0, 0x1300])
        self.assertEqual([row.ordinal for row in rows], [0, 1, 2, 3])
        self.assertEqual(rows[-1].end, 0x1304)
        self.assertEqual(rows[1].cpu, rows[2].cpu)
        self.assertFalse(hasattr(rows[1], "address_space"))
        self.assertEqual(entries, (0x200,))
        self.assertEqual(creator, "AS fixture")

    def test_truncated_headers_payloads_magic_and_missing_end_are_rejected(self):
        good = b"\x89\x14" + record(1, 0, b"\x4e\x75") + b"\0"
        for bad in (b"", b"\x89", b"\0\0", good[:-1], good[:-3], b"\x89\x14\x81\x51"):
            with self.subTest(data=bad), self.assertRaises(ValueError):
                codec.decode(bad)
        with self.assertRaises(ValueError):
            codec.decode(good, max_file_size=4)

    def test_unknown_record_kinds_cpus_and_segment_scales_cannot_be_skipped(self):
        for payload in (
            b"\x82",
            record(5, 0, b"a"),
            record(0x51, 0, b"a", extended=True, segment=2),
            record(0x51, 0, b"a", extended=True, granularity=2),
        ):
            with self.subTest(payload=payload), self.assertRaises(ValueError):
                codec.decode(b"\x89\x14" + payload + b"\0")

    def test_empty_overflowing_records_and_binary_trailers_are_rejected(self):
        for payload in (record(1, 0, b""), record(1, 0xFFFFFFFF, b"ab"), record(1, 0, b"a") + b"\0\xff"):
            with self.subTest(payload=payload), self.assertRaises(ValueError):
                codec.decode(b"\x89\x14" + payload + b"\0")

    def test_invalid_size_bound_types_are_rejected(self):
        for limit in (True, -1, 1, 2.5):
            with self.assertRaises(ValueError):
                codec.decode(b"\x89\x14\0", max_file_size=limit)

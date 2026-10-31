"""Independent selection, entry-code and range regressions."""

import unittest
from scripts.authoring import blue_sphere as codec


class BlueSphereTests(unittest.TestCase):
    def test_level_zero_selects_original_initial_quadrants(self):
        self.assertEqual(codec.stage_bytes(0), bytes((0, 1, 2, 3)))
        self.assertEqual(codec.stage_bytes(1), bytes((1, 4, 7, 10)))
        self.assertEqual(codec.stage_bytes(128), bytes((0, 4, 12, 24)))
        self.assertEqual(codec.stage_number(bytes((0, 1, 2, 3))), 16643)
        self.assertEqual(codec.stage_number(bytes((128, 129, 130, 131))), 16643)

    def test_level_zero_code_uses_zero_checksum_and_word_rotation(self):
        # 0x01234567 rotated right six bits is 0x9C048D15.
        # XOR gives 0x36AE27BF; the high check word is 0x55.
        expected = f"{0x5536AE27BF:012d}"
        self.assertEqual(codec.encode_code(0), expected)
        self.assertEqual(codec.decode_code(expected), {"level_index": 0, "progress": False})

    def test_codes_roundtrip_edges_progress_and_deterministic_samples(self):
        levels = [0, 1, 125, 126, 127, 128, 65535, 65536, 0x7FFFFFF]
        levels += [(index * 0x1F123B) & 0x7FFFFFF for index in range(1000)]
        for level in levels:
            for progress in (False, True):
                code = codec.encode_code(level, progress=progress)
                self.assertEqual(codec.decode_code(code), {"level_index": level, "progress": progress})

    def test_bad_digits_checksum_profiles_and_field_ranges_fail(self):
        for code in ("", "0" * 11, "0" * 13, "a" * 12, "１" * 12, 0):
            with self.assertRaises(ValueError):
                codec.decode_code(code)
        code = int(codec.encode_code(0))
        # Toggle a stored check bit, without changing any level bit.
        with self.assertRaisesRegex(ValueError, "checksum"):
            codec.decode_code(f"{code ^ (1 << 32):012d}")
        for level in (-1, 0x8000000, True, 1.5):
            with self.assertRaises(ValueError):
                codec.stage_bytes(level)
            with self.assertRaises(ValueError):
                codec.encode_code(level)
        with self.assertRaises(ValueError):
            codec.encode_code(0, progress=1)
        with self.assertRaises(ValueError):
            codec.stage_number(bytes(3))

    def test_lockon_header_seed_uses_byte_operations_and_nonzero_serial_scan(self):
        header = bytearray(512)
        header[0x180:0x18C] = b"GM 00000001-"
        header[0x114:0x116] = b"EG"
        header[0x11A:0x120] = b"88.JAN"
        # serial=1, month=0, serial-high=0, other inputs=0; 88-88=0.
        self.assertEqual(codec.level_from_lockon_header(header), 1 << 21)
        self.assertEqual(codec.level_from_lockon_header(header, header_flag=True), (1 << 21) | 1)
        header[0x11C:0x120] = b"????"
        self.assertEqual(codec.level_from_lockon_header(header), (1 << 21) | (15 << 17))
        header[0x180:0x18C] = b"GM 00000000-"
        with self.assertRaisesRegex(ValueError, "underflow"):
            codec.level_from_lockon_header(header)
        with self.assertRaises(ValueError):
            codec.level_from_lockon_header(header[:511])

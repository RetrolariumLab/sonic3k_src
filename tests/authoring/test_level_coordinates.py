"""Player start word ordering, edits and bounds."""

import unittest
from scripts.authoring import level_coordinates as codec


class LevelCoordinateTests(unittest.TestCase):
    def test_coordinates_are_x_then_y_big_endian(self):
        raw = bytes.fromhex("1234fedc")
        self.assertEqual(codec.decode_start(raw), {"x": 0x1234, "y": 0xFEDC})
        self.assertEqual(codec.encode_start(codec.decode_start(raw)), raw)

    def test_coordinate_edit_changes_one_word(self):
        model = codec.decode_start(bytes(4))
        model["y"] = 0xFFFF
        self.assertEqual(codec.encode_start(model), bytes.fromhex("0000ffff"))

    def test_partial_extra_and_invalid_fields_fail(self):
        for size in (0, 2, 5, 8):
            with self.assertRaises(ValueError):
                codec.decode_start(bytes(size))
        for value in (True, -1, 65536, 1.5):
            with self.assertRaises(ValueError):
                codec.encode_start({"x": value, "y": 0})
        with self.assertRaises(ValueError):
            codec.encode_start({"x": 0, "y": 0, "zone": 0})

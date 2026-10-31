"""Ring cursor guard, coordinate words, terminal widths and allocation checks."""

import copy
import unittest
from scripts.authoring import rings as codec


class RingCodecTests(unittest.TestCase):
    def test_independent_xy_words_and_two_terminal_widths(self):
        raw = bytes.fromhex("000000000010002001000180ffffffff")
        model = codec.decode(raw)
        self.assertEqual(model["rings"], [{"x": 16, "y": 32}, {"x": 256, "y": 384}])
        self.assertEqual(model["terminator"], {"x": 65535, "y": 65535})
        self.assertEqual(codec.encode(model), raw)
        model = codec.decode(raw[:-2])
        self.assertIsNone(model["terminator"]["y"])
        self.assertEqual(codec.encode(model), raw[:-2])

    def test_guard_is_preserved_and_actual_coordinate_edit_changes_its_field(self):
        empty = bytes.fromhex("ffff0001ffff")
        self.assertEqual(codec.encode(codec.decode(empty)), empty)
        model = codec.decode(bytes.fromhex("0000000000100020ffff"))
        model["rings"][0]["y"] = 64
        self.assertEqual(codec.encode(model), bytes.fromhex("0000000000100040ffff"))

    def test_streaming_order_is_checked_for_the_declared_axis(self):
        model = codec.decode(bytes.fromhex("000000000010002000080040ffff"))
        codec.check_order(model, "y")
        with self.assertRaisesRegex(ValueError, "ordered"):
            codec.check_order(model, "x")

    def test_bounds_truncation_terminal_shape_and_invalid_coordinates_fail(self):
        raw = bytes.fromhex("0000000000100020ffff")
        for bad in (b"", raw[:5], raw[:-2], raw + b"extra"):
            with self.subTest(raw=bad), self.assertRaises(ValueError):
                codec.decode(bad)
        with self.assertRaises(ValueError):
            codec.decode(raw, max_rings=0)
        for value in (-1, 32768, True):
            model = codec.decode(raw)
            model["rings"][0]["x"] = value
            with self.subTest(value=value), self.assertRaises(ValueError):
                codec.encode(model)
        model = codec.decode(raw)
        model["terminator"]["x"] = 1
        with self.assertRaises(ValueError):
            codec.encode(model)

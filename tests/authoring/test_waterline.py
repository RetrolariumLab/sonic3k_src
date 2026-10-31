"""Waterline active triangles, preserved unused cells, zone ABI and initial heights."""

import unittest
from scripts.authoring import waterline as codec


class WaterlineTests(unittest.TestCase):
    def test_only_leading_triangle_is_used_and_other_bytes_are_preserved(self):
        raw = bytearray(65 * 64)
        raw[0], raw[64], raw[127], raw[-1] = 191, 63, 191, 255
        model = codec.decode(raw, zone="lbz")
        self.assertEqual(model["rows"][1]["source_words"][0], 63)
        self.assertEqual(model["rows"][1]["unused_selectors"], [191])
        self.assertEqual(codec.encode(model, target_zone="lbz"), raw)
        model["rows"][1]["source_words"][0] = 2
        self.assertEqual(codec.encode(model, target_zone="lbz")[64], 2)

    def test_distance_selects_width_minus_absolute_distance_and_skips_endpoints(self):
        model = codec.decode(bytes(97 * 96), zone="hcz")
        for distance in (95, -95):
            self.assertEqual(len(codec.selectors_for_distance(model, distance)), 95)
        for distance in (1, -1):
            self.assertEqual(len(codec.selectors_for_distance(model, distance)), 1)
        for distance in (0, 96, -96, 32767):
            self.assertEqual(codec.selectors_for_distance(model, distance), [])

    def test_active_out_of_span_different_zone_and_wrong_allocation_fail(self):
        raw = bytearray(65 * 64)
        raw[64] = 64
        with self.assertRaises(ValueError):
            codec.decode(raw, zone="lbz")
        model = codec.decode(bytes(65 * 64), zone="lbz")
        with self.assertRaisesRegex(ValueError, "different"):
            codec.encode(model, target_zone="hcz")
        with self.assertRaises(ValueError):
            codec.decode(bytes(65 * 64 - 1), zone="lbz")
        model["rows"][1]["source_words"][0] = True
        with self.assertRaises(ValueError):
            codec.encode(model, target_zone="lbz")

    def test_initial_heights_are_big_endian_two_act_records(self):
        raw = bytes.fromhex("1234ffff") + bytes(60)
        model = codec.decode_starting_heights(raw)
        self.assertEqual(model[0], {"act1": 0x1234, "act2": 0xFFFF})
        self.assertEqual(codec.encode_starting_heights(model), raw)
        model[1]["act2"] = 100
        self.assertEqual(codec.encode_starting_heights(model)[6:8], bytes.fromhex("0064"))
        with self.assertRaises(ValueError):
            codec.decode_starting_heights(raw[:-2])

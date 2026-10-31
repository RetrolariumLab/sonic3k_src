"""Lookahead duplication, Q8 signed words, ratio endpoints and original angle quirks."""

import unittest
from scripts.authoring import trigonometry as codec


class TrigonometryTests(unittest.TestCase):
    def test_sine_edit_rebuilds_cosine_lookahead(self):
        samples = [0] * 256
        samples[0], samples[63], samples[255] = -256, 256, -1
        raw = codec.encode_sine(samples)
        self.assertEqual(raw[:2], bytes.fromhex("ff00"))
        self.assertEqual(raw[512:], raw[:128])
        self.assertEqual(codec.decode_sine(raw), samples)
        self.assertEqual(codec.sine_cosine(samples, 255), (-1, 256))
        samples[0] = 7
        self.assertEqual(codec.encode_sine(samples)[512:514], bytes.fromhex("0007"))
        with self.assertRaises(ValueError):
            codec.decode_sine(raw[:-1])

    def test_arctangent_ratios_quadrants_zero_and_full_word_wrap(self):
        table = {"angles": [index // 8 for index in range(257)], "alignment_byte": 165}
        raw = codec.encode_arctan(table)
        self.assertEqual(raw[-2:], bytes.fromhex("20a5"))
        self.assertEqual(codec.decode_arctan(raw), table)
        self.assertEqual(codec.vector_angle(table, 1, 1), 32)
        self.assertEqual(codec.vector_angle(table, -1, 1), 96)
        self.assertEqual(codec.vector_angle(table, -1, -1), 160)
        self.assertEqual(codec.vector_angle(table, 1, -1), 224)
        self.assertEqual(codec.vector_angle(table, 0, 0), 64)
        self.assertEqual(codec.vector_angle(table, 32767, -1), 256)

    def test_invalid_samples_bounds_and_reserved_alignment_are_distinct(self):
        with self.assertRaises(ValueError):
            codec.decode_arctan(bytes(257))
        with self.assertRaises(ValueError):
            codec.decode_arctan(bytes([33]) + bytes(257))
        samples = [0] * 256
        samples[0] = True
        with self.assertRaises(ValueError):
            codec.encode_sine(samples)

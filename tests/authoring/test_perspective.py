"""Projection field ordering, signed positions, 24-bit view pointers and ABI bounds."""

import unittest
from scripts.authoring import perspective as codec


class PerspectiveTests(unittest.TestCase):
    def raw(self):
        return bytes.fromhex("001880007fff") * (15 * 16 * 15)

    def test_depth_and_signed_xy_grid_have_independent_semantic_fields(self):
        raw = self.raw()
        model = codec.decode(raw, product="s3")
        self.assertEqual(model["frames"][0][0][0], {"scale_code": 24, "x": -32768, "y": 32767})
        self.assertEqual(codec.encode(model, target_product="s3"), raw)
        model["frames"][0][0][0]["x"] = -10
        self.assertEqual(codec.encode(model, target_product="s3")[2:4], bytes.fromhex("fff6"))

    def test_sk_views_encode_24_bit_ram_aliases_and_preserve_frame_sharing(self):
        model = codec.decode(self.raw(), product="s3")
        model["product"], model["views"] = "sk", list(range(8)) * 2 + list(range(8, 15))
        raw = codec.encode(model, target_product="sk")
        self.assertEqual(raw[:4], bytes.fromhex("00ff005c"))
        self.assertEqual(raw[32:36], raw[:4])
        self.assertEqual(codec.decode(raw, product="sk"), model)
        with self.assertRaises(ValueError):
            codec.encode(model, target_product="s3")
        bad = bytearray(raw)
        bad[:4] = bytes.fromhex("ffff005c")
        with self.assertRaisesRegex(ValueError, "24-bit"):
            codec.decode(bad, product="sk")

    def test_partial_frame_invalid_view_and_coordinate_overflow_fail(self):
        with self.assertRaises(ValueError):
            codec.decode(self.raw()[:-2], product="s3")
        model = codec.decode(self.raw(), product="s3")
        model["frames"][0][0][0]["x"] = 32768
        with self.assertRaises(ValueError):
            codec.encode(model, target_product="s3")
        model = codec.decode(self.raw(), product="s3")
        model["product"], model["views"] = "sk", [15] * 23
        with self.assertRaises(ValueError):
            codec.encode(model, target_product="sk")

    def test_scalar_signed_word_order_and_fractional_values_are_preserved(self):
        raw = bytes.fromhex("c00000004000") + bytes(506)
        model = codec.decode_scalars(raw)
        self.assertEqual(model[:3], [-16384, 0, 16384])
        self.assertEqual(codec.encode_scalars(model), raw)
        model[0] = -1
        self.assertEqual(codec.encode_scalars(model)[:2], bytes.fromhex("ffff"))
        with self.assertRaises(ValueError):
            codec.decode_scalars(raw[:-1])

"""Independent trajectory terminators, rock cursor records and VDP template fields."""

import unittest
from scripts.authoring import geometry as codec


class GeometryTests(unittest.TestCase):
    def test_slope_keeps_unused_frame_high_byte_and_negative_terminal(self):
        raw = bytes.fromhex("1234fedca50bffff")
        model = codec.decode_slope(raw)
        self.assertEqual(model["samples"][0], {"x": 0x1234, "y": 0xFEDC, "ignored_frame_high": 0xA5, "frame": 11})
        self.assertEqual(codec.encode_slope(model), raw)
        model["samples"][0]["frame"] = 12
        self.assertEqual(codec.encode_slope(model)[4:6], bytes.fromhex("a50c"))
        with self.assertRaises(ValueError):
            codec.decode_slope(raw[:-1])
        with self.assertRaises(ValueError):
            codec.decode_slope(bytes.fromhex("800000000000ffff"))

    def test_rock_record_order_and_target_style_bounds(self):
        raw = bytes.fromhex("000101000200000203000400ffffffff")
        rocks = codec.decode_rocks(raw)
        self.assertEqual(rocks, [{"style": 1, "x": 256, "y": 512}, {"style": 2, "x": 768, "y": 1024}])
        self.assertEqual(codec.encode_rocks(rocks), raw)
        codec.check_rock_order(rocks)
        codec.check_rock_styles(rocks, 3)
        with self.assertRaises(ValueError):
            codec.check_rock_styles(rocks, 2)
        with self.assertRaises(ValueError):
            codec.check_rock_order(rocks[::-1])

    def test_sprite_template_signed_offsets_dimensions_and_ignored_word_byte(self):
        raw = bytes.fromhex("fffda5cbe9551234")
        model = codec.decode_rock_sprites(raw)
        self.assertEqual((model[0]["offset_y"], model[0]["offset_x"]), (-3, 0x1234))
        self.assertEqual((model[0]["width_tiles"], model[0]["height_tiles"]), (3, 4))
        self.assertEqual((model[0]["size_reserved"], model[0]["ignored_size_high"]), (12, 165))
        self.assertEqual(codec.encode_rock_sprites(model), raw)
        model[0]["offset_x"] = -1
        self.assertEqual(codec.encode_rock_sprites(model)[-2:], bytes.fromhex("ffff"))

    def test_capacity_partial_terminal_and_invalid_field_fail_before_output(self):
        rocks = codec.decode_rocks(bytes.fromhex("000100020003ffffffff"))
        with self.assertRaises(ValueError):
            codec.encode_rocks(rocks * 2, max_rocks=1)
        with self.assertRaises(ValueError):
            codec.decode_rocks(bytes.fromhex("000100020003ffff"))
        sprite = codec.decode_rock_sprites(bytes(8))
        sprite[0]["width_tiles"] = 0
        with self.assertRaises(ValueError):
            codec.encode_rock_sprites(sprite)
        path = codec.decode_slope(bytes.fromhex("000100020003ffff"))
        path["samples"][0]["x"] = 32768
        with self.assertRaises(ValueError):
            codec.encode_slope(path)

"""Hardware field vectors and edits preserve unrelated color and tile attributes."""

import copy
import unittest
from scripts.authoring import graphics as codec


class GraphicsCodecTests(unittest.TestCase):
    def test_color_channels_and_reserved_bits_have_independent_positions(self):
        raw = bytes.fromhex("0e420000ffff")
        colors = codec.decode_palette(raw)
        self.assertEqual(colors[0], {"red": 1, "green": 2, "blue": 7, "reserved": 0})
        self.assertEqual(colors[2], {"red": 7, "green": 7, "blue": 7, "reserved": 0xF111})
        self.assertEqual(codec.encode_palette(colors), raw)
        colors[0]["red"] = 3
        self.assertEqual(codec.encode_palette(colors)[:2], bytes.fromhex("0e46"))

    def test_nibble_order_and_tile_row_order(self):
        raw = bytes.fromhex("0123456789abcdef") * 4
        tile = codec.decode_tiles(raw)[0]
        self.assertEqual(tile[0], list(range(8)))
        self.assertEqual(tile[1], list(range(8, 16)))
        self.assertEqual(codec.encode_tiles([tile]), raw)
        tile[0][1] = 15
        self.assertEqual(codec.encode_tiles([tile])[0], 15)

    def test_vdp_tile_attributes_and_a_real_edit(self):
        raw = bytes.fromhex("f923")
        records = codec.decode_tile_words(raw)
        self.assertEqual(records, [{"pattern": 0x123, "flip_x": True, "flip_y": True, "palette": 3, "priority": True}])
        self.assertEqual(codec.encode_tile_words(records), raw)
        records[0]["pattern"] = 2
        records[0]["flip_y"] = False
        self.assertEqual(codec.encode_tile_words(records), bytes.fromhex("e802"))

    def test_partial_units_and_invalid_edit_fields_are_rejected(self):
        for decoder in (codec.decode_palette, codec.decode_tile_words, codec.decode_tiles):
            with self.subTest(decoder=decoder), self.assertRaises(ValueError):
                decoder(b"\0")
        color = codec.decode_palette(b"\0\0")[0]
        for key, value in (("red", -1), ("blue", 8), ("green", True), ("reserved", 2)):
            bad = copy.deepcopy(color)
            bad[key] = value
            with self.subTest(key=key), self.assertRaises(ValueError):
                codec.encode_palette([bad])
        tile = codec.decode_tiles(bytes(32))[0]
        tile[0][0] = 16
        with self.assertRaises(ValueError):
            codec.encode_tiles([tile])
        with self.assertRaises(ValueError):
            codec.encode_tiles([[[0] * 8]])
        record = codec.decode_tile_words(b"\0\0")[0]
        for key, value in (("pattern", 2048), ("palette", 4), ("priority", 1), ("flip_x", "yes")):
            bad = copy.deepcopy(record)
            bad[key] = value
            with self.subTest(key=key), self.assertRaises(ValueError):
                codec.encode_tile_words([bad])

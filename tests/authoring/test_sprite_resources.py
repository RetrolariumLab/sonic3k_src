"""Mapping width and signed fields; incompatible DPLC bit layouts and bounds."""

import copy
import unittest
from scripts.authoring import sprite_resources as codec


class SpriteResourceTests(unittest.TestCase):
    def test_word_count_mapping_unused_pieces_size_bits_and_signed_coordinates(self):
        raw = bytes.fromhex("0001f0ab8123fffe070000090002")
        model = codec.decode_mapping(raw, abi="s3k-word-count")
        self.assertEqual(model["active_count"], 1)
        self.assertEqual(len(model["pieces"]), 2)
        piece = model["pieces"][0]
        self.assertEqual(
            (piece["y"], piece["x"], piece["width_tiles"], piece["height_tiles"], piece["size_reserved"]),
            (-16, -2, 3, 4, 160),
        )
        self.assertEqual(codec.encode_mapping(model, target_abi="s3k-word-count"), raw)
        model["pieces"][0]["x"] = 300
        self.assertEqual(codec.encode_mapping(model, target_abi="s3k-word-count")[6:8], bytes.fromhex("012c"))

    def test_s1_count_and_five_byte_pieces_have_signed_byte_x(self):
        raw = bytes.fromhex("01f00b0123fe")
        model = codec.decode_mapping(raw, abi="s1-byte-count")
        self.assertEqual(model["pieces"][0]["x"], -2)
        self.assertEqual(codec.encode_mapping(model, target_abi="s1-byte-count"), raw)
        model["pieces"][0]["x"] = 128
        with self.assertRaises(ValueError):
            codec.encode_mapping(model, target_abi="s1-byte-count")
        with self.assertRaisesRegex(ValueError, "ABI"):
            codec.encode_mapping(model, target_abi="s3k-word-count")

    def test_dplc_player_and_object_layouts_have_opposite_length_nibbles(self):
        for abi, raw in (
            ("player-high-count", bytes.fromhex("0001a123")),
            ("object-low-count-minus-one", bytes.fromhex("0000123a")),
        ):
            model = codec.decode_dplc(raw, abi=abi)
            self.assertEqual(model["active_count"], 1)
            self.assertEqual(model["transfers"], [{"source_tile": 291, "tile_count": 11}])
            self.assertEqual(codec.encode_dplc(model, target_abi=abi), raw)
            with self.assertRaisesRegex(ValueError, "source art"):
                codec.encode_dplc(model, target_abi=abi, source_tiles=300)
            with self.assertRaisesRegex(ValueError, "VRAM"):
                codec.encode_dplc(model, target_abi=abi, destination_tiles=10)

    def test_unused_transfer_is_retained_without_being_executed(self):
        raw = bytes.fromhex("0001a123ffff")
        model = codec.decode_dplc(raw, abi="player-high-count")
        self.assertEqual(
            codec.encode_dplc(model, target_abi="player-high-count", source_tiles=302, destination_tiles=11), raw
        )
        wrong = copy.deepcopy(model)
        wrong["active_count"] = 2
        with self.assertRaises(ValueError):
            codec.encode_dplc(wrong, target_abi="player-high-count", source_tiles=302)

    def test_truncation_count_abi_and_capacity_fail(self):
        for raw in (b"", bytes(1), bytes.fromhex("000100")):
            with self.assertRaises(ValueError):
                codec.decode_mapping(raw, abi="s3k-word-count")
            with self.assertRaises(ValueError):
                codec.decode_dplc(raw, abi="player-high-count")
        with self.assertRaises(ValueError):
            codec.decode_dplc(bytes.fromhex("ffff"), abi="object-low-count-minus-one")
        with self.assertRaises(ValueError):
            codec.decode_mapping(bytes.fromhex("0000000000000000"), abi="s3k-word-count", max_pieces=0)
        with self.assertRaises(ValueError):
            codec.decode_mapping(bytes(2), abi="other")

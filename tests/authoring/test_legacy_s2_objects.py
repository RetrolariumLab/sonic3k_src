"""Legacy Y flag meanings, full-byte IDs and rejection by other placement ABIs."""

import unittest
from scripts.authoring import legacy_s2_objects as codec


class LegacyS2ObjectTests(unittest.TestCase):
    def raw(self):
        return bytes.fromhex("1234f567a5c3ffff00000000")

    def test_respawn_and_two_player_flags_are_not_s3k_y_range_flags(self):
        model = codec.decode(self.raw())
        row = model["objects"][0]
        self.assertEqual((row["x"], row["y"], row["type_id"], row["subtype"]), (0x1234, 0x567, 0xA5, 0xC3))
        self.assertTrue(all(row[name] for name in ("flip_x", "flip_y", "respawn_entry", "normal_ram_in_two_player")))
        self.assertNotIn("ignore_y_range", row)
        self.assertEqual(codec.encode(model), self.raw())
        row["respawn_entry"] = False
        self.assertEqual(codec.encode(model)[2], 0x75)

    def test_another_placement_abi_and_target_respawn_overflow_fail(self):
        model = codec.decode(self.raw())
        with self.assertRaisesRegex(ValueError, "different"):
            codec.encode(model, target_abi="s3k-placement")
        codec.check_respawn_capacity(model, 1)
        with self.assertRaisesRegex(ValueError, "respawn table"):
            codec.check_respawn_capacity(model, 0)
        with self.assertRaises(ValueError):
            codec.check_respawn_capacity(model, True)

    def test_extra_terminal_padding_and_s3_flag_names_are_rejected(self):
        with self.assertRaises(ValueError):
            codec.decode(self.raw() + bytes(4))
        model = codec.decode(self.raw())
        model["objects"][0]["ignore_y_range"] = False
        with self.assertRaises(ValueError):
            codec.encode(model)

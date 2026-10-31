"""Fixed bonus layout rows, map descriptor bounds and start word ordering."""

import unittest
from scripts.authoring import slot_bonus as codec


class SlotBonusTests(unittest.TestCase):
    def test_layout_rows_and_real_id_edit(self):
        raw = bytes([0, 1, 8, 19]) + bytes(1020)
        model = codec.decode_layout(raw)
        self.assertEqual(model[0][:4], [0, 1, 8, 19])
        self.assertEqual(codec.encode_layout(model), raw)
        model[1][0] = 9
        self.assertEqual(codec.encode_layout(model)[32], 9)

    def test_start_is_two_world_position_words(self):
        raw = bytes.fromhex("13572468")
        model = codec.decode_start(raw)
        self.assertEqual(model, {"x": 4951, "y": 9320})
        self.assertEqual(codec.encode_start(model), raw)

    def test_unallocated_map_ids_truncation_and_bad_rows_fail(self):
        for raw in (bytes(1023), bytes([20]) + bytes(1023)):
            with self.assertRaises(ValueError):
                codec.decode_layout(raw)
        model = codec.decode_layout(bytes(1024))
        model[0][0] = True
        with self.assertRaises(ValueError):
            codec.encode_layout(model)
        with self.assertRaises(ValueError):
            codec.encode_layout([[0] * 32] * 31)

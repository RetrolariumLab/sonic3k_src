"""CRAM cycle dimensions, wrapping, lookahead banks and genuine color edits."""

import unittest
from scripts.authoring import palettes as codec


class PaletteCycleTests(unittest.TestCase):
    def test_special_stage_cycle_wrap_is_rebuilt_after_color_edit(self):
        cycle = bytes.fromhex("0000020406080a0c0e00020204040606")
        raw = cycle * 2 + bytes(6)
        model = codec.decode_special_stage(raw)
        self.assertEqual(codec.encode_special_stage(model), raw)
        model["cycle"][0]["red"] = 7
        encoded = codec.encode_special_stage(model)
        self.assertEqual(encoded[:2], bytes.fromhex("000e"))
        self.assertEqual(encoded[16:18], encoded[:2])
        with self.assertRaises(ValueError):
            codec.decode_special_stage(cycle + bytes(22))

    def test_pachinko_two_cycles_have_different_frame_widths(self):
        raw = bytes(1332)
        model = codec.decode_pachinko(raw)
        self.assertEqual((len(model["line4_cycle"]), len(model["line3_cycle"])), (18, 108))
        self.assertEqual((len(model["line4_cycle"][0]), len(model["line3_cycle"][0])), (7, 5))
        self.assertEqual(codec.encode_pachinko(model), raw)
        model["line3_cycle"][0][0]["blue"] = 7
        self.assertEqual(codec.encode_pachinko(model)[252:254], bytes.fromhex("0e00"))

    def test_partial_frames_bad_width_and_changed_capacities_fail(self):
        for width in (0, 65, True, 8.0):
            with self.assertRaises(ValueError):
                codec.decode_frames(bytes(32), colors_per_frame=width)
        with self.assertRaises(ValueError):
            codec.decode_frames(bytes(30), colors_per_frame=16)
        model = codec.decode_pachinko(bytes(1332))
        model["line3_cycle"].pop()
        with self.assertRaises(ValueError):
            codec.encode_pachinko(model)

"""Controller bit order, initial held state and counted-run underflow semantics."""

import unittest
from scripts.authoring import demo_input as codec


class DemoInputTests(unittest.TestCase):
    def test_raw_initial_state_and_pressed_edges(self):
        raw = bytes.fromhex("080a4a")
        model = codec.decode_raw(raw)
        self.assertTrue(model["initial_buttons"]["right"])
        self.assertTrue(model["frames"][0]["down"])
        self.assertTrue(model["frames"][1]["a"])
        self.assertTrue(codec.pressed(model["initial_buttons"], model["frames"][0])["down"])
        self.assertFalse(codec.pressed(model["initial_buttons"], model["frames"][0])["right"])
        self.assertEqual(codec.encode_raw(model), raw)

    def test_zero_counter_means_one_frame_and_ff_means_256(self):
        raw = bytes.fromhex("0040ff80")
        runs = codec.decode_runs(raw)
        self.assertEqual([row["frames"] for row in runs], [1, 256])
        self.assertTrue(runs[0]["buttons"]["a"])
        self.assertTrue(runs[1]["buttons"]["start"])
        self.assertEqual(codec.encode_runs(runs), raw)
        runs[0]["frames"] = 2
        self.assertEqual(codec.encode_runs(runs)[0], 1)

    def test_partial_pairs_frame_capacity_and_invalid_buttons_fail(self):
        for raw in (b"", b"\0", bytes(3)):
            with self.assertRaises(ValueError):
                codec.decode_runs(raw)
        with self.assertRaises(ValueError):
            codec.decode_raw(b"\0")
        with self.assertRaises(ValueError):
            codec.decode_runs(bytes.fromhex("ff00"), max_frames=255)
        runs = codec.decode_runs(bytes(2))
        for count in (0, 257, True):
            runs[0]["frames"] = count
            with self.assertRaises(ValueError):
                codec.encode_runs(runs)
        runs[0]["frames"] = 1
        runs[0]["buttons"]["a"] = 1
        with self.assertRaises(ValueError):
            codec.encode_runs(runs)

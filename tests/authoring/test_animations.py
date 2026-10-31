"""Animation commands retain their actual consumer ABI and byte boundaries."""

from copy import deepcopy
import unittest
from scripts.authoring import animations as codec


class AnimationTests(unittest.TestCase):
    def test_player_high_frames_differ_from_object_no_progress_commands(self):
        raw = bytes.fromhex("039a9bfcff")
        player = codec.decode(raw, abi="player-delay")
        self.assertEqual(player["tokens"][0], {"op": "frame", "frame": 154})
        self.assertEqual(player["tokens"][2], {"op": "hold", "code": 252})
        other = codec.decode(raw, abi="object-delay")
        self.assertEqual(other["tokens"][0], {"op": "hold", "code": 154})
        self.assertEqual(other["tokens"][2], {"op": "advance-routine"})
        self.assertEqual(codec.encode(player, target_abi="player-delay"), raw)
        with self.assertRaises(ValueError):
            codec.encode(player, target_abi="object-delay")

    def test_timing_selector_and_fixed_255_tick_delay_are_distinct(self):
        raw = bytes.fromhex("ff00ff")
        player = codec.decode(raw, abi="player-delay")
        object_model = codec.decode(raw, abi="object-delay")
        self.assertEqual(player["timing"], {"mode": "selector", "value": -1})
        self.assertEqual(object_model["timing"], {"mode": "ticks", "value": 255})
        self.assertEqual(codec.encode(player, target_abi="player-delay"), raw)

    def test_irregular_routine_skips_second_byte_then_runs_next_command(self):
        raw = bytes.fromhex("037ffc fffd01")
        model = codec.decode(raw, abi="frame-delay")
        self.assertIsNone(model["timing"])
        self.assertEqual(
            model["tokens"],
            [
                {"op": "frame", "frame": 3, "ticks": 127},
                {"op": "advance-routine", "skipped_byte": 255},
                {"op": "change-animation", "value": 1},
            ],
        )
        self.assertEqual(codec.encode(model, target_abi="frame-delay"), raw)
        self.assertEqual(codec.encode(codec.decode(b"\xfc", abi="frame-delay"), target_abi="frame-delay"), b"\xfc")
        broken = deepcopy(model)
        del broken["tokens"][1]["skipped_byte"]
        with self.assertRaises(ValueError):
            codec.encode(broken, target_abi="frame-delay")

    def test_fallthrough_fragments_and_unexecuted_restart_tail_are_preserved(self):
        for raw, abi in (
            (bytes.fromhex("01010201"), "frame-delay"),
            (bytes.fromhex("050102ffff"), "player-delay"),
            (bytes.fromhex("0701fe01fd00"), "object-delay"),
        ):
            model = codec.decode(raw, abi=abi)
            self.assertEqual(codec.encode(model, target_abi=abi), raw)
        for raw in (b"", b"\xfd", b"\xfe", b"\x01"):
            with self.assertRaises(ValueError):
                codec.decode(raw, abi="frame-delay")

    def test_frame_edit_and_byte_bounds_are_checked(self):
        model = codec.decode(bytes.fromhex("030102ff"), abi="object-delay")
        model["tokens"][0]["frame"] = 7
        self.assertEqual(codec.encode(model, target_abi="object-delay"), bytes.fromhex("030702ff"))
        model["tokens"][0]["frame"] = 128
        with self.assertRaises(ValueError):
            codec.encode(model, target_abi="object-delay")

"""Independent SMPS command lengths, hardware meanings and original byte semantics."""

import unittest
from scripts.authoring import smps_tracks as codec


class SmpsInstructionTests(unittest.TestCase):
    def decode(self, packed, channel="fm", alternate=False):
        return codec.decode_instruction(
            bytes.fromhex(packed), abi="smps3", channel=channel, alternate_frequency=alternate
        )

    def encode(self, model, channel="fm", alternate=False):
        return codec.encode_instruction(model, abi="smps3", channel=channel, alternate_frequency=alternate)

    def test_duration_rest_note_and_dac_sample_are_distinct(self):
        for raw, expected in (
            ("00", {"op": "duration", "ticks": 0}),
            ("80", {"op": "rest"}),
            ("81", {"op": "note", "semitone": 0}),
            ("df", {"op": "note", "semitone": 94}),
        ):
            model, size = self.decode(raw)
            self.assertEqual((model, size), (expected, 1))
            self.assertEqual(self.encode(model), bytes.fromhex(raw))
        model, size = self.decode("df", channel="dac")
        self.assertEqual(model, {"op": "sample", "index": 95})
        self.assertEqual(self.encode(model, channel="dac"), bytes.fromhex("df"))
        with self.assertRaises(ValueError):
            self.encode(model, channel="psg")

    def test_voice_negative_index_consumes_external_selector_even_on_psg(self):
        for channel in ("fm", "psg", "dac"):
            model, size = self.decode("ef80ab", channel)
            self.assertEqual((model, size), ({"op": "set_voice", "index": 128, "song_bank_selector": 171}, 3))
            self.assertEqual(self.encode(model, channel), bytes.fromhex("ef80ab"))
        model, size = self.decode("ef7f")
        self.assertEqual((model, size), ({"op": "set_voice", "index": 127}, 2))

    def test_loop_counter_count_and_little_endian_target(self):
        model, size = self.decode("f701031292")
        self.assertEqual((model, size), ({"op": "repeat", "counter": 1, "count": 3, "target": 0x9212}, 5))
        self.assertEqual(self.encode(model), bytes.fromhex("f701031292"))
        jump, size = self.decode("eb003481")
        self.assertEqual((jump["target"], size), (0x8134, 4))
        call, size = self.decode("f8feff")
        self.assertEqual((call["target"], size), (0xFFFE, 3))

    def test_ignored_volume_parameter_and_signed_deltas_are_preserved(self):
        model, size = self.decode("e57fc0")
        self.assertEqual((model, size), ({"op": "change_fm_volume_pair", "ignored_first": 127, "delta": -64}, 3))
        self.assertEqual(self.encode(model), bytes.fromhex("e57fc0"))
        modulation, size = self.decode("f00102ff04")
        self.assertEqual((modulation["delta"], size), (-1, 5))

    def test_meta_register_parameters_and_no_parameter_reset(self):
        for raw, expected in (
            ("ff0040", {"op": "set_main_tempo", "tempo": 64}),
            ("ff0501020304", {"op": "ssg_eg", "operator_register_values": [1, 2, 3, 4]}),
            ("ff062a0b", {"op": "fm_volume_envelope", "index": 42, "operator_mask": 11}),
            ("ff07", {"op": "reset_spindash_rev"}),
        ):
            model, size = self.decode(raw)
            self.assertEqual(model, expected)
            self.assertEqual(size, len(bytes.fromhex(raw)))
            self.assertEqual(self.encode(model), bytes.fromhex(raw))

    def test_alternate_frequency_has_two_bytes_slide_state_and_raw_duration(self):
        model, size = self.decode("1234feff", alternate=True)
        self.assertEqual(
            (model, size), ({"op": "literal_frequency", "frequency": 0x1234, "pitch_slide_state": 254, "ticks": 255}, 4)
        )
        self.assertEqual(self.encode(model, alternate=True), bytes.fromhex("1234feff"))
        with self.assertRaises(ValueError):
            self.encode(model, alternate=False)
        self.assertEqual(self.decode("fd01", alternate=True), ({"op": "alternate_frequency_mode", "control": 1}, 2))
        self.assertEqual(self.decode("81", channel="dac", alternate=True), ({"op": "sample", "index": 1}, 1))

    def test_terminal_flags_have_no_stored_unused_parameter(self):
        for raw, op in (("e3", "silence_stop"), ("f2", "stop"), ("f9", "return"), ("e7", "prevent_attack")):
            self.assertEqual(self.decode(raw), ({"op": op}, 1))
            self.assertEqual(self.encode({"op": op}), bytes.fromhex(raw))

    def test_partial_invalid_commands_fields_offsets_and_contexts_fail(self):
        for raw in ("ef80", "ff", "ff08", "f70000", "fe000000"):
            with self.subTest(raw=raw), self.assertRaises(ValueError):
                self.decode(raw)
        with self.assertRaises(ValueError):
            self.decode("1234ff", alternate=True)
        for model in (
            {"op": "note", "semitone": 95},
            {"op": "sample", "index": 0},
            {"op": "duration", "ticks": True},
            {"op": "return", "extra": 1},
            {"op": "set_voice", "index": 128},
        ):
            with self.subTest(model=model), self.assertRaises(ValueError):
                self.encode(model)
        with self.assertRaises(ValueError):
            codec.decode_instruction(b"\x80", True, abi="smps3", channel="fm")

    def test_unreachable_events_keep_a_selector_without_inventing_a_channel(self):
        model, size = self.decode("81", channel="unbound")
        self.assertEqual((model, size), ({"op": "channel_event", "selector": 1}, 1))
        self.assertEqual(self.encode(model, channel="unbound"), bytes.fromhex("81"))
        with self.assertRaises(ValueError):
            self.encode(model, channel="fm")

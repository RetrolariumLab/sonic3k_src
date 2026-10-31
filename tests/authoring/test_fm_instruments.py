"""YM2612 register positions, track-volume flags and out-of-range edit rejection."""

import copy
import unittest
from scripts.authoring import fm_instruments as codec


class FmInstrumentTests(unittest.TestCase):
    def test_independent_register_vector_has_hardware_operator_order(self):
        data = bytes.fromhex("1d214365874586c7088122436405264768192a3b4c80018203")
        voice = codec.decode_voice(data)
        self.assertEqual((voice["algorithm"], voice["feedback"]), (5, 3))
        self.assertEqual([row["index"] for row in voice["operators"]], [1, 2, 3, 4])
        self.assertEqual([row["multiple"] for row in voice["operators"]], [1, 5, 3, 7])
        self.assertTrue(voice["operators"][3]["detune_reserved"])
        self.assertEqual([row["rate_scale"] for row in voice["operators"]], [1, 3, 2, 0])
        self.assertEqual([row["decay_reserved"] for row in voice["operators"]], [0, 2, 1, 3])
        self.assertEqual([row["apply_track_volume"] for row in voice["operators"]], [True, True, False, False])
        self.assertEqual(codec.encode_voice(voice), data)

    def test_all_bits_and_a_field_edit_preserve_other_registers(self):
        for data in (bytes(25), b"\xff" * 25, bytes(range(25))):
            self.assertEqual(codec.encode_voice(codec.decode_voice(data)), data)
        data = bytes(25)
        voice = codec.decode_voice(data)
        voice["operators"][1]["attack_rate"] = 17
        expected = bytearray(data)
        expected[7] = 17
        self.assertEqual(codec.encode_voice(voice), expected)

    def test_bank_records_and_partial_instruments(self):
        raw = bytes(range(25)) + b"\xff" * 25
        self.assertEqual(codec.encode_bank(codec.decode_bank(raw)), raw)
        for bad in (b"", bytes(24), bytes(26)):
            with self.subTest(size=len(bad)), self.assertRaises(ValueError):
                codec.decode_voice(bad)
        with self.assertRaises(ValueError):
            codec.decode_bank(raw[:-1])

    def test_duplicate_operators_and_overflow_edits_fail(self):
        voice = codec.decode_voice(bytes(25))
        for field, value in (
            ("attack_rate", 32),
            ("detune", 8),
            ("sustain_level", 16),
            ("total_level", 128),
            ("apply_track_volume", 1),
        ):
            bad = copy.deepcopy(voice)
            bad["operators"][0][field] = value
            with self.subTest(field=field), self.assertRaises(ValueError):
                codec.encode_voice(bad)
        bad = copy.deepcopy(voice)
        bad["operators"][1]["index"] = 1
        with self.assertRaises(ValueError):
            codec.encode_voice(bad)
        voice["feedback"] = True
        with self.assertRaises(ValueError):
            codec.encode_voice(voice)

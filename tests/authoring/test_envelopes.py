"""Envelope command semantics, original bugs, data edits and bounded execution."""

import unittest
from scripts.authoring import envelopes as codec


class EnvelopeTests(unittest.TestCase):
    def test_modulation_commands_and_signed_pitch_atoms_roundtrip(self):
        raw = bytes.fromhex("007f808182838485ff")
        model = codec.decode(raw, family="modulation")
        self.assertEqual(model[-2:], [{"op": "pitch_delta", "value": -123}, {"op": "pitch_delta", "value": -1}])
        self.assertEqual(model[4], {"op": "jump_via_code"})
        self.assertEqual(codec.encode(model, family="modulation"), raw)
        self.assertEqual(codec.tick(bytes.fromhex("ff"), family="modulation", sensitivity=255)["delta"], -256)

    def test_jump_reads_code_not_the_following_envelope_byte(self):
        data = bytes.fromhex("82030009")
        code = bytes.fromhex("0002")
        result = codec.tick(data, family="modulation", code_memory=code)
        self.assertEqual((result["index"], result["delta"]), (3, 0))
        volume = codec.tick(data, family="volume", code_memory=code)
        self.assertEqual((volume["index"], volume["value"]), (3, 0))

    def test_sensitivity_command_reads_code_and_skips_two_data_positions(self):
        result = codec.tick(
            bytes.fromhex("840902"), family="modulation", code_memory=bytes.fromhex("0007"), sensitivity=255
        )
        self.assertEqual((result["index"], result["sensitivity"], result["delta"]), (3, 6, 14))

    def test_volume_rest_flag_does_not_immediately_silence_channel(self):
        self.assertEqual(codec.tick(bytes.fromhex("81"), family="volume")["event"], "rest_without_silencing")
        self.assertEqual(codec.tick(bytes.fromhex("83"), family="volume")["event"], "request_full_rest")
        raw = bytes.fromhex("007f8081828384ff")
        self.assertEqual(codec.encode(codec.decode(raw, family="volume"), family="volume"), raw)

    def test_invalid_atoms_missing_code_and_nonterminating_controls_fail(self):
        for family, atom in (
            ("modulation", {"op": "pitch_delta", "value": -124}),
            ("volume", {"op": "jump_via_code", "opcode": 131}),
            ("volume", {"op": "attenuation", "value": True}),
        ):
            with self.assertRaises(ValueError):
                codec.encode([atom], family=family)
        with self.assertRaisesRegex(ValueError, "unavailable"):
            codec.tick(bytes.fromhex("82"), family="volume")
        with self.assertRaisesRegex(ValueError, "budget"):
            codec.tick(bytes.fromhex("80"), family="modulation", max_steps=3)
        with self.assertRaisesRegex(ValueError, "escapes"):
            codec.tick(bytes.fromhex("8200"), family="modulation", code_memory=bytes.fromhex("00ff"))

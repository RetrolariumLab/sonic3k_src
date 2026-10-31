"""Independent SMPS music/SFX header layouts and target ABI rejection."""

import unittest
from scripts.authoring import smps_headers as codec


class SmpsHeaderTests(unittest.TestCase):
    def test_music_header_uses_little_endian_pointers_and_signed_transpose(self):
        raw = bytes.fromhex("3413010102060080fe10009001200304")
        header, consumed = codec.decode_header(raw + b"unused", kind="music", abi="smps3")
        self.assertEqual(consumed, 16)
        self.assertEqual(header["voice_pointer"], 0x1334)
        self.assertEqual(header["fm_dac"][0], {"pointer": 32768, "transpose": -2, "volume": 16})
        self.assertEqual(header["psg"][0]["modulation_envelope"], 3)
        self.assertEqual(header["psg"][0]["volume_envelope"], 4)
        self.assertEqual(codec.encode_header(header, target_abi="smps3"), raw)

    def test_sfx_header_has_explicit_playback_and_hardware_channel(self):
        raw = bytes.fromhex("0081010180c03492ff08")
        header, consumed = codec.decode_header(raw, kind="sfx", abi="smps4")
        self.assertEqual(consumed, 10)
        self.assertEqual(
            header["tracks"][0],
            {"playback_control": 128, "channel": 192, "pointer": 0x9234, "transpose": -1, "volume": 8},
        )
        self.assertEqual(codec.encode_header(header, target_abi="smps4"), raw)
        header["tracks"][0]["volume"] = 9
        self.assertEqual(codec.encode_header(header, target_abi="smps4")[-1], 9)

    def test_wrong_driver_and_truncated_or_impossible_counts_fail(self):
        raw = bytes.fromhex("0081010180c03492ff08")
        header, _ = codec.decode_header(raw, kind="sfx", abi="smps3")
        with self.assertRaisesRegex(ValueError, "different"):
            codec.encode_header(header, target_abi="smps4")
        for invalid in (raw[:-1], bytes(4), bytes.fromhex("00000108")):
            with self.assertRaises(ValueError):
                codec.decode_header(invalid, kind="sfx", abi="smps3")

    def test_invalid_hardware_channel_pointer_and_fields_fail(self):
        raw = bytes.fromhex("0081010180c03492ff08")
        for name, value in (("channel", 0xE0), ("pointer", 0x7FFF), ("transpose", -129), ("volume", True)):
            header, _ = codec.decode_header(raw, kind="sfx", abi="smps3")
            header["tracks"][0][name] = value
            with self.subTest(field=name), self.assertRaises(ValueError):
                codec.encode_header(header, target_abi="smps3")

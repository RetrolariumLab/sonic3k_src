"""Independent S3K packet dispatch, PCCVH bit order and deterministic edits."""

import random
import unittest
from scripts.authoring import enigma as codec


def stream(bits, *, width=16, flags=0, increment=0x100, static=0x200):
    bits += "0" * ((-len(bits)) % 8)
    return (
        bytes((width, flags))
        + increment.to_bytes(2, "big")
        + static.to_bytes(2, "big")
        + int(bits, 2).to_bytes(len(bits) // 8, "big")
        + b"\0\0"
    )


class EnigmaTests(unittest.TestCase):
    def test_static_six_bit_packet_differs_from_incrementing_packet(self):
        self.assertEqual(codec.decode(bytes.fromhex("0000010002004ff80000")), bytes.fromhex("0200020002000200"))
        self.assertEqual(
            codec.decode(bytes.fromhex("0000010002001ff80000")), bytes.fromhex("01000101010201030104010501060107")
        )

    def test_all_five_attribute_flags_and_palette_addition(self):
        packed = stream("1110000" + "11111" + "0011" + "1111111", width=4, flags=31)
        self.assertEqual(codec.decode(packed), bytes.fromhex("f803"))
        self.assertEqual(codec.decode(packed, base_tile=0x10), bytes.fromhex("f813"))
        self.assertEqual(codec.decode(packed, base_tile=0x6000), bytes.fromhex("5803"))
        for mask, expected in ((16, 0x8003), (8, 0x4003), (4, 0x2003), (2, 0x1003), (1, 0x803)):
            packed = stream("1110000" + "1" + "0011" + "1111111", width=4, flags=mask)
            self.assertEqual(codec.decode(packed), expected.to_bytes(2, "big"))

    def test_long_packets_repeat_ascend_descend_and_copy_literals(self):
        bits = (
            "1000001"
            + f"{0x3456:016b}"
            + "1010010"
            + f"{0x10:016b}"
            + "1100001"
            + "0" * 16
            + "1110001"
            + f"{0x1111:016b}{0x2222:016b}"
            + "1111111"
        )
        expected = (0x3456, 0x3456, 0x10, 0x11, 0x12, 0, 0xFFFF, 0x1111, 0x2222)
        self.assertEqual(codec.decode(stream(bits)), b"".join(word.to_bytes(2, "big") for word in expected))

    def test_bounds_truncation_and_bad_header_fields(self):
        packed = bytes.fromhex("0000010002004ff80000")
        for raw in (b"", packed[:5], bytes((17, 0)) + packed[2:]):
            with self.subTest(raw=raw), self.assertRaises(ValueError):
                codec.decode(raw)
        with self.assertRaises(ValueError):
            codec.decode(packed[:7])
        for limit in (0, 2, -1, True, 1.5):
            with self.subTest(limit=limit), self.assertRaises(ValueError):
                codec.decode(packed, max_output=limit)
        with self.assertRaisesRegex(ValueError, "nonzero"):
            codec.decode(stream("1110000" + "1111111", width=0))
        with self.assertRaises(ValueError):
            codec.encode(b"\0")

    def test_deterministic_encoder_edits_and_zero_edit_padding(self):
        randomizer = random.Random(1704)
        samples = [b"", bytes(200), b"\xff\xff\0\0" * 10, bytes.fromhex("0001000200030004000300020001")]
        samples += [bytes(randomizer.randrange(256) for _ in range(size)) for size in (2, 32, 198, 1000)]
        for plain in samples:
            packed = codec.encode(plain)
            self.assertEqual(codec.decode(packed), plain)
            self.assertEqual(codec.encode(plain), packed)
            self.assertEqual(codec.encode_preserving(plain, packed + b"\xff"), packed + b"\xff")
        original = bytes.fromhex("0000010002004ff80000")
        edited = bytes.fromhex("0200020002010200")
        self.assertEqual(codec.decode(codec.encode_preserving(edited, original)), edited)

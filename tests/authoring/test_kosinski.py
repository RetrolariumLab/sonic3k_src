"""Independent stream vectors, descriptor boundaries and codec input bounds."""

import random
import unittest

from scripts.authoring.kosinski import decode, decode_stream, encode, encode_preserving


class KosinskiTests(unittest.TestCase):
    def test_independent_literal_short_long_and_extended_vectors(self):
        vectors = (
            ("050041000000", b"A"),
            ("590041ff000000", b"A" * 6),
            ("150041ffff000000", b"A" * 10),
            ("150041fff8ff000000", b"A" * 257),
            ("160000000141000000", b"A"),
        )
        for encoded, expected in vectors:
            with self.subTest(encoded=encoded):
                self.assertEqual(decode(bytes.fromhex(encoded)), expected)

    def test_sixteenth_bit_fetches_descriptor_before_literal_payload(self):
        stream = b"\xff\xff" + bytes(range(15)) + b"\x02\0" + bytes((15,)) + b"\0\0\0"
        self.assertEqual(decode(stream), bytes(range(16)))
        self.assertEqual(decode(encode(bytes(range(256)) * 3)), bytes(range(256)) * 3)

    def test_consumed_length_does_not_include_container_padding(self):
        stream = bytes.fromhex("050041000000")
        self.assertEqual(decode_stream(stream + b"\xff" * 4), (b"A", len(stream)))
        self.assertEqual(encode_preserving(b"A", stream + b"\xff" * 4), stream + b"\xff" * 4)

    def test_capacity_history_and_truncation_fail_before_unbounded_output(self):
        stream = bytes.fromhex("150041fff8ff000000")
        for broken in (b"", b"\0", stream[:-1], bytes.fromhex("0000ff")):
            with self.subTest(broken=broken), self.assertRaises(ValueError):
                decode(broken)
        with self.assertRaisesRegex(ValueError, "capacity"):
            decode(stream, max_output=256)
        self.assertEqual(decode(stream, max_output=257), b"A" * 257)
        for limit in (-1, True, 1.5):
            with self.subTest(limit=limit), self.assertRaises(ValueError):
                decode(stream, max_output=limit)

    def test_encoder_reconstructs_overlaps_and_distant_dictionary_matches(self):
        randomizer = random.Random(1703)
        noise = bytes(randomizer.randrange(256) for _ in range(8400))
        samples = [b"", b"A" * 4000, bytes(range(256)) * 40, noise, noise[:30] + noise + noise[:30]]
        samples += [bytes(randomizer.randrange(8) for _ in range(size)) for size in range(1, 150, 7)]
        for sample in samples:
            packed = encode(sample)
            self.assertEqual(decode(packed, max_output=len(sample)), sample)
            self.assertEqual(packed, encode(sample))
        changed = encode_preserving(b"B", bytes.fromhex("050041000000"))
        self.assertEqual(decode(changed), b"B")
        self.assertEqual(decode(encode_preserving(b"", bytes.fromhex("050041000000"))), b"")


if __name__ == "__main__":
    unittest.main()

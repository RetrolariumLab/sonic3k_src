"""Driver nibble order, modulo accumulator, duplicate codes and lossless edit bounds."""

import unittest
from scripts.authoring import dac as codec


class DacCodecTests(unittest.TestCase):
    def setUp(self):
        self.codebook = codec.encode_codebook(list(range(-8, 8)))

    def test_independent_nibbles_and_unsigned_pcm_center(self):
        self.assertEqual(codec.decode_dpcm(bytes.fromhex("97f0"), self.codebook), [1, 0, 7, -1])
        self.assertEqual(codec.encode_dpcm([1, 0, 7, -1], self.codebook), bytes.fromhex("97f0"))
        self.assertEqual(codec.decode_pcm(bytes.fromhex("0080ff")), [-128, 0, 127])
        self.assertEqual(codec.encode_pcm([-128, 0, 127]), bytes.fromhex("0080ff"))

    def test_accumulator_wraps_and_stream_reencodes(self):
        raw = b"\xff" * 10
        samples = codec.decode_dpcm(raw, self.codebook)
        self.assertEqual(samples[:2], [7, 14])
        self.assertEqual(samples[-1], -116)
        self.assertEqual(codec.encode_dpcm(samples, self.codebook), raw)

    def test_duplicate_delta_codes_preserve_the_original_choice(self):
        codebook = codec.encode_codebook([0, 0] + list(range(1, 15)))
        original = b"\x11\x10"
        samples = codec.decode_dpcm(original, codebook)
        self.assertEqual(samples, [0, 0, 0, 0])
        self.assertEqual(codec.encode_dpcm(samples, codebook), bytes(2))
        self.assertEqual(codec.encode_preserving(samples, original, codebook), original)

    def test_bad_samples_codebooks_partial_frames_and_capacity_are_rejected(self):
        for bad in ([-129], [128], [True], [1.5]):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                codec.encode_pcm(bad)
        for bad in (b"", bytes(15), bytes(17)):
            with self.subTest(size=len(bad)), self.assertRaises(ValueError):
                codec.decode_dpcm(b"\0", bad)
        with self.assertRaises(ValueError):
            codec.encode_dpcm([0], self.codebook)
        with self.assertRaisesRegex(ValueError, "outside"):
            codec.encode_dpcm([30, 30], self.codebook)
        with self.assertRaisesRegex(ValueError, "capacity"):
            codec.decode_dpcm(b"\0", self.codebook, max_samples=1)
        with self.assertRaises(ValueError):
            codec.decode_pcm(b"\0", max_samples=True)

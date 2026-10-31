"""Pinned Core synthetic streams, edited content and bounded reference codecs."""

import os
import unittest
from scripts.authoring import core_compression as codec


class CoreCompressionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (codec.BUILD / "binding.json").is_file() and not os.environ.get("RETROLARIUM_CORE_SOURCE"):
            raise unittest.SkipTest(
                "Native Core needs make prepare-core and RETROLARIUM_CORE_SOURCE; full content gates require it"
            )
        codec.tool()

    def test_nemesis_independent_flat_tile_and_forced_reencoding(self):
        stream = bytes.fromhex("0001057200ff00000000")
        plain = b"\x55" * 32
        self.assertEqual(codec.decode_nemesis(stream), plain)
        self.assertEqual(codec.decode_nemesis(codec.encode_nemesis(plain, stream)), plain)
        edited = b"\x65" + plain[1:]
        self.assertEqual(codec.decode_nemesis(codec.encode_nemesis(edited, stream)), edited)

    def test_nemesis_xor_register_words_are_applied(self):
        stream = bytes.fromhex("8001013200740e823201751e83720284730685363eff1b77adf7c00000")
        plain = bytes.fromhex("1111222222221111666655557777444455556666666655552222111177774444")
        self.assertEqual(codec.decode_nemesis(stream), plain)
        self.assertEqual(codec.decode_nemesis(codec.encode_nemesis(plain, stream)), plain)

    def test_unchanged_original_stream_padding_is_preserved(self):
        original = bytes.fromhex("0001057200ff00000000") + bytes((255, 255))
        self.assertEqual(codec.encode_preserving("nemesis", codec.decode_nemesis(original), original), original)

    def test_truncation_limits_wrong_count_and_unverified_dialect_fail(self):
        for raw in (bytes(), bytes(1)):
            with self.assertRaises(ValueError):
                codec.decode_nemesis(raw)
        for capacity in (-1, True, 1.5):
            with self.assertRaises(ValueError):
                codec.decode_nemesis(bytes(8), max_output=capacity)
        reference = bytes.fromhex("0001057200ff00000000")
        with self.assertRaisesRegex(ValueError, "capacity"):
            codec.decode_nemesis(reference, max_output=31)
        with self.assertRaisesRegex(ValueError, "tile count"):
            codec.encode_nemesis(bytes(64), reference)
        with self.assertRaisesRegex(ValueError, "Nemesis dialect"):
            codec.encode_preserving("enigma", b"", bytes(8))

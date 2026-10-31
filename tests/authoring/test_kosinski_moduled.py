"""Archive headers, relative module alignment and independent payload bounds."""

import unittest
from scripts.authoring import kosinski
from scripts.authoring import kosinski_moduled as codec


class KosinskiModuledTests(unittest.TestCase):
    def test_independent_literal_header_and_final_padding(self):
        stream = bytes.fromhex("00020b004142000000")
        self.assertEqual(codec.decode_stream(stream + b"\xff\xff"), (b"AB", len(stream)))
        self.assertEqual(codec.encode_preserving(b"AB", stream + b"\xff"), stream + b"\xff")

    def test_next_module_alignment_starts_after_header(self):
        first = kosinski.encode(bytes(0x1000))
        padding = b"\xff" * ((-len(first)) % 16)
        last = bytes.fromhex("0b004142000000")
        stream = b"\x10\x02" + first + padding + last
        self.assertEqual(codec.decode(stream), bytes(0x1000) + b"AB")
        self.assertEqual(codec.decode_stream(stream + b"padding")[1], len(stream))

    def test_bad_header_limits_truncation_and_module_size_are_rejected(self):
        for data in (b"", b"\0", b"\0\0", b"\0\x03", bytes.fromhex("00040b004142000000")):
            with self.subTest(data=data), self.assertRaises(ValueError):
                codec.decode(data)
        stream = bytes.fromhex("00020b004142000000")
        for limit in (0, 1, -1, True, 1.5):
            with self.subTest(limit=limit), self.assertRaises(ValueError):
                codec.decode(stream, max_output=limit)
        with self.assertRaises(ValueError):
            codec.decode(stream[:-1])
        for data in (b"", b"A", bytes(65536)):
            with self.subTest(size=len(data)), self.assertRaises(ValueError):
                codec.encode(data)

    def test_deterministic_multimodule_reencoding_and_real_edit(self):
        original = bytes(range(256)) * 34
        packed = codec.encode(original)
        self.assertEqual(codec.decode(packed), original)
        self.assertEqual(codec.encode(original), packed)
        changed = original[:-2] + b"XY"
        self.assertEqual(codec.decode(codec.encode_preserving(changed, packed)), changed)
        self.assertEqual(codec.encode_preserving(original, packed), packed)

    def test_final_module_only_transfers_the_header_prefix_to_vram(self):
        original = b"\x00\x02" + kosinski.encode(b"ABCD") + b"\xff"
        self.assertEqual(codec.decode(original), b"AB")
        self.assertEqual(codec.encode_preserving(b"AB", original), original)
        self.assertEqual(codec.decode(codec.encode_preserving(b"XY", original)), b"XY")
        with self.assertRaises(ValueError):
            codec.decode(b"\x00\x02" + kosinski.encode(bytes(4098)))

    def test_prototype_header_clips_placeholder_modules(self):
        first = kosinski.encode(bytes(4096))
        module = first + bytes((-len(first)) % 16)
        stream = b"\xa0\x00" + module * 7 + first
        self.assertEqual(codec.decode(stream), bytes(32768))
        with self.assertRaisesRegex(ValueError, "clips"):
            codec.encode(bytes(0xA000))

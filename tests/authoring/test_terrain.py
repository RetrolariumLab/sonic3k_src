"""Independent block tile order, chunk flip/solidity fields and target table bounds."""

import copy
import unittest
from scripts.authoring import terrain as codec


class TerrainCodecTests(unittest.TestCase):
    def test_block_words_are_row_major_two_by_two(self):
        raw = bytes.fromhex("000108021003e004")
        model = codec.decode_blocks(raw)
        self.assertEqual([[cell["pattern"] for cell in row] for row in model[0]], [[1, 2], [3, 4]])
        self.assertTrue(model[0][0][1]["flip_x"])
        self.assertTrue(model[0][1][0]["flip_y"])
        self.assertEqual(codec.encode_blocks(model), raw)

    def test_chunk_word_fields_and_a_real_block_edit(self):
        raw = bytes.fromhex("e955") * 64
        chunks = codec.decode_chunks(raw)
        self.assertEqual(
            chunks[0][0][0], {"block": 0x155, "flip_x": False, "flip_y": True, "solidity_a": 2, "solidity_b": 3}
        )
        self.assertEqual(codec.encode_chunks(chunks), raw)
        chunks[0][0][0]["block"] = 1
        self.assertEqual(codec.encode_chunks(chunks)[:2], bytes.fromhex("e801"))

    def test_invalid_dimensions_partial_units_and_bit_fields_are_rejected(self):
        for decoder in (codec.decode_blocks, codec.decode_chunks):
            with self.subTest(decoder=decoder), self.assertRaises(ValueError):
                decoder(b"\0")
        with self.assertRaises(ValueError):
            codec.encode_blocks([[]])
        with self.assertRaises(ValueError):
            codec.encode_chunks([[]])
        original = codec.decode_chunks(bytes(128))
        for name, value in (("block", 1024), ("solidity_a", 4), ("flip_y", 1)):
            chunks = copy.deepcopy(original)
            chunks[0][0][0][name] = value
            with self.subTest(field=name), self.assertRaises(ValueError):
                codec.encode_chunks(chunks)

    def test_declared_capacities_and_cross_asset_references_are_enforced(self):
        with self.assertRaises(ValueError):
            codec.decode_blocks(bytes(8), max_blocks=0)
        with self.assertRaises(ValueError):
            codec.decode_chunks(bytes(128), max_chunks=0)
        chunks = codec.decode_chunks(bytes(128))
        codec.check_chunk_references(chunks, 1)
        chunks[0][0][0]["block"] = 1
        with self.assertRaisesRegex(ValueError, "outside"):
            codec.check_chunk_references(chunks, 1)

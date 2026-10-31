"""Independent level pointers, chunk grids, editing and memory limits."""

import unittest
from scripts.authoring import level_layout as codec


class LevelLayoutTests(unittest.TestCase):
    def model(self):
        return {"foreground": {"width": 2, "rows": [[1, 2], [3, 4]]}, "background": {"width": 1, "rows": [[5]]}}

    def test_header_word_order_ram_pointers_and_padding(self):
        model = self.model()
        raw = codec.encode(model)
        self.assertEqual(raw[:8], bytes.fromhex("0002000100020001"))
        self.assertEqual(raw[8:16], bytes.fromhex("8088808c808a0000"))
        self.assertEqual(raw[136:], bytes.fromhex("010203040500"))
        self.assertEqual(codec.decode(raw), model)

    def test_growing_a_foreground_row_recomputes_background_pointer(self):
        model = self.model()
        model["foreground"]["rows"].append([6, 7])
        raw = codec.encode(model)
        self.assertEqual(raw[10:12], bytes.fromhex("808e"))
        self.assertEqual(codec.decode(raw), model)
        codec.check_chunk_references(model, 8)
        with self.assertRaises(ValueError):
            codec.check_chunk_references(model, 7)

    def test_truncation_dangling_and_unused_pointers_fail(self):
        raw = codec.encode(self.model())
        for invalid in (raw[:135], raw[:-1], bytes(4098)):
            with self.assertRaises(ValueError):
                codec.decode(invalid)
        for offset, pointer in ((8, 0x807F), (8, 0x9000), (16, 0x8088)):
            invalid = bytearray(raw)
            invalid[offset : offset + 2] = pointer.to_bytes(2, "big")
            with self.assertRaises(ValueError):
                codec.decode(invalid)

    def test_aliases_and_nonzero_alignment_are_not_silently_normalized(self):
        raw = bytearray(codec.encode(self.model()))
        raw[12:14] = raw[8:10]
        with self.assertRaisesRegex(ValueError, "noncanonical"):
            codec.decode(raw)
        raw = bytearray(codec.encode(self.model()))
        raw[-1] = 1
        with self.assertRaisesRegex(ValueError, "noncanonical"):
            codec.decode(raw)

    def test_row_count_width_cell_and_total_capacity_are_checked(self):
        for width, rows in ((0, [[]]), (1, [[0]] * 33), (4096, [[0] * 4096]), (2, [[0]]), (1, [[256]])):
            model = self.model()
            model["foreground"] = {"width": width, "rows": rows}
            with self.subTest(width=width, height=len(rows)), self.assertRaises(ValueError):
                codec.encode(model)

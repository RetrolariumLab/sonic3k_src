"""Placed-object coordinates, renderer flips, vertical range flag and target bounds."""

import copy
import unittest
from scripts.authoring import object_placements as codec


class ObjectPlacementTests(unittest.TestCase):
    def test_independent_record_fields_and_both_terminal_padding_variants(self):
        raw = bytes.fromhex("1234a5671234ffff00000000")
        model = codec.decode(raw)
        self.assertEqual(
            model["objects"],
            [
                {
                    "x": 0x1234,
                    "y": 0x567,
                    "flip_x": True,
                    "flip_y": False,
                    "ignore_y_range": True,
                    "reserved_bit12": False,
                    "type_id": 0x12,
                    "subtype": 0x34,
                }
            ],
        )
        self.assertEqual(codec.encode(model), raw)
        self.assertEqual(codec.encode(codec.decode(raw + bytes(4))), raw + bytes(4))

    def test_y_edit_preserves_all_flags_and_reserved_bit(self):
        raw = bytes.fromhex("0010f1230102ffff00000000")
        model = codec.decode(raw)
        model["objects"][0]["y"] = 0x456
        self.assertEqual(codec.encode(model), bytes.fromhex("0010f4560102ffff00000000"))
        codec.check_order(model)

    def test_partial_records_bad_terminal_padding_and_invalid_field_values(self):
        raw = bytes.fromhex("1234a5671234ffff00000000")
        for bad in (b"", raw[:5], raw[:-6], raw[:-1] + b"\1"):
            with self.subTest(raw=bad), self.assertRaises(ValueError):
                codec.decode(bad)
        for field, value in (("x", 65535), ("y", 4096), ("type_id", 256), ("subtype", -1), ("flip_x", 1)):
            model = codec.decode(raw)
            model["objects"][0][field] = value
            with self.subTest(field=field), self.assertRaises(ValueError):
                codec.encode(model)

    def test_empty_layout_capacity_and_streaming_order(self):
        raw = b"\xff\xff" + bytes(4)
        self.assertEqual(codec.encode(codec.decode(raw, max_objects=0), max_objects=0), raw)
        model = codec.decode(bytes.fromhex("001000000000ffff00000000"))
        with self.assertRaises(ValueError):
            codec.encode(model, max_objects=0)
        model["objects"].append(copy.deepcopy(model["objects"][0]))
        model["objects"][1]["x"] = 1
        with self.assertRaisesRegex(ValueError, "sorted"):
            codec.check_order(model)

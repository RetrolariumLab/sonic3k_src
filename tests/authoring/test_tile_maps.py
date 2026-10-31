"""Frame-major versus interleaved glyph rows, VDP tile edits and immutable layout ABI."""

import unittest
from scripts.authoring import tile_maps as codec


def layout(columns, rows, frames=1, packing="frames"):
    return {"columns": columns, "rows": rows, "frames": frames, "packing": packing}


class TileMapTests(unittest.TestCase):
    def test_rectangular_map_keeps_row_order_and_tile_attributes(self):
        spec = layout(2, 2)
        raw = bytes.fromhex("000108021003e004")
        model = codec.decode(raw, layout=spec)
        self.assertEqual([[tile["pattern"] for tile in row] for row in model["frames"][0]], [[1, 2], [3, 4]])
        self.assertTrue(model["frames"][0][0][1]["flip_x"])
        self.assertEqual(codec.encode(model, target_layout=spec), raw)
        model["frames"][0][1][0]["pattern"] = 5
        self.assertEqual(codec.encode(model, target_layout=spec)[4:6], bytes.fromhex("1005"))

    def test_contiguous_digits_differ_from_horizontal_row_atlas(self):
        raw = bytes.fromhex("0001000200030004")
        contiguous = layout(1, 2, 2)
        atlas = layout(1, 2, 2, "horizontal-atlas")
        first = codec.decode(raw, layout=contiguous)
        second = codec.decode(raw, layout=atlas)
        self.assertEqual([row[0]["pattern"] for row in first["frames"][0]], [1, 2])
        self.assertEqual([row[0]["pattern"] for row in second["frames"][0]], [1, 3])
        self.assertEqual(codec.encode(first, target_layout=contiguous), raw)
        self.assertEqual(codec.encode(second, target_layout=atlas), raw)
        with self.assertRaisesRegex(ValueError, "different"):
            codec.encode(first, target_layout=atlas)

    def test_partial_maps_shape_growth_and_invalid_dimensions_fail(self):
        spec = layout(2, 2)
        with self.assertRaises(ValueError):
            codec.decode(bytes(6), layout=spec)
        for invalid in (layout(True, 2), layout(0, 2), layout(2, 129), layout(2, 2, 257)):
            with self.assertRaises(ValueError):
                codec.decode(bytes(8), layout=invalid)
        model = codec.decode(bytes(8), layout=spec)
        model["frames"][0][0].append(model["frames"][0][0][0])
        with self.assertRaises(ValueError):
            codec.encode(model, target_layout=spec)

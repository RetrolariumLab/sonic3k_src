"""Independent special-stage field ordering, product ABI and quadrant mirroring."""

import unittest
from scripts.authoring import special_stage as codec


class SpecialStageTests(unittest.TestCase):
    def test_record_fields_and_real_cell_edit(self):
        raw = bytes.fromhex("0001020304") + bytes(1019) + bytes.fromhex("400012341fff0040")
        model = codec.decode_record(raw, product="s3")
        self.assertEqual(model["cells"][0][:5], ["empty", "red_sphere", "blue_sphere", "bumper", "ring"])
        self.assertEqual((model["angle"], model["x_8_8"], model["y_8_8"], model["rings_left"]), (16384, 4660, 8191, 64))
        self.assertEqual(codec.encode_record(model, product="s3"), raw)
        model["cells"][0][0] = "blue_sphere"
        self.assertEqual(codec.encode_record(model, product="s3")[0], 2)

    def test_yellow_sphere_requires_sk_abi(self):
        raw = bytes([5]) + bytes(1031)
        model = codec.decode_record(raw, product="sk")
        self.assertEqual(model["cells"][0][0], "yellow_sphere")
        self.assertEqual(codec.encode_record(model, product="sk"), raw)
        with self.assertRaises(ValueError):
            codec.decode_record(raw, product="s3")
        with self.assertRaises(ValueError):
            codec.encode_record(model, product="s3")

    def test_sk_stage_set_has_eight_distinct_records(self):
        raw = b"".join(bytes([index % 6]) + bytes(1031) for index in range(8))
        model = codec.decode_sk_set(raw)
        self.assertEqual(codec.encode_sk_set(model), raw)
        with self.assertRaises(ValueError):
            codec.encode_sk_set(model[:7])
        with self.assertRaises(ValueError):
            codec.decode_sk_set(raw[:-1])

    def bank(self):
        raw = bytes([9]) * 128 + bytes([3]) * 128 + bytes(128 * 256)
        return codec.decode_blue_sphere_bank(raw)

    def test_bank_metadata_arrays_are_separate_and_roundtrip(self):
        raw = bytes([9]) * 128 + bytes([3]) * 128 + bytes(128 * 256)
        model = codec.decode_blue_sphere_bank(raw)
        self.assertEqual((model[0]["rings_left"], model[127]["difficulty"]), (9, 3))
        self.assertEqual(codec.encode_blue_sphere_bank(model), raw)

    def test_generator_mirrors_each_quadrant_and_masks_selection_bit(self):
        bank = self.bank()
        for index, cell in enumerate(("red_sphere", "blue_sphere", "bumper", "ring")):
            bank[index]["cells"][0][0] = cell
        model = codec.compose_blue_sphere_stage(bank, [128, 1, 2, 3])
        grid = model["cells"]
        self.assertEqual(
            (grid[0][0], grid[0][31], grid[31][0], grid[31][31]), ("red_sphere", "blue_sphere", "bumper", "ring")
        )
        self.assertEqual((model["rings_left"], model["difficulty"]), (36, 12))
        self.assertEqual((model["angle"], model["x_8_8"], model["y_8_8"]), (0x4000, 0x1000, 0x300))

    def test_bad_cells_shapes_fields_and_selection_are_rejected(self):
        for raw in (bytes(1031), bytes([6]) + bytes(1031)):
            with self.assertRaises(ValueError):
                codec.decode_record(raw, product="sk")
        with self.assertRaises(ValueError):
            codec.decode_blue_sphere_bank(bytes(33023))
        bank = self.bank()
        with self.assertRaises(ValueError):
            codec.compose_blue_sphere_stage(bank, [0, 1, 2])
        with self.assertRaises(ValueError):
            codec.compose_blue_sphere_stage(bank, [0, 1, 2, True])
        bank[0]["difficulty"] = 256
        with self.assertRaises(ValueError):
            codec.encode_blue_sphere_bank(bank)

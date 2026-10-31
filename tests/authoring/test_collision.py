"""Independent collision ABI, height sign and angle flag cases."""

import unittest
from scripts.authoring import collision as codec


class CollisionTests(unittest.TestCase):
    def test_s3_separate_word_paths_and_shape_511(self):
        raw = bytes.fromhex("01ff") + bytes(1534) + bytes.fromhex("0123") + bytes(1534)
        model = codec.decode_indices(raw, abi="s3-planar16")
        self.assertEqual(model[0], {"path_a": 511, "path_b": 291})
        self.assertEqual(codec.encode_indices(model, abi="s3-planar16"), raw)
        with self.assertRaises(ValueError):
            codec.encode_indices(model, abi="sk-interleaved8")

    def test_sk_interleaved_bytes_and_an_edited_path(self):
        raw = bytes.fromhex("12fe") + bytes(1534)
        model = codec.decode_indices(raw, abi="sk-interleaved8")
        self.assertEqual(model[0], {"path_a": 18, "path_b": 254})
        self.assertEqual(codec.encode_indices(model, abi="sk-interleaved8"), raw)
        model[0]["path_b"] = 4
        self.assertEqual(codec.encode_indices(model, abi="sk-interleaved8")[:2], bytes.fromhex("1204"))
        with self.assertRaises(ValueError):
            codec.decode_indices(raw, abi="s3-planar16")

    def test_signed_heights_and_rotated_tables_keep_their_own_samples(self):
        raw = bytes.fromhex("80ff00107f") + bytes(4091)
        model = codec.decode_heights(raw, shape_count=256)
        self.assertEqual(model[0][:5], [-128, -1, 0, 16, 127])
        self.assertEqual(codec.encode_heights(model, shape_count=256), raw)
        model[0][0] = -129
        with self.assertRaises(ValueError):
            codec.encode_heights(model, shape_count=256)

    def test_odd_angles_are_fallback_flags_not_rounded_away(self):
        raw = bytes.fromhex("0180ff") + bytes(253)
        model = codec.decode_angles(raw, shape_count=256)
        self.assertEqual(model[0], {"angle": 0, "use_fallback": True})
        self.assertEqual(model[2], {"angle": 254, "use_fallback": True})
        self.assertEqual(codec.encode_angles(model, shape_count=256), raw)
        model[0]["angle"] = 1
        with self.assertRaises(ValueError):
            codec.encode_angles(model, shape_count=256)

    def test_allocations_partial_units_and_boolean_indices_fail(self):
        for count in (0, 255, True, 256.0):
            with self.assertRaises(ValueError):
                codec.decode_heights(b"", shape_count=count)
        with self.assertRaises(ValueError):
            codec.decode_indices(bytes(3072), abi="other")
        with self.assertRaises(ValueError):
            codec.decode_heights(bytes(4095), shape_count=256)
        with self.assertRaises(ValueError):
            codec.decode_angles(bytes(255), shape_count=256)
        model = codec.decode_indices(bytes(1536), abi="sk-interleaved8")
        model[0]["path_a"] = True
        with self.assertRaises(ValueError):
            codec.encode_indices(model, abi="sk-interleaved8")

    def test_sk_lockon_cannot_use_the_upper_half_of_s3_shape_space(self):
        raw = bytes.fromhex("012c") + bytes(3070)
        model = codec.decode_indices(raw, abi="s3-planar16")
        codec.check_shape_references(model, shape_count=512)
        with self.assertRaisesRegex(ValueError, "target shape"):
            codec.check_shape_references(model, shape_count=256)

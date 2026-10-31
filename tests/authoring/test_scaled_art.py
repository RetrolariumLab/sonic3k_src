"""Scaling raster stride, duplicated palette nibbles, frames and edit capacities."""

import unittest
from scripts.authoring import scaled_art as codec


class ScaledArtTests(unittest.TestCase):
    def test_raster_rows_and_frames_do_not_use_vdp_tile_order(self):
        raw = bytearray(8192)
        raw[0], raw[64], raw[4096] = 0x11, 0xAA, 0xFF
        frames = codec.decode(raw)
        self.assertEqual((frames[0][0][0], frames[0][1][0], frames[1][0][0]), (1, 10, 15))
        self.assertEqual(codec.encode(frames), raw)
        frames[0][0][1] = 7
        self.assertEqual(codec.encode(frames)[1], 0x77)

    def test_mismatched_nibbles_partial_frames_and_target_capacity_fail(self):
        for raw in (bytes(4095), bytes.fromhex("12") + bytes(4095)):
            with self.assertRaises(ValueError):
                codec.decode(raw)
        with self.assertRaises(ValueError):
            codec.decode(bytes(8192), max_frames=1)
        frames = codec.decode(bytes(8192))
        with self.assertRaises(ValueError):
            codec.encode(frames, max_frames=1)

    def test_pixel_field_and_grid_are_bounded_before_encoding(self):
        frame = codec.decode(bytes(4096))
        for value in (16, -1, True):
            frame[0][0][0] = value
            with self.assertRaises(ValueError):
                codec.encode(frame)
        with self.assertRaises(ValueError):
            codec.encode([[[0]]])

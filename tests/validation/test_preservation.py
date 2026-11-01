"""Historical entry and procedure preservation must reject loss, movement and merging."""

from collections import Counter
import unittest
from unittest.mock import patch
from scripts.validation import preservation as codec


class PreservationTests(unittest.TestCase):
    def test_every_historical_entry_must_remain_at_the_same_normal_address(self):
        expected = {"Startup": 512, "Worker": 1024}
        self.assertEqual(codec.compare_entries(expected, dict(expected)), 2)
        for actual in ({"Startup": 512}, expected | {"Extra": 1026}, expected | {"Worker": 1026}):
            with self.assertRaises(ValueError):
                codec.compare_entries(expected, actual)

    def test_named_terminal_and_exact_start_boundaries_are_a_multiset(self):
        item = ("Worker", "rts", True)
        expected = Counter({item: 2})
        self.assertEqual(codec.compare_procedures(expected, Counter({item: 2})), 2)
        for actual in (
            Counter({item: 1}),
            Counter({("Worker", "jmp", True): 2}),
            Counter({("Worker", "rts", False): 2}),
        ):
            with self.assertRaises(ValueError):
                codec.compare_procedures(expected, actual)

    def test_registered_entry_view_preserves_every_original_address(self):
        original = {"sub_1234": 1024, "Keep": 2048}
        renamed = {"ReadState": 1024, "Keep": 2048}
        mapping = {"sub_1234": "ReadState"}
        self.assertEqual(codec.compare_entries(original, renamed, mapping), 2)
        self.assertEqual(original, {"sub_1234": 1024, "Keep": 2048})
        for actual in (
            {"ReadState": 1026, "Keep": 2048},
            {"ReadState": 1024},
            renamed | {"Extra": 4096},
            renamed | {"sub_1234": 1024},
        ):
            with self.subTest(actual=actual), self.assertRaises(ValueError):
                codec.compare_entries(original, actual, mapping)
        with self.assertRaisesRegex(ValueError, "collide"):
            codec.compare_entries(original, {"Keep": 1024}, {"sub_1234": "Keep"})

    def test_registered_procedure_names_cannot_mask_merging_or_boundary_changes(self):
        original = Counter({("sub_1234", "rts", True): 2})
        mapping = {"sub_1234": "ReadState"}
        self.assertEqual(codec.compare_procedures(original, Counter({("ReadState", "rts", True): 2}), mapping), 2)
        for actual in (
            Counter({("ReadState", "rts", True): 1}),
            Counter({("ReadState", "jmp", True): 2}),
            Counter({("ReadState", "rts", False): 2}),
        ):
            with self.subTest(actual=actual), self.assertRaises(ValueError):
                codec.compare_procedures(original, actual, mapping)
        collision = original + Counter({("ReadState", "rts", True): 1})
        with self.assertRaisesRegex(ValueError, "collide"):
            codec.compare_procedures(collision, Counter({("ReadState", "rts", True): 3}), mapping)

    def test_origin_ranges_keep_the_git_blob_physical_line_numbers(self):
        text = bytes((10,)) + b"Worker:\n rts\n; End of function Worker\n"
        with patch.object(codec.subprocess, "check_output", return_value=text):
            document = codec.origin_document("a" * 40, "fixture.s")
        # The probe follows the explicit terminal marker on physical line four.
        self.assertEqual(document["points"][0]["after"], 4)

"""Guard real edit recipe bounds and independent lock-on consumer placement."""

from copy import deepcopy
import unittest
from unittest.mock import patch

from scripts.authoring import edited_containers as edits
from scripts.authoring.formats_workflow import load_catalog
from scripts.build.project import load


class RealEditContractTests(unittest.TestCase):
    def test_probe_coordinates_are_checked_without_rom_data(self):
        catalog, assets = load_catalog()
        self.assertEqual(len(edits.probe_definitions(catalog, assets)), 2)
        recipe = load(edits.CONFIG)
        wrong = deepcopy(recipe)
        row = wrong["probes"][0]
        row["color"] = assets[row["asset"]]["size"] // 2
        with patch.object(edits, "load", return_value=wrong):
            with self.assertRaisesRegex(ValueError, "coordinate"):
                edits.probe_definitions(catalog, assets)
        wrong = deepcopy(recipe)
        wrong["probes"][0]["color"] = True
        with patch.object(edits, "load", return_value=wrong):
            with self.assertRaisesRegex(ValueError, "coordinate"):
                edits.probe_definitions(catalog, assets)

    def fixture(self):
        size = 0x220
        image = bytes(size)
        references = {"s3-us": image, "sk": image, "s3k": image + image}
        profiles = {"s3-us": {}, "sk": {}, "s3k": {"compose": ["sk", "s3-us"]}}
        sites = [
            {"profile": "s3-us", "start": 0x202, "end": 0x206},
            {"profile": "s3k", "start": size + 0x202, "end": size + 0x206},
        ]
        changes = [
            {"probe": {"asset": "palette"}, "original": bytes(4), "encoded": b"\x00\x02\x00\x00", "sites": sites}
        ]
        return references, profiles, changes

    def calculate(self, references, profiles, changes):
        with (
            patch.object(edits, "image_records", return_value=references),
            patch.object(edits, "profiles", return_value=profiles),
            patch.object(edits, "read_reference", side_effect=lambda image: image),
        ):
            return edits.expected_images(changes)

    def test_component_consumer_must_agree_with_independent_sibling_concatenation(self):
        references, profiles, changes = self.fixture()
        _, expected, _ = self.calculate(references, profiles, changes)
        self.assertEqual(expected["s3k"], expected["sk"] + expected["s3-us"])
        # Identical zero bytes at the wrong address would satisfy a raw content search.
        # The explicit component proof must still reject this misplaced consumer.
        wrong = deepcopy(changes)
        wrong[0]["sites"][1]["start"] -= 2
        wrong[0]["sites"][1]["end"] -= 2
        with self.assertRaisesRegex(ValueError, "composition"):
            self.calculate(references, profiles, wrong)

    def test_overlapping_allocations_are_rejected_even_when_overlap_bytes_are_unchanged(self):
        references, profiles, changes = self.fixture()
        second = {
            "probe": {"asset": "another-palette"},
            "original": bytes(4),
            "encoded": b"\x00\x00\x00\x02",
            "sites": [{"profile": "s3-us", "start": 0x204, "end": 0x208}],
        }
        with self.assertRaisesRegex(ValueError, "overlap"):
            self.calculate(references, profiles, changes + [second])

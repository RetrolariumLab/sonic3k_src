"""Semantic path changes must not repartition probes in physical code order."""

import unittest

from scripts.build.relocation import canonical_documents


class RelocationOrderTests(unittest.TestCase):
    def test_partition_follows_emission_order_and_deduplicates_regional_views(self):
        documents = [{"path": name} for name in ("boss.s", "camera.s", "startup.s", "sk.s")]
        engines = {
            "us": {"sources": ["startup.s", "camera.s", "boss.s"]},
            "eu": {"sources": ["startup.s", "camera.s", "boss.s"]},
            "sk": {"sources": ["sk.s"]},
        }
        actual = canonical_documents(documents, engines)
        self.assertEqual([row["path"] for row in actual], ["startup.s", "camera.s", "boss.s", "sk.s"])
        self.assertEqual(len(actual), len(documents))

    def test_renaming_paths_does_not_change_the_sequence_of_physical_owners(self):
        original = [{"path": "early.s", "owner": 0}, {"path": "late.s", "owner": 1}]
        renamed = [{"path": "z_last_alphabetically.s", "owner": 0}, {"path": "a_first_alphabetically.s", "owner": 1}]
        before = canonical_documents(original, {"engine": {"sources": [row["path"] for row in original]}})
        after = canonical_documents(list(reversed(renamed)), {"engine": {"sources": [row["path"] for row in renamed]}})
        self.assertEqual([row["owner"] for row in before], [row["owner"] for row in after])

    def test_missing_duplicated_and_contradictory_ownership_is_rejected(self):
        documents = [{"path": "first.s"}, {"path": "second.s"}]
        cases = [
            {"us": {"sources": ["first.s"]}},
            {"us": {"sources": ["first.s", "first.s", "second.s"]}},
            {"us": {"sources": ["first.s", "second.s"]}, "eu": {"sources": ["second.s", "first.s"]}},
            {"us": {"sources": ["first.s", "unknown.s"]}},
        ]
        for engines in cases:
            with self.subTest(engines=engines), self.assertRaises(ValueError):
                canonical_documents(documents, engines)
        with self.assertRaises(ValueError):
            canonical_documents(documents + [documents[0]], {"us": {"sources": ["first.s", "second.s"]}})

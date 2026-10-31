"""Tag fixtures are in-memory observations; no release refs are created."""

from copy import deepcopy
import unittest

from scripts.validation.release_tags import parse_tag, validate_state
from scripts.validation.source_2 import validate_aggregate
from scripts.validation.source_2_contract import STAGES


class ReleaseTagTests(unittest.TestCase):
    def setUp(self):
        self.head, self.base = "1" * 40, "2" * 40
        self.manifest = {
            "tag": "source-reconstruction-2.0",
            "status": "tag-ready",
            "predecessor": {"tag": "source-reconstruction-1.0", "commit": self.base},
        }
        self.tags = {
            name: parse_tag(
                "object "
                + target
                + "\ntype commit\ntag "
                + name
                + "\ntagger Owner <owner@example.com> 1 +0000\n\nVerified release summary\n",
                "3" * 40,
            )
            for name, target in ((self.manifest["tag"], self.head), (self.manifest["predecessor"]["tag"], self.base))
        }

    def test_post_tag_accepts_annotated_head_and_exact_predecessor(self):
        report = validate_state(self.manifest, self.head, self.tags, True)
        self.assertEqual(report["mode"], "post-tag")
        self.assertEqual(report["commit"], self.head)
        self.assertFalse(report["remote_refs_checked"])

    def test_missing_lightweight_wrong_target_name_and_summary_fail(self):
        name = self.manifest["tag"]
        variants = [None, {"kind": "commit", "object": self.head}]
        for key, value in (
            ("target", self.base),
            ("target_type", "tag"),
            ("name", "other"),
            ("message", " "),
            ("object", "bad"),
        ):
            variants.append(self.tags[name] | {key: value})
        for row in variants:
            with self.subTest(row=row), self.assertRaises(ValueError):
                validate_state(self.manifest, self.head, self.tags | {name: row}, True)

    def test_predecessor_cannot_be_missing_lightweight_or_moved_post_tag(self):
        name = self.manifest["predecessor"]["tag"]
        for row in (None, {"kind": "commit"}, self.tags[name] | {"target": self.head}):
            with self.subTest(row=row), self.assertRaises(ValueError):
                validate_state(self.manifest, self.head, self.tags | {name: row}, True)

    def test_pre_tag_allows_owner_deferred_predecessor_but_not_current_tag(self):
        self.assertEqual(validate_state(self.manifest, self.head, {})["mode"], "pre-tag")
        with self.assertRaises(ValueError):
            validate_state(self.manifest, self.head, self.tags)
        name = self.manifest["predecessor"]["tag"]
        with self.assertRaises(ValueError):
            validate_state(self.manifest, self.head, {name: self.tags[name] | {"target": self.head}})

    def test_tagged_and_unready_states_cannot_bypass_pre_tag(self):
        for status in ("tagged", "development", "candidate"):
            with self.subTest(status=status), self.assertRaises(ValueError):
                validate_state(self.manifest | {"status": status}, self.head, {})
        self.assertEqual(
            validate_state(self.manifest | {"status": "tagged"}, self.head, self.tags, True)["mode"], "post-tag"
        )

    def test_first_release_has_no_synthetic_predecessor(self):
        manifest = {"tag": "source-reconstruction-1.0", "status": "tag-ready", "predecessor": None}
        tag = deepcopy(self.tags[manifest["tag"]])
        tag["target"] = self.head
        self.assertIsNone(validate_state(manifest, self.head, {manifest["tag"]: tag}, True)["predecessor_tag_object"])


class CompletedAggregateTests(unittest.TestCase):
    def report(self):
        return {
            "complete": True,
            "audit_sha256": "audit",
            "source_sha256": "source",
            "tooling_sha256": "tools",
            "public_sha256": "public",
            "stages": [list(targets) for _, targets in STAGES],
        }

    def test_post_tag_needs_every_stage_and_the_exact_completed_audit(self):
        report = self.report()
        validate_aggregate(report, "source", "tools", "public", True, "audit")
        for field, value in (
            ("complete", False),
            ("audit_sha256", "stale"),
            ("stages", report["stages"][:-1]),
            ("source_sha256", "stale"),
            ("tooling_sha256", "stale"),
            ("public_sha256", "stale"),
        ):
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_aggregate(report | {field: value}, "source", "tools", "public", True, "audit")

    def test_in_progress_candidate_is_distinct_from_completed_post_tag_evidence(self):
        report = self.report()
        report.update(complete=False, stages=report["stages"][:-1])
        validate_aggregate(report, "source", "tools", "public")
        with self.assertRaises(ValueError):
            validate_aggregate(report, "source", "tools", "public", True, "audit")
        with self.assertRaises(ValueError):
            validate_aggregate(self.report(), "source", "tools", "public")

    def test_completed_pre_tag_reaudit_requires_the_unchanged_finished_audit(self):
        report = self.report()
        validate_aggregate(report, "source", "tools", "public", False, "audit")
        for field, value in (
            ("audit_sha256", "changed"),
            ("stages", report["stages"][:-1]),
            ("source_sha256", "changed"),
        ):
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_aggregate(report | {field: value}, "source", "tools", "public", False, "audit")

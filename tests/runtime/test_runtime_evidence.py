"""A successful subset or stale previous run cannot satisfy runtime release coverage."""

import copy
import unittest

from scripts.runtime.contracts import check_run_evidence


class RuntimeEvidenceTests(unittest.TestCase):
    def test_partial_duplicate_stale_and_different_matrix_runs_fail(self):
        evidence = {
            "complete": True,
            "source_sha256": "source",
            "scenario_sha256": "scenario",
            "manifest_sha256": "matrix",
            "results": [
                {"profile": "us", "variant": "g0", "passed": True},
                {"profile": "eu", "variant": "g0", "passed": True},
            ],
        }
        expected = {("us", "g0"), ("eu", "g0")}
        check_run_evidence(evidence, "source", "scenario", expected, "matrix")
        variants = []
        value = copy.deepcopy(evidence)
        value["results"].pop()
        variants.append(value)
        value = copy.deepcopy(evidence)
        value["results"].append(value["results"][0])
        variants.append(value)
        value = copy.deepcopy(evidence)
        value["results"][0]["passed"] = False
        variants.append(value)
        for field in ("source_sha256", "scenario_sha256", "manifest_sha256"):
            value = copy.deepcopy(evidence)
            value[field] = "stale"
            variants.append(value)
        value = copy.deepcopy(evidence)
        value["complete"] = False
        variants.append(value)
        for value in variants:
            with self.subTest(value=value), self.assertRaises(ValueError):
                check_run_evidence(value, "source", "scenario", expected, "matrix")

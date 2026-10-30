"""Release gates fail fast and cannot advertise an unverified image identity."""

import copy
import subprocess
import unittest

from scripts.validation.release import run_stages, validate_profiles


class ReleaseGateTests(unittest.TestCase):
    def test_a_failed_stage_prevents_later_stages(self):
        calls = []

        def execute(targets):
            calls.append(targets)
            if targets == ("build",):
                raise subprocess.CalledProcessError(1, ["make", "build"])

        with self.assertRaises(subprocess.CalledProcessError):
            run_stages((("tests", ("test",)), ("assembly", ("build",)), ("runtime", ("trace",))), execute)
        self.assertEqual(calls, [("test",), ("build",)])

    def test_wrong_hash_private_artifact_and_missing_profile_fail(self):
        images = {"us": {"size": 16, "sha1": "one", "sha256": "two"}}
        manifest = {
            "profiles": [{"id": "us", "artifact": "us_rom", "identity": "byte-identical"}],
            "artifacts": [
                {
                    "id": "us_rom",
                    "profile": "us",
                    "path": "build/images/us.bin",
                    "tracked": False,
                    "size": 16,
                    "sha1": "one",
                    "sha256": "two",
                }
            ],
        }
        validate_profiles(manifest, images)
        for change in ({"sha256": "wrong"}, {"tracked": True}, {"path": "data/us.bin"}):
            value = copy.deepcopy(manifest)
            value["artifacts"][0].update(change)
            with self.subTest(change=change), self.assertRaises(ValueError):
                validate_profiles(value, images)
        value = copy.deepcopy(manifest)
        value["profiles"].clear()
        with self.assertRaises(ValueError):
            validate_profiles(value, images)

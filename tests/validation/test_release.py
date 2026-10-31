"""Release gates fail fast and cannot advertise an unverified image identity."""

import copy
import subprocess
import unittest

from scripts.validation.release import run_stages, validate_identity, validate_profiles
from scripts.build.project import load


class ReleaseMetadataTests(unittest.TestCase):
    def test_nonstandard_states_missing_delta_and_wrong_tag_are_rejected(self):
        manifest = load("config/source_reconstruction_1_0.json")
        validate_identity(manifest)
        variants = []
        value = copy.deepcopy(manifest)
        value["status"] = "candidate"
        variants.append(value)
        value = copy.deepcopy(manifest)
        next(iter(value["requirements"].values()))["status"] = "implemented"
        variants.append(value)
        value = copy.deepcopy(manifest)
        value["delta"] = []
        variants.append(value)
        value = copy.deepcopy(manifest)
        value["tag"] = "source-reconstruction-2.0"
        variants.append(value)
        value = copy.deepcopy(manifest)
        value["licensing"][0]["license_id_or_status"] = "rights_holder_property"
        variants.append(value)
        value = copy.deepcopy(manifest)
        value["toolchain"] = "config/toolchain.json"
        variants.append(value)
        for value in variants:
            with self.subTest(value=value), self.assertRaises(ValueError):
                validate_identity(value)


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


class PreservationLayerStatusTests(unittest.TestCase):
    def test_inactive_preservation_layer_uses_the_validated_active_candidate(self):
        from scripts.validation.release import validate_preservation_status

        validate_preservation_status("development", "source-reconstruction-2.0")
        for status in ("tag-ready", "tagged"):
            validate_preservation_status(status, "source-reconstruction-1.0")
        for status, active in (
            ("development", "source-reconstruction-1.0"),
            ("development", "other"),
            ("candidate", "source-reconstruction-2.0"),
        ):
            with self.subTest(status=status, active=active), self.assertRaises(ValueError):
                validate_preservation_status(status, active)

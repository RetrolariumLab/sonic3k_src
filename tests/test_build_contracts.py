"""Regressions for header arithmetic, private data and manifest contracts."""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from scripts.build.pipeline import first_difference, fix_header
from scripts.build.project import ROOT, image_records, inside, load, profiles, read_reference
from scripts.validation.private_data import validate_blob


class HeaderTests(unittest.TestCase):
    def test_checksum_and_end_address(self):
        raw = bytearray(0x206)
        raw[0x200:] = bytes.fromhex("ffff00010002")
        built = fix_header(raw)
        self.assertEqual(built[0x18e:0x190], bytes.fromhex("0002"))
        self.assertEqual(int.from_bytes(built[0x1a4:0x1a8], "big"), 0x205)
        self.assertEqual(fix_header(built), built)

    def test_invalid_container_is_rejected(self):
        for data in (b"", bytes(0x1fe), bytes(0x201)):
            with self.subTest(length=len(data)), self.assertRaises(ValueError):
                fix_header(data)

    def test_first_difference_checks_length_and_content(self):
        self.assertIsNone(first_difference(b"abc", b"abc"))
        self.assertEqual(first_difference(b"abc", b"ab"), 2)
        self.assertEqual(first_difference(b"abc", b"adc"), 1)


class PrivateDataTests(unittest.TestCase):
    def test_exact_asset_is_rejected_even_when_it_looks_like_text(self):
        asset = b"apparently ordinary text"
        with self.assertRaisesRegex(ValueError, "Private asset"):
            validate_blob(asset, {hashlib.sha1(asset).hexdigest()}, {}, "sample.asm")

    def test_unlisted_binary_and_wrong_allowlist_hash_are_rejected(self):
        with self.assertRaises(ValueError):
            validate_blob(b"a\0b", set(), {}, "tool.bin")
        with self.assertRaises(ValueError):
            validate_blob(b"a\0b", set(), {"tool.bin":"0"*64}, "tool.bin")
        validate_blob(b"a\0b", set(), {"tool.bin":hashlib.sha256(b"a\0b").hexdigest()}, "tool.bin")


class ManifestTests(unittest.TestCase):
    def test_extraction_ranges_and_profile_ownership(self):
        manifest = load("assets/manifest.json")
        images = image_records()
        self.assertEqual(len(images), 5)
        paths = set()
        for asset in manifest["assets"]:
            self.assertNotIn(asset["path"], paths)
            paths.add(asset["path"])
            self.assertGreater(asset["size"], 0)
            self.assertLessEqual(asset["offset"]+asset["size"], images[asset["image"]]["size"])
            inside(manifest["output"]+"/"+asset["path"])
        values = profiles()
        for profile in values.values():
            self.assertIn(profile["image"], images)
            for child in profile.get("compose", []):
                self.assertIn(child, values)
            if "entry" in profile:
                self.assertTrue((ROOT/profile["entry"]).is_file())

    def test_escape_paths_are_rejected(self):
        with self.assertRaises(ValueError):
            inside("../escape")

    def test_public_make_help_runs_without_a_rom(self):
        output = subprocess.check_output(["make", "help"], cwd=ROOT, text=True)
        self.assertIn("verify-all", output)
        self.assertIn("check-assets", output)

    def test_optional_private_inputs(self):
        if not all((ROOT/i["file"]).is_file() for i in image_records().values()):
            self.skipTest("Private ROM inputs are absent; synthetic tool tests still run")
        for image in image_records().values():
            read_reference(image)


if __name__ == "__main__":
    unittest.main()

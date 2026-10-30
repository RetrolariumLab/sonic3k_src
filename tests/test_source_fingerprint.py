"""Producer and independent verifier bind the same mutable ROM-input recipe."""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts.build import project, relocation


class SourceFingerprintTests(unittest.TestCase):
    def test_audio_recipe_change_invalidates_both_independent_fingerprints(self):
        scratch = project.ROOT / "build" / "test-source-fingerprint"
        scratch.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=scratch) as folder:
            root = Path(folder)
            files = {
                "fixture.s": "Entry:\n dc.w 1\n",
                "assets/manifest.json": "{}\n",
                "config/revision_profiles.json": "{}\n",
                "config/toolchain.json": "{}\n",
                "config/audio_driver_payloads.json": '{"recipe":1}\n',
            }
            for name, text in files.items():
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text, newline="\n")
            index = ("\0".join(files) + "\0").encode()
            with patch.object(project, "ROOT", root), patch.object(relocation, "ROOT", root):
                with patch.object(project.subprocess, "check_output", return_value=index):
                    before = project.source_fingerprint(source_root=root)
                    proof = relocation.rendered_fingerprint(
                        {"engines": {}}, {"points": [], "groups": 1}, 0, ["fixture.s"], []
                    )
                    self.assertEqual(proof, before)
                    (root / "config/audio_driver_payloads.json").write_text('{"recipe":2}\n', newline="\n")
                    after = project.source_fingerprint(source_root=root)
                    self.assertNotEqual(after, before)
                    proof = relocation.rendered_fingerprint(
                        {"engines": {}}, {"points": [], "groups": 1}, 0, ["fixture.s"], []
                    )
                    self.assertEqual(proof, after)

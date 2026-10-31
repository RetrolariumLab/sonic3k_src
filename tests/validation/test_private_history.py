"""Historical path aliases cannot hide ASCII-valued binary payloads."""

from pathlib import Path
import hashlib
import json
import subprocess
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.validation.private_data import audit_repository, validate_blob


class BinaryClassificationTests(unittest.TestCase):
    def test_ascii_binary_suffix_still_needs_an_allowlist(self):
        for path in ("fragment.bin", "sample.pcm", "art.kos", "tool.exe"):
            with self.subTest(path=path), self.assertRaisesRegex(ValueError, "Binary suffix"):
                validate_blob(b"AB", set(), {}, path)

    def test_allowed_tool_never_overrides_a_private_asset_match(self):
        data = b"AB"
        pin = {"tool.bin": hashlib.sha256(data).hexdigest()}
        validate_blob(data, set(), pin, "tool.bin")
        with self.assertRaisesRegex(ValueError, "Private asset"):
            validate_blob(data, {hashlib.sha1(data).hexdigest()}, pin, "tool.bin")

    def test_private_root_is_forbidden_but_build_tools_remain_source(self):
        with self.assertRaises(ValueError):
            validate_blob(b"text", set(), {}, "build/report.txt", forbidden_prefixes=["build/"])
        validate_blob(b"text", set(), {}, "scripts/build/project.py", forbidden_prefixes=["build/"])


class HistoricalAliasTests(unittest.TestCase):
    def test_deleted_binary_alias_of_a_current_text_blob_is_rejected(self):
        parent = ROOT / "build/test-private-history"
        parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=parent) as directory:
            repo = Path(directory).resolve()
            self.assertTrue(repo.is_relative_to((ROOT / "build").resolve()))

            def git(*args):
                return subprocess.run(["git", "-C", str(repo), *args], check=True, capture_output=True).stdout

            git("init", "-b", "main")
            git("config", "user.name", "History Test Fixture")
            git("config", "user.email", "fixture@example.invalid")
            git("config", "commit.gpgsign", "false")
            (repo / "assets").mkdir()
            (repo / "config").mkdir()
            (repo / "assets/manifest.json").write_text(json.dumps({"images": [], "assets": []}))
            (repo / "config/binary_allowlist.json").write_text(json.dumps({"files": {}}))
            (repo / "notes.txt").write_bytes(b"AB")
            git("add", ".")
            git("commit", "-m", "Create synthetic text fixture")
            self.assertGreater(audit_repository(repo)["blobs"], 0)
            (repo / "notes.txt").rename(repo / "fragment.bin")
            git("add", "-A")
            git("commit", "-m", "Record a binary path alias")
            (repo / "fragment.bin").rename(repo / "notes.txt")
            git("add", "-A")
            git("commit", "-m", "Restore the harmless current text path")
            with self.assertRaisesRegex(ValueError, "Binary suffix"):
                audit_repository(repo)

"""Reproduce the Windows working-tree/Git movie byte mismatch and prevent recurrence."""

from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.validation.movie_style import check_style


class ControllerMovieStyleTests(unittest.TestCase):
    def fixture(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        temporary = tempfile.TemporaryDirectory(prefix="movie-style-", dir=base)
        self.addCleanup(temporary.cleanup)
        return Path(temporary.name)

    def test_real_text_lint_is_read_only_until_fix_and_matches_git_checkout_bytes(self):
        if shutil.which("rltool") is None:
            self.skipTest("Pinned public text style needs Retrolarium Kit")
        root = self.fixture()
        subprocess.run(["git", "init", "-q", str(root)], check=True)
        (root / ".gitattributes").write_bytes(b"*.rlmovie text eol=lf\n")
        source = root / "scenarios/route.rlmovie"
        source.parent.mkdir()
        original = b"# retrolarium movie 1\r\nplatform megadrive\r\nsource mame\r\nframes 2\r\n---\r\n2 00 00\r\n"
        source.write_bytes(original)
        subprocess.run(
            ["git", "add", ".gitattributes", "scenarios/route.rlmovie"], cwd=root, check=True, capture_output=True
        )
        snapshot = subprocess.check_output(["git", "show", ":scenarios/route.rlmovie"], cwd=root)
        self.assertNotEqual(source.read_bytes(), snapshot)
        with self.assertRaises(RuntimeError):
            check_style(root, ["scenarios/route.rlmovie"])
        self.assertEqual(source.read_bytes(), original)
        check_style(root, ["scenarios/route.rlmovie"], fix=True)
        self.assertEqual(source.read_bytes(), snapshot)
        self.assertEqual(source.read_text().splitlines(), original.decode().splitlines())
        check_style(root, ["scenarios/route.rlmovie"])

    def test_escaping_or_missing_movie_is_rejected_before_staging(self):
        root = self.fixture()
        outside = root / "outside.rlmovie"
        outside.write_bytes(b"unchanged\r\n")
        for name in ("scenarios/../outside.rlmovie", "other/outside.rlmovie", "scenarios/missing.rlmovie"):
            with self.subTest(name=name), self.assertRaises(ValueError):
                check_style(root, [name], fix=True)
        self.assertEqual(outside.read_bytes(), b"unchanged\r\n")
        self.assertFalse((root / "build/style").exists())

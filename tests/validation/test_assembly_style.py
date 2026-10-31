"""The real public linter must check .asm content without changing read-only inputs."""

from pathlib import Path
import re
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.validation.assembly_style import check_style


class ProcessorStyleTests(unittest.TestCase):
    def setUp(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(dir=base)
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        (self.root / "src").mkdir()

    def test_asm_is_linted_read_only_then_explicitly_formatted_without_token_changes(self):
        path = self.root / "src/driver.asm"
        original = "Entry:\n ld a,1\n ret\n"
        path.write_text(original)
        with self.assertRaises(RuntimeError):
            check_style(self.root, ["src/driver.asm"])
        self.assertEqual(path.read_text(), original)
        check_style(self.root, ["src/driver.asm"], fix=True)
        formatted = path.read_bytes()
        self.assertEqual(re.sub(r"\s+", "", original), re.sub(r"\s+", "", formatted.decode()))
        check_style(self.root, ["src/driver.asm"])
        self.assertEqual(path.read_bytes(), formatted)

    def test_escaping_or_missing_sources_fail_before_staging_is_created(self):
        for name in ("../outside.asm", "src/missing.asm"):
            with self.subTest(name=name), self.assertRaises(ValueError):
                check_style(self.root, [name])
            self.assertFalse((self.root / "build").exists())

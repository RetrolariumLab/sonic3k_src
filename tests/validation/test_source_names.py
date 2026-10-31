"""Filename policy is independent from deferred assembler symbol naming."""

from pathlib import Path
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.build.relocation import prune_source
from scripts.validation.source_names import check_source_names


class SourceNameTests(unittest.TestCase):
    def test_roles_have_distinct_suffixes_without_restricting_assembly_symbols(self):
        rows = [
            {"path": "src/game/update.s", "role": "code", "symbol": "loc_1234"},
            {"path": "src/memory/ram.inc", "role": "memory"},
            {"path": "src/audio/driver.asm", "role": "z80-driver"},
        ]
        self.assertEqual(check_source_names(rows, [r["path"] for r in rows]), 3)

    def test_bad_names_wrong_suffixes_and_unowned_inputs_are_rejected(self):
        for path in (
            "src/game/TooLong.s",
            "src/game/four_long_source_words.s",
            "src/game/loc_abcd.s",
            "src/game/update.asm",
            "src/game/../update.s",
        ):
            with self.subTest(path=path), self.assertRaises(ValueError):
                check_source_names([{"path": path, "role": "code"}])
        with self.assertRaises(ValueError):
            check_source_names([{"path": "src/audio/driver.s", "role": "z80-driver"}])
        with self.assertRaises(ValueError):
            check_source_names(
                [{"path": "src/game/update.s", "role": "code"}], ["src/game/update.s", "src/game/hidden.ASM"]
            )

    def test_obsolete_asm_is_pruned_but_owned_inputs_and_private_data_remain(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=base) as folder:
            root = Path(folder)
            (root / "src").mkdir()
            (root / "data").mkdir()
            (root / "src/old.asm").write_text("obsolete")
            (root / "src/current.asm").write_text("owned")
            (root / "data/private.asm").write_text("private")
            prune_source(root, ["src/current.asm"])
            self.assertFalse((root / "src/old.asm").exists())
            self.assertEqual((root / "src/current.asm").read_text(), "owned")
            self.assertEqual((root / "data/private.asm").read_text(), "private")

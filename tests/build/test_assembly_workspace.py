"""Real AS must assemble generated source and reject original-tree fallback."""

from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

from scripts.build import pipeline
from scripts.build.project import ROOT
from scripts.validation.as_object import decode


class AssemblyWorkspaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if shutil.which("rltool") is None:
            raise unittest.SkipTest("Pinned AS needs Retrolarium Kit; full build gates require it")
        cls.commands = pipeline.tools()

    def fixture(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        temporary = tempfile.TemporaryDirectory(prefix="as-workspace-", dir=base)
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        original, generated = root / "original", root / "generated"
        for tree in (original, generated):
            (tree / "src").mkdir(parents=True)
            (tree / "data").mkdir()
            (tree / "src/entry.s").write_text(' cpu 68000\n org $200\n include "src/nested.s"\n')
            (tree / "src/nested.s").write_text(' include "src/leaf.s"\n')
        (original / "src/leaf.s").write_text(" dc.w $1111\n")
        (generated / "src/leaf.s").write_text(" dc.w $2222\n")
        return original, generated, root / "objects"

    def assemble(self, original, generated, objects):
        with patch.object(pipeline, "ROOT", original):
            obj = pipeline.assemble(self.commands, {"entry": "src/entry.s", "defines": {}}, generated, objects)
        records, _, _ = decode(obj.read_bytes())
        self.assertTrue(all(row.cpu == 1 and row.address >= 0x200 for row in records))
        return b"".join(row.data for row in records)

    def test_nested_edit_changes_actual_object_bytes(self):
        original, generated, objects = self.fixture()
        self.assertEqual(self.assemble(original, generated, objects), b"\x22\x22")
        (generated / "src/leaf.s").write_text(" dc.w $3344\n")
        self.assertEqual(self.assemble(original, generated, objects), b"\x33\x44")

    def test_missing_generated_source_does_not_read_the_existing_original(self):
        original, generated, objects = self.fixture()
        (generated / "src/leaf.s").unlink()
        with self.assertRaises(RuntimeError):
            self.assemble(original, generated, objects)

    def test_binary_inputs_must_also_belong_to_the_generated_tree(self):
        original, generated, objects = self.fixture()
        (generated / "src/leaf.s").write_text(' binclude "data/sample.bin"\n')
        (original / "data/sample.bin").write_bytes(b"\x11\x11")
        with self.assertRaises(RuntimeError):
            self.assemble(original, generated, objects)
        (generated / "data/sample.bin").write_bytes(b"\xab\xcd")
        self.assertEqual(self.assemble(original, generated, objects), b"\xab\xcd")

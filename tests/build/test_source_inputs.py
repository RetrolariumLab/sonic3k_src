"""Private-input staging is hash-bound, bounded and all-or-nothing."""

import hashlib
from pathlib import Path
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.build.source_inputs import stage


def resource(name, data):
    return {
        "path": name,
        "size": len(data),
        "sha1": hashlib.sha1(data).hexdigest(),
        "sha256": hashlib.sha256(data).hexdigest(),
    }


class SourceInputTests(unittest.TestCase):
    def fixture(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        temporary = tempfile.TemporaryDirectory(prefix="source-inputs-", dir=base)
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        source = root / "private"
        source.mkdir()
        (source / "first.bin").write_bytes(b"first synthetic resource")
        (source / "second.bin").write_bytes(b"second synthetic resource")
        rows = [resource(name, (source / name).read_bytes()) for name in ("first.bin", "second.bin")]
        return source, root / "workspace", rows

    def test_only_registered_inputs_are_staged_with_exact_bytes(self):
        source, work, rows = self.fixture()
        (source / "unregistered.s").write_text("Not a generated-source fallback")
        self.assertEqual(stage(work, rows, source_root=source), 2)
        self.assertEqual({p.name for p in (work / "data").iterdir()}, {row["path"] for row in rows})
        self.assertEqual((work / "data/first.bin").read_bytes(), (source / "first.bin").read_bytes())

    def test_late_hash_failure_leaves_all_existing_outputs_untouched(self):
        source, work, rows = self.fixture()
        (work / "data").mkdir(parents=True)
        (work / "data/first.bin").write_bytes(b"previous output")
        (source / "second.bin").write_bytes(b"changed input")
        with self.assertRaises(ValueError):
            stage(work, rows, source_root=source)
        self.assertEqual((work / "data/first.bin").read_bytes(), b"previous output")
        self.assertFalse((work / "data/second.bin").exists())

    def test_aliases_escapes_wrong_sizes_and_missing_hashes_fail_before_writes(self):
        source, work, rows = self.fixture()
        invalid = [
            rows + [rows[0]],
            [dict(rows[0], path="../first.bin")],
            [dict(rows[0], path="nested//first.bin")],
            [dict(rows[0], path="C:/first.bin")],
            [dict(rows[0], size=True)],
            [dict(rows[0], size=0x400001)],
            [{"path": "first.bin", "size": rows[0]["size"]}],
        ]
        for value in invalid:
            with self.subTest(value=value), self.assertRaises(ValueError):
                stage(work, value, source_root=source)
            self.assertFalse(work.exists())

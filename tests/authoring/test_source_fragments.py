"""Multiple content families compose once against immutable physical source lines."""

from copy import deepcopy
import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts.authoring import source_fragments as codec


def fragment(original, first, last, owner, source, name="src/owner.s"):
    data = b"".join(original.splitlines(keepends=True)[first - 1 : last])
    return {
        "path": name,
        "owner": owner,
        "first_line": first,
        "last_line": last,
        "original_sha256": hashlib.sha256(data).hexdigest(),
        "source": source,
    }


class SourceFragmentTests(unittest.TestCase):
    def test_two_families_survive_line_count_changes_and_preserve_other_bytes(self):
        original = b"; keep\r\nRaw: dc.b 1\r\n; middle\r\nPalette: dc.w 2\r\n; tail\r\n"
        patches = [
            fragment(original, 2, 2, "raw", "Raw:\n dc.b 3\n"),
            fragment(original, 4, 4, "palette", "Palette:\n dc.w 4\n"),
        ]
        actual, evidence = codec.compose({"src/owner.s": original}, list(reversed(patches)))
        self.assertEqual(actual["src/owner.s"], b"; keep\r\nRaw:\n dc.b 3\n; middle\r\nPalette:\n dc.w 4\n; tail\r\n")
        self.assertEqual({row["owner"] for row in evidence}, {"raw", "palette"})
        self.assertEqual(codec.compose({"src/owner.s": original}, patches)[0], actual)

    def test_overlap_stale_original_and_missing_owner_fail_before_any_write(self):
        original = b"First:\n dc.b 1\nSecond:\n dc.b 2\n"
        first = fragment(original, 1, 2, "raw", "First: dc.b 3\n")
        invalid = [
            [first, fragment(original, 2, 3, "palette", "Second: dc.b 4\n")],
            [first, first],
            [first | {"original_sha256": "0" * 64}],
            [first | {"path": "src/missing.s"}],
            [first | {"first_line": 0}],
            [first | {"source": "incomplete"}],
            [first | {"path": "src/../outside.s"}],
        ]
        with (
            tempfile.TemporaryDirectory() as folder,
            patch.object(codec, "ROOT", Path(folder)),
            patch.object(codec, "atomic") as write,
        ):
            workspace = Path(folder) / "build/authoring/workspace"
            for patches in invalid:
                with self.subTest(patches=patches), self.assertRaises(ValueError):
                    codec.write(workspace, {"src/owner.s": original}, patches)
            write.assert_not_called()

    def test_invalid_second_file_cannot_leave_a_first_file_partially_written(self):
        original = b"Data: dc.b 1\n"
        valid = fragment(original, 1, 1, "first", "Data: dc.b 2\n")
        invalid = fragment(original, 1, 1, "second", "Other: dc.b 3\n", "src/other.s")
        invalid["original_sha256"] = "0" * 64
        with (
            tempfile.TemporaryDirectory() as folder,
            patch.object(codec, "ROOT", Path(folder)),
            patch.object(codec, "atomic") as write,
        ):
            with self.assertRaises(ValueError):
                codec.write(
                    Path(folder) / "build/authoring/workspace",
                    {"src/owner.s": original, "src/other.s": original},
                    [valid, invalid],
                )
            write.assert_not_called()

    def test_workspace_escape_is_rejected(self):
        original = b"Data: dc.b 1\n"
        item = fragment(original, 1, 1, "first", "Data: dc.b 2\n")
        with (
            tempfile.TemporaryDirectory() as folder,
            patch.object(codec, "ROOT", Path(folder)),
            patch.object(codec, "atomic") as write,
        ):
            with self.assertRaises(ValueError):
                codec.write(Path(folder) / "outside", {"src/owner.s": original}, [item])
            write.assert_not_called()

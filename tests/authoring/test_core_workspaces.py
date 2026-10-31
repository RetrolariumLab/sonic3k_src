"""Temporary Windows locks cannot hide codec failures or fail completed output."""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from scripts.authoring import core_compression as codec


class CoreWorkspaceTests(unittest.TestCase):
    def test_cleanup_permission_error_leaves_only_ignored_scratch(self):
        parent = codec.ROOT / "build/test-core-workspace"
        parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=parent) as folder:
            with patch.object(codec.shutil, "rmtree", side_effect=PermissionError("busy scanner")):
                with codec._workspace(Path(folder)) as workspace:
                    self.assertTrue(workspace.is_relative_to(parent.resolve()))

    def test_body_io_error_is_fatal_even_if_cleanup_is_also_locked(self):
        parent = codec.ROOT / "build/test-core-workspace"
        parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=parent) as folder:
            with patch.object(codec.shutil, "rmtree", side_effect=PermissionError("busy scanner")):
                with self.assertRaisesRegex(PermissionError, "output read failed"):
                    with codec._workspace(Path(folder)):
                        raise PermissionError("output read failed")

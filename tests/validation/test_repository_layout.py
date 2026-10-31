"""Keep public tool and test ownership aligned after path-only moves."""

import unittest

from scripts.build.project import ROOT


class RepositoryLayoutTests(unittest.TestCase):
    def test_tests_mirror_tool_packages_and_remain_discoverable(self):
        def packages(parent):
            return {path.name for path in parent.iterdir() if path.is_dir() and (path / "__init__.py").is_file()}

        owners = packages(ROOT / "scripts")
        self.assertEqual(owners, packages(ROOT / "tests"))
        self.assertFalse(list((ROOT / "tests").glob("test_*.py")))
        for owner in owners:
            with self.subTest(owner=owner):
                self.assertTrue(list((ROOT / "tests" / owner).glob("test_*.py")))

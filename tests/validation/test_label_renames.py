"""Reviewed symbol migration must retain exact physical scope and namespaces."""

import copy
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.validation.label_renames import profile_maps, validate_registry


class LabelMigrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        cls.temporary = tempfile.TemporaryDirectory(prefix="label-registry-", dir=base)
        cls.root = Path(cls.temporary.name).resolve()
        assert cls.root.is_relative_to(base.resolve())

        def cleanup():
            assert cls.root.is_relative_to(base.resolve())
            cls.temporary.cleanup()

        cls.addClassCleanup(cleanup)
        cls.sources = {"s3-us": "src/game/s3/example.s", "sk": "src/game/sk/example.s"}
        for path in cls.sources.values():
            target = cls.root / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text("sub_1234:\n rts\n; End of function sub_1234\n", encoding="utf-8")
        policy = {"engines": {profile: {"sources": [path]} for profile, path in cls.sources.items()}}
        (cls.root / "config/reconstruction").mkdir(parents=True)
        (cls.root / "config/reconstruction/relocation.json").write_text(json.dumps(policy), encoding="utf-8")
        subprocess.run(["git", "init", "-q"], cwd=cls.root, check=True, capture_output=True)
        subprocess.run(["git", "add", "."], cwd=cls.root, check=True, capture_output=True)
        subprocess.run(
            [
                "git",
                "-c",
                "user.name=Fixture Tester",
                "-c",
                "user.email=fixture@example.invalid",
                "commit",
                "-q",
                "-m",
                "Fixture original definition scope",
            ],
            cwd=cls.root,
            check=True,
            capture_output=True,
        )
        revision = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=cls.root, text=True).strip()
        rows = [
            {
                "source": path,
                "original_line": 1,
                "old": "sub_1234",
                "new": "S3ReadState" if profile == "s3-us" else "SKReadState",
                "profiles": [profile],
                "meaning": "Read the fixture player state without moving it.",
            }
            for profile, path in cls.sources.items()
        ]
        ids = sorted(row["source"] + ":1:sub_1234" for row in rows)
        cls.example = {
            "schema_version": 2,
            "state": "complete",
            "upstream_commit": "a" * 40,
            "baseline_commit": revision,
            "target_count": 2,
            "original_scope_sha256": hashlib.sha256("\n".join(ids).encode()).hexdigest(),
            "note": "Reviewed fixture meanings in two independent namespaces.",
            "renames": rows,
        }

    def setUp(self):
        self.registry = copy.deepcopy(self.example)
        for row in self.registry["renames"]:
            (self.root / row["source"]).write_text(
                row["new"] + ":\n rts\n; End of function " + row["new"] + "\n", encoding="utf-8"
            )

    def test_duplicate_old_spelling_resolves_independently_per_engine(self):
        value = validate_registry(self.root, self.registry)
        self.assertEqual(profile_maps(value), {"s3-us": {"sub_1234": "S3ReadState"}, "sk": {"sub_1234": "SKReadState"}})

    def test_identical_new_names_in_disjoint_engines_are_valid(self):
        for row in self.registry["renames"]:
            row["new"] = "ReadState"
            (self.root / row["source"]).write_text("ReadState:\n rts\n", encoding="utf-8")
        self.assertEqual(len(validate_registry(self.root, self.registry)["renames"]), 2)

    def test_cannot_shrink_historical_scope_by_redefining_declared_count_or_hash(self):
        self.registry["renames"].pop()
        self.registry["target_count"] = 1
        self.registry["original_scope_sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "historical physical scope"):
            validate_registry(self.root, self.registry)

    def test_missing_duplicate_and_foreign_physical_records_are_rejected(self):
        for kind in ["missing", "duplicate", "foreign"]:
            value = copy.deepcopy(self.registry)
            if kind == "missing":
                value["renames"].pop()
            elif kind == "duplicate":
                value["renames"][1] = copy.deepcopy(value["renames"][0])
            else:
                value["renames"][0]["source"] = "../outside.s"
            with self.subTest(kind=kind), self.assertRaises(ValueError):
                validate_registry(self.root, value)

    def test_profiles_meaning_and_semantic_name_are_mandatory(self):
        for key, invalid in [("profiles", ["sk"]), ("meaning", ""), ("new", "sub_9999"), ("new", "bad.label")]:
            value = copy.deepcopy(self.registry)
            value["renames"][0][key] = invalid
            with self.subTest(field=key, value=invalid), self.assertRaises(ValueError):
                validate_registry(self.root, value)

    def test_live_old_reference_cannot_hide_behind_a_renamed_definition(self):
        path = self.root / self.registry["renames"][0]["source"]
        path.write_text(path.read_text() + " jsr sub_1234\n", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "still occurs"):
            validate_registry(self.root, self.registry)

    def test_missing_or_duplicate_current_definition_is_rejected(self):
        row = self.registry["renames"][0]
        path = self.root / row["source"]
        for text in ["DifferentName:\n rts\n", row["new"] + ":\n rts\n" + row["new"] + ":\n rts\n"]:
            path.write_text(text, encoding="utf-8")
            with self.subTest(source=text), self.assertRaisesRegex(ValueError, "Renamed definitions"):
                validate_registry(self.root, self.registry)

    def test_nonempty_legacy_registry_is_not_an_approval_for_unreviewed_changes(self):
        value = {
            "schema_version": 1,
            "upstream_commit": "a" * 40,
            "note": "Legacy",
            "renames": [{"old": "X", "new": "Y"}],
        }
        with self.assertRaises(ValueError):
            validate_registry(self.root, value)

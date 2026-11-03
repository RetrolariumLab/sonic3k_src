"""Incremental renames retain physical scope, local names and pending packets."""

import copy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from scripts.build.project import ROOT
from scripts.validation.semantic_labels import (
    INDEX,
    SHARDS,
    historical_source,
    inherited,
    profile_maps,
    scope_hash,
    validate,
)


class IncrementalLabelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        base = (ROOT / "build/tests").resolve()
        base.mkdir(parents=True, exist_ok=True)
        cls.temporary = tempfile.TemporaryDirectory(prefix="semantic-labels-", dir=base)
        cls.root = Path(cls.temporary.name).resolve()
        assert cls.root.is_relative_to(base)

        def cleanup():
            assert cls.root.is_relative_to(base)
            cls.temporary.cleanup()

        cls.addClassCleanup(cleanup)
        cls.original = {
            "src/game/s3/example.s": 'loc_100:\n._1:\n bra.s ._1\n.Existing:\n dc.b "loc_100"\nlocret_110:\n rts\nOtherScope:\n._1:\n rts\n',
            "src/game/sk/example.s": "loc_100:\n rts\n",
        }
        for name, text in cls.original.items():
            path = cls.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8")
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
                "Freeze semantic scope fixture",
            ],
            cwd=cls.root,
            check=True,
            capture_output=True,
        )
        cls.revision = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=cls.root, text=True).strip()
        _, cls.targets = historical_source(str(cls.root), cls.revision)
        cls.example = {
            "schema_version": 1,
            "baseline_commit": cls.revision,
            "target_count": len(cls.targets),
            "scope_sha256": scope_hash(cls.targets),
            "state": "in-progress",
            "applied_targets": 0,
            "packets": [],
        }
        for index, path in enumerate(cls.original, 1):
            ids = [identity for identity, row in cls.targets.items() if row["source"] == path]
            key = str(index) + "-fixture"
            cls.example["packets"].append(
                {
                    "id": key,
                    "state": "pending",
                    "registry": SHARDS + "/" + key + ".json",
                    "sources": [{"path": path, "profiles": ["s3-us" if index == 1 else "sk"]}],
                    "target_count": len(ids),
                    "scope_sha256": scope_hash(ids),
                }
            )

    def setUp(self):
        self.index = copy.deepcopy(self.example)
        for name, text in self.original.items():
            (self.root / name).write_text(text, encoding="utf-8")
        folder = self.root / SHARDS
        folder.mkdir(parents=True, exist_ok=True)
        for path in folder.glob("*.json"):
            path.unlink()

    def apply(self, number=0):
        packet = self.index["packets"][number]
        path = packet["sources"][0]["path"]
        rows = []
        for identity, target in self.targets.items():
            if target["source"] != path:
                continue
            name = target["name"]
            new = ".RetryLoop" if name.startswith(".") else "ReadFixture" if name == "loc_100" else "ReturnFixture"
            rows.append(
                {
                    "source": path,
                    "original_line": target["line"],
                    "old": name,
                    "new": new,
                    "profiles": packet["sources"][0]["profiles"],
                    "meaning": "Fixture state dispatch or return boundary.",
                }
            )
        document = {"schema_version": 1, "packet": packet["id"], "mappings": rows}
        (self.root / packet["registry"]).write_text(json.dumps(document), encoding="utf-8")
        text = (
            self.original[path]
            .replace("._1", ".RetryLoop")
            .replace("locret_110:", "ReturnFixture:")
            .replace("loc_100:", "ReadFixture:")
        )
        (self.root / path).write_text("; Explain the retained fixture branch.\n" + text, encoding="utf-8")
        packet["state"] = "applied"
        self.index["applied_targets"] += len(rows)
        if self.index["applied_targets"] == self.index["target_count"]:
            self.index["state"] = "complete"
        return document

    def write_document(self, document, packet=0):
        (self.root / self.index["packets"][packet]["registry"]).write_text(json.dumps(document), encoding="utf-8")

    def test_pending_scope_and_partial_application_are_valid(self):
        self.assertEqual(validate(self.root, self.index)["applied_targets"], 0)
        self.apply()
        result = validate(self.root, self.index)
        self.assertEqual(result["applied_targets"], 4)
        self.assertEqual(len(result["mappings"]), 4)
        self.assertEqual(result["index"]["state"], "in-progress")

    def test_local_names_follow_renamed_global_scope_after_inserted_comments(self):
        self.apply()
        maps = profile_maps(validate(self.root, self.index))
        self.assertEqual(maps["s3-us"]["loc_100._1"], "ReadFixture.RetryLoop")
        self.assertEqual(maps["s3-us"]["OtherScope._1"], "OtherScope.RetryLoop")

    def test_disjoint_engine_names_can_match_and_complete(self):
        self.apply(0)
        self.apply(1)
        result = validate(self.root, self.index)
        self.assertEqual(result["index"]["state"], "complete")
        self.assertEqual(profile_maps(result)["sk"]["loc_100"], "ReadFixture")

    def test_historical_scope_cannot_be_shrunk(self):
        self.index["target_count"] -= 1
        self.index["scope_sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "historical scope"):
            validate(self.root, self.index)

    def test_missing_or_overlapping_subsystem_sources_are_rejected(self):
        for mode in ("missing", "duplicate"):
            index = copy.deepcopy(self.index)
            if mode == "missing":
                index["packets"].pop()
            else:
                index["packets"][1]["sources"] = copy.deepcopy(index["packets"][0]["sources"])
            with self.subTest(mode=mode), self.assertRaises(ValueError):
                validate(self.root, index)

    def test_pending_definitions_cannot_be_renamed_early(self):
        name = self.index["packets"][0]["sources"][0]["path"]
        (self.root / name).write_text(self.original[name].replace("loc_100:", "RenamedEarly:"), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Unregistered"):
            validate(self.root, self.index)

    def test_missing_duplicate_and_foreign_mappings_fail(self):
        document = self.apply()
        for mode in ("missing", "duplicate", "foreign"):
            changed = copy.deepcopy(document)
            if mode == "missing":
                changed["mappings"].pop()
            elif mode == "duplicate":
                changed["mappings"].append(copy.deepcopy(changed["mappings"][0]))
            else:
                changed["mappings"][0]["source"] = "../outside.s"
            self.write_document(changed)
            with self.subTest(mode=mode), self.assertRaises(ValueError):
                validate(self.root, self.index)

    def test_local_global_conversion_and_local_collisions_fail(self):
        document = self.apply()
        for new in ("GlobalInsteadOfLocal", ".Existing"):
            changed = copy.deepcopy(document)
            row = next(r for r in changed["mappings"] if r["old"] == "._1")
            row["new"] = new
            self.write_document(changed)
            if new == ".Existing":
                name = row["source"]
                text = (self.root / name).read_text().replace(".RetryLoop", ".Existing", 1)
                (self.root / name).write_text(text, encoding="utf-8")
            with self.subTest(new=new), self.assertRaises(ValueError):
                validate(self.root, self.index)

    def test_profiles_meanings_and_progress_are_required(self):
        document = self.apply()
        for key, invalid in (("profiles", ["sk"]), ("meaning", ""), ("new", "loc_ABC")):
            changed = copy.deepcopy(document)
            changed["mappings"][0][key] = invalid
            self.write_document(changed)
            with self.subTest(field=key), self.assertRaises(ValueError):
                validate(self.root, self.index)
        self.write_document(document)
        self.index["applied_targets"] = 0
        with self.assertRaisesRegex(ValueError, "progress"):
            validate(self.root, self.index)

    def test_pending_and_unowned_shards_are_rejected(self):
        target = self.root / self.index["packets"][0]["registry"]
        target.write_text("{}", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Pending"):
            validate(self.root, self.index)
        target.unlink()
        (self.root / SHARDS / "unowned.json").write_text("{}", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Unowned"):
            validate(self.root, self.index)

    def test_completion_cannot_be_declared_before_every_packet(self):
        self.index["state"] = "complete"
        with self.assertRaisesRegex(ValueError, "completion"):
            validate(self.root, self.index)

    def test_classifier_retains_palette_words_and_existing_procedure_names(self):
        for name in ("Pal_fade_delay", "Pal_fade_delay2", "ReadFixture", "sub_1234"):
            self.assertFalse(inherited(name), name)
        for name in ("Frame_1234", "locret_1234", "loc_FACE", "._100", "_unkEF44_1", "_tempFF88"):
            self.assertTrue(inherited(name), name)


if __name__ == "__main__":
    unittest.main()

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
    destination_hash,
    historical_source,
    inherited,
    original_view,
    profile_maps,
    scope_hash,
    validate,
)
from scripts.validation.semantic_label_edits import code_lines


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
            "src/game/sk/example.s": (
                'loc_100:\n rts\nImportFixture: include "src/game/s3/example.s"\n dc.b "src/game/s3/example.s"\n'
            ),
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
            "applied_order": [],
            "packets": [],
        }
        for index, path in enumerate(cls.original, 1):
            ids = [identity for identity, row in cls.targets.items() if row["source"] == path]
            key = str(index) + "-fixture"
            destinations = [
                {
                    "source": path,
                    "original_line": cls.targets[identity]["line"],
                    "old": cls.targets[identity]["name"],
                    "new": cls.proposed(cls.targets[identity]["name"]),
                }
                for identity in ids
            ]
            cls.example["packets"].append(
                {
                    "id": key,
                    "state": "pending",
                    "registry": SHARDS + "/" + key + ".json",
                    "sources": [{"path": path, "profiles": ["s3-us" if index == 1 else "sk"]}],
                    "target_count": len(ids),
                    "scope_sha256": scope_hash(ids),
                    "destination_sha256": destination_hash(destinations),
                }
            )

    @staticmethod
    def proposed(name):
        return ".RetryLoop" if name.startswith(".") else "ReadFixture" if name == "loc_100" else "ReturnFixture"

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
            new = self.proposed(name)
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
        text = (
            self.original[path]
            .replace("._1", ".RetryLoop")
            .replace("locret_110:", "ReturnFixture:")
            .replace("loc_100:", "ReadFixture:")
        )
        edits = []
        for code_line, ((_, before), (_, after)) in enumerate(
            zip(code_lines(self.original[path]), code_lines(text)), 1
        ):
            for token, (old, new) in enumerate(zip(before, after)):
                if old.text != new.text:
                    mapping = next(i for i, r in enumerate(rows) if (r["old"], r["new"]) == (old.text, new.text))
                    edits.append([code_line, token, mapping, ""])
        document["source_edits"] = [{"source": path, "tokens": edits}]
        self.write_document(document, number)
        (self.root / path).write_text("; Explain the retained fixture branch.\n" + text, encoding="utf-8")
        packet["state"] = "applied"
        self.index["applied_order"].append(packet["id"])
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
                self.index["packets"][0]["destination_sha256"] = destination_hash(changed["mappings"])
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
        for name in (
            "Frame_1234",
            "locret_1234",
            "loc_FACE",
            "._100",
            "_unkEF44_1",
            "_tempFF88",
        ):
            self.assertTrue(inherited(name), name)

    def test_original_view_restores_every_registered_reference(self):
        self.apply()
        result = validate(self.root, self.index)
        path = self.index["packets"][0]["sources"][0]["path"]
        self.assertEqual(
            original_view(path, (self.root / path).read_text(), result),
            "; Explain the retained fixture branch.\n" + self.original[path],
        )

    def test_source_move_preserves_symbols_and_reverses_only_includes(self):
        self.apply()
        old = "src/game/s3/example.s"
        new = "src/game/s3/descriptive.s"
        (self.root / old).rename(self.root / new)
        self.addCleanup((self.root / new).unlink)
        registry = self.root / "config/reconstruction/source_layout.json"
        self.addCleanup(registry.unlink)
        registry.write_text(
            json.dumps(
                {
                    "path_moves": [{"historical": old, "current": new}],
                    "files": [{"path": new}],
                }
            ),
            encoding="utf-8",
        )
        consumer = self.root / "src/game/sk/example.s"
        original = self.original["src/game/sk/example.s"]
        updated = original.replace(f'include "{old}"', f'include "{new}"')
        consumer.write_text(updated, encoding="utf-8")
        result = validate(self.root, self.index)
        self.assertTrue(all(row["source"] == old for row in result["mappings"]))
        self.assertEqual(original_view("src/game/sk/example.s", updated, result), original)

        consumer.write_text(updated.replace(f'dc.b "{old}"', f'dc.b "{new}"'), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Unregistered code"):
            validate(self.root, self.index)

    def test_unregistered_code_literals_and_context_changes_fail(self):
        path = self.index["packets"][0]["sources"][0]["path"]
        for old, new in (
            (" rts", " nop"),
            ('"loc_100"', '"ReadFixture"'),
            ("bra.s", "bra.w"),
        ):
            (self.root / path).write_text(self.original[path].replace(old, new), encoding="utf-8")
            with (
                self.subTest(old=old),
                self.assertRaisesRegex(ValueError, "Unregistered code"),
            ):
                validate(self.root, self.index)

    def test_destinations_cannot_drift_from_the_reviewed_catalog(self):
        document = self.apply()
        document["mappings"][0]["new"] = "OtherMeaning"
        self.write_document(document)
        with self.assertRaisesRegex(ValueError, "reviewed semantic destinations"):
            validate(self.root, self.index)

    def test_missing_and_overlapping_source_tokens_fail(self):
        document = self.apply()
        for mode in ("missing", "overlapping"):
            changed = copy.deepcopy(document)
            if mode == "missing":
                changed["source_edits"][0]["tokens"].pop()
            else:
                changed["source_edits"][0]["tokens"].append(copy.deepcopy(changed["source_edits"][0]["tokens"][0]))
            self.write_document(changed)
            with self.subTest(mode=mode), self.assertRaises(ValueError):
                validate(self.root, self.index)

    def test_applied_source_order_must_account_for_every_subsystem(self):
        self.apply()
        self.index["applied_order"] = []
        with self.assertRaisesRegex(ValueError, "edit order"):
            validate(self.root, self.index)


if __name__ == "__main__":
    unittest.main()

"""Exercise public release commands from a disposable clone without ROMs."""

import copy
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from scripts.build.make_interface import recipes
from scripts.build.project import ROOT, image_records, load
from scripts.validation.documentation import document_inventory, heading_anchors, tracked
from scripts.validation.release import run_stages
from scripts.validation.source_2 import validate_content
from scripts.validation.source_2_contract import STAGES, validate_history


class AggregateTests(unittest.TestCase):
    def test_failed_complete_preservation_gate_prevents_every_extra_stage(self):
        calls = []

        def execute(targets):
            calls.append(targets)
            raise subprocess.CalledProcessError(1, ["make", *targets])

        with self.assertRaises(subprocess.CalledProcessError):
            run_stages(STAGES, execute)
        self.assertEqual(calls, [("release-check",)])

    def test_content_evidence_rejects_stale_incomplete_and_missing_families(self):
        manifest, images = load("config/source_reconstruction_2_0.json"), image_records()
        fields = {
            "all_registered_inputs": "private_inputs",
            "assembly_resources": "assembly_resources",
            "palette_groups": "palette_groups",
            "raw_groups": "raw_groups",
            "raw_source_entries": "raw_source_entries",
            "indexed_palette_groups": "indexed_palette_groups",
        }
        report = {
            "complete": True,
            "source_sha256": "source",
            "tooling_sha256": "tools",
            "profiles": {key: row["sha256"] for key, row in images.items()},
            **{k: manifest["authoring"][v] for k, v in fields.items()},
        }
        validate_content(report, manifest, "source", "tools", images)
        for field, value in (
            ("complete", False),
            ("source_sha256", "old"),
            ("tooling_sha256", "old"),
            ("profiles", {}),
            ("indexed_palette_groups", 0),
            ("raw_source_entries", 1),
        ):
            invalid = copy.deepcopy(report)
            invalid[field] = value
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_content(invalid, manifest, "source", "tools", images)

    def test_help_covers_actual_included_public_targets(self):
        result = subprocess.run(["make", "help"], cwd=ROOT, capture_output=True, text=True, check=True)
        listed = result.stdout.split("Public targets: ", 1)[1].splitlines()[0].strip().split(", ")
        self.assertEqual(set(listed), set(recipes(ROOT)))


class DocumentationTests(unittest.TestCase):
    def test_heading_ids_keep_code_unicode_and_unique_duplicate_suffixes(self):
        text = """# Topic
## Topic
## Topic-1
## `ContentCatalog.encode()` & Память!
Setext title
============
<a id="custom-anchor"></a>
~~~markdown
# Fake tilde
~~~
````markdown
# Fake backtick
```
# Still fenced
````
    # Indented example
```
# Unclosed example
"""
        self.assertEqual(
            heading_anchors(text),
            {"topic", "topic-1", "topic-1-1", "contentcatalogencode--память", "setext-title", "custom-anchor"},
        )

    def test_real_link_path_rejects_nonexistent_heading_fragments(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=base) as folder:
            root = Path(folder)
            names = ["README.md", "CONTRIBUTING.md", "docs/topic.md"]
            (root / "docs").mkdir()
            (root / "CONTRIBUTING.md").write_text("# Contributing\n", encoding="utf-8")
            (root / "docs/topic.md").write_text("# Topic\n## Topic\n## Память\n~~~\n## Fake\n~~~\n", encoding="utf-8")
            review = {
                "schema_version": 1,
                "review_scope": "Synthetic fragment review",
                "documents": [{"path": name, "decision": "kept", "reason": "Cohesive topic"} for name in names],
            }
            for fragment in ("topic", "topic-1", "%D0%BF%D0%B0%D0%BC%D1%8F%D1%82%D1%8C"):
                (root / "README.md").write_text(
                    "# Example\n[Self](#example)\n[Topic](docs/topic.md#" + fragment + ")\n"
                )
                with self.subTest(fragment=fragment):
                    self.assertTrue(document_inventory(root, names, review)["complete"])
            for link in ("#missing", "docs/topic.md#missing", "docs/topic.md#fake", "docs/topic.md#topic-2"):
                (root / "README.md").write_text("# Example\n[Topic](docs/topic.md)\n[Broken](" + link + ")\n")
                with self.subTest(link=link), self.assertRaisesRegex(ValueError, "anchor"):
                    document_inventory(root, names, review)

    def test_missing_review_broken_escaping_and_orphan_links_fail(self):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=base) as folder:
            root = Path(folder)
            names = ["README.md", "CONTRIBUTING.md", "docs/topic.md"]
            (root / "docs").mkdir()
            (root / "README.md").write_text("# Example\n\n[Topic](docs/topic.md)\n")
            (root / "CONTRIBUTING.md").write_text("# Contributing\n")
            (root / "docs/topic.md").write_text("# Topic\n")
            review = {
                "schema_version": 1,
                "review_scope": "Synthetic navigation review",
                "documents": [{"path": name, "decision": "kept", "reason": "Cohesive topic"} for name in names],
            }
            self.assertTrue(document_inventory(root, names, review)["complete"])
            invalid = copy.deepcopy(review)
            invalid["documents"].pop()
            with self.assertRaisesRegex(ValueError, "omits"):
                document_inventory(root, names, invalid)
            for link in ("missing.md", "../outside.md", "docs/%2e%2e/%2e%2e/outside.md"):
                (root / "README.md").write_text("[Broken](" + link + ")\n")
                with self.subTest(link=link), self.assertRaises(ValueError):
                    document_inventory(root, names, review)
            (root / "README.md").write_text("# No navigation\n")
            with self.assertRaisesRegex(ValueError, "Unreachable"):
                document_inventory(root, names, review)


class PublicCommandTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        cls.temporary = tempfile.TemporaryDirectory(prefix="release-smoke-", dir=base)
        cls.root = Path(cls.temporary.name) / "clone"
        subprocess.run(
            ["git", "clone", "--quiet", "--no-hardlinks", str(ROOT), str(cls.root)], check=True, capture_output=True
        )
        # Include the candidate public worktree without any ignored/private files.
        for name in tracked(ROOT):
            destination = cls.root / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / name, destination)
        cls.manifest_path = cls.root / "config/source_reconstruction_2_0.json"
        cls.original = cls.manifest_path.read_bytes()

    @classmethod
    def tearDownClass(cls):
        cls.temporary.cleanup()

    def tearDown(self):
        self.manifest_path.write_bytes(self.original)

    def command(self, target):
        return subprocess.run(["make", target], cwd=self.root, capture_output=True, text=True)

    def test_real_metadata_command_passes_without_any_rom(self):
        self.assertFalse((self.root / "data").exists())
        result = self.command("source-2-audit")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("complete delta", result.stdout)

    def test_real_command_rejects_a_claimed_profile_and_missing_delta(self):
        for field in ("profiles", "delta"):
            manifest = json.loads(self.original)
            manifest[field].pop(0)
            self.manifest_path.write_text(json.dumps(manifest))
            result = self.command("source-2-audit")
            self.assertNotEqual(result.returncode, 0, result.stdout)
            self.assertIn("ValueError", result.stderr)
            self.manifest_path.write_bytes(self.original)

    def test_empty_release_commit_is_rejected_in_a_temporary_history(self):
        empty = Path(self.temporary.name) / "empty-history"
        subprocess.run(
            ["git", "clone", "--quiet", "--no-hardlinks", str(ROOT), str(empty)], check=True, capture_output=True
        )
        subprocess.run(
            [
                "git",
                "-c",
                "user.name=Daniel Oranguthang",
                "-c",
                "user.email=75395800+oranguthang@users.noreply.github.com",
                "commit",
                "--allow-empty",
                "-m",
                "Exercise rejection of an empty release commit",
                "-m",
                "This synthetic fixture proves that metadata cannot bless an empty history stage.",
            ],
            cwd=empty,
            check=True,
            capture_output=True,
        )
        manifest = json.loads(self.original)
        actual = subprocess.check_output(
            ["git", "rev-list", manifest["predecessor"]["commit"] + "..HEAD"], cwd=empty, text=True
        ).splitlines()
        explicit = {commit for row in manifest["delta"] for commit in row["commits"]} - {"release-commit"}
        # A committed candidate HEAD may already occupy the release boundary.
        # Declare every ordinary predecessor so the failure reaches the empty-commit audit.
        missing = sorted(set(actual[1:]) - explicit)
        if missing:
            manifest["delta"].append(
                {
                    "id": "fixture-preceding-stage",
                    "kind": "validation",
                    "summary": "Preserve the current candidate boundary in this fixture.",
                    "commits": missing,
                }
            )
        manifest["delta_history"]["commit_count"] = len(actual)
        with self.assertRaisesRegex(ValueError, "empty commit"):
            validate_history(empty, manifest)

    def test_full_audit_cannot_use_metadata_as_release_evidence(self):
        result = self.command("source-2-release-audit")
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertFalse((self.root / "build/release/source-2-audit.json").exists())

    def test_delta_rejects_a_foreign_commit_and_stale_count(self):
        manifest = json.loads(self.original)
        for change in ("foreign", "count"):
            invalid = copy.deepcopy(manifest)
            if change == "foreign":
                invalid["delta"][0]["commits"][0] = "0" * 40
            else:
                invalid["delta_history"]["commit_count"] += 1
            with self.subTest(change=change), self.assertRaises(ValueError):
                validate_history(self.root, invalid)

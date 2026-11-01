"""Validate Source 2.0 metadata, actual public interfaces and delta history."""

import hashlib
import json
import re
import subprocess

from scripts.build.make_interface import recipes
from scripts.build.project import ROOT
from scripts.validation.documentation import document_inventory, tracked
from scripts.validation.label_renames import validate_registry

MANIFEST = "config/source_reconstruction_2_0.json"
REQUIREMENTS = frozenset(
    (
        "preservation",
        "semantic_source",
        "memory_and_composition",
        "z80_contexts",
        "content_formats",
        "regional_profiles",
        "documentation",
        "headless_validation",
        "privacy_and_provenance",
        "aggregate_acceptance",
    )
)
STAGES = (
    ("complete-preservation-gate", ("release-check",)),
    (
        "semantic-source",
        (
            "check-source-preservation",
            "check-source-ranges",
            "check-memory-layout",
            "check-composition",
            "check-z80-driver",
        ),
    ),
    ("encoded-content", ("check-content-contract", "check-content-zero-edit", "check-content-edits")),
    ("documentation", ("check-docs",)),
    ("publication-audit", ("source-2-release-audit",)),
)


def git(root, *args):
    return subprocess.check_output(["git", *args], cwd=root).decode().strip()


def read(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise ValueError("Missing or escaping public contract: " + str(name))
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError("Expected a JSON object: " + name)
    return value


def public_fingerprint(root=ROOT):
    digest = hashlib.sha256()
    for name in tracked(root):
        digest.update(name.encode() + bytes(1) + (root / name).read_bytes() + bytes(1))
    return digest.hexdigest()


def validate_history(root, manifest):
    base = manifest["predecessor"]["commit"]
    if not re.fullmatch(r"[0-9a-f]{40}", base):
        raise ValueError("Predecessor needs an exact commit")
    subprocess.run(["git", "merge-base", "--is-ancestor", base, "HEAD"], cwd=root, check=True, capture_output=True)
    delta = set(git(root, "rev-list", base + "..HEAD").splitlines())
    entries, declared, identifiers = manifest.get("delta", []), [], []
    for row in entries:
        if not all(row.get(k) for k in ("id", "kind", "summary", "commits")):
            raise ValueError("Incomplete delta explanation")
        identifiers.append(row["id"])
        declared.extend(row["commits"])
    if len(identifiers) != len(set(identifiers)) or len(declared) != len(set(declared)):
        raise ValueError("Duplicate delta identity or commit")
    if declared.count("release-commit") != 1:
        raise ValueError("Delta must identify its current substantive release stage")
    explicit = set(declared) - {"release-commit"}
    head = git(root, "rev-parse", "HEAD")
    if not explicit <= delta or delta - explicit not in (set(), {head}):
        raise ValueError("Delta omits a non-current commit or claims foreign history")
    history = manifest.get("delta_history", {})
    if history.get("base_commit") != base or history.get("tip") != "release-commit":
        raise ValueError("Delta bounds disagree with predecessor")
    expected_count = len(delta) + (head in explicit)
    if history.get("commit_count") != expected_count:
        raise ValueError("Delta commit count is stale")
    tag = manifest["predecessor"]["tag"]
    existing = subprocess.run(
        ["git", "rev-parse", "--verify", "refs/tags/" + tag], cwd=root, capture_output=True, text=True
    )
    if existing.returncode == 0 and git(root, "rev-list", "-n", "1", tag) != base:
        raise ValueError("Existing predecessor tag points to another commit")
    for revision in git(root, "rev-list", "--all").splitlines():
        message = git(root, "show", "-s", "--format=%an%x00%ae%x00%cn%x00%ce%x00%B", revision).split("\0", 4)
        if message[:4] != ["Daniel Oranguthang", "75395800+oranguthang@users.noreply.github.com"] * 2:
            raise ValueError("Unexpected commit author or committer")
        title, *body = message[4].splitlines()
        if title.strip().lower() in {"fix", "update", "changes", "wip"} or not any(line.strip() for line in body):
            raise ValueError("Commit lacks a substantive title or body")
        if re.search(r"[\u0400-\u052f]", message[4]):
            raise ValueError("Commit message contains a non-English script")
        if not git(root, "diff-tree", "--root", "--no-commit-id", "--name-only", "-r", revision):
            raise ValueError("Reachable history contains an empty commit")
    return {"predecessor": base, "delta_commits": len(delta)}


def metadata(root=ROOT):
    manifest = read(root, MANIFEST)
    if (
        manifest.get("schema_version") != 1
        or manifest.get("release_line") != "2.0"
        or manifest.get("release_kind") != "baseline"
        or manifest.get("release") != {"name": "Source Reconstruction 2.0", "version": "2.0"}
        or manifest.get("tag") != "source-reconstruction-2.0"
        or manifest.get("status") not in {"development", "tag-ready", "tagged"}
    ):
        raise ValueError("Invalid Source 2.0 release identity")
    if manifest.get("publication") != {
        "mode": "maintainer-only",
        "tags_created_by_checks": False,
        "push_performed_by_checks": False,
    }:
        raise ValueError("Publication must remain an explicit maintainer action")
    predecessor = manifest.get("predecessor", {})
    if (
        predecessor.get("manifest") != "config/source_reconstruction_1_0.json"
        or predecessor.get("gate") != "release-check"
        or predecessor.get("tag_status") != "maintainer-action"
    ):
        raise ValueError("Incomplete predecessor contract")
    source_1 = read(root, predecessor["manifest"])
    if predecessor.get("tag") != source_1.get("tag"):
        raise ValueError("Predecessor tag identity differs from Source 1.0")
    revisions = read(root, "config/revision_profiles.json")
    for field in ("reference", "profiles", "artifacts", "runtime_coverage", "toolchain", "licensing"):
        if manifest.get(field) != source_1.get(field):
            raise ValueError("Source 2.0 changed inherited preservation metadata: " + field)
    if not manifest.get("included_scope") or manifest.get("excluded_scope") != revisions["excluded_scope"]:
        raise ValueError("Release scope differs from accepted profiles")
    rules = recipes(root)
    targets = set(rules)
    if rules.get("source-2-check") != ["$(PYTHON) -m scripts.run validation.source_2 check"]:
        raise ValueError("Source 2.0 target does not run the complete aggregate")
    if rules.get("release-check") != ["$(PYTHON) -m scripts.run validation.release check"]:
        raise ValueError("Source 1.0 target does not run the complete preservation gate")
    required = manifest.get("requirements", {})
    if set(required) != REQUIREMENTS:
        raise ValueError("Incomplete Source 2.0 requirement registry")
    for row in required.values():
        if row.get("status") not in {"satisfied", "not_applicable"} or not row.get("note"):
            raise ValueError("A mandatory control is unfinished or unexplained")
        evidence = row.get("evidence", {})
        if not evidence.get("targets") or not evidence.get("files"):
            raise ValueError("Requirement has no executable and public evidence")
        if not set(evidence["targets"]) <= targets:
            raise ValueError("Requirement names a missing public target")
        for name in evidence["files"]:
            path = (root / name).resolve()
            if not path.is_relative_to(root.resolve()) or not path.exists():
                raise ValueError("Missing or escaping requirement evidence: " + name)
    if not set(manifest.get("release_commands", [])) <= targets:
        raise ValueError("Release command is missing")
    if manifest.get("aggregate_gates", {}).get("pre_tag") != ["make source-2-check"]:
        raise ValueError("Incomplete aggregate gate declaration")
    for row in manifest.get("layout_deviations", []):
        if not all(row.get(k) for k in ("rule_id", "actual_path", "reason", "equivalent_control")):
            raise ValueError("Incomplete layout deviation")
        if not (root / row["actual_path"]).exists():
            raise ValueError("Layout deviation names a missing path")
    names = tracked(root)
    docs = {name for name in names if name.endswith(".md")}
    if set(manifest.get("required_documents", [])) != docs:
        raise ValueError("Required document registry is incomplete")
    registry = "config/reconstruction/label_renames.json"
    candidates = []
    for name in names:
        if name.endswith(".json"):
            value = read(root, name)
            if name.endswith("label_renames.json") or "renames" in value:
                candidates.append(name)
    if candidates != [registry] or manifest.get("label_registry") != registry:
        raise ValueError("Label rename registry must have one canonical owner")
    validate_registry(root, read(root, registry))
    if "../" + registry not in (root / "docs/provenance.md").read_text():
        raise ValueError("Provenance must link the canonical label registry")
    provenance = manifest.get("provenance", {})
    if provenance.get("private_inputs_tracked") is not False or registry not in provenance.get("references", []):
        raise ValueError("Missing public provenance or private-input boundary")
    for name in provenance["references"]:
        if not (root / name).is_file():
            raise ValueError("Missing provenance reference")
    layout = read(root, manifest["semantic_source"]["manifest"])
    if (
        layout.get("state") != "complete"
        or any(row.get("status") != "owned" for row in layout["files"])
        or len(layout["files"]) != manifest["semantic_source"]["owned_units"]
        or manifest["semantic_source"].get("pending_units") != 0
    ):
        raise ValueError("Incomplete source ownership")
    authoring = manifest["authoring"]
    catalog = read(root, authoring["manifest"])
    if authoring.get("gui_editors") is not False or authoring.get("scope") != catalog.get("scope"):
        raise ValueError("Authoring scope must remain headless with fixed allocations")
    if len(catalog["artifacts"]) != authoring["private_inputs"]:
        raise ValueError("Content input count is stale")
    for field, link, collection in (
        ("assembly_resources", "assembly_catalog", "resources"),
        ("palette_groups", "palette_catalog", "groups"),
        ("raw_groups", "raw_catalog", "groups"),
        ("indexed_palette_groups", "indexed_palette_catalog", "groups"),
    ):
        if len(read(root, catalog[link])[collection]) != authoring[field]:
            raise ValueError("Content family count is stale: " + field)
    review = read(root, manifest["documentation_review"])
    documents = document_inventory(root, names, review)
    history = validate_history(root, manifest)
    print("[OK] Source 2.0 metadata, complete delta, public commands and documentation")
    return manifest, documents, history

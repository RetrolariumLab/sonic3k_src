"""Fail-fast preservation acceptance and evidence-based publication audit."""

import argparse
from datetime import datetime, timezone
import json
import subprocess

from scripts.build.project import ROOT, atomic, image_records, inside, load, profiles, sha, source_fingerprint
from scripts.build.relocation import verify_manifest
from scripts.runtime.contracts import bus_image, check_run_evidence, runtime_signature, scenarios
from scripts.validation.private_data import audit_repository
from scripts.validation.audio_storage import check as check_audio_storage
from scripts.authoring.driver_payloads import check as check_driver_payloads
from scripts.validation.release_tags import audit_tags

REQUIREMENTS = frozenset(
    (
        "canonical_identity",
        "reproducible_build",
        "executable_source",
        "symbolic_pointers",
        "runtime_coverage",
        "baseline_validation",
        "baseline_documentation",
        "private_inputs_and_history",
        "licensing_and_provenance",
        "release_contract",
    )
)
STAGES = (
    ("style", ("lint", "check-release-metadata")),
    ("tool-tests", ("test",)),
    ("legal-inputs-and-tools", ("check-inputs", "verify-toolchain")),
    ("extraction", ("split", "check-assets")),
    ("clean-preservation-identity", ("clean", "verify-all")),
    (
        "symbolic-and-relocation",
        (
            "check-lockon",
            "check-numeric-operands",
            "check-audio-binding",
            "check-driver-audio",
            "build-relocated",
            "check-relocated",
        ),
    ),
    ("runtime", ("verify-emulator", "trace", "trace-relocated")),
    ("publication-audit", ("release-audit",)),
)


def validate_profiles(manifest, images):
    declared = manifest["profiles"]
    if len({r["id"] for r in declared}) != len(declared) or {r["id"] for r in declared} != set(images):
        raise ValueError("Release profile registry is incomplete or duplicated")
    artifacts = manifest["artifacts"]
    if len({r["profile"] for r in artifacts}) != len(artifacts) or {r["profile"] for r in artifacts} != set(images):
        raise ValueError("Release artifact registry is incomplete or duplicated")
    for row in artifacts:
        image = images[row["profile"]]
        if row.get("tracked") is not False or any(row[k] != image[k] for k in ("size", "sha1", "sha256")):
            raise ValueError("Release artifact differs from its legal input")
        if row["path"] != "build/images/" + row["profile"] + ".bin":
            raise ValueError("Release output escapes its canonical ignored path")
        owners = [r for r in declared if r["id"] == row["profile"]]
        if owners[0]["artifact"] != row["id"] or owners[0]["identity"] != "byte-identical":
            raise ValueError("Release profile/artifact ownership differs")


def audit_runtime(matrix):
    contract, entries = scenarios()
    by_profile = {r["profile"]: r for r in entries}
    signature = runtime_signature()
    source = source_fingerprint()
    variants = {v["id"]: v for v in matrix["variants"]}
    for command, cases in (
        ("check", {(key, None) for key in profiles()}),
        ("matrix", {(key, variant) for key in profiles() for variant in variants}),
    ):
        evidence = load("build/runtime/evidence/" + command + ".json")
        manifest_hash = sha((ROOT / "build/relocated/manifest.json").read_bytes()) if command == "matrix" else None
        check_run_evidence(evidence, source, signature, cases, manifest_hash)
        if evidence.get("command") != command:
            raise ValueError("Runtime evidence has the wrong command owner")
        for row in evidence["results"]:
            entry = by_profile[row["profile"]]
            if row["checks"] != entry["check"]:
                raise ValueError("Runtime result uses an undeclared golden")
            log = inside(row["log"], ROOT / "build")
            if sha(log.read_bytes()) != row["log_sha256"]:
                raise ValueError("Runtime log differs from its accepted evidence")
            expected_cells = len(contract["cell_symbols"]) * len(load(entry["check"])["frames"])
            if "[OK] " not in log.read_text(encoding="utf-8") or str(
                expected_cells
            ) + " cell(s) match the original" not in log.read_text(encoding="utf-8"):
                raise ValueError("Runtime log does not report the complete original comparison")
            if command == "matrix":
                artifact = variants[row["variant"]]["artifacts"][row["profile"]]
                payload = inside(artifact["path"], ROOT / "build").read_bytes()
            else:
                payload = (ROOT / "build/images" / (row["profile"] + ".bin")).read_bytes()
            if row["image_sha256"] != sha(bus_image(entry, payload)):
                raise ValueError("Runtime result is bound to a different bus image")


def validate_identity(manifest):
    if (
        manifest.get("schema_version") != 1
        or manifest.get("release_line") != "1.0"
        or manifest.get("release_kind") != "preservation"
    ):
        raise ValueError("Invalid preservation release identity")
    if manifest.get("status") not in ("development", "tag-ready", "tagged"):
        raise ValueError("Invalid release status")
    if manifest.get("release", {}).get("version") != "1.0" or manifest.get("tag") != "source-reconstruction-1.0":
        raise ValueError("Release version and tag do not agree")
    if set(manifest.get("requirements", {})) != REQUIREMENTS:
        raise ValueError("Incomplete project requirement registry")
    statuses = {"satisfied", "not_applicable", "partial", "unsupported", "planned"}
    if any(row.get("status") not in statuses for row in manifest["requirements"].values()):
        raise ValueError("Invalid requirement status")
    delta = manifest.get("delta", [])
    if (
        not delta
        or len({row["id"] for row in delta}) != len(delta)
        or any(not row.get("summary") or not row.get("commits") for row in delta)
    ):
        raise ValueError("Release delta is missing, duplicated or unexplained")
    tools = manifest.get("toolchain", {})
    if (
        not isinstance(tools, dict)
        or tools.get("manifest") != "config/toolchain.json"
        or not tools.get("supported_hosts")
    ):
        raise ValueError("Release toolchain or host declaration is missing")
    allowed = {"licensed", "license_not_granted", "private_user_supplied", "external_unbundled", "unknown"}
    if not manifest.get("licensing") or any(
        r.get("license_id_or_status") not in allowed or not r.get("origin") for r in manifest["licensing"]
    ):
        raise ValueError("Invalid or missing component provenance/license status")


def check_metadata():
    manifest = load("config/source_reconstruction_1_0.json")
    validate_identity(manifest)
    validate_profiles(manifest, image_records())
    for name in manifest["required_documents"]:
        if not inside(name).is_file():
            raise ValueError("Required release document is missing: " + name)
    for requirement in manifest["requirements"].values():
        for name in requirement["evidence"]["files"]:
            if not inside(name).exists():
                raise ValueError("Missing declared evidence file: " + name)
    print("[OK] Release identity, states, delta, legal metadata and profile identities")
    return manifest


def audit(post_tag=False):
    manifest = check_metadata()
    tags = audit_tags(manifest, post_tag)
    if (
        manifest["schema_version"] != 1
        or manifest["release_line"] != "1.0"
        or manifest["release_kind"] != "preservation"
    ):
        raise ValueError("Invalid preservation release identity")
    if manifest["status"] not in ("tag-ready", "tagged"):
        raise ValueError("Unknown preservation release status")
    if set(manifest["requirements"]) != REQUIREMENTS:
        raise ValueError("Release requirements are incomplete or unknown")
    if any(r["status"] != "satisfied" for r in manifest["requirements"].values()):
        raise ValueError("Release requirement verification is still pending")
    validate_profiles(manifest, image_records())
    for path in manifest["required_documents"]:
        if not inside(path).is_file():
            raise ValueError("Required release document is missing: " + path)
    for requirement in manifest["requirements"].values():
        for path in requirement["evidence"]["files"]:
            if not inside(path).exists():
                raise ValueError("Declared requirement evidence is missing: " + path)
    if set(manifest["reference"]["images"]) != set(profiles()):
        raise ValueError("Release private input references omit a profile")
    if manifest["excluded_scope"] != load("config/revision_profiles.json")["excluded_scope"]:
        raise ValueError("Release scope differs from profile scope")
    for name in ("binary_suffixes", "forbidden_prefixes"):
        field = "prohibited_tracked_extensions" if name == "binary_suffixes" else "prohibited_tracked_prefixes"
        if manifest[field] != load("config/binary_allowlist.json")[name]:
            raise ValueError("Release privacy policy differs from the executable audit")
    binding = load("build/source_binding.json")
    if (
        not binding["byte_identity_checked"]
        or binding["source_sha256"] != source_fingerprint()
        or set(binding["profiles"]) != set(profiles())
    ):
        raise ValueError("Preservation evidence is stale or lacks a profile")
    identity = load("build/identity.json")
    for key, image in image_records().items():
        data = (ROOT / "build/images" / (key + ".bin")).read_bytes()
        if len(data) != image["size"] or sha(data) != image["sha256"] or identity[key]["byte_identical"] is not True:
            raise ValueError("Preservation output or byte-identity evidence changed")
    check_audio_storage(built=True)
    check_driver_payloads(built=True)
    matrix = verify_manifest()
    audit_runtime(matrix)
    privacy = audit_repository(ROOT)
    history = subprocess.check_output(["git", "-C", str(ROOT), "rev-list", "--all"]).decode().splitlines()
    for revision in history:
        changed = subprocess.check_output(
            ["git", "-C", str(ROOT), "diff-tree", "--root", "--no-commit-id", "--name-only", "-r", revision]
        )
        if not changed.strip():
            raise ValueError("An empty commit is reachable")
    dirty = subprocess.check_output(["git", "-C", str(ROOT), "status", "--porcelain=v1", "--untracked-files=normal"])
    if dirty.strip():
        raise ValueError("Release requires a clean tracked tree and no unignored files")
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source_fingerprint(),
        "profiles": list(profiles()),
        "relocation_variants": len(matrix["variants"]),
        "privacy": privacy,
        "release_identity": tags,
    }
    destination = "build/release/post-tag.json" if post_tag else "build/release/audit.json"
    atomic(ROOT / destination, (json.dumps(report, indent=2) + "\n").encode())
    print("[OK] Preservation publication audit, runtime matrix and clean history")


def run_stages(stages, execute):
    completed = []
    for name, targets in stages:
        print("[CHECK] " + name, flush=True)
        execute(targets)
        completed.append(name)
    return completed


def check():
    destination = ROOT / "build/release/source-1-check.json"
    report = {
        "schema_version": 1,
        "complete": False,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "stages": [],
    }
    atomic(destination, (json.dumps(report, indent=2) + "\n").encode())

    def execute(targets):
        subprocess.run(["make", *targets], cwd=ROOT, check=True)
        report["stages"].append(list(targets))
        atomic(destination, (json.dumps(report, indent=2) + "\n").encode())

    run_stages(STAGES, execute)
    report.update(complete=True, source_sha256=source_fingerprint())
    atomic(destination, (json.dumps(report, indent=2) + "\n").encode())
    print("[OK] Source Reconstruction 1.0 complete aggregate gate")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("check", "audit", "metadata"))
    parser.add_argument("--post-tag", action="store_true")
    args = parser.parse_args(argv)
    if args.post_tag and args.command != "audit":
        parser.error("--post-tag is available only for audit")
    if args.command == "check":
        check()
    elif args.command == "audit":
        audit(post_tag=args.post_tag)
    else:
        check_metadata()
    return 0

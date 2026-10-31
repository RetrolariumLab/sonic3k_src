"""Serial complete Source 2.0 acceptance; never creates tags or publishes."""

import argparse
from datetime import datetime, timezone
import json
import subprocess

from scripts.authoring.formats_workflow import load_catalog, tooling_fingerprint
from scripts.build.project import ROOT, atomic, image_records, inside, load, sha, source_fingerprint, source_names
from scripts.validation import release
from scripts.validation.source_2_contract import STAGES, metadata, public_fingerprint

DESTINATION = "build/release/source-2-check.json"


def save(name, value):
    atomic(inside(name), (json.dumps(value, indent=2) + "\n").encode())


def validate_content(report, manifest, source, tooling, images):
    if (
        report.get("complete") is not True
        or report.get("source_sha256") != source
        or report.get("tooling_sha256") != tooling
    ):
        raise ValueError("Content evidence is incomplete or stale")
    if report.get("profiles") != {key: row["sha256"] for key, row in images.items()}:
        raise ValueError("Encoded containers lack an accepted profile or exact identity")
    fields = {
        "all_registered_inputs": "private_inputs",
        "assembly_resources": "assembly_resources",
        "palette_groups": "palette_groups",
        "raw_groups": "raw_groups",
        "raw_source_entries": "raw_source_entries",
        "indexed_palette_groups": "indexed_palette_groups",
    }
    if any(report.get(k) != manifest["authoring"][v] for k, v in fields.items()):
        raise ValueError("Content evidence omits a declared family")


def validate_aggregate(running, source, tooling, public, post_tag=False, final_audit_hash=None):
    expected_stages = STAGES if post_tag else STAGES[:-1]
    if post_tag and (
        running.get("complete") is not True
        or final_audit_hash is None
        or running.get("audit_sha256") != final_audit_hash
    ):
        raise ValueError("Post-tag audit requires the completed exact aggregate and its final audit")
    if (
        running.get("public_sha256") != public
        or running.get("source_sha256") != source
        or running.get("tooling_sha256") != tooling
        or running.get("stages") != [list(targets) for _, targets in expected_stages]
    ):
        raise ValueError("Release audit requires this complete aggregate's preceding stages")


def audit(post_tag=False):
    manifest, documents, history = metadata()
    source, tooling, public = source_fingerprint(), tooling_fingerprint(), public_fingerprint()
    running = load(DESTINATION)
    final_audit_hash = sha((ROOT / "build/release/source-2-audit.json").read_bytes()) if post_tag else None
    validate_aggregate(running, source, tooling, public, post_tag, final_audit_hash)
    first = load("build/release/source-1-check.json")
    if (
        first.get("complete") is not True
        or first.get("source_sha256") != source
        or first.get("stages") != [list(targets) for _, targets in release.STAGES]
        or running.get("source_1_report_sha256") != sha((ROOT / "build/release/source-1-check.json").read_bytes())
    ):
        raise ValueError("The full current Source 1.0 gate has not passed")
    release.audit(post_tag=post_tag)  # Recheck artifacts without replacing pre-tag acceptance reports.
    content = load("build/authoring/zero-edit-containers.json")
    validate_content(content, manifest, source, tooling, image_records())
    from scripts.authoring.edited_containers import audit as audit_edited

    audit_edited()
    roundtrip = load("build/authoring/roundtrip.json")
    if (
        roundtrip.get("complete") is not True
        or roundtrip.get("source_sha256") != source
        or roundtrip.get("tooling_sha256") != tooling
        or roundtrip.get("workspace") != content.get("roundtrip_workspace")
        or roundtrip.get("workspace_source_sha256") != content.get("workspace_source_sha256")
    ):
        raise ValueError("Encoded-source workspace evidence differs from container evidence")
    workspace = inside(roundtrip["workspace"], ROOT)
    if not workspace.is_relative_to((ROOT / "build/authoring").resolve()):
        raise ValueError("Content workspace leaves its declared build root")
    _, assets = load_catalog()
    if set(roundtrip["outputs"]) != set(assets):
        raise ValueError("Content workspace lacks a registered private input")
    if set(roundtrip["source_outputs"]) != set(source_names()):
        raise ValueError("Content workspace lacks a source owner")
    for prefix, outputs in (("data/", roundtrip["outputs"]), ("", roundtrip["source_outputs"])):
        for name, expected in outputs.items():
            if sha(inside(prefix + name, workspace).read_bytes()) != expected:
                raise ValueError("Encoded workspace changed after acceptance: " + name)
    for key, expected in content["profiles"].items():
        if sha((workspace / "rebuilt/images" / (key + ".bin")).read_bytes()) != expected:
            raise ValueError("Encoded image changed after acceptance")
    if load("build/release/documentation.json") != documents:
        raise ValueError("Documentation review evidence is stale")
    report = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source,
        "tooling_sha256": tooling,
        "public_sha256": public,
        "history": history,
        "profiles": list(image_records()),
        "evidence": {
            name: sha(inside(name).read_bytes())
            for name in (
                "build/release/source-1-check.json",
                "build/release/audit.json",
                "build/authoring/roundtrip.json",
                "build/authoring/zero-edit-containers.json",
                "build/authoring/edited-containers.json",
                "build/runtime/evidence/check.json",
                "build/runtime/evidence/matrix.json",
                "build/runtime/evidence/extended.json",
                "build/release/documentation.json",
            )
        },
    }
    if post_tag:
        report["release_identity"] = load("build/release/post-tag.json")["release_identity"]
    save("build/release/source-2-post-tag.json" if post_tag else "build/release/source-2-audit.json", report)
    print("[OK] Source 2.0 current preservation, content, documentation and history audit")
    return report


def check():
    report = {
        "schema_version": 1,
        "complete": False,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "source_sha256": source_fingerprint(),
        "tooling_sha256": tooling_fingerprint(),
        "public_sha256": public_fingerprint(),
        "stages": [],
    }
    save(DESTINATION, report)

    def execute(targets):
        subprocess.run(["make", *targets], cwd=ROOT, check=True)
        if public_fingerprint() != report["public_sha256"]:
            raise ValueError("Public inputs changed during the aggregate gate")
        report["stages"].append(list(targets))
        if targets == ("release-check",):
            report["source_1_report_sha256"] = sha((ROOT / "build/release/source-1-check.json").read_bytes())
        save(DESTINATION, report)

    release.run_stages(STAGES, execute)
    report.update(
        complete=True,
        audit_sha256=sha((ROOT / "build/release/source-2-audit.json").read_bytes()),
        finished_utc=datetime.now(timezone.utc).isoformat(),
    )
    save(DESTINATION, report)
    print("[OK] Source Reconstruction 2.0 complete aggregate gate")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("metadata", "audit", "check"))
    parser.add_argument("--post-tag", action="store_true")
    args = parser.parse_args(argv)
    if args.post_tag and args.command != "audit":
        parser.error("--post-tag is available only for audit")
    if args.command == "metadata":
        metadata()
    elif args.command == "audit":
        audit(post_tag=args.post_tag)
    else:
        check()
    return 0

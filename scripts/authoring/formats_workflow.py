"""Run complete original-resource and rebuilt-container content checks."""

from collections import defaultdict
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

from scripts.authoring import (
    assembly_workflow,
    content_profiles,
    core_compression,
    driver_inputs,
    format_codecs,
    smps_storage,
    palette_workflow,
    palette_indexed_workflow,
    raw_workflow,
    source_fragments,
)
from scripts.authoring.content_contract import ContentCatalog
from scripts.authoring.driver_payloads import resolve_contract
from scripts.build.pipeline import build_selected
from scripts.build.project import ROOT, atomic, load, profiles, read_reference, source_fingerprint, source_names


def load_catalog():
    manifest, recipe, audio = (
        load("assets/manifest.json"),
        load("config/audio_driver_payloads.json"),
        load("config/audio_streams.json"),
    )
    primary = {row["path"]: row for row in manifest["assets"]}
    derived = {row["path"]: row for row in resolve_contract(recipe, primary, audio["engines"])}
    assets = primary | derived
    return ContentCatalog(load("config/authoring/data_formats.json"), assets, profiles()), assets


def tooling_fingerprint():
    names = (
        subprocess.check_output(["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"], cwd=ROOT)
        .decode()
        .split("\0")
    )
    selected = sorted(
        {
            name
            for name in names
            if name.endswith(".py")
            and name.startswith(("scripts/", "tests/"))
            or name.startswith("config/")
            or name in {"assets/manifest.json", "Makefile", "mk/authoring.mk"}
        }
        - {""}
    )
    digest = hashlib.sha256()
    for name in selected:
        digest.update(name.encode() + bytes(1) + (ROOT / name).read_bytes() + bytes(1))
    return digest.hexdigest()


def _save(name, value):
    atomic(ROOT / "build/authoring" / name, (json.dumps(value, indent=2) + "\n").encode())


def roundtrip():
    core_compression.tool()  # Full content acceptance never skips this backend.
    catalog, assets = load_catalog()
    source = source_fingerprint()
    tooling = tooling_fingerprint()
    rebuilt_seeds, seed_report = driver_inputs.check()
    locations = content_profiles.check(catalog, assets)
    base = ROOT / "build/authoring"
    base.mkdir(parents=True, exist_ok=True)
    workspace = Path(tempfile.mkdtemp(prefix="roundtrip-", dir=base)).resolve()
    if not workspace.is_relative_to(base.resolve()):
        raise ValueError("Round-trip workspace leaves ignored storage")
    report = {
        "schema_version": 1,
        "complete": False,
        "source_sha256": source,
        "tooling_sha256": tooling,
        "workspace": workspace.relative_to(ROOT).as_posix(),
        "artifacts": [],
        "source_rebuilt_inputs": seed_report,
    }
    _save("roundtrip.json", report)
    context = {"codebook": (ROOT / "data/Sound/DAC/deltas.bin").read_bytes()}
    groups, results = defaultdict(list), dict(rebuilt_seeds)
    for row in catalog.rows():
        name = row["path"]
        if row["codec"] == "source-driver-tables":
            continue
        if row["codec"] == "smps-corpus":
            asset = assets[name]
            groups[(asset["image"], asset["offset"] // 32768, row["parameters"]["abi"])].append(row)
            continue
        original = (ROOT / "data" / name).read_bytes()
        for profile in row["profiles"]:
            packet = catalog.decode(name, profile, original, context=context)
            encoded = catalog.encode(packet, target_profile=profile, original=original, context=context)
            if encoded != original:
                raise ValueError("Zero-edit resource differs from its original bytes: " + name)
        if row["compression"] != "none":
            plain = format_codecs.encode_plain(row, packet["model"], context=context)
            format_codecs.compress(row, plain, original, force=True)
        results[name] = encoded
        report["artifacts"].append(
            {
                "path": name,
                "profiles": row["profiles"],
                "sha256": hashlib.sha256(encoded).hexdigest(),
                "zero_edit_byte_exact": True,
            }
        )
        if len(results) % 100 == 0:
            print("[OK] Content resources: " + str(len(results)), flush=True)
    images = {row["id"]: row for row in load("assets/manifest.json")["images"]}
    for (image, bank, abi), rows in sorted(groups.items()):
        originals = {row["path"]: (ROOT / "data" / row["path"]).read_bytes() for row in rows}
        inputs = [
            {
                "id": name,
                "bank_offset": assets[name]["offset"] % 32768,
                "kind": "music" if "/Music/" in name else "sfx",
                "data": data,
            }
            for name, data in originals.items()
        ]
        reference = read_reference(images[image])[bank * 32768 : (bank + 1) * 32768]
        model = smps_storage.decode_corpus(inputs, reference, abi=abi)
        applicable = set.intersection(*(set(row["profiles"]) for row in rows))
        if any(set(row["profiles"]) != applicable for row in rows):
            raise ValueError("Shared SMPS bank corpus has inconsistent profile applicability")
        for profile in sorted(applicable):
            encoded = catalog.encode_corpus(model, target_profile=profile, abi=abi, originals=originals)
            if encoded != originals:
                raise ValueError("Zero-edit SMPS corpus differs from original bytes")
        results.update(encoded)
        for row in rows:
            report["artifacts"].append(
                {
                    "path": row["path"],
                    "profiles": row["profiles"],
                    "sha256": hashlib.sha256(encoded[row["path"]]).hexdigest(),
                    "zero_edit_byte_exact": True,
                }
            )
        print("[OK] SMPS corpus " + image + " " + hex(bank * 32768), flush=True)
    if set(results) != set(assets):
        raise ValueError("Full content round trip omits a primary, derived or source-rebuilt input")
    for name, data in results.items():
        # Identity, ABI and capacity checks have all finished before workspace writes.
        destination = (workspace / "data" / name).resolve()
        if not destination.is_relative_to(workspace / "data"):
            raise ValueError("Encoded resource leaves its workspace")
        atomic(destination, data)
    report["assembly_content"] = assembly_workflow.roundtrip(workspace)
    palette_patches, palette_evidence = palette_workflow.prepare(workspace)
    raw_patches, raw_evidence = raw_workflow.prepare(workspace)
    indexed_patches, indexed_evidence = palette_indexed_workflow.prepare(workspace)
    patches = palette_patches + raw_patches + indexed_patches
    originals = {name: (ROOT / name).read_bytes() for name in {p["path"] for p in patches}}
    report["source_fragments"] = source_fragments.write(workspace, originals, patches)
    report["palette_content"] = {
        "groups": len(palette_evidence),
        "initializers": sum(r["initializers"] for r in palette_evidence),
        "source_files": len({r["path"] for r in palette_evidence}),
        "artifacts": palette_evidence,
    }
    report["raw_content"] = {
        "groups": len(raw_evidence),
        "source_entries": sum(len(r["members"]) for r in raw_evidence),
        "source_files": len({r["path"] for r in raw_evidence}),
        "artifacts": raw_evidence,
    }
    report["indexed_palette_content"] = {
        "groups": len(indexed_evidence),
        "source_files": len({r["path"] for r in indexed_evidence}),
        "artifacts": indexed_evidence,
    }
    print(
        "[OK] Composed palette/raw source spans: "
        + str(len(patches))
        + " in "
        + str(report["source_fragments"]["source_files"])
        + " source files",
        flush=True,
    )
    source_outputs = dict(report["assembly_content"]["outputs"])
    if set(source_outputs) & set(report["source_fragments"]["outputs"]):
        raise ValueError("Semantic source content has duplicate authoring owners")
    source_outputs.update(report["source_fragments"]["outputs"])
    for name in source_names():
        if name not in source_outputs:
            payload = (ROOT / name).read_bytes()
            atomic(workspace / name, payload)
            source_outputs[name] = hashlib.sha256(payload).hexdigest()
    report["source_outputs"] = source_outputs
    report["workspace_source_sha256"] = source_fingerprint(workspace)
    report["source_input_paths"] = sorted(rebuilt_seeds)
    report["outputs"] = {name: hashlib.sha256(data).hexdigest() for name, data in sorted(results.items())}
    report["profile_use_count"] = sum(len(row["profiles"]) for row in catalog.rows())
    if source != source_fingerprint() or tooling != tooling_fingerprint():
        raise ValueError("Content tooling changed during the round trip")
    report["complete"] = True
    _save("roundtrip.json", report)
    print("[OK] All " + str(len(results)) + " registered resources passed the zero-edit round trip", flush=True)
    return report


def zero_edit():
    report = load("build/authoring/roundtrip.json")
    if (
        not report.get("complete")
        or report["source_sha256"] != source_fingerprint()
        or report["tooling_sha256"] != tooling_fingerprint()
    ):
        raise ValueError("Container check requires a current complete content round trip")
    workspace = (ROOT / report["workspace"]).resolve()
    if not workspace.is_relative_to((ROOT / "build/authoring").resolve()):
        raise ValueError("Encoded content workspace leaves ignored storage")
    catalog, assets = load_catalog()
    if set(report["outputs"]) != set(assets):
        raise ValueError("Encoded workspace does not contain every registered resource")
    for name, expected in report["outputs"].items():
        data = (workspace / "data" / name).read_bytes()
        if hashlib.sha256(data).hexdigest() != expected:
            raise ValueError("Encoded workspace resource changed after its round trip")
    if set(report["source_outputs"]) != set(source_names()):
        raise ValueError("Encoded workspace omits a checked source owner")
    for name, expected in report["source_outputs"].items():
        if hashlib.sha256((workspace / name).read_bytes()).hexdigest() != expected:
            raise ValueError("Encoded semantic source changed after its round trip")
    if source_fingerprint(workspace) != report["workspace_source_sha256"]:
        raise ValueError("Zero-edit source differs from the encoded semantic workspace")
    outputs = build_selected(
        list(profiles()), source_root=workspace, output_root=workspace / "rebuilt/images", verify=True
    )
    if report["tooling_sha256"] != tooling_fingerprint():
        raise ValueError("Content tooling changed during container rebuilding")
    result = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": report["source_sha256"],
        "tooling_sha256": report["tooling_sha256"],
        "roundtrip_workspace": report["workspace"],
        "all_registered_inputs": len(assets),
        "assembly_resources": report["assembly_content"]["resources"],
        "palette_groups": report["palette_content"]["groups"],
        "palette_initializers": report["palette_content"]["initializers"],
        "palette_source_files": report["palette_content"]["source_files"],
        "raw_groups": report["raw_content"]["groups"],
        "raw_source_entries": report["raw_content"]["source_entries"],
        "indexed_palette_groups": report["indexed_palette_content"]["groups"],
        "indexed_palette_source_files": report["indexed_palette_content"]["source_files"],
        "raw_source_files": report["raw_content"]["source_files"],
        "workspace_source_sha256": report["workspace_source_sha256"],
        "profiles": {key: hashlib.sha256(path.read_bytes()).hexdigest() for key, path in outputs.items()},
    }
    _save("zero-edit-containers.json", result)
    print("[OK] Every preservation container rebuilt byte identically from encoded content", flush=True)
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("check-contract", "roundtrip", "zero-edit"))
    args = parser.parse_args(argv)
    if args.command == "check-contract":
        catalog, assets = load_catalog()
        from scripts.authoring.edited_containers import probe_definitions

        probe_definitions(catalog, assets)
        source_catalog = assembly_workflow.catalog()
        palette_catalog, palette_sources = palette_workflow.catalog()
        raw_catalog, raw_sources = raw_workflow.catalog()
        indexed_catalog, indexed_sources = palette_indexed_workflow.catalog()
        print(
            "[OK] Complete immutable content registry: "
            + str(len(catalog.rows()))
            + " inputs and "
            + str(len(source_catalog.rows()))
            + " source resources and "
            + str(len(palette_catalog.rows()))
            + " palette groups and "
            + str(len(raw_catalog.rows()))
            + " registered raw groups and "
            + str(len(indexed_catalog.rows()))
            + " indexed palette groups"
        )
    elif args.command == "roundtrip":
        roundtrip()
    else:
        zero_edit()
    return 0

"""Capture originals or compare source-built images with pinned RAM checkpoints."""

import argparse
import json
from pathlib import Path

from scripts.build.project import (
    ROOT,
    atomic,
    image_records,
    inside,
    load,
    profiles,
    read_reference,
    sha,
    source_fingerprint,
)
from scripts.runtime.contracts import bus_image, runtime_signature, scenarios, validate_golden
from scripts.runtime.native import prepare, run_movie
from scripts.validation.symbols import parse_symbols


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("prepare", "golden", "check", "matrix"))
    parser.add_argument("--mame", type=Path)
    parser.add_argument("--profile")
    parser.add_argument("--manifest", default="build/relocated/manifest.json")
    args = parser.parse_args(argv)
    evidence_path = ROOT / "build/runtime/evidence" / (args.command + ".json")
    start_source = source_fingerprint()
    start_signature = runtime_signature()
    if args.command != "prepare":
        atomic(
            evidence_path,
            (json.dumps({"complete": False, "command": args.command, "source_sha256": start_source}) + "\n").encode(),
        )
        atomic(ROOT / "build/runtime/results.json", b"[]\n")
    mame = prepare(args.mame)
    if args.command == "prepare":
        print("[OK] Pinned MAME ready under build/")
        return 0
    binding = load("build/source_binding.json")
    if binding["source_sha256"] != source_fingerprint() or not binding["byte_identity_checked"]:
        raise ValueError("Preservation assembly evidence is stale; run make verify-all")
    contract, entries = scenarios()
    if args.profile:
        entries = [e for e in entries if e["profile"] == args.profile]
        if not entries:
            parser.error("Unknown runtime profile")
    results = []
    variants = [None]
    matrix = None
    if args.command == "matrix":
        from scripts.build.relocation import verify_manifest

        matrix = verify_manifest(args.manifest)
        if matrix["source_sha256"] != source_fingerprint():
            raise ValueError("Relocation evidence is stale; rebuild the probe matrix")
        variants = matrix["variants"]
        if not variants or len({v["id"] for v in variants}) != len(variants):
            raise ValueError("Relocation manifest has missing or duplicated variants")
        for variant in variants:
            if set(variant["artifacts"]) != set(profiles()):
                raise ValueError("Relocation runtime lacks an accepted profile")
    for variant in variants:
        for entry in entries:
            key = entry["profile"]
            spec = load(entry["check"])
            owner = key
            while "compose" in profiles()[owner]:
                owner = profiles()[owner]["compose"][0]
            symbols = parse_symbols(
                (ROOT / "build/objects" / owner / "main.lst").read_text(encoding="utf-8", errors="replace")
            )
            validate_golden(entry, spec, contract, symbols)
            if args.command == "golden":
                data = read_reference(image_records()[key])
                artifact = None
                label = key + "-golden"
            elif variant is None:
                data = (ROOT / "build/images" / (key + ".bin")).read_bytes()
                expected = image_records()[key]
                if len(data) != expected["size"] or sha(data) != expected["sha256"]:
                    raise ValueError("Preservation runtime image is unverified: " + key)
                artifact = None
                label = key + "-preservation"
            else:
                artifact = variant["artifacts"][key]
                path = inside(artifact["path"], ROOT / "build")
                data = path.read_bytes()
                if len(data) != artifact["size"] or sha(data) != artifact["sha256"]:
                    raise ValueError("Relocation artifact differs from its build evidence")
                label = key + "-" + variant["id"]
            image = ROOT / "build/runtime/images" / (label + ".bin")
            atomic(image, bus_image(entry, data))
            log = ROOT / "build/runtime/logs" / (label + ".log")
            command = "golden" if args.command == "golden" else "check"
            run_movie([command, ROOT / entry["check"], "--rom", image, "--mame", mame], log)
            if args.command == "golden":
                validate_golden(entry, load(entry["check"]), contract, symbols)
            results.append(
                {
                    "profile": key,
                    "variant": None if variant is None else variant["id"],
                    "image_sha256": sha(image.read_bytes()),
                    "checks": entry["check"],
                    "passed": True,
                    "log": log.relative_to(ROOT / "build").as_posix(),
                    "log_sha256": sha(log.read_bytes()),
                }
            )
            atomic(ROOT / "build/runtime/results.json", (json.dumps(results, indent=2) + "\n").encode())
            print("[OK] Runtime RAM matched: " + label, flush=True)
    if start_source != source_fingerprint() or (args.command != "golden" and start_signature != runtime_signature()):
        raise ValueError("Source or scenario changed during runtime verification")
    evidence = {
        "schema_version": 1,
        "complete": True,
        "command": args.command,
        "source_sha256": start_source,
        "scenario_sha256": runtime_signature(),
        "manifest_sha256": sha((ROOT / args.manifest).read_bytes()) if matrix is not None else None,
        "results": results,
    }
    atomic(evidence_path, (json.dumps(evidence, indent=2) + "\n").encode())
    return 0

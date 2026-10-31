"""Compare extended original-input routes, including a real cartridge SRAM cycle."""

import argparse
import json
import re

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
from scripts.build.relocation import verify_manifest
from scripts.runtime.contracts import bus_image, scenarios
from scripts.runtime.native import prepare, read_nvram, run_movie
from scripts.validation.symbols import parse_symbols

CONFIG = "config/runtime/extended_scenarios.json"
PROVENANCE = "scenarios/extended/provenance.json"
EVIDENCE = "build/runtime/evidence/extended.json"


def save(path, value):
    atomic(path, (json.dumps(value, indent=2) + "\n").encode())


def definitions():
    contract = load(CONFIG)
    cases = contract.get("cases", [])
    if contract.get("schema_version") != 1 or contract.get("relocated_variant") != "g0" or not cases:
        raise ValueError("Missing extended runtime contract")
    seen = {}
    for case in cases:
        name = case.get("id", "")
        keys = case.get("profiles", [])
        if not re.fullmatch("[a-z][a-z0-9-]*", name) or name in seen:
            raise ValueError("Invalid or duplicate extended route")
        if not keys or len(keys) != len(set(keys)) or not set(keys) <= set(profiles()):
            raise ValueError("Invalid extended route profiles")
        if not case.get("states") or not case.get("progress"):
            raise ValueError("Extended routes require reached states and observed progress")
        if not 1200 <= case.get("frames", 0) <= 30000 or case.get("step") not in (30, 60):
            raise ValueError("Invalid extended frame budget")
        if not case.get("cells") or not set(case["cells"]) <= set(contract["cells"]):
            raise ValueError("Extended route lacks a RAM contract")
        seed = case.get("seed")
        if seed is not None and (
            seed not in seen or not seen[seed].get("save_nvram") or not set(keys) <= set(seen[seed]["profiles"])
        ):
            raise ValueError("SRAM reload must follow its own declared original-input writer")
        for state in case["states"] + [row["where"] for row in case["progress"]]:
            if (
                not state
                or not set(state) <= set(case["cells"])
                or any(type(value) is not int or value < 0 for value in state.values())
            ):
                raise ValueError("Invalid reached-state predicates")
        for row in case["progress"]:
            if row.get("cell") not in case["cells"] or type(row.get("distinct")) is not int or row["distinct"] < 2:
                raise ValueError("Invalid progress predicate")
        movie = inside(case["movie"])
        if not movie.is_relative_to((ROOT / "scenarios/extended").resolve()):
            raise ValueError("Extended movie leaves its scenario owner")
        raw = movie.read_bytes()
        if b"\r" in raw:
            raise ValueError("Controller movies require canonical LF bytes; run make format")
        text = raw.decode("utf-8")
        if "source mame\n" not in text or "frames " + str(case["frames"]) + "\n" not in text:
            raise ValueError("Extended movie budget/source differs")
        # Public routes use controller input only; resets and injected state are absent.
        lines = text.split("\n---\n", 1)[1].splitlines()
        count = 0
        for line in lines:
            if not re.fullmatch(r"[1-9][0-9]* [0-9A-F]{2} [0-9A-F]{2}", line):
                raise ValueError("Extended movie contains commands beyond controller input")
            count += int(line.split()[0])
        if count != case["frames"]:
            raise ValueError("Extended movie does not account for every frame")
        seen[name] = case
    return contract, cases


def checkpoints(case):
    return list(range(case["step"], case["frames"], case["step"])) + ["end"]


def check_path(case, key):
    return "scenarios/extended/" + case["id"] + "/" + key + ".check.json"


def cell_addresses(contract, case, symbols):
    result = {}
    for name in case["cells"]:
        row = contract["cells"][name]
        offset = symbols[row["offset_symbol"]] if "offset_symbol" in row else row.get("offset", 0)
        address = (symbols[row["symbol"]] + offset) & 0xFFFFFF
        width = row["length"]
        if width not in (1, 2, 4) or not 0xFF0000 <= address <= 0x1000000 - width:
            raise ValueError("Extended observation is outside work RAM")
        result[name] = {"address": hex(address), "length": width}
    return result


def matches(values, state):
    return all(int(values[name], 16) == value for name, value in state.items())


def validate_observations(case, spec, cells):
    if spec.get("schema") != "retrolarium.movie-check" or spec.get("schema_version") != 1:
        raise ValueError("Invalid extended movie-check identity")
    if spec.get("cells") != cells or any(row.get("tolerance", 0) != 0 for row in spec["cells"].values()):
        raise ValueError("Extended RAM bindings differ from source or use tolerance")
    frames = checkpoints(case)
    if spec.get("frames") != frames or set(spec.get("expected", {})) != {str(frame) for frame in frames}:
        raise ValueError("Extended golden omits checkpoints")
    observed = []
    for frame in frames:
        values = spec["expected"][str(frame)]
        if set(values) != set(cells) or any(
            not re.fullmatch("[0-9a-fA-F]{" + str(cells[name]["length"] * 2) + "}", value)
            for name, value in values.items()
        ):
            raise ValueError("Extended golden omits or corrupts RAM values")
        observed.append(values)
    cursor = 0
    for state in case["states"]:
        while cursor < len(observed) and not matches(observed[cursor], state):
            cursor += 1
        if cursor == len(observed):
            raise ValueError("Original route did not reach its ordered required state: " + str(state))
        cursor += 1
    for row in case["progress"]:
        values = {frame[row["cell"]] for frame in observed if matches(frame, row["where"])}
        if len(values) < row["distinct"]:
            raise ValueError("Original route did not show required gameplay progress")


def signature():
    _, cases = definitions()
    names = {
        CONFIG,
        PROVENANCE,
        "config/runtime/emulator.json",
        "scripts/runtime/extended.py",
        "scripts/runtime/native.py",
        "scripts/runtime/processes.py",
        "scripts/runtime/contracts.py",
    }
    for case in cases:
        names.add(case["movie"])
        names.update(check_path(case, key) for key in case["profiles"])
    return sha(b"".join(name.encode() + b"\0" + inside(name).read_bytes() + b"\0" for name in sorted(names)))


def golden_record(case, key, output_nvram):
    return {
        "profile": key,
        "case": case["id"],
        "reference_sha256": image_records()[key]["sha256"],
        "movie_sha256": sha(inside(case["movie"]).read_bytes()),
        "check_sha256": sha(inside(check_path(case, key)).read_bytes()),
        "emulator_sha256": sha(inside("config/runtime/emulator.json").read_bytes()),
        "nvram_sha256": sha(output_nvram) if output_nvram is not None else None,
    }


def original_records(cases):
    proof = load(PROVENANCE)
    records = proof.get("results", [])
    expected = {(key, case["id"]) for case in cases for key in case["profiles"]}
    if (
        proof.get("complete") is not True
        or proof.get("method") != "verified-original-controller-input"
        or len(records) != len(expected)
        or {(row["profile"], row["case"]) for row in records} != expected
    ):
        raise ValueError("Extended originals lack complete capture provenance")
    return {(row["profile"], row["case"]): row for row in records}


def matrix_variant(matrix):
    variants = [row for row in matrix["variants"] if row["id"] == "g0"]
    if len(variants) != 1 or variants[0].get("group") != 0:
        raise ValueError("Extended runtime needs the declared representative relocation variant")
    return variants[0]


def symbol_tables():
    result = {}
    for key, profile in profiles().items():
        if "compose" not in profile:
            result[key] = parse_symbols((ROOT / "build/objects" / key / "main.lst").read_text(errors="replace"))
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("golden", "check", "audit"))
    args = parser.parse_args(argv)
    if args.command == "audit":
        audit(verify_manifest())
        return 0
    contract, cases = definitions()
    original = args.command == "golden"
    source = source_fingerprint()
    binding = load("build/source_binding.json")
    if (
        binding.get("source_sha256") != source
        or binding.get("byte_identity_checked") is not True
        or set(binding.get("profiles", {})) != set(profiles())
    ):
        raise ValueError("Extended runtime requires current verified source assembly")
    mame = prepare()
    entries = {row["profile"]: row for row in scenarios()[1]}
    matrix = None if original else verify_manifest()
    if matrix is not None and matrix.get("source_sha256") != source:
        raise ValueError("Extended relocation evidence is stale")
    variants = [None] if original else [None, matrix_variant(matrix)]
    tables = symbol_tables()
    before = None if original else signature()
    reference = {} if original else original_records(cases)
    destination = PROVENANCE if original else EVIDENCE
    save(inside(destination), {"complete": False, "source_sha256": source})
    results = []
    for variant in variants:
        snapshots = {}
        for case in cases:
            for key in case["profiles"]:
                owner = key
                while "compose" in profiles()[owner]:
                    owner = profiles()[owner]["compose"][0]
                symbols = tables[owner]
                cells = cell_addresses(contract, case, symbols)
                path = inside(check_path(case, key))
                if original:
                    spec = {
                        "schema": "retrolarium.movie-check",
                        "schema_version": 1,
                        "movie": "../" + inside(case["movie"]).name,
                        "machine": load(entries[key]["check"])["machine"],
                        "reference_image": key,
                        "cells": cells,
                        "frames": checkpoints(case),
                        "expected": {},
                    }
                    save(path, spec)
                    data = read_reference(image_records()[key])
                else:
                    spec = load(check_path(case, key))
                    validate_observations(case, spec, cells)
                    if (
                        spec.get("reference_image") != key
                        or spec.get("machine") != load(entries[key]["check"])["machine"]
                        or spec.get("movie") != "../" + inside(case["movie"]).name
                    ):
                        raise ValueError("Extended golden profile, machine or movie differs")
                    recorded = reference[(key, case["id"])]
                    if recorded != golden_record(case, key, None) | {"nvram_sha256": recorded["nvram_sha256"]}:
                        raise ValueError("Extended golden differs from original capture provenance")
                    if variant is None:
                        data = (ROOT / "build/images" / (key + ".bin")).read_bytes()
                        if sha(data) != image_records()[key]["sha256"]:
                            raise ValueError("Extended preservation image is not verified")
                    else:
                        artifact = variant["artifacts"][key]
                        data = inside(artifact["path"], ROOT / "build").read_bytes()
                        if len(data) != artifact["size"] or sha(data) != artifact["sha256"]:
                            raise ValueError("Extended relocated image differs from build evidence")
                label = (
                    key
                    + "-"
                    + case["id"]
                    + "-"
                    + ("original" if original else "normal" if variant is None else variant["id"])
                )
                image = ROOT / "build/runtime/extended/images" / (label + ".bin")
                atomic(image, bus_image(entries[key], data))
                log = ROOT / "build/runtime/extended/logs" / (label + ".log")
                movie_args = ["golden" if original else "check", path, "--rom", image, "--mame", mame]
                seed = snapshots[(key, case["seed"])] if case.get("seed") else None
                run_movie(movie_args, log, nvram=seed)
                output = read_nvram(movie_args) if case.get("save_nvram") else None
                if output is not None:
                    snapshots[(key, case["id"])] = output
                if original:
                    validate_observations(case, load(check_path(case, key)), cells)
                    results.append(golden_record(case, key, output))
                else:
                    expected_nvram = reference[(key, case["id"])]["nvram_sha256"]
                    if (sha(output) if output is not None else None) != expected_nvram:
                        raise ValueError("Source-built cartridge SRAM differs from the original writer")
                    results.append(
                        {
                            "profile": key,
                            "case": case["id"],
                            "variant": None if variant is None else variant["id"],
                            "passed": True,
                            "image_sha256": sha(image.read_bytes()),
                            "log": log.relative_to(ROOT / "build").as_posix(),
                            "log_sha256": sha(log.read_bytes()),
                            "seed_sha256": sha(seed) if seed is not None else None,
                            "nvram_sha256": expected_nvram,
                        }
                    )
                print("[OK] Extended original-input route: " + label, flush=True)
                save(inside(destination), {"complete": False, "source_sha256": source, "results": results})
    if source_fingerprint() != source or (not original and signature() != before):
        raise ValueError("Extended source or contract changed during verification")
    save(
        inside(destination),
        {
            "complete": True,
            "source_sha256": source,
            "method": "verified-original-controller-input",
            "scenario_sha256": signature() if not original else None,
            "manifest_sha256": sha((ROOT / "build/relocated/manifest.json").read_bytes()) if matrix else None,
            "results": results,
        },
    )
    return 0


def audit(matrix):
    contract, cases = definitions()
    originals = original_records(cases)
    tables = symbol_tables()
    for case in cases:
        for key in case["profiles"]:
            owner = profiles()[key].get("compose", [key])[0]
            spec = load(check_path(case, key))
            validate_observations(case, spec, cell_addresses(contract, case, tables[owner]))
            recorded = originals[(key, case["id"])]
            if recorded != golden_record(case, key, None) | {"nvram_sha256": recorded["nvram_sha256"]}:
                raise ValueError("Extended original capture identity changed")
    report = load(EVIDENCE)
    variant = matrix_variant(matrix)
    expected = {(key, case["id"], revision) for case in cases for key in case["profiles"] for revision in (None, "g0")}
    rows = report.get("results", [])
    if (
        report.get("complete") is not True
        or report.get("source_sha256") != source_fingerprint()
        or report.get("scenario_sha256") != signature()
        or report.get("manifest_sha256") != sha((ROOT / "build/relocated/manifest.json").read_bytes())
    ):
        raise ValueError("Extended runtime evidence is stale or incomplete")
    if (
        len(rows) != len(expected)
        or {(row.get("profile"), row.get("case"), row.get("variant")) for row in rows} != expected
        or any(row.get("passed") is not True for row in rows)
    ):
        raise ValueError("Extended runtime omitted or duplicated a required route")
    by_case = {case["id"]: case for case in cases}
    entries = {row["profile"]: row for row in scenarios()[1]}
    for row in rows:
        key, case = row["profile"], by_case[row["case"]]
        log = inside(row["log"], ROOT / "build")
        count = len(case["cells"]) * len(checkpoints(case))
        if (
            sha(log.read_bytes()) != row["log_sha256"]
            or "[OK] " not in log.read_text()
            or str(count) + " cell(s) match the original" not in log.read_text()
        ):
            raise ValueError("Extended runtime log lacks its complete original comparison")
        payload = (
            inside(variant["artifacts"][key]["path"], ROOT / "build")
            if row["variant"]
            else ROOT / "build/images" / (key + ".bin")
        )
        if row["image_sha256"] != sha(bus_image(entries[key], payload.read_bytes())):
            raise ValueError("Extended runtime is bound to a different image")
        recorded = originals[(key, case["id"])]
        seed = originals[(key, case["seed"])]["nvram_sha256"] if case.get("seed") else None
        if row.get("seed_sha256") != seed or row.get("nvram_sha256") != recorded["nvram_sha256"]:
            raise ValueError("Extended runtime SRAM chain differs from its own original-input writer")
    print("[OK] Complete extended original-input runtime product: " + str(len(rows)) + " cases")

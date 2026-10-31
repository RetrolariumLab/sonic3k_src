"""Build and independently verify the complete bounded relocation matrix."""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

from scripts.build.project import (
    ROOT,
    atomic,
    image_records,
    inside,
    load,
    profiles,
    sha,
    source_fingerprint,
    source_names,
)
from scripts.build.pipeline import build_selected
from scripts.validation.cohorts import collect_file, render, table_slot
from scripts.validation.lockon import check_fixed
from scripts.validation.symbols import parse_symbols

DEST = ROOT / "build/relocated"


def encoded(value):
    return (json.dumps(value, sort_keys=True, separators=(",", ":")) + "\n").encode()


def digest(value):
    return hashlib.sha256(encoded(value)).hexdigest()


def derive(policy):
    names = source_names()
    # Discover all returns independently of the configured list. New executable
    # source cannot silently disappear from the probe when modules are split.
    discovered = []
    for name in names:
        text = (ROOT / name).read_text(encoding="utf-8")
        if re.search(r"\b(?:rts|rte)\b|; End of function", text, re.I):
            data = collect_file(name, text)
            if data["returns"] or data["procedures"]:
                discovered.append(data)
    if {d["path"] for d in discovered} != set(policy["code_sources"]):
        raise ValueError("Relocation code-source registry is incomplete or stale")
    documents = sorted(discovered, key=lambda d: d["path"])
    points = [dict(point, path=document["path"]) for document in documents for point in document["points"]]
    if not points or policy["groups"] < 1 or policy["groups"] > len(points):
        raise ValueError("Invalid relocation partition")
    return {"documents": documents, "points": points, "groups": policy["groups"], "policy_sha256": digest(policy)}


def selected(plan, group):
    return [p for i, p in enumerate(plan["points"]) if i % plan["groups"] == group]


def check_coverage(plan, manifest, accepted):
    if manifest.get("complete") is not True or manifest.get("plan_sha256") != digest(plan):
        raise ValueError("Relocation coverage is incomplete or differs from source")
    variants = manifest.get("variants", [])
    if [v.get("group") for v in variants] != list(range(plan["groups"])):
        raise ValueError("Relocation matrix has missing, duplicated or reordered groups")
    ids = [v.get("id") for v in variants]
    if len(set(ids)) != len(ids) or any(not isinstance(i, str) or not i for i in ids):
        raise ValueError("Invalid relocation variant identities")
    for variant in variants:
        expected = [p["id"] for p in selected(plan, variant["group"])]
        if variant.get("insertions") != expected:
            raise ValueError("Relocation matrix omits or duplicates a physical cohort")
        if set(variant.get("artifacts", {})) != set(accepted):
            raise ValueError("Relocation artifacts do not cover every profile")


def fixed_names(profile):
    names = set()
    for region in load("config/reconstruction/fixed_regions.json")["regions"]:
        if "profiles" in region and profile not in region["profiles"]:
            continue
        for field in ("owner", "symbol", "base_symbol", "end_symbol", "tail_aligned_start", "tail_allocation"):
            if field in region:
                names.add(region[field])
    if profile == "sk":
        names.update(r["external"] for r in load("config/reconstruction/lockon_abi.json")["exports"])
    return names


def rendered_fingerprint(policy, plan, group, names, widenings):
    anchors = {
        engine.get("startup_source", profiles()[key]["entry"]): engine["startup_label"]
        for key, engine in policy["engines"].items()
    }
    chosen = selected(plan, group)
    digestor = hashlib.sha256()
    for name in sorted(
        set(names)
        | {
            "assets/manifest.json",
            "config/revision_profiles.json",
            "config/toolchain.json",
            "config/audio_driver_payloads.json",
        }
    ):
        payload = (ROOT / name).read_bytes()
        if name.endswith((".s", ".inc", ".asm")):
            text = render(payload.decode("utf-8"), [p for p in chosen if p["path"] == name], anchors.get(name))
            lines = text.splitlines(keepends=True)
            for change in [w for w in widenings if w["path"] == name]:
                index = change["line"] - 1
                if not 0 <= index < len(lines) or lines[index].strip() != change["before"]:
                    raise ValueError("Widening does not bind to rendered source")
                expected = re.sub(r"\b(bra|bsr)\.s\b", r"\1.w", change["before"], flags=re.I)
                if expected == change["before"] or expected != change["after"] or table_slot(lines, index):
                    raise ValueError("Unpermitted timing or indexed-slot change")
                lines[index] = lines[index].replace(change["before"], change["after"])
            payload = "".join(lines).encode()
        digestor.update(name.encode() + b"\0" + payload + b"\0")
    if any(w["path"] not in names for w in widenings):
        raise ValueError("Unknown widened source")
    return digestor.hexdigest()


def check_bank_storage(symbols, original, relocated):
    starts = {
        name: value
        for name, value in symbols.items()
        if re.fullmatch(r"Snd_Bank[0-9]+_Start", name) or name == "SndBank"
    }
    if "Snd_Bank1_Start" not in starts:
        raise ValueError("Missing bank storage anchor")
    first = starts["Snd_Bank1_Start"]
    for name, value in starts.items():
        if name != "Snd_Bank1_Start" and value % 32768:
            raise ValueError("Unaligned Z80 ROM bank origin: " + name)
        if not first <= value < len(original):
            raise ValueError("Z80 bank storage leaves its preserved container")
    if original[first:] != relocated[first:]:
        raise ValueError("Relocation changed fixed music/sample bank storage")


def checked_code_aliases(policy, profile, symbols, declared):
    records = policy.get("code_entry_aliases", [])
    names = [row["alias"] for row in records]
    if len(names) != len(set(names)):
        raise ValueError("Duplicate code-entry alias")
    result = {}
    for row in records:
        if (
            row.get("kind") != "data-end-code-alias"
            or not row.get("reason")
            or not set(row["profiles"]) <= set(policy["engines"])
        ):
            raise ValueError("Invalid code-entry alias contract")
        if profile not in row["profiles"]:
            continue
        alias, target = row["alias"], row["target"]
        if (
            alias == target
            or target not in declared
            or alias not in symbols
            or target not in symbols
            or symbols[alias] != symbols[target]
        ):
            raise ValueError("Code-entry alias differs from its independently discovered target")
        result[alias] = symbols[alias]
    return result


def baseline(policy, plan):
    result = {}
    documents = {d["path"]: d for d in plan["documents"]}
    for key, engine in policy["engines"].items():
        image = (ROOT / "build/images" / (key + ".bin")).read_bytes()
        expected = image_records()[key]
        if len(image) != expected["size"] or sha(image) != expected["sha256"]:
            raise ValueError("Preservation image has changed: " + key)
        symbols = parse_symbols(
            (ROOT / "build/objects" / key / "main.lst").read_text(encoding="utf-8", errors="replace")
        )
        declared = {n for p in engine["sources"] for n in documents[p]["code_labels"]}
        declared.update(checked_code_aliases(policy, key, symbols, declared))
        entries = {n: symbols[n] for n in sorted(declared) if n in symbols and 0x200 <= symbols[n] < 0x200000}
        if not entries or engine["startup_label"] not in entries:
            raise ValueError("Missing independently assembled code entries for " + key)
        result[key] = {"symbols": symbols, "entries": entries, "moved": set(), "image": image}
    return result


def prune_source(work, names):
    """Discard only obsolete AS inputs beneath the checked generated-source root."""
    allowed = set(names)
    work = work.resolve()
    for path in work.rglob("*"):
        if path.suffix not in (".s", ".inc"):
            continue
        if path.is_symlink() or not path.resolve().is_relative_to(work):
            raise ValueError("Generated source escapes its work directory")
        if path.is_file() and path.relative_to(work).as_posix() not in allowed:
            path.unlink()


def prepare_source(policy, plan, group, names):
    work = inside("work/source", DEST)
    prune_source(work, names)
    anchors = {
        engine.get("startup_source", profiles()[key]["entry"]): engine["startup_label"]
        for key, engine in policy["engines"].items()
    }
    chosen = selected(plan, group)
    for name in names:
        text = (ROOT / name).read_text(encoding="utf-8")
        transformed = render(text, [p for p in chosen if p["path"] == name], anchors.get(name))
        path = inside(name, work)
        atomic(path, transformed.encode())
    return work


def widen_failures(work, folder, policy):
    changes = []
    for key in policy["engines"]:
        log = folder / "objects" / key / "assembler.log"
        if not log.is_file():
            continue
        text = log.read_text(encoding="utf-8", errors="replace")
        errors = re.findall(r"> > > ([^\r\n()]+)\((\d+)\).*error #(\d+):", text)
        if not errors:
            continue
        if any(code != "1370" for _, _, code in errors):
            raise ValueError("Relocation has a non-range assembler failure: " + str(log))
        for name, number, _ in errors:
            path = inside(name.strip(), work)
            lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
            index = int(number) - 1
            old = lines[index]
            match = re.search(r"\b(bra|bsr)\.s\b", old, re.I)
            if not match or match[0].lower() not in policy["neutral_widening"]:
                raise ValueError(
                    "Relocation exceeds an inseparable/ranged operand; use a finer partition: " + old.strip()
                )
            if table_slot(lines, index):
                raise ValueError("An indexed branch slot cannot grow")
            lines[index] = re.sub(r"\b(bra|bsr)\.s\b", r"\1.w", old, flags=re.I)
            atomic(path, "".join(lines).encode())
            changes.append(
                {"path": name.strip(), "line": int(number), "before": old.strip(), "after": lines[index].strip()}
            )
    if not changes:
        raise ValueError("Assembler failed without a permitted timing-neutral widening")
    return changes


def symbol_evidence(policy, base, key, listing):
    symbols = parse_symbols(listing.read_text(encoding="utf-8", errors="replace"))
    check_fixed(load("config/reconstruction/fixed_regions.json"), symbols, key)
    if key == "sk":
        for row in load("config/reconstruction/lockon_abi.json")["exports"]:
            name = row["external"]
            if symbols[name] != base[key]["symbols"][name]:
                raise ValueError("Relocation moved a fixed second-cartridge export: " + name)
    entries = base[key]["entries"]
    if any(n not in symbols for n in entries):
        raise ValueError("A relocated code entry disappeared")
    checked_code_aliases(policy, key, symbols, set(entries))
    after = {n: symbols[n] for n in entries}
    if any(v & 1 or not 0x200 <= v < 0x200000 for v in after.values()):
        raise ValueError("A 68000 code entry became odd")
    base[key]["moved"].update(n for n in entries if entries[n] != after[n])
    return {
        "profile": key,
        "before": entries,
        "after": after,
        "fixed_regions_checked": True,
        "external_exports_checked": 675 if key == "sk" else 0,
        "fixed": {name: symbols[name] for name in sorted(fixed_names(key))},
    }


def verify_manifest(path="build/relocated/manifest.json"):
    policy = load("config/reconstruction/relocation.json")
    plan = derive(policy)
    manifest = load(path)
    binding = load("build/source_binding.json")
    if (
        manifest.get("source_sha256") != source_fingerprint()
        or binding.get("source_sha256") != source_fingerprint()
        or not binding.get("byte_identity_checked")
    ):
        raise ValueError("Relocation or preservation source evidence is stale")
    check_coverage(plan, manifest, profiles())
    base = baseline(policy, plan)
    names = source_names()
    for variant in manifest["variants"]:
        if variant.get("rendered_source_sha256") != rendered_fingerprint(
            policy, plan, variant["group"], names, variant["widenings"]
        ):
            raise ValueError("Relocation render or widening evidence differs from source")
        for key, artifact in variant["artifacts"].items():
            expected_path = "relocated/variants/g" + str(variant["group"]) + "/images/" + key + ".bin"
            if artifact["path"] != expected_path or artifact["size"] != image_records()[key]["size"]:
                raise ValueError("Unexpected relocation artifact location or size")
            image = inside(artifact["path"], ROOT / "build")
            data = image.read_bytes()
            if len(data) != artifact["size"] or sha(data) != artifact["sha256"]:
                raise ValueError("Relocation artifact hash/size mismatch")
            if key in base:
                check_bank_storage(base[key]["symbols"], base[key]["image"], data)
        for key, record in variant["evidence"].items():
            proof_path = inside(record["path"], ROOT / "build")
            payload = proof_path.read_bytes()
            if sha(payload) != record["sha256"]:
                raise ValueError("Relocation symbol evidence hash mismatch")
            proof = json.loads(payload)
            if (
                proof["profile"] != key
                or proof["before"] != base[key]["entries"]
                or set(proof["after"]) != set(proof["before"])
            ):
                raise ValueError("Relocation symbol coverage differs from independent entries")
            checked_code_aliases(policy, key, proof["after"], set(base[key]["entries"]))
            if any(value & 1 or not 0x200 <= value < 0x200000 for value in proof["after"].values()):
                raise ValueError("Odd relocated code address")
            if set(proof["fixed"]) != fixed_names(key):
                raise ValueError("Incomplete fixed-interface symbol evidence")
            check_fixed(load("config/reconstruction/fixed_regions.json"), proof["fixed"], key)
            if key == "sk" and any(proof["fixed"][n] != base[key]["symbols"][n] for n in fixed_names(key)):
                raise ValueError("Changed external-cartridge interface")
            base[key]["moved"].update(n for n in proof["before"] if proof["before"][n] != proof["after"][n])
        if set(variant.get("evidence", {})) != set(policy["engines"]):
            raise ValueError("Relocation lacks regional symbol evidence")
        for key, composition in policy["composites"].items():
            read = lambda name: inside(variant["artifacts"][name]["path"], ROOT / "build").read_bytes()
            fixed = (ROOT / "build/images" / (composition["fixed"] + ".bin")).read_bytes()
            if read(key) != read(composition["relocated"]) + fixed:
                raise ValueError("Composite relocation changed the attached cartridge ABI")
    for key, record in base.items():
        if record["moved"] != set(record["entries"]):
            raise ValueError(
                "Unmoved 68000 code entries: " + key + " " + str(sorted(set(record["entries"]) - record["moved"]))
            )
    return manifest


def build():
    binding = load("build/source_binding.json")
    if (
        binding.get("source_sha256") != source_fingerprint()
        or not binding.get("byte_identity_checked")
        or set(binding["profiles"]) != set(profiles())
    ):
        raise ValueError("Run make verify-all before relocation")
    policy = load("config/reconstruction/relocation.json")
    plan = derive(policy)
    base = baseline(policy, plan)
    DEST.mkdir(parents=True, exist_ok=True)
    (DEST / "manifest.json").unlink(missing_ok=True)
    atomic(DEST / "coverage.json", encoded(plan))
    names = source_names()
    variants = []
    for group in range(plan["groups"]):
        folder = inside("variants/g" + str(group), DEST)
        work = prepare_source(policy, plan, group, names)
        widenings = []
        for attempt in range(10):
            try:
                images = build_selected(list(policy["engines"]), source_root=work, output_root=folder / "images")
                break
            except RuntimeError:
                widenings.extend(widen_failures(work, folder, policy))
        else:
            raise ValueError("Neutral branch widening did not converge")
        evidence = {}
        for key in policy["engines"]:
            proof = symbol_evidence(policy, base, key, folder / "objects" / key / "main.lst")
            proof_path = folder / "symbols" / (key + ".json")
            payload = encoded(proof)
            atomic(proof_path, payload)
            evidence[key] = {"path": proof_path.relative_to(ROOT / "build").as_posix(), "sha256": sha(payload)}
        for key, composition in policy["composites"].items():
            path = folder / "images" / (key + ".bin")
            atomic(
                path,
                images[composition["relocated"]].read_bytes()
                + (ROOT / "build/images" / (composition["fixed"] + ".bin")).read_bytes(),
            )
            images[key] = path
        artifacts = {
            key: {
                "path": path.relative_to(ROOT / "build").as_posix(),
                "size": path.stat().st_size,
                "sha256": sha(path.read_bytes()),
            }
            for key, path in images.items()
        }
        variants.append(
            {
                "id": "g" + str(group),
                "group": group,
                "insertions": [p["id"] for p in selected(plan, group)],
                "rendered_source_sha256": source_fingerprint(work),
                "widenings": widenings,
                "artifacts": artifacts,
                "evidence": evidence,
            }
        )
        atomic(
            DEST / "progress.json",
            encoded({"complete": False, "groups_built": len(variants), "groups": plan["groups"]}),
        )
        # Listings and object containers are reproducible scratch. Keep compact
        # symbol evidence and logs, rather than many gigabytes of listings.
        for key in policy["engines"]:
            for name in ("main.lst", "main.p", "linked.bin"):
                disposable = folder / "objects" / key / name
                if not disposable.resolve().is_relative_to(DEST.resolve()):
                    raise ValueError("Disposable output escaped relocation root")
                disposable.unlink(missing_ok=True)
        print("[OK] Relocation group " + str(group + 1) + "/" + str(plan["groups"]), flush=True)
    manifest = {
        "schema_version": 1,
        "complete": True,
        "source_sha256": source_fingerprint(),
        "plan_sha256": digest(plan),
        "variants": variants,
    }
    check_coverage(plan, manifest, profiles())
    atomic(DEST / "manifest.json", encoded(manifest))
    verify_manifest()
    atomic(DEST / "progress.json", encoded({"complete": True, "groups": plan["groups"], "groups_built": len(variants)}))
    print("[OK] Complete relocation matrix and code movement verified", flush=True)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("build", "check", "inventory"))
    args = parser.parse_args(argv)
    if args.command == "build":
        build()
    elif args.command == "check":
        result = verify_manifest()
        atomic(
            DEST / "progress.json",
            encoded({"complete": True, "groups": len(result["variants"]), "groups_built": len(result["variants"])}),
        )
        print("[OK] Relocation evidence: " + str(len(result["variants"])) + " complete variants")
    else:
        plan = derive(load("config/reconstruction/relocation.json"))
        atomic(DEST / "coverage.json", encoded(plan))
        print("[OK] Derived " + str(len(plan["points"])) + " physical cohorts")
    return 0

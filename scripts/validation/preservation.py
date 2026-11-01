"""Compare current normal entries and procedure boundaries with the accepted baseline."""

from collections import Counter
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

from scripts.build.project import ROOT, atomic, image_records, load, read_reference, source_fingerprint
from scripts.build.relocation import baseline, derive
from scripts.validation.cohorts import collect_file
from scripts.validation.symbols import parse_declaration_symbols
from scripts.validation.label_renames import REGISTRY, profile_maps, validate_registry

EXPORT = """
from pathlib import Path
from collections import Counter
import json
from scripts.build.project import load,source_fingerprint
from scripts.build.relocation import baseline,derive
policy=load('config/reconstruction/relocation.json')
plan=derive(policy)
normal=baseline(policy,plan)
documents={row['path']:row for row in plan['documents']}
procedures={}
for key,engine in policy['engines'].items():
 counts=Counter((p['name'],p['terminal'],p['exact_start']) for path in engine['sources'] for p in documents[path]['procedures'])
 procedures[key]=[{'name':name,'terminal':terminal,'exact_start':exact,'count':count} for (name,terminal,exact),count in sorted(counts.items())]
report={'symbols':{key:row['symbols'] for key,row in normal.items()},'source_sha256':source_fingerprint(),'entries':{key:row['entries'] for key,row in normal.items()},'procedures':procedures}
Path('build/preservation-export.json').write_text(json.dumps(report,indent=2))
"""


def compare_entries(expected, actual, renames=None):
    mapped = {}
    for name, address in expected.items():
        current = (renames or {}).get(name, name)
        if current in mapped:
            raise ValueError("Registered historical entry names collide")
        mapped[current] = address
    expected = mapped
    if expected != actual:
        missing, extra = sorted(set(expected) - set(actual)), sorted(set(actual) - set(expected))
        moved = sorted(name for name in set(expected) & set(actual) if expected[name] != actual[name])
        raise ValueError(
            "Historical code entry changed: missing="
            + str(missing[:5])
            + " extra="
            + str(extra[:5])
            + " moved="
            + str(moved[:5])
        )
    return len(actual)


def compare_procedures(expected, actual, renames=None):
    mapped, origins = Counter(), {}
    for (name, terminal, exact_start), count in expected.items():
        current = (renames or {}).get(name, name)
        key = current, terminal, exact_start
        if key in origins and origins[key] != name:
            raise ValueError("Registered historical procedures collide")
        origins[key] = name
        mapped[key] += count
    expected = mapped
    if expected != actual:
        raise ValueError(
            "Historical procedure boundaries changed: missing="
            + str(expected - actual)
            + " extra="
            + str(actual - expected)
        )
    return sum(actual.values())


def origin_document(commit, path):
    # Origin ranges use physical source lines; preserve leading blank lines.
    text = subprocess.check_output(["git", "show", commit + ":" + path], cwd=ROOT).decode()
    return collect_file(path, text)


def _git(*arguments, cwd=ROOT):
    return subprocess.check_output(["git", *arguments], cwd=cwd).decode().strip()


def historical_build(revision):
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Historical preservation baseline must be a full commit identity")
    head = _git("rev-parse", "HEAD")
    if revision == head:
        raise ValueError("Current source cannot be its own historical preservation baseline")
    subprocess.run(["git", "merge-base", "--is-ancestor", revision, head], cwd=ROOT, check=True)
    folder = (ROOT / "build/provenance/source-1-baseline").resolve()
    if not folder.is_relative_to((ROOT / "build").resolve()):
        raise ValueError("Historical checkout leaves ignored build storage")
    if folder.exists():
        if _git("rev-parse", "HEAD", cwd=folder) != revision or _git("status", "--porcelain", cwd=folder):
            raise ValueError("Cached historical checkout is changed or belongs to another baseline")
    else:
        folder.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(["git", "worktree", "add", "--detach", str(folder), revision], cwd=ROOT, check=True)
    manifest = json.loads((folder / "assets/manifest.json").read_text())
    current_images = image_records()
    for image in manifest["images"]:
        if image != current_images[image["id"]]:
            raise ValueError("Historical preservation profile input contract changed")
        destination = (folder / image["file"]).resolve()
        if not destination.is_relative_to(folder / "data"):
            raise ValueError("Historical private input leaves its ignored data root")
        atomic(destination, read_reference(image))
    log = ROOT / "build/provenance/source-1-baseline-build.log"
    with log.open("wb") as output:
        subprocess.run(["make", "split", "verify-all"], cwd=folder, stdout=output, stderr=subprocess.STDOUT, check=True)
        # Import and execute the historical checkout's own source discovery code.
        subprocess.run([sys.executable, "-c", EXPORT], cwd=folder, stdout=output, stderr=subprocess.STDOUT, check=True)
    if _git("status", "--porcelain", cwd=folder):
        raise ValueError("Historical preservation check modified tracked source")
    report = json.loads((folder / "build/preservation-export.json").read_text())
    report["symbols"] = {
        key: parse_declaration_symbols((folder / "build/objects" / key / "main.lst").read_text(errors="replace"))
        for key in report["entries"]
    }
    report["baseline_commit"] = revision
    return report


def check():
    layout = load("config/reconstruction/source_layout.json")
    reference = historical_build(layout["baseline_commit"])
    binding = load("build/source_binding.json")
    if not binding["byte_identity_checked"] or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Current normal preservation assembly binding is stale")
    policy = load("config/reconstruction/relocation.json")
    plan = derive(policy)
    normal = baseline(policy, plan)
    documents = {row["path"]: row for row in plan["documents"]}
    added = {(row["path"], item["name"]) for row in layout["files"] for item in row.get("added_annotations", [])}
    registry = validate_registry()
    mappings = profile_maps(registry)
    result = {}
    for profile, engine in policy["engines"].items():
        count = compare_entries(reference["entries"][profile], normal[profile]["entries"], mappings.get(profile))
        expected = Counter(
            {(p["name"], p["terminal"], p["exact_start"]): p["count"] for p in reference["procedures"][profile]}
        )
        actual = Counter(
            (p["name"], p["terminal"], p["exact_start"])
            for path in engine["sources"]
            for p in documents[path]["procedures"]
            if (path, p["name"]) not in added
        )
        procedures = compare_procedures(expected, actual, mappings.get(profile))
        result[profile] = {
            "exact_entry_count": count,
            "original_procedure_count": procedures,
            "registered_label_mappings": len(mappings.get(profile, {})),
        }
    cache = {}
    for row in layout["files"]:
        for annotation in row.get("added_annotations", []):
            origin = row["origin"]
            key = origin["commit"], origin["path"]
            if key not in cache:
                cache[key] = origin_document(*key)
            absorbed = [
                point["after"]
                for point in cache[key]["points"]
                if annotation["origin_first_line"] <= point["after"] <= annotation["origin_end_line"]
            ]
            if absorbed:
                raise ValueError("Added procedure annotation absorbs an existing independent return boundary")
    from scripts.authoring.formats_workflow import tooling_fingerprint

    report = {
        "schema_version": 1,
        "complete": True,
        "baseline_commit": reference["baseline_commit"],
        "baseline_source_sha256": reference["source_sha256"],
        "historical_symbols": reference["symbols"],
        "label_registry": REGISTRY,
        "label_registry_sha256": hashlib.sha256((ROOT / REGISTRY).read_bytes()).hexdigest(),
        "historical_names_compared_through_registered_profile_maps": True,
        "tooling_sha256": tooling_fingerprint(),
        "source_sha256": source_fingerprint(),
        "profiles": result,
        "additional_annotations": len(added),
        "no_original_probe_boundaries_absorbed": True,
    }
    atomic(ROOT / "build/provenance/preservation-comparison.json", (json.dumps(report, indent=2) + "\n").encode())
    print("[OK] Historical normal entries and procedure boundaries preserved for every base profile")
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.parse_args(argv)
    check()
    return 0

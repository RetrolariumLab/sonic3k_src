"""Check palette span coverage and actual AS bytes; encode complete source owners."""

import hashlib
from pathlib import Path
import re

from scripts.authoring import palette_scripts, source_fragments
from scripts.authoring.palette_content import PaletteCatalog
from scripts.build.project import ROOT, atomic, image_records, load, profiles, source_fingerprint, source_names
from scripts.validation.data_macros import body_statement, definition_blocks
from scripts.validation.source_layout import parse_include_ranges
from scripts.validation.symbols import parse_symbols

CATALOG = "config/authoring/palette_formats.json"
LABEL = re.compile("(" + palette_scripts.NAME + r"):\s*")


def discover(text):
    """Find complete scoped declaration groups without crossing unrelated data."""
    rows = text.splitlines(keepends=True)
    hidden = {i for name, first, last, body in definition_blocks(text) for i in range(first, last)}
    scope, active, result = "", None, []
    for index, line in enumerate(rows):
        if index in hidden:
            continue
        number = index + 1
        raw = line.split(";", 1)[0].strip()
        label = LABEL.match(raw)
        if label and not label[1].startswith("."):
            if active:
                result.append(active)
                active = None
            scope = label[1]
        body = body_statement(line)
        parts = body.split(None, 1)
        op = parts[0].lower() if parts else ""
        if op == "palscriptptr" and active is None:
            if not scope:
                raise ValueError("Palette initializer has no global source scope")
            active = {"scope": scope, "first_line": number, "last_line": number}
        if op.startswith("palscript") and op not in palette_scripts.OPS:
            raise ValueError("Unknown palette declaration operation")
        if op in palette_scripts.OPS and active is None:
            raise ValueError("Palette operation has no owning initializer group")
        if active:
            if not op:
                continue
            if (
                op in palette_scripts.OPS
                or op == "even"
                or op == "dc.w"
                and len(parts) == 2
                and parts[1].strip() == "0"
            ):
                active["last_line"] = number
            else:
                result.append(active)
                active = None
    if active:
        result.append(active)
    for item in result:
        item["text"] = "".join(rows[item["first_line"] - 1 : item["last_line"]])
    return result


def dependencies(records, scope):
    current, names, labels = scope, set(), set()
    for record in records:
        if "label" in record:
            name = palette_scripts.qualify(record["label"], current)
            labels.add(name)
            if not record["label"].startswith("."):
                current = record["label"]
            continue
        expressions = record.get("args", []) + ([record["ticks"]] if "ticks" in record else [])
        for expression in expressions:
            for term in expression:
                if isinstance(term["value"], str):
                    names.add(palette_scripts.qualify(term["value"], current))
    return (names - labels) | {"Normal_palette"}


def catalog():
    if load("config/authoring/data_formats.json").get("palette_catalog") != CATALOG:
        raise ValueError("Main format registry does not own the palette source catalog")
    assets = {row["path"]: row for row in load("assets/manifest.json")["assets"]}
    result = PaletteCatalog(load(CATALOG), profiles(), assets)
    actual = {}
    for name in source_names():
        text = (ROOT / name).read_bytes().decode()
        for group in discover(text):
            key = (name, group["scope"])
            if key in actual:
                raise ValueError("Palette initializer scope is duplicated in one source file")
            actual[key] = group
    rows = {(row["path"], row["scope"]): row for row in result.rows()}
    if set(rows) != set(actual):
        raise ValueError("Palette span catalog omits or duplicates live source declarations")
    for key, row in rows.items():
        group = actual[key]
        if any(row[name] != group[name] for name in ("first_line", "last_line")):
            raise ValueError("Palette physical source range is stale")
        records = result.source(row, group["text"])
        if dependencies(records, row["scope"]) != set(row["external_symbols"]):
            raise ValueError("Palette source dependencies differ from their exact symbol contract")
    return result, actual


def _header_entries(records, scope, labels):
    current, pending, result = scope, [], set()
    for record in records:
        if "label" in record:
            name = palette_scripts.qualify(record["label"], current)
            pending.append(name)
            if not record["label"].startswith("."):
                current = record["label"]
        else:
            if record["op"] == "palscripthdr":
                if not pending:
                    raise ValueError("Palette header must have a named graph entry")
                result.update(labels[name] for name in pending)
            pending = []
    return result


def bind(result, sources):
    binding = load("build/source_binding.json")
    if not binding.get("byte_identity_checked") or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Palette content needs a current byte-exact assembly binding")
    selected = {(row["path"], row["scope"]): row for row in result.rows()}
    paths = {row["path"] for row in selected.values()}
    locations = {key: [] for key in selected}
    images = image_records()
    for profile, spec in profiles().items():
        if "compose" in spec:
            continue
        listing = (ROOT / "build/objects" / profile / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        if hashlib.sha256(image).hexdigest() != images[spec["image"]]["sha256"]:
            raise ValueError("Palette proof image differs from the preservation image")
        intervals = parse_include_ranges(listing, paths)
        by_path = {}
        for interval in intervals:
            if interval["path"] in by_path:
                raise ValueError("Palette source owner is included twice in one profile")
            by_path[interval["path"]] = interval
        headers, controls = set(), []
        for key, row in selected.items():
            if row["path"] not in by_path:
                continue
            if row["scope"] not in symbols:
                raise ValueError("Palette source scope is absent from active AS symbols")
            base = symbols[row["scope"]]
            external = {name: symbols[name] for name in row["external_symbols"] if name in symbols}
            files = {name: (ROOT / name).read_bytes() for name in row["file_frames"]}
            text = sources[key]["text"]
            packet = result.decode(*key, profile, text, base=base, symbols=external, files=files)
            records = result.source(row, text)
            data, labels, models = palette_scripts.assemble(
                records, scope=row["scope"], base=base, symbols=external, files=files
            )
            interval = by_path[row["path"]]
            if (
                not interval["start"] <= base < base + len(data) <= interval["end"]
                or image[base : base + len(data)] != data
            ):
                raise ValueError("Palette semantic bytes leave their source owner or differ from AS output")
            if any(symbols.get(name) != value for name, value in labels.items()):
                raise ValueError("Palette local label differs from independently assembled AS symbols")
            headers.update(_header_entries(records, row["scope"], labels))
            controls.extend(model for model in models if model.get("op") in ("initializer", "next-header"))
            locations[key].append(
                {"profile": profile, "start": base, "end": base + len(data), "assembly_base": base, "symbols": external}
            )
        for model in controls:
            if model.get("header", model.get("target")) not in headers:
                raise ValueError("Palette transition leaves registered header entries in this profile")
            if model["op"] == "initializer" and model["data"] != model["header"] + 4:
                raise ValueError("Palette initializer does not enter the first frame after its header")
    for key, entries in locations.items():
        for item in list(entries):
            if item["profile"] in ("s3-us", "sk"):
                shift = 0x200000 if item["profile"] == "s3-us" else 0
                # Header longwords keep the component's assembly addresses. Only
                # their physical position in the concatenated image changes.
                entries.append(
                    item
                    | {
                        "profile": "s3k",
                        "component": item["profile"],
                        "start": item["start"] + shift,
                        "end": item["end"] + shift,
                    }
                )
        if {item["profile"] for item in entries} != set(selected[key]["profiles"]):
            raise ValueError("Palette applicability differs from active source includes")
    return locations


def prepare(workspace):
    result, sources = catalog()
    locations = bind(result, sources)
    patches, evidence = [], []
    for row in result.rows():
        key = (row["path"], row["scope"])
        text = sources[key]["text"]
        rendered = None
        for item in locations[key]:
            files = {name: (workspace / name).read_bytes() for name in row["file_frames"]}
            component = item.get("component")
            packet = result.decode(
                *key,
                item["profile"],
                text,
                base=item["assembly_base"],
                symbols=item["symbols"],
                files=files,
                component=component,
            )
            source, encoded = result.encode(
                packet,
                target_profile=item["profile"],
                original=text,
                base=item["assembly_base"],
                symbols=item["symbols"],
                files=files,
                component=component,
            )
            if rendered is not None and source != rendered:
                raise ValueError("Palette source encoding differs between preservation views")
            rendered = source
        patches.append(
            {
                "path": row["path"],
                "owner": "palette:" + row["scope"],
                "first_line": row["first_line"],
                "last_line": row["last_line"],
                "original_sha256": hashlib.sha256(text.encode()).hexdigest(),
                "source": rendered,
            }
        )
        evidence.append(
            {
                "path": row["path"],
                "scope": row["scope"],
                "bindings": locations[key],
                "initializers": sum(model.get("op") == "initializer" for model in packet["models"]),
                "byte_exact": True,
            }
        )
    return patches, evidence


def roundtrip(workspace):
    patches, evidence = prepare(workspace)
    originals = {name: (ROOT / name).read_bytes() for name in {item["path"] for item in patches}}
    composed = source_fragments.write(workspace, originals, patches)
    report = {
        "complete": True,
        "groups": len(evidence),
        "initializers": sum(item["initializers"] for item in evidence),
        "source_files": composed["source_files"],
        "artifacts": evidence,
        "outputs": composed["outputs"],
        "fragments": composed["fragments"],
    }
    print(
        "[OK] Palette scripts: "
        + str(len(evidence))
        + " groups in "
        + str(composed["source_files"])
        + " encoded source files",
        flush=True,
    )
    return report

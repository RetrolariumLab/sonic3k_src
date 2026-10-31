"""Bind registered raw graphs to actual AS labels and preservation image bytes."""

import hashlib
import re

from scripts.authoring import raw_source
from scripts.authoring.raw_content import RawCatalog
from scripts.build.project import ROOT, image_records, load, profiles, source_fingerprint, source_names
from scripts.validation.source_layout import parse_include_ranges
from scripts.validation.symbols import parse_symbols

CATALOG = "config/authoring/raw_formats.json"


def dependencies(records, scope):
    current, names, labels = scope, set(), set()

    def visit(item):
        if "symbol" in item:
            names.add(raw_source.qualify(item["symbol"], current))
        elif "value" in item:
            visit(item["value"])
        elif "left" in item:
            visit(item["left"])
            visit(item["right"])

    for record in records:
        if "label" in record:
            labels.add(raw_source.qualify(record["label"], current))
            if not record["label"].startswith("."):
                current = record["label"]
        else:
            for expression in record.get("bytes", []):
                visit(expression)
    return names - labels


def indexed_references(text):
    """Literal indexed frame reads, excluding comments, quotes and register bases."""
    result = set()
    for line in text.splitlines():
        code = line.split(";", 1)[0]
        match = re.fullmatch(
            r"\s*(?:[A-Za-z_]\w*:\s*)?move\.b\s+([A-Za-z_]\w*)\(pc,d[0-7]\.w\),\s*mapping_frame\(a[0-6]\)\s*",
            code,
            re.I,
        )
        if match:
            result.add(match[1])
    return result


def catalog():
    if load("config/authoring/data_formats.json").get("raw_catalog") != CATALOG:
        raise ValueError("Main format registry does not own the raw source catalog")
    result = RawCatalog(load(CATALOG), profiles())
    sources, names, declared = {}, set(source_names()), set()
    for item in result.consumer_sources:
        if (
            item["path"] not in names
            or hashlib.sha256((ROOT / item["path"]).read_bytes()).hexdigest() != item["sha256"]
        ):
            raise ValueError("Raw consumer source changed; its ABI selection needs review")
    for row in result.rows():
        if row["path"] not in names:
            raise ValueError("Raw span has no preservation source owner")
        lines = (ROOT / row["path"]).read_bytes().decode().splitlines(keepends=True)
        if row["last_line"] > len(lines):
            raise ValueError("Raw source range exceeds its owner")
        text = "".join(lines[row["first_line"] - 1 : row["last_line"]])
        records = result.source(row, text)
        if dependencies(records, row["scope"]) != set(row["external_symbols"]):
            raise ValueError("Raw dependencies differ from their exact symbol contract")
        sources[(row["path"], row["symbol"])] = text
        current = row["scope"]
        for record in records:
            if "label" in record:
                declared.add((row["path"], raw_source.qualify(record["label"], current)))
                if not record["label"].startswith("."):
                    current = record["label"]
    # Every explicitly named raw stream is registered, including custom readers.
    named = {
        (name, match[1])
        for name in names
        for match in re.finditer(r"^((?:AniRaw|RawAni)_[A-Za-z_0-9]+):", (ROOT / name).read_text(), re.M)
    }
    indexed = set().union(*(indexed_references((ROOT / name).read_text()) for name in names))
    if not indexed <= {symbol for name, symbol in declared}:
        raise ValueError("Raw catalog omits a direct indexed sprite-frame source")
    if not named <= declared:
        raise ValueError("Raw catalog omits an explicitly named source stream")
    return result, sources


def bind(result, sources):
    binding = load("build/source_binding.json")
    if not binding.get("byte_identity_checked") or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Raw content needs a current byte-exact assembly binding")
    rows = {(r["path"], r["symbol"]): r for r in result.rows()}
    locations = {key: [] for key in rows}
    paths = {row["path"] for row in rows.values()}
    images = image_records()
    for profile, spec in profiles().items():
        if "compose" in spec:
            continue
        listing = (ROOT / "build/objects" / profile / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        if hashlib.sha256(image).hexdigest() != images[spec["image"]]["sha256"]:
            raise ValueError("Raw proof image differs from its preservation image")
        intervals = parse_include_ranges(listing, paths)
        by_path = {}
        for interval in intervals:
            if interval["path"] in by_path:
                raise ValueError("Raw source owner is included twice in one profile")
            by_path[interval["path"]] = interval
        for key, row in rows.items():
            if row["path"] not in by_path:
                continue
            if row["symbol"] not in symbols:
                raise ValueError("Raw source entry is absent from active AS symbols")
            base = symbols[row["symbol"]]
            external = {n: symbols[n] for n in row["external_symbols"] if n in symbols}
            packet = result.decode(*key, profile, sources[key], base=base, symbols=external)
            raw, labels, padding = raw_source.assemble(
                result.source(row, sources[key]), scope=row["scope"], base=base, external=external
            )
            interval = by_path[row["path"]]
            if (
                not interval["start"] <= base < base + len(raw) <= interval["end"]
                or image[base : base + len(raw)] != raw
                or any(symbols.get(n) != v for n, v in labels.items())
            ):
                raise ValueError("Raw semantic bytes or labels differ from independently assembled output")
            locations[key].append(
                {"profile": profile, "start": base, "end": base + len(raw), "assembly_base": base, "symbols": external}
            )
    for key, entries in locations.items():
        for item in list(entries):
            if item["profile"] in ("s3-us", "sk"):
                shift = 0x200000 if item["profile"] == "s3-us" else 0
                entries.append(
                    item
                    | {
                        "profile": "s3k",
                        "component": item["profile"],
                        "start": item["start"] + shift,
                        "end": item["end"] + shift,
                    }
                )
        if {item["profile"] for item in entries} != set(rows[key]["profiles"]):
            raise ValueError("Raw applicability differs from active source includes")
    return locations


def prepare(workspace):
    result, sources = catalog()
    locations = bind(result, sources)
    patches, evidence = [], []
    for row in result.rows():
        key = (row["path"], row["symbol"])
        original, rendered = sources[key], None
        for item in locations[key]:
            context = {"base": item["assembly_base"], "symbols": item["symbols"], "component": item.get("component")}
            packet = result.decode(*key, item["profile"], original, **context)
            source, encoded = result.encode(packet, target_profile=item["profile"], original=original, **context)
            if rendered is not None and source != rendered:
                raise ValueError("Raw source rendering differs between preservation views")
            rendered = source
        patches.append(
            {
                "path": row["path"],
                "owner": "raw:" + row["symbol"],
                "first_line": row["first_line"],
                "last_line": row["last_line"],
                "original_sha256": hashlib.sha256(original.encode()).hexdigest(),
                "source": rendered,
            }
        )
        evidence.append(
            {
                "path": row["path"],
                "symbol": row["symbol"],
                "bindings": locations[key],
                "entries": row["entries"],
                "members": row.get("members", [row["symbol"]]),
                "stored_markers": row.get("stored_markers", []),
                "nodes": len(packet["model"]["nodes"]),
                "byte_exact": True,
            }
        )
    return patches, evidence

"""Verify alternate palette consumers and prepare their source fragments."""

import hashlib, re
from scripts.authoring import palette_indexed_source as source
from scripts.authoring.palette_indexed_content import IndexedPaletteCatalog
from scripts.build.project import ROOT, image_records, load, profiles, source_fingerprint, source_names
from scripts.validation.source_layout import parse_include_ranges
from scripts.validation.symbols import parse_symbols

CATALOG = "config/authoring/palette_indexed_formats.json"


def calls(text):
    return {
        i + 1
        for i, line in enumerate(text.splitlines())
        if re.match(
            r"\s*(?:jsr|jmp|bsr(?:\.[bswl])?|bra(?:\.[bswl])?)\s+.*\bRun_PalRotationScript2\b",
            line.split(";", 1)[0],
            re.I,
        )
    }


def copies_state(text, symbol):
    lines = [line.split(";", 1)[0] for line in text.splitlines()]
    for i, line in enumerate(lines):
        if (
            re.search(r"\blea\s+", line)
            and re.search(r"\b" + re.escape(symbol) + r"\b", line)
            and line.rstrip().endswith(",a1")
        ):
            following = "\n".join(lines[i + 1 : i + 7])
            if (
                "Palette_rotation_data" in following
                and len(re.findall(r"move\.l\s+\(a1\)\+,\(a2\)\+", following, re.I)) == 2
            ):
                return True
    return False


def catalog():
    if load("config/authoring/data_formats.json").get("indexed_palette_catalog") != CATALOG:
        raise ValueError("Main registry does not own the indexed palette catalog")
    result = IndexedPaletteCatalog(load(CATALOG), profiles())
    names = set(source_names())
    for item in result.consumer_sources:
        if (
            item["path"] not in names
            or hashlib.sha256((ROOT / item["path"]).read_bytes()).hexdigest() != item["sha256"]
        ):
            raise ValueError("Indexed palette consumer source changed; review its ABI context")
    actual = {(name, line) for name in names for line in calls((ROOT / name).read_text())}
    expected = {(item["path"], item["call_line"]) for item in result.consumer_bindings}
    if actual != expected:
        raise ValueError("Indexed palette caller catalog omits or invents an active source call")
    sources = {}
    texts = {name: (ROOT / name).read_text() for name in names}
    for row in result.rows():
        if row["path"] not in names:
            raise ValueError("Indexed palette group has no source owner")
        lines = (ROOT / row["path"]).read_bytes().decode().splitlines(keepends=True)
        if row["last_line"] > len(lines):
            raise ValueError("Indexed palette range exceeds its owner")
        text = "".join(lines[row["first_line"] - 1 : row["last_line"]])
        result.source(row, text)
        found = any(copies_state(t, row["symbol"]) for t in texts.values())
        if found != row["ram_state_copy"]:
            raise ValueError("Indexed palette RAM-state overlay contract differs from actual source copies")
        sources[(row["path"], row["symbol"])] = text
    return result, sources


def destination_offset(normal, address, color_count):
    if any(type(v) is not int for v in (normal, address, color_count)) or not 0 < color_count <= 64:
        raise ValueError("Indexed palette destination context needs bounded integer addresses")
    start = address - normal
    if start % 2 or not 0 <= start < start + 2 * color_count <= 128:
        raise ValueError("Indexed palette copy leaves normal CRAM staging capacity")
    return start // 2


def bind(result, sources):
    binding = load("build/source_binding.json")
    if not binding.get("byte_identity_checked") or binding["source_sha256"] != source_fingerprint():
        raise ValueError("Indexed palette proof requires current byte-exact source assembly")
    rows = {(r["path"], r["symbol"]): r for r in result.rows()}
    locations = {key: [] for key in rows}
    images = image_records()
    paths = {r["path"] for r in rows.values()} | {c["path"] for c in result.consumer_bindings}
    for profile, spec in profiles().items():
        if "compose" in spec:
            continue
        listing = (ROOT / "build/objects" / profile / "main.lst").read_text(errors="replace")
        symbols = parse_symbols(listing)
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        if hashlib.sha256(image).hexdigest() != images[spec["image"]]["sha256"]:
            raise ValueError("Indexed palette proof image differs from preservation reference")
        by_path = {}
        for interval in parse_include_ranges(listing, paths):
            if interval["path"] in by_path:
                raise ValueError("Indexed palette source is included twice in one profile")
            by_path[interval["path"]] = interval
        for key, row in rows.items():
            if row["path"] not in by_path:
                continue
            if row["symbol"] not in symbols:
                raise ValueError("Indexed palette entry is absent from active AS symbols")
            base = symbols[row["symbol"]]
            packet = result.decode(*key, profile, sources[key], base=base)
            raw, labels, padding = source.assemble(
                result.source(row, sources[key]), scope=row["scope"], base=base, external={}
            )
            interval = by_path[row["path"]]
            if (
                not interval["start"] <= base < base + len(raw) <= interval["end"]
                or image[base : base + len(raw)] != raw
                or any(symbols.get(n) != v for n, v in labels.items())
            ):
                raise ValueError("Indexed palette semantic bytes or labels differ from independent AS output")
            destinations = []
            for call in result.consumer_bindings:
                if call["header"] != row["symbol"]:
                    continue
                if call["path"] not in by_path:
                    raise ValueError("Indexed palette caller is inactive while its source is active")
                for target in call["destinations"]:
                    if target["symbol"] not in symbols or "Normal_palette" not in symbols:
                        raise ValueError("Palette destination is absent from AS memory symbols")
                    address = symbols[target["symbol"]] + target["byte_offset"]
                    offset = destination_offset(symbols["Normal_palette"], address, row["color_count"])
                    destinations.append(
                        {
                            "path": call["path"],
                            "line": call["call_line"],
                            "color_offset": offset,
                            "colors": row["color_count"],
                        }
                    )
            locations[key].append(
                {
                    "profile": profile,
                    "start": base,
                    "end": base + len(raw),
                    "assembly_base": base,
                    "destinations": destinations,
                    "state_overlay": packet["state_overlay"],
                }
            )
    for key, items in locations.items():
        for item in list(items):
            if item["profile"] in ("s3-us", "sk"):
                shift = 0x200000 if item["profile"] == "s3-us" else 0
                items.append(
                    item
                    | {
                        "profile": "s3k",
                        "component": item["profile"],
                        "start": item["start"] + shift,
                        "end": item["end"] + shift,
                    }
                )
        if {item["profile"] for item in items} != set(rows[key]["profiles"]):
            raise ValueError("Indexed palette applicability differs from active source includes")
    return locations


def prepare(workspace):
    result, sources = catalog()
    locations = bind(result, sources)
    patches = []
    evidence = []
    for row in result.rows():
        key = (row["path"], row["symbol"])
        text = sources[key]
        rendered = None
        for item in locations[key]:
            context = {"base": item["assembly_base"], "component": item.get("component")}
            packet = result.decode(*key, item["profile"], text, **context)
            encoded, data = result.encode(packet, target_profile=item["profile"], original=text, **context)
            if rendered is not None and encoded != rendered:
                raise ValueError("Indexed palette source differs between preservation views")
            rendered = encoded
        patches.append(
            {
                "path": row["path"],
                "owner": "indexed-palette:" + row["symbol"],
                "first_line": row["first_line"],
                "last_line": row["last_line"],
                "original_sha256": hashlib.sha256(text.encode()).hexdigest(),
                "source": rendered,
            }
        )
        evidence.append(
            {
                "path": row["path"],
                "symbol": row["symbol"],
                "bindings": locations[key],
                "steps": row["step_count"],
                "frames": row["palette_count"],
                "byte_exact": True,
            }
        )
    return patches, evidence

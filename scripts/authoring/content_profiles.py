"""Bind every registered resource to active AS includes and actual address spaces."""

import re

from scripts.authoring.driver_inputs import virtual_tables
from scripts.build.project import ROOT, load, source_fingerprint
from scripts.validation.as_object import decode

RECORD = re.compile(r"^(?:\((\d+)\))?\s*\d+/\s*([0-9A-Fa-f]+)\s*:\s*(.*)$")
INCLUDE = re.compile(r'\bbinclude\s+"data/([^"]+)"', re.I)


def check(catalog, source_assets):
    binding = load("build/source_binding.json")
    if binding["source_sha256"] != source_fingerprint() or not binding["byte_identity_checked"]:
        raise ValueError("Content profile binding requires a current verified build")
    recipe = load("config/audio_driver_payloads.json")
    derived = {row["path"] for row in recipe["assets"]}
    seeds = {row["asset"] for row in recipe["containers"].values()}
    locations = {name: [] for name in source_assets}
    for profile in ("s3-us", "s3-eu", "s3-jp", "sk"):
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        objects = (ROOT / "build/objects" / profile / "main.p").read_bytes()
        records, entries, creator = decode(objects)
        spaces = {
            "z80-driver-code": (0, virtual_tables(records, base=0, limit=0x1300)),
            "z80-driver-tables": (0x1300, virtual_tables(records)),
        }
        listing = ROOT / "build/objects" / profile / "main.lst"
        for line in listing.read_text(errors="replace").splitlines():
            record = RECORD.match(line)
            if not record:
                continue
            include = INCLUDE.search(record[3])
            if not include:
                continue
            name, address = include[1], int(record[2], 16)
            if name not in locations or name in seeds:
                raise ValueError("AS includes an unowned input or an extraction-only seed")
            space = (
                "z80-driver-tables"
                if name in derived
                else "z80-driver-code"
                if name == "Sound/DAC/deltas.bin"
                else "cartridge-rom"
            )
            data = (ROOT / "data" / name).read_bytes()
            catalog._original(name, data)
            if space == "cartridge-rom":
                actual = image[address : address + len(data)]
            else:
                base, container = spaces[space]
                if address < base:
                    raise ValueError("Content include leaves its virtual AS segment")
                actual = container[address - base : address - base + len(data)]
            if actual != data:
                raise ValueError("AS resource bytes differ from their claimed storage space")
            locations[name].append({"profile": profile, "space": space, "start": address, "end": address + len(data)})
    for name, rows in locations.items():
        for row in list(rows):
            if row["profile"] not in ("sk", "s3-us"):
                continue
            shift = 0x200000 if row["profile"] == "s3-us" and row["space"] == "cartridge-rom" else 0
            rows.append(
                row
                | {
                    "profile": "s3k",
                    "component": row["profile"],
                    "start": row["start"] + shift,
                    "end": row["end"] + shift,
                }
            )
    if {name for name, rows in locations.items() if not rows} != seeds:
        raise ValueError("Content profile evidence omits a registered resource")
    for row in catalog.rows():
        if row["path"] in seeds:
            expected = (
                {"sk", "s3k"}
                if row["path"] == recipe["containers"]["sk"]["asset"]
                else {"s3-us", "s3-eu", "s3-jp", "s3k"}
            )
            spaces = {"z80-driver-tables"}
        else:
            actual = locations[row["path"]]
            expected, spaces = {x["profile"] for x in actual}, {x["space"] for x in actual}
        if set(row["profiles"]) != expected or set(row["address_spaces"]) != spaces:
            raise ValueError("Content registry applicability differs from active AS evidence: " + row["path"])
    return locations

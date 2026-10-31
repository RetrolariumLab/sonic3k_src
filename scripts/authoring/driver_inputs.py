"""Prove ROM extraction seeds are rebuilt by current virtual AS table output."""

import hashlib

from scripts.authoring import kosinski
from scripts.build.project import ROOT, load, source_fingerprint
from scripts.validation.as_object import decode


def virtual_tables(records, *, base=0x1300, limit=0x1C00):
    starts = [index for index, row in enumerate(records) if row.cpu == 0x51 and row.address == base]
    if len(starts) != 1:
        raise ValueError("Driver table context is missing or duplicated")
    cursor, output = starts[0], bytearray()
    previous = None
    while cursor < len(records) and records[cursor].cpu == 0x51:
        record = records[cursor]
        if (
            record.address != base + len(output)
            or record.end > limit
            or (previous is not None and record.ordinal != previous + 1)
        ):
            raise ValueError("Virtual driver table records overlap, have holes or exceed RAM")
        output.extend(record.data)
        previous = record.ordinal
        cursor += 1
    if not output:
        raise ValueError("Virtual driver table output is empty")
    return bytes(output)


def check():
    binding = load("build/source_binding.json")
    if binding["source_sha256"] != source_fingerprint() or not binding["byte_identity_checked"]:
        raise ValueError("Driver input round trip requires a current verified build")
    manifest, recipe = load("assets/manifest.json"), load("config/audio_driver_payloads.json")
    assets = {row["path"]: row for row in manifest["assets"]}
    images = {row["id"]: row for row in manifest["images"]}
    outputs, report = {}, {}
    for profile in ("s3-us", "s3-eu", "s3-jp", "sk"):
        owner = "sk" if profile == "sk" else "s3-us"
        contract = recipe["containers"][owner]
        asset = assets[contract["asset"]]
        image = (ROOT / "build/images" / (profile + ".bin")).read_bytes()
        if len(image) != images[profile]["size"] or hashlib.sha256(image).hexdigest() != images[profile]["sha256"]:
            raise ValueError("Driver input proof image differs from its preservation profile")
        packed = (ROOT / "build/objects" / profile / "main.p").read_bytes()
        records, entries, creator = decode(packed)
        tables = virtual_tables(records)
        original = (ROOT / manifest["output"] / asset["path"]).read_bytes()
        if len(original) != asset["size"] or hashlib.sha1(original).hexdigest() != asset["sha1"]:
            raise ValueError("Driver extraction seed differs from its original identity")
        decoded = (
            kosinski.decode(original, max_output=recipe["address_limit"] - recipe["virtual_base"])
            if contract["codec"] == "kos"
            else original
        )
        if (
            tables != decoded
            or len(tables) != contract["decoded_size"]
            or hashlib.sha256(tables).hexdigest() != contract["decoded_sha256"]
        ):
            raise ValueError("Source-built virtual tables differ from the complete input seed")
        rebuilt = image[asset["offset"] : asset["offset"] + asset["size"]]
        if rebuilt != original:
            raise ValueError("Fresh source-built physical container differs from its extraction seed")
        if asset["path"] in outputs and outputs[asset["path"]] != rebuilt:
            raise ValueError("Regional source-built driver containers disagree")
        outputs[asset["path"]] = rebuilt
        report[profile] = {
            "asset": asset["path"],
            "size": len(rebuilt),
            "decoded_size": len(tables),
            "object_sha256": hashlib.sha256(packed).hexdigest(),
            "source_rebuilt_byte_exact": True,
        }
    if set(outputs) != {row["asset"] for row in recipe["containers"].values()}:
        raise ValueError("Driver input proof omits an extraction seed")
    return outputs, report

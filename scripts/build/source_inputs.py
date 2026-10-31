"""Stage hash-bound private resources without exposing another source tree."""

from pathlib import Path, PurePosixPath
import re

from scripts.build.project import ROOT, atomic, inside, sha


def stage(work, rows, *, source_root, output="data"):
    work, source_root = work.resolve(), source_root.resolve()
    if not work.is_relative_to((ROOT / "build").resolve()) or work == (ROOT / "build").resolve():
        raise ValueError("Generated inputs must stay below the ignored build root")
    if output != "data" or not isinstance(rows, list) or not rows or len(rows) > 65536:
        raise ValueError("Invalid private input root or resource registry")
    prepared = {}
    for row in rows:
        name = row.get("path")
        if (
            not isinstance(name, str)
            or not name
            or "\\" in name
            or ":" in name
            or PurePosixPath(name).is_absolute()
            or ".." in PurePosixPath(name).parts
            or PurePosixPath(name).as_posix() != name
            or name in prepared
        ):
            raise ValueError("Duplicate or escaping private input path")
        if type(row.get("size")) is not int or not 0 < row["size"] <= 0x400000:
            raise ValueError("Private input allocation is outside its bounded cartridge")
        identities = {key: row[key] for key in ("sha1", "sha256") if key in row}
        if not identities or any(
            not isinstance(value, str) or not re.fullmatch(r"[0-9a-f]{" + str(40 if key == "sha1" else 64) + "}", value)
            for key, value in identities.items()
        ):
            raise ValueError("Private input lacks a valid immutable identity")
        source = inside(name, source_root)
        target = inside(output + "/" + name, work)
        if source.stat().st_size != row["size"]:
            raise ValueError("Private input size differs from its extraction: " + name)
        data = source.read_bytes()
        if any(sha(data, key) != expected for key, expected in identities.items()):
            raise ValueError("Private input hash differs from its extraction: " + name)
        prepared[name] = (target, data)
    # Validate all paths, capacities and identities before writing the first input.
    for target, data in prepared.values():
        if not target.is_file() or target.read_bytes() != data:
            atomic(target, data)
    return len(prepared)

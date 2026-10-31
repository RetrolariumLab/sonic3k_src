"""Check semantic source basenames and processor-oriented suffixes."""

from pathlib import PurePosixPath
import re


def check_source_names(rows, tracked=None):
    paths = [row["path"] for row in rows]
    if not paths or len(paths) != len({path.casefold() for path in paths}):
        raise ValueError("Source names are empty or collide on a case-insensitive host")
    if tracked is not None and {name for name in tracked if name.startswith("src/")} != set(paths):
        raise ValueError("Every file below src/ must have a canonical source owner")
    for row in rows:
        value = row["path"]
        path = PurePosixPath(value)
        expected = (
            ".inc" if row["role"] in {"memory", "definitions"} else ".asm" if row["role"] == "z80-driver" else ".s"
        )
        if (
            not value.startswith("src/")
            or path.as_posix() != value
            or path.suffix != expected
            or not re.fullmatch(r"[a-z][a-z0-9]*(?:_[a-z0-9]+)*", path.stem)
            or len(path.stem.split("_")) > 3
            or any(not re.fullmatch(r"[a-z0-9]+(?:_[a-z0-9]+)*", part) for part in path.parts[:-1])
            or re.fullmatch(r"(?:loc|sub|code|routine|word|byte|off)_[0-9a-f]+", path.stem)
        ):
            raise ValueError("Noncanonical source filename or processor suffix: " + value)
    return len(paths)

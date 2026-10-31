"""Keep processor-specific .asm files inside the pinned public AS style checks."""

import argparse
import json
from pathlib import Path
import tempfile

from scripts.build.project import ROOT, inside, rltool_command, run, source_names


def check_style(root, names, fix=False):
    sources = []
    for name in names:
        if Path(name).suffix != ".asm":
            continue
        path = inside(name, root)
        if not name.startswith("src/") or not path.is_file():
            raise ValueError("AS style inputs must be owned source files below src/")
        sources.append((name, path))
    base = root / "build/style"
    if base.resolve() != base.absolute() or not base.resolve().is_relative_to(root.resolve()):
        raise ValueError("AS style staging escaped its exact build root")
    if not sources:
        print("[OK] Supplemental AS style: no .asm inputs")
        return
    base.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="asl-", dir=base) as folder:
        stage = Path(folder)
        pairs = []
        for name, source in sources:
            destination = stage / "sources" / Path(name).with_suffix(".s")
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(source.read_bytes())
            pairs.append((source, destination))
        config = {
            "schema": "retrolarium.lint",
            "schema_version": 1,
            "assembly": {"dialect": "asl", "paths": ["sources"]},
            "code": False,
        }
        (stage / "config").mkdir()
        (stage / "config/lint.json").write_text(json.dumps(config) + "\n", encoding="utf-8")
        arguments = [*rltool_command(), "lint", "--project", str(stage), "--only", "assembly"]
        if fix:
            arguments.append("--fix")
        run(arguments)
        if fix:
            for source, destination in pairs:
                data = destination.read_bytes()
                if source.read_bytes() != data:
                    source.write_bytes(data)
    print("[OK] Supplemental AS style: " + str(len(sources)) + " .asm inputs checked through disposable .s copies")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fix", action="store_true")
    args = parser.parse_args(argv)
    check_style(ROOT, source_names(), args.fix)
    return 0

"""Apply the pinned public text contract to controller movie files."""

import argparse
import json
from pathlib import Path
import tempfile

from scripts.build.project import ROOT, inside, rltool_command, run
from scripts.validation.documentation import tracked


def check_style(root, names, fix=False):
    sources = []
    for name in names:
        if Path(name).suffix != ".rlmovie":
            continue
        path = inside(name, root)
        if (
            not name.startswith("scenarios/")
            or not path.is_relative_to((root / "scenarios").resolve())
            or not path.is_file()
        ):
            raise ValueError("Movie style inputs must stay inside the owned scenario tree")
        sources.append((name, path))
    base = root / "build/style"
    if base.resolve() != base.absolute() or not base.resolve().is_relative_to(root.resolve()):
        raise ValueError("Movie style staging escaped its exact build root")
    if not sources:
        print("[OK] Supplemental movie text style: no controller movies")
        return
    base.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="movie-", dir=base) as folder:
        stage, pairs = Path(folder), []
        for name, source in sources:
            destination = stage / Path(name).with_suffix(".txt")
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(source.read_bytes())
            pairs.append((source, destination))
        config = {
            "schema": "retrolarium.lint",
            "schema_version": 1,
            "assembly": {"dialect": "asl", "paths": []},
            "code": False,
            "text": {"json": "valid"},
        }
        (stage / "config").mkdir()
        (stage / "config/lint.json").write_bytes((json.dumps(config) + "\n").encode())
        args = [*rltool_command(), "lint", "--project", str(stage), "--only", "text"]
        if fix:
            args.append("--fix")
        run(args)
        if fix:
            for source, destination in pairs:
                data = destination.read_bytes()
                if source.read_bytes() != data:
                    source.write_bytes(data)
    print(
        "[OK] Supplemental movie text style: "
        + str(len(sources))
        + " controller movies checked through disposable .txt copies"
    )


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fix", action="store_true")
    args = parser.parse_args(argv)
    check_style(ROOT, tracked(ROOT), args.fix)
    return 0

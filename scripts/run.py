"""Stable package launcher: python -m scripts.run <module> [arguments]."""

import importlib
import sys


def main():
    if len(sys.argv) < 2:
        raise SystemExit("Name a module under scripts, such as build.pipeline")
    module = sys.argv[1]
    if not all(part.isidentifier() for part in module.split(".")):
        raise SystemExit("Invalid tool module")
    return importlib.import_module("scripts." + module).main(sys.argv[2:])


if __name__ == "__main__":
    raise SystemExit(main())

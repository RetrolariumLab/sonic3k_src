"""Build the pinned public Core in ignored storage and use its C++ compression CLI."""

import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import tarfile
import tempfile

from scripts.build.project import ROOT, atomic, load, sha

BUILD = ROOT / "build" / "tools" / "core"


def _pin():
    return next(
        row["commit"] for row in load("config/toolchain.json")["dependencies"] if row["name"] == "retrolarium-core"
    )


def _run(arguments, *, cwd=ROOT):
    result = subprocess.run(
        [str(item) for item in arguments], cwd=cwd, capture_output=True, text=True, errors="replace"
    )
    if result.returncode:
        raise ValueError("Core tool failed: " + (result.stderr + result.stdout)[-3000:])
    return result.stdout.strip()


def prepare(source=None):
    """Archive the exact dependency revision; never build in or alter its checkout."""
    source = source or os.environ.get("RETROLARIUM_CORE_SOURCE")
    if not source:
        raise ValueError("Set RETROLARIUM_CORE_SOURCE to the pinned public retrolarium-core checkout")
    source = Path(source).resolve()
    revision = _pin()
    if _run(["git", "rev-parse", revision + "^{commit}"], cwd=source) != revision:
        raise ValueError("The configured Core source does not contain its dependency pin")
    packed = subprocess.check_output(["git", "-C", str(source), "archive", revision])
    archive = tarfile.open(fileobj=io.BytesIO(packed))
    destination = (BUILD / "source").resolve()
    assert destination.is_relative_to(ROOT / "build")
    files = {}
    for member in archive.getmembers():
        path = (destination / member.name).resolve()
        if not path.is_relative_to(destination) or not (member.isfile() or member.isdir()):
            raise ValueError("Core source archive contains an unsupported path or link")
        if member.isfile():
            files[member.name] = archive.extractfile(member).read()
    for name, data in files.items():
        path = destination / name
        if path.is_file() and path.read_bytes() != data:
            raise ValueError("Cached Core source differs from the dependency pin")
    existing = (
        {path.relative_to(destination).as_posix() for path in destination.rglob("*") if path.is_file()}
        if destination.exists()
        else set()
    )
    if existing - set(files):
        raise ValueError("Unexpected files in the cached Core source snapshot")
    for name, data in files.items():
        path = destination / name
        if not path.exists():
            atomic(path, data)
    cmake = shutil.which("cmake")
    if not cmake:
        raise ValueError("CMake 3.21 or later and a C++17 compiler are required for Core")
    output = BUILD / "cmake"
    command = [
        cmake,
        "-S",
        destination,
        "-B",
        output,
        "-DRETROLARIUM_CORE_BUILD_TESTS=OFF",
        "-DBUILD_TESTING=OFF",
        "-DRETROLARIUM_CORE_BUILD_CLI=ON",
    ]
    _run(command)
    _run([cmake, "--build", output, "--config", "Release", "--target", "rlcore", "--parallel", "1"])
    name = "rlcore.exe" if os.name == "nt" else "rlcore"
    candidates = [output / "Release" / name, output / name]
    executable = next((path for path in candidates if path.is_file()), None)
    if executable is None:
        raise ValueError("Core build produced no CLI executable")
    if _run([executable, "version"]) != "0.1.0":
        raise ValueError("Unexpected Core CLI version")
    binary = executable.read_bytes()
    report = {
        "schema_version": 1,
        "dependency_commit": revision,
        "source_archive_sha256": sha(packed),
        "executable": executable.relative_to(ROOT).as_posix(),
        "size": len(binary),
        "sha256": sha(binary),
    }
    atomic(BUILD / "binding.json", (json.dumps(report, indent=2) + "\n").encode())
    return executable


def tool():
    binding = BUILD / "binding.json"
    if not binding.is_file():
        return prepare()
    report = json.loads(binding.read_text())
    if report["dependency_commit"] != _pin():
        raise ValueError("Cached Core binary belongs to another dependency pin")
    path = (ROOT / report["executable"]).resolve()
    if not path.is_relative_to(BUILD.resolve()):
        raise ValueError("Core binary leaves its declared build cache")
    data = path.read_bytes()
    if len(data) != report["size"] or sha(data) != report["sha256"]:
        raise ValueError("Cached Core binary changed after preparation")
    return path


def _bytes(value):
    if not isinstance(value, (bytes, bytearray, memoryview)) or len(value) > 0x400000:
        raise ValueError("Core compression input must be bytes within its bounded allocation")
    return bytes(value)


def _limit(value):
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise ValueError("Compression output capacity must be a nonnegative integer")


def _call(family, operation, data, reference=None):
    executable = tool()
    scratch = ROOT / "build" / "authoring" / "core"
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="codec-", dir=scratch) as folder:
        root = Path(folder).resolve()
        assert root.is_relative_to(scratch.resolve())
        source, output = root / "input.bin", root / "output.bin"
        source.write_bytes(data)
        arguments = [executable, family, operation, source]
        if reference is not None:
            path = root / "reference.bin"
            path.write_bytes(reference)
            arguments.append(path)
        _run([*arguments, output])
        return output.read_bytes()


def decode_nemesis(data, *, max_output=0x100000):
    raw = _bytes(data)
    _limit(max_output)
    if len(raw) < 2:
        raise ValueError("Truncated Nemesis tile count")
    expected = (int.from_bytes(raw[:2], "big") & 0x7FFF) * 32
    if expected > max_output:
        raise ValueError("Nemesis tile count exceeds its declared capacity")
    plain = _call("nemesis", "decompress", raw)
    if len(plain) != expected:
        raise ValueError("Core Nemesis output differs from its tile count")
    return plain


def encode_nemesis(data, reference):
    plain, original = _bytes(data), _bytes(reference)
    if len(decode_nemesis(original)) != len(plain):
        raise ValueError("Nemesis editing must retain the reference tile count")
    packed = _call("nemesis", "compress", plain, original)
    if decode_nemesis(packed) != plain:
        raise ValueError("Core Nemesis encoding failed content equivalence")
    return packed


def encode_preserving(family, data, original, *, max_output=0x100000):
    """Keep an unchanged Nemesis stream, including noncanonical padding."""
    plain, reference = _bytes(data), _bytes(original)
    if family != "nemesis":
        raise ValueError("Only the verified Nemesis dialect is supported by this backend")
    _limit(max_output)
    if len(plain) > max_output:
        raise ValueError("Edited content exceeds its decoded capacity")
    decoded = decode_nemesis(reference, max_output=max_output)
    if decoded == plain:
        return reference
    return encode_nemesis(plain, reference)


def main(argv=None):
    import argparse

    parser = argparse.ArgumentParser(description="Prepare the pinned native Nemesis backend")
    parser.add_argument("command", choices=("prepare", "check"))
    args = parser.parse_args(argv)
    executable = prepare() if args.command == "prepare" else tool()
    print("[OK] Pinned native Core backend: " + executable.relative_to(ROOT).as_posix())
    return 0

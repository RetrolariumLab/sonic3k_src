"""Shared manifest, path and subprocess contracts."""

from pathlib import Path
import hashlib
import json
import os
import subprocess
import shlex

ROOT = Path(__file__).resolve().parents[2]


def load(path):
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def atomic(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_bytes(data)
    temporary.replace(path)


def inside(relative, parent=ROOT):
    path = (parent / relative).resolve()
    if not path.is_relative_to(parent.resolve()) or path == parent.resolve():
        raise ValueError("Path must stay below its declared root: " + str(relative))
    return path


def run(args, cwd=ROOT, log=None):
    result = subprocess.run([str(a) for a in args], cwd=cwd, capture_output=True, text=True, errors="replace")
    if log:
        atomic(log, (result.stdout + result.stderr).encode("utf-8"))
    if result.returncode:
        raise RuntimeError(
            "Command failed: " + " ".join(map(str, args)) + "\n" + (result.stdout + result.stderr)[-5000:]
        )
    return result.stdout.strip()


def rltool_command():
    command = os.environ.get("RLTOOL", "rltool")
    try:
        if Path(command).is_file():
            return [command]
    except OSError:
        pass
    return shlex.split(command)


def rltool(*args):
    return run([*rltool_command(), *args])


def sha(data, algorithm="sha256"):
    return hashlib.new(algorithm, data).hexdigest()


def image_records():
    return {i["id"]: i for i in load("assets/manifest.json")["images"]}


def read_reference(image):
    data = inside(image["file"]).read_bytes()
    for key in ("sha1", "sha256"):
        if sha(data, key) != image[key]:
            raise ValueError("Wrong input hash for " + image["id"] + ": " + key)
    if len(data) != image["size"]:
        raise ValueError("Wrong input size for " + image["id"])
    return data


def profiles():
    spec = load("config/revision_profiles.json")
    values = {p["id"]: p for p in spec["profiles"]}
    if len(values) != len(spec["profiles"]) or spec["default"] not in values:
        raise ValueError("Duplicate or invalid default profile")
    return values


def source_names():
    names = (
        subprocess.check_output(
            ["git", "-C", str(ROOT), "ls-files", "-z", "--cached", "--others", "--exclude-standard"]
        )
        .decode()
        .split("\0")
    )
    return sorted({name for name in names if name.endswith((".s", ".inc", ".asm"))})


def source_fingerprint(source_root=ROOT):
    """Bind AS evidence to current source and its manifest-owned build inputs."""
    listing = (
        subprocess.check_output(["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"], cwd=ROOT)
        .decode()
        .split("\0")
    )
    names = sorted(
        {
            n
            for n in listing
            if n.endswith((".s", ".inc", ".asm"))
            or n
            in (
                "assets/manifest.json",
                "config/revision_profiles.json",
                "config/toolchain.json",
                "config/audio_driver_payloads.json",
            )
        }
    )
    digest = hashlib.sha256()
    for name in names:
        digest.update(name.encode("utf-8") + b"\0")
        digest.update(((source_root if name.endswith((".s", ".inc", ".asm")) else ROOT) / name).read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()

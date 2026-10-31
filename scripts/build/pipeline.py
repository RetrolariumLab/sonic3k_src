"""Build every accepted official image through the manifest-owned pipeline."""

import argparse
import json
import os
from pathlib import Path
import platform
import shutil

from scripts.build.project import ROOT, atomic, image_records, inside, load, profiles, source_fingerprint
from scripts.build.project import read_reference, rltool, run, sha


def fix_header(data):
    if len(data) < 0x200 or len(data) % 2:
        raise ValueError("A Mega Drive image needs a complete header and even size")
    result = bytearray(data)
    result[0x1A4:0x1A8] = (len(result) - 1).to_bytes(4, "big")
    checksum = sum(int.from_bytes(result[i : i + 2], "big") for i in range(0x200, len(result), 2)) & 0xFFFF
    result[0x18E:0x190] = checksum.to_bytes(2, "big")
    return bytes(result)


def first_difference(left, right):
    for offset, (a, b) in enumerate(zip(left, right)):
        if a != b:
            return offset
    return min(len(left), len(right)) if len(left) != len(right) else None


def tools():
    spec = load("config/toolchain.json")
    status = json.loads(rltool("build-tools", "status"))
    if status["release"] != spec["kit_release"]:
        raise ValueError("Retrolarium Kit tool release differs from the pin")
    commands = {}
    host = status["host"]
    for item in spec["components"]:
        path = Path(rltool("build-tools", "path", "megadrive", item["id"]))
        expected = item["hosts"][host]
        install = expected["commands"][item["id"]]
        file = next(f for f in expected["files"] if f["install_path"] == install)
        data = path.read_bytes()
        if len(data) != file["size"] or sha(data) != file["sha256"]:
            raise ValueError("Tool binary differs from pin: " + item["id"])
        commands[item["id"]] = path
    return commands


def import_inputs(folder):
    if not folder.is_dir():
        raise ValueError("ROM folder is missing: " + str(folder))
    images = image_records()
    names = {i["original_name"]: i for i in images.values()}
    copied = set()
    for path in folder.rglob("*"):
        if path.is_file() and path.name in names:
            image = names[path.name]
            data = path.read_bytes()
            if len(data) != image["size"] or sha(data, "sha1") != image["sha1"] or sha(data) != image["sha256"]:
                raise ValueError("Unexpected input bytes: " + path.name)
            atomic(inside(image["file"]), data)
            copied.add(image["id"])
    missing = set(images) - copied
    if missing:
        raise ValueError("ROM folder lacks profiles: " + ", ".join(sorted(missing)))
    print("[OK] Imported verified private images: " + ", ".join(sorted(copied)))


def build_selected(selected, *, source_root=ROOT, output_root=None, verify=False):
    values = profiles()
    images = image_records()
    output_root = output_root or ROOT / "build/images"
    commands = tools()
    built = {}
    visiting = set()

    def one(key):
        if key in built:
            return built[key]
        if key in visiting:
            raise ValueError("Profile composition cycle: " + key)
        visiting.add(key)
        profile = values[key]
        output = output_root / (key + ".bin")
        if "compose" in profile:
            data = b"".join(one(child).read_bytes() for child in profile["compose"])
        else:
            objdir = output_root.parent / "objects" / key
            objdir.mkdir(parents=True, exist_ok=True)
            obj = objdir / "main.p"
            obj.unlink(missing_ok=True)
            args = [
                commands["asl"],
                "-xx",
                "-n",
                "-q",
                "-A",
                "-L",
                "-U",
                "-i",
                str(source_root),
                "-o",
                obj,
                "-olist",
                objdir / "main.lst",
            ]
            if source_root != ROOT:
                args += ["-i", str(ROOT)]
            for name, value in profile["defines"].items():
                args += ["-D", name + "=" + str(value)]
            entry = inside(profile["entry"], source_root)
            if not entry.is_file():
                raise ValueError("Missing source entry: " + str(entry))
            run([*args, entry], cwd=objdir, log=objdir / "assembler.log")
            if not obj.is_file():
                raise RuntimeError("AS produced no object for " + key)
            temporary = objdir / "linked.bin"
            temporary.unlink(missing_ok=True)
            codec = profile["driver_compression"]
            link = [
                commands["p2bin"],
                "-p=FF",
                "-z=0," + codec + ",Size_of_Snd_driver_guess,before",
                "-z=1300," + codec + ",Size_of_Snd_driver2_guess,before",
                obj,
                temporary,
            ]
            run(link, cwd=objdir, log=objdir / "linker.log")
            data = fix_header(temporary.read_bytes())
        atomic(output, data)
        if verify:
            reference = read_reference(images[profile["image"]])
            offset = first_difference(data, reference)
            if offset is not None:
                raise ValueError(
                    key
                    + ": byte difference at "
                    + hex(offset)
                    + " (sizes "
                    + str(len(data))
                    + "/"
                    + str(len(reference))
                    + ")"
                )
            print("[OK] " + key + ": byte identical, " + str(len(data)) + " bytes, SHA-256 " + sha(data), flush=True)
        else:
            print("[OK] Built " + key, flush=True)
        built[key] = output
        visiting.remove(key)
        return output

    for key in selected:
        one(key)
    atomic(
        output_root.parent / "identity.json",
        (
            json.dumps(
                {
                    key: {
                        "file": str(p.relative_to(ROOT)).replace(os.sep, "/"),
                        "sha256": sha(p.read_bytes()),
                        "byte_identical": verify,
                    }
                    for key, p in built.items()
                },
                indent=2,
            )
            + "\n"
        ).encode(),
    )
    atomic(
        output_root.parent / "source_binding.json",
        (
            json.dumps(
                {
                    "source_sha256": source_fingerprint(source_root),
                    "profiles": list(built),
                    "byte_identity_checked": verify,
                },
                indent=2,
            )
            + "\n"
        ).encode(),
    )
    return built


def clean():
    # Research, originals and extracted assets survive ordinary make clean.
    for relative in ("build/images", "build/objects", "build/relocated"):
        path = inside(relative)
        if path.exists():
            shutil.rmtree(path)
    (ROOT / "build/identity.json").unlink(missing_ok=True)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "command",
        choices=("help", "init", "build", "verify", "verify-all", "clean", "verify-toolchain", "check-inputs"),
    )
    parser.add_argument("--profile", default=load("config/revision_profiles.json")["default"])
    parser.add_argument("--rom-root", type=Path)
    args = parser.parse_args(argv)
    if args.command == "help":
        print(
            "Sonic 3 / Sonic & Knuckles preservation source\n"
            "make init ROM_ROOT=<folder>  import the five checked user images\n"
            "make split                  extract manifest-owned private assets\n"
            "make check-assets           verify extracted files\n"
            "make check-inputs           verify private input identities\n"
            "make build PROFILE=s3-us    assemble one profile\n"
            "make verify PROFILE=s3-us   assemble and compare every byte\n"
            "make verify-all             build and compare all five profiles\n"
            "make verify-toolchain       check the pinned Kit tools\n"
            "make test                   run tools/contract tests without ROMs\n"
            "make lint / format          check or normalize the source style\n"
            "make check-lockon           prove all 675 S3 external exports\n"
            "make build-relocated        build the complete procedure matrix\n"
            "make check-relocated        verify coverage and code movement\n"
            "make release-check          run the complete preservation gate\n"
            "make source-2-check         run preservation plus the full 2.0 gate\n"
            "make scaffold-check         validate public structure without ROMs\n"
            "make check-docs             review documentation links and coverage\n"
            "make check-content-zero-edit rebuild all profiles from encoded resources\n"
            "make check-numeric-operands  audit explicit numeric address forms\n"
            "make verify-emulator        prepare the pinned MAME executable\n"
            "make trace                  check preservation attract RAM\n"
            "make trace-relocated        check a prepared relocation matrix\n"
            "make check-driver-audio      verify ROM-owned FM and envelope payloads\n"
            "make audit-private          inspect every reachable Git blob\n"
            "make clean                  remove only disposable build outputs"
        )
        from scripts.build.make_interface import recipes

        print("Public targets: " + ", ".join(sorted(recipes(ROOT))))
    elif args.command == "init":
        if args.rom_root is None:
            parser.error("init needs --rom-root")
        import_inputs(args.rom_root)
    elif args.command == "check-inputs":
        for image in image_records().values():
            read_reference(image)
        print("[OK] All five private input identities")
    elif args.command == "clean":
        clean()
    elif args.command == "verify-toolchain":
        tools()
        print("[OK] Pinned Kit assembler and authentic p2bin")
    else:
        selected = list(profiles()) if args.command == "verify-all" else [args.profile]
        build_selected(selected, verify=args.command.startswith("verify"))
    return 0

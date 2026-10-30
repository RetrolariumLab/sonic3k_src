"""Declarative runtime contracts and cartridge bus wrappers."""

from pathlib import Path
import re

from scripts.build.project import ROOT, image_records, inside, load, profiles


def wrap_empty_upper(data, half):
    if len(data) != half or half <= 0:
        raise ValueError("The empty second-cartridge wrapper needs exactly one base image")
    return data + b"\xff" * half


def bus_image(entry, data):
    image = image_records()[entry["profile"]]
    if len(data) != image["size"]:
        raise ValueError("Runtime input size differs from its preservation profile")
    if entry["cart_mapping"] == "empty-upper":
        return wrap_empty_upper(data, image["size"])
    if entry["cart_mapping"] != "direct":
        raise ValueError("Unknown cartridge mapping")
    return data


def validate_golden(entry, spec, contract, symbols=None):
    if spec.get("schema") != "retrolarium.movie-check" or spec.get("schema_version") != 1:
        raise ValueError("Invalid movie-check schema")
    if spec.get("machine") not in ("genesis", "megadriv", "megadrij"):
        raise ValueError("Unsupported MAME machine")
    if spec.get("reference_image") != entry["profile"]:
        raise ValueError("Golden belongs to another preservation input")
    if set(spec["cells"]) != set(contract["cell_symbols"]):
        raise ValueError("Runtime RAM contract is incomplete")
    for name, size in contract["cell_symbols"].items():
        cell = spec["cells"][name]
        if cell["length"] != size or cell.get("tolerance", 0) != 0:
            raise ValueError("Runtime cell width/tolerance differs from the exact contract")
        if symbols is not None and int(cell["address"], 0) != symbols[name] & 0xFFFFFF:
            raise ValueError("Runtime RAM address differs from the profile's source: " + name)
    expected = spec.get("expected", {})
    if set(expected) != {str(frame) for frame in spec["frames"]}:
        raise ValueError("Golden lacks required checkpoints")
    for values in expected.values():
        if set(values) != set(spec["cells"]):
            raise ValueError("Golden lacks required RAM observations")
        for name, value in values.items():
            if len(value) != contract["cell_symbols"][name] * 2 or not re.fullmatch("[0-9a-fA-F]+", value):
                raise ValueError("Golden has an invalid RAM value")
    demos = [v for v in expected.values() if int(v["Game_mode"], 16) == 8]
    if not demos or not any(
        int(v["Current_zone"], 16) == entry["demo_zone"]
        and int(v["Camera_X_pos"], 16) > 0
        and int(v["Level_frame_counter"], 16) > 0
        for v in demos
    ):
        raise ValueError("Golden did not reach the expected natural gameplay demo")


def scenarios():
    contract = load("config/runtime/scenarios.json")
    entries = contract["scenarios"]
    names = [e["profile"] for e in entries]
    if len(names) != len(set(names)) or set(names) != set(profiles()):
        raise ValueError("Runtime matrix does not cover every accepted profile")
    for entry in entries:
        path = inside(entry["check"])
        spec = load(entry["check"])
        movie = (path.parent / spec["movie"]).resolve()
        if movie != inside(contract["movie"]) or not movie.is_file():
            raise ValueError("Movie path differs from its declared scenario")
        text = movie.read_text(encoding="utf-8")
        if "source mame\n" not in text or "frames " + str(contract["frames"]) + "\n" not in text:
            raise ValueError("Movie source or frame budget differs from the declaration")
        validate_golden(entry, spec, contract)
    return contract, entries

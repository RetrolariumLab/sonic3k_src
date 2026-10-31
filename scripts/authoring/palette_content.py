"""Immutable palette source spans and profile-bound semantic edit packets."""

from copy import deepcopy
import hashlib
from pathlib import PurePosixPath
import re

from scripts.authoring import palette_scripts
from scripts.authoring.assembly_content import digest, _path


class PaletteCatalog:
    def __init__(self, registry, profiles, assets):
        if (
            set(registry) != {"schema_version", "scope", "groups"}
            or registry["schema_version"] != 1
            or registry["scope"] != "preservation-fixed-footprint"
        ):
            raise ValueError("Unknown palette source catalog")
        self._profiles = deepcopy(profiles)
        self._rows, self._assets = {}, {}
        for original in registry["groups"]:
            row = deepcopy(original)
            if set(row) != {
                "path",
                "scope",
                "first_line",
                "last_line",
                "profiles",
                "capacity_bytes",
                "declarations_sha256",
                "external_symbols",
                "file_frames",
            }:
                raise ValueError("Palette group fields differ from the source-span schema")
            _path(row["path"])
            if not isinstance(row["scope"], str) or not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", row["scope"]):
                raise ValueError("Palette scope must be an explicit global source label")
            if (
                any(type(row[k]) is not int for k in ("first_line", "last_line", "capacity_bytes"))
                or not 1 <= row["first_line"] <= row["last_line"]
                or not 0 < row["capacity_bytes"] <= 65536
            ):
                raise ValueError("Palette span has invalid physical or storage bounds")
            if (
                not row["profiles"]
                or len(set(row["profiles"])) != len(row["profiles"])
                or set(row["profiles"]) - set(profiles)
            ):
                raise ValueError("Palette group has invalid product applicability")
            if not re.fullmatch(r"[0-9a-f]{64}", row["declarations_sha256"]):
                raise ValueError("Palette declaration identity is malformed")
            if (
                len(set(row["external_symbols"])) != len(row["external_symbols"])
                or any(
                    not isinstance(n, str) or not re.fullmatch(palette_scripts.NAME, n) for n in row["external_symbols"]
                )
                or "Normal_palette" not in row["external_symbols"]
            ):
                raise ValueError("Palette external symbol contract is invalid")
            if len(set(row["file_frames"])) != len(row["file_frames"]):
                raise ValueError("Palette file context is duplicated")
            for name in row["file_frames"]:
                path = PurePosixPath(name)
                if (
                    not name.startswith("data/")
                    or path.as_posix() != name
                    or ".." in path.parts
                    or name[5:] not in assets
                ):
                    raise ValueError("Palette frame has no manifest-owned storage")
                asset = deepcopy(assets[name[5:]])
                if type(asset["size"]) is not int or not 2 <= asset["size"] <= 128 or asset["size"] % 2:
                    raise ValueError("Palette frame leaves the CRAM color capacity")
                self._assets[name] = asset
            key = (row["path"], row["scope"])
            if key in self._rows:
                raise ValueError("Palette source group is duplicated")
            self._rows[key] = row
        by_path = {}
        for row in self._rows.values():
            by_path.setdefault(row["path"], []).append((row["first_line"], row["last_line"]))
        for spans in by_path.values():
            end = 0
            for first, last in sorted(spans):
                if first <= end:
                    raise ValueError("Palette physical source spans overlap")
                end = last

    def rows(self):
        return [deepcopy(self._rows[key]) for key in sorted(self._rows)]

    def _select(self, path, scope, profile, component):
        row = self._rows.get((path, scope))
        if row is None or profile not in row["profiles"]:
            raise ValueError("Palette source group is unavailable in this profile")
        composition = self._profiles[profile].get("compose")
        if composition:
            if component not in composition or component not in row["profiles"]:
                raise ValueError("Palette composite view needs an applicable component")
        elif component is not None:
            raise ValueError("A base palette profile has no component view")
        return row

    def source(self, row, text):
        records = palette_scripts.parse(text)
        if digest(records) != row["declarations_sha256"]:
            raise ValueError("Palette source differs from its immutable declaration identity")
        files = {r["path"] for r in records if r.get("op") == "palscriptfile"}
        if files != set(row["file_frames"]):
            raise ValueError("Palette declarations differ from their file storage owners")
        return records

    def _context(self, row, base, symbols, files):
        if type(base) is not int or base % 2 or not 0 <= base < 0x400000:
            raise ValueError("Palette source base leaves its aligned cartridge domain")
        if set(symbols) != set(row["external_symbols"]) or any(
            type(v) is not int or not 0 <= v <= 0xFFFFFFFF for v in symbols.values()
        ):
            raise ValueError("Palette context differs from its exact symbol dependencies")
        if set(files) != set(row["file_frames"]):
            raise ValueError("Palette file context omits or adds a dependency")
        for name, data in files.items():
            asset = self._assets[name]
            if (
                not isinstance(data, bytes)
                or len(data) != asset["size"]
                or hashlib.sha1(data).hexdigest() != asset["sha1"]
                or asset.get("sha256")
                and hashlib.sha256(data).hexdigest() != asset["sha256"]
            ):
                raise ValueError("Palette file context differs from its immutable asset identity")
        return digest([row, base, symbols, {name: hashlib.sha256(data).hexdigest() for name, data in files.items()}])

    def decode(self, path, scope, profile, text, *, base, symbols, files, component=None):
        row = self._select(path, scope, profile, component)
        token = self._context(row, base, symbols, files)
        records = self.source(row, text)
        raw, labels, models = palette_scripts.assemble(records, scope=scope, base=base, symbols=symbols, files=files)
        if len(raw) != row["capacity_bytes"]:
            raise ValueError("Palette source differs from its immutable byte allocation")
        return {
            "path": path,
            "scope": scope,
            "profile": profile,
            "component": component,
            "contract": digest([token, profile, component]),
            "models": models,
        }

    def encode(self, packet, *, target_profile, original, base, symbols, files, component=None):
        if set(packet) != {"path", "scope", "profile", "component", "contract", "models"}:
            raise ValueError("Palette model packet has unknown fields")
        row = self._select(packet["path"], packet["scope"], target_profile, component)
        token = self._context(row, base, symbols, files)
        if (
            packet["profile"] != target_profile
            or packet["component"] != component
            or packet["contract"] != digest([token, target_profile, component])
        ):
            raise ValueError("Palette model belongs to another profile, context or declaration contract")
        records = self.source(row, original)
        text, raw = palette_scripts.encode_models(
            records, packet["models"], scope=row["scope"], base=base, symbols=symbols, files=files
        )
        if len(raw) != row["capacity_bytes"]:
            raise ValueError("Palette source edit changes its fixed byte allocation")
        return text, raw

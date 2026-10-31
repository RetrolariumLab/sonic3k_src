"""Immutable preservation allocations and profile checks before workspace writes."""

from copy import deepcopy
import hashlib
import json
from pathlib import Path, PurePosixPath

from scripts.authoring import collision, dac, format_codecs, smps_storage
from scripts.build.project import ROOT, atomic


def _digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def _path(value):
    if not isinstance(value, str) or not value or chr(92) in value or ":" in value:
        raise ValueError("Content path must be a relative POSIX path")
    path = PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts or value != path.as_posix():
        raise ValueError("Content path leaves its allocation root")
    return value


class ContentCatalog:
    def __init__(self, catalog, source_assets, profiles):
        if catalog.get("schema_version") != 1 or catalog.get("scope") != "preservation-fixed-footprint":
            raise ValueError("Unknown content catalog schema or write policy")
        self._assets = deepcopy(source_assets)
        self._rows = {}
        self._profiles = set(profiles)
        for row in catalog["artifacts"]:
            required = {
                "segment",
                "path",
                "codec",
                "compression",
                "parameters",
                "round_trip",
                "capacity",
                "profiles",
                "address_spaces",
            }
            if set(row) != required:
                raise ValueError("Content artifact fields differ from the catalog schema")
            name = _path(row["path"])
            if row["segment"] != name or name in self._rows or name not in self._assets:
                raise ValueError("Missing, duplicated or unknown content storage owner")
            if (
                not row["profiles"]
                or len(set(row["profiles"])) != len(row["profiles"])
                or set(row["profiles"]) - self._profiles
            ):
                raise ValueError("Unknown or duplicated content profile")
            if not row["address_spaces"] or set(row["address_spaces"]) - {
                "cartridge-rom",
                "z80-driver-code",
                "z80-driver-tables",
            }:
                raise ValueError("Unknown content address space")
            capacity = row["capacity"]
            if set(capacity) != {"policy", "storage_owner", "decoded_bytes"}:
                raise ValueError("Unknown content capacity fields")
            expected = (
                "source-owned-input" if row["codec"] == "source-driver-tables" else "preservation-fixed-footprint"
            )
            if capacity["policy"] != expected or capacity["storage_owner"] not in {
                "asset-manifest",
                "driver-payload-recipe",
            }:
                raise ValueError("Unknown content storage-capacity policy")
            limit = capacity["decoded_bytes"]
            if type(limit) is not int or not 0 < limit <= 0x400000:
                raise ValueError("Decoded content capacity exceeds its bounded allocation")
            expected_roundtrip = (
                "source-rebuilt"
                if row["codec"] == "source-driver-tables"
                else "exact"
                if row["compression"] == "none"
                else "original-stream"
            )
            if row["round_trip"] != expected_roundtrip:
                raise ValueError("Round-trip policy differs from the storage contract")
            format_codecs.validate_spec(row)
            asset = self._assets[name]
            if type(asset["size"]) is not int or not 0 < asset["size"] <= 0x400000:
                raise ValueError("Encoded content allocation exceeds its bounded storage")
            if not isinstance(asset["sha1"], str) or len(asset["sha1"]) != 40:
                raise ValueError("Original content identity is missing")
            self._rows[name] = deepcopy(row)
        if set(self._rows) != set(self._assets):
            raise ValueError("Content registry does not cover every primary and derived input")

    def rows(self):
        return [deepcopy(self._rows[key]) for key in sorted(self._rows)]

    def _select(self, name, profile):
        row = self._rows.get(name)
        if row is None or profile not in row["profiles"]:
            raise ValueError("Resource is not applicable to the target profile")
        return row

    def _original(self, name, data):
        if not isinstance(data, (bytes, bytearray, memoryview)):
            raise ValueError("Original content must be bytes")
        asset = self._assets[name]
        original = bytes(data)
        if len(original) != asset["size"] or hashlib.sha1(original).hexdigest() != asset["sha1"]:
            raise ValueError("Original bytes differ from the immutable storage allocation")
        if asset.get("sha256") and hashlib.sha256(original).hexdigest() != asset["sha256"]:
            raise ValueError("Original content SHA-256 differs from its catalog")
        return original

    def _token(self, row, profile):
        return _digest({"contract": row, "source": self._assets[row["path"]], "profile": profile})

    def _context(self, row, profile, context):
        if row["codec"] != "dac-dpcm":
            return context
        name = "Sound/DAC/deltas.bin"
        self._select(name, profile)
        if not isinstance(context, dict) or set(context) != {"codebook"}:
            raise ValueError("DPCM context requires its catalog-owned codebook")
        self._original(name, context["codebook"])
        dac.decode_codebook(context["codebook"])
        return context

    def decode(self, name, profile, original, *, context=None):
        row = self._select(name, profile)
        original = self._original(name, original)
        context = self._context(row, profile, context)
        plain = format_codecs.decompress(row, original)
        if len(plain) != row["capacity"]["decoded_bytes"]:
            raise ValueError("Original decoded size differs from its consumer allocation")
        model = format_codecs.decode_plain(row, plain, context=context)
        return {"asset": name, "profile": profile, "contract": self._token(row, profile), "model": model}

    def encode(self, packet, *, target_profile, original, context=None):
        if not isinstance(packet, dict) or set(packet) != {"asset", "profile", "contract", "model"}:
            raise ValueError("Content packet fields differ from the profile contract")
        row = self._select(packet["asset"], target_profile)
        if packet["profile"] != target_profile or packet["contract"] != self._token(row, target_profile):
            raise ValueError("Content packet belongs to a different target profile or ABI")
        original = self._original(row["path"], original)
        context = self._context(row, target_profile, context)
        if len(format_codecs.decompress(row, original)) != row["capacity"]["decoded_bytes"]:
            raise ValueError("Original decoded size differs from its consumer allocation")
        if (
            row["codec"] == "collision-indices"
            and row["parameters"]["abi"] == "s3-planar16"
            and target_profile in {"sk", "s3k"}
        ):
            collision.check_shape_references(packet["model"], shape_count=256)
        plain = format_codecs.encode_plain(row, packet["model"], context=context)
        if len(plain) != row["capacity"]["decoded_bytes"]:
            raise ValueError("Edited data exceeds or changes its fixed decoded footprint")
        # Verify model equivalence even for an unchanged compressed stream.
        if format_codecs.decode_plain(row, plain, context=context) != packet["model"]:
            raise ValueError("Encoded data differs from its semantic model")
        if row["codec"] == "dac-dpcm" and format_codecs.decode_plain(row, original, context=context) == packet["model"]:
            result = original
        else:
            result = format_codecs.compress(row, plain, original)
        capacity = self._assets[row["path"]]["size"]
        if len(result) > capacity or (row["compression"] == "none" and len(result) != capacity):
            raise ValueError("Encoded data exceeds or changes its fixed storage footprint")
        if len(result) < capacity:
            result += bytes(capacity - len(result))
        if row["codec"] != "dac-dpcm" and format_codecs.decompress(row, result) != plain:
            raise ValueError("Fixed-slot padding changes decoded content")
        return result

    def write(self, workspace, packet, *, target_profile, original, context=None):
        # Finish all ABI, original-identity and capacity checks before any write.
        data = self.encode(packet, target_profile=target_profile, original=original, context=context)
        base = Path(workspace).resolve()
        if not base.is_relative_to((ROOT / "build").resolve()):
            raise ValueError("Content workspace must stay inside ignored build storage")
        destination = (base / _path(packet["asset"])).resolve()
        if not destination.is_relative_to(base):
            raise ValueError("Content output escapes its workspace allocation")
        atomic(destination, data)
        return destination

    def encode_corpus(self, model, *, target_profile, abi, originals):
        if model.get("abi") != abi:
            raise ValueError("SMPS corpus belongs to another target ABI")
        # Slot descriptors are immutable and come from the source asset manifest.
        expected = {}
        for name, original in originals.items():
            row = self._select(name, target_profile)
            if row["codec"] != "smps-corpus" or row["parameters"] != {"abi": abi}:
                raise ValueError("SMPS corpus includes an incompatible target allocation")
            self._original(name, original)
            asset = self._assets[name]
            expected[name] = (asset["offset"] % 32768, asset["size"])
        actual = {row["id"]: (row["bank_offset"], row["capacity"]) for row in model["streams"]}
        if actual != expected or len(model["streams"]) != len(expected):
            raise ValueError("SMPS model changes its immutable bank slots")
        banks = {self._assets[name]["offset"] // 32768 for name in expected}
        if len(banks) != 1:
            raise ValueError("SMPS corpus crosses a physical ROM bank")
        encoded = smps_storage.encode_corpus(model, target_abi=abi)
        if set(encoded) != set(expected) or any(len(data) != expected[name][1] for name, data in encoded.items()):
            raise ValueError("SMPS corpus changes its storage footprints")
        return encoded

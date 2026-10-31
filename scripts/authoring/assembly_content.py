"""Immutable source allocations with editable mapping, DPLC and animation models."""

from copy import deepcopy
import hashlib
import json
from pathlib import PurePosixPath

from scripts.authoring import animations, assembly_data, sprite_resources


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def _path(value):
    if not isinstance(value, str):
        raise ValueError("Assembly resource path must be text")
    path = PurePosixPath(value)
    if (
        not value.startswith("src/")
        or path.is_absolute()
        or ".." in path.parts
        or path.as_posix() != value
        or not value.endswith(".s")
    ):
        raise ValueError("Assembly resource leaves the source allocation")
    return value


def _name(value):
    if not isinstance(value, str) or not assembly_data.NAME.fullmatch(value):
        raise ValueError("Assembly resource needs a canonical symbol name")
    return value


class AssemblyCatalog:
    def __init__(self, registry, profiles):
        if (
            set(registry) != {"schema_version", "scope", "resources"}
            or registry["schema_version"] != 1
            or registry["scope"] != "preservation-fixed-footprint"
        ):
            raise ValueError("Unknown assembly resource registry")
        self._rows = {}
        self._profiles = deepcopy(profiles) if isinstance(profiles, dict) else {key: {} for key in profiles}
        for value in registry["resources"]:
            row = deepcopy(value)
            if set(row) != {
                "path",
                "family",
                "address_space",
                "profiles",
                "capacity",
                "declarations_sha256",
                "labels",
                "external_symbols",
                "blocks",
            }:
                raise ValueError("Unknown assembly resource contract fields")
            path = _path(row["path"])
            if (
                path in self._rows
                or row["family"] not in {"map", "dplc", "anim"}
                or row["address_space"] != "cartridge-rom"
            ):
                raise ValueError("Duplicate resource, unknown family or unsupported source namespace")
            if (
                not row["profiles"]
                or len(set(row["profiles"])) != len(row["profiles"])
                or set(row["profiles"]) - set(self._profiles)
            ):
                raise ValueError("Assembly resource has invalid profile applicability")
            capacity = row["capacity"]
            if (
                set(capacity) != {"policy", "bytes"}
                or capacity["policy"] != "preservation-fixed-footprint"
                or type(capacity["bytes"]) is not int
                or not 0 < capacity["bytes"] <= 0x100000
            ):
                raise ValueError("Assembly resource has no bounded fixed allocation")
            identity = row["declarations_sha256"]
            if (
                not isinstance(identity, str)
                or len(identity) != 64
                or any(c not in "0123456789abcdef" for c in identity)
            ):
                raise ValueError("Assembly source declaration identity is malformed")
            if not isinstance(row["labels"], dict) or any(
                _name(k) != k or type(v) is not int or not 0 <= v <= capacity["bytes"] for k, v in row["labels"].items()
            ):
                raise ValueError("Assembly label leaves its immutable allocation")
            if len(set(row["external_symbols"])) != len(row["external_symbols"]) or any(
                _name(n) != n or n in row["labels"] for n in row["external_symbols"]
            ):
                raise ValueError("External assembly symbol is duplicated or locally shadowed")
            cursor = 0
            for block in row["blocks"]:
                self._block_contract(block, row["family"])
                if block["offset"] != cursor:
                    raise ValueError("Assembly semantic blocks overlap or leave a hole")
                cursor += block["size"]
            if cursor != capacity["bytes"]:
                raise ValueError("Assembly semantic blocks do not cover the allocation")
            self._rows[path] = row

    @staticmethod
    def _block_contract(block, family):
        kind = block.get("kind")
        fields = {"kind", "offset", "size"}
        if kind == "relative-word":
            fields |= {"target", "base"}
            _name(block.get("target"))
            _name(block.get("base"))
            if block["size"] != 2:
                raise ValueError("Relative source pointer must occupy one word")
        elif kind == "alignment":
            if block["size"] != 1 or block["offset"] % 2 != 1:
                raise ValueError("Source padding must be an odd-address even alignment")
        elif kind == "animation":
            fields.add("abi")
            if family != "anim" or block.get("abi") not in animations.ABIS:
                raise ValueError("Animation block has no declared consumer ABI")
        elif kind in ("map-s1", "map-s3k"):
            if family != "map":
                raise ValueError("Mapping frame has no mapping resource owner")
            header, stride = (1, 5) if kind == "map-s1" else (2, 6)
            if not header <= block["size"] <= header + 80 * stride or (block["size"] - header) % stride:
                raise ValueError("Mapping allocation exceeds its piece capacity")
        elif kind in ("dplc-player", "dplc-object"):
            if family not in ("map", "dplc") or not 2 <= block["size"] <= 514 or block["size"] % 2:
                raise ValueError("DPLC allocation exceeds its transfer capacity")
        else:
            raise ValueError("Unknown assembly semantic block kind")
        if (
            set(block) != fields
            or type(block["offset"]) is not int
            or type(block["size"]) is not int
            or block["offset"] < 0
            or block["size"] < 1
        ):
            raise ValueError("Assembly block fields or capacity are malformed")

    def rows(self):
        return [deepcopy(self._rows[path]) for path in sorted(self._rows)]

    def _select(self, path, profile, component):
        row = self._rows.get(path)
        if row is None or profile not in row["profiles"]:
            raise ValueError("Assembly resource is unavailable in this profile")
        composition = self._profiles[profile].get("compose")
        if composition:
            if component not in composition or component not in row["profiles"]:
                raise ValueError("Assembly composite view needs an applicable component")
        elif component is not None:
            raise ValueError("A base assembly profile has no component selector")
        return row

    @staticmethod
    def _context(row, external_symbols):
        if (
            not isinstance(external_symbols, dict)
            or set(external_symbols) != set(row["external_symbols"])
            or any(type(x) is not int or not -0xFFFFFFFF <= x <= 0xFFFFFFFF for x in external_symbols.values())
        ):
            raise ValueError("Assembly external context differs from its exact symbol contract")
        return external_symbols

    @staticmethod
    def _original(row, text, external):
        records = assembly_data.decode_source(text, external_symbols=external)
        raw, labels = assembly_data.assemble(records, external_symbols=external)
        if (
            digest(records) != row["declarations_sha256"]
            or labels != row["labels"]
            or len(raw) != row["capacity"]["bytes"]
        ):
            raise ValueError("Assembly original differs from its immutable declaration allocation")
        return records, raw, labels

    @staticmethod
    def _pointer(block, labels, external):
        symbols = external | labels
        if block["target"] not in symbols or block["base"] not in symbols:
            raise ValueError("Relative source pointer has no checked symbol")
        value = symbols[block["target"]] - symbols[block["base"]]
        if not -32768 <= value <= 32767:
            raise ValueError("Relative source pointer exceeds its signed word ABI")
        return (value & 65535).to_bytes(2, "big")

    def decode(self, path, profile, text, *, external_symbols, component=None):
        row = self._select(path, profile, component)
        external = self._context(row, external_symbols)
        records, raw, labels = self._original(row, text, external)
        models = []
        for block in row["blocks"]:
            chunk = raw[block["offset"] : block["offset"] + block["size"]]
            kind = block["kind"]
            if kind == "relative-word":
                if chunk != self._pointer(block, labels, external):
                    raise ValueError("Assembly pointer expression differs from its structural owner")
                model = {"target": block["target"], "base": block["base"]}
            elif kind == "alignment":
                if chunk != b"\0":
                    raise ValueError("Even alignment contains nonzero data")
                model = {"alignment": 2}
            elif kind.startswith("map-"):
                model = sprite_resources.decode_mapping(
                    chunk, abi="s1-byte-count" if kind == "map-s1" else "s3k-word-count"
                )
            elif kind.startswith("dplc-"):
                model = sprite_resources.decode_dplc(
                    chunk, abi="player-high-count" if kind == "dplc-player" else "object-low-count-minus-one"
                )
            else:
                model = animations.decode(chunk, abi=block["abi"])
            models.append(model)
        return {
            "path": path,
            "profile": profile,
            "component": component,
            "contract": digest([row, profile, component, external]),
            "models": models,
        }

    def encode(self, packet, *, target_profile, original, external_symbols, component=None):
        if set(packet) != {"path", "profile", "component", "contract", "models"}:
            raise ValueError("Assembly model packet has unknown fields")
        row = self._select(packet["path"], target_profile, component)
        external = self._context(row, external_symbols)
        if (
            packet["profile"] != target_profile
            or packet["component"] != component
            or packet["contract"] != digest([row, target_profile, component, external])
        ):
            raise ValueError("Assembly model belongs to another contract, profile or component")
        records, raw, labels = self._original(row, original, external)
        if not isinstance(packet["models"], list) or len(packet["models"]) != len(row["blocks"]):
            raise ValueError("Assembly model block count differs from its immutable layout")
        output = bytearray()
        for block, model in zip(row["blocks"], packet["models"]):
            kind = block["kind"]
            if kind == "relative-word":
                if model != {"target": block["target"], "base": block["base"]}:
                    raise ValueError("Structural source references cannot be retargeted by a content edit")
                encoded = self._pointer(block, labels, external)
            elif kind == "alignment":
                if model != {"alignment": 2}:
                    raise ValueError("Even alignment cannot become editable content")
                encoded = b"\0"
            elif kind.startswith("map-"):
                encoded = sprite_resources.encode_mapping(
                    model, target_abi="s1-byte-count" if kind == "map-s1" else "s3k-word-count"
                )
            elif kind.startswith("dplc-"):
                encoded = sprite_resources.encode_dplc(
                    model, target_abi="player-high-count" if kind == "dplc-player" else "object-low-count-minus-one"
                )
            else:
                encoded = animations.encode(model, target_abi=block["abi"])
            if len(encoded) != block["size"]:
                raise ValueError("Semantic edit grows or shrinks its fixed assembly block")
            output.extend(encoded)
        # Keep structural expressions and every label, including aliases inside pieces.
        # Only literal byte/word operands receive the newly encoded semantic values.
        rewritten = deepcopy(records)
        cursor = 0
        for record in rewritten:
            if "label" in record:
                continue
            if "align" in record:
                cursor += cursor & 1
                continue
            width = record["width"]
            for index, expression in enumerate(record["values"]):
                if not any(isinstance(term["value"], str) for term in expression):
                    record["values"][index] = [
                        {"sign": 1, "value": int.from_bytes(output[cursor : cursor + width], "big")}
                    ]
                cursor += width
        text = assembly_data.encode_source(rewritten, external_symbols=external)
        if assembly_data.assemble(rewritten, external_symbols=external) != (bytes(output), labels):
            raise ValueError("Rendered semantic source differs from its independent byte model")
        return text, bytes(output)

"""Fixed-footprint raw script packets tied to source, consumer ABI and product."""

from copy import deepcopy
import re

from scripts.authoring import raw_graph, raw_source
from scripts.authoring.assembly_content import digest, _path


class RawCatalog:
    def __init__(self, registry, profiles):
        if (
            set(registry) != {"schema_version", "scope", "coverage", "groups"}
            or registry["schema_version"] != 1
            or registry["scope"] != "preservation-fixed-footprint"
            or registry["coverage"] != "named-and-direct-static-consumers"
        ):
            raise ValueError("Unknown raw source catalog")
        self._profiles, self._rows = deepcopy(profiles), {}
        if not isinstance(registry["groups"], list) or not 0 < len(registry["groups"]) <= 4096:
            raise ValueError("Raw catalog group capacity exceeded")
        for original in registry["groups"]:
            row = deepcopy(original)
            if set(row) != {
                "path",
                "symbol",
                "scope",
                "first_line",
                "last_line",
                "profiles",
                "capacity_bytes",
                "declarations_sha256",
                "entries",
                "external_symbols",
            }:
                raise ValueError("Raw group fields differ from the source span contract")
            _path(row["path"])
            for key in ("symbol", "scope"):
                if not isinstance(row[key], str) or not raw_source.NAME.fullmatch(row[key]) or row[key].startswith("."):
                    raise ValueError("Raw context needs a qualified source symbol")
            if (
                any(type(row[k]) is not int for k in ("first_line", "last_line", "capacity_bytes"))
                or not 1 <= row["first_line"] <= row["last_line"]
                or not 0 < row["capacity_bytes"] <= 65536
            ):
                raise ValueError("Raw physical or byte allocation bounds are invalid")
            if (
                not row["profiles"]
                or len(set(row["profiles"])) != len(row["profiles"])
                or set(row["profiles"]) - set(profiles)
            ):
                raise ValueError("Raw product applicability is invalid")
            if not isinstance(row["declarations_sha256"], str) or not re.fullmatch(
                r"[0-9a-f]{64}", row["declarations_sha256"]
            ):
                raise ValueError("Raw declaration identity is malformed")
            raw_graph._entries(row["entries"], row["capacity_bytes"])
            if (
                not isinstance(row["external_symbols"], list)
                or len(set(row["external_symbols"])) != len(row["external_symbols"])
                or any(
                    not isinstance(n, str) or not raw_source.NAME.fullmatch(n) or n.startswith(".")
                    for n in row["external_symbols"]
                )
            ):
                raise ValueError("Raw external dependencies are invalid")
            key = (row["path"], row["symbol"])
            if key in self._rows:
                raise ValueError("Raw source span is duplicated")
            self._rows[key] = row
        owners = {}
        for row in self._rows.values():
            owners.setdefault(row["path"], []).append((row["first_line"], row["last_line"]))
        for spans in owners.values():
            end = 0
            for first, last in sorted(spans):
                if first <= end:
                    raise ValueError("Raw source spans overlap")
                end = last

    def rows(self):
        return [deepcopy(self._rows[key]) for key in sorted(self._rows)]

    def _select(self, path, symbol, profile, component):
        row = self._rows.get((path, symbol))
        if row is None or profile not in row["profiles"]:
            raise ValueError("Raw script is unavailable in the selected profile")
        composition = self._profiles[profile].get("compose")
        if composition:
            if component not in composition or component not in row["profiles"]:
                raise ValueError("Raw composite view needs an applicable component")
        elif component is not None:
            raise ValueError("A base raw profile has no component view")
        return row

    def source(self, row, text):
        records = raw_source.parse(text)
        if digest(records) != row["declarations_sha256"]:
            raise ValueError("Raw source differs from its immutable declaration identity")
        return records

    def _context(self, row, base, symbols):
        if type(base) is not int or not 0 <= base < 0x400000:
            raise ValueError("Raw source base leaves its cartridge domain")
        if (
            not isinstance(symbols, dict)
            or set(symbols) != set(row["external_symbols"])
            or any(type(v) is not int or not 0 <= v <= 0xFFFFFFFF for v in symbols.values())
        ):
            raise ValueError("Raw context differs from its exact symbol dependencies")
        return digest([row, base, symbols])

    def decode(self, path, symbol, profile, text, *, base, symbols, component=None):
        row = self._select(path, symbol, profile, component)
        token = self._context(row, base, symbols)
        raw, labels, padding = raw_source.assemble(
            self.source(row, text), scope=row["scope"], base=base, external=symbols
        )
        if len(raw) != row["capacity_bytes"] or labels.get(symbol) != base:
            raise ValueError("Raw source differs from its named byte allocation")
        return {
            "path": path,
            "symbol": symbol,
            "profile": profile,
            "component": component,
            "contract": digest([token, profile, component]),
            "model": raw_graph.decode(raw, row["entries"], padding),
        }

    def encode(self, packet, *, target_profile, original, base, symbols, component=None):
        if not isinstance(packet, dict) or set(packet) != {
            "path",
            "symbol",
            "profile",
            "component",
            "contract",
            "model",
        }:
            raise ValueError("Raw model packet has unknown fields")
        row = self._select(packet["path"], packet["symbol"], target_profile, component)
        token = self._context(row, base, symbols)
        if (
            packet["profile"] != target_profile
            or packet["component"] != component
            or packet["contract"] != digest([token, target_profile, component])
        ):
            raise ValueError("Raw model belongs to another profile, source or consumer ABI")
        self.source(row, original)
        text, raw = raw_source.encode_graph_source(
            original, packet["model"], entries=row["entries"], scope=row["scope"], base=base, external=symbols
        )
        if len(raw) != row["capacity_bytes"]:
            raise ValueError("Raw edit changes its fixed byte allocation")
        return text, raw

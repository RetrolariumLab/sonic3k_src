"""Profile-bound indexed palette edits with immutable pointer and overlay contexts."""

from copy import deepcopy
import re
from scripts.authoring import palette_indexed as codec, palette_indexed_source as source
from scripts.authoring.assembly_content import digest, _path


class IndexedPaletteCatalog:
    def __init__(self, registry, profiles):
        if (
            not isinstance(registry, dict)
            or set(registry) != {"schema_version", "scope", "groups", "consumer_sources", "consumer_bindings"}
            or registry["schema_version"] != 1
            or registry["scope"] != "preservation-fixed-footprint"
        ):
            raise ValueError("Unknown indexed palette source contract")
        self._profiles = deepcopy(profiles)
        self._rows = {}
        self.consumer_sources = deepcopy(registry["consumer_sources"])
        self.consumer_bindings = deepcopy(registry["consumer_bindings"])
        if not isinstance(self.consumer_sources, list) or not 0 < len(self.consumer_sources) <= 4096:
            raise ValueError("Indexed palette source proof is unbounded")
        seen = set()
        for item in self.consumer_sources:
            if not isinstance(item, dict) or set(item) != {"path", "sha256"}:
                raise ValueError("Invalid indexed palette consumer identity")
            _path(item["path"])
            if (
                item["path"] in seen
                or not isinstance(item["sha256"], str)
                or not re.fullmatch(r"[0-9a-f]{64}", item["sha256"])
            ):
                raise ValueError("Duplicate or malformed indexed palette consumer identity")
            seen.add(item["path"])
        if not isinstance(registry["groups"], list) or not 0 < len(registry["groups"]) <= 4096:
            raise ValueError("Indexed palette group count is unbounded")
        symbols = set()
        spans = {}
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
                "palette_count",
                "step_count",
                "color_count",
                "ram_state_copy",
            }:
                raise ValueError("Unknown indexed palette group fields")
            _path(row["path"])
            if (
                any(
                    not isinstance(row[k], str) or not re.fullmatch(r"[A-Za-z_]\w*", row[k])
                    for k in ("symbol", "scope")
                )
                or row["symbol"] != row["scope"]
            ):
                raise ValueError("Indexed palette needs a global scoped entry")
            if (
                any(type(row[k]) is not int for k in ("first_line", "last_line", "capacity_bytes"))
                or not 1 <= row["first_line"] <= row["last_line"]
                or type(row["ram_state_copy"]) is not bool
            ):
                raise ValueError("Invalid indexed palette span or RAM overlay policy")
            if (
                not isinstance(row["profiles"], list)
                or not row["profiles"]
                or len(set(row["profiles"])) != len(row["profiles"])
                or set(row["profiles"]) - set(profiles)
            ):
                raise ValueError("Unknown indexed palette profile")
            if not isinstance(row["declarations_sha256"], str) or not re.fullmatch(
                r"[0-9a-f]{64}", row["declarations_sha256"]
            ):
                raise ValueError("Invalid indexed palette source identity")
            if codec.layout(base=0, **self.parameters(row))[2] != row["capacity_bytes"]:
                raise ValueError("Indexed palette byte capacity differs from its declared layout")
            key = (row["path"], row["symbol"])
            if key in self._rows or row["symbol"] in symbols:
                raise ValueError("Duplicate indexed palette source entry")
            self._rows[key] = row
            symbols.add(row["symbol"])
            spans.setdefault(row["path"], []).append((row["first_line"], row["last_line"]))
        for items in spans.values():
            end = 0
            for first, last in sorted(items):
                if first <= end:
                    raise ValueError("Indexed palette source spans overlap")
                end = last
        if not isinstance(self.consumer_bindings, list) or not 0 < len(self.consumer_bindings) <= 4096:
            raise ValueError("Indexed palette caller proof is unbounded")
        calls = set()
        used = set()
        for item in self.consumer_bindings:
            if not isinstance(item, dict) or set(item) != {"path", "call_line", "header", "destinations"}:
                raise ValueError("Unknown indexed palette consumer binding")
            if (
                item["path"] not in seen
                or type(item["call_line"]) is not int
                or not 0 < item["call_line"] <= 200000
                or item["header"] not in symbols
                or (item["path"], item["call_line"]) in calls
            ):
                raise ValueError("Invalid indexed palette caller source or header")
            calls.add((item["path"], item["call_line"]))
            used.add(item["header"])
            if not isinstance(item["destinations"], list) or not 0 < len(item["destinations"]) <= 64:
                raise ValueError("Palette caller destinations are unbounded")
            for target in item["destinations"]:
                if (
                    not isinstance(target, dict)
                    or set(target) != {"symbol", "byte_offset"}
                    or not isinstance(target["symbol"], str)
                    or not re.fullmatch(r"[A-Za-z_]\w*", target["symbol"])
                    or type(target["byte_offset"]) is not int
                    or not 0 <= target["byte_offset"] < 128
                    or target["byte_offset"] % 2
                ):
                    raise ValueError("Invalid indexed palette destination contract")
        if used != symbols:
            raise ValueError("Indexed palette source has no registered consumer")

    @staticmethod
    def parameters(row):
        return {name: row[name] for name in ("palette_count", "step_count", "color_count")}

    def rows(self):
        return [deepcopy(self._rows[key]) for key in sorted(self._rows)]

    def source(self, row, text):
        records = source.parse(text)
        if digest(records) != row["declarations_sha256"]:
            raise ValueError("Indexed palette source declaration identity changed")
        return records

    def _select(self, path, symbol, profile, component):
        row = self._rows.get((path, symbol))
        if row is None or profile not in row["profiles"]:
            raise ValueError("Indexed palette is unavailable in this profile")
        composition = self._profiles[profile].get("compose")
        if composition:
            if component not in composition or component not in row["profiles"]:
                raise ValueError("Indexed palette composite needs an applicable component")
        elif component is not None:
            raise ValueError("Base indexed palette profile has no component view")
        return row

    def _contract(self, row, base, profile, component):
        codec.layout(base=base, **self.parameters(row))
        return digest([row, base, profile, component, self.consumer_sources, self.consumer_bindings])

    def decode(self, path, symbol, profile, text, *, base, component=None):
        row = self._select(path, symbol, profile, component)
        raw, labels, padding = source.assemble(self.source(row, text), scope=row["scope"], base=base, external={})
        if len(raw) != row["capacity_bytes"] or labels.get(symbol) != base or padding:
            raise ValueError("Indexed palette source differs from its named allocation")
        return {
            "path": path,
            "symbol": symbol,
            "profile": profile,
            "component": component,
            "contract": self._contract(row, base, profile, component),
            "state_overlay": codec.state_copy(raw) if row["ram_state_copy"] else None,
            "model": codec.decode(raw, base=base, **self.parameters(row)),
        }

    def encode(self, packet, *, target_profile, original, base, component=None):
        if not isinstance(packet, dict) or set(packet) != {
            "path",
            "symbol",
            "profile",
            "component",
            "contract",
            "state_overlay",
            "model",
        }:
            raise ValueError("Unknown indexed palette edit packet fields")
        row = self._select(packet["path"], packet["symbol"], target_profile, component)
        if (
            packet["profile"] != target_profile
            or packet["component"] != component
            or packet["contract"] != self._contract(row, base, target_profile, component)
        ):
            raise ValueError("Indexed palette packet belongs to another context or profile")
        previous = self.decode(row["path"], row["symbol"], target_profile, original, base=base, component=component)
        raw = codec.encode(packet["model"], base=base, **self.parameters(row))
        if packet["state_overlay"] != previous["state_overlay"] or codec.structure(packet["model"]) != codec.structure(
            previous["model"]
        ):
            raise ValueError("Indexed palette edits change structural controls or RAM state ownership")
        prior = codec.encode(previous["model"], base=base, **self.parameters(row))
        prefix = 8 if row["ram_state_copy"] else 6
        if raw[:prefix] != prior[:prefix]:
            raise ValueError(
                "Indexed palette edit changes a structural pointer, including the overlapping RAM-state copy"
            )
        return source.rewrite(original, raw, scope=row["scope"], base=base), raw

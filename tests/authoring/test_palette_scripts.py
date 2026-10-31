"""Palette edits preserve the scoped macro graph and original storage."""

from copy import deepcopy
import hashlib
import unittest

from scripts.authoring import palette_scripts as codec
from scripts.authoring.assembly_content import digest
from scripts.authoring.palette_content import PaletteCatalog
from scripts.authoring.palette_workflow import discover

SYMBOLS = {"Normal_palette": 0xFFFFFC00, "Normal_palette_line_2": 0xFFFFFC20}
SOURCE = """Start:
palscriptptr .header,.data
dc.w 0
.header: palscripthdr Normal_palette_line_2+2,1,2
.data: palscriptdata 3,$246
palscriptloop .next
.next: palscripthdr Normal_palette_line_2+2,1,0
palscriptdata 4,$68A
palscriptrept
"""


def fixture(source=SOURCE, files=None):
    files = files or {}
    records = codec.parse(source)
    raw, labels, models = codec.assemble(records, scope="Start", base=0x100, symbols=SYMBOLS, files=files)
    row = {
        "path": "src/palette.s",
        "scope": "Start",
        "first_line": 1,
        "last_line": len(source.splitlines()),
        "profiles": ["first", "second", "composite"],
        "capacity_bytes": len(raw),
        "declarations_sha256": digest(records),
        "external_symbols": sorted(SYMBOLS),
        "file_frames": sorted(files),
    }
    assets = {
        name[5:]: {
            "size": len(data),
            "sha1": hashlib.sha1(data).hexdigest(),
            "sha256": hashlib.sha256(data).hexdigest(),
        }
        for name, data in files.items()
    }
    registry = {"schema_version": 1, "scope": "preservation-fixed-footprint", "groups": [row]}
    result = PaletteCatalog(
        registry, {"first": {}, "second": {}, "composite": {"compose": ["first", "second"]}}, assets
    )
    return result, raw, labels, models


class PaletteScriptTests(unittest.TestCase):
    def test_color_and_duration_edit_changes_only_checked_words(self):
        catalog, original, labels, models = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", SOURCE, base=0x100, symbols=SYMBOLS, files={})
        frame = next(model for model in packet["models"] if model.get("op") == "frame")
        frame["colors"][0]["red"] = 7
        frame["ticks"] = 2
        text, raw = catalog.encode(
            packet, target_profile="first", original=SOURCE, base=0x100, symbols=SYMBOLS, files={}
        )
        self.assertEqual(raw[14:18], bytes.fromhex("024e0001"))
        self.assertEqual(raw[:14] + raw[18:], original[:14] + original[18:])
        self.assertIn(".header:", text)
        self.assertNotIn("Start.header:", text)
        self.assertEqual(
            codec.assemble(codec.parse(text), scope="Start", base=0x100, symbols=SYMBOLS, files={})[1], labels
        )

    def test_structural_graph_counter_color_count_and_profile_substitutions_fail(self):
        catalog, raw, labels, models = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", SOURCE, base=0x100, symbols=SYMBOLS, files={})
        changed = []
        for op, key, value in (
            ("header", "entries", 2),
            ("header", "counter_limit", 0),
            ("next-header", "target", 0x100),
        ):
            model = deepcopy(packet)
            next(item for item in model["models"] if item.get("op") == op)[key] = value
            changed.append(model)
        for model in changed:
            with self.assertRaises(ValueError):
                catalog.encode(model, target_profile="first", original=SOURCE, base=0x100, symbols=SYMBOLS, files={})
        for profile, base, source, component in (
            ("second", 0x100, SOURCE, None),
            ("first", 0x102, SOURCE, None),
            ("first", 0x100, SOURCE.replace("$246", "$248"), None),
            ("first", 0x100, SOURCE, "second"),
            ("composite", 0x100, SOURCE, None),
        ):
            with self.subTest(profile=profile, base=base), self.assertRaises(ValueError):
                catalog.encode(
                    packet,
                    target_profile=profile,
                    original=source,
                    base=base,
                    symbols=SYMBOLS,
                    files={},
                    component=component,
                )

    def test_delay_color_and_destination_bounds_fail_before_encoding(self):
        catalog, raw, labels, models = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", SOURCE, base=0x100, symbols=SYMBOLS, files={})
        variants = []
        for ticks in (0, 129, True):
            model = deepcopy(packet)
            next(item for item in model["models"] if item.get("op") == "frame")["ticks"] = ticks
            variants.append(model)
        model = deepcopy(packet)
        next(item for item in model["models"] if item.get("op") == "frame")["colors"][0]["reserved"] = 0x8000
        variants.append(model)
        model = deepcopy(packet)
        next(item for item in model["models"] if item.get("op") == "header")["color_offset"] = 64
        variants.append(model)
        model = deepcopy(packet)
        next(item for item in model["models"] if item.get("op") == "frame")["colors"].append(
            {"red": 0, "green": 0, "blue": 0, "reserved": 0}
        )
        variants.append(model)
        for model in variants:
            with self.assertRaises(ValueError):
                catalog.encode(model, target_profile="first", original=SOURCE, base=0x100, symbols=SYMBOLS, files={})

    def test_two_initializers_share_a_scope_and_keep_absolute_header_longwords(self):
        source = "Start: palscriptptr .h1,.d1\npalscriptptr .h2,.d2\n.h1: palscripthdr Normal_palette_line_2,1,0\n.d1: palscriptdata 1,0\npalscriptrept\n.h2: palscripthdr Normal_palette_line_2,1,0\n.d2: palscriptdata 1,2\npalscriptrept\n"
        catalog, raw, labels, models = fixture(source)
        self.assertEqual(int.from_bytes(raw[4:8], "big"), labels["Start.h1"])
        self.assertEqual(int.from_bytes(raw[12:16], "big"), labels["Start.h2"])
        text, encoded = codec.encode_models(
            codec.parse(source), models, scope="Start", base=0x100, symbols=SYMBOLS, files={}
        )
        self.assertEqual(encoded, raw)
        self.assertEqual(len(discover(source)), 1)

    def test_stored_records_after_repeat_preserve_their_original_width(self):
        source = "Start: palscriptptr .h,.d\n.h: palscripthdr Normal_palette_line_2,1,0\n.d: palscriptdata 2,$222\npalscriptrept\npalscriptdata 2,$444,$666\n"
        catalog, raw, labels, models = fixture(source)
        stored = [item for item in models if item.get("op") == "frame"][-1]
        self.assertTrue(stored["after_terminal"])
        self.assertEqual(len(stored["colors"]), 2)
        self.assertEqual(
            codec.encode_models(codec.parse(source), models, scope="Start", base=0x100, symbols=SYMBOLS, files={})[1],
            raw,
        )

    def test_external_file_context_is_immutable_and_delay_is_editable(self):
        source = 'Start: palscriptptr .h,.d\n.h: palscripthdr Normal_palette_line_2,1,0\n.d: palscriptfile 3,"data/frame.bin"\npalscriptrept\n'
        files = {"data/frame.bin": bytes.fromhex("0246")}
        catalog, raw, labels, models = fixture(source, files)
        packet = catalog.decode("src/palette.s", "Start", "first", source, base=0x100, symbols=SYMBOLS, files=files)
        next(item for item in packet["models"] if item.get("op") == "file-frame")["ticks"] = 4
        self.assertIn(
            bytes.fromhex("02460003"),
            catalog.encode(packet, target_profile="first", original=source, base=0x100, symbols=SYMBOLS, files=files)[
                1
            ],
        )
        with self.assertRaises(ValueError):
            catalog.encode(
                packet,
                target_profile="first",
                original=source,
                base=0x100,
                symbols=SYMBOLS,
                files={"data/frame.bin": bytes(2)},
            )

    def test_discovery_covers_all_groups_without_absorbing_other_data(self):
        full = "Before: dc.w 7\n" + SOURCE + "After: dc.w 9\n" + SOURCE.replace("Start:", "Other:")
        spans = discover(full)
        self.assertEqual([item["scope"] for item in spans], ["Start", "Other"])
        self.assertTrue(all("After:" not in item["text"] and "Before:" not in item["text"] for item in spans))
        for body in ("rts", 'binclude "data/blob.bin"', "rept 10\ndc.w 0\nendm", "palscriptdata 2"):
            with self.assertRaises(ValueError):
                codec.parse("Start: palscriptptr .h,.d\n" + body)

    def test_cross_group_next_header_uses_the_actual_prior_header_origin(self):
        source = "Start: palscriptptr .h,.d\n.h: palscripthdr Normal_palette_line_2,1,1\n.d: palscriptdata 1,0\npalscriptloop Other.header\n"
        symbols = SYMBOLS | {"Other.header": 0x200}
        records = codec.parse(source)
        raw, labels, models = codec.assemble(records, scope="Start", base=0x100, symbols=symbols, files={})
        self.assertEqual(raw[-4:-2], bytes.fromhex("fff8"))
        self.assertEqual(int.from_bytes(raw[-2:], "big"), 0x200 - labels["Start.h"])
        self.assertEqual(
            codec.encode_models(records, models, scope="Start", base=0x100, symbols=symbols, files={})[1], raw
        )

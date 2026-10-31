"""Indexed palettes preserve pointers, shared state, CRAM bounds and source views."""

from copy import deepcopy
import unittest
from scripts.authoring import palette_indexed as codec, palette_indexed_source as source
from scripts.authoring.palette_indexed_content import IndexedPaletteCatalog
from scripts.authoring.palette_indexed_workflow import calls, copies_state, destination_offset
from scripts.authoring.assembly_content import digest

TEXT = """Start: dc.l .table
dc.w 2-1
dc.b 0,3,1,5,0,7,$ff,$fc
.table: dc.w .p0-.table,.p1-.table
.p0: dc.w $246,$68a
.p1: dc.w $ace,$eee
"""


def fixture(overlay=False):
    raw, labels, padding = source.assemble(source.parse(TEXT), scope="Start", base=0x100, external={})
    row = {
        "path": "src/palette.s",
        "symbol": "Start",
        "scope": "Start",
        "first_line": 1,
        "last_line": len(TEXT.splitlines()),
        "profiles": ["first", "second", "combined"],
        "capacity_bytes": len(raw),
        "declarations_sha256": digest(source.parse(TEXT)),
        "palette_count": 2,
        "step_count": 3,
        "color_count": 2,
        "ram_state_copy": overlay,
    }
    registry = {
        "schema_version": 1,
        "scope": "preservation-fixed-footprint",
        "groups": [row],
        "consumer_sources": [{"path": "src/reader.s", "sha256": "a" * 64}],
        "consumer_bindings": [
            {
                "path": "src/reader.s",
                "call_line": 1,
                "header": "Start",
                "destinations": [{"symbol": "Normal_palette", "byte_offset": 0}],
            }
        ],
    }
    result = IndexedPaletteCatalog(registry, {"first": {}, "second": {}, "combined": {"compose": ["second", "first"]}})
    return result, raw, labels, registry


class IndexedPaletteTests(unittest.TestCase):
    def test_color_indices_and_byte_counters_reencode_only_their_fields(self):
        catalog, raw, labels, registry = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", TEXT, base=0x100)
        packet["model"]["steps"][1]["delay_counter"] = 8
        packet["model"]["steps"][2]["palette_index"] = 1
        packet["model"]["frames"][0][0]["red"] = 7
        rendered, encoded = catalog.encode(packet, target_profile="first", original=TEXT, base=0x100)
        self.assertEqual(encoded[:8], raw[:8])
        self.assertEqual(encoded[9:11], bytes((8, 1)))
        self.assertEqual(encoded[18:20], bytes.fromhex("024e"))
        self.assertEqual(encoded[12:18], raw[12:18])
        self.assertEqual(source.assemble(source.parse(rendered), scope="Start", base=0x100, external={})[1], labels)
        self.assertIn(".table:", rendered)
        self.assertNotIn("Start.table:", rendered)

    def test_control_shape_markers_relative_words_and_color_width_cannot_change(self):
        catalog, raw, labels, registry = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", TEXT, base=0x100)
        for key, value in (
            ("restart_marker", 254),
            ("stored_marker", 248),
            ("color_count", 1),
            ("relative_offsets", [6, 4]),
            ("palette_table", 0x110),
        ):
            changed = deepcopy(packet)
            changed["model"][key] = value
            with self.assertRaises(ValueError):
                catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)
        for key in ("steps", "frames"):
            changed = deepcopy(packet)
            changed["model"][key].pop()
            with self.assertRaises(ValueError):
                catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)

    def test_overlay_bytes_remain_a_structural_pointer_in_the_other_reader(self):
        catalog, raw, labels, registry = fixture(True)
        packet = catalog.decode("src/palette.s", "Start", "first", TEXT, base=0x100)
        self.assertEqual(packet["state_overlay"], codec.state_copy(raw))
        self.assertEqual(packet["state_overlay"]["script_pointer"], 0x10003)
        for key in ("palette_index", "delay_counter"):
            changed = deepcopy(packet)
            changed["model"]["steps"][0][key] = 1
            with self.assertRaises(ValueError):
                catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)
        changed = deepcopy(packet)
        changed["state_overlay"]["script_pointer"] += 1
        with self.assertRaises(ValueError):
            catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)
        packet["model"]["steps"][1]["delay_counter"] = 0
        packet["model"]["frames"][0][0]["green"] = 7
        rendered, encoded = catalog.encode(packet, target_profile="first", original=TEXT, base=0x100)
        self.assertEqual(encoded[:8], raw[:8])
        self.assertNotEqual(encoded, raw)

    def test_profile_base_component_source_and_consumer_context_are_bound(self):
        catalog, raw, labels, registry = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", TEXT, base=0x100)
        for profile, base, text, component in (
            ("second", 0x100, TEXT, None),
            ("first", 0x102, TEXT, None),
            ("first", 0x100, TEXT.replace("$246", "$248"), None),
            ("combined", 0x100, TEXT, None),
            ("first", 0x100, TEXT, "second"),
        ):
            with self.assertRaises(ValueError):
                catalog.encode(packet, target_profile=profile, original=text, base=base, component=component)
        registry["consumer_sources"][0]["sha256"] = "b" * 64
        other = IndexedPaletteCatalog(
            registry, {"first": {}, "second": {}, "combined": {"compose": ["second", "first"]}}
        )
        with self.assertRaises(ValueError):
            other.encode(packet, target_profile="first", original=TEXT, base=0x100)
        combined = catalog.decode("src/palette.s", "Start", "combined", TEXT, base=0x100, component="first")
        self.assertEqual(
            catalog.encode(combined, target_profile="combined", original=TEXT, base=0x100, component="first")[1], raw
        )

    def test_index_counter_and_rgb_capacity_are_checked(self):
        catalog, raw, labels, registry = fixture()
        packet = catalog.decode("src/palette.s", "Start", "first", TEXT, base=0x100)
        for key, value in (
            ("palette_index", 2),
            ("palette_index", True),
            ("delay_counter", 256),
            ("delay_counter", -1),
        ):
            changed = deepcopy(packet)
            changed["model"]["steps"][0][key] = value
            with self.assertRaises(ValueError):
                catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)
        changed = deepcopy(packet)
        changed["model"]["frames"][0][0]["red"] = 8
        with self.assertRaises(ValueError):
            catalog.encode(changed, target_profile="first", original=TEXT, base=0x100)
        packet["model"]["frames"][0][0]["reserved"] = 0x8000
        # This reader copies CRAM words directly; unlike the macro DSL, color bit15 is not a command.
        self.assertTrue(catalog.encode(packet, target_profile="first", original=TEXT, base=0x100)[1][18] & 128)

    def test_destination_and_layout_domains_stop_at_the_staging_boundary(self):
        normal = 0xFFFFFC00
        self.assertEqual(destination_offset(normal, normal + 124, 2), 62)
        for at in (normal - 2, normal + 1, normal + 126):
            with self.assertRaises(ValueError):
                destination_offset(normal, at, 2)
        for params in (
            {"base": 0x3FFFFE, "palette_count": 2, "step_count": 3, "color_count": 2},
            {"base": 0, "palette_count": 129, "step_count": 3, "color_count": 2},
            {"base": 0, "palette_count": 2, "step_count": 128, "color_count": 2},
        ):
            with self.assertRaises(ValueError):
                codec.layout(**params)

    def test_source_grammar_rejects_execution_unknown_fields_and_overflow(self):
        for text in ('Start: binclude "data/blob.bin"', "Start: nop", "Start: dc.w function(1)", "Start: dc.q 1"):
            with self.assertRaises(ValueError):
                source.parse(text)
        for text in (
            "Start: dc.b 256",
            "Start: dc.w 65536",
            "Start: dc.l $100000000",
            "Start: dc.w Missing",
            "Start: dc.b 1\nStart: dc.b 2",
        ):
            with self.assertRaises(ValueError):
                source.assemble(source.parse(text), scope="Start", base=0, external={})
        with self.assertRaises(ValueError):
            source.assemble([{"width": True, "values": [{"integer": 1}]}], scope="Start", base=0, external={})

    def test_caller_and_state_copy_discovery_track_the_actual_instructions(self):
        text = "; jsr (Run_PalRotationScript2).l\njsr (Run_PalRotationScript2).l\nRun_PalRotationScript2:\nrts\n"
        self.assertEqual(calls(text), {2})
        text = (
            "lea (Start).l,a1\nlea (Palette_rotation_data).w,a2\nmove.l (a1)+,(a2)+\nmove.l (a1)+,(a2)+\nclr.w (a2)\n"
        )
        self.assertTrue(copies_state(text, "Start"))
        self.assertFalse(copies_state(text, "Other"))
        self.assertFalse(copies_state(text.replace("Palette_rotation_data", "Normal_palette"), "Start"))

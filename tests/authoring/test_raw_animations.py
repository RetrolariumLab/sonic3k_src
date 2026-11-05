"""Interpreter-specific raw frames, base-changing graphs and scoped source edits."""

from copy import deepcopy
import unittest

from scripts.authoring import raw_animations as codec, raw_graph as graph, raw_source as source


class RawAnimationTests(unittest.TestCase):
    def test_same_bytes_have_explicit_fixed_and_pair_views(self):
        raw = bytes.fromhex("01020304fc")
        fixed = codec.decode(raw, abi="fixed")
        pairs = codec.decode(raw, abi="pairs")
        self.assertEqual(fixed["header"], {"delay_counter": 1})
        self.assertEqual(pairs["header"], {})
        self.assertEqual(pairs["tokens"][0], {"op": "frame", "frame": 1, "delay_counter": 2})
        for abi, model in (("fixed", fixed), ("pairs", pairs)):
            self.assertEqual(codec.encode(model, target_abi=abi), raw)
        with self.assertRaises(ValueError):
            codec.encode(fixed, target_abi="pairs")

    def test_extended_prefix_preserves_high_frame_ids(self):
        raw = bytes.fromhex("03fe80fffc")
        model = codec.decode(raw, abi="extended-fixed")
        self.assertEqual([x["frame"] for x in model["tokens"][:-1]], [254, 128])
        self.assertEqual(codec.encode(model, target_abi="extended-fixed"), raw)
        with self.assertRaises(ValueError):
            codec.decode(raw, abi="fixed")
        for raw in (b"\x03\xff", b"\x03\xf8", b"\x03\x80", b"\x03\x01"):
            with self.assertRaises(ValueError):
                codec.decode(raw, abi="fixed")

    def test_external_player_sentinels_are_product_specific(self):
        for raw, abi, frame in (
            (bytes.fromhex("020001ff"), "external-player-s3", 0),
            (bytes.fromhex("02ff0100"), "external-player-sk", 255),
        ):
            model = codec.decode(raw, abi=abi)
            self.assertEqual(model["tokens"][0], {"op": "frame", "frame": frame, "flip_flag": 1})
            self.assertEqual(model["tokens"][-1], {"op": "custom-routine"})
            self.assertEqual(codec.encode(model, target_abi=abi), raw)
        with self.assertRaises(ValueError):
            codec.decode(bytes.fromhex("020001ff"), abi="external-player")

    def test_flip_axis_and_shared_deceleration_limit_frame_are_explicit(self):
        raw = bytes.fromhex("0341fc")
        model = codec.decode(raw, abi="fixed-flip-x")
        self.assertEqual(model["tokens"][0], {"op": "frame", "frame": 1, "toggle_x": True})
        self.assertEqual(codec.encode(model, target_abi="fixed-flip-x"), raw)
        with self.assertRaises(ValueError):
            codec.encode(model, target_abi="fixed-flip-y")
        raw = bytes.fromhex("04fa0102ff")
        model = codec.decode(raw, abi="decelerating")
        self.assertEqual(model["header"]["completion_limit_and_restart_frame"], 250)
        self.assertEqual(codec.encode(model, target_abi="decelerating"), raw)

    def test_tails_carry_has_no_timing_header(self):
        raw = bytes.fromhex("070809ff")
        model = codec.decode(raw, abi="sentinel")
        self.assertEqual(model["header"], {})
        self.assertEqual(model["tokens"][0], {"op": "frame", "frame": 7})
        self.assertEqual(codec.encode(model, target_abi="sentinel"), raw)


class RawGraphTests(unittest.TestCase):
    def test_jump_changes_the_script_base_and_can_cycle(self):
        raw = bytes.fromhex("0301f8040702f8fc")
        model = graph.decode(raw, [(0, "fixed")])
        self.assertEqual([(x["offset"], x["target"]) for x in model["nodes"]], [(0, 4), (4, 0)])
        self.assertEqual(model["nodes"][1]["model"]["header"], {"delay_counter": 7})
        self.assertEqual(graph.encode(model), raw)
        with self.assertRaises(ValueError):
            codec.decode(raw, abi="fixed")

    def test_shared_bytes_require_consistent_semantic_edits(self):
        model = graph.decode(bytes.fromhex("01020304fc"), [(0, "fixed"), (0, "pairs")])
        model["nodes"][0]["model"]["header"]["delay_counter"] = 2
        with self.assertRaises(ValueError):
            graph.encode(model)
        model["nodes"][1]["model"]["tokens"][0]["frame"] = 2
        self.assertEqual(graph.encode(model), bytes.fromhex("02020304fc"))

    def test_unmodeled_storage_and_escaped_targets_are_not_raw_fallbacks(self):
        for raw, entries in (
            (bytes.fromhex("0301f87f"), [(0, "fixed")]),
            (bytes.fromhex("0102fc0703fc"), [(0, "fixed")]),
        ):
            with self.assertRaises(ValueError):
                graph.decode(raw, entries)
        model = graph.decode(bytes.fromhex("0102fc0703fc"), [(0, "fixed"), (3, "fixed")])
        self.assertEqual(graph.encode(model), bytes.fromhex("0102fc0703fc"))
        for altered in (
            model | {"size": -1},
            model | {"size": True},
            model | {"entries": [[0, "unknown"]]},
            model | {"padding": [100]},
        ):
            with self.assertRaises(ValueError):
                graph.encode(altered)

    def test_allocation_padding_is_explicit_zero_storage(self):
        raw = bytes.fromhex("0102fc00")
        model = graph.decode(raw, [(0, "fixed")], [3])
        self.assertEqual(graph.encode(model), raw)
        with self.assertRaises(ValueError):
            graph.decode(bytes.fromhex("0102fc01"), [(0, "fixed")], [3])


class RawSourceTests(unittest.TestCase):
    def test_local_jump_and_bit_flag_survive_value_edit(self):
        original = "Start: dc.b 3,1,$f8,.next-Start\n.next: dc.b 7,(3|$40),$fc\neven\n"
        records = source.parse(original)
        raw, labels, padding = source.assemble(records, scope="Start", base=0x100, external={})
        model = graph.decode(raw, [(0, "fixed-flip-x")], padding)
        model["nodes"][1]["model"]["tokens"][0]["frame"] = 5
        text, encoded = source.encode_graph_source(
            original, model, entries=[(0, "fixed-flip-x")], scope="Start", base=0x100, external={}
        )
        self.assertEqual(encoded[5], 0x45)
        self.assertIn(".next:", text)
        self.assertIn(".next-Start", text)
        self.assertEqual(source.assemble(source.parse(text), scope="Start", base=0x100, external={})[1], labels)
        changed = deepcopy(model)
        changed["nodes"][0]["model"]["tokens"][-1]["base_displacement"] = 0
        with self.assertRaises(ValueError):
            source.encode_graph_source(
                original, changed, entries=[(0, "fixed-flip-x")], scope="Start", base=0x100, external={}
            )

    def test_executable_opaque_and_unbounded_expressions_are_rejected(self):
        for text in (
            'Start: binclude "data/blob.bin"',
            "Start: nop",
            "Start: dc.b function(1)",
            "Start: dc.b 1<<2",
            "Start: dc.b 1 2",
            "Start: dc.b " + ("(" * 30) + "1" + (")" * 30),
        ):
            with self.assertRaises(ValueError):
                source.parse(text)
        for records in (
            [{"bytes": [{"integer": True}]}],
            [{"bytes": [{"op": "*", "left": {"integer": 1}, "right": {"integer": 2}}]}],
            [{"label": "A", "bytes": [{"integer": 1}]}],
        ):
            with self.assertRaises(ValueError):
                source.assemble(records, scope="Start", base=0x100, external={})
        for text in ("Start: dc.b 256", "Start: dc.b -129"):
            with self.assertRaises(ValueError):
                source.assemble(source.parse(text), scope="Start", base=0x100, external={})


class RawCatalogTests(unittest.TestCase):
    def fixture(self):
        from scripts.authoring.raw_content import RawCatalog
        from scripts.authoring.assembly_content import digest

        text = "Start: dc.b 3,1,2,$fc\n"
        row = {
            "path": "src/raw.s",
            "symbol": "Start",
            "scope": "Start",
            "first_line": 1,
            "last_line": 1,
            "profiles": ["first", "second", "combined"],
            "capacity_bytes": 4,
            "declarations_sha256": digest(source.parse(text)),
            "entries": [[0, "fixed"]],
            "external_symbols": [],
        }
        registry = {
            "schema_version": 1,
            "scope": "preservation-fixed-footprint",
            "coverage": "named-and-direct-static-consumers",
            "groups": [row],
        }
        profiles = {"first": {}, "second": {}, "combined": {"compose": ["second", "first"]}}
        return RawCatalog(registry, profiles), text

    def test_value_edit_reencodes_source_within_the_original_contract(self):
        catalog, text = self.fixture()
        packet = catalog.decode("src/raw.s", "Start", "first", text, base=0x101, symbols={})
        packet["model"]["nodes"][0]["model"]["tokens"][0]["frame"] = 5
        rendered, raw = catalog.encode(packet, target_profile="first", original=text, base=0x101, symbols={})
        self.assertEqual(raw, bytes.fromhex("030502fc"))
        self.assertEqual(source.assemble(source.parse(rendered), scope="Start", base=0x101, external={})[0], raw)

    def test_profile_context_allocation_and_reader_abi_substitution_fail(self):
        catalog, text = self.fixture()
        packet = catalog.decode("src/raw.s", "Start", "first", text, base=0x101, symbols={})
        for profile, base, original, symbols, component in (
            ("second", 0x101, text, {}, None),
            ("first", 0x102, text, {}, None),
            ("first", 0x101, text.replace("3,", "4,"), {}, None),
            ("first", 0x101, text, {"Unexpected": 3}, None),
            ("combined", 0x101, text, {}, None),
            ("first", 0x101, text, {}, "second"),
        ):
            with self.assertRaises(ValueError):
                catalog.encode(
                    packet, target_profile=profile, original=original, base=base, symbols=symbols, component=component
                )
        for field, value in (("size", 5), ("entries", [[0, "pairs"]])):
            changed = deepcopy(packet)
            changed["model"][field] = value
            with self.assertRaises(ValueError):
                catalog.encode(changed, target_profile="first", original=text, base=0x101, symbols={})
        packet["model"]["nodes"][0]["abi"] = "pairs"
        with self.assertRaises(ValueError):
            catalog.encode(packet, target_profile="first", original=text, base=0x101, symbols={})
        combined = catalog.decode("src/raw.s", "Start", "combined", text, base=0x101, symbols={}, component="first")
        self.assertEqual(
            catalog.encode(
                combined, target_profile="combined", original=text, base=0x101, symbols={}, component="first"
            )[1],
            bytes.fromhex("030102fc"),
        )


class DedicatedRawTests(unittest.TestCase):
    def test_counted_unsigned_frames_do_not_dispatch_their_high_bit(self):
        raw = bytes.fromhex("030497969a96fc")
        markers = [{"offset": 6, "value": 252, "purpose": "unread-terminal-marker"}]
        model = graph.decode(raw, [(0, "counted")], stored=markers)
        body = model["nodes"][0]["model"]
        self.assertEqual(body["header"], {"delay_counter": 3, "frame_count": 4})
        body["tokens"][0]["frame"] = 255
        self.assertEqual(graph.encode(model), bytes.fromhex("0304ff969a96fc"))
        for key, value in (("frame_count", 3), ("frame_count", True)):
            changed = deepcopy(model)
            changed["nodes"][0]["model"]["header"][key] = value
            with self.assertRaises(ValueError):
                graph.encode(changed)
        with self.assertRaises(ValueError):
            graph.decode(raw, [(0, "fixed")], stored=markers)

    def test_signed_motion_fields_and_single_byte_deletion_keep_stored_marker(self):
        original = "Start: dc.b 6,0,0,-4,7,1,-128,127,$ff,$f4\n"
        markers = [{"offset": 9, "value": 244, "purpose": "unread-terminal-marker"}]
        data, labels, padding = source.assemble(source.parse(original), scope="Start", base=0, external={})
        model = graph.decode(data, [(0, "delta-frames")], stored=markers)
        frame = model["nodes"][0]["model"]["tokens"][1]
        self.assertEqual((frame["dx"], frame["dy"]), (-128, 127))
        frame["dx"], frame["dy"] = 3, -2
        text, encoded = source.encode_graph_source(
            original, model, entries=[(0, "delta-frames")], scope="Start", base=0, external={}, stored=markers
        )
        self.assertEqual(encoded[6:8], bytes((3, 254)))
        self.assertEqual(encoded[-2:], bytes((255, 244)))
        frame["dx"] = 128
        with self.assertRaises(ValueError):
            graph.encode(model)
        model = graph.decode(data, [(0, "delta-frames")], stored=markers)
        model["stored"][0]["value"] = 252
        with self.assertRaises(ValueError):
            source.encode_graph_source(
                original, model, entries=[(0, "delta-frames")], scope="Start", base=0, external={}, stored=markers
            )
        with self.assertRaises(ValueError):
            graph.decode(data, [(0, "delta-frames")])
        with self.assertRaises(ValueError):
            graph.decode(data, [(0, "delta-frames")], stored=[markers[0] | {"purpose": "opaque-bytes"}])

    def test_particle_lanes_have_one_restart_marker_and_independent_frames(self):
        raw = bytes.fromhex("080706ff030405")
        model = codec.decode(raw, abi="paired-lanes")
        self.assertEqual(model["header"], {"secondary_offset": 4})
        self.assertEqual(model["tokens"][0], {"op": "frame", "frame": 8, "secondary_frame": 3})
        model["tokens"][0]["secondary_frame"] = 255
        self.assertEqual(codec.encode(model, target_abi="paired-lanes"), bytes.fromhex("080706ffff0405"))
        model["header"]["secondary_offset"] = 3
        with self.assertRaises(ValueError):
            codec.encode(model, target_abi="paired-lanes")
        for raw in (bytes.fromhex("080706ff0304"), bytes.fromhex("ff")):
            with self.assertRaises(ValueError):
                codec.decode(raw, abi="paired-lanes")
        negative = codec.decode(bytes.fromhex("080706fe"), abi="negative-sentinel")
        self.assertEqual(negative["tokens"][-1], {"op": "restart", "marker": 254})
        self.assertEqual(codec.encode(negative, target_abi="negative-sentinel"), bytes.fromhex("080706fe"))

    def test_count_and_motion_capacity_are_checked_before_writing(self):
        for raw, abi in (
            (b"\x03\x00\x01", "counted"),
            (b"\x03\x02\x01", "counted"),
            (bytes((1, 2, 3, 4)) * 64 + b"\xff", "delta-frames"),
        ):
            with self.assertRaises(ValueError):
                codec.decode(raw, abi=abi)


class RegisteredReaderTests(unittest.TestCase):
    def test_state_selected_reader_abis_are_independent_of_the_next_physical_call(self):
        import json
        from pathlib import Path

        root = Path(__file__).resolve().parents[2]
        registry = json.loads((root / "config/authoring/raw_formats.json").read_text())
        expected = {
            "byte_4704C": "pairs",
            "byte_69136": "pairs",
            "byte_5773E": "pairs-flip-y",
            "byte_57723": "pairs-flip-x",
            "byte_57749": "pairs-flip-y",
            "byte_77482": "pairs",
            "byte_667AD": "extended-fixed",
            "byte_667D4": "extended-pairs",
            "byte_6684F": "extended-pairs",
            "byte_7D57C": "pairs-flip-x",
            "byte_7D636": "pairs-flip-x",
            "byte_7D587": "pairs",
        }
        from scripts.validation.semantic_labels import validate

        mappings = [row for row in validate(root)["mappings"] if row["old"] in expected]
        renamed = {row["old"]: row["new"] for row in mappings}
        self.assertEqual(len(renamed), len(mappings))
        for original, abi in expected.items():
            symbol = renamed.get(original, original)
            row = next(r for r in registry["groups"] if symbol in r.get("members", [r["symbol"]]))
            text = "".join(
                (root / row["path"]).read_text().splitlines(keepends=True)[row["first_line"] - 1 : row["last_line"]]
            )
            records = source.parse(text)
            data, labels, padding = source.assemble(records, scope=row["scope"], base=0, external={})
            at = labels[symbol]
            self.assertEqual([mode for offset, mode in row["entries"] if offset == at], [abi], symbol)

    def test_consumer_source_identity_is_part_of_the_edit_packet(self):
        from scripts.authoring.raw_content import RawCatalog
        from scripts.authoring.assembly_content import digest

        text = "Start: dc.b 3,1,$fc\n"
        row = {
            "path": "src/raw.s",
            "symbol": "Start",
            "scope": "Start",
            "first_line": 1,
            "last_line": 1,
            "profiles": ["first"],
            "capacity_bytes": 3,
            "declarations_sha256": digest(source.parse(text)),
            "entries": [[0, "fixed"]],
            "external_symbols": [],
            "members": ["Start"],
        }
        registry = {
            "schema_version": 1,
            "scope": "preservation-fixed-footprint",
            "coverage": "registered-consumer-corpora",
            "groups": [row],
            "consumer_sources": [{"path": "src/reader.s", "sha256": "a" * 64}],
        }
        catalog = RawCatalog(registry, {"first": {}})
        packet = catalog.decode("src/raw.s", "Start", "first", text, base=0, symbols={})
        registry["consumer_sources"][0]["sha256"] = "b" * 64
        changed = RawCatalog(registry, {"first": {}})
        with self.assertRaises(ValueError):
            changed.encode(packet, target_profile="first", original=text, base=0, symbols={})


class IndexedFrameTests(unittest.TestCase):
    def test_high_frames_are_data_and_alignment_is_not_an_editable_frame(self):
        raw = bytes.fromhex("bac45600d6d7d800")
        model = graph.decode(raw, [(0, "frame-index"), (4, "frame-index")], [3, 7])
        self.assertEqual([len(n["model"]["tokens"]) - 1 for n in model["nodes"]], [3, 3])
        model["nodes"][0]["model"]["tokens"][0]["frame"] = 255
        self.assertEqual(graph.encode(model), bytes.fromhex("ffc45600d6d7d800"))
        with self.assertRaises(ValueError):
            graph.decode(raw, [(0, "frame-index")], [3, 7])
        model["nodes"][0]["model"]["tokens"].insert(-1, {"op": "frame", "frame": 1})
        with self.assertRaises(ValueError):
            graph.encode(model)

    def test_indexed_flip_is_an_unsigned_stored_flag_not_a_toggle_or_sentinel(self):
        raw = bytes.fromhex("5a01590055ff")
        model = codec.decode(raw, abi="frame-flip-index")
        self.assertEqual(model["tokens"][2], {"op": "frame", "frame": 85, "flip_flag": 255})
        model["tokens"][0]["flip_flag"] = 2
        self.assertEqual(codec.encode(model, target_abi="frame-flip-index"), bytes.fromhex("5a02590055ff"))
        for value in (256, -1, True):
            model["tokens"][0]["flip_flag"] = value
            with self.assertRaises(ValueError):
                codec.encode(model, target_abi="frame-flip-index")
        with self.assertRaises(ValueError):
            codec.decode(b"\x5a", abi="frame-flip-index")

    def test_source_lookup_edits_keep_two_physical_aligned_sections(self):
        original = "Start: dc.b $ba,$ad,$56\neven\ndc.b $c4,$b0,$d6\neven\n"
        raw, labels, pad = source.assemble(source.parse(original), scope="Start", base=0, external={})
        model = graph.decode(raw, [(0, "frame-index"), (4, "frame-index")], pad)
        model["nodes"][1]["model"]["tokens"][1]["frame"] = 0xFC
        rendered, encoded = source.encode_graph_source(
            original, model, entries=[(0, "frame-index"), (4, "frame-index")], scope="Start", base=0, external={}
        )
        self.assertEqual(encoded, bytes.fromhex("baad5600c4fcd600"))
        self.assertEqual(rendered.count("even"), 2)


class IndexedCoverageTests(unittest.TestCase):
    def test_discovery_requires_an_actual_literal_pc_relative_frame_read(self):
        from scripts.authoring.raw_workflow import indexed_references

        text = 'Label: move.b Frames(pc,d0.w),mapping_frame(a1) ; comment\nmove.b Other(pc,d3.w),mapping_frame(a0)\n; move.b Hidden(pc,d0.w),mapping_frame(a0)\ndc.b "move.b Quoted(pc,d0.w),mapping_frame(a0)"\nmove.b (a1,d0.w),mapping_frame(a0)\n'
        self.assertEqual(indexed_references(text), {"Frames", "Other"})

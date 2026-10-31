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

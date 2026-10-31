"""Semantic source edits preserve labels and reject footprint/profile changes."""

from copy import deepcopy
import unittest
from scripts.authoring import assembly_content as codec, assembly_data


def fixture():
    text = "Root:\ndc.w Frame-Root\nFrame:\ndc.w 1\ndc.b 0,0\nInside:\ndc.b 0,0,0,0\n"
    records = assembly_data.decode_source(text)
    data, labels = assembly_data.assemble(records)
    row = {
        "path": "src/frames.s",
        "family": "map",
        "address_space": "cartridge-rom",
        "profiles": ["first", "second", "composite"],
        "capacity": {"policy": "preservation-fixed-footprint", "bytes": len(data)},
        "declarations_sha256": codec.digest(records),
        "labels": labels,
        "external_symbols": [],
        "blocks": [
            {"kind": "relative-word", "offset": 0, "size": 2, "target": "Frame", "base": "Root"},
            {"kind": "map-s3k", "offset": 2, "size": 8},
        ],
    }
    registry = {"schema_version": 1, "scope": "preservation-fixed-footprint", "resources": [row]}
    catalog = codec.AssemblyCatalog(
        registry, {"first": {}, "second": {}, "composite": {"compose": ["first", "second"]}}
    )
    return text, registry, catalog


class AssemblyContentTests(unittest.TestCase):
    def test_coordinate_edit_changes_semantic_bytes_preserving_internal_alias(self):
        text, spec, catalog = fixture()
        model = catalog.decode("src/frames.s", "first", text, external_symbols={})
        model["models"][1]["pieces"][0]["x"] = -7
        rendered, data = catalog.encode(model, target_profile="first", original=text, external_symbols={})
        self.assertEqual(data[-2:], bytes.fromhex("fff9"))
        self.assertEqual(
            assembly_data.assemble(assembly_data.decode_source(rendered))[1], {"Root": 0, "Frame": 2, "Inside": 6}
        )
        self.assertIn("Frame-Root", rendered)
        self.assertIn("Inside:", rendered)
        spec["resources"][0]["blocks"][1]["size"] = 100
        catalog.rows()[0]["labels"]["Inside"] = 100
        self.assertEqual(len(catalog.encode(model, target_profile="first", original=text, external_symbols={})[1]), 10)

    def test_profile_component_context_and_original_identity_cannot_be_substituted(self):
        text, spec, catalog = fixture()
        packet = catalog.decode("src/frames.s", "first", text, external_symbols={})
        for target, context, original, component in (
            ("second", {}, text, None),
            ("first", {"unknown": 0}, text, None),
            ("first", {}, text.replace("dc.w 1", "dc.w 0"), None),
            ("first", {}, text, "second"),
            ("composite", {}, text, None),
        ):
            with self.subTest(target=target, component=component), self.assertRaises(ValueError):
                catalog.encode(
                    packet, target_profile=target, original=original, external_symbols=context, component=component
                )
        for component in ("first", "second"):
            model = catalog.decode("src/frames.s", "composite", text, external_symbols={}, component=component)
            catalog.encode(model, target_profile="composite", original=text, external_symbols={}, component=component)
        with self.assertRaises(ValueError):
            catalog.decode("src/frames.s", "composite", text, external_symbols={}, component="unknown")

    def test_growth_reference_changes_and_layout_holes_are_rejected(self):
        text, spec, catalog = fixture()
        packet = catalog.decode("src/frames.s", "first", text, external_symbols={})
        grown = deepcopy(packet)
        grown["models"][1]["pieces"].append(deepcopy(grown["models"][1]["pieces"][0]))
        changed = deepcopy(packet)
        changed["models"][0]["target"] = "Inside"
        for model in (grown, changed):
            with self.assertRaises(ValueError):
                catalog.encode(model, target_profile="first", original=text, external_symbols={})
        for key, value in (("size", 9), ("offset", 3), ("kind", "raw")):
            altered = deepcopy(spec)
            altered["resources"][0]["blocks"][1][key] = value
            with self.assertRaises(ValueError):
                codec.AssemblyCatalog(altered, ["first", "second", "composite"])

    def test_relative_word_signed_range_is_enforced(self):
        block = {"target": "Frame", "base": "Root"}
        self.assertEqual(codec.AssemblyCatalog._pointer(block, {"Frame": -32768, "Root": 0}, {}), bytes.fromhex("8000"))
        for value in (-32769, 32768):
            with self.assertRaises(ValueError):
                codec.AssemblyCatalog._pointer(block, {"Frame": value, "Root": 0}, {})

    def test_opaque_or_executable_source_cannot_replace_a_model(self):
        text, spec, catalog = fixture()
        for altered in (
            text + "rts\n",
            text.replace("dc.b 0,0", 'binclude "blob.bin"'),
            text.replace("Frame-Root", "$0002"),
        ):
            with self.assertRaises(ValueError):
                catalog.decode("src/frames.s", "first", altered, external_symbols={})

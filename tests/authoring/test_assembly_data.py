"""Strict data syntax, signed fields and symbolic pointer round trips."""

import unittest
from scripts.authoring import assembly_data as codec


class AssemblyDataTests(unittest.TestCase):
    def test_symbolic_aliases_forward_references_and_signed_data(self):
        source = "Table: dc.w Frame-Table,Alias-Table\nFrame: dc.b -1,$12+2\nAlias: dc.w -2\n"
        model = codec.decode_source(source)
        data, symbols = codec.assemble(model)
        self.assertEqual(data, bytes.fromhex("00040006ff14fffe"))
        self.assertEqual(symbols, {"Table": 0, "Frame": 4, "Alias": 6})
        self.assertEqual(codec.assemble(codec.decode_source(codec.encode_source(model))), (data, symbols))

    def test_even_alignment_is_recomputed_after_an_edit(self):
        model = codec.decode_source("A: dc.b 7\neven\nB: dc.w B-A\n")
        self.assertEqual(codec.assemble(model), (bytes.fromhex("07000002"), {"A": 0, "B": 2}))
        model[1]["values"].append([{"sign": 1, "value": 9}])
        self.assertEqual(codec.assemble(model)[0], bytes.fromhex("07090002"))

    def test_executable_controls_paths_undefined_names_and_overflow_fail(self):
        for text in (
            "rts",
            'include "a.s"',
            "A: dc.w External-A",
            "A:\nA:",
            "dc.b 256",
            "dc.b -129",
            "dc.w 65536",
            "dc.w 1*2",
            "dc.w 1/2",
            "dc.w 1 2",
        ):
            with self.subTest(text=text), self.assertRaises(ValueError):
                codec.decode_source(text)
        model = codec.decode_source("dc.b 1")
        model[0]["width"] = True
        with self.assertRaises(ValueError):
            codec.assemble(model)

    def test_external_symbols_are_explicit_and_do_not_override_local_labels(self):
        source = "Here: dc.w Elsewhere-Here"
        model = codec.decode_source(source, external_symbols={"Elsewhere": 16, "Here": 500})
        self.assertEqual(codec.assemble(model, external_symbols={"Elsewhere": 16})[0], bytes.fromhex("0010"))
        with self.assertRaisesRegex(ValueError, "Unknown"):
            codec.assemble(model)
        with self.assertRaises(ValueError):
            codec.assemble(model, external_symbols={"Elsewhere": True})

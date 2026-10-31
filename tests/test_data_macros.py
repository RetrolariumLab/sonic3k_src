"""Emitting data macros cannot hide executable bytes or unchecked file inputs."""

import copy
import unittest

from scripts.validation.data_macros import REVIEWED_MACROS, check_data_macros, definition_hash, macro_definitions
from scripts.validation.source_layout import check_data_graph, check_ledger


def fixture():
    text = "\n".join(name + " macro\n dc.w 0\n endm\n" for name in sorted(REVIEWED_MACROS))
    sources = {"src/macros.s": text}
    records = [
        {
            "name": name,
            "source": "src/macros.s",
            "sha256": definition_hash(body),
            "reason": "Synthetic data declaration",
        }
        for name, body in macro_definitions(text).items()
    ]
    return sources, {"schema_version": 1, "definitions": records}


class DataMacroContracts(unittest.TestCase):
    def test_changed_or_executable_definitions_fail_even_with_updated_hash(self):
        sources, contract = fixture()
        self.assertEqual(check_data_macros(sources, contract), len(REVIEWED_MACROS))
        broken = {
            "src/macros.s": sources["src/macros.s"].replace(
                "palscriptdata macro\n dc.w 0", "palscriptdata macro\n jsr Target"
            )
        }
        with self.assertRaisesRegex(ValueError, "reviewed"):
            check_data_macros(broken, contract)
        updated = copy.deepcopy(contract)
        body = macro_definitions(broken["src/macros.s"])["palscriptdata"]
        next(row for row in updated["definitions"] if row["name"] == "palscriptdata")["sha256"] = definition_hash(body)
        with self.assertRaisesRegex(ValueError, "executable or unknown"):
            check_data_macros(broken, updated)

    def test_missing_duplicate_or_extra_definitions_are_rejected(self):
        sources, contract = fixture()
        missing = copy.deepcopy(contract)
        missing["definitions"].pop()
        with self.assertRaises(ValueError):
            check_data_macros(sources, missing)
        for suffix in (
            "palscriptdata macro\n dc.w 0\n endm\n",
            "palptr macro\n dc.w 0\n endm\n",
            "palptr:macro\n dc.w 0\n endm\n",
        ):
            with self.subTest(suffix=suffix), self.assertRaisesRegex(ValueError, "Duplicate"):
                check_data_macros({"src/macros.s": sources["src/macros.s"] + suffix}, contract)
        extra = dict(sources, **{"src/other.s": "palscriptdata macro\n dc.w 0\n endm\n"})
        with self.assertRaisesRegex(ValueError, "omits, duplicates or adds"):
            check_data_macros(extra, contract)

    def test_unbounded_encoding_or_unchecked_include_cannot_be_approved(self):
        for content in ("codepage LEVELSELECT", "restore", "save", "binclude ALLARGS", "UnknownMacro 0"):
            sources, contract = fixture()
            sources["src/macros.s"] = sources["src/macros.s"].replace(
                "levselstr macro\n dc.w 0", "levselstr macro\n " + content
            )
            body = macro_definitions(sources["src/macros.s"])["levselstr"]
            next(row for row in contract["definitions"] if row["name"] == "levselstr")["sha256"] = definition_hash(body)
            with self.subTest(content=content), self.assertRaises(ValueError):
                check_data_macros(sources, contract)

    def test_palette_file_calls_require_manifest_asset_and_word_frame_capacity(self):
        assets = {"data/palette.bin"}
        for count in ("1", "$80", "65536"):
            check_ledger("Palette: palscriptfile " + count + ', "data/palette.bin"\n', binary_includes=assets)
        for call in (
            'palscriptfile 0, "data/palette.bin"',
            'palscriptfile 65537, "data/palette.bin"',
            'palscriptfile 1, "data/unowned.bin"',
            "palscriptfile 1, DynamicPath",
            'palscriptfile Count, "data/palette.bin"',
        ):
            with self.subTest(call=call), self.assertRaises(ValueError):
                check_ledger(call, binary_includes=assets)


def replaced_fixture(replacements):
    sources, contract = fixture()
    text = sources["src/macros.s"]
    for name, body in replacements.items():
        old = macro_definitions(text)[name]
        text = text.replace(old, name + " macro\n" + body + "\n endm\n")
    sources["src/macros.s"] = text
    definitions = macro_definitions(text)
    for row in contract["definitions"]:
        row["sha256"] = definition_hash(definitions[row["name"]])
    return sources, contract


class EmitterClosureTests(unittest.TestCase):
    def test_loop_endm_does_not_end_macro_or_hide_following_instructions(self):
        sources, contract = replaced_fixture({"org0": " while Count > 0\n dc.b 0\n endm\n dc.w 1"})
        body = macro_definitions(sources["src/macros.s"])["org0"]
        self.assertIn("endm\n dc.w 1", body)
        check_data_macros(sources, contract)
        sources, contract = replaced_fixture({"org0": " while Count > 0\n dc.b 0\n endm\n jsr Target"})
        with self.assertRaisesRegex(ValueError, "executable or unknown"):
            check_data_macros(sources, contract)

    def test_primitive_overrides_cannot_bypass_the_reviewed_closure(self):
        for name in ("dc.b", "binclude", "include", "db", "set", "error", "if"):
            sources, contract = fixture()
            sources["src/macros.s"] += name + ":macro\n jsr Target\n endm\n"
            with self.subTest(name=name), self.assertRaisesRegex(ValueError, "Unchecked override"):
                check_data_macros(sources, contract)

    def test_alignment_helpers_reject_executable_bytes_and_call_cycles(self):
        for body in ("rts", "UnknownCall 0", "palscriptfile 1, Path", "include Path", "codepage LEVELSELECT"):
            sources, contract = replaced_fixture({"even": body})
            with self.subTest(body=body), self.assertRaises(ValueError):
                check_data_macros(sources, contract)
        sources, contract = replaced_fixture({"even": "align0 2", "align0": "even"})
        with self.assertRaisesRegex(ValueError, "Cyclic"):
            check_data_macros(sources, contract)

    def test_helper_controls_and_iteration_boundaries_must_balance(self):
        for body in ("if 1\n dc.b 0", "else", "if 1\n else\n elseif 1\n endif", "while Count\n if 1\n endm\n endif"):
            sources, contract = replaced_fixture({"org0": body})
            with self.subTest(body=body), self.assertRaisesRegex(ValueError, "alignment"):
                check_data_macros(sources, contract)
        for text in ("org0 macro\n while Count\n dc.b 0\n endm\n", "org0 macro\n even macro\n endm\n endm\n"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                macro_definitions(text)

    def test_debug_includes_are_literal_owned_graph_edges(self):
        owners = {"src/debug.s", "src/list.s"}
        self.assertEqual(check_ledger('Debug: dbglistinclude "src/list.s"', owners), ["src/list.s"])
        for call in ("dbglistinclude DynamicPath", 'dbglistinclude "src/unowned.s"', 'dbglistinclude "src/list.s", 1'):
            with self.subTest(call=call), self.assertRaises(ValueError):
                check_ledger(call, owners)
        with self.assertRaisesRegex(ValueError, "Cyclic"):
            check_data_graph({"src/debug.s": ["src/list.s"], "src/list.s": ["src/debug.s"]})

    def test_ledger_alignment_is_literal_bounded_and_helpers_are_not_callable(self):
        for call in ("even", "align 2", "align $1000", "align 32768"):
            check_ledger(call)
        for call in (
            "even 2",
            "align 0",
            "align 1",
            "align 3",
            "align 65536",
            "align Size",
            "org $1000",
            "cnop 0,16",
            "align0 16",
        ):
            with self.subTest(call=call), self.assertRaises(ValueError):
                check_ledger(call)
        check_ledger(
            "plcptr macro plc\n__LABEL__: label (*-Offs_PLC)/2\n dc.w plc-Offs_PLC\n endm\nPLCID: plcptr PLC_AIZ\n"
        )

    def test_debug_macro_cannot_approve_a_different_include_parameter(self):
        for body in ("include OtherPath", 'include "src/list.s"', "binclude path"):
            sources, contract = replaced_fixture({"dbglistinclude": body})
            with self.subTest(body=body), self.assertRaisesRegex(ValueError, "unchecked"):
                check_data_macros(sources, contract)


if __name__ == "__main__":
    unittest.main()

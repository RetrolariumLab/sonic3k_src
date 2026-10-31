"""Emitting data macros cannot hide executable bytes or unchecked file inputs."""

import copy
import unittest

from scripts.validation.data_macros import REVIEWED_MACROS, check_data_macros, definition_hash, macro_definitions
from scripts.validation.source_layout import check_ledger


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


if __name__ == "__main__":
    unittest.main()

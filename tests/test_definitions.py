"""Definition owners cannot conceal emission or skip assembled address checks."""

import unittest

from scripts.validation.definitions import check_definitions, check_nonemitting_range
from scripts.validation.source_layout import check_ledger, validate_entry


class DefinitionOwnershipTests(unittest.TestCase):
    def test_helper_bodies_are_declarations_but_outside_instructions_are_not(self):
        library = "Count: equ 2\nHelper macro\n while Count\n move.w d0,d1\n endm\n rts\n endm\n"
        self.assertEqual(check_definitions(library), 1)
        for instruction in ("rts", "dc.w 0", "Helper", "org $100", "phase $FF0000", 'include "src/unowned.s"'):
            for changed in (instruction + "\n" + library, library + instruction + "\n"):
                with self.subTest(instruction=instruction), self.assertRaises(ValueError):
                    check_definitions(changed)

    def test_macro_boundaries_cannot_hide_later_emission(self):
        for text in ("Helper macro\n while 1\n dc.b 0\n endm\n", "Helper macro\n dc.b 0\n endm\n dc.w 1\n"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                check_definitions(text)

    def test_compiler_options_and_encoding_context_are_explicit(self):
        check_definitions(
            "padding off\nlisting purecode\nsupmode on\npage 0\nsave\ncodepage LEVELSELECT\ncharset 'A','Z',30\nrestore\n"
        )
        for text in (
            "padding on",
            "page 1",
            "restore",
            "save",
            "codepage LEVELSELECT",
            "save\ncodepage OTHER\nrestore",
            "charset 'A',1",
        ):
            with self.subTest(text=text), self.assertRaises(ValueError):
                check_definitions(text)

    def test_built_declarations_must_preserve_the_cartridge_cursor(self):
        check_nonemitting_range(0, 0)
        check_nonemitting_range(0x1000, 0x1000)
        for start, end in ((0, 1), (0x1000, 0), (0x1000, 0x1002)):
            with self.subTest(start=start, end=end), self.assertRaises(ValueError):
                check_nonemitting_range(start, end)

    def test_roles_and_address_spaces_cannot_evade_ownership_checks(self):
        text = "; declaration\n" * 25
        row = {
            "path": "src/macros.s",
            "owner": "system/assembly",
            "responsibility": "Synthetic definitions",
            "role": "definitions",
            "status": "owned",
            "physical_lines": 25,
            "origin": {"commit": "baseline", "path": "old.s", "first_line": 1, "last_line": 25},
        }
        self.assertTrue(validate_entry(row, text))
        for fields in ({"role": "unchecked"}, {"address_space": "unchecked"}, {"role": "code"}):
            with self.subTest(fields=fields), self.assertRaises(ValueError):
                validate_entry(dict(row, **fields), text)

    def test_named_equates_do_not_enable_other_declarations_in_data(self):
        check_ledger("Flag EQU 0\nOther: equ Flag+1\n dc.w Other\n")
        for text in ("Flag set 0", "Func function x,x+1", "Entry jsr Target"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                check_ledger(text)


if __name__ == "__main__":
    unittest.main()

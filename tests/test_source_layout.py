"""Source ownership cannot hide executable pages behind data exceptions."""

import unittest

from scripts.validation.source_layout import check_ledger, parse_include_ranges, validate_entry


class SourceLayoutTests(unittest.TestCase):
    def test_rom_ranges_follow_include_depth_not_macro_expansion_rows(self):
        text = ' 10/ 1000 : Map: include "src/map.s"\n(1) 1/ 1000 : Frame: dc.w 1\n(1) 2/ 1002 : dc.w 2\n 11/ 1004 : Next: dc.w 0\n'
        self.assertEqual(
            parse_include_ranges(text, {"src/map.s"}), [{"path": "src/map.s", "start": 0x1000, "end": 0x1004}]
        )
        with self.assertRaisesRegex(ValueError, "Unclosed"):
            parse_include_ranges(text.split(" 11/")[0], {"src/map.s"})

    def test_pending_ownership_is_visible_and_never_accepted(self):
        row = {
            "path": "pending.s",
            "physical_lines": 1,
            "owner": "pending/engine",
            "responsibility": "Pending extraction",
            "role": "pending",
            "status": "pending",
            "origin": {"commit": "baseline", "path": "old.s", "first_line": 1, "last_line": 1},
        }
        self.assertFalse(validate_entry(row, "rts\n", inventory=True))
        with self.assertRaisesRegex(ValueError, "pending"):
            validate_entry(row, "rts\n")

    def test_a_data_ledger_rejects_instructions_and_unknown_macros(self):
        check_ledger("Table:\n dc.w Frame-Table\nFrame:\n dc.b 1,2\n even\n")
        for text in ("Entry:\n rts\n", "macro\n dc.w 1\n", "endm\n", "macro\n jsr Target\n endm\n"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                check_ledger(text)

    def test_large_code_cannot_use_a_data_ledger_exception(self):
        row = {
            "path": "src/game/control.s",
            "physical_lines": 2001,
            "owner": "game/control",
            "responsibility": "Synthetic control module",
            "role": "code",
            "status": "owned",
            "origin": {"commit": "baseline", "path": "old.s", "first_line": 1, "last_line": 2001},
            "size_exception": {
                "kind": "data-ledger",
                "reason": "Incorrect claim",
                "proof_target": "check-source-layout",
            },
        }
        with self.assertRaisesRegex(ValueError, "hard review"):
            validate_entry(row, "nop\n" * 2001)

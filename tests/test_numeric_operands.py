"""Numeric operand checks reject hidden addresses without confusing displacements."""

import unittest

from scripts.validation.numeric_operands import candidates, check_records, operands


class NumericOperandTests(unittest.TestCase):
    def test_numeric_addresses_and_pc_offsets_are_rejected(self):
        forms = (
            "jsr $1234",
            "bra.w $1234",
            "dbf d0,$1234",
            "lea $30,a2",
            "pea ($1234).l",
            "movea.l #$1234,a0",
            "move.w $30,d0",
            "tst.b 0",
            "move.l ($FF2000).l,d0",
            "lea $20(pc),a0",
            "move.w $20(pc,d0.w),d0",
        )
        for form in forms:
            with self.subTest(form=form):
                rows = list(candidates("fixture.s", "Entry:\n " + form))
                self.assertTrue(rows)
                with self.assertRaisesRegex(ValueError, "unexpected"):
                    check_records(rows, [])

    def test_symbols_field_displacements_and_quoted_text_are_not_addresses(self):
        text = """Entry:
 lea $30(a0),a2
 move.w field(a0),d0
 move.l #Target,d0
 lea Table-$20(pc,d0.w),a0
 move.w #$30,d0
 dc.b "literal;comma,word"
 bra.w Target
"""
        self.assertEqual(list(candidates("fixture.s", text)), [])
        self.assertEqual(operands('Table(pc,d0.w),"a,b",a2'), ["Table(pc,d0.w)", '"a,b"', "a2"])

    def test_restore_returns_to_68000_and_z80_controls_are_checked(self):
        text = """Entry:
 save
 cpu Z80
 call 1234h
 jr nz,$1234
 djnz $
 restore
 jsr $1234
"""
        rows = list(candidates("fixture.s", text))
        self.assertEqual([r["kind"] for r in rows], ["z80-control", "z80-control", "control"])
        with self.assertRaisesRegex(ValueError, "Unbalanced"):
            list(candidates("fixture.s", "restore"))

    def test_scalar_exception_is_exact_and_cannot_exempt_an_address(self):
        rows = list(candidates("fixture.s", "Weights:\n dc.l 100000\n dc.l 100000"))
        exception = {
            "path": "fixture.s",
            "owner": "Weights",
            "kind": "rom-range-long",
            "operand": "100000",
            "count": 2,
            "type": "decimal-digit-weight",
            "reason": "Synthetic digit table.",
        }
        check_records(rows, [exception])
        with self.assertRaisesRegex(ValueError, "stale"):
            check_records(rows[:1], [exception])
        with self.assertRaisesRegex(ValueError, "unexpected"):
            check_records(rows + rows[:1], [exception])
        with self.assertRaisesRegex(ValueError, "Invalid"):
            check_records(rows, [exception, exception])
        with self.assertRaisesRegex(ValueError, "Invalid"):
            check_records([], [exception | {"kind": "control"}])

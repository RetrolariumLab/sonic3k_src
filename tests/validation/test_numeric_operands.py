"""Numeric operand checks reject hidden addresses without confusing displacements."""

import unittest

from scripts.validation.constant_expressions import Resolver
from scripts.validation.numeric_operands import candidates, check_records, constant_definitions, operands


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

    def test_stack_pointer_and_all_address_register_loads_are_checked(self):
        for instruction in ("move.w", "move.l", "movea.w", "movea.l"):
            for register in ("sp", "SP", *("a" + str(i) for i in range(8))):
                with self.subTest(instruction=instruction, register=register):
                    rows = list(candidates("fixture.s", f"Entry:\n {instruction} #$1234,{register}"))
                    self.assertIn("immediate-address-register", [row["kind"] for row in rows])

    def test_numeric_aliases_cannot_hide_address_operands(self):
        for declaration in (
            "Alias equ $1234",
            "Alias: equ $1234",
            "Alias set $1234",
            "Alias = $1234",
            "Alias := $1234",
        ):
            for instruction in (
                "jsr Alias",
                "bra.w Alias",
                "dbf d0,Alias",
                "lea Alias,a0",
                "pea Alias",
                "movea.l #Alias,sp",
                "move.w Alias,d0",
                "tst.b (Alias).l",
                "lea Alias(pc),a0",
                "move.w Alias(pc,d0.w),d0",
            ):
                with self.subTest(declaration=declaration, instruction=instruction):
                    rows = list(candidates("fixture.s", declaration + "\nEntry:\n " + instruction))
                    self.assertTrue(rows)
                    with self.assertRaisesRegex(ValueError, "unexpected"):
                        check_records(rows, [])

    def test_forward_local_and_cross_file_chains_resolve_case_insensitively(self):
        aliases = constant_definitions("Base equ $1200\nAlias equ BASE+$34")
        text = "Entry:\n movea.l #.return,sp\n.return equ Next\nNext equ alias"
        rows = list(candidates("fixture.s", text, aliases=aliases))
        self.assertEqual(rows[0]["values"], [0x1234])
        self.assertEqual(rows[0]["owner"], "Entry")
        self.assertEqual(list(candidates("fixture.s", "Entry:\n bra.w .return\n.return:\n rts")), [])

    def test_constant_expression_longwords_and_all_alternatives_are_checked(self):
        text = "Pointer equ ($12000+%100)/2\nData:\n dc.l Pointer"
        self.assertEqual(list(candidates("fixture.s", text))[0]["values"], [0x9002])
        aliases = {"alias": ["$FF0000", "$1234", "Procedure+4"]}
        rows = list(candidates("fixture.s", "Entry:\n jsr Alias", aliases=aliases))
        self.assertEqual(rows[0]["values"], [0x1234, 0xFF0000])

    def test_symbolic_interfaces_and_word_sign_extension_remain_valid(self):
        text = """Ram equ $FF0000
Port equ $C00004
ShortRam equ $FFFF
ProcedureAlias equ Procedure+4
Entry:
 movea.l #Ram,a0
 movea.l #Port,sp
 movea.w #ShortRam,a1
 move.w (ShortRam).w,d0
 jsr ProcedureAlias
 move.w Ram,d0
 bra.w +
 bra.w --
 DebugObject Label
 DebugOff
"""
        self.assertEqual(list(candidates("fixture.s", text)), [])
        rows = list(candidates("fixture.s", "Alias equ $FFFF\nEntry:\n movea.l #Alias,a1"))
        self.assertEqual(rows[0]["values"], [0xFFFF])

    def test_failed_numeric_resolution_is_not_a_bypass(self):
        for definitions in ("Alias equ Next\nNext equ Alias", "Alias equ 1<<100", "Alias equ 1/0", "Alias equ 2**8"):
            with self.subTest(definitions=definitions):
                self.assertTrue(list(candidates("fixture.s", definitions + "\nEntry:\n jsr Alias")))

    def test_expression_arithmetic_uses_assembler_integer_division(self):
        resolver = Resolver({})
        for expression, value in (
            ("-7/3", -2),
            ("-7%3", -1),
            ("7/-3", -2),
            ("(1234h | %101) & $FFFF", 0x1235),
            ("~0", -1),
        ):
            with self.subTest(expression=expression):
                self.assertEqual(resolver.resolve(expression).values, {value})
        self.assertTrue(resolver.resolve("*+$20").symbolic)
        self.assertTrue(resolver.resolve("$+4").symbolic)

    def test_spaced_multiplication_cannot_be_mistaken_for_current_pc(self):
        for expression in ("2 * $1234", "$1200 * 1", "(2 + 3) * 16", "2*$1234"):
            with self.subTest(expression=expression):
                rows = list(candidates("fixture.s", "Alias equ " + expression + "\nEntry:\n jsr Alias"))
                self.assertTrue(rows)
                self.assertTrue(rows[0]["values"])
        resolver = Resolver({})
        for expression in ("*", "*+$20", "$+4", "2 * *", "3*(*)"):
            with self.subTest(expression=expression):
                self.assertTrue(resolver.resolve(expression).symbolic)
        self.assertTrue(resolver.resolve("2 ** 8").unresolved)
        collision = Resolver({"__asm_current_pc": ["$1234"]})
        self.assertTrue(collision.resolve("*+4").symbolic)
        self.assertEqual(collision.resolve("__asm_current_pc").values, {0x1234})

    def test_fixed_interface_exception_binds_instruction_value_and_count(self):
        source = "Stride equ 16\nEntry:\n movea.w #Stride,a3"
        rows = list(candidates("fixture.s", source))
        exception = {key: rows[0][key] for key in ("path", "owner", "kind", "operand", "code", "values")}
        exception.update(count=1, type="address-register-scalar", reason="Sixteen-pixel scalar step.")
        check_records(rows, [exception])
        for changed in (
            source.replace("16", "17"),
            source.replace("a3", "a4"),
            source.replace("movea.w", "movea.l"),
            source.replace("Entry:", "Other:"),
            source + "\n movea.w #Stride,a3",
        ):
            with self.subTest(changed=changed), self.assertRaises(ValueError):
                check_records(list(candidates("fixture.s", changed)), [exception])
        with self.assertRaises(ValueError):
            check_records(list(candidates("other.s", source)), [exception])
        with self.assertRaises(ValueError):
            check_records([], [exception])
        for invalid in (
            {"code": ""},
            {"values": []},
            {"values": [True]},
            {"values": [16, 16]},
            {"count": True},
            {"type": "any-address"},
        ):
            with self.subTest(invalid=invalid), self.assertRaises(ValueError):
                check_records(rows, [exception | invalid])

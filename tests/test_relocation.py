"""Procedure and matrix regressions protect fallthrough, slots and completeness."""

import copy
import unittest

from scripts.validation.cohorts import (
    collect_file,
    render,
    statements,
    protection_spans,
    table_slot,
    validate_ownership,
)
from scripts.build.relocation import check_bank_storage, check_coverage, digest


class CohortTests(unittest.TestCase):
    def test_lost_procedure_or_return_ownership_is_rejected(self):
        result = collect_file("fixture.s", "Entry:\n rts\n; End of function Entry\n")
        result["points"][0]["members"] = []
        with self.assertRaisesRegex(ValueError, "procedure ownership"):
            validate_ownership(result)
        result = collect_file("fixture.s", "Entry:\n rts\n; End of function Entry\n")
        result["returns"][0]["cohort"] = 999
        with self.assertRaisesRegex(ValueError, "return site"):
            validate_ownership(result)

    def test_z80_function_annotations_do_not_become_68000_cohorts(self):
        result = collect_file("driver.s", "cpu Z80\nFunction:\n ret\n; End of function Function\n")
        self.assertEqual(result["procedures"], [])
        self.assertEqual(result["points"], [])
        self.assertEqual(result["returns"], [])

    def test_fallthrough_aliases_share_the_actual_terminal(self):
        text = "A:\n moveq #0,d0\n; End of function A\nB:\n rts\n; End of function B\n"
        result = collect_file("fixture.s", text)
        self.assertEqual(len(result["points"]), 1)
        self.assertEqual(result["points"][0]["members"], ["A", "B"])
        output = render(text, result["points"])
        self.assertIn("moveq #0,d0\n; End of function A\nB:", output)
        self.assertEqual(output.count("rts"), 2)

    def test_unmarked_helper_between_markers_remains_a_probe_boundary(self):
        text = "A:\n rts\n; End of function A\nHelper:\n rts\nB:\n rts\n; End of function B\n"
        result = collect_file("fixture.s", text)
        self.assertEqual([r["after"] for r in result["points"]], [3, 5, 8])
        self.assertEqual(len(result["returns"]), 3)

    def test_short_conditional_span_keeps_internal_returns_together(self):
        text = "A:\n beq.s Done\n rts\nHelper:\n rts\nDone:\n rts\n"
        result = collect_file("fixture.s", text)
        self.assertEqual([r["after"] for r in result["points"]], [7])
        self.assertEqual({r["cohort"] for r in result["returns"]}, {7})
        self.assertEqual(len(result["merges"]), 2)

    def test_indexed_two_byte_return_slots_cannot_grow(self):
        text = "Dispatch:\n jmp Table(pc,d0.w)\nTable:\n rts\nSlot2:\n bra.s Handler\nHandler:\n rts\n"
        result = collect_file("fixture.s", text)
        self.assertEqual([r["after"] for r in result["points"]], [8])
        self.assertTrue(table_slot(text.splitlines(keepends=True), 5))
        self.assertTrue(result["tables"])

    def test_indexed_pc_table_displacement_remains_inseparable(self):
        text = "Entry:\n move.w Weights(pc,d0.w),d0\n rts\nWeights:\n dc.w 1\nNext:\n rts\n"
        result = collect_file("fixture.s", text)
        self.assertEqual([p["after"] for p in result["points"]], [7])
        self.assertIn("indexed-pc-byte-displacement", result["merges"][0]["reason"])

    def test_qualified_local_and_anonymous_short_branches_resolve(self):
        text = "Entry:\n bne.s Entry.done\n bne.s +\n +:\n beq.s -\n -:\n.done:\n rts\n"
        # Backward '-' labels must precede their branch.
        text = text.replace(" beq.s -\n -:", " -:\n beq.s -")
        spans, _ = protection_spans(statements(text))
        self.assertEqual(len(spans), 3)
        with self.assertRaisesRegex(ValueError, "Unresolved"):
            collect_file("fixture.s", "Entry:\n bne.s Missing\n rts\n")

    def test_startup_guard_precedes_the_fallthrough_error_trap(self):
        text = "Header:\n dc.b 0\nErrorTrap:\n nop\nEntryPoint:\n rts\n"
        result = collect_file("fixture.s", text)
        output = render(text, result["points"], "ErrorTrap")
        self.assertIn("rts\nErrorTrap:\n nop\nEntryPoint:", output)
        with self.assertRaisesRegex(ValueError, "Startup"):
            render(text, [], "Missing")


class BankStorageTests(unittest.TestCase):
    def test_bank_data_is_fixed_while_earlier_engine_bytes_can_move(self):
        symbols = {"Snd_Bank1_Start": 0xFF00, "Snd_Bank2_Start": 0x10000, "SndBank": 0x18000}
        original = b"A" * 0x20000
        before = bytearray(original)
        before[0x200] = 0x42
        check_bank_storage(symbols, original, bytes(before))
        before[0x18020] = 0x42
        with self.assertRaisesRegex(ValueError, "bank storage"):
            check_bank_storage(symbols, original, bytes(before))
        with self.assertRaisesRegex(ValueError, "Unaligned"):
            check_bank_storage(symbols | {"SndBank": 0x18002}, original, original)


class MatrixCoverageTests(unittest.TestCase):
    def setUp(self):
        self.plan = {"groups": 2, "points": [{"id": "a"}, {"id": "b"}, {"id": "c"}]}
        self.manifest = {
            "complete": True,
            "plan_sha256": digest(self.plan),
            "variants": [
                {"id": "g0", "group": 0, "insertions": ["a", "c"], "artifacts": {"us": {}, "eu": {}}},
                {"id": "g1", "group": 1, "insertions": ["b"], "artifacts": {"us": {}, "eu": {}}},
            ],
        }

    def test_missing_group_profile_or_cohort_cannot_pass(self):
        check_coverage(self.plan, self.manifest, ["us", "eu"])
        variants = []
        value = copy.deepcopy(self.manifest)
        value["variants"].pop()
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["variants"][0]["insertions"].pop()
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["variants"][0]["insertions"].append("a")
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["variants"][1]["artifacts"].pop("eu")
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["variants"][1]["group"] = 0
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["complete"] = False
        variants.append(value)
        value = copy.deepcopy(self.manifest)
        value["plan_sha256"] = "stale"
        variants.append(value)
        for value in variants:
            with self.subTest(value=value), self.assertRaises(ValueError):
                check_coverage(self.plan, value, ["us", "eu"])

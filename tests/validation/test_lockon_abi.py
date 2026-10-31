"""Negative checks for stale and mismatched lock-on export contracts."""

import copy
import unittest

from scripts.validation.lockon import check_exports, check_fixed, source_exports
from scripts.validation.symbols import parse_symbols


class SymbolTableTests(unittest.TestCase):
    def test_unused_and_extended_ram_symbols_are_not_lost(self):
        symbols = parse_symbols("*Unused : 200011 C | Target : 100 - |\n RAM : FFFFFFFFFFFFF600 C |")
        self.assertEqual(symbols, {"Unused": 0x200011, "Target": 0x100, "RAM": 0xFFFFF600})

    def test_conflicting_and_missing_tables_fail(self):
        for text in ("not an AS table", "A : 1 C | A : 2 C |"):
            with self.assertRaises(ValueError):
                parse_symbols(text)


class LockOnTests(unittest.TestCase):
    def setUp(self):
        self.contract = {
            "base": "0x200000",
            "exports": [
                {"external": "HeaderAlias", "target": "Header", "addend": 4},
                {"external": "EndAlias", "target": "End"},
            ],
        }
        self.internal = {"Header": 0x100, "End": 0x200}
        self.external = {"HeaderAlias": 0x200104, "EndAlias": 0x200200}
        self.declared = {"HeaderAlias", "EndAlias"}

    def check(self, contract=None, internal=None, external=None):
        return check_exports(
            contract or self.contract, self.declared, internal or self.internal, external or self.external, 0x200
        )

    def test_interior_and_end_boundary_aliases(self):
        self.assertEqual(self.check(), 2)
        self.assertEqual(source_exports("; Ignored:\nHeaderAlias: ds.b 4\nEndAlias: ds.b 0"), self.declared)

    def test_a_moved_target_fails_even_when_export_stays_fixed(self):
        with self.assertRaisesRegex(ValueError, "differs"):
            self.check(internal={"Header": 0x102, "End": 0x200})

    def test_duplicate_missing_and_out_of_bounds_exports_fail(self):
        for entries in (
            self.contract["exports"][:1],
            self.contract["exports"] * 2,
            [{"external": "HeaderAlias", "target": "Missing"}, self.contract["exports"][1]],
        ):
            changed = copy.deepcopy(self.contract)
            changed["exports"] = entries
            with self.assertRaises(ValueError):
                self.check(contract=changed)
        with self.assertRaisesRegex(ValueError, "leaves"):
            self.check(internal={"Header": 0x300, "End": 0x200})


class FixedRegionTests(unittest.TestCase):
    def test_window_alignment_and_hardware_positions(self):
        contract = {
            "regions": [
                {"id": "vectors", "owner": "Vectors", "base": "0x0"},
                {"id": "window", "tail_aligned_start": "Bank", "tail_allocation": "Size", "window_bytes": 0x8000},
            ]
        }
        check_fixed(contract, {"Vectors": 0, "Bank": 0x7F00, "Size": 0x100})
        for wrong in ({"Vectors": 2, "Bank": 0x7F00, "Size": 0x100}, {"Vectors": 0, "Bank": 0x7F02, "Size": 0x100}):
            with self.assertRaises(ValueError):
                check_fixed(contract, wrong)

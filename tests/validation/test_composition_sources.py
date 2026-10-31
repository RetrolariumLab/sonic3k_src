"""Include-only entries, bank capacities and original cartridge-tail templates."""

import unittest
from scripts.validation import composition_sources as codec


class CompositionSourceTests(unittest.TestCase):
    def test_entry_contains_only_owned_sources_and_a_final_end(self):
        owners = {"owner.s": {"role": "code"}}
        spec = {"kind": "entry", "profiles": ["s3-us"]}
        self.assertEqual(codec.check('include "owner.s"\nEND', spec, owners, set()), ["owner.s"])
        for text in (
            'include "missing.s"\nEND',
            'binclude "blob.bin"\nEND',
            'include "owner.s"\nrts\nEND',
            'END\ninclude "owner.s"',
            'include "owner.s"',
        ):
            with self.subTest(text=text), self.assertRaises(ValueError):
                codec.check(text, spec, owners, {"blob.bin"})

    def test_bank_grammar_requires_checked_payloads_and_one_start_finish(self):
        spec = {
            "kind": "bank",
            "alignment": "start",
            "start_symbol": "Bank",
            "end_symbol": None,
            "profiles": ["sk"],
        }
        text = 'Bank: startBank\nSample: binclude "data/sample.bin"\nfinishBank'
        codec.check(text, spec, {}, {"data/sample.bin"})
        for altered in (
            text.replace("finishBank", "rts"),
            text.replace("startBank", "startBank\nOther: startBank"),
            text.replace("data/sample.bin", "data/unknown.bin"),
            text.replace('Sample: binclude "data/sample.bin"', "dc.w $4E75"),
        ):
            with self.subTest(text=altered), self.assertRaises(ValueError):
                codec.check(altered, spec, {}, {"data/sample.bin"})

    def test_bank_bounds_reject_crossings_invalid_alignment_and_capacity(self):
        codec.check_bank_bounds(0x8000, 0x9000, 0x7000, 0x9000, alignment="start")
        codec.check_bank_bounds(0x7F00, 0x8000, 0x7E00, 0x8000, alignment="end", reservation=256)
        # The reserved end aligns even when the actual payload stops earlier.
        codec.check_bank_bounds(0x7F00, 0x7FE0, 0x7E00, 0x7FE0, alignment="end", reservation=256)
        for start, end, mode, cap in (
            (0x7F00, 0x8100, "end", 512),
            (0x8001, 0x9000, "start", None),
            (0x7F00, 0x8000, "end", 255),
            (0x8000, 0x8000, "start", None),
            (0x7F01, 0x7FFF, "end", 256),
        ):
            with self.subTest(start=start, end=end), self.assertRaises(ValueError):
                codec.check_bank_bounds(start, end, 0x7000, 0x9000, alignment=mode, reservation=cap)

    def test_tail_is_a_fixed_product_template_with_no_hidden_code(self):
        spec = {"kind": "tail", "product": "s3", "profiles": ["s3-us"]}
        codec.check("org $200000\nEndOfROM:", spec, {}, set())
        for text in ("org $200001\nEndOfROM:", "org $200000\nrts\nEndOfROM:", "dc.b $FF"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                codec.check(text, spec, {}, set())

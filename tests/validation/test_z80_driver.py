"""Reject Z80 namespace escapes, opaque code replacement and RAM allocation drift."""

import unittest
from scripts.build.project import ROOT
from scripts.validation import z80_driver as codec


class Z80DriverTests(unittest.TestCase):
    def test_renamed_ram_and_code_keep_independent_historical_addresses(self):
        self.assertEqual(
            codec.compare_symbol_addresses(
                {"StopTrackLatch": 0x1C15, "z80_stack": 0x2000},
                {"ResumeDac", "Shared", "Inactive"},
                {"StopTrackLatch": 0x1C15, "z80_stack": 0x2000, "ResumeDac": 0xBE9, "Shared": 7},
                {"unk_1C15": 0x1C15, "z80_stack": 0x2000, "loc_BE9": 0xBE9, "Shared": 7},
                {"unk_1C15": "StopTrackLatch", "loc_BE9": "ResumeDac", "loc_ABCD": "Inactive"},
            ),
            2,
        )

    def test_registered_names_cannot_hide_ram_drift_or_missing_historical_abi(self):
        for current, historical in (
            ({"StopTrackLatch": 0x1C16}, {"unk_1C15": 0x1C15}),
            ({"StopTrackLatch": 0x1C15}, {"unk_1C15": 0x1C16}),
            ({}, {"unk_1C15": 0x1C15}),
            ({"StopTrackLatch": 0x1C15}, {"StopTrackLatch": 0x1C15}),
        ):
            with self.subTest(current=current, historical=historical), self.assertRaises(ValueError):
                codec.compare_symbol_addresses(
                    {"StopTrackLatch": 0x1C15}, set(), current, historical, {"unk_1C15": "StopTrackLatch"}
                )

    def test_renamed_code_entry_is_checked_instead_of_dropped_from_coverage(self):
        for symbols in ({}, {"ResumeDac": 0xBEA}, {"loc_BE9": 0xBE9}):
            with self.subTest(symbols=symbols), self.assertRaises(ValueError):
                codec.compare_symbol_addresses({}, {"ResumeDac"}, symbols, {"loc_BE9": 0xBE9}, {"loc_BE9": "ResumeDac"})

    def test_historical_symbol_projection_rejects_ambiguous_destinations(self):
        with self.assertRaisesRegex(ValueError, "collide"):
            codec.compare_symbol_addresses({}, set(), {}, {}, {"OldA": "New", "OldB": "New"})

    def test_real_ram_layout_has_independent_field_and_overlay_offsets(self):
        text = (ROOT / "src/audio/driver/ram_layout.asm").read_text()
        model = codec.ram_declarations(text)
        symbols = model["symbols"]
        self.assertEqual(model["track_instances"], 25)
        self.assertEqual(symbols["zTrack.len"], 48)
        self.assertEqual(symbols["zTrack.SavedDAC"], symbols["zTrack.FreqLow"])
        self.assertEqual(symbols["zSongFM1.PlaybackControl"], 0x1C70)
        self.assertEqual(symbols["zTracksSaveStart"], symbols["zTracksSFXStart"])
        self.assertEqual(symbols["zTempVariablesEnd"], 0x1FA0)

    def test_ram_rejects_initialized_bytes_executable_code_and_stack_overflow(self):
        text = (ROOT / "src/audio/driver/ram_layout.asm").read_text()
        for changed in (
            text.replace("padding off", "CPU Z80", 1),
            text.replace("ds.b 1", "db 0", 1),
            text.replace("ds.b 1", "ds.b 2", 1),
            text.replace("phase   zTracksSFXStart", "phase   zDataStart", 1),
            text + "\nld a,0\n",
            text.replace("$2000", "$2001", 1),
        ):
            with self.subTest(source=changed[-120:]), self.assertRaises(ValueError):
                codec.ram_declarations(changed)

    def test_code_requires_cpu_and_disallows_context_changes_or_opaque_payloads(self):
        spec = {"kind": "code", "context": "code"}
        prefix = "CPU Z80\nlisting purecode\n"
        codec.check_module(prefix + "Entry: ld a,0\nret\n", spec)
        for body in (
            "org $8000\nret",
            "CPU 68000\nret",
            "save\nret",
            'include "other.s"\nret',
            'binclude "data/Sound/Driver/Payloads/shared/modenv_01.bin"\nret',
            "db $C9",
            "rts",
        ):
            with self.subTest(body=body), self.assertRaises(ValueError):
                codec.check_module(prefix + body, spec)
        with self.assertRaises(ValueError):
            codec.check_module("Entry: ret", spec)

    def test_data_and_definitions_cannot_execute_instructions(self):
        prefix = "CPU Z80\nlisting purecode\n"
        codec.check_module(prefix + "Table: dw $1234", {"kind": "data", "context": "tables"})
        codec.check_module(prefix + "Value: equ 1", {"kind": "definitions", "context": "code"})
        for spec, body in (
            ({"kind": "data", "context": "tables"}, "ld a,0"),
            ({"kind": "definitions", "context": "code"}, "db 0"),
            ({"kind": "data", "context": "tables"}, 'binclude "data/unknown.bin"'),
            ({"kind": "data", "context": "tables"}, "bankswitch1 macro\nld a,0\nendm"),
        ):
            with self.subTest(spec=spec, body=body), self.assertRaises(ValueError):
                codec.check_module(prefix + body, spec)

    def test_helpers_reject_unbounded_or_unknown_macro_loops(self):
        prefix = "CPU Z80\nlisting purecode\n"
        good = "bankswitch1 macro\nrept 7\nrrca\nendm\nendm"
        codec.check_module(prefix + good, {"kind": "definitions", "context": "code"})
        for body in (
            good.replace("rept 7", "while 1"),
            good.replace("rept 7", "rept count"),
            good.replace("bankswitch1", "db"),
            good.replace("rrca", 'include "hidden.s"'),
        ):
            with self.subTest(body=body), self.assertRaises(ValueError):
                codec.check_module(prefix + body, {"kind": "definitions", "context": "code"})

    def test_statement_proof_accepts_comments_but_rejects_same_byte_substitution(self):
        codec.preserve_statements("Entry: ret ; original", "  Entry:  ret ; moved", "owner")
        for changed in ("Entry: db $C9", "Other: ret", "Entry: nop\nret", "ret\nEntry:"):
            with self.subTest(changed=changed), self.assertRaises(ValueError):
                codec.preserve_statements("Entry: ret", changed, "owner")
        with self.assertRaises(ValueError):
            codec.preserve_statements('binclude "data/first file.bin"', 'binclude "data/firstfile.bin"', "owner")

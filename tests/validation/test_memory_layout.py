"""Non-emitting memory grammar, odd SRAM, bounded phases and primitive ownership."""

import unittest
from scripts.validation import memory_layout as codec
from scripts.build.project import ROOT, load
from scripts.validation.symbols import parse_declaration_symbols


def contract(kind="ram", phases=None, rewind=False):
    return {
        "kind": kind,
        "phases": phases if phases is not None else ["$FFFF0000"],
        "rewind": rewind,
        "profiles": ["s3-us"],
    }


class MemoryLayoutTests(unittest.TestCase):
    def test_all_project_memory_modules_match_their_registered_contracts(self):
        owners = [row for row in load("config/reconstruction/source_layout.json")["files"] if row["role"] == "memory"]
        self.assertTrue(owners)
        texts = {row["path"]: (ROOT / row["path"]).read_text(encoding="utf-8") for row in owners}
        codec.check_primitives(texts)
        for row in owners:
            with self.subTest(path=row["path"]):
                codec.declarations(texts[row["path"]], row["memory_contract"])

    def test_ram_fields_aliases_and_balanced_phase_are_declarations(self):
        text = "padding off\nphase $FFFF0000\nRAM_start: equ *\nField: ds.b 3\nAlias: set Field+1\nRAM_end: equ *\ndephase\n"
        model = codec.declarations(text, contract())
        self.assertEqual(model["symbols"], ["Alias", "Field", "RAM_end", "RAM_start"])
        self.assertEqual([row["name"] for row in model["fields"]], ["RAM_start", "Field", "RAM_end"])

    def test_instructions_initialized_storage_includes_and_context_changes_fail(self):
        for body in (
            "dc.b 1",
            "ds.b 1,0",
            'include "data.s"',
            'binclude "data.bin"',
            "cpu Z80",
            "padding on",
            "rts",
            "org $100",
            "!org 0",
        ):
            text = "padding off\nphase $FFFF0000\n" + body + "\ndephase\n"
            with self.subTest(body=body), self.assertRaises(ValueError):
                codec.declarations(text, contract())

    def test_phase_list_nested_scope_and_missing_explicit_padding_fail(self):
        for text in (
            "phase $FFFF0000\nA: ds.b 1\ndephase",
            "padding off\nphase $FFFF0000\nphase $FFFF0010\ndephase\ndephase",
            "padding off\nphase $FFFF0010\nA: ds.b 1\ndephase",
            "padding off\nphase $FFFF0000\nA: ds.b 1",
            "padding off\nA: ds.b 1",
            "padding off\ndephase",
        ):
            with self.subTest(text=text), self.assertRaises(ValueError):
                codec.declarations(text, contract())

    def test_sram_word_stride_and_cursor_rewind_are_explicit(self):
        text = "padding off\nphase $200001\nSlot: ds.w 4\ndephase\n"
        model = codec.declarations(text, contract("sram", ["$200001"]))
        self.assertEqual(model["symbols"], ["Slot"])
        with self.assertRaises(ValueError):
            codec.declarations(text.replace("ds.w", "ds.b"), contract("sram", ["$200001"]))
        codec.declarations("padding off\n!org 0", contract("cursor", [], True))
        with self.assertRaises(ValueError):
            codec.declarations("padding off\n!org $100", contract("cursor", [], True))

    def test_capacity_diagnostic_cannot_hide_executable_source(self):
        text = 'padding off\nphase $FFFF0000\n.check: equ (*)&$FFFFFF\nif (.check>0)&(.check<$FF0000)\nfatal "RAM capacity exceeded"\nendif\ndephase'
        codec.declarations(text, contract())
        with self.assertRaises(ValueError):
            codec.declarations(text.replace('fatal "RAM capacity exceeded"', "nop"), contract())

    def test_memory_domains_and_primitive_redefinitions_are_bounded(self):
        codec._domain("Field", 0xFFFF0010, "ram")
        codec._domain("RAM_end", 0, "ram")
        codec._domain("Slot", 0x200001, "sram")
        codec._domain("ID", 255, "enumerations")
        for name, value, kind in (
            ("Field", 0xFFFEFFFF, "ram"),
            ("Field", 0, "ram"),
            ("Slot", 0x200002, "sram"),
            ("Slot", 0x200801, "sram"),
            ("ID", 256, "enumerations"),
        ):
            with self.subTest(name=name, value=value), self.assertRaises(ValueError):
                codec._domain(name, value, kind)
        with self.assertRaises(ValueError):
            codec.check_primitives({"unsafe.s": "ds.b macro count\n dc.b 0\n endm"})

    def test_quoted_checksum_constants_remain_typed_and_are_not_code_addresses(self):
        text = " Field : FFFF0010 - | Ref_Checksum_String : 'init' - |\n"
        result = parse_declaration_symbols(text)
        self.assertEqual(result, {"Field": 0xFFFF0010, "Ref_Checksum_String": "'init'"})
        with self.assertRaises(ValueError):
            codec._domain("Field", "'init'", "ram")

    def test_external_cartridge_has_an_exact_nonemitting_two_mib_cursor(self):
        helper = (
            "DACDECLARE macro dataSize,sampleRate\n .sample_rate: equ sampleRate\n"
            " .size: equ dataSize\n ds.b dataSize\n endm\n"
        )
        text = (
            "padding off\nphase $200000\nStart: ds.b $10\n"
            + helper
            + "Sample: DACDECLARE $20,13332\nTail: ds.b $1FFFD0\ndephase"
        )
        model = codec.declarations(text, contract("external", ["$200000"]))
        self.assertEqual(model["external_bytes"], 0x200000)
        self.assertEqual([row["external_offset"] for row in model["fields"]], [0, 16, 48])
        for altered in (
            text.replace("$1FFFD0", "$1FFFD1"),
            text.replace("$1FFFD0", "$1FFFCF"),
            text.replace("ds.b dataSize", "dc.b dataSize"),
            text.replace("$20,13332", "$20,999999"),
            text.replace("phase $200000", "phase $200001"),
        ):
            with self.subTest(text=altered), self.assertRaises(ValueError):
                codec.declarations(altered, contract("external", ["$200000"]))
        codec._domain("External", 0x200000, "external")
        codec._domain("External_end", 0x400000, "external")
        with self.assertRaises(ValueError):
            codec._domain("External", 0x400001, "external")

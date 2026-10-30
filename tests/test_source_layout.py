"""Source ownership cannot hide executable pages behind data exceptions."""

import unittest

from scripts.validation.source_layout import check_data_graph, check_ledger, parse_include_ranges, validate_entry


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


class DataIncludeTests(unittest.TestCase):
    def test_only_owned_data_and_manifest_assets_can_be_included(self):
        text = 'Map: include "src/map.s"\nArt: binclude "data/art.nem"\n even\n'
        self.assertEqual(check_ledger(text, {"src/map.s"}, {"data/art.nem"}), ["src/map.s"])
        for source, binary in ((set(), {"data/art.nem"}), ({"src/map.s"}, set())):
            with self.subTest(source=source, binary=binary), self.assertRaisesRegex(ValueError, "no checked"):
                check_ledger(text, source, binary)

    def test_recursive_or_missing_data_contracts_are_rejected(self):
        check_data_graph({"a": ["b"], "b": []})
        for graph in ({"a": ["b"]}, {"a": ["b"], "b": ["a"]}, {"a": ["a"]}):
            with self.subTest(graph=graph), self.assertRaises(ValueError):
                check_data_graph(graph)


class DataEncodingContextTests(unittest.TestCase):
    def test_save_text_owns_its_complete_encoding_context(self):
        check_ledger(' save\n codepage LEVELSELECT\nText: dc.b "SAVE",$FF\n even\n restore\n')
        for text in (
            "restore\n",
            "save\n dc.b 1\n",
            "codepage LEVELSELECT\n",
            "save\n codepage UNKNOWN\n restore\n",
            "save\n cpu Z80\n restore\n",
        ):
            with self.subTest(text=text), self.assertRaises(ValueError):
                check_ledger(text)


class TerminalAnnotationTests(unittest.TestCase):
    def test_draw_tail_call_and_private_data_have_an_unreachable_probe(self):
        from scripts.validation.source_layout import check_added_annotations
        from scripts.validation.cohorts import collect_file, render

        text = "Entry:\n move.l #Map,mappings(a0)\n jmp Draw_Sprite\nMap:\n dc.w 0\n; End of function Entry\n"
        row = {
            "role": "code",
            "origin": {"first_line": 1, "last_line": 5},
            "added_annotations": [
                {
                    "name": "Entry",
                    "kind": "terminal-tail",
                    "reason": "Existing draw tail call owns its map",
                    "origin_first_line": 1,
                    "origin_terminal_line": 3,
                    "origin_end_line": 5,
                }
            ],
        }
        check_added_annotations(row, text)
        document = collect_file("scenery.s", text)
        self.assertEqual(document["returns"], [])
        self.assertEqual([r["name"] for r in document["procedures"]], ["Entry"])
        self.assertTrue(render(text, document["points"]).endswith("; End of function Entry\n                rts\n"))

    def test_terminal_annotation_rejects_live_code_unknown_data_and_bad_origin(self):
        import copy
        from scripts.validation.source_layout import check_added_annotations

        text = "Entry:\n jmp Draw_Sprite\nMap: dc.w 0\n; End of function Entry\n"
        row = {
            "role": "code",
            "origin": {"first_line": 1, "last_line": 3},
            "added_annotations": [
                {
                    "name": "Entry",
                    "kind": "terminal-tail",
                    "reason": "Existing tail call",
                    "origin_first_line": 1,
                    "origin_terminal_line": 2,
                    "origin_end_line": 3,
                }
            ],
        }
        for changed in (
            text.replace("jmp Draw_Sprite", "moveq #0,d0"),
            text.replace("dc.w 0", 'include "src/unowned.s"'),
            text.replace("; End of function Entry\n", ""),
        ):
            with self.subTest(text=changed), self.assertRaises(ValueError):
                check_added_annotations(row, changed)
        for change in ({"origin_end_line": 4}, {"reason": ""}, {"kind": "assumed"}):
            broken = copy.deepcopy(row)
            broken["added_annotations"][0].update(change)
            with self.subTest(change=change), self.assertRaises(ValueError):
                check_added_annotations(broken, text)
        broken = copy.deepcopy(row)
        broken["added_annotations"] *= 2
        with self.assertRaises(ValueError):
            check_added_annotations(broken, text)

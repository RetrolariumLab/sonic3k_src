"""Token edits must preserve literal bytes, scopes and source structure."""

import unittest

from scripts.validation.semantic_label_edits import (
    apply_comment_edits,
    apply_edits,
    code_fingerprint,
    code_lines,
    tokens,
)


def edit_at(text, old, new, occurrence=0):
    choices = [
        {"code_line": line, "token": index, "old": old, "new": new}
        for line, (_, row) in enumerate(code_lines(text), 1)
        for index, token in enumerate(row)
        if token.kind == "symbol" and token.text == old
    ]
    return choices[occurrence]


class SymbolTokenEditsTests(unittest.TestCase):
    def test_quoted_names_and_comments_keep_every_byte(self):
        text = "loc_100:\r\n dc.b \"loc_100;still data\",'loc_100' ; loc_100\r\n bra.s loc_100\r\n"
        edits = [edit_at(text, "loc_100", "ReadState", n) for n in (0, 1)]
        actual = apply_edits(text, edits)
        self.assertEqual(
            actual, "ReadState:\r\n dc.b \"loc_100;still data\",'loc_100' ; loc_100\r\n bra.s ReadState\r\n"
        )

    def test_comment_insertion_keeps_code_token_coordinates(self):
        before = "loc_100:\n bra.s loc_100\n"
        edit = edit_at(before, "loc_100", "ReadState", 1)
        text = "; Input is a signed byte.\n\nloc_100:\n; Retain the original branch.\n bra.s loc_100\n"
        self.assertTrue(apply_edits(text, [edit]).endswith(" bra.s ReadState\n"))

    def test_catalog_notes_use_post_rename_anchors_and_preserve_crlf(self):
        before = "loc_100:\r\n    ; Old note\r\n    bra.s loc_100\r\n"
        edits = [edit_at(before, "loc_100", "ReadState", n) for n in (0, 1)]
        notes = [
            {"code_line": 1, "anchor": ["ReadState", ":"], "lines": ["A saved state"]},
            {
                "code_line": 2,
                "anchor": ["bra.s", "ReadState"],
                "lines": ["A checked branch", "The saved state is retained"],
                "replace": ["Old note"],
            },
        ]
        actual = apply_edits(before, edits, comments=notes)
        self.assertEqual(
            actual,
            "; A saved state\r\nReadState:\r\n    ; A checked branch\r\n"
            "    ; The saved state is retained\r\n    bra.s ReadState\r\n",
        )
        self.assertEqual(apply_comment_edits(actual, notes), actual)

    def test_catalog_notes_reject_stale_text_and_cannot_create_code_or_markers(self):
        before = "; Existing note\nReadState:\n rts\n"
        edit = {"code_line": 1, "anchor": ["ReadState", ":"], "lines": ["New note"], "replace": ["Existing note"]}
        for bad in (
            [{**edit, "anchor": ["OtherState", ":"]}],
            [{**edit, "replace": ["Stale note"]}],
            [{**edit, "lines": ["note\n dc.b 1"]}],
            [{**edit, "lines": ["End of function ReadState"]}],
            [edit, edit],
        ):
            with self.subTest(edits=bad), self.assertRaises(ValueError):
                apply_comment_edits(before, bad)

    def test_prefixes_qualified_names_and_operand_sizes_are_distinct(self):
        text = " dc.l loc_10,loc_100.w,Owner.local,._100\n"
        changed = apply_edits(text, [edit_at(text, "loc_100.w", "ObjectFrame.w"), edit_at(text, "._100", ".Retry")])
        self.assertEqual(changed, " dc.l loc_10,ObjectFrame.w,Owner.local,.Retry\n")

    def test_replacements_are_simultaneous(self):
        text = " dc.l First,Second\n"
        edits = [edit_at(text, "First", "Second"), edit_at(text, "Second", "Third")]
        self.assertEqual(apply_edits(text, edits), " dc.l Second,Third\n")

    def test_stale_duplicate_and_out_of_range_edits_fail(self):
        text = " bra.s loc_100\n"
        edit = edit_at(text, "loc_100", "ReadState")
        for edits in ([{**edit, "old": "loc_200"}], [edit, edit], [{**edit, "code_line": 2}], [{**edit, "token": -1}]):
            with self.subTest(edits=edits), self.assertRaises(ValueError):
                apply_edits(text, edits)

    def test_a_literal_cannot_be_addressed_as_a_symbol(self):
        text = ' dc.b "loc_100"\n'
        with self.assertRaisesRegex(ValueError, "literal"):
            apply_edits(text, [{"code_line": 1, "token": 1, "old": '"loc_100"', "new": "ReadState"}])

    def test_newline_operators_and_quotes_cannot_be_injected(self):
        text = " bra.s loc_100\n"
        for new in ("ReadState\n nop", "ReadState+2", '"ReadState"', ""):
            with self.subTest(new=new), self.assertRaises(ValueError):
                apply_edits(text, [edit_at(text, "loc_100", new)])

    def test_fingerprint_ignores_comments_and_spacing_outside_literals(self):
        self.assertEqual(
            code_fingerprint(' dc.b "A B",2 ; text\n'), code_fingerprint('; explanation\n\n\tdc.b  "A B", 2\n')
        )

    def test_fingerprint_preserves_literal_contents_and_operators(self):
        before = code_fingerprint(' dc.b "A B",2+1\n')
        for changed in (' dc.b "AB",2+1\n', ' dc.b "A B",2-1\n', ' dc.b "A B",2+2\n'):
            self.assertNotEqual(before, code_fingerprint(changed))

    def test_doubled_quotes_and_semicolons_remain_literal_tokens(self):
        row = tokens(" dc.b \"A\"\";B\",'C'';D' ; actual comment")
        self.assertEqual([t.text for t in row if t.kind == "string"], ['"A"";B"', "'C'';D'"])
        self.assertFalse(any(t.text == "actual" for t in row))


if __name__ == "__main__":
    unittest.main()

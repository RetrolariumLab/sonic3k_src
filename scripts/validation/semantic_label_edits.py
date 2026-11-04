"""Apply explicit ASM symbol and explanatory comment edits at stable code anchors."""

from dataclasses import dataclass
import hashlib
import json
import re

from scripts.validation.numeric_operands import code_part

LEXEME = re.compile(
    r"""(?P<string>"(?:[^"\n]|"")*"|'(?:[^'\n]|'')*')|(?P<symbol>[A-Za-z_.][A-Za-z_0-9.]*)|(?P<other>\S)"""
)
SYMBOL = re.compile(r"[A-Za-z_.][A-Za-z_0-9.]*$")


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    start: int
    end: int


def tokens(line):
    return [Token(m.lastgroup, m[0], m.start(), m.end()) for m in LEXEME.finditer(code_part(line))]


def code_lines(text):
    return [(number, row) for number, line in enumerate(text.splitlines(keepends=True), 1) if (row := tokens(line))]


def code_fingerprint(text):
    """Whitespace and comments may change; literals and code line structure may not."""
    rows = [[(t.kind, t.text) for t in row] for _, row in code_lines(text)]
    return hashlib.sha256(json.dumps(rows, separators=(",", ":")).encode()).hexdigest()


def apply_edits(text, edits, *, comments=()):
    """Address tokens by code-line ordinal, stable across explanatory comments."""
    lines = text.splitlines(keepends=True)
    code = code_lines(text)
    changes, seen = {}, set()
    for edit in edits:
        row, index, old, new = (edit.get(k) for k in ("code_line", "token", "old", "new"))
        if (
            type(row) is not int
            or type(index) is not int
            or not 1 <= row <= len(code)
            or not 0 <= index < len(code[row - 1][1])
        ):
            raise ValueError("ASM symbol edit has an invalid code-token coordinate")
        if (row, index) in seen:
            raise ValueError("ASM symbol edit duplicates or overlaps another token")
        seen.add((row, index))
        physical, parsed = code[row - 1]
        token = parsed[index]
        if token.kind != "symbol" or token.text != old or not isinstance(new, str) or not SYMBOL.fullmatch(new):
            raise ValueError("ASM edit is stale, crosses a literal or introduces non-symbol syntax")
        changes.setdefault(physical, []).append((token.start, token.end, new))
    for physical, replacements in changes.items():
        line = lines[physical - 1]
        for start, end, new in sorted(replacements, reverse=True):
            line = line[:start] + new + line[end:]
        lines[physical - 1] = line
    return apply_comment_edits("".join(lines), comments)


def _comment_text(lines):
    if not isinstance(lines, list) or not lines:
        raise ValueError("ASM comments need a nonempty list of text lines")
    for line in lines:
        if (
            not isinstance(line, str)
            or not line
            or line != line.strip()
            or not all(" " <= character <= "~" for character in line)
            or line.lower().startswith(("end of function", "source provenance and ranges:"))
        ):
            raise ValueError("ASM comment must be printable text and cannot edit provenance or procedure markers")
    return lines


def apply_comment_edits(text, comments):
    """Insert or replace standalone comments before exact post-rename code rows.

    Anchors count code rows, so earlier comment edits do not invalidate later
    coordinates. Replacing an existing note requires its exact old text.
    """
    if not comments:
        return text
    lines = text.splitlines(keepends=True)
    code = code_lines(text)
    changes, anchors = [], set()
    for edit in comments:
        if not isinstance(edit, dict) or set(edit) - {"code_line", "anchor", "lines", "replace"}:
            raise ValueError("Invalid ASM comment record")
        row = edit.get("code_line")
        if type(row) is not int or not 1 <= row <= len(code) or row in anchors:
            raise ValueError("Invalid or duplicate ASM comment anchor")
        anchors.add(row)
        physical, tokens_at_anchor = code[row - 1]
        if edit.get("anchor") != [token.text for token in tokens_at_anchor]:
            raise ValueError("ASM comment anchor is stale")
        new = _comment_text(edit.get("lines"))
        old = _comment_text(edit["replace"]) if "replace" in edit else []
        end = physical - 1

        def preceding(note):
            start = end - len(note)
            return start >= 0 and [line.strip() for line in lines[start:end]] == ["; " + item for item in note]

        if preceding(new):
            continue
        if old and not preceding(old):
            raise ValueError("ASM comment to replace is missing or has changed")
        start = end - len(old)
        eol = "\r\n" if lines[end].endswith("\r\n") else "\n"
        if old:
            indentation = lines[start][: len(lines[start]) - len(lines[start].lstrip())]
        else:
            indentation = ""
        changes.append((start, end, [indentation + "; " + line + eol for line in new]))
    for start, end, replacement in sorted(changes, reverse=True):
        lines[start:end] = replacement
    result = "".join(lines)
    if code_fingerprint(result) != code_fingerprint(text):
        raise ValueError("ASM comment edit changed code tokens")
    return result

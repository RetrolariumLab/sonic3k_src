"""Apply explicit ASM symbol edits without interpreting strings or comments."""

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


def apply_edits(text, edits):
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
    return "".join(lines)

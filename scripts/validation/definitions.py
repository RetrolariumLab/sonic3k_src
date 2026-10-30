"""Prove macro libraries declare helpers without emitting cartridge bytes."""

import re

from scripts.validation.data_macros import definition_blocks
from scripts.validation.numeric_operands import code_part

NAMED = re.compile(r"^[A-Za-z_.][A-Za-z_0-9.]*(?::\s*|\s+)(equ|set|function)\s+(.+)$", re.I)
OPTIONS = frozenset(("padding off", "listing purecode", "supmode on", "page 0"))


def named_declaration(raw):
    match = NAMED.fullmatch(raw)
    return match[1].lower() + " " + match[2] if match else None


def check_definitions(text):
    rows = text.splitlines()
    blocks = definition_blocks(text)
    hidden = {i for name, first, last, body in blocks for i in range(first, last)}
    saved, encoding = [], None
    for index, line in enumerate(rows):
        if index in hidden:
            continue
        raw = code_part(line).strip()
        if not raw or named_declaration(raw):
            continue
        parts = raw.split(None, 1)
        op, args = parts[0].lower(), parts[1] if len(parts) == 2 else ""
        if " ".join(raw.lower().split()) in OPTIONS:
            continue
        if op == "save" and not args:
            saved.append(encoding)
        elif op == "restore" and not args and saved:
            encoding = saved.pop()
        elif op == "codepage" and saved and args == "LEVELSELECT":
            encoding = args
        elif op == "charset" and saved and encoding == "LEVELSELECT" and args:
            continue
        else:
            raise ValueError("Definition library has executable, emitting or unchecked top-level syntax: " + raw)
    if saved:
        raise ValueError("Unclosed definition encoding context")
    return len(blocks)


def check_nonemitting_range(start, end):
    if start != end:
        raise ValueError("Definition library emits cartridge bytes")

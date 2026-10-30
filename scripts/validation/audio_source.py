"""Reject score assembly and inline instrument/envelope payloads, including history."""

from pathlib import PurePosixPath
import re

from scripts.validation.data_macros import definition_blocks
from scripts.validation.definitions import named_declaration
from scripts.validation.numeric_operands import code_part


LEGACY = ("sound/music/", "sound/sfx/", "sound/_smps2asm_inc.")
PAYLOAD_LABEL = re.compile(r"^(?:ModEnv_[0-9a-f]{2}|VolEnv_[0-9a-f]{2}|z80_UniVoiceBank)$", re.I)
LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*):\s*(.*)$")


def validate_audio_source(data, path):
    name = path.replace("\\", "/").casefold()
    if name.startswith(LEGACY):
        raise ValueError("Audio score source in Git: " + path)
    if PurePosixPath(name).suffix not in (".s", ".asm", ".inc"):
        return
    text = data.decode("utf-8-sig") if isinstance(data, bytes) else data
    blocks = definition_blocks(text)
    hidden = set()
    for macro, first, last, body in blocks:
        if macro.startswith("smps") and not macro.startswith(("smpsvc", "smpsdc")):
            raise ValueError("Full score macro library in Git: " + path)
        hidden.update(range(first, last))
    payload = False
    for index, line in enumerate(text.splitlines()):
        if index in hidden:
            continue
        if re.match(r"\s*;\s*Voice\s+[0-9a-f]+h\s*-", line, re.I):
            raise ValueError("Inline FM instrument annotation in Git: " + path)
        raw = code_part(line).strip()
        match = LABEL.match(raw)
        if match:
            payload = bool(PAYLOAD_LABEL.fullmatch(match[1]))
            raw = match[2]
        raw = named_declaration(raw) or raw
        if not raw:
            continue
        op = raw.split(None, 1)[0].lower()
        if op.startswith("smps") or payload and op in ("db", "dw", "dc.b", "dc.w", "dc.l"):
            raise ValueError("Inline audio payload in Git: " + path)

"""Read AS integer symbols, including symbols marked unused in the listing."""

import re

SYMBOL = re.compile(
    r"(?:^|\|)\s*\*?([A-Za-z_.][A-Za-z_0-9.]*)\s*:\s*([A-Fa-f0-9]{1,16})\s+[A-Z-]",
    re.MULTILINE,
)


def parse_symbols(text):
    values = {}
    for name, value in SYMBOL.findall(text):
        address = int(value, 16) & 0xFFFFFFFF
        if name in values and values[name] != address:
            raise ValueError("Conflicting AS symbol: " + name)
        values[name] = address
    if not values:
        raise ValueError("AS listing contains no integer symbol table")
    return values


STRING_SYMBOL = re.compile(
    r"""(?:^|\|)\s*\*?([A-Za-z_.][A-Za-z_0-9.]*)\s*:\s*('(?:[^'\r\n]|'')*'|"(?:[^"\r\n]|"")*")\s+[A-Z-]\s*(?=\||$)""",
    re.MULTILINE,
)


def parse_declaration_symbols(text):
    """Retain the distinction between integer and quoted-string AS constants."""
    values = parse_symbols(text)
    for name, value in STRING_SYMBOL.findall(text):
        if name in values and values[name] != value:
            raise ValueError("Conflicting AS declaration symbol: " + name)
        values[name] = value
    return values

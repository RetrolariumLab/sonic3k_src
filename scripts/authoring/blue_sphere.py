"""Blue Sphere's 27-bit level selection and checked decimal entry codes.

The public level index is zero based, as in Blue_spheres_current_level.
A menu's LEVEL display adds one; stage resources remain separate from codes.
"""

from scripts.authoring.graphics import _boolean, _integer

LEVEL_MASK = 0x7FFFFFF


def stage_bytes(level_index):
    """Select the four original quadrant slots without copying their layouts."""
    level = _integer(level_index, LEVEL_MASK + 1, "Blue Sphere level index")
    return bytes((level % 128, (3 * level + 1) % 127, (5 * level + 2) % 126, (7 * level + 3) % 125))


def stage_number(selections):
    """Return the title's nine-digit packed stage number, distinct from LEVEL."""
    if not isinstance(selections, (bytes, bytearray, memoryview)) or len(selections) != 4:
        raise ValueError("A stage number needs four quadrant bytes")
    values = [value & 127 for value in selections]
    return sum(value << shift for value, shift in zip(values, (21, 14, 7, 0)))


def _check(level):
    checksum = 0
    for word in (level >> 16, level & 65535):
        checksum ^= word
        carry = checksum & 1
        checksum >>= 1
        if carry:
            checksum ^= 0x8810
    return checksum


def _rotate_right(value, count):
    return (value >> count | value << (32 - count)) & 0xFFFFFFFF


def encode_code(level_index, *, progress=False):
    """Return all twelve decimal digits, including any leading zeroes."""
    level = _integer(level_index, LEVEL_MASK + 1, "Blue Sphere level index")
    _boolean(progress, "Blue Sphere progress flag")
    checksum = _check((level + (0x7654321 if progress else 0)) & LEVEL_MASK)
    high = ((checksum & 63) | (64 if progress else 0)) ^ 0x55
    low = ((level + 0x1234567) & LEVEL_MASK) | ((checksum << 21) & 0xF8000000)
    low = _rotate_right(low, 6) ^ 0xAAAAAAAA
    return f"{(high << 32) | low:012d}"


def decode_code(code):
    """Validate the game's checksum and return the level and progress state.

    The original accepts unused high bits of the decimal entry value. They do
    not select a different level; encode_code always returns its canonical form.
    """
    if not isinstance(code, str) or len(code) != 12 or any(char not in "0123456789" for char in code):
        raise ValueError("Blue Sphere code must be twelve ASCII decimal digits")
    value = int(code)
    high = (value >> 32) ^ 0x55
    low = value & 0xFFFFFFFF
    low = _rotate_right(low ^ 0xAAAAAAAA, 26)
    checksum = (((low >> 16) & 0xF800) >> 5 | high & 63) & 0x7FF
    progress = bool(high & 64)
    level = (low - 0x1234567) & LEVEL_MASK
    checked = (level + (0x7654321 if progress else 0)) & LEVEL_MASK
    if _check(checked) & 0x7FF != checksum:
        raise ValueError("Blue Sphere code checksum does not match")
    return {"level_index": level, "progress": progress}


def level_from_lockon_header(header, *, header_flag=False):
    """Reproduce BlueSphereDeriveTwentySevenBitLevelFromLockonHeader for a complete attached cartridge header.

    The caller supplies the result of the game's header test. Sonic 1 serial
    recognition is an earlier mode decision and does not call this seed path.
    A serial with no nonzero digit is rejected: the original counter underflows
    and reads past its header rather than defining a bounded header-only seed.
    """
    if not isinstance(header, (bytes, bytearray, memoryview)) or len(header) != 0x200:
        raise ValueError("Lock-on seed requires the complete 512-byte header region")
    _boolean(header_flag, "Lock-on header-test flag")
    serial = header[0x180:0x18C]
    first = next((i for i, value in enumerate(serial) if 49 <= value <= 57), None)
    if first is None:
        raise ValueError("Lock-on serial would underflow the original header scan")
    number = 0
    for value in serial[first:]:
        if 48 <= value <= 57:
            number = (number * 10 + value - 48) & 65535
    number &= 0x7FFF
    months = (
        b".JAN",
        b".FEB",
        b".MAR",
        b".APR",
        b".MAY",
        b".JUN",
        b".JUL",
        b".AUG",
        b".SEP",
        b".OCT",
        b".NOV",
        b".DEC",
        b".   ",
        b"    ",
        b"....",
    )
    date = bytes(header[0x11C:0x120])
    month = months.index(date) if date in months else 15
    year = (((header[0x11A] - 48) & 255) * 10 + ((header[0x11B] - 48) & 255) - 0x58) & 7
    result = number & 63
    for width, value in (
        (4, month),
        (4, (number >> 6) & 15),
        (1, header[0x150] & 1),
        (3, year),
        (5, (number >> 10) & 31),
        (2, (header[0x1A5] >> 3) & 3),
        (1, int(header[0x114:0x116] != b"EG")),
        (1, int(header_flag)),
    ):
        result = (result << width) | value
    return result & LEVEL_MASK

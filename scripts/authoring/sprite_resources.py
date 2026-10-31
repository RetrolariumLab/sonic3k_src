"""Sprite mapping pieces and the two distinct retained DPLC transfer ABIs."""

from scripts.authoring.graphics import _bytes, _integer, decode_tile_words, encode_tile_words


def _signed(value, bits, name):
    if type(value) is not int or not -(1 << (bits - 1)) <= value < (1 << (bits - 1)):
        raise ValueError(name + " exceeds its signed field")
    return value & ((1 << bits) - 1)


def _mapping_abi(abi):
    if abi not in ("s3k-word-count", "s1-byte-count"):
        raise ValueError("Unknown sprite mapping ABI")
    return (2, 6, 16) if abi == "s3k-word-count" else (1, 5, 8)


def decode_mapping(data, *, abi, max_pieces=80):
    header, stride, x_bits = _mapping_abi(abi)
    raw = _bytes(data)
    _integer(max_pieces, 65536, "Mapping piece capacity")
    if len(raw) < header or (len(raw) - header) % stride:
        raise ValueError("Truncated sprite mapping records")
    count = int.from_bytes(raw[:header], "big")
    stored = (len(raw) - header) // stride
    if stored > max_pieces or count > stored:
        raise ValueError("Sprite mapping count exceeds stored pieces or capacity")
    pieces = []
    for start in range(header, len(raw), stride):
        row = raw[start : start + stride]
        pieces.append(
            {
                "y": int.from_bytes(row[:1], "big", signed=True),
                "width_tiles": ((row[1] >> 2) & 3) + 1,
                "height_tiles": (row[1] & 3) + 1,
                "size_reserved": row[1] & 0xF0,
                "tile": decode_tile_words(row[2:4])[0],
                "x": int.from_bytes(row[4:], "big", signed=True),
            }
        )
    return {"abi": abi, "active_count": count, "pieces": pieces}


def encode_mapping(model, *, target_abi, max_pieces=80):
    header, stride, x_bits = _mapping_abi(target_abi)
    if set(model) != {"abi", "active_count", "pieces"} or model["abi"] != target_abi:
        raise ValueError("Sprite mapping model differs from the target ABI")
    _integer(max_pieces, 65536, "Mapping piece capacity")
    pieces = model["pieces"]
    count = _integer(model["active_count"], 1 << (header * 8), "Active mapping count")
    if len(pieces) > max_pieces or count > len(pieces):
        raise ValueError("Sprite mapping exceeds its piece capacity")
    output = bytearray(count.to_bytes(header, "big"))
    for piece in pieces:
        if set(piece) != {"y", "width_tiles", "height_tiles", "size_reserved", "tile", "x"}:
            raise ValueError("Sprite piece fields differ from the ABI")
        width = _integer(piece["width_tiles"] - 1 if type(piece["width_tiles"]) is int else None, 4, "Sprite width")
        height = _integer(piece["height_tiles"] - 1 if type(piece["height_tiles"]) is int else None, 4, "Sprite height")
        unused = _integer(piece["size_reserved"], 256, "Sprite size reserved bits")
        if unused & 15:
            raise ValueError("Reserved sprite bits overlap size")
        output.extend((_signed(piece["y"], 8, "Sprite Y"), unused | width << 2 | height))
        output.extend(encode_tile_words([piece["tile"]]))
        output.extend(_signed(piece["x"], x_bits, "Sprite X").to_bytes(x_bits // 8, "big"))
    return bytes(output)


def _dplc_abi(abi):
    if abi not in ("player-high-count", "object-low-count-minus-one"):
        raise ValueError("Unknown DPLC transfer ABI")
    return abi == "player-high-count"


def decode_dplc(data, *, abi, max_transfers=256):
    player = _dplc_abi(abi)
    raw = _bytes(data)
    _integer(max_transfers, 65536, "DPLC transfer capacity")
    if len(raw) < 2 or len(raw) % 2:
        raise ValueError("Truncated DPLC transfer records")
    header = int.from_bytes(raw[:2], "big")
    count = header if player else header + 1
    stored = len(raw) // 2 - 1
    if stored > max_transfers or count > stored:
        raise ValueError("DPLC count exceeds stored transfers or capacity")
    transfers = []
    for offset in range(2, len(raw), 2):
        word = int.from_bytes(raw[offset : offset + 2], "big")
        transfers.append(
            {
                "source_tile": word & 4095 if player else word >> 4,
                "tile_count": (word >> 12 if player else word & 15) + 1,
            }
        )
    return {"abi": abi, "active_count": count, "transfers": transfers}


def encode_dplc(model, *, target_abi, max_transfers=256, source_tiles=4111, destination_tiles=2048):
    player = _dplc_abi(target_abi)
    if set(model) != {"abi", "active_count", "transfers"} or model["abi"] != target_abi:
        raise ValueError("DPLC model differs from the target ABI")
    for name, value in (
        ("transfer capacity", max_transfers),
        ("source tiles", source_tiles),
        ("destination tiles", destination_tiles),
    ):
        _integer(value, 65537, "DPLC " + name)
    count = _integer(model["active_count"], 65536, "Active DPLC count")
    transfers = model["transfers"]
    if count > len(transfers) or len(transfers) > max_transfers or (not player and not count):
        raise ValueError("DPLC count exceeds transfer capacity")
    output = bytearray((count if player else count - 1).to_bytes(2, "big"))
    total = 0
    for index, row in enumerate(transfers):
        if set(row) != {"source_tile", "tile_count"}:
            raise ValueError("DPLC transfer fields differ from the ABI")
        source = _integer(row["source_tile"], 4096, "DPLC source tile")
        length = _integer(row["tile_count"] - 1 if type(row["tile_count"]) is int else None, 16, "DPLC tile count") + 1
        if index < count:
            if source + length > source_tiles:
                raise ValueError("DPLC transfer crosses the source art allocation")
            total += length
            if total > destination_tiles:
                raise ValueError("DPLC transfer crosses the destination VRAM allocation")
        word = ((length - 1) << 12 | source) if player else (source << 4 | (length - 1))
        output.extend(word.to_bytes(2, "big"))
    return bytes(output)

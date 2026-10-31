"""S3K 16-pixel block definitions and 128-pixel chunk block cells."""

from scripts.authoring.graphics import _boolean, _bytes, _integer, decode_tile_words, encode_tile_words


def _capacity(value, limit, name):
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value <= limit:
        raise ValueError(name + " exceeds the game memory allocation")


def decode_blocks(data, *, max_blocks=768):
    raw = _bytes(data)
    _capacity(max_blocks, 768, "Block count")
    if len(raw) % 8 or len(raw) > max_blocks * 8:
        raise ValueError("Block data ends inside four tile words or exceeds capacity")
    tiles = decode_tile_words(raw)
    return [[tiles[offset : offset + 2], tiles[offset + 2 : offset + 4]] for offset in range(0, len(tiles), 4)]


def encode_blocks(blocks, *, max_blocks=768):
    _capacity(max_blocks, 768, "Block count")
    if len(blocks) > max_blocks:
        raise ValueError("Block definitions exceed their declared capacity")
    tiles = []
    for block in blocks:
        if len(block) != 2 or any(len(row) != 2 for row in block):
            raise ValueError("A block must contain two rows of two tile words")
        tiles.extend(cell for row in block for cell in row)
    return encode_tile_words(tiles)


def decode_chunks(data, *, max_chunks=256):
    raw = _bytes(data)
    _capacity(max_chunks, 256, "Chunk count")
    if len(raw) % 128 or len(raw) > max_chunks * 128:
        raise ValueError("Chunk data ends inside its eight by eight block grid or exceeds capacity")
    cells = []
    for offset in range(0, len(raw), 2):
        word = int.from_bytes(raw[offset : offset + 2], "big")
        cells.append(
            {
                "block": word & 1023,
                "flip_x": bool(word & 0x400),
                "flip_y": bool(word & 0x800),
                "solidity_a": (word >> 12) & 3,
                "solidity_b": (word >> 14) & 3,
            }
        )
    chunks = []
    for offset in range(0, len(cells), 64):
        chunks.append([cells[offset + row : offset + row + 8] for row in range(0, 64, 8)])
    return chunks


def encode_chunks(chunks, *, max_chunks=256):
    _capacity(max_chunks, 256, "Chunk count")
    if len(chunks) > max_chunks:
        raise ValueError("Chunk definitions exceed their declared capacity")
    output = bytearray()
    for chunk in chunks:
        if len(chunk) != 8 or any(len(row) != 8 for row in chunk):
            raise ValueError("A chunk must contain eight rows of eight block cells")
        for row in chunk:
            for cell in row:
                if set(cell) != {"block", "flip_x", "flip_y", "solidity_a", "solidity_b"}:
                    raise ValueError("Chunk cell fields differ from the format")
                word = (
                    _integer(cell["block"], 1024, "chunk block index")
                    | int(_boolean(cell["flip_x"], "block X flip")) << 10
                    | int(_boolean(cell["flip_y"], "block Y flip")) << 11
                )
                word |= (
                    _integer(cell["solidity_a"], 4, "collision path A solidity") << 12
                    | _integer(cell["solidity_b"], 4, "collision path B solidity") << 14
                )
                output.extend(word.to_bytes(2, "big"))
    return bytes(output)


def check_chunk_references(chunks, block_count):
    _capacity(block_count, 768, "Block count")
    if any(cell["block"] >= block_count for chunk in chunks for row in chunk for cell in row):
        raise ValueError("A chunk cell references a block outside its target block table")

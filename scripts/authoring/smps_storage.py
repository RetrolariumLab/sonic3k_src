"""Closed-bank semantic SMPS corpus codecs with fixed slots and no opaque payload echo."""

from scripts.authoring import fm_instruments, smps_graph, smps_headers, smps_tracks
from scripts.authoring.graphics import _bytes, _integer


class _Storage:
    def __init__(self, streams):
        if not streams:
            raise ValueError("SMPS corpus must contain at least one catalog slot")
        self.data, self.coverage, self.code = bytearray(32768), bytearray(32768), bytearray(32768)
        self.owners = bytearray(32768)
        self.ids = set()
        for row in streams:
            name, offset, capacity = row["id"], row["bank_offset"], row["capacity"]
            if not isinstance(name, str) or not name or name in self.ids:
                raise ValueError("SMPS storage IDs must be unique nonempty strings")
            self.ids.add(name)
            _integer(offset, 32768, "SMPS storage offset")
            if (
                isinstance(capacity, bool)
                or not isinstance(capacity, int)
                or capacity <= 0
                or offset + capacity > 32768
            ):
                raise ValueError("SMPS slot exceeds its selected bank allocation")
            if any(self.owners[offset : offset + capacity]):
                raise ValueError("SMPS storage slots overlap")
            self.owners[offset : offset + capacity] = bytes([1]) * capacity

    def put(self, offset, data, *, code=False):
        _integer(offset, 32768, "SMPS record offset")
        end = offset + len(data)
        if end > 32768 or not all(self.owners[offset:end]):
            raise ValueError("SMPS typed record escapes its declared corpus slots")
        for index, value in enumerate(data, offset):
            if self.coverage[index] and self.data[index] != value:
                raise ValueError("SMPS overlapping semantic records disagree after editing")
        self.data[offset:end] = data
        self.coverage[offset:end] = bytes([1]) * len(data)
        if code:
            self.code[offset:end] = bytes([1]) * len(data)

    def complete(self):
        if any(owner and not covered for owner, covered in zip(self.owners, self.coverage)):
            raise ValueError("SMPS corpus leaves owned storage bytes without a semantic record")


def _entries(streams):
    result = []
    for row in streams:
        header = row["header"]
        if header["kind"] == "music":
            result.extend(
                {"address": track["pointer"], "channel": "dac" if index == 0 else "fm"}
                for index, track in enumerate(header["fm_dac"])
            )
            result.extend({"address": track["pointer"], "channel": "psg"} for track in header["psg"])
        else:
            result.extend(
                {"address": track["pointer"], "channel": "psg" if track["channel"] & 128 else "fm"}
                for track in header["tracks"]
            )
    return result


def _put_instructions(storage, nodes, abi, *, unreachable=False):
    for row in nodes:
        if set(row) != {"address", "channel", "alternate_frequency", "size", "instruction"}:
            raise ValueError("SMPS instruction record has unknown or missing fields")
        if unreachable != (row["channel"] == "unbound"):
            raise ValueError("SMPS unreachable fragments must keep their unbound channel context")
        address = _integer(row["address"], 65536, "SMPS instruction address")
        if address < 32768:
            raise ValueError("SMPS instruction escapes its ROM window")
        packed = smps_tracks.encode_instruction(
            row["instruction"], abi=abi, channel=row["channel"], alternate_frequency=row["alternate_frequency"]
        )
        if isinstance(row["size"], bool) or not isinstance(row["size"], int) or len(packed) != row["size"]:
            raise ValueError("SMPS edits must retain the instruction's fixed allocation")
        storage.put(address - 32768, packed, code=True)


def _put_headers(storage, streams, abi):
    for row in streams:
        if set(row) != {"id", "bank_offset", "capacity", "header_size", "header"}:
            raise ValueError("SMPS stream storage record has unknown or missing fields")
        packed = smps_headers.encode_header(row["header"], target_abi=abi)
        if (
            isinstance(row["header_size"], bool)
            or not isinstance(row["header_size"], int)
            or len(packed) != row["header_size"]
        ):
            raise ValueError("SMPS edits must retain the header's fixed allocation")
        storage.put(row["bank_offset"], packed)


def decode_corpus(streams, bank_data, *, abi):
    """Decode all catalog slots in one bank, including shared and dead bytecode.

    Each input stream has id, bank_offset, kind and extracted data. The complete
    bank view resolves cross-stream pointers; it is never retained in the model.
    Header-referenced, unexecuted tails divisible into 25-byte voices are local
    FM banks. Dummy voice pointers into headers are excluded. Unreachable events
    retain a selector without inventing a hardware consumer.
    """
    smps_headers._abi(abi)
    bank = _bytes(bank_data)
    if len(bank) != 32768:
        raise ValueError("SMPS corpus needs a complete 32 KiB reference bank")
    model = {"abi": abi, "streams": [], "instructions": [], "voice_banks": [], "unreachable": []}
    voice_pointers = set()
    for row in streams:
        if set(row) != {"id", "bank_offset", "kind", "data"}:
            raise ValueError("SMPS extracted stream record has unknown or missing fields")
        data = _bytes(row["data"])
        offset = _integer(row["bank_offset"], 32768, "SMPS stream offset")
        if not data or bank[offset : offset + len(data)] != data:
            raise ValueError("SMPS extracted stream differs from its selected reference bank")
        header, consumed = smps_headers.decode_header(data, kind=row["kind"], abi=abi)
        model["streams"].append(
            {"id": row["id"], "bank_offset": offset, "capacity": len(data), "header_size": consumed, "header": header}
        )
        if header["voice_pointer"] >= 32768:
            voice_pointers.add(header["voice_pointer"] - 32768)
    storage = _Storage(model["streams"])
    _put_headers(storage, model["streams"], abi)
    graph = smps_graph.analyze_bank(bank, _entries(model["streams"]), abi=abi)
    if graph["issues"]:
        raise ValueError("SMPS corpus has unresolved dynamic or unbalanced reachable control flow")
    model["instructions"] = graph["nodes"]
    _put_instructions(storage, model["instructions"], abi)
    for stream in model["streams"]:
        start, end = stream["bank_offset"], stream["bank_offset"] + stream["capacity"]
        for pointer in sorted(voice_pointers):
            if (
                start + stream["header_size"] <= pointer < end
                and (end - pointer) % 25 == 0
                and not any(storage.coverage[pointer:end])
            ):
                voices = fm_instruments.decode_bank(bank[pointer:end])
                model["voice_banks"].append({"bank_offset": pointer, "size": end - pointer, "voices": voices})
                storage.put(pointer, fm_instruments.encode_bank(voices))
                break
        position = start
        while position < end:
            if storage.coverage[position]:
                position += 1
                continue
            gap_end = position + 1
            while gap_end < end and not storage.coverage[gap_end]:
                gap_end += 1
            alternate = False
            while position < gap_end:
                instruction, size = smps_tracks.decode_instruction(
                    bank[position:gap_end], abi=abi, channel="unbound", alternate_frequency=alternate
                )
                row = {
                    "address": 32768 + position,
                    "channel": "unbound",
                    "alternate_frequency": alternate,
                    "size": size,
                    "instruction": instruction,
                }
                model["unreachable"].append(row)
                _put_instructions(storage, [row], abi, unreachable=True)
                if instruction["op"] == "alternate_frequency_mode":
                    alternate = instruction["control"] == 1
                position += size
    storage.complete()
    for row in model["streams"]:
        start, end = row["bank_offset"], row["bank_offset"] + row["capacity"]
        if storage.data[start:end] != bank[start:end]:
            raise ValueError("SMPS typed corpus did not reconstruct its original storage")
    return model


def encode_corpus(model, *, target_abi):
    """Return validated per-slot bytes; perform no file or ROM writes.

    Fixed header/instruction sizes and overlap agreement are checked before any
    result is returned. Profile applicability and catalog allocation identities
    must additionally be checked by the repository's authoring write boundary.
    """
    smps_headers._abi(target_abi)
    if set(model) != {"abi", "streams", "instructions", "voice_banks", "unreachable"} or model["abi"] != target_abi:
        raise ValueError("SMPS corpus and target have different driver ABIs or fields")
    storage = _Storage(model["streams"])
    _put_headers(storage, model["streams"], target_abi)
    _put_instructions(storage, model["instructions"], target_abi)
    _put_instructions(storage, model["unreachable"], target_abi, unreachable=True)
    for row in model["voice_banks"]:
        if set(row) != {"bank_offset", "size", "voices"}:
            raise ValueError("FM bank record has unknown or missing fields")
        packed = fm_instruments.encode_bank(row["voices"])
        if isinstance(row["size"], bool) or not isinstance(row["size"], int) or len(packed) != row["size"]:
            raise ValueError("FM voice edits must retain the bank allocation")
        storage.put(row["bank_offset"], packed)
    storage.complete()
    graph = smps_graph.analyze_bank(bytes(storage.data), _entries(model["streams"]), abi=target_abi)
    if graph["issues"]:
        raise ValueError("SMPS edit introduces unresolved dynamic or unbalanced control flow")
    for row in graph["nodes"]:
        start = row["address"] - 32768
        if not all(storage.code[start : start + row["size"]]):
            raise ValueError("SMPS edited control flow enters a header, voice bank or unowned region")
    return {
        row["id"]: bytes(storage.data[row["bank_offset"] : row["bank_offset"] + row["capacity"]])
        for row in model["streams"]
    }

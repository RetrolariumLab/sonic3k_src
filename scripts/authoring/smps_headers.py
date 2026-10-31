"""Typed music and SFX headers shared by the retained SMPS 3 and 4 drivers."""

from scripts.authoring.graphics import _bytes, _integer

SFX_CHANNELS = (2, 4, 5, 6, 128, 160, 192)


def _abi(abi):
    if abi not in ("smps3", "smps4"):
        raise ValueError("Unknown SMPS driver ABI")


def _signed(value):
    if isinstance(value, bool) or not isinstance(value, int) or not -128 <= value < 128:
        raise ValueError("SMPS transpose is outside its signed byte field")
    return value & 255


def _track(raw, offset, *, psg=False, sfx=False):
    size = 6 if psg or sfx else 4
    if offset + size > len(raw):
        raise ValueError("Truncated SMPS track header")
    row = {}
    if sfx:
        row["playback_control"], row["channel"] = raw[offset : offset + 2]
        offset += 2
    row["pointer"] = int.from_bytes(raw[offset : offset + 2], "little")
    row["transpose"] = raw[offset + 2] if raw[offset + 2] < 128 else raw[offset + 2] - 256
    row["volume"] = raw[offset + 3]
    if psg:
        row["modulation_envelope"], row["volume_envelope"] = raw[offset + 4 : offset + 6]
    return row


def _pack_track(row, *, psg=False, sfx=False):
    keys = {"pointer", "transpose", "volume"}
    if sfx:
        keys |= {"playback_control", "channel"}
    if psg:
        keys |= {"modulation_envelope", "volume_envelope"}
    if set(row) != keys:
        raise ValueError("SMPS channel fields differ from the target header ABI")
    pointer = _integer(row["pointer"], 65536, "SMPS track pointer")
    if pointer < 32768:
        raise ValueError("SMPS track pointer escapes the ROM bank window")
    output = bytearray()
    if sfx:
        channel = _integer(row["channel"], 256, "SFX hardware channel")
        if channel not in SFX_CHANNELS:
            raise ValueError("SFX channel has no driver RAM track allocation")
        output.extend((_integer(row["playback_control"], 256, "playback control"), channel))
    output.extend(pointer.to_bytes(2, "little"))
    output.extend((_signed(row["transpose"]), _integer(row["volume"], 256, "track volume")))
    if psg:
        output.extend(_integer(row[name], 256, name) for name in ("modulation_envelope", "volume_envelope"))
    return bytes(output)


def encode_header(header, *, target_abi):
    _abi(target_abi)
    kind = header.get("kind")
    keys = {"kind", "abi", "voice_pointer", "tempo_divider"}
    keys |= {"tempo", "fm_dac", "psg"} if kind == "music" else {"tracks"}
    if kind not in ("music", "sfx") or set(header) != keys or header["abi"] != target_abi:
        raise ValueError("SMPS header and target have different driver ABIs or fields")
    # Voice pointers can address the driver's RAM universal bank as well as ROM.
    output = bytearray(_integer(header["voice_pointer"], 65536, "voice pointer").to_bytes(2, "little"))
    divider = _integer(header["tempo_divider"], 256, "tempo divider")
    if kind == "music":
        fm, psg = header["fm_dac"], header["psg"]
        if not 1 <= len(fm) <= 7 or len(psg) > 3:
            raise ValueError("Music header exceeds the FM/DAC or PSG track allocation")
        output.extend((len(fm), len(psg), divider, _integer(header["tempo"], 256, "main tempo")))
        for row in fm:
            output.extend(_pack_track(row))
        for row in psg:
            output.extend(_pack_track(row, psg=True))
    else:
        tracks = header["tracks"]
        if not 1 <= len(tracks) <= 7:
            raise ValueError("SFX header exceeds the driver's track allocation")
        output.extend((divider, len(tracks)))
        for row in tracks:
            output.extend(_pack_track(row, sfx=True))
    return bytes(output)


def decode_header(data, *, kind, abi):
    _abi(abi)
    raw = _bytes(data)
    if kind not in ("music", "sfx") or len(raw) < (6 if kind == "music" else 4):
        raise ValueError("Unknown or truncated SMPS header")
    model = {"kind": kind, "abi": abi, "voice_pointer": int.from_bytes(raw[:2], "little")}
    if kind == "music":
        fm, psg = raw[2:4]
        if not 1 <= fm <= 7 or psg > 3:
            raise ValueError("Music channel count exceeds the driver allocation")
        model["tempo_divider"], model["tempo"] = raw[4:6]
        model["fm_dac"] = [_track(raw, 6 + i * 4) for i in range(fm)]
        model["psg"] = [_track(raw, 6 + fm * 4 + i * 6, psg=True) for i in range(psg)]
        consumed = 6 + fm * 4 + psg * 6
    else:
        model["tempo_divider"] = raw[2]
        count = raw[3]
        if not 1 <= count <= 7:
            raise ValueError("SFX channel count exceeds the driver allocation")
        model["tracks"] = [_track(raw, 4 + i * 6, sfx=True) for i in range(count)]
        consumed = 4 + count * 6
    if encode_header(model, target_abi=abi) != raw[:consumed]:
        raise ValueError("SMPS header cannot be preserved by its typed fields")
    return model, consumed

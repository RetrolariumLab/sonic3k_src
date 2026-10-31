"""Typed instructions for the retained SMPS 3/4 FM, PSG and DAC track streams."""

from scripts.authoring.graphics import _bytes, _integer
from scripts.authoring.smps_headers import _abi, _signed

# These are file-format command definitions, not song or driver payload bytes.
COMMANDS = {
    0xE0: ("pan_ams_fms", (("bits", "byte"),)),
    0xE1: ("detune", (("delta", "signed"),)),
    0xE2: ("fade_previous_control", (("value", "byte"),)),
    0xE3: ("silence_stop", ()),
    0xE4: ("set_volume", (("level", "byte"),)),
    0xE5: ("change_fm_volume_pair", (("ignored_first", "byte"), ("delta", "signed"))),
    0xE6: ("change_fm_volume", (("delta", "signed"),)),
    0xE7: ("prevent_attack", ()),
    0xE8: ("note_fill", (("ticks", "byte"),)),
    0xE9: ("spindash_rev", ()),
    0xEA: ("queue_dac_sample", (("index", "byte"),)),
    0xEB: ("conditional_jump", (("counter", "byte"), ("target", "pointer"))),
    0xEC: ("change_psg_volume", (("delta", "signed"),)),
    0xED: ("set_key_bias", (("biased_key", "byte"),)),
    0xEE: ("write_fm_part_one", (("register", "byte"), ("value", "byte"))),
    0xEF: ("set_voice", (("index", "byte"),)),
    0xF0: ("setup_modulation", (("delay", "byte"), ("speed", "byte"), ("delta", "signed"), ("steps", "byte"))),
    0xF1: ("select_modulation_by_channel", (("psg", "byte"), ("fm", "byte"))),
    0xF2: ("stop", ()),
    0xF3: ("psg_noise", (("bits", "byte"),)),
    0xF4: ("set_modulation", (("control", "byte"),)),
    0xF5: ("psg_volume_envelope", (("index", "byte"),)),
    0xF6: ("jump", (("target", "pointer"),)),
    0xF7: ("repeat", (("counter", "byte"), ("count", "byte"), ("target", "pointer"))),
    0xF8: ("call", (("target", "pointer"),)),
    0xF9: ("return", ()),
    0xFA: ("disable_modulation", ()),
    0xFB: ("change_transposition", (("delta", "signed"),)),
    0xFC: ("continuous_sfx_loop", (("target", "pointer"),)),
    0xFD: ("alternate_frequency_mode", (("control", "byte"),)),
    0xFE: ("fm3_special_mode", (("frequency_table_indices", "four"),)),
}
META_COMMANDS = {
    0: ("set_main_tempo", (("tempo", "byte"),)),
    1: ("play_sound", (("index", "byte"),)),
    2: ("halt_resume", (("control", "byte"),)),
    3: ("copy_track_data", (("source", "pointer"), ("count", "byte"))),
    4: ("set_all_tempo_dividers", (("divider", "byte"),)),
    5: ("ssg_eg", (("operator_register_values", "four"),)),
    6: ("fm_volume_envelope", (("index", "byte"), ("operator_mask", "byte"))),
    7: ("reset_spindash_rev", ()),
}
BY_NAME = {spec[0]: (bytes([code]), spec[1]) for code, spec in COMMANDS.items()}
BY_NAME.update({spec[0]: (bytes([255, code]), spec[1]) for code, spec in META_COMMANDS.items()})


def _context(abi, channel, alternate_frequency):
    _abi(abi)
    if channel not in ("fm", "psg", "dac", "unbound") or not isinstance(alternate_frequency, bool):
        raise ValueError("SMPS instruction needs an explicit channel and frequency mode")


def decode_instruction(data, offset=0, *, abi, channel, alternate_frequency=False):
    _context(abi, channel, alternate_frequency)
    raw = _bytes(data)
    if isinstance(offset, bool) or not isinstance(offset, int) or not 0 <= offset < len(raw):
        raise ValueError("SMPS instruction offset escapes its stream view")
    position = offset

    def take(size=1):
        nonlocal position
        if position + size > len(raw):
            raise ValueError("Truncated SMPS instruction or command operands")
        value = raw[position : position + size]
        position += size
        return value

    code = take()[0]
    if code < 224:
        if alternate_frequency and channel != "dac":
            model = {
                "op": "literal_frequency",
                "frequency": code << 8 | take()[0],
                "pitch_slide_state": take()[0],
                "ticks": take()[0],
            }
        elif code < 128:
            model = {"op": "duration", "ticks": code}
        elif code == 128:
            model = {"op": "rest"}
        elif channel == "unbound":
            model = {"op": "channel_event", "selector": code - 128}
        elif channel == "dac":
            model = {"op": "sample", "index": code - 128}
        else:
            model = {"op": "note", "semitone": code - 129}
        return model, position - offset
    if code == 255:
        selector = take()[0]
        if selector not in META_COMMANDS:
            raise ValueError("SMPS meta command indexes outside the retained driver table")
        name, fields = META_COMMANDS[selector]
    else:
        name, fields = COMMANDS[code]
    model = {"op": name}
    for name, kind in fields:
        value = take(2 if kind == "pointer" else 4 if kind == "four" else 1)
        if kind == "pointer":
            model[name] = int.from_bytes(value, "little")
        elif kind == "four":
            model[name] = list(value)
        elif kind == "signed":
            model[name] = value[0] if value[0] < 128 else value[0] - 256
        else:
            model[name] = value[0]
    if code == 239 and model["index"] >= 128:
        # FM/DAC use the external song's bank; PSG consumes but ignores this byte.
        model["song_bank_selector"] = take()[0]
    return model, position - offset


def encode_instruction(model, *, abi, channel, alternate_frequency=False):
    _context(abi, channel, alternate_frequency)
    op = model.get("op")
    if op in ("duration", "rest", "note", "sample", "channel_event", "literal_frequency"):
        literal = alternate_frequency and channel != "dac"
        if op == "literal_frequency":
            if not literal or set(model) != {"op", "frequency", "pitch_slide_state", "ticks"}:
                raise ValueError("Literal frequency requires its alternate track context")
            frequency = _integer(model["frequency"], 224 * 256, "literal frequency")
            return frequency.to_bytes(2, "big") + bytes(
                _integer(model[name], 256, name) for name in ("pitch_slide_state", "ticks")
            )
        if literal:
            raise ValueError("Alternate frequency mode does not encode normal notes or durations")
        if op == "rest" and set(model) == {"op"}:
            return bytes([128])
        fields = {"duration": "ticks", "note": "semitone", "sample": "index", "channel_event": "selector"}
        name = fields.get(op)
        if not name or set(model) != {"op", name}:
            raise ValueError("SMPS note/sample fields differ from the operation")
        if op == "duration":
            code = _integer(model[name], 128, name)
        elif op == "note" and channel in ("fm", "psg"):
            code = 129 + _integer(model[name], 95, name)
        elif op == "channel_event" and channel == "unbound":
            selector = _integer(model[name], 96, name)
            if not selector:
                raise ValueError("An unbound event zero is the rest byte")
            code = 128 + selector
        elif op == "sample" and channel == "dac":
            index = _integer(model[name], 96, name)
            if not index:
                raise ValueError("DAC sample zero is the rest byte")
            code = 128 + index
        else:
            raise ValueError("SMPS note/sample does not match its hardware channel")
        return bytes([code])
    if op not in BY_NAME:
        raise ValueError("Unknown SMPS instruction")
    prefix, fields = BY_NAME[op]
    expected = {"op"} | {name for name, _ in fields}
    external = op == "set_voice" and isinstance(model.get("index"), int) and model["index"] >= 128
    if external:
        expected.add("song_bank_selector")
    if set(model) != expected:
        raise ValueError("SMPS command fields differ from the operation")
    output = bytearray(prefix)
    for name, kind in fields:
        value = model[name]
        if kind == "pointer":
            output.extend(_integer(value, 65536, name).to_bytes(2, "little"))
        elif kind == "four":
            if len(value) != 4:
                raise ValueError("SMPS operator command requires four register values")
            output.extend(_integer(item, 256, name) for item in value)
        elif kind == "signed":
            output.append(_signed(value))
        else:
            output.append(_integer(value, 256, name))
    if external:
        output.append(_integer(model["song_bank_selector"], 256, "song bank selector"))
    return bytes(output)

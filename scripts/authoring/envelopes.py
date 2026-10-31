"""Driver envelope atoms and bounded evaluation preserving original code-read bugs."""

from scripts.authoring.graphics import _bytes, _integer

MOD_CONTROLS = {
    128: "reset",
    129: "sustain_81",
    130: "jump_via_code",
    131: "sustain_83",
    132: "add_sensitivity_via_code",
}
VOL_CONTROLS = {128: "reset", 129: "rest_without_silencing", 131: "full_rest"}


def decode(data, *, family):
    raw = _bytes(data)
    if family not in ("modulation", "volume") or not 0 < len(raw) <= 256:
        raise ValueError("Envelope family or eight-bit index allocation is invalid")
    rows = []
    for value in raw:
        if family == "modulation":
            if value in MOD_CONTROLS:
                rows.append({"op": MOD_CONTROLS[value]})
            else:
                rows.append({"op": "pitch_delta", "value": value if value < 128 else value - 256})
        elif value in VOL_CONTROLS:
            rows.append({"op": VOL_CONTROLS[value]})
        elif value < 128:
            rows.append({"op": "attenuation", "value": value})
        else:
            rows.append({"op": "jump_via_code", "opcode": value})
    return rows


def encode(atoms, *, family):
    if family not in ("modulation", "volume") or not 0 < len(atoms) <= 256:
        raise ValueError("Envelope family or eight-bit index allocation is invalid")
    output = bytearray()
    controls = MOD_CONTROLS if family == "modulation" else VOL_CONTROLS
    inverse = {name: value for value, name in controls.items()}
    for atom in atoms:
        op = atom.get("op")
        if op in inverse and set(atom) == {"op"}:
            value = inverse[op]
        elif family == "modulation" and op == "pitch_delta" and set(atom) == {"op", "value"}:
            delta = atom["value"]
            if isinstance(delta, bool) or not isinstance(delta, int) or not -123 <= delta <= 127:
                raise ValueError("Modulation delta overlaps a command or exceeds a signed byte")
            value = delta & 255
        elif family == "volume" and op == "attenuation" and set(atom) == {"op", "value"}:
            value = _integer(atom["value"], 128, "volume envelope attenuation")
        elif family == "volume" and op == "jump_via_code" and set(atom) == {"op", "opcode"}:
            value = _integer(atom["opcode"], 256, "envelope jump opcode")
            if value < 128 or value in VOL_CONTROLS:
                raise ValueError("Volume jump opcode collides with another envelope operation")
        else:
            raise ValueError("Envelope atom fields differ from their operation")
        output.append(value)
    return bytes(output)


def tick(data, *, family, index=0, sensitivity=0, code_memory=b"", max_steps=512):
    """Evaluate one tick without guessing bytes beyond the supplied envelope/code view.

    Pass a view containing any intentionally adjacent driver tables as data when
    execution can run past the nominal envelope's end. Code-read commands use
    address index+1 in the external Z80 code view, never data[index+1].
    """
    raw, code = _bytes(data), _bytes(code_memory)
    if family not in ("modulation", "volume"):
        raise ValueError("Unknown envelope family")
    _integer(index, 256, "envelope index")
    _integer(sensitivity, 256, "modulation sensitivity")
    if isinstance(max_steps, bool) or not isinstance(max_steps, int) or max_steps <= 0:
        raise ValueError("Envelope control budget must be a positive integer")
    for _ in range(max_steps):
        if index >= len(raw):
            raise ValueError("Envelope execution escapes the supplied driver data view")
        value = raw[index]
        if value == 128:
            index = 0
            continue
        if family == "modulation":
            if value in (129, 131):
                return {"index": index, "sensitivity": sensitivity, "event": "sustain_frequency"}
            code_read = value in (130, 132)
        else:
            if value in (129, 131):
                return {"index": index, "event": "rest_without_silencing" if value == 129 else "request_full_rest"}
            code_read = value >= 128
        if code_read:
            if index + 1 >= len(code):
                raise ValueError("Original envelope bug needs an unavailable Z80 code byte")
            operand = code[index + 1]
            if family == "modulation" and value == 132:
                sensitivity = (sensitivity + operand) & 255
                index = (index + 2) & 255
            else:
                index = operand
            continue
        next_index = (index + 1) & 255
        if family == "modulation":
            delta = value if value < 128 else value - 256
            return {
                "index": next_index,
                "sensitivity": sensitivity,
                "event": "frequency_delta",
                "delta": delta * (sensitivity + 1),
            }
        return {"index": next_index, "event": "attenuation", "value": value}
    raise ValueError("Envelope control flow exceeds its step budget")

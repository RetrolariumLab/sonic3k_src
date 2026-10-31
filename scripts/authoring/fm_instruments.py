"""Driver FM instruments in the register order used by the retained Z80 engine."""

from scripts.authoring.graphics import _boolean, _bytes, _integer

SLOTS = (1, 3, 2, 4)
OPERATOR_FIELDS = frozenset(
    (
        "index",
        "detune",
        "multiple",
        "detune_reserved",
        "rate_scale",
        "attack_rate",
        "attack_reserved",
        "amplitude_modulation",
        "decay_rate",
        "decay_reserved",
        "sustain_rate",
        "sustain_reserved",
        "sustain_level",
        "release_rate",
        "total_level",
        "apply_track_volume",
    )
)


def decode_voice(data):
    raw = _bytes(data)
    if len(raw) != 25:
        raise ValueError("An FM instrument must contain exactly 25 bytes")
    operators = []
    for position, index in enumerate(SLOTS):
        dt, attack, decay, sustain, release, level = (raw[1 + group * 4 + position] for group in range(6))
        operators.append(
            {
                "index": index,
                "detune": (dt >> 4) & 7,
                "multiple": dt & 15,
                "detune_reserved": bool(dt & 128),
                "rate_scale": attack >> 6,
                "attack_rate": attack & 31,
                "attack_reserved": bool(attack & 32),
                "amplitude_modulation": bool(decay & 128),
                "decay_rate": decay & 31,
                "decay_reserved": (decay >> 5) & 3,
                "sustain_rate": sustain & 31,
                "sustain_reserved": sustain >> 5,
                "sustain_level": release >> 4,
                "release_rate": release & 15,
                "total_level": level & 127,
                "apply_track_volume": bool(level & 128),
            }
        )
    return {
        "algorithm": raw[0] & 7,
        "feedback": (raw[0] >> 3) & 7,
        "reserved": raw[0] >> 6,
        "operators": sorted(operators, key=lambda row: row["index"]),
    }


def encode_voice(voice):
    if set(voice) != {"algorithm", "feedback", "reserved", "operators"} or len(voice["operators"]) != 4:
        raise ValueError("FM instrument fields or operator count differ from the format")
    operators = {}
    for operator in voice["operators"]:
        if set(operator) != OPERATOR_FIELDS:
            raise ValueError("FM operator fields differ from the format")
        index = _integer(operator["index"], 5, "operator index")
        if index not in SLOTS or index in operators:
            raise ValueError("FM operator indices must cover 1 through 4 exactly once")
        operators[index] = operator
    output = bytearray(
        [
            _integer(voice["algorithm"], 8, "algorithm")
            | _integer(voice["feedback"], 8, "feedback") << 3
            | _integer(voice["reserved"], 4, "instrument reserved bits") << 6
        ]
    )
    groups = [[] for _ in range(6)]
    for index in SLOTS:
        row = operators[index]

        def integer(name, limit):
            return _integer(row[name], limit, name)

        def boolean(name):
            return int(_boolean(row[name], name))

        groups[0].append(integer("detune", 8) << 4 | integer("multiple", 16) | boolean("detune_reserved") << 7)
        groups[1].append(integer("rate_scale", 4) << 6 | integer("attack_rate", 32) | boolean("attack_reserved") << 5)
        groups[2].append(
            boolean("amplitude_modulation") << 7 | integer("decay_rate", 32) | integer("decay_reserved", 4) << 5
        )
        groups[3].append(integer("sustain_rate", 32) | integer("sustain_reserved", 8) << 5)
        groups[4].append(integer("sustain_level", 16) << 4 | integer("release_rate", 16))
        groups[5].append(integer("total_level", 128) | boolean("apply_track_volume") << 7)
    for group in groups:
        output.extend(group)
    return bytes(output)


def decode_bank(data):
    raw = _bytes(data)
    if len(raw) % 25:
        raise ValueError("FM bank ends inside an instrument")
    return [decode_voice(raw[offset : offset + 25]) for offset in range(0, len(raw), 25)]


def encode_bank(voices):
    return b"".join(encode_voice(voice) for voice in voices)

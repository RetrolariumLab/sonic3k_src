"""Raw per-frame and counted-run controller recordings used by S3K attract mode."""

from scripts.authoring.graphics import _boolean, _bytes, _integer

BUTTONS = ("up", "down", "left", "right", "b", "c", "a", "start")


def _buttons(value):
    return {name: bool(value & (1 << bit)) for bit, name in enumerate(BUTTONS)}


def _mask(buttons):
    if set(buttons) != set(BUTTONS):
        raise ValueError("Controller buttons differ from the eight-bit game input ABI")
    return sum(int(_boolean(buttons[name], name)) << bit for bit, name in enumerate(BUTTONS))


def _limit(value):
    if isinstance(value, bool) or not isinstance(value, int) or value < 1:
        raise ValueError("Demo frame capacity must be a positive integer")


def decode_raw(data, *, max_frames=65535):
    raw = _bytes(data)
    _limit(max_frames)
    if len(raw) < 2 or len(raw) - 1 > max_frames:
        raise ValueError("Raw demo needs an initial previous-button byte and bounded frame input")
    return {"initial_buttons": _buttons(raw[0]), "frames": [_buttons(value) for value in raw[1:]]}


def encode_raw(recording, *, max_frames=65535):
    _limit(max_frames)
    if set(recording) != {"initial_buttons", "frames"} or not 1 <= len(recording["frames"]) <= max_frames:
        raise ValueError("Raw demo fields or frame count differ from its allocation")
    return bytes([_mask(recording["initial_buttons"])]) + bytes(_mask(frame) for frame in recording["frames"])


def decode_runs(data, *, max_frames=65535):
    raw = _bytes(data)
    _limit(max_frames)
    if not raw or len(raw) & 1:
        raise ValueError("Run demo must contain complete counter/button pairs")
    runs = [{"frames": raw[i] + 1, "buttons": _buttons(raw[i + 1])} for i in range(0, len(raw), 2)]
    if sum(row["frames"] for row in runs) > max_frames:
        raise ValueError("Run demo exceeds its total frame capacity")
    return runs


def encode_runs(runs, *, max_frames=65535):
    _limit(max_frames)
    if not runs:
        raise ValueError("Run demo needs at least one counter/button pair")
    output, frames = bytearray(), 0
    for row in runs:
        if set(row) != {"frames", "buttons"}:
            raise ValueError("Run demo fields differ from the counter/button ABI")
        count = _integer(row["frames"], 257, "demo run frames")
        if not count:
            raise ValueError("Demo run must last between one and 256 frames")
        frames += count
        if frames > max_frames:
            raise ValueError("Run demo exceeds its total frame capacity")
        output.extend((count - 1, _mask(row["buttons"])))
    return bytes(output)


def pressed(previous_buttons, current_buttons):
    previous, current = _mask(previous_buttons), _mask(current_buttons)
    return _buttons(current & ~previous)

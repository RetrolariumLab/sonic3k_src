"""Unsigned YM2612 PCM and high-first DPCM using the ROM-owned delta codebook."""


def _bytes(value):
    if not isinstance(value, (bytes, bytearray, memoryview)):
        raise ValueError("DAC content must be bytes")
    return bytes(value)


def _samples(values):
    result = list(values)
    if any(isinstance(value, bool) or not isinstance(value, int) or not -128 <= value <= 127 for value in result):
        raise ValueError("DAC waveform samples must be signed 8-bit integers")
    return result


def _capacity(value):
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise ValueError("DAC sample capacity must be a nonnegative integer")


def decode_codebook(data):
    raw = _bytes(data)
    if len(raw) != 16:
        raise ValueError("The DPCM codebook must contain exactly sixteen deltas")
    return [value if value < 128 else value - 256 for value in raw]


def encode_codebook(deltas):
    values = _samples(deltas)
    if len(values) != 16:
        raise ValueError("The DPCM codebook must contain exactly sixteen deltas")
    return bytes(value & 255 for value in values)


def decode_pcm(data, *, max_samples=0x200000):
    raw = _bytes(data)
    _capacity(max_samples)
    if len(raw) > max_samples:
        raise ValueError("PCM waveform exceeds its declared sample capacity")
    return [value - 128 for value in raw]


def encode_pcm(samples):
    return bytes(value + 128 for value in _samples(samples))


def decode_dpcm(data, codebook, *, max_samples=0x200000):
    raw = _bytes(data)
    deltas = decode_codebook(codebook)
    _capacity(max_samples)
    if len(raw) * 2 > max_samples:
        raise ValueError("DPCM waveform exceeds its declared sample capacity")
    accumulator, samples = 128, []
    for value in raw:
        for code in (value >> 4, value & 15):
            accumulator = (accumulator + deltas[code]) & 255
            samples.append(accumulator - 128)
    return samples


def encode_dpcm(samples, codebook):
    waveform = _samples(samples)
    deltas = decode_codebook(codebook)
    if len(waveform) % 2:
        raise ValueError("DPCM needs two waveform samples per packed byte")
    lookup = {}
    for index, delta in enumerate(deltas):
        lookup.setdefault(delta & 255, index)
    accumulator, output, pending = 128, bytearray(), None
    for sample in waveform:
        next_value = sample + 128
        delta = (next_value - accumulator) & 255
        if delta not in lookup:
            raise ValueError("Edited waveform needs a delta outside the target codebook")
        code = lookup[delta]
        if pending is None:
            pending = code
        else:
            output.append(pending << 4 | code)
            pending = None
        accumulator = next_value
    return bytes(output)


def encode_preserving(samples, original, codebook, *, max_samples=0x200000):
    waveform, reference = _samples(samples), _bytes(original)
    _capacity(max_samples)
    if len(waveform) > max_samples:
        raise ValueError("Edited DPCM waveform exceeds its declared sample capacity")
    previous = decode_dpcm(reference, codebook, max_samples=max_samples)
    return reference if previous == waveform else encode_dpcm(waveform, codebook)

"""Explicit headless model dispatch for the reviewed content registry."""

from scripts.authoring import (
    collision,
    core_compression,
    dac,
    demo_input,
    enigma,
    envelopes,
    fm_instruments,
    geometry,
    graphics,
    kosinski,
    kosinski_moduled,
    legacy_s2_objects,
    level_coordinates,
    level_layout,
    object_placements,
    palettes,
    perspective,
    rings,
    scaled_art,
    slot_bonus,
    special_stage,
    terrain,
    tile_maps,
    trigonometry,
    waterline,
)

# Named format, decoder, encoder, exact parameter keys and encoder keyword names.
SPECS = {
    "tiles": (graphics.decode_tiles, graphics.encode_tiles, {}),
    "vdp-words": (graphics.decode_tile_words, graphics.encode_tile_words, {}),
    "palette": (graphics.decode_palette, graphics.encode_palette, {}),
    "blocks": (terrain.decode_blocks, terrain.encode_blocks, {}),
    "chunks": (terrain.decode_chunks, terrain.encode_chunks, {}),
    "rings": (rings.decode, rings.encode, {"axis": "axis"}),
    "objects": (object_placements.decode, object_placements.encode, {}),
    "legacy-s2-objects": (legacy_s2_objects.decode, legacy_s2_objects.encode, {}),
    "level-layout": (level_layout.decode, level_layout.encode, {}),
    "start-xy": (level_coordinates.decode_start, level_coordinates.encode_start, {}),
    "collision-indices": (collision.decode_indices, collision.encode_indices, {"abi": "abi"}),
    "collision-heights": (collision.decode_heights, collision.encode_heights, {"shape_count": "shape_count"}),
    "collision-angles": (collision.decode_angles, collision.encode_angles, {"shape_count": "shape_count"}),
    "fm-bank": (fm_instruments.decode_bank, fm_instruments.encode_bank, {}),
    "envelope": (envelopes.decode, envelopes.encode, {"family": "family"}),
    "dac-codebook": (dac.decode_codebook, dac.encode_codebook, {}),
    "dac-pcm": (dac.decode_pcm, dac.encode_pcm, {}),
    "demo-raw": (demo_input.decode_raw, demo_input.encode_raw, {}),
    "demo-runs": (demo_input.decode_runs, demo_input.encode_runs, {}),
    "s3-special-stage": (
        lambda data: special_stage.decode_record(data, product="s3"),
        lambda model: special_stage.encode_record(model, product="s3"),
        {},
    ),
    "sk-special-stage-set": (special_stage.decode_sk_set, special_stage.encode_sk_set, {}),
    "blue-sphere-bank": (special_stage.decode_blue_sphere_bank, special_stage.encode_blue_sphere_bank, {}),
    "special-stage-palette": (palettes.decode_special_stage, palettes.encode_special_stage, {}),
    "pachinko-palette": (palettes.decode_pachinko, palettes.encode_pachinko, {}),
    "perspective": (perspective.decode, perspective.encode, {"product": "target_product"}),
    "scalars": (perspective.decode_scalars, perspective.encode_scalars, {}),
    "scaled-raster": (scaled_art.decode, scaled_art.encode, {}),
    "waterline": (waterline.decode, waterline.encode, {"zone": "target_zone"}),
    "starting-water": (waterline.decode_starting_heights, waterline.encode_starting_heights, {}),
    "snowboard-path": (geometry.decode_slope, geometry.encode_slope, {}),
    "rock-sprites": (geometry.decode_rock_sprites, geometry.encode_rock_sprites, {}),
    "sine": (trigonometry.decode_sine, trigonometry.encode_sine, {}),
    "arctan": (trigonometry.decode_arctan, trigonometry.encode_arctan, {}),
    "slot-layout": (slot_bonus.decode_layout, slot_bonus.encode_layout, {}),
    "tile-map": (tile_maps.decode, tile_maps.encode, {"layout": "target_layout"}),
}
SPECIAL_KEYS = {
    "rock-placement": {"style_count"},
    "dac-dpcm": set(),
    "smps-corpus": {"abi"},
    "source-driver-tables": set(),
}
COMPRESSIONS = {"none", "kosinski", "kosinski-moduled", "nemesis", "enigma"}


def validate_spec(row):
    codec, parameters = row["codec"], row["parameters"]
    expected = set(SPECS[codec][2]) if codec in SPECS else SPECIAL_KEYS.get(codec)
    if expected is None or not isinstance(parameters, dict) or set(parameters) != expected:
        raise ValueError("Unknown content codec or incorrect ABI parameter keys")
    if row["compression"] not in COMPRESSIONS:
        raise ValueError("Unknown content compression family")
    # Syntax and semantic values are additionally checked by the selected codec.


def decode_plain(row, data, *, context=None):
    validate_spec(row)
    codec, parameters = row["codec"], row["parameters"]
    if codec in SPECS:
        return SPECS[codec][0](data, **parameters)
    if codec == "rock-placement":
        model = geometry.decode_rocks(data)
        geometry.check_rock_styles(model, parameters["style_count"])
        return model
    if codec == "dac-dpcm":
        if not context or "codebook" not in context:
            raise ValueError("DPCM requires the separately checked ROM-owned codebook")
        return dac.decode_dpcm(data, context["codebook"])
    raise ValueError("Source inputs and SMPS corpora require their dedicated ownership API")


def encode_plain(row, model, *, context=None, original=None):
    validate_spec(row)
    codec, parameters = row["codec"], row["parameters"]
    if codec == "chunks":
        terrain.check_chunk_references(model, block_count=768)
    if codec in SPECS:
        encoder, names = SPECS[codec][1], SPECS[codec][2]
        encoded = encoder(model, **{names[key]: value for key, value in parameters.items()})
        # Retail placements contain a few deliberate inversions. Preserve them
        # only when the entire encoded stream matches the verified original.
        if encoded != original:
            if codec in {"objects", "legacy-s2-objects"}:
                object_placements.check_order(model)
            elif codec == "rings":
                rings.check_order(model, parameters["axis"])
        return encoded
    if codec == "rock-placement":
        geometry.check_rock_styles(model, parameters["style_count"])
        return geometry.encode_rocks(model)
    if codec == "dac-dpcm":
        if not context or "codebook" not in context:
            raise ValueError("DPCM requires the separately checked ROM-owned codebook")
        return dac.encode_dpcm(model, context["codebook"])
    raise ValueError("Source inputs and SMPS corpora require their dedicated ownership API")


def decompress(row, original):
    family, capacity = row["compression"], row["capacity"]["decoded_bytes"]
    if family == "none":
        return graphics._bytes(original)
    if family == "kosinski":
        return kosinski.decode(original, max_output=capacity)
    if family == "kosinski-moduled":
        return kosinski_moduled.decode(original, max_output=capacity)
    if family == "enigma":
        return enigma.decode(original, max_output=capacity)
    if family == "nemesis":
        return core_compression.decode_nemesis(original, max_output=capacity)
    raise ValueError("Unknown content compression family")


def compress(row, data, original, *, force=False):
    family = row["compression"]
    if family == "none":
        return bytes(data)
    if not force and decompress(row, original) == data:
        return bytes(original)
    if family == "kosinski":
        result = kosinski.encode(data)
    elif family == "kosinski-moduled":
        result = kosinski_moduled.encode(data)
    elif family == "enigma":
        result = enigma.encode(data)
    elif family == "nemesis":
        result = core_compression.encode_nemesis(data, original)
    else:
        raise ValueError("Unknown content compression family")
    if decompress(row, result) != data:
        raise ValueError("Compressed result differs from the edited semantic content")
    return result

# Headless content codec APIs

The models in scripts/authoring accept bytes and semantic values and return
encoded bytes. They do not write ROMs. Callers must check the product ABI,
target profile, decoded capacity and immutable storage allocation before any
write. The public aggregate registry and complete container round trip remain
under development; these APIs alone do not establish Source Reconstruction 2.0.

## Compression

Kosinski and Kosinski Moduled follow the retained loaders. Moduled streams use
4096-byte modules and alignment relative to the header. A final module may
decode beyond its declared visible prefix, matching the original loader. Enigma
follows the retained 68000 packet semantics. The pinned Core Enigma dialect
differs from this game and is not its authoring backend.

Nemesis uses the pinned public Core C++ implementation. Set
RETROLARIUM_CORE_SOURCE to a checkout containing the dependency revision in
config/toolchain.json, then run make prepare-core. CMake 3.21 or later and a
C++17 compiler are required. Preparation archives the pinned revision into
ignored build/tools/core and builds there, without modifying the dependency
checkout. Make check-core verifies the cached binary binding. Native unit tests
skip explicitly when no backend is configured; complete content gates must
require it.

Forced encoding checks decoded equivalence. The encoders need not reproduce the
original compressor. Zero-edit encoding preserves the original packed stream and
padding after semantic comparison. An edited result must still fit the target
storage allocation.

## Model families

| Modules                                             | Content                                                                            |
| --------------------------------------------------- | ---------------------------------------------------------------------------------- |
| graphics, tile_maps                                 | CRAM channels and unused bits, 4bpp tiles, VDP attributes, row/frame/atlas packing |
| terrain, level_layout                               | Tile blocks, chunks, solidity paths and foreground/background RAM row layouts      |
| object_placements, rings                            | Positions, flags, fixed record widths and bounded terminators                      |
| legacy_s2_objects                                   | Retained lock-on data with distinct respawn semantics; no Sonic 2 runtime profile  |
| collision, level_coordinates                        | Product-specific indices, signed heights, angles and starting coordinates          |
| special_stage, blue_sphere                          | Complete layouts, mirrored quadrants, level/header selection and checked codes     |
| palettes, perspective                               | Cyclic palettes, projection cells, RAM pointers and Q14 scalars                    |
| scaled_art, waterline                               | Duplicated-nibble rasters and active scroll selectors separated from unused cells  |
| geometry, trigonometry, slot_bonus                  | Slopes, rock records, sine/arctangent tables and bonus block indices               |
| demo_input                                          | Raw per-frame buttons or counter/button pairs and initial held state               |
| fm_instruments, envelopes, dac                      | FM operators, original driver commands, external-codebook DPCM and PCM             |
| smps_headers, smps_tracks, smps_graph, smps_storage | Both SMPS ABIs, bank corpora, typed commands, control flow and local voice banks   |

S3 collision indices support 512 shapes, but the S&K lock-on consumer reads
their low byte and must reject indices above 255. Waterline bounds apply to
active cells only. Software-scaled art uses raster order, not VDP tile order.
Perspective pointers have a 24-bit RAM base. Sine encoding regenerates the
duplicated cosine lookahead.

Blue Sphere distinguishes one-based menu LEVEL, packed STAGE and entry code.
Progress changes the checksum. The original accepts some unused high code bits;
encoding returns a canonical code. A header serial without a nonzero digit would
underflow the original scan; the bounded header-only API rejects it.

SMPS decoding requires a complete closed 32 KiB bank because streams can share
tracks and voices. Models include headers, context-sensitive instructions, typed
unused commands and local voice banks. Encoding checks fixed allocations,
complete ownership, aliases and edited control flow. Unsupported dynamic
execution and unbalanced returns are explicit errors. The target profile's
immutable allocation checks remain necessary before writes.

## Tests

Make test discovers normal package tests under tests/authoring. Fixtures are
synthetic. They cover field semantics, edits, malformed records, capacities and
ABI mismatches. Complete original-resource and rebuilt-container checks remain
the next integration step.

## Immutable write allocations

The registry in config/authoring/data_formats.json covers every primary asset
and every derived driver payload. Format and compression are independent;
extensions do not determine either one. Profiles and address spaces are checked
against active AS includes, not against the image used to extract a shared
resource.

The current authoring policy is preservation-fixed-footprint. Encoded slots come
from the asset manifest or driver payload recipe. Decoded dimensions also remain
fixed. This deliberately does not offer expanded or relocated assets. An edited
compressed stream may use fewer bytes and receives zero padding to retain its
original slot; overflow is rejected. Zero-edit output preserves the original
stream and its complete tail.

ContentCatalog binds a decoded model to an immutable artifact contract and an
explicit target profile. The caller must decode again for another profile. The
DPCM codebook must match its own catalog identity. S&K lock-on rejects S3
collision indices above 255, and chunk references must fit the 768-block RAM
table. SMPS corpus descriptors must keep their exact manifest-owned bank offsets
and capacities. A complete corpus is validated before output is returned. All
checks finish before the write API creates any output, and the write API accepts
only workspaces inside ignored build storage.

Two original driver containers are extraction inputs, not editable opaque
resources. Their complete decoded bytes must equal the fresh virtual AS table
output, and their packed bytes must equal the fresh source-built image slice.
They remain explicitly registered and are included in the full check.

## Complete content commands

Make check-content-contract works without ROMs. Make roundtrip-formats first
builds every preservation profile and requires the pinned Core backend. It runs
every modeled resource and every applicable profile, forces compression
content-equivalence checks, checks all closed SMPS bank corpora and rebuilds
both source-owned driver inputs. The complete encoded inputs are saved only
under ignored build/authoring.

Make check-content-zero-edit then copies the retained assembly into that
workspace and builds all five preservation containers from those encoded inputs.
Every output must match its original ROM, including both composite halves.
Reports bind assembly, authoring tooling and registry identities. These content
checks do not replace the full preservation/runtime gate or the remaining source
ownership work.

Core scratch cleanup can leave a directory in ignored build storage when a
Windows process still holds a temporary file. Execution, encoding, output
reading and unexpected cleanup failures remain fatal.

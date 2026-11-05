# Headless content codec APIs

The models in scripts/authoring accept bytes and semantic values and return
encoded bytes. They do not write ROMs. Callers must check the product ABI,
target profile, decoded capacity and immutable storage allocation before any
write. The public registry covers every extracted input and the declared
retained assembler resource families. Complete content checks complement the
full preservation/runtime gate; these APIs alone do not establish release
acceptance.

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

Object placement exports require nondecreasing X in both the S3K and retained
legacy Sonic 2 ABIs. Ring contracts declare their streaming axis. The Pachinko
consumer uses Y and its alternate status table; the other ring streams use X.
Retail streams with descending pairs can be exported only when their entire
encoded content matches the verified original allocation. Edited streams must
satisfy their order contract before encoding or workspace writes complete.

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

Make test discovers normal package tests under tests/authoring. Synthetic
fixtures cover field semantics, edits, malformed records, capacities, streaming
order and ABI mismatches. When private inputs are available, integration cases
also exercise real AIZ exports through ContentCatalog.encode and write. These
cases skip explicitly when inputs are absent. The complete original-resource and
rebuilt-container commands are described below.

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
Every output must match its original ROM, including both composite halves. AS
searches only the encoded workspace; missing generated source or binary inputs
cannot fall back to the preservation tree. Real-AS synthetic edit tests check
that nested generated values reach emitted object bytes. Reports bind assembly,
authoring tooling and registry identities. These content checks do not replace
the full preservation/runtime gate or the built source ownership checks.

Core scratch cleanup can leave a directory in ignored build storage when a
Windows process still holds a temporary file. Execution, encoding, output
reading and unexpected cleanup failures remain fatal.

## Retained assembler content

The main format catalog links config/authoring/assembly_formats.json. This
source-owned catalog covers all 502 mapping, 39 DPLC and 72 animation files.
Their original labels and pointer expressions remain assembler source; binary
extraction recipes do not duplicate these resources. The fixed allocation lists
every semantic block and padding byte, including mixed mapping/DPLC tables,
unnamed frames, aliases inside pieces and stored but inactive pieces.

assembly_data parses only labels, byte/word declarations, bounded integer and
symbol sums/differences, and even alignment. assembly_content exposes typed
models and renders edited literals while retaining every structural expression
and label offset. It rejects growth, unknown syntax, retargeted structural
references, a different original declaration identity and packets from another
profile or lock-on component before producing source output. Cross-file frame
references must enter a registered semantic resource, and an external table base
must match the actual outer source alias.

Mappings use either the S3/S&K word count with six-byte pieces or the retained
Sonic 1 byte count with five-byte pieces. Models expose signed X/Y coordinates,
tile dimensions, VDP tile attributes and reserved size bits. The count remains
separate from stored pieces so original inactive records survive a round trip.
Player DPLC uses a high length nibble and direct count; ordinary-object DPLC
uses a low length nibble and count minus one. Transfers expose source tiles and
tile counts; the primitive encoder accepts explicit source-art and
destination-tile limits and rejects active transfers crossing them. Catalog
edits also retain the original table allocation and the hardware VRAM tile
ceiling. This is a fixed footprint source workflow; it does not relocate art or
infer new runtime code.

Animation models declare the actual consumer ABI per sequence. Object animations
have a shared delay and negative control bytes; player animations allow frame
IDs through 0xFB and use signed timing selectors for specialized runtime modes.
Irregular animations store frame/delay pairs. Some HCZ and Sky Sanctuary tables
mix the shared and per-frame forms. Rewind, animation change, restart, routine
advance, offscreen movement and no-progress commands remain distinct. The model
preserves fallthrough fragments, repeated unused commands and the skipped second
byte after an irregular routine-advance command. It reproduces the original
interpreter behavior, including the S3 irregular-restart quirk.

The complete round-trip command checks every applicable profile and both lock-on
component views against actual AS includes, labels and image bytes. It creates
encoded assembly source in the same ignored workspace as encoded binary assets.
The container command checks all resulting source hashes and builds all five ROM
profiles from that workspace; it never overwrites encoded source with the
original files. The current source fingerprint and tooling fingerprint bind
every report to the checked inputs.

## Palette rotation script source

The linked config/authoring/palette_formats.json catalog owns 29 scoped source
groups in 13 files, containing all 31 state initializers and 463 palette DSL
calls. It includes adjacent initializer arrays, named header chains, external
frame includes and the original color records stored after restart commands. The
surrounding code, data and source includes remain outside those exact physical
spans and are copied without modification.

palette_scripts parses the restricted declaration language and independently
models state initializers, normal-palette destinations, color counts, counter
limits, RGB frames, delays, header transitions, repeats and custom routine
commands. A frame has one to 64 CRAM colors; its first word must retain a clear
sign bit because the interpreter uses negative words for commands. The runtime
copies the low delay byte into a signed countdown, so editable durations are one
to 128 ticks. Header destinations must fit the 64-color normal palette staging
area. Reserved color bits remain explicit in the RGB model.

A zero counter limit makes negative commands restart at the current header's
first frame. Nonzero limits enable the original counter and transition logic;
therefore limits, color widths, state pointers and command graphs are structural
fields. The API edits inline RGB values, durations and bounded destination
positions while preserving those fields and all scoped label spellings. File
frame colors belong to their binary palette resource; this API edits their
duration and verifies the immutable source context by manifest hash. The source
encoder never creates a second owner for a shared palette file.

The actual AS proof checks every qualified local label and every emitted byte,
requires each transition to enter a registered header, and binds each
initializer to the first frame after its header. Both lock-on views keep their
component's assembly addresses in longwords; only physical image positions
receive the component offset. The encoder preserves stored records after a
terminal command without asserting they are reachable through the default
initializer graph.

Palette groups join raw-animation and indexed-palette fragments through one
shared source composer. Its 264 fragments produce 212 complete owner files
alongside the 613 whole-file mapping/DPLC/animation resources. Every final
source owner is hashed before the five-profile container rebuild. Contract
checks and synthetic edit tests need no ROM inputs; actual byte and container
checks require the private extracted assets and preservation builds.

## Composing inline source owners

source_fragments combines independently validated content regions against one
immutable copy of each complete source file. Each patch names its family owner,
physical line interval and original span hash. All intervals and destinations
must pass before any file is written; overlapping families, stale originals and
unknown source paths are rejected. Patches are applied together in reverse
original-line order, so adding lines to one encoded region cannot displace or
erase another family. Every byte outside the registered intervals is retained.

The palette workflow exposes prepared patches as well as its standalone round
trip. Additional inline content families use the same composer and contribute
their own semantic validation before source composition. Each final owner has a
single output hash and the report retains separate encoded-span identities.

## Actual bounded edits

`make check-content-edits` first requires the complete encoded-resource and
zero-edit container checks. It then copies that validated source/input tree to
another ignored workspace and changes one RGB channel bit in one independently
owned palette per engine. The public probe declaration names the resources and
semantic edit coordinates, without copying their private payloads.

The check exercises the actual content writer. A foreign-profile packet and an
overflowing model must fail before changing their allocated file. The valid
edits keep the original storage capacities. All five ROMs are assembled from the
edited workspace, with no original-tree include fallback.

Expected payload positions come independently from the preservation AS includes,
including every active consumer and the attached S3 component offset. Expected
images are constructed from verified originals plus those exact encoded bytes;
the cartridge word checksum is computed independently of the build pipeline.
Every rebuilt byte must agree. S3K must also equal the two independently rebuilt
siblings concatenated in the declared order. Every assembler symbol must retain
its normal value in each base profile.

The generated `build/authoring/edited-containers.json` binds the current source,
tooling, encoded baseline, exact changed ranges, owned consumer allocations,
actual image hashes, symbol listings and unchanged-allocation rejection checks.
The final 2.0 audit rechecks these files and every other source/input hash.
Preservation outputs and private original ROMs remain untouched. This proves
fixed-footprint palette editing; it does not claim variable allocation or
successful gameplay for arbitrary edits.

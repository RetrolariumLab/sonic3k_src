# Sonic the Hedgehog 3 / Sonic & Knuckles (SMD) Source Reconstruction

A byte-identical source reconstruction of **Sonic the Hedgehog 3** and **Sonic &
Knuckles** for the Sega Mega Drive / Genesis, maintained as a fork of
[Sonic Retro's Sonic 3 / Sonic & Knuckles disassembly](https://github.com/sonicretro/skdisasm).
The 68000 and Z80 source rebuilds three regional Sonic 3 images, Sonic &
Knuckles and the Sonic 3 & Knuckles lock-on composition from legally obtained
reference images.

The fork starts from upstream at
[`73de97c`](https://github.com/sonicretro/skdisasm/commit/73de97c6b55055bcb8089c1d55d006b02136f163).
Its Git history begins with a text-only snapshot import; the original authors
are credited in [CONTRIBUTORS.md](CONTRIBUTORS.md).

## Status

Source Reconstruction 1.0 establishes the byte-identical build, symbolic address
checks, relocated-source probes and original-ROM runtime comparisons. Source
Reconstruction 2.0 adds:

- 1979 source modules organized by subsystem and semantic owner;
- five preservation profiles, with Sonic 3 USA as the default;
- typed RAM, SRAM, Z80 and cartridge-composition contracts;
- round trips for 1778 private inputs and 613 assembly resources, plus palette
  scripts and raw/indexed animation groups;
- five byte-identical rebuilds from a newly encoded zero-edit export;
- two bounded nonzero palette edits rebuilt into all five ROMs, with exact
  changed-range, checksum and unchanged-symbol checks.

Runtime acceptance requires 165 short-attract comparisons and forty extended
comparisons covering longer attract, characters, Competition, special stage and
cartridge save reload. Finite RAM observations do not establish exhaustive
gameplay, pixel output or hardware equivalence. Complete ending sequences remain
outside the reached-state contract.

The entry points are `src/revisions/s3.s` and `src/revisions/sk.s`. Sonic 3 and
Sonic & Knuckles retain separate sibling engines. S3K concatenates the
separately built S&K and Sonic 3 USA images in that order; it adds no duplicate
source or asset tree. Community Complete builds are outside the preservation
profiles.

All 1571 reviewed address-named procedures and 35470 further inherited labels
have registered semantic names. The
[rename provenance](docs/provenance.md#label-provenance) retains their physical
identities and profile scope; naming does not establish every runtime path. Data
extracted from ROMs stays in ignored `data/`; generated images, listings,
reports and scratch files stay in ignored `build/`. ROM images, extracted
graphics, music, effects and samples are not distributed here.

## Quick start

The supported host is Windows x64 with Python 3.11+, Git, GNU Make and the
pinned Retrolarium Kit and Core dependencies. Kit supplies the AS Macro
Assembler and authentic p2bin compressor. See [building](docs/build.md) for
dependency pins and version checks, and [runtime setup](docs/runtime.md) for the
pinned MAME build.

```sh
git clone https://github.com/RetrolariumLab/sonic3k_src.git
cd sonic3k_src

# Keep your legally obtained dumps in a separate folder, using the filenames
# recorded in assets/manifest.json. The importer checks every image's hashes.
make init ROM_ROOT="path/to/dumps"
make split
make check-assets
make verify-all
```

Each verification compares the rebuilt image byte for byte with the supplied ROM
and checks its SHA-1 and SHA-256. All five reference images are required for
initialization. Supported profiles are:

| Profile | Reference image    | Selection                   |
| ------- | ------------------ | --------------------------- |
| `s3-us` | Sonic 3 USA        | Default, or `PROFILE=s3-us` |
| `s3-eu` | Sonic 3 Europe     | `PROFILE=s3-eu`             |
| `s3-jp` | Sonic 3 Japan      | `PROFILE=s3-jp`             |
| `sk`    | Sonic & Knuckles   | `PROFILE=sk`                |
| `s3k`   | Sonic 3 & Knuckles | `PROFILE=s3k`               |

Original filenames, canonical local paths, sizes and hashes belong to
`assets/manifest.json`. Regional Sonic 3 images differ at header byte 0x1f0.
Prototypes, modifications, compilations and Knuckles in Sonic 2 are excluded;
`config/revision_profiles.json` records their scope boundaries.

## Build and verify

```sh
make help                         # Show the public command catalog
make verify-toolchain             # Check the pinned assembler and p2bin
make check-assets                 # Check every extracted and derived asset
make build PROFILE=s3-us          # Assemble the selected profile
make verify                       # Build and compare the default profile
make verify PROFILE=sk
make verify-all                   # Build and compare all five images
make clean                        # Remove build results; keep private inputs
```

Outputs are written to `build/images/<profile>.bin`; standalone assembler
listings live in `build/objects/<profile>/main.lst`. Both Z80 drivers remain
executable assembly source. The build retains the original uncompressed Sonic 3
and Kosinski-compressed S&K driver segments, cartridge padding and checksum
rules.

```sh
make format                       # Apply the project style, then lint
make lint                         # Check source, code and text style
make test                         # Run the Python tooling tests
make scaffold-check               # Check public contracts without ROMs
make audit-private                # Audit the index and reachable Git history
make check-numeric-operands        # Check numeric addresses and constant aliases
make check-source-layout           # Check source ownership and naming
make check-memory-contract         # Check declarations without ROMs
make check-lockon                  # Compare 675 exports for each S3 region
make build-relocated              # Build the controlled relocation probes
make check-relocated              # Check their symbols and coverage
make trace                        # Compare preservation attract RAM in MAME
```

Built-range, lock-on and runtime checks need current assemblies and extracted
inputs. Run emulator scenarios serially. `make test` works without ROM files and
reports private-input cases as explicit skips. Editing belongs in Retrolarium;
this repository contains no GUI editor.

## Content models

The headless models describe tiles, palettes, blocks, chunks, layouts,
collision, object and ring placements, mappings, DPLC, animations, special-stage
data, geometry, demo input, SMPS and DAC data. Their profile, capacity and
address-space contracts are declared in `config/authoring/data_formats.json` and
explained in [data formats](docs/data_formats.md).

Core preparation requires CMake 3.21+, a C++17 compiler and a public Core
checkout containing the pinned revision. Set `RETROLARIUM_CORE_SOURCE` to that
checkout; the project archives the exact dependency commit and builds only below
ignored `build/`.

```sh
make prepare-core
make roundtrip-formats            # Decode and encode all registered content
make check-content-zero-edit      # Export content and rebuild all five ROMs
make check-content-edits          # Prove actual bounded edits in rebuilt ROMs
```

Unchanged decoded content retains the original compressed stream. Changed
payloads must fit their original allocations and obey their ABI, structural and
streaming-order contracts. Original object/ring ordering exceptions survive only
when the whole stream is unchanged. [Codec APIs](docs/content_codecs.md)
describes the public export boundary and format-specific constraints.

Variable allocation, expanded ROMs, engine merging and a general edited-ROM
composer are outside this release. See [known limits](docs/unknowns.md) and
[architecture decisions](docs/architecture_decisions.md).

## Release checks

The complete 2.0 command first runs the full 1.0 preservation gate, including
fresh extraction, all five original images, symbolic and relocation checks, and
MAME. It then checks historical source preservation, built ownership, memory and
Z80 contracts, content round trips, zero-edit and actual-edit rebuilds,
documentation and the classified source history.

Pre-tag gates require a committed candidate with no active release tag and no
publishing remote. Use a disposable checkout for that workflow:

```sh
git clone --no-tags https://github.com/RetrolariumLab/sonic3k_src.git sonic3k-check
cd sonic3k-check
git remote remove origin
make init ROM_ROOT="path/to/dumps"
make source-2-check
```

This checkout needs the same pinned Kit, Core and MAME setup. The aggregate
extracts its own private assets; old reports cannot certify changed source,
tools or public files. `make release-check` and `make source-1-check` run the
standalone preservation gate. `make source-2-audit` checks metadata;
`make source-2-release-audit` rechecks completed current acceptance.

After the maintainer creates the required annotated release tags, validate them
with `make release-audit AUDIT_MODE=--post-tag` and
`make source-2-post-tag-audit`. Checks create no tags and perform no push.
[Verification](docs/verification.md) describes evidence bindings and the exact
pre-tag/post-tag boundaries.

## Repository map

```text
assets/                 Reference image identities and extraction manifest
config/authoring/       Content formats, capacities and codec contracts
config/reconstruction/ Source origins, ownership, symbols and fixed regions
config/runtime/        Emulator, scenarios and runtime coverage contracts
docs/                   Architecture, formats, workflows and evidence
mk/                     Runtime, validation and content Make targets
scenarios/              Original-input movies and RAM comparison goldens
scripts/authoring/      Headless models, codecs and bounded export APIs
scripts/build/          Extraction, assembly and byte-identity checks
scripts/runtime/        MAME execution and runtime validation
scripts/validation/     Static, source-layout and release audits
src/                    Sibling 68000/Z80 engines and owned data declarations
tests/                  Tests mirroring the script package layout
data/                   Ignored private ROMs and extracted assets
build/                  Ignored generated outputs, tools and local evidence
```

Start with the [documentation index](docs/index.md),
[architecture](docs/architecture.md), [source layout](docs/source_layout.md) and
[memory map](docs/memory_map.md). See [CONTRIBUTING.md](CONTRIBUTING.md) for the
change and verification workflow.

## Credits

- Original games: SEGA, 1994.
- Original disassembly and community work: Stealth, Sonic Retro and the
  [upstream contributors](CONTRIBUTORS.md).
- AS Macro Assembler: Alfred Arnold.
- Build and codec dependencies: Retrolarium Kit and Retrolarium Core.
- Runtime validation: MAME.

The import revision, removed optional modifications and attribution boundaries
are recorded in [provenance](docs/provenance.md).

## Copyright and licensing

Original game copyright (C) 1994 SEGA. Game code, graphics, music and other game
data remain the property of their respective rights holders.

This repository does not distribute ROM images or extracted copyrighted assets.
Users supply their own legally obtained reference images. No license to the game
or imported upstream annotations is granted by this project; the upstream rights
status is `license_not_granted`. External Kit and Core dependencies retain their
own licenses. See [provenance](docs/provenance.md).

The following original Sonic Retro disclaimer is retained verbatim:

> Any and all content presented in this repository is presented for
> informational and educational purposes only. Commercial usage is expressly
> prohibited. Sonic Retro claims no ownership of any code in these repositories.
> You assume any and all responsibility for using this content responsibly.
> Sonic Retro claims no responsibiliy or warranty.

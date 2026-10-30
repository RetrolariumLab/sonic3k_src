# Sonic 3 / Sonic & Knuckles preservation source

Buildable, ROM-free reconstruction of the Sonic Retro disassembly. It preserves
Sonic 3 USA, Europe and Japan, Sonic & Knuckles, and the Sonic 3 & Knuckles
lock-on composition. Sonic 3 and S&K remain separate sibling engines. No game
images, extracted binary assets or compiler executables are distributed.

## Status

All five preservation images build byte for byte from verified private ROM
inputs. Direct original-image attract checks cover all five profiles, and the
675-label S3 second-cartridge ABI is checked independently for each S3 region.
The complete Source Reconstruction 1.0 gate passed from a clean clone, including
ROM-extracted SMPS storage, all-profile relocation and runtime. The 1.0 manifest
records the accepted commit and source binding; the tag remains a maintainer
action. Work continues toward 2.0 semantic source layout and editable format
contracts. No Source Reconstruction 2.0 release is claimed.

## Quick start

Install Python 3.11 or later, GNU Make and Retrolarium Kit. Compiler sources,
versions and binary hashes are pinned in `config/toolchain.json`; runtime
requires the MAME build pinned in `config/runtime/emulator.json`. See
[build instructions](docs/build.md) and [runtime setup](docs/runtime.md).

Supply your own legally obtained ROM dumps. Accepted filenames and image
identities are in `assets/manifest.json`. The importer checks their content
before writing canonical copies below ignored `data/roms/`.

```sh
make init ROM_ROOT="path/to/your/dumps"
make split
make check-assets
make verify-all
```

The profile IDs are `s3-us`, `s3-eu`, `s3-jp`, `sk` and `s3k`. Use
`make verify PROFILE=sk` for one image. All build outputs stay under `build/`.
The regional S3 images differ at header byte 0x1f0; S3&K is the exact
concatenation of S&K and S3 USA. Community complete builds and Knuckles in Sonic
2 are excluded, as recorded in `config/revision_profiles.json`.

With inputs split and the pinned emulator available, run the complete
preservation gate in one invocation:

```sh
make release-check
```

Run it serially; emulator scenarios must not overlap. `make test` works without
ROM files and reports the private-input case as an explicit skip. `make` lists
the public commands. Never commit `data/`, `build/`, ROM fragments or samples.

Read the [documentation index](docs/index.md), [open work](docs/unknowns.md),
[contribution rules](CONTRIBUTING.md) and [provenance](docs/provenance.md).
Editing belongs in Retrolarium; this repository contains no GUI editor.

## Rights and original disclaimer

The upstream annotation has no granted license (`license_not_granted`). Game
code and data remain the rights holder's property. This repository grants no
license to them. See provenance for the pinned upstream source and attribution.

The following original Sonic Retro disclaimer is retained verbatim:

> Any and all content presented in this repository is presented for
> informational and educational purposes only. Commercial usage is expressly
> prohibited. Sonic Retro claims no ownership of any code in these repositories.
> You assume any and all responsibility for using this content responsibly.
> Sonic Retro claims no responsibiliy or warranty.

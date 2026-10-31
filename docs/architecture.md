# Architecture

## Two sibling engines

src/revisions/s3.s assembles Sonic 3; src/revisions/sk.s assembles Sonic &
Knuckles. Each entry orders subsystem owners and shared resources. The engines
remain independent programs with their own object, level and game-mode behavior.
Shared memory declarations live under src/memory/shared; S3 applies its explicit
overrides from src/memory/s3. Hardware, cartridge SRAM, main RAM, overlay fields
and byte-sized sound identifiers have checked declaration domains.

Both entries begin with the vector table and cartridge header, then bootstrap
through `EntryPoint`. `GameModes` dispatches the active mode; `VInt` and `HInt`
serve video interrupts. `Level` drives level gameplay, `Load_Level` consumes
level-owned tables, `Process_Sprites` updates object state, and `Render_Sprites`
produces the sprite display. These names occur independently in both engines;
similar names do not prove identical implementations.

Tails retains dedicated slope routines in S3. Its S&K mode dispatch calls the
existing player-common slope routines instead. Source ownership preserves this
product distinction alongside the separate flight and carrying implementations.

## Graphics and level content

`src/` places common UI, player, object, zone and debugging data under their
semantic owners. Source tables retain mappings, DPLC, animation and other
assembler-owned structures. `docs/source_layout.md` describes the checked
ownership registry and its historical preservation checks. The binary payloads
named by those includes are extracted under the corresponding paths in `data/`.
Nemesis, Kosinski, moduled Kosinski and Enigma decoders remain executable
source. The asset manifest identifies storage ranges; editable format and
capacity contracts live separately in config/authoring/data_formats.json.

The S3 Sega-screen actor keeps its preceding debug dispatch shim in the same
bounded owner. `Func_Listing` is an empty indexed function-list label sharing
the address of `Obj_SonicOnSegaScr`; it emits no table data. The shim reads that
label through indexed PC addressing. Keeping both in
`src/objects/interface/s3/sega_screen_actor.s` preserves the actual indexed span
and return cohort instead of placing a relocation probe between the empty
listing label and its aliased entry.

## Audio

src/audio/driver contains the shared Z80 runtime split by responsibility:
bootstrap and interrupts, track updates, FM/PSG handling, sound loading,
coordination commands, fades and digital playback. Helpers, RAM layout,
frequency/bank tables and pointer tables have separate typed owners. The
cartridge container retains both original physical reservations and explicit
virtual CPU contexts. Historical statement comparison, independent track/RAM
allocation and AS object coverage check those boundaries. Authentic p2bin
conversion reproduces compressed S&K segments and uncompressed S3 segments.

Scores, instrument values, envelopes and samples are private ROM-derived
resources. Only driver code, structural pointers and extraction metadata are
tracked. Sample rate and length remain text metadata. No WAV conversion is
needed for byte identity.

## Lock-on boundary

src/memory/lockon/sonic3_exports.s describes the separately attached S3
cartridge at 0x200000 without emitting its bytes into the base S&K image. Its
exported labels are compared with independently assembled S3 labels. Composite
construction concatenates verified components; engine relocation must keep the
attached S3 half on that external ABI. Sonic 2 compatibility slots are a
separate fixed interface whose game profile is excluded.

## Host tools

`scripts/build/` validates inputs and tool pins, assembles, links and compares
images. `scripts/validation/` checks external exports, numeric operands and Git
privacy. `scripts/runtime/` prepares the pinned emulator and serial RAM checks.
`mk/runtime.mk` exposes runtime commands. Tests exercise these contracts without
requiring distributed game bytes. No host GUI editor is part of the repository.

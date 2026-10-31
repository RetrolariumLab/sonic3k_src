# Source ownership and ranges

`config/reconstruction/source_layout.json` records each assembler unit's owner,
responsibility, physical line count and source range at the preservation
baseline. Owned data lives under `src/objects`, `src/rendering`, `src/ui`,
`src/game` and `src/system/debug`. Engine-specific code remains separate.

This registry is intentionally incomplete during extraction: 886 data owners,
1043 sibling executable owners, 5 definition libraries, 10 checked memory
modules and 20 structural composition modules. The 2 remaining driver and
external-ABI containers still await complete semantic ownership. The inventory
keeps that distinction explicit; a complete source layout cannot accept pending
entries.

Every owned cartridge unit has independently checked normal-build ROM ranges,
including the applicable component and offset in the lock-on image. After an
all-profile build, run
`python -m scripts.run validation.source_layout --inventory --built` to compare
these ranges with AS include-depth records and the current source binding. Macro
expansion records do not close their containing file's interval.

Executable units target 300--700 physical lines; cohesive units may reach 900.
Larger units require a named, checkable cohesion exception. Only a verified
assembler data ledger may exceed 2000 lines. Existing player mapping/DPLC
families use explicit data exceptions: the checker rejects CPU instructions,
unknown emitting macros and unbalanced data macros inside those files. Small
data resources retain their named owner instead of being padded or combined
solely to meet a size target.

No code or data labels were renamed in this move. The mandatory
`config/reconstruction/label_renames.json` records that empty migration.

The final water-transition and enemy-art catalog sentinels share the addresses
of the following demo-input and bubble-emitter entries. Their explicit
`data-end-code-alias` contracts in the relocation policy retain the preservation
baseline's code-entry coverage. Normal assembly and every relocated symbol proof
must keep the alias equal to its independently discovered target; assigning
different source owners cannot silently discard the alias or change that
relationship.

Comments mark the ends of object programs that finish with a shared display or
solid-collision tail call. The registry records these as "added_annotations"
with historical source ranges. The checker requires a terminal instruction and
allows only checked data after it. Relocation may place its unreachable probe
after that complete tail; normal assembly emits no bytes for the comments. An
existing annotated closure takes precedence over a derived EOF data boundary.

Permitted emitting data macros have a separate definition contract in
`config/reconstruction/data_macros.json`. The checker scans every source unit,
requires the reviewed definition hashes and rejects executable instructions,
unknown emitting operations, duplicate definitions and unbounded encoding
contexts even if a definition hash is changed. Palette-script file calls also
require literal word-sized frame counts and a manifest-owned binary resource.
This check precedes data-ledger acceptance and needs no ROM payloads.

The emitter contract also covers the complete alignment-helper dependency graph.
The checker understands nested assembler iteration blocks, rejects unchecked
primitive overrides and requires an acyclic reviewed helper closure. Data
ledgers may request only bounded literal power-of-two alignment or argument-free
`even`. Both fill variants (`align`/`align0` and `cnop`/`cnop0`) use the same
reviewed helper closure. An explicit offset must be a literal strictly within
its alignment interval. Dynamic offsets and direct `org`/`org0` remain
unavailable there. Debug-list calls require a literal owned data-source include
and participate in the same cycle checks as ordinary data includes. PLC pointer
declarations use compile-time labels and data words only.

Definition libraries have their own role. Their top level accepts only named
constants/functions, the explicit compiler setup options, balanced known text
encoding contexts and complete macro definitions. Instructions and data may
occur inside a macro body, but cannot execute when the library is included.
Independent AS include ranges must have identical start and end addresses for
every applicable profile. Unknown roles and unchecked address spaces are
rejected; include wiring cannot claim executable ownership without an actual
return or terminal procedure.

## Historical preservation comparison

Make check-source-preservation builds the pinned pre-layout preservation
baseline in a detached checkout under ignored build/provenance. The baseline's
own tooling discovers its normal code entries and original annotated procedure
boundaries. Current normal entries must retain every name and address, and the
original procedure multiset must remain unchanged. Added terminal annotations
must not absorb any earlier independent return boundary. The check rejects the
current commit as its own reference and verifies the historical revision is an
ancestor, so a new empty comparison cannot silently replace the accepted base.

The historical checkout uses the same verified private inputs and builds all
five original containers. This supplements byte identity and relocation/runtime
checks; it does not replace either. Cached historical source must remain clean.

## Memory declaration owners

Shared object offsets, hardware ports and clocks, odd-byte SRAM, the complete
68000 RAM map, special-stage overlays, art tile assignments and sound
identifiers have separate owners under src/memory. Sonic 3's RAM changes form
one explicit override module. The allocation cursor resets before the cartridge
vectors.

Memory modules use a distinct declaration role, not executable or ROM-data
ownership. Every module explicitly disables padding. The grammar accepts only
named EQU/SET declarations, explicit offset enumerations, balanced declared
PHASE regions, uninitialized DS reservations and bounded fatal-only capacity
guards. It rejects instructions, includes, initialized storage, CPU switches,
nested or unknown phases and allocation primitive overrides. SRAM reserves words
so its live bytes stay at odd bus addresses.

Make check-memory-contract checks this grammar without ROMs. Make
check-memory-layout additionally requires a fresh historical preservation
witness and current assemblies. Every declared global symbol must match the
pre-layout baseline for its applicable product. Actual AS includes establish
applicability. RAM, sound identifier and odd SRAM domains are checked.

The built proof also reads AS absolute records and independently accounts for
every physical cartridge byte exactly once. It reconciles both virtual Z80
segments with their physical containers, bounded reservations, product padding
and header patches. The CPU identifier alone never selects an address space.
This prevents an allegedly non-emitting allocation from hiding cartridge data.

## Revision composition and sound-bank owners

The profile roots in src/revisions select one sibling engine's canonical order.
Their source-order modules contain only checked includes; they have no synthetic
return instructions or hidden executable ownership. Private music, effects and
DAC inputs live in separate original bank owners under src/audio/banks. Fixed
cartridge tails keep the original product padding and physical boundary.

Composition contracts distinguish include order, profile entry, fixed tail and
bank allocation. A bank includes checked data owners and extracted resources.
The canonical entry order places the Z80 driver at its original separate
physical reservation and virtual contexts. Its reviewed compile-time helper
closure is pinned separately and rejects executable helper syntax. The DAC setup
helper's sole recursion supplies a nonempty default parameter and terminates on
that second invocation.

Make check-composition-contract checks these structural declarations. Make
check-composition also checks current AS ranges, applicable profiles, 32-KiB
window boundaries, aligned starts and the end-aligned initial bank reservation.
Entry contracts must match the revision profile configuration; tail templates
must finish at the original 2-MiB boundary.

## Second-cartridge declaration window

The original lock-on map is owned by src/memory/lockon/sonic3_exports.s. Its
non-emitting phase starts at the caller's existing 0x200000 cursor and describes
exactly the two-MiB second cartridge. An independent byte cursor accounts for
every literal reservation and bounded DAC metadata declaration; all 675 address
fields must match that cursor and the historical build.

Its single DACDECLARE helper can only declare sample rate, size and an
uninitialized byte reservation. Initialized data, other macro bodies, missing
space, overflow and a different bus base are rejected. The existing lock-on gate
still compares every export with actual Sonic 3 source plus 0x200000 in all
three regional builds. This adds no second-cartridge Sonic 2 runtime profile.

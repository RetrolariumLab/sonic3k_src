# Source ownership and ranges

`config/reconstruction/source_layout.json` records each assembler unit's owner,
responsibility, physical line count and source range at the preservation
baseline. Owned data lives under `src/objects`, `src/rendering`, `src/ui`,
`src/game` and `src/system/debug`. Engine-specific code remains separate.

The registry has 1978 owned units: 886 data owners, 1042 executable owners, 4
definition libraries, 10 checked memory modules, 20 structural composition
modules and 16 typed Z80 driver owners. No source unit remains pending. The
shared child initialization module represents two historical executable owners.
Source-layout acceptance also requires the built range, historical ABI and
physical object coverage checks.

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

The ownership and filename moves retained existing symbol spellings. The later
semantic naming migration is recorded separately in the mandatory
`config/reconstruction/label_renames.json`: it maps 1571 physical procedures and
their references while preserving the emitted bytes and original namespace
separation. Historical source paths and procedure boundaries remain traceable.
The layout registry's `path_moves` entries bind original paths to current
owners. The label audit resolves each original file through that mapping and
reverses the corresponding `include` path updates before comparing statements.
Shared executable owners have a separate `shared_sources` contract. Each variant
records its historical path, provenance, compilation profiles and the literal
label prefix passed immediately before the include. The audit expands the prefix
and restores the include path for each historical view. Relocation checks the
physical cohort boundaries in every view and uses the resolved code labels when
reading the corresponding AS listing.

The completed semantic continuation also covers 35470 further inherited labels,
partitioned by subsystem in `config/reconstruction/semantic_labels.json`. Every
packet is applied. The checker preserves original physical declarations and
requires reversible token edits, including subsequent short names and their
explanatory comments. No new runtime coverage follows from naming alone.

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
pre-layout baseline for its applicable product. Renamed symbols resolve through
the validated profile-specific catalog to their original historical names;
missing declarations, changed values and ambiguous destinations remain errors.
Actual AS includes establish applicability. RAM, sound identifier and odd SRAM
domains are checked.

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

The original lock-on map is owned by src/memory/lockon/sonic3_exports.inc. Its
non-emitting phase starts at the caller's existing 0x200000 cursor and describes
exactly the two-MiB second cartridge. An independent byte cursor accounts for
every literal reservation and bounded DAC metadata declaration; all 675 address
fields must match that cursor and the historical build.

Its single DACDECLARE helper can only declare sample rate, size and an
uninitialized byte reservation. Initialized data, other macro bodies, missing
space, overflow and a different bus base are rejected. The existing lock-on gate
still compares every export with actual Sonic 3 source plus 0x200000 in all
three regional builds. This adds no second-cartridge Sonic 2 runtime profile.

## Z80 driver ownership

The driver lives under src/audio/driver. Its cartridge container retains the
original two physical reservations, SAVE/RESTORE pairs, virtual origins and
capacity assertions. Ordered children own RAM, helper definitions, runtime
subsystems, frequency/bank data and pointer tables. Every emitting child
declares CPU Z80 inside the original saved context. The RAM child leaves the
caller CPU unchanged and allocates no cartridge bytes.

Make check-z80-contract compares all original statements with the independently
pinned pre-extraction source. Only comments, spacing and the explicit leaf
context prefixes differ. Labels, instructions, macro bodies, conditionals,
resource paths and wrapper order remain checked. Executable children need real
Z80 instructions; data cannot execute instructions. Code includes only the
extracted sixteen-byte delta codebook; table resources require extraction
recipes. Unknown CPU, origin, include and iteration directives are rejected.

The RAM parser independently computes the 48-byte track fields, aliases and all
25 track instances. Music and effects occupy their declared RAM; song backups
explicitly overlay effects and end at 0x1FA0. The final 96 bytes up to 0x2000
remain reserved for the stack. Make check-z80-driver compares these
independently computed fields and original code/table entry addresses with the
accepted 1.0 build, checks actual AS child ranges in 0x0000--0x1300 and
0x1300--0x1C00, and requires the current physical object coverage and cartridge
identity witness.

## Source filename convention

All source basenames use lowercase snake_case, at most three words, and the
nearest semantic directory context. Names describe the primary entity rather
than enumerating every child operation. Mapping, animation and DPLC declarations
are grouped by kind beneath their existing semantic owner; repeated mode-name
directories are collapsed without changing content sharing or include order.

The `.s` suffix identifies 68000 code, structural composition and emitted
content declarations. Shared definitions and memory declarations use `.inc`;
typed Z80 driver modules use `.asm`. Supplemental official AS lint covers those
`.asm` files through disposable `.s` copies. Source-layout checks enforce names,
suffixes and ownership of every file below `src/`. Filename normalization does
not rename assembly labels. Subsequent reviewed symbol changes have their own
physical, profile-scoped entries in the canonical label rename registry.
Historical source origins continue to name the exact files at their original
commits. The historical entry and procedure comparison remains mandatory.

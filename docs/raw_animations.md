# Raw sprite animation source

The registered source catalog is `config/authoring/raw_formats.json`, linked
from the main content registry. It currently covers all 72 explicitly named
`AniRaw_*` declarations and 158 source spans supplied by adjacent static
NoSST/external-player calls. Twenty-one spans belong to both sets: there are 209
distinct groups in 79 source files. This is a checked subset, not a claim that
every object-state or pointer-table flow has been classified.

`RawCatalog` exposes profile-bound decode/encode packets. A packet binds the
source declaration tree, scoped entry symbol, byte capacity, exact external
symbol dependencies, entry offsets and interpreter ABIs. Only frame values, flip
fields and counter values can change. Labels, command types, signed jump
displacements, stored entry boundaries, byte lengths and alignment remain fixed.
Cross-profile, cross-component and cross-ABI packet reuse fails before workspace
writes. These are preservation allocations, not a relocating linker.

## Interpreter families

The interpreter is selected by a registered consumer, never guessed from byte
shape. The same bytes can have different fixed-delay and frame/delay views.

| ABI                             | Storage and command interpretation                                                                       |
| ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| fixed                           | One shared delay-counter byte, then frame bytes; negative bytes dispatch commands.                       |
| pairs                           | Frame/delay-counter pairs; there is no shared timing header.                                             |
| fixed/pairs flip x or y         | Bit 6 toggles the selected render flag; the normal frame value uses bits 0–5.                            |
| extended-fixed / extended-pairs | Only FF introduces a command; frames 80–FE remain valid.                                                 |
| accelerating                    | Initial counter and completion limit precede the frame sequence; any negative marker ends a cycle.       |
| decelerating                    | Maximum counter and a shared completion-limit/restart-frame byte precede the remaining frames.           |
| external-player-s3              | Shared counter followed by frame/flip pairs; FF calls the object's custom routine and frame 00 is valid. |
| external-player-sk              | Shared counter followed by frame/flip pairs; 00 calls the object's custom routine and frame FF is valid. |
| sentinel                        | The Tails carry reader uses frame bytes with no timing header; FF restarts the sequence.                 |

The standard command slots are FC restart, F8 signed displacement from the
current script base, and F4 custom routine. The extended readers prefix these
with FF. Changing a base is not an ordinary cursor jump: the target supplies its
own header, and subsequent F8 offsets use that new base. The graph codec follows
these edges, supports cycles and checks overlapping views for byte agreement. A
flat substream ends at its first command. Every stored byte must belong to a
typed graph node or explicit zero alignment; there is no generic raw-data
fallback.

Counters are stored byte values, not normalized durations. Original runtime
quirks remain visible: restart helpers load the initial frame directly without
the normal flip-bit handling, and the decelerating reader also uses its second
byte as both a completion limit and restart frame. The S3 external-player reader
takes its script in A1 and updates Player 1 through A2; the SK reader takes its
script in A2 and its player in A1. Their shared function spelling does not imply
a shared ABI.

The primary readers are in `src/objects/runtime/{s3,sk}/raw_animation.s`. The S3
external-player reader is in
`src/objects/bosses/lbz/final_boss_2/s3/motion_and_ending_helpers.s`. The carry
reader remains in the Tails carrying source. The source and its active AS
symbols are authoritative when interpreting a consumer.

## Verification and source generation

`make check-content-contract` checks catalog shape and source identities without
ROMs. `make check-content-zero-edit` additionally binds every applicable base
profile to its AS include interval, emitted bytes and qualified labels. The S3K
view preserves component assembly addresses and shifts only the physical S3
position by 2 MiB.

The raw source writer accepts bounded dc.b declarations, scoped labels, even
alignment and a small arithmetic/bitwise expression grammar. It uses no eval,
assembler execution, includes or opaque binary directives. Symbol expressions
remain structural; literal fields are generated from the semantic graph.

Palette and raw fragments are composed together once, against original line
intervals, before complete source owners are written. Both families can share
one parent source file without overwriting each other's generated text. The
actual combined encoded source tree then builds every preservation container; no
original source file replaces a generated source owner during that check.

## Remaining coverage

Static object-state assignments and indirect pointer-table paths beyond the
registered named/direct subset remain under review. Several scripts change
interpreters between states or exit before their stored terminator, and some F8
targets cross global declaration boundaries. These need closed allocation and
consumer-state contracts before their source edit packets are registered. A
pointer in object field 30 alone is not sufficient evidence of raw animation:
that field is also used for collapse timers and other object-specific data.

# Source ownership and ranges

`config/reconstruction/source_layout.json` records each assembler unit's owner,
responsibility, physical line count and source range at the preservation
baseline. Owned data lives under `src/objects`, `src/rendering`, `src/ui`,
`src/game` and `src/system/debug`. Engine-specific code remains separate.

This registry is intentionally incomplete during extraction: 838 data units and
1043 sibling executable units and 5 definition libraries have owners. The 6
remaining entry, driver, memory and macro units still await complete semantic
extraction. Run `make source-layout-inventory` for that distinction.
`make check-source-layout` rejects pending entries and cannot certify this
intermediate tree as 2.0.

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
`even`; implementation helpers such as `org` and `cnop` remain unavailable
there. Debug-list calls require a literal owned data-source include and
participate in the same cycle checks as ordinary data includes. PLC pointer
declarations use compile-time labels and data words only.

Definition libraries have their own role. Their top level accepts only named
constants/functions, the explicit compiler setup options, balanced known text
encoding contexts and complete macro definitions. Instructions and data may
occur inside a macro body, but cannot execute when the library is included.
Independent AS include ranges must have identical start and end addresses for
every applicable profile. Unknown roles and unchecked address spaces are
rejected; include wiring cannot claim executable ownership without an actual
return or terminal procedure.

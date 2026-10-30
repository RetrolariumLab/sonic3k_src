# Source ownership and ranges

`config/reconstruction/source_layout.json` records each assembler unit's owner,
responsibility, physical line count and source range at the preservation
baseline. Owned data lives under `src/objects`, `src/rendering`, `src/ui`,
`src/game` and `src/system/debug`. Engine-specific code remains separate.

This registry is intentionally incomplete during extraction: 667 data units and
four sibling bootstrap/interrupt units have owners. The 60 remaining entry,
driver, memory and macro units still await complete semantic extraction. Run
`make source-layout-inventory` for that distinction. `make check-source-layout`
rejects pending entries and cannot certify this intermediate tree as 2.0.

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

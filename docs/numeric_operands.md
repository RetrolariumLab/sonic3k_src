# Numeric operand audit

Run `make check-numeric-operands` without ROM inputs. It scans every tracked
`.s` and `.inc` file and records its inventory under `build/audits/`.

The check rejects explicit numeric 68000 branch/call targets, address-register
loads, absolute memory operands (including bare AS syntax), and PC-relative
literal displacements. It tracks AS CPU selection and save/restore while
checking Z80 control targets and explicit absolute memory operands. Object-field
offsets, symbolic label arithmetic and immediate data-register scalars remain
valid. Z80 `$` means the current instruction and remains a symbolic self-loop.

Numeric longwords in the cartridge-address range from 0x8000 to 0x3fffff need an
exact owner, operand, count, scalar type and consumer explanation in
`config/reconstruction/numeric_scalars.json`. The current 22 entries represent
16 signed 16.16 position steps and six decimal-digit weights. The validator
rejects stale exceptions and never permits an exception for a control or
address-register operand. Collision scan distance and Nemesis row count use
separate named scalar constants even though address registers carry them.

This static inventory covers explicit syntactic address forms. It does not prove
that an arbitrary value loaded into a data register or a byte/word table cannot
later be used as a pointer. Source review, independent lock-on symbol checks and
runtime relocation probes supply separate evidence for those cases.

# Numeric operand audit

Run `make check-numeric-operands` without ROM inputs. It scans every tracked
`.s` and `.inc` file and records its inventory under `build/audits/`.

The check rejects numeric 68000 branch/call targets, address-register loads
(including `SP`), absolute memory operands (including bare AS syntax), and
PC-relative literal displacements. It resolves `equ`, `set`, `=` and `:=`
constant expressions and alias chains across source files, including local
symbols and alternative definitions. Arithmetic is bounded; numeric cycles,
overflow and unsupported numeric expressions cannot exempt an address operand.
Named RAM and hardware interfaces retain their classifications, including
sign-extended word address-register loads. Genuine label arithmetic,
object-field offsets and immediate data-register scalars remain valid.

AS CPU selection and save/restore delimit the Z80 checks for explicit numeric
control targets and absolute memory operands. Z80 `$` means the current
instruction and remains a symbolic self-loop. Constant-alias resolution applies
to the 68000 audit.

Numeric longwords in the cartridge-address range from 0x8000 to 0x3fffff need an
exact owner, operand, count, type and consumer explanation in
`config/reconstruction/numeric_scalars.json`. Existing scalar records describe
signed 16.16 position steps and decimal-digit weights. Resolving named constants
also exposes original font scanlines, a cartridge header boundary and the
external Sonic 2 sprite-list interfaces.

Exceptions for those newly exposed forms additionally bind the complete
instruction and every resolved value. This includes scalar collision distances
and Nemesis row counts carried in address registers, the fixed Sonic 2 lock-on
entry point, and two preserved original Balloon reads of absolute address 5.
Changing an opcode, destination register, alias value, owner, path or occurrence
count invalidates the exception. There is no blanket exemption for calls or
address-register operands, and stale exceptions fail the check.

This static inventory covers explicit syntactic address forms. It does not prove
that an arbitrary value loaded into a data register or a byte/word table cannot
later be used as a pointer. Source review, independent lock-on symbol checks and
runtime relocation probes supply separate evidence for those cases.

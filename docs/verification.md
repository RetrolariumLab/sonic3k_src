# Verification and evidence

## Implemented checks

| Command                       | Evidence                                                                                   |
| ----------------------------- | ------------------------------------------------------------------------------------------ |
| `make lint`                   | Read-only AS, text, Python, JSON and Markdown style checks                                 |
| `make test`                   | ROM-less build, ABI, privacy, numeric-operand and runtime contract regressions             |
| `make verify-toolchain`       | Pinned compiler/linker binaries                                                            |
| `make check-audio-storage`    | ROM-less audio ownership, ABI and bank bounds                                              |
| `make check-audio-binding`    | Independent audio addresses and dialects in every standalone profile                       |
| `make check-assets`           | Every manifest-owned extracted payload                                                     |
| `make verify-all`             | Cleanly assembled images compared with all five private reference images                   |
| `make check-lockon`           | 675 exports against each independently assembled S3 regional symbol table                  |
| `make check-numeric-operands` | Explicit numeric address forms and exact scalar exceptions                                 |
| `make verify-emulator`        | Pinned executable prepared under ignored build storage                                     |
| `make trace`                  | Direct preservation attract RAM comparison for every profile                               |
| `make audit-private`          | Reachable historical Git paths and index checked for private bytes and undeclared binaries |

Build identity reports and source bindings live below `build/`. ABI and runtime
checks reject stale source evidence and altered artifacts. Golden generation is
separate from checking and uses original images only. Runtime writes a result
only after its movie check succeeds; no screenshot comparison is used.

## Relocation and release limits

The public [relocation producer](relocation.md) builds every declared variant
and checks exact source-derived cohort coverage and independent symbol movement.
The complete clean-clone 1.0 gate passed after the SMPS storage migration,
including all 160 relocated and five preservation runtime cases. Its commit and
source binding are recorded in the release manifest. Exploratory artifacts are
not substitutes for these public commands.

`make release-check` fails at the first unsuccessful stage: style and metadata,
tests, private inputs, clean assembly, identity, complete relocation, relocated
runtime, privacy/publication audit and clean tracked tree. Source 2.0
additionally requires semantic source ownership and validated editable data
contracts. Run `make source-2-check` for both layers; `make scaffold-check`
checks public structure without ROMs. See the
[2.0 gate](source_reconstruction_2_0.md) and [known limits](unknowns.md).

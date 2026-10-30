# Verification and evidence

## Implemented checks

| Command                       | Evidence                                                                                   |
| ----------------------------- | ------------------------------------------------------------------------------------------ |
| `make lint`                   | Read-only AS, text, Python, JSON and Markdown style checks                                 |
| `make test`                   | ROM-less build, ABI, privacy, numeric-operand and runtime contract regressions             |
| `make verify-toolchain`       | Pinned compiler/linker binaries                                                            |
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
All 160 relocated runtime cases have passed. ROM-extracted SMPS storage and
clean-clone aggregate acceptance are still pending. Exploratory candidates are
not substitutes for these public commands.

The candidate `make release-check` sequence fails at the first unsuccessful
stage: style, tests, private inputs, clean assembly, identity, complete
relocation, relocated runtime, privacy/publication audit and clean tracked tree.
Its input and evidence manifests must be reproducible from a clean clone. Source
2.0 also requires semantic source ownership and validated editable data
contracts. See [remaining work](unknowns.md).

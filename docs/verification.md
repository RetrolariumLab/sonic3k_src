# Verification and evidence

## Implemented checks

| Command                       | Evidence                                                                                          |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| `make lint`                   | Read-only AS, text, Python, JSON and Markdown style checks                                        |
| `make test`                   | ROM-less build, ABI, privacy, numeric-operand and runtime contract regressions                    |
| `make verify-toolchain`       | Pinned compiler/linker binaries                                                                   |
| `make check-audio-storage`    | ROM-less audio ownership, ABI and bank bounds                                                     |
| `make check-audio-binding`    | Independent audio addresses and dialects in every standalone profile                              |
| `make check-assets`           | Every manifest-owned extracted payload                                                            |
| `make verify-all`             | Cleanly assembled images compared with all five private reference images                          |
| `make check-content-edits`    | Actual typed edits rebuilt into five ROMs, exact owned/checksum differences and unchanged symbols |
| `make check-lockon`           | 675 exports against each independently assembled S3 regional symbol table                         |
| `make check-numeric-operands` | Explicit numeric address forms and exact scalar exceptions                                        |
| `make verify-emulator`        | Pinned executable prepared under ignored build storage                                            |
| `make trace`                  | Direct preservation attract RAM comparison for every profile                                      |
| `make audit-private`          | Reachable historical Git paths and index checked for private bytes and undeclared binaries        |

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

The 2.0 baseline passed the full aggregate from a clean clone. Its manifest
records the accepted commit and source/tooling identities. The successful run
included all 1979 source owners, the complete runtime matrix and all five
containers assembled from the actual encoded resource tree. Generated reports
remain local and every changed release candidate must run the full gate again.

## Candidate and annotated-tag audits

Pre-tag acceptance uses a clean checkout without publishing remotes. It rejects
the active future release tag; an owner-deferred predecessor tag may be absent.
An existing predecessor tag must be annotated and name the accepted commit.

After the owner creates release tags, `make source-2-post-tag-audit` requires
the completed current aggregate, its unchanged final audit, an annotated 2.0 tag
on HEAD and an annotated 1.0 tag on the exact predecessor. Both annotations need
a summary. The manifests in the corresponding commits must agree with these
identities. `make release-audit AUDIT_MODE=--post-tag` performs the preservation
layer's current artifact and local tag checks. No command creates a tag or
pushes. Remote publication identity remains an explicit owner verification.

Post-tag reports use separate files below `build/release/`; they never overwrite
the pre-tag reports or hashes that establish full aggregate acceptance. A
metadata-only check is not sufficient. Tests use in-memory tag observations and
do not create release refs.

`make source-2-release-audit` can also recheck an already completed pre-tag
aggregate. It first requires every completed stage and the unchanged accepted
final audit, then checks current artifacts again. The resulting preservation and
2.0 re-audits use `build/release/reaudit.json` and
`build/release/source-2-reaudit.json`. They preserve the primary completed
aggregate and both accepted audit files. An in-progress aggregate still uses the
final audit stage's ordinary report; post-tag checks remain a separate mode.

A ready 2.0 candidate retains the 1.0 preservation manifest as a component. That
inactive component may keep its development status while all preservation
requirements remain mandatory. The tag audit validates the active 2.0 identity
and its exact accepted 1.0 predecessor. An active development 1.0 release is
still rejected; changing an inactive status cannot bypass active tag checks.

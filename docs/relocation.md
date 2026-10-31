# Procedure relocation probe

`make build-relocated` creates source copies and builds every variant below
ignored `build/relocated/`. `make check-relocated` derives the expected coverage
again from current source and verifies the matrix. No saved research source or
original developer checkout is an input. Run `make verify-all` first.

The generated tree receives hash-checked copies of the declared private binary
inputs. AS searches only that tree: an absent transformed include is an error,
not permission to use the preservation source. Synthetic real-AS regressions
check nested source edits and missing input rejection.

## Source-derived physical cohorts

The collector discovers return-bearing and annotated procedure files rather than
trusting only a maintained path list. The policy must name exactly those files.
Every 68000 `rts`/`rte` site and every imported function-end annotation has an
owner. Fallthrough aliases share the actual terminal; an end comment alone never
authorizes inserting an executed return into a live fallthrough. Unannotated
return boundaries add perturbations beyond the annotated functions.

Short conditional branch spans, signed 8-bit indexed PC displacement spans and
indexed instruction-table slots remain inseparable. For example, inserting a
word between `LS_Level_Order(pc,d0.w)` and its table can exceed the 68000 index
extension's range even though both references are symbolic. The table and its
reader therefore move together. Internal return sites in such a span belong to
the next safe physical terminal. No return site or annotated member disappears
when cohorts merge; exact ownership counters are checked.

The accepted preservation baseline has 7152 return sites and 2559 imported
annotations. Semantic owners also record explicitly checked terminal
annotations; the current source determines its physical boundaries. These are
derived counts, not acceptance constants. The matrix partitions every boundary
once over the 32 groups in `config/reconstruction/relocation.json`. Each
selected terminal gets an unreachable duplicate `rts`/`rte`; a pure tail-jump
terminal gets an unreachable return guard. Procedure-owned trailing data stays
inside its cohort.

An additional unreachable return before `ErrorTrap`, immediately after the fixed
header, moves the initial engine code too. In S&K `ErrorTrap` deliberately falls
through into `EntryPoint`; the guard must never split that path. Vectors and the
header stay fixed and the assembler recomputes their code references.

## Timing and storage constraints

Probe-only `bra.s` and `bsr.s` may widen to word form when necessary. MC68000
timings are identical for these forms (10 and 18 clocks respectively), as
recorded from
[MC68000 User Manual, table 8-9](https://www.nxp.com/docs/en/reference-manual/MC68000UM.pdf)
in the policy. Indexed branch slots cannot grow. Conditional branches, indexed
addressing and absolute call conversion are never widened to hide an overflow.
Any remaining assembler failure fails the matrix.

The verifier checks every fixed-region/interface symbol, all 675 S3 external
exports, even code addresses within the base image, and movement of every
discovered independently assembled code entry across the matrix. It reconstructs
the transformed source and every permitted widening, verifies artifact sizes and
hashes, and rejects missing or duplicate groups, cohorts and profiles.
Music/sample storage remains at the preserved bank locations; ordinary bank
origins are aligned, the first allocation stays aligned to the bank end, and the
complete stored suffix is unchanged.

S3 USA, Europe and Japan are assembled separately in every group. S&K is also
assembled directly. The S3&K artifact combines relocated S&K with the verified
preservation S3 USA half, retaining the second-cartridge ABI. It does not use
the separately relocated standalone S3 image as its attached cartridge.

## Runtime and acceptance

`make trace-relocated` validates the manifest before replaying every variant and
profile against its original-image RAM golden. Runtime evidence records source,
scenario/emulator, matrix, bus-image and log identities; incomplete or stale
results cannot satisfy `make release-audit`. Original-image golden capture is
separate and is never used to redefine expected state from a candidate.

A complete build and movement check is necessary but does not replace runtime or
clean-clone aggregate acceptance. The finite attract scenario also does not
prove all gameplay paths. See [verification](verification.md),
[runtime](runtime.md) and the [1.0 gate](source_reconstruction_1_0.md).

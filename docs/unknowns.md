# Unknowns and remaining work

## Unaccepted release requirements

- Complete current-source 1.0 aggregate clean-clone acceptance after the SMPS
  storage migration. The prior source passed all 32 relocation groups and 160
  relocated runtime cases; those source bindings must now be regenerated.
- Semantic subsystem source layout with documented size exceptions and a label
  rename registry. The large imported entry units are still present.
- Editable contracts/codecs for every stored and assembler-owned format,
  allocator capacities, malformed/overflow rejection and zero-edit round trips.
- Source Reconstruction 2.0 manifest/gate, final clean-clone evidence and owner
  review. No release tag or publication is part of the automated work.

## Preserved source uncertainty

Many imported `sub_*`, `loc_*`, `word_*` and `byte_*` labels still express
addresses rather than established meaning. A coincident address is not evidence
that two products share a semantic owner. Interior-byte lock-on aliases are
validated as external addresses without inventing a consumer interpretation.

Original comments identify several erroneous absolute vector-area reads. They
are deliberately preserved and named in source, not repaired. The upstream
annotation grants no explicit license; its status remains `license_not_granted`.
Runtime currently observes a finite attract path and nine RAM cells, so it is
not exhaustive gameplay coverage. Host support beyond the pinned Windows runtime
is not claimed by portable ROM-less tests.

Complete clean-clone acceptance for the current source and history remains
pending.

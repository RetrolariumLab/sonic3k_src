# Source Reconstruction 1.0

The preservation contract is `config/source_reconstruction_1_0.json`. It names
all five accepted images, private input identities, untracked output artifacts,
external tools, runtime coverage, rights boundaries and project-owned checks. It
is in development; a complete aggregate acceptance run is pending.

After importing user images, run `make release-check` (alias
`make source-1-check`). The fail-fast sequence is lint, tests, input/tool pins,
reproducible extraction, clean all-profile assembly and byte identity,
independent ABI/numeric audits, the full relocation matrix, preservation and
relocated runtime, publication/privacy checks and a clean tracked tree. Golden
generation is not part of the gate. No saved research artifact supplies an input
to the gate; everything required is reproducible from a clean clone and the
declared private dependencies.

The sibling engine entries temporarily remain at the root. This is an explicit
layout deviation for the preservation milestone, with profile-owned entries,
code/data maps, source-derived return coverage and exact assembly as controls.
Semantic source organization and editable content formats remain the next
milestone's additional requirements. Passing a content check cannot replace any
preservation guarantee.

Tags and publication remain maintainer actions. A candidate manifest, partial
matrix, original-image-only runtime run or passing byte comparison alone does
not establish completion of this release line.

Requirement status `implemented` records that the executable control exists. It
is not an acceptance result. Only a complete current-source aggregate run proves
acceptance, including regenerated relocated builds and runtime after any
storage/source migration.

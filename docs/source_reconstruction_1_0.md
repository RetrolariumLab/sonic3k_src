# Source Reconstruction 1.0

The preservation contract is `config/source_reconstruction_1_0.json`. Its
complete clean-clone aggregate run passed at the commit recorded under
`evidence.accepted_baseline`. All five images, fixed interfaces, audio storage,
32 relocation groups, 165 runtime cases and the clean history were checked. The
manifest is tag-ready; tags and publication remain maintainer actions.

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

The manifest is now `tag-ready` following complete clean-clone acceptance.
Publication metadata records that source binding without changing assembly,
inputs, compiler settings, scenarios or expected state. Metadata is checked
before expensive stages and again against actual evidence during the audit.

# Source Reconstruction 1.0

The preservation manifest is `config/source_reconstruction_1_0.json`. Its
`evidence.accepted_baseline` records historical clean-clone acceptance: all five
exact images, the second-cartridge ABI, audio storage, 32 relocation groups, 165
runtime cases and clean history. The accepted predecessor metadata commit is
pinned by the 2.0 manifest. No release tag is created automatically.

After importing user images, run `make release-check` (alias
`make source-1-check`). The fail-fast sequence is lint and metadata, tests,
private inputs and tool pins, extraction, clean all-profile assembly and byte
identity, independent ABI/numeric audits, complete relocation, preservation and
relocated runtime, privacy/publication checks and a clean tracked tree. Golden
generation is separate and always uses original inputs.

The current 1.0 manifest stays in development while source evolves toward 2.0.
Historical acceptance does not certify current code. Source 2.0 invokes the
entire preservation gate again before additional controls. Source ownership and
content checks cannot replace any preservation guarantee.

The historical baseline used root entry units; current entries live under
`src/revisions/`. [Source layout](source_layout.md) describes semantic owners
and independent preservation comparison. Tags and publication remain maintainer
actions.

# Contributing

## Preserve behavior and private inputs

Preservation profiles must remain byte identical to the verified user inputs.
Keep Sonic 3 and S&K engines separate, and keep revision selection declarative
in `config/revision_profiles.json`. Community bug fixes and optimizations are
outside these profiles. Preserve known original bugs with an explanatory source
comment; do not silently repair them during naming or formatting changes.

Never add game images, binary fragments, extracted assets, screenshots, samples
or generated outputs to Git. All private input lives below `data/`; generated
work lives below `build/`. The binary allowlist is explicit and currently empty.
`make audit-private` inspects both staged content and every reachable historical
path. Deleting a bad file in a later commit is insufficient.

## Source and metadata

AS source uses `.s` and `.inc`, explicit colon labels, `equ`/`set` declarations
and ASCII comments. Keep data with its owning subsystem. Use source labels for
addresses and declare fixed hardware or external-cartridge interfaces
explicitly. Do not replace Sonic 2 compatibility constants with coincident Sonic
3 labels.

The assets manifest owns image identities, extraction ranges and output paths.
Toolchain and runtime manifests own external dependency pins. Avoid duplicating
those values in ad hoc scripts. Public code must not depend on machine-local
paths or private project documentation.

## Validate a change

Run `make format`, review the diff and run `make lint test`. Lint is read-only;
a second format run must leave the tracked tree unchanged. Keep mechanical
formatting separate from semantic changes and record a formatting revision in
`.git-blame-ignore-revs` in a following commit.

For assembly or input-contract changes run
`make check-assets verify-all check-lockon check-numeric-operands`. Use the
pinned MAME checks after changes that can affect runtime. Run heavy
build/emulator work serially and never kill another task's emulator. A changed
golden requires separately reviewed original image evidence; candidate output
must never define its own expected result.

Before publication run `make audit-private` and inspect `git status`. Runtime,
relocation and content-format claims require their own executed evidence;
preservation identity alone cannot establish a release. Describe the concrete
behavior, validation and remaining limits in each change. Tags and publication
remain maintainer actions.

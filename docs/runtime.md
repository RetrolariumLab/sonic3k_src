# Runtime evidence

Each preservation profile has an original-image attract golden with nine RAM
cells at seven checkpoints over 3600 input-free frames. USA and the lock-on
products use `genesis`; Europe uses `megadriv`, and Japan uses `megadrij`. Sonic
3 checks its region header at startup, so regional runtime coverage is direct.
Cell addresses are checked against each profile's AS symbols.

`config/runtime/scenarios.json` owns the scenario/profile matrix and RAM widths;
the movie-check files own machines, addresses and expected observations. Each
golden must show the expected natural level demo, a moving camera and elapsed
level frames. Missing checkpoints/cells and nonzero tolerances are rejected.
Screenshots are not evidence. The movie contains no controller input or setup
patches, and no image data is distributed.

## Reproduce a check

Supply the pinned MAME executable through `RETROLARIUM_MAME` or the Kit's
remembered movie emulator. `make verify-emulator` checks its exact binary hash
and copies it under ignored `build/runtime/mame`, where emulator state and
outputs remain local. The source commit and binary identity are in
`config/runtime/emulator.json`. Full runtime is accepted on Windows x86_64;
other hosts retain portable ROM-less tests without claiming runtime support.

After `make verify-all`, `make trace` compares the preservation images with
their committed goldens. `make trace-relocated` checks every artifact declared
by the relocation manifest. The runner waits while another MAME is active, runs
one movie at a time, enforces a run budget and never kills a foreign process.
Timeout cleanup targets only the runner process tree it created.

`make golden` is a separate research command: it reads verified original user
images, updates golden observations and rechecks the natural-gameplay contract.
It is never called by a release check. Review any changed golden as new
evidence.

## Sonic & Knuckles bus mapping

This MAME build mirrors a bare 2 MiB S&K image into the empty second-cartridge
window, causing the game to see its own header and enter Blue Sphere. The
standalone S&K scenario therefore constructs a runtime-only 4 MiB bus image: the
unchanged S&K bytes followed by an all-FF empty upper window. Its golden reaches
the Mushroom Hill demo. The preserved artifact remains the exact original 2 MiB
image; the wrapper changes no base byte or header field.

The composite S3&K bus image contains S&K followed by the verified original S3
half. Its golden reaches the Angel Island demo. Composite relocation keeps the
attached S3 cartridge on its fixed external ABI, checked independently by
`make check-lockon`. The content of two halves alone does not prove runtime.

## Complete run binding

Successful checks write separate `build/runtime/evidence/check.json` and
`matrix.json` records. A record becomes complete only after every requested case
passes. It binds source, movies, goldens, emulator contract and relocation
manifest, and records each bus image and log hash. The release audit requires
the exact complete profile/variant product; a previous run or successful subset
cannot replace missing observations.

## Isolated state and owned process cleanup

Every invocation starts with a clean generated emulator directory under
`build/runtime/mame`. Only the hash-checked executable survives; configuration,
NVRAM and save-state defaults cannot leak from an earlier profile or scenario.
Cleanup validates every resolved path before removing anything and cannot touch
external emulator installations or adjacent runtime evidence. Temporary movie
files stay under `build/runtime/tmp`.

A Windows process snapshot records descendant relationships and creation times
while the owned runner is active. Cleanup checks creation time and terminates
through the same process handle, preventing a reused PID from redirecting it to
a foreign process. Leftovers fail the run even when they are cleaned. Failure
and timeout paths apply the same ownership rules; unrelated processes remain
untouched. The runtime evidence signature also binds these runner sources.

## Extended controller routes and cartridge saves

`make golden-extended` captures twenty profile/route pairs from verified
original images. `make trace-extended` compares the same routes against
preservation builds and relocation variant `g0`, giving forty additional cases.
The existing five preservation and 160 relocated short-attract checks remain
mandatory. These extended checks run serially inside the complete preservation
gate.

`config/runtime/extended_scenarios.json` owns controller movies, applicable
profiles, source-derived RAM views and ordered reached-state predicates. Each
route also requires observed progress at multiple checkpoints. Coverage includes
long attract sequences across several zones, both players in Competition,
Knuckles selection, an interactive special stage and Tails save creation and
reload. Regions use their own console machine and their own original goldens.
All original capture identities are recorded in
`scenarios/extended/provenance.json`.

A save test first creates a slot through the game's ordinary controller
interface and exits MAME normally. The runner reads only that invocation's
bounded cartridge NVRAM. It then clears all emulator state, starts another
process and explicitly seeds only that case's cartridge file. Required
observations prove the character was restored at boot and can be started without
selecting the character again. Every preservation and relocated writer produces
its own seed; its bytes must match the original writer's hash. No personal save,
RAM injection, state file, cartridge patch or soft reset is used. Standalone S&K
has no save-slot reload case.

The extended report binds the exact profile/route/variant product, current
source, scenario definitions, original goldens, emulator contract, relocation
manifest, image hashes, logs and SRAM chain. Missing routes, unordered screen
visits, stationary progress observations and stale evidence fail acceptance.
This remains finite RAM coverage: it does not prove pixel output, full-game
completion or every ending. Extended relocation uses one declared cohort
variant; all 32 variants retain the complete short-attract comparison.

## Canonical movie text

Controller movies use UTF-8 text with LF line endings. Git attributes and
`make format` must produce the same bytes in a Windows working tree and a clean
checkout. The pinned Kit text selector does not include `.rlmovie`, so the
repository checks disposable `.txt` copies through its official text contract.
Read-only lint never rewrites the movies; explicit formatting copies back only
normalized text. Extended capture rejects CRLF before creating provenance.
Line-ending normalization preserves every controller record and observation.

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

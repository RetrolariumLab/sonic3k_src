# Provenance and rights

The baseline is the Sonic Retro Sonic 3 / Sonic & Knuckles buildable
disassembly, https://github.com/sonicretro/skdisasm, commit
`73de97c6b55055bcb8089c1d55d006b02136f163`, dated 2026-10-11. This import
collapses 758 commits attributed by Git shortlog to 37 public contributor names.
The original buildable disassembly, labeling and formatting credit is
Stealth (2006). Subsequent upstream attribution in the source is retained.
IDA license banners and an original machine-local file path were removed.

## Public upstream contributor names

- Clownacy
- Fred Bronze
- unknown
- Vinny
- Filter
- Natsumi
- flamewing
- MainMemory
- Tiddles
- David Korth
- Francis Gagné
- BenoitRen
- TheBlad768
- lavagaming1
- FourHawk
- RobiWanKenobi
- Malachi
- ollie-ollie-tech-deck
- yilisharcs
- InfernoGear
- Lave sIime
- PikaNoob
- RappyPhan
- Alex Oxorn
- Brainulator9
- Christopher Trumbour
- Harry Palmer
- Lave siime
- MDTravis
- Sean Brackeen
- Selbi182
- ThatCesarMan
- kirisamemofo
- notaz
- snkenjoi
- vinegar97
- vladikcomper

## Import exclusions

No upstream Git objects were imported. Commercial ROMs, extracted binary
payloads, WAV samples, screenshots, PCX graphics and external editor projects
were omitted. Their deletion from a later commit would not remove them from
history, so they never enter this repository's initial tree.

The upstream Lua/batch build, split executables and bundled compiler binaries
are omitted. Original source remains text; the first import intentionally
cannot build without the subsequent extraction/build workflow.

The community complete build and its LockOn Data module are excluded. Bug-fix,
optimization and complete-build alternatives can be recovered from the pinned
upstream commit; they are not official preservation revisions. Editing belongs
in Retrolarium, not in bundled GUI tools or external-editor projects.

## Licensing boundaries

Upstream has a disclaimer, retained in README, but grants no license to its
annotation: status `license_not_granted`. No license to the reconstructed game
code or data is granted by this repository; these remain the rights holder's
property. User-supplied ROMs are private inputs and are never redistributed.
Retrolarium Kit and Core are external public tool dependencies with their own
licenses. No bundled compiler binaries are needed for the current host.

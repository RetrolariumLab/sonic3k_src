# Provenance and rights

The baseline is the Sonic Retro Sonic 3 / Sonic & Knuckles buildable
disassembly, https://github.com/sonicretro/skdisasm, commit
`73de97c6b55055bcb8089c1d55d006b02136f163`, dated 2026-10-11. This import
collapses 758 commits attributed by Git shortlog to 37 public contributor names.
The original buildable disassembly, labeling and formatting credit is Stealth
(2006). Subsequent upstream attribution in the source is retained. IDA license
banners and an original machine-local file path were removed.

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
are omitted. Original source remains text; the first import intentionally cannot
build without the subsequent extraction/build workflow.

The community complete build and its LockOn Data module are excluded. Bug-fix,
optimization and complete-build alternatives can be recovered from the pinned
upstream commit; they are not official preservation revisions. Editing belongs
in Retrolarium, not in bundled GUI tools or external-editor projects.

The unused upstream `Lockon S3/Screen Events.s` reference module was never
included by an accepted revision. Its duplicate event implementations are
removed from the source tree and the relocation source inventory. Live Sonic 3
events remain under their subsystem owners; the second-cartridge interface
continues to use the independently checked fixed lock-on symbol declarations.
Normal-build listings and all accepted image identities confirm this exclusion.

The Z80 driver bug-fix option is also specialized to its original disabled
branch. Conditions that distinguish the accepted Sonic 3 and Sonic & Knuckles
driver versions remain explicit. The optional fixed driver can be recovered from
the pinned upstream source; it is outside the preservation profiles.

## Licensing boundaries

Upstream has a disclaimer, retained in README, but grants no license to its
annotation: status `license_not_granted`. No license to the reconstructed game
code or data is granted by this repository; these remain the rights holder's
property. User-supplied ROMs are private inputs and are never redistributed.
Retrolarium Kit and Core are external public tool dependencies with their own
licenses. No bundled compiler binaries are needed for the current host.

## Audio storage migration and helper license

The initially imported music/SFX score assembly has been replaced in the final
tree by exact ROM extraction recipes: 219 S3 and 198 S&K streams. Their internal
score labels are not referenced by retained executable source; outer storage
labels and driver pointer tables remain source-owned. The full score macro
library is removed.

`src/audio/shared/fm_instrument_macros.s` retains only generic instrument
helpers needed by the Z80 drivers. Its original notice credits Flamewing and
S1SMPS2ASM 1.1 by Marc Gordon and explicitly grants permission to use, copy,
modify and distribute that software. The notice is retained in the helper file.
This file-specific grant does not change the general upstream annotation status
or grant rights to game code, scores or sample data.

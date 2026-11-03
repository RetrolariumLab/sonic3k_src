# Provenance and rights

The baseline is the Sonic Retro Sonic 3 / Sonic & Knuckles buildable
disassembly, https://github.com/sonicretro/skdisasm, commit
`73de97c6b55055bcb8089c1d55d006b02136f163`, dated 2026-10-11. This import
collapses 758 commits attributed by Git shortlog to 37 public contributor names.
The original buildable disassembly, labeling and formatting credit is Stealth
(2006). Subsequent upstream attribution in the source is retained. IDA license
banners and an original machine-local file path were removed.

## Contributors

The complete [contributor credits](../CONTRIBUTORS.md) retain all 37 public
upstream names, their historical aliases and the original Stealth credit.

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

The initial import excludes music/SFX score assembly and inline audio payloads.
Exact ROM extraction recipes cover 219 S3 and 198 S&K streams. Their internal
score labels are not referenced by retained executable source; outer storage
labels and driver pointer tables remain source-owned. The full score macro
library is removed.

A transitional generic FM helper library was retained while driver payloads were
separated. Once all instruments and envelopes were ROM-extracted, none of its
fifteen macros or private conversion constants had a caller. The library and
both bootstrap includes were removed without changing any emitted byte. The
original licensed helper code remains attributable in the development history;
no score encoder macros remain in the current tree. Its historical file-specific
permission does not change the upstream annotation or game-data rights described
above.

## Label provenance

The canonical
[label rename registry](../config/reconstruction/label_renames.json) maps all
1571 reviewed address-named procedures to source-derived meaningful names. Each
record retains its original spelling, physical source identity, compilation
profiles and concrete purpose. The three repeated spellings remain separate
definitions in separate engines. Local labels and unrelated data labels retain
their existing spellings.

The registry is bound to the exact pre-migration Git source and must cover every
original physical definition. Current declarations and references are checked
against that scope. Historical preservation compares registered names as a
profile-specific view; original addresses, procedure counts and return
boundaries must still match. Original baseline evidence is not redefined by a
candidate build. Semantic naming does not claim new runtime coverage.

The same canonical registry owns an
[incremental semantic continuation](../config/reconstruction/semantic_labels.json)
for 35470 further physical labels. Its subsystem partition is checked against
the exact Git baseline; each applied subsystem must provide all of its reviewed
mappings. Pending definitions retain their original names, and original physical
identities remain stable when explanatory comments are inserted. This optional
naming migration preserves the completed 1571-procedure record and does not
change the original byte, address, scope or runtime acceptance requirements.

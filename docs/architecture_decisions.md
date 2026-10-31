# Architecture decisions

## Preserve sibling engines

Sonic 3 and Sonic & Knuckles are separate products with different engine and
SMPS versions. They keep separate executable owners and common definitions where
upstream already shared them. Regional Sonic 3 profiles select the header define
from one entry; they do not duplicate the engine. S3&K combines verified S&K and
S3 USA images in that order. [Revisions](revisions.md) explains the profiles;
the build registry owns executable choices.

## Separate storage from interpretation

The asset manifest owns private image ranges and identities. Authoring catalogs
own semantic formats, product ABIs, capacities and applicable profiles. Actual
AS includes and symbols establish where shared assets are used. A file suffix or
extraction image cannot establish runtime meaning. Unknown bytecode and
cross-profile edit packets fail before output.

## Keep editing bounded and headless

Models expose semantic values through pure codecs. Fixed allocations preserve
labels, structural pointers, alignment and reserved bits. Zero-edit compression
retains original streams; changed streams require decoded equivalence and must
fit their slot. Retrolarium supplies editors; this repository contains no GUI,
external-editor project or automatic asset allocator.

Inline families prepare immutable span patches. One composer validates every
interval before writing complete owners, preventing families in a shared file
from overwriting each other's edits. All 1980 source owners enter the encoded
workspace; the actual workspace builds all five images.

## Keep executable contexts explicit

RAM declarations, non-emitting libraries, include composition, cartridge data
and Z80 virtual segments have distinct checked grammars. Independent AS ranges
and physical object records supplement source parsing. Historical symbol and
procedure comparisons prevent ownership changes from erasing original entries.
The external S3 window and 32-KiB sound banks remain fixed interfaces.

## Share dependencies through public pins

Kit owns the assembler, converter, lint and movie commands. Core provides the
Nemesis backend. This game's Enigma semantics differ from the pinned Core
implementation, so its bounded codec follows the retained 68000 decoder and
checks all 35 original streams. Neither dependency checkout is modified.

## Keep evidence reproducible

The complete 1.0 gate runs first in 2.0. Structural tests work without ROMs;
byte identity, relocation, runtime and encoded-container checks require verified
private inputs. Reports bind inputs and reject incomplete or stale runs. Tags
and publishing are owner actions. No predecessor tag is inferred from a commit
or created by a check.

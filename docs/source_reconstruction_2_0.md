# Source Reconstruction 2.0

The release manifest is `config/source_reconstruction_2_0.json`. It pins the
accepted 1.0 predecessor commit without claiming that the maintainer has created
a tag. Tags and publication remain maintainer actions.

`make scaffold-check` needs no ROMs. It runs style, the headless suite, source,
memory, composition, Z80, audio and content contracts, documentation review and
release metadata checks. Private-input tests skip with a reason; required
structural checks do not skip.

`make source-2-check` first invokes the entire `make release-check` gate. It
then checks historical source preservation, all built source ranges, memory,
composition and Z80 contexts, the complete encoded-resource/container round
trip, documentation and final release audit. Every stage is fail-fast and
serial. A partial run remains incomplete. Reports below `build/release/` bind
current source, tooling, complete public-tree content and referenced evidence.

The scope is five original preservation profiles, complete semantic source
ownership and fixed-allocation headless content descriptions. No GUI editor,
engine merger, expanded allocator, community modification, prototype or Sonic 2
runtime profile is included. [Architecture decisions](architecture_decisions.md)
records rationale and [known limits](unknowns.md) bounds the claims.

Documentation is reviewed as one corpus: a review registry records a decision
for every public Markdown document. `make check-docs` inventories sizes, links,
reachability and repeated substantial paragraphs, checks required documents and
writes current hashes. Automated checks supplement substantive review; file
presence alone does not establish document quality.

The baseline passed the complete aggregate from a clean clone with verified
private inputs. The manifest records that accepted commit and its source and
tooling identities. Current evidence must still be regenerated for a changed
HEAD; standalone content reports or an older predecessor run do not establish
current acceptance. The manifest is tag-ready and creates no tag automatically.

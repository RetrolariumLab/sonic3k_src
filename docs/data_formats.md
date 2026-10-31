# Content formats and allocations

`config/authoring/data_formats.json` is the aggregate contract. It covers 1778
private inputs: 1729 extracted segments and 49 derived driver payloads. Two
containers are source-built driver tables, not editable opaque resources. Linked
catalogs own 613 complete assembly resources, 29 macro palette groups, 233
raw/indexed animation groups and two indexed palette groups.

## Products and representations

| Family                              | Applicability and semantic model                                                                                                                                                                                     |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Nemesis, Kosinski, moduled Kosinski | Both products. Packed bytes and decoded allocation are distinct; moduled streams retain 4096-byte module and alignment semantics. Nemesis uses pinned Core.                                                          |
| Enigma, raw tiles and VDP maps      | Both products. Enigma follows this game's decoder. Tiles expose 4bpp pixels; map words expose tile, palette, priority and flip fields.                                                                               |
| Blocks, chunks and level layouts    | Both products, with profile-owned dimensions and RAM limits. Chunk references must fit the 768-block RAM table. Layouts retain row pointers and foreground/background ownership.                                     |
| Objects, rings and starts           | Both products. Fixed-width records, flags, coordinates and bounded terminators. Retained S2 compatibility data has its own respawn ABI; it adds no S2 runtime profile.                                               |
| Collision                           | Both products. Shape indices, two signed height paths and angles. S3 supports 512 shapes; the S&K lock-on consumer requires indices below 256.                                                                       |
| Palettes and rotation               | Both products. CRAM RGB channels retain reserved bits. Macro scripts preserve command graphs and RAM destinations; [indexed palettes](indexed_palettes.md) covers the separate S&K reader.                           |
| Mappings and DPLC                   | Both products, plus retained S1 mapping records. Signed sprite coordinates, dimensions and tile attributes; player and object DPLC count/nibble conventions remain distinct.                                         |
| Sprite animations                   | Both products. Shared/per-frame/player commands plus [raw and indexed ABIs](raw_animations.md), fixed labels, graph edges and stored tails.                                                                          |
| Special stage and Blue Sphere       | S3 layouts and S&K stage sets differ. Models expose layouts, perspective cells, palettes, mirrored quadrants and Blue Sphere level/header/code selection.                                                            |
| Competition, scroll and geometry    | Both products where declared. Demo buttons/counters, waterline active cells, scaled rasters, start/water coordinates, slopes, sine/arctangent and bonus selectors.                                                   |
| SMPS, FM and envelopes              | S3 uses SMPS3; S&K uses SMPS4. 417 streams form eight closed 32-KiB bank corpora; typed track graphs and local FM voices retain aliases and original commands. Driver payloads include 48 envelopes and one FM bank. |
| DAC                                 | Both products. PCM/DPCM preserve sample allocation and require the exact sixteen-byte codebook; rate and length remain source metadata.                                                                              |

Every artifact declares its profile set, address space, decoded capacity and
storage owner. The catalog is authoritative for exceptions to this summary.
[Codec APIs](content_codecs.md) explains models and format-specific edge cases.

## Writes and round trips

The policy is `preservation-fixed-footprint`. Decode binds the model to its
immutable original allocation, declaration identity and target profile. Packets
from another product or lock-on component are rejected. Structural references,
record counts and alignment cannot silently move. Capacities, graph edges, RAM
destinations and reserved fields are checked before producing output.

Zero-edit compression returns the original packed stream and padding after
semantic comparison. Forced encoding and decoding independently prove content
equality; original compressor byte choices are not promised for edits. Edited
compressed data must fit its slot. Pure encoders never write a ROM; controlled
output APIs accept only ignored build workspaces.

`make check-content-contract` needs no ROM. `make check-content-zero-edit`
requires the pinned Core backend and private inputs, builds all profiles, checks
every applicable resource/profile binding, encodes every modeled resource,
composes inline families once, and builds all five images from that actual
encoded workspace. Source and tooling fingerprints reject stale evidence.
[Verification](verification.md) explains the full release gate.

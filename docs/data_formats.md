# Content formats

The content format migration is in development. The sections below describe
implemented codecs; they do not certify coverage of every asset family.

## Kosinski

`scripts/authoring/kosinski.py` implements the format consumed by the retained
`Kos_Decomp` routines. Descriptor words are little endian and consumed least
significant bit first. The game fetches a new descriptor immediately after bit
16, before reading the following payload. Literals, short and long overlapping
back-references, extended lengths, continuation records and termination are
supported. Invalid history references, truncated input and output capacity
overflow are rejected.

`decode_stream` returns both content and the compressed byte count, allowing a
container to keep its following padding. `encode` uses a deterministic bounded 8
KiB dictionary and emits a valid stream. It is not an original-compressor
identity promise. `encode_preserving` returns the original stream, including
padding, when decoded content is unchanged; edited content is encoded anew.
Validation additionally forces encoding and decoding to prove content equality.
A caller must enforce its asset allocation and target ABI before writing.

ROM-free tests use independent literal, match and continuation vectors, an eager
descriptor boundary, malformed inputs and bounded expansion. Verification
against private assets also covers the original compressed driver blocks and
retained Kosinski resources. Other compression families and semantic content
formats still need their own descriptors and authoring checks.

## Driver payload containers

`config/audio_driver_payloads.json` binds each FM bank or envelope to one or
both original driver table containers, its decoded offset, hashes, fixed
capacity and audio ABI. The raw Sonic 3 container and compressed Sonic &
Knuckles container are extraction inputs, not substitutes for executable source.
Pointer tables and engine-owned data continue to assemble symbolically.

The payload extractor verifies the complete decoded container and every slice
before writing private files. The original 101-byte Sonic 3 volume envelope 26
and 99-byte Sonic & Knuckles variant remain separate. Shared payloads must match
both sources even when their offsets differ. Full semantic FM/envelope editing
codecs and format descriptors are still part of the pending content migration;
binary extraction alone does not claim that coverage.

# Audio source and private storage

Music, effects, instruments and envelopes are private ROM-derived inputs. The
initial import excludes score source and inline instrument/envelope values. The
complete score macro library is absent. Executable drivers and symbolic pointer
tables remain source-owned. No SMPS2ASM score or instrument-encoder macros
remain in the current tree.

The asset manifest extracts music/effect streams and both original driver table
containers. The driver payload recipe splits checked decoded slices, retaining
the separate official volume envelope variant. Shared data must agree with both
ROM origins. `make split` prepares these private files; `make check-assets`
checks them. The audio storage and driver payload checks enforce ownership,
capacities and target ABI before writes. The headless codecs describe
SMPS3/SMPS4 closed banks, FM instruments, envelopes and PCM/DPCM with immutable
product allocations; see [content formats](data_formats.md) and
[codec APIs](content_codecs.md). The history audit is a mandatory release check
and rejects scores or inline instrument/envelope payloads.

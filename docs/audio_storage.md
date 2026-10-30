# Audio source and private storage

Music, effects, instruments and envelopes are private ROM-derived inputs.
The initial import excludes score source and inline instrument/envelope values.
The complete score macro library is absent. Executable drivers, symbolic
pointer tables and generic licensed instrument helpers remain source-owned.

The asset manifest extracts music/effect streams and both original driver table
containers. The driver payload recipe splits checked decoded slices, retaining
the separate official volume envelope variant. Shared data must agree with
both ROM origins. `make split` prepares these private files; `make check-assets`
checks them. The audio storage and driver payload checks enforce ownership,
capacities and target ABI before writes. Full semantic content editing remains
part of the later content format migration. The history audit is a mandatory
release check and rejects scores or inline instrument/envelope payloads.

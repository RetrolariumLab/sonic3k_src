; Owner: audio/dac/s3
; Responsibility: DPCM sample BA rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 7946
                .size:  equ 1203
                binclude "data/Sound/DAC/generated/BA.dpcm"

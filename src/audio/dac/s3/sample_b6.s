; Owner: audio/dac/s3
; Responsibility: DPCM sample B6 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12155
                .size:  equ 1365
                binclude "data/Sound/DAC/generated/B6.dpcm"

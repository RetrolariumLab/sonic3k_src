; Owner: audio/dac/s3
; Responsibility: DPCM sample B8-B9 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12155
                .size:  equ 1594
                binclude "data/Sound/DAC/generated/B8-B9.dpcm"

; Owner: audio/dac/s3
; Responsibility: DPCM sample A0 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12155
                .size:  equ 3514
                binclude "data/Sound/DAC/generated/A0.dpcm"

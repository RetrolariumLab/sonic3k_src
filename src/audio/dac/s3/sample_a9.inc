; Owner: audio/dac/s3
; Responsibility: DPCM sample A9 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12155
                .size:  equ 2639
                binclude "data/Sound/DAC/generated/A9.dpcm"

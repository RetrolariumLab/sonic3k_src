; Owner: audio/dac/s3
; Responsibility: DPCM sample A1 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 13332
                .size:  equ 2984
                binclude "data/Sound/DAC/generated/A1.dpcm"

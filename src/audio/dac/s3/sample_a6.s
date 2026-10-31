; Owner: audio/dac/s3
; Responsibility: DPCM sample A6 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 14010
                .size:  equ 1750
                binclude "data/Sound/DAC/generated/A6.dpcm"

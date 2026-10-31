; Owner: audio/dac/s3
; Responsibility: DPCM sample Unused rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12500
                .size:  equ 4956
                binclude "data/Sound/DAC/generated/Unused.dpcm"

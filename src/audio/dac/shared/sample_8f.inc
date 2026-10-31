; Owner: audio/dac/shared
; Responsibility: DPCM sample 8F rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 14761
                .size:  equ 1263
                binclude "data/Sound/DAC/generated/8F.dpcm"

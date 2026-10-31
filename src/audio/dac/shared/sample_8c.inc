; Owner: audio/dac/shared
; Responsibility: DPCM sample 8C rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 14761
                .size:  equ 96
                binclude "data/Sound/DAC/generated/8C.dpcm"

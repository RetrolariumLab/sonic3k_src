; Owner: audio/dac/shared
; Responsibility: DPCM sample 82-85 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 11169
                .size:  equ 1133
                binclude "data/Sound/DAC/generated/82-85.dpcm"

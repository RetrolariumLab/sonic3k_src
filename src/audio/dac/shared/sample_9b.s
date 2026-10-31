; Owner: audio/dac/shared
; Responsibility: DPCM sample 9B rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12155
                .size:  equ 1568
                binclude "data/Sound/DAC/generated/9B.dpcm"

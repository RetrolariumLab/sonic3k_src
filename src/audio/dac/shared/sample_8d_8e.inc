; Owner: audio/dac/shared
; Responsibility: DPCM sample 8D-8E rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12716
                .size:  equ 1159
                binclude "data/Sound/DAC/generated/8D-8E.dpcm"

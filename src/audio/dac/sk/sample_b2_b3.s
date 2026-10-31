; Owner: audio/dac/sk
; Responsibility: DPCM sample B2-B3 (Sonic & Knuckles) rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 8432
                .size:  equ 2120
                binclude "data/Sound/DAC/generated/B2-B3 (Sonic & Knuckles).dpcm"

; Owner: audio/dac/shared
; Responsibility: DPCM sample 90-93 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 20166
                .size:  equ 1570
                binclude "data/Sound/DAC/generated/90-93.dpcm"

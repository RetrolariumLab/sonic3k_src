; Owner: audio/dac/shared
; Responsibility: DPCM sample 86 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 18790
                .size:  equ 719
                binclude "data/Sound/DAC/generated/86.dpcm"

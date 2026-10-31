; Owner: audio/dac/shared
; Responsibility: DPCM sample 87 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 18790
                .size:  equ 1820
                binclude "data/Sound/DAC/generated/87.dpcm"

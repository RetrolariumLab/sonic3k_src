; Owner: audio/dac/s3
; Responsibility: DPCM sample AC rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 16534
                .size:  equ 1409
                binclude "data/Sound/DAC/generated/AC.dpcm"

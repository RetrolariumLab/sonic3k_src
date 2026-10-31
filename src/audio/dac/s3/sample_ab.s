; Owner: audio/dac/s3
; Responsibility: DPCM sample AB rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 11641
                .size:  equ 2308
                binclude "data/Sound/DAC/generated/AB.dpcm"

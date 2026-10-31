; Owner: audio/dac/s3
; Responsibility: DPCM sample AD-AE rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 10331
                .size:  equ 444
                binclude "data/Sound/DAC/generated/AD-AE.dpcm"

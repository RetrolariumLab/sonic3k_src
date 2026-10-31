; Owner: audio/dac/s3
; Responsibility: DPCM sample C0 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 12716
                .size:  equ 2102
                binclude "data/Sound/DAC/generated/C0.dpcm"

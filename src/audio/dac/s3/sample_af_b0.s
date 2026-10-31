; Owner: audio/dac/s3
; Responsibility: DPCM sample AF-B0 rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 14010
                .size:  equ 876
                binclude "data/Sound/DAC/generated/AF-B0.dpcm"

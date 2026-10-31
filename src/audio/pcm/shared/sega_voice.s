; Owner: audio/pcm/shared
; Responsibility: Sega PCM voice rate, declared size and manifest-owned ROM payload; sample command identity and caller label context are preserved
; Source provenance and ranges: config/reconstruction/source_layout.json
                .sample_rate: equ 14434
                .size:  equ 24111
                binclude "data/Sound/PCM/generated/Sega.pcm"

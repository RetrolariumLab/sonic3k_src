; Owner: audio/s3
; Responsibility: Original music bank 1 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ===========================================================================
; Music Banks
; ===========================================================================
                cnop    -Size_of_Snd_Bank1, $8000       ; aligned to end of bank

; ---------------------------------------------------------------------------
; Music Bank 1
; ---------------------------------------------------------------------------
Snd_Bank1_Start:
Snd_Minib:      binclude "data/Sound/SMPS/s3/Music/Miniboss (Sonic 3).bin"
Snd_FinalBoss:  binclude "data/Sound/SMPS/s3/Music/Final Boss.bin"
Snd_Bank1_End:

                if      Snd_Bank1_End - Snd_Bank1_Start > $8000
                fatal   "Snd_Bank1_Start must fit within $8000 bytes, but was $\{Snd_Bank1_End-Snd_Bank1_Start }. Try moving something to the other bank."
                endif
                if      Snd_Bank1_End - Snd_Bank1_Start > Size_of_Snd_Bank1
                fatal   "Size_of_Snd_Bank1 = $\{Size_of_Snd_Bank1}, but you have $\{Snd_Bank1_End-Snd_Bank1_Start} bytes of music."
                endif

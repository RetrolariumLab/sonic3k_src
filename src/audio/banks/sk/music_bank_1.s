; Owner: audio/sk
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
Snd_SKCredits:  binclude "data/Sound/SMPS/sk/Music/Credits (Sonic & Knuckles).bin"
Snd_GameOver:   binclude "data/Sound/SMPS/sk/Music/Game Over.bin"
Snd_Continue:   binclude "data/Sound/SMPS/sk/Music/Continue (Sonic & Knuckles).bin"
Snd_Results:    binclude "data/Sound/SMPS/sk/Music/Level Outro.bin"
Snd_Invic:      binclude "data/Sound/SMPS/sk/Music/Invincible (Sonic & Knuckles).bin"
Snd_Menu:       binclude "data/Sound/SMPS/sk/Music/Menu (Sonic & Knuckles).bin"
Snd_FinalBoss:  binclude "data/Sound/SMPS/sk/Music/Final Boss.bin"
Snd_PresSega:   binclude "data/Sound/SMPS/sk/Music/Game Complete (Sonic & Knuckles).bin"

Snd_Bank1_End:

                if      Snd_Bank1_End - Snd_Bank1_Start > $8000
                fatal   "Snd_Bank1_Start must fit within $8000 bytes, but was $\{Snd_Bank1_End-Snd_Bank1_Start }. Try moving something to the other bank."
                endif
                if      Snd_Bank1_End - Snd_Bank1_Start > Size_of_Snd_Bank1
                fatal   "Size_of_Snd_Bank1 = $\{Size_of_Snd_Bank1}, but you have $\{Snd_Bank1_End-Snd_Bank1_Start} bytes of music."
                endif

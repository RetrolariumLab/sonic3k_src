; Owner: audio/s3
; Responsibility: Original music bank 3 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Music Bank 3
; ---------------------------------------------------------------------------
Snd_Bank3_Start:    startBank
Snd_ICZ2:           binclude "data/Sound/SMPS/s3/Music/ICZ2.bin"
Snd_ICZ1:           binclude "data/Sound/SMPS/s3/Music/ICZ1.bin"
Snd_LBZ2:           binclude "data/Sound/SMPS/s3/Music/LBZ2.bin"
Snd_LBZ1:           binclude "data/Sound/SMPS/s3/Music/LBZ1.bin"
Snd_MHZ1:           binclude "data/Sound/SMPS/s3/Music/MHZ1.bin"
Snd_MHZ2:           binclude "data/Sound/SMPS/s3/Music/MHZ2.bin"
Snd_SOZ1:           binclude "data/Sound/SMPS/s3/Music/SOZ1.bin"
Snd_SOZ2:           binclude "data/Sound/SMPS/s3/Music/SOZ2.bin"
Snd_LRZ1:           binclude "data/Sound/SMPS/s3/Music/LRZ1.bin"
Snd_LRZ2:           binclude "data/Sound/SMPS/s3/Music/LRZ2.bin"
Snd_SSZ:            binclude "data/Sound/SMPS/s3/Music/SSZ (Sonic 3).bin"
Snd_DEZ1:           binclude "data/Sound/SMPS/s3/Music/DEZ1.bin"
Snd_DEZ2:           binclude "data/Sound/SMPS/s3/Music/DEZ2.bin"
Snd_Minib_SK:       binclude "data/Sound/SMPS/s3/Music/Miniboss (Sonic & Knuckles).bin"
Snd_Boss:           binclude "data/Sound/SMPS/s3/Music/Zone Boss.bin"
Snd_PachBonus:      binclude "data/Sound/SMPS/s3/Music/Pachinko.bin"
Snd_SpecialS:       binclude "data/Sound/SMPS/s3/Music/Special Stage.bin"
Snd_Results:        binclude "data/Sound/SMPS/s3/Music/Level Outro.bin"
Snd_Menu:           binclude "data/Sound/SMPS/s3/Music/Menu (Sonic 3).bin"

                finishBank

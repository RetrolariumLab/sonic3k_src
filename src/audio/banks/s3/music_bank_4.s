; Owner: audio/s3
; Responsibility: Original music bank 4 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Music Bank 4
; ---------------------------------------------------------------------------
Snd_Bank4_Start:    startBank
Snd_SlotBonus:      binclude "data/Sound/SMPS/s3/Music/Slots.bin"
Snd_GumBonus:       binclude "data/Sound/SMPS/s3/Music/Gum Ball Machine.bin"
Snd_Knux:           binclude "data/Sound/SMPS/s3/Music/Knuckles (Sonic 3).bin"
Snd_ALZ:            binclude "data/Sound/SMPS/s3/Music/Azure Lake.bin"
Snd_BPZ:            binclude "data/Sound/SMPS/s3/Music/Balloon Park.bin"
Snd_DPZ:            binclude "data/Sound/SMPS/s3/Music/Desert Palace.bin"
Snd_CGZ:            binclude "data/Sound/SMPS/s3/Music/Chrome Gadget.bin"
Snd_EMZ:            binclude "data/Sound/SMPS/s3/Music/Endless Mine.bin"
Snd_Title:          binclude "data/Sound/SMPS/s3/Music/Title (Sonic 3).bin"
Snd_S3Credits:      binclude "data/Sound/SMPS/s3/Music/Credits (Sonic 3).bin"
Snd_GameOver:       binclude "data/Sound/SMPS/s3/Music/Game Over.bin"
Snd_Continue:       binclude "data/Sound/SMPS/s3/Music/Continue (Sonic 3).bin"
Snd_1UP:            binclude "data/Sound/SMPS/s3/Music/1UP (Sonic 3).bin"
Snd_Emerald:        binclude "data/Sound/SMPS/s3/Music/Chaos Emerald.bin"
Snd_Invic:          binclude "data/Sound/SMPS/s3/Music/Invincible (Sonic 3).bin"
Snd_2PMenu:         binclude "data/Sound/SMPS/s3/Music/Competition Menu.bin"
Snd_Drown:          binclude "data/Sound/SMPS/s3/Music/Countdown.bin"
Snd_PresSega:       binclude "data/Sound/SMPS/s3/Music/Game Complete (Sonic 3).bin"

                finishBank

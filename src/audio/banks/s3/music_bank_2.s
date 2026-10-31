; Owner: audio/s3
; Responsibility: Original music bank 2 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Music Bank 2
; ---------------------------------------------------------------------------
Snd_Bank2_Start:    startBank
Snd_AIZ1:           binclude "data/Sound/SMPS/s3/Music/AIZ1.bin"
Snd_AIZ2:           binclude "data/Sound/SMPS/s3/Music/AIZ2.bin"
Snd_HCZ1:           binclude "data/Sound/SMPS/s3/Music/HCZ1.bin"
Snd_HCZ2:           binclude "data/Sound/SMPS/s3/Music/HCZ2.bin"
Snd_MGZ1:           binclude "data/Sound/SMPS/s3/Music/MGZ1.bin"
Snd_MGZ2:           binclude "data/Sound/SMPS/s3/Music/MGZ2.bin"
Snd_CNZ2:           binclude "data/Sound/SMPS/s3/Music/CNZ2.bin"
Snd_CNZ1:           binclude "data/Sound/SMPS/s3/Music/CNZ1.bin"
Snd_FBZ1:           binclude "data/Sound/SMPS/s3/Music/FBZ1 (Sonic 3).bin"
Snd_FBZ2:           binclude "data/Sound/SMPS/s3/Music/FBZ2.bin"
Snd_DDZ:            binclude "data/Sound/SMPS/s3/Music/DDZ.bin"

                finishBank

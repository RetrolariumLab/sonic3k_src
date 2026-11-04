; Owner: game/level/sk
; Responsibility: Late-zone, competition, bonus and boss-room object and ring placements with original empty slots
; Source provenance and ranges: config/reconstruction/source_layout.json
SpriteTerminatB:
                dc.w    $FFFF, 0, 0
LRZ1_Sprites:
                binclude "data/Levels/LRZ/Object Pos/1.bin"
                even
LRZ2_Sprites:
                binclude "data/Levels/LRZ/Object Pos/2.bin"
                even
LRZ1_Rings:
                binclude "data/Levels/LRZ/Ring Pos/1.bin"
                even
LRZ2_Rings:
                binclude "data/Levels/LRZ/Ring Pos/2.bin"
                even
SpriteTerminatC:
                dc.w    $FFFF, 0, 0
SSZ1_Sprites:
                binclude "data/Levels/SSZ/Object Pos/1.bin"
                even
SSZ2_Sprites:
                binclude "data/Levels/SSZ/Object Pos/2.bin"
                even
SSZ1_Rings:
                binclude "data/Levels/SSZ/Ring Pos/1.bin"
                even
SSZ2_Rings:
                binclude "data/Levels/SSZ/Ring Pos/2.bin"
                even
SpriteTerminatD:
                dc.w    $FFFF, 0, 0
DEZ1_Sprites:
                binclude "data/Levels/DEZ/Object Pos/1.bin"
                even
DEZ2_Sprites:
                binclude "data/Levels/DEZ/Object Pos/2.bin"
                even
DEZ1_Rings:
                binclude "data/Levels/DEZ/Ring Pos/1.bin"
                even
DEZ2_Rings:
                binclude "data/Levels/DEZ/Ring Pos/2.bin"
                even
SKLevel_DEZLightTunnelPath00:   dc.w    $1E
                dc.w    $1B80,  $331
                dc.w    $1BD8,  $328
                dc.w    $1C8C,  $328
                dc.w    $8004,  $400
                dc.w    $8108,  $800
                dc.w    $80FC, $7C80
                dc.w    $80FC, $7C40
                dc.w    $81F8, $3880
                dc.w    $8004,  $480
                dc.w    $8108, $8840
                dc.w    $81F8, $B840
                dc.w    $8108, $C840
                dc.w    $8004, $44C0
                dc.w    $8108, $C800
                dc.w    $81F8, $7880
                dc.w    $8004,  $440
                dc.w    $80FC, $BC80
                dc.w    $8108,  $800
                dc.w    $81F8, $7840
                dc.w    $8004, $C400
                dc.w    $8108,  $800
                dc.w    $8004,  $840
                dc.w    $8108, $4840
                dc.w    $8004, $4480
                dc.w    $81F8, $F880
                dc.w    $80FC, $7C00
                dc.w    $81F8, $F880
                dc.w    $202C,  $1A8
                dc.w    $81F8, $7880
                dc.w    $20D4,  $1A8
SKLevel_DEZLightTunnelPath01:   dc.w    $26
                dc.w    $2B80,  $3B1
                dc.w    $2BD8,  $3A8
                dc.w    $2C78,  $3A8
                dc.w    $8004,  $4C0
                dc.w    $8108, $C8C0
                dc.w    $8004, $C400
                dc.w    $81F8, $7840
                dc.w    $8108, $C800
                dc.w    $8004,  $480
                dc.w    $81F8, $F800
                dc.w    $8108, $88C0
                dc.w    $8004, $C440
                dc.w    $8108, $48C0
                dc.w    $8004, $C440
                dc.w    $81F8, $B840
                dc.w    $80FC, $3C80
                dc.w    $81F8, $7800
                dc.w    $80FC, $FC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC80
                dc.w    $3044,  $268
                dc.w    $81F8, $7880
                dc.w    $80FC, $7CC0
                dc.w    $81F8, $B880
                dc.w    $8108,  $800
                dc.w    $8004,  $440
                dc.w    $81F8, $B880
                dc.w    $80FC, $7CC0
                dc.w    $81F8, $B880
                dc.w    $3140,  $228
                dc.w    $81F8, $7880
                dc.w    $31D0,  $228
SKLevel_DEZLightTunnelPath02And03:  dc.w    $F
                dc.w    $1D00,  $1B1
                dc.w    $1D54,  $1A8
                dc.w    $1E08,  $1A8
                dc.w    $8004,  $400
                dc.w    $8108,  $800
                dc.w    $81F8, $7880
                dc.w    $81F8, $78C0
                dc.w    $80FC, $BC40
                dc.w    $8108, $C8C0
                dc.w    $8108, $C800
                dc.w    $1F44,  $228
                dc.w    $81F8, $7840
                dc.w    $8108, $C8C0
                dc.w    $81F8, $3880
                dc.w    $204C,  $228
SKLevel_DEZLightTunnelPath04:   dc.w    $15
                dc.w    $2B80,  $5B1
                dc.w    $2BD8,  $5A8
                dc.w    $2C80,  $5A8
                dc.w    $8108,  $800
                dc.w    $8004,  $400
                dc.w    $2CC8,  $5A8
                dc.w    $80FC, $7C40
                dc.w    $8004, $C440
                dc.w    $8108, $4840
                dc.w    $8108, $4880
                dc.w    $80FC, $FC80
                dc.w    $81F8, $7800
                dc.w    $8108, $8880
                dc.w    $8004, $8400
                dc.w    $2EBC,  $668
                dc.w    $81F8, $7800
                dc.w    $80FC, $FC80
                dc.w    $8108,  $8C0
                dc.w    $8004, $C000
                dc.w    $2F08,  $628
                dc.w    $2F44,  $628
SKLevel_DEZLightTunnelPath05:   dc.w    $1B
                dc.w    $2F00,  $8F1
                dc.w    $2EA8,  $8E8
                dc.w    $2DF4,  $8E8
                dc.w    $80FC, $FCC0
                dc.w    $81F8, $B880
                dc.w    $80FC, $7C00
                dc.w    $80FC, $FC00
                dc.w    $8108, $8840
                dc.w    $8004, $4000
                dc.w    $8108,  $880
                dc.w    $8004, $8480
                dc.w    $81F8, $F840
                dc.w    $80FC, $40C0
                dc.w    $8108, $48C0
                dc.w    $81F8, $3840
                dc.w    $2C34,  $9DC
                dc.w    $8004, $C440
                dc.w    $2D34,  $9AC
                dc.w    $8108, $4880
                dc.w    $81F8, $F800
                dc.w    $8108, $8880
                dc.w    $2C88,  $96C
                dc.w    $80FC, $FC00
                dc.w    $81F8, $F8C0
                dc.w    $8108, $48C0
                dc.w    $81F8, $3800
                dc.w    $2AB0,  $968
SKLevel_DEZLightTunnelPath06:   dc.w    6
                dc.w    $2C00,  $6B1
                dc.w    $2BA8,  $6A8
                dc.w    $2AF4,  $688
                dc.w    $8304, $8480
                dc.w    $8304, $8480
                dc.w    $2A40,  $4E8
SKLevel_DEZLightTunnelPath07:   dc.w    9
                dc.w    $2500,  $38E
                dc.w    $24A8,  $398
                dc.w    $240C,  $398
                dc.w    $8204, $8480
                dc.w    $8204, $8480
                dc.w    $8204, $8480
                dc.w    $8204, $84C0
                dc.w    $8204, $C400
                dc.w    $24D8,  $638
SpriteTerminatE:
                dc.w    $FFFF, 0, 0
DDZ1_Sprites:
                binclude "data/Levels/DDZ/Object Pos/1.bin"
                even
DDZ2_Sprites:
                binclude "data/Levels/DDZ/Object Pos/2.bin"
                even
DDZ1_Rings:
                binclude "data/Levels/DDZ/Ring Pos/1.bin"
                even
DDZ2_Rings:
                binclude "data/Levels/DDZ/Ring Pos/2.bin"
                even
SpriteTerminatF:
                dc.w    $FFFF, 0, 0
Ending_Sprites:
                binclude "data/Levels/SSZ/Object Pos/Ending.bin"
                even
Ending_Rings:
                binclude "data/Levels/SSZ/Ring Pos/Ending.bin"
                even
SpriteTerminatG:
                dc.w    $FFFF, 0, 0
ALZ_Sprites:
                binclude "data/Levels/ALZ/Object Pos/1.bin"
                even
ALZ_Rings:
                binclude "data/Levels/ALZ/Ring Pos/1.bin"
                even
SpriteTerminatH:
                dc.w    $FFFF, 0, 0
BPZ_Sprites:
                binclude "data/Levels/BPZ/Object Pos/1.bin"
                even
BPZ_Rings:
                binclude "data/Levels/BPZ/Ring Pos/1.bin"
                even
SpriteTerminatI:
                dc.w    $FFFF, 0, 0
DPZ_Sprites:
                binclude "data/Levels/DPZ/Object Pos/1.bin"
                even
DPZ_Rings:
                binclude "data/Levels/DPZ/Ring Pos/1.bin"
                even
SpriteTerminatJ:
                dc.w    $FFFF, 0, 0
CGZ_Sprites:
                binclude "data/Levels/CGZ/Object Pos/1.bin"
                even
CGZ_Rings:
                binclude "data/Levels/CGZ/Ring Pos/1.bin"
                even
SpriteTerminatK:
                dc.w    $FFFF, 0, 0
EMZ_Sprites:
                binclude "data/Levels/EMZ/Object Pos/1.bin"
                even
EMZ_Rings:
                binclude "data/Levels/EMZ/Ring Pos/1.bin"
                even
SpriteTerminatL:
                dc.w    $FFFF, 0, 0
Gumball_Sprites:
                binclude "data/Levels/Gumball/Object Pos/1.bin"
                even
Gumball_Rings:
                binclude "data/Levels/Gumball/Ring Pos/1.bin"
                even
SpriteTerminatM:
                dc.w    $FFFF, 0, 0
Pachinko_Sprites:
                binclude "data/Levels/Pachinko/Object Pos/1.bin"
                even
Pachinko_Rings:
                binclude "data/Levels/Pachinko/Ring Pos/1.bin"
                even
SpriteTerminatN:
                dc.w    $FFFF, 0, 0
Slots_Sprites:
                binclude "data/Levels/Slots/Object Pos/1.bin"
                even
Slots_Rings:
                binclude "data/Levels/Slots/Ring Pos/1.bin"
                even
SpriteTerminatO:
                dc.w    $FFFF, 0, 0
LRZ3_Sprites:
                binclude "data/Levels/LRZ/Object Pos/3.bin"
                even
HPZ_Sprites:
                binclude "data/Levels/HPZ/Object Pos/1.bin"
                even
LRZ3_Rings:
                binclude "data/Levels/LRZ/Ring Pos/3.bin"
                even
HPZ_Rings:
                binclude "data/Levels/HPZ/Ring Pos/1.bin"
                even
SpriteTerminatP:
                dc.w    $FFFF, 0, 0
DEZ3_Sprites:
                binclude "data/Levels/DEZ/Object Pos/3.bin"
                even
HPZMini_Sprites:
                binclude "data/Levels/HPZ/Object Pos/Mini.bin"
                even
DEZ3_Rings:
                binclude "data/Levels/DEZ/Ring Pos/3.bin"
                even

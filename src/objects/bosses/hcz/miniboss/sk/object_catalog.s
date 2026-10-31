; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss object attributes, child records, splash DPLC, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_HCZMiniboss_Loop:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,  $F
ObjDat_HCZMiniboss_Rockets:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $200
                dc.b    $10, $10,   1, $8B
word_6AD08:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15,   0
ObjDat2_HCZMiniboss_Engine:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15, $92
ObjDat3_6AD18:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $280
                dc.b    $10, $28, $16,   0
ObjDat3_6AD24:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,1,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjSlot_6AD30:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_HCZMinibossSplash,0,1)
                dc.w    $10,     0
                dc.l    Map_HCZMinibossSplash
                dc.w    $80
                dc.b    $10, $10,   0,   0
word_6AD42:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
word_6AD48:
                dc.w    $280
                dc.b    $14, $24,   0,   0
Child1_HCZMiniboss_RocketsEngine:
                dc.w    5-1
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    $18, $18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    -$18,-$18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    -$18, $18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    $18,-$18
                dc.l    Obj_HCZMiniboss_Engine
                dc.b    0, $24
ChildObjDat_6AD6E:
                dc.w    1-1
                dc.l    loc_6A51E
                dc.b    0,   0
ChildObjDat_6AD76:
                dc.w    1-1
                dc.l    loc_6A460
                dc.b    0,   0
ChildObjDat_6AD7E:
                dc.w    3-1
                dc.l    loc_6A4C8
                dc.b    0,   0
                dc.l    loc_6A4C8
                dc.b    -$10,   0
                dc.l    loc_6A4C8
                dc.b    $10,   0
ChildObjDat_6AD92:
                dc.w    $1E-1
                dc.l    loc_6A65C
ChildObjDat_6AD98:
                dc.w    1-1
                dc.l    loc_6A710
ChildObjDat_6AD9E:
                dc.w    1-1
                dc.l    loc_6A7C4
ChildObjDat_6ADA4:
                dc.w    2-1
                dc.l    loc_6A7C4
ChildObjDat_6ADAA:
                dc.w    4-1
                dc.l    loc_6A8C6
                dc.b    -$C, -$C
                dc.l    loc_6A8C6
                dc.b    -$C,  $C
                dc.l    loc_6A8C6
                dc.b    $C, -$C
                dc.l    loc_6A8C6
                dc.b    $C,  $C
ChildObjDat_6ADC4:
                dc.w    5-1
                dc.l    loc_6A8EE
                dc.b    0,-$24
                dc.l    loc_6A8EE
                dc.b    -8,   0
                dc.l    loc_6A8EE
                dc.b    8,   0
                dc.l    loc_6A8EE
                dc.b    -$C, $30
                dc.l    loc_6A8EE
                dc.b    $C, $30
DPLCPtr_HCZMinibossSplash:
                dc.l    ArtUnc_DashDust
                dc.l    DPLC_HCZMinibossSplash
byte_6ADEC:
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $16,   6
                dc.b    $17,   6
                dc.b    $18,   6
                dc.b    $16,   5
                dc.b    $17,   5
                dc.b    $18,   5
                dc.b    $16,   4
                dc.b    $17,   4
                dc.b    $18,   4
                dc.b    $16,   3
                dc.b    $17,   3
                dc.b    $18,   3
                dc.b    $16,   2
                dc.b    $17,   2
                dc.b    $18,   2
                dc.b    $F4
byte_6AE11:
                dc.b    1, $16, $17, $18, $FC
byte_6AE16:
                dc.b    $16,   2
                dc.b    $17,   2
                dc.b    $18,   2
                dc.b    $16,   3
                dc.b    $17,   3
                dc.b    $18,   3
                dc.b    $16,   4
                dc.b    $17,   4
                dc.b    $18,   4
                dc.b    $16,   5
                dc.b    $17,   5
                dc.b    $18,   5
                dc.b    $16,   6
                dc.b    $17,   6
                dc.b    $18,   6
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $F4
byte_6AE3B:
                dc.b    3,   0,   1,   2,   3,   4,   5,   6,   7,   8, $F4
byte_6AE46:
                dc.b    0,   0, $16, $FC
byte_6AE4A:
                dc.b    0,   1, $16, $FC
byte_6AE4E:
                dc.b    0,   2, $16, $FC
byte_6AE52:
                dc.b    0,   3, $16, $FC
                even
Pal_HCZMiniboss:
                binclude "data/Levels/HCZ/Palettes/Miniboss.bin"
                even
Pal_HCZMinibossWater:
                binclude "data/Levels/HCZ/Palettes/Miniboss Water.bin"
                even
; ---------------------------------------------------------------------------
word_6AE96:
                dc.w    $438,  $838, $3F00, $4100
                dc.w    $738,  $738, $4000, $4050
word_6AEA6:
                dc.w    0,  $3B8, $44E0, $4640
                dc.w    $2B8,  $2B8, $4540, $4590

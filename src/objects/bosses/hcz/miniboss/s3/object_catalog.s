; Owner: objects/bosses/hcz/miniboss/s3
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
word_48B4C:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15,   0
ObjDat2_HCZMiniboss_Engine:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15, $92
ObjDat3_48B5C:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $280
                dc.b    $10, $28, $16,   0
ObjDat3_48B68:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,1,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjSlot_48B74:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_HCZMinibossSplash,0,1)
                dc.w    $10,     0
                dc.l    Map_HCZMinibossSplash
                dc.w    $80
                dc.b    $10, $10,   0,   0
word_48B86:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
word_48B8C:
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
ChildObjDat_48BB2:
                dc.w    1-1
                dc.l    loc_48362
                dc.b    0,   0
ChildObjDat_48BBA:
                dc.w    1-1
                dc.l    loc_482B0
                dc.b    0,   0
ChildObjDat_48BC2:
                dc.w    3-1
                dc.l    loc_4830C
                dc.b    0,   0
                dc.l    loc_4830C
                dc.b    -$10,   0
                dc.l    loc_4830C
                dc.b    $10,   0
ChildObjDat_48BD6:
                dc.w    $1E-1
                dc.l    loc_484A0
ChildObjDat_48BDC:
                dc.w    1-1
                dc.l    loc_48554
ChildObjDat_48BE2:
                dc.w    1-1
                dc.l    loc_48608
ChildObjDat_48BE8:
                dc.w    2-1
                dc.l    loc_48608
ChildObjDat_48BEE:
                dc.w    4-1
                dc.l    loc_4870A
                dc.b    -$C, -$C
                dc.l    loc_4870A
                dc.b    -$C,  $C
                dc.l    loc_4870A
                dc.b    $C, -$C
                dc.l    loc_4870A
                dc.b    $C,  $C
ChildObjDat_48C08:
                dc.w    5-1
                dc.l    loc_48732
                dc.b    0,-$24
                dc.l    loc_48732
                dc.b    -8,   0
                dc.l    loc_48732
                dc.b    8,   0
                dc.l    loc_48732
                dc.b    -$C, $30
                dc.l    loc_48732
                dc.b    $C, $30
DPLCPtr_HCZMinibossSplash:
                dc.l    ArtUnc_DashDust
                dc.l    DPLC_HCZMinibossSplash
byte_48C30:
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
byte_48C55:
                dc.b    1, $16, $17, $18, $FC
byte_48C5A:
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
byte_48C7F:
                dc.b    3,   0,   1,   2,   3,   4,   5,   6,   7,   8, $F4
byte_48C8A:
                dc.b    0,   0, $16, $FC
byte_48C8E:
                dc.b    0,   1, $16, $FC
byte_48C92:
                dc.b    0,   2, $16, $FC
byte_48C96:
                dc.b    0,   3, $16, $FC
                even
Pal_HCZMiniboss:
                binclude "data/Levels/HCZ/Palettes/Miniboss.bin"
                even
Pal_HCZMinibossWater:
                binclude "data/Levels/HCZ/Palettes/Miniboss Water.bin"
                even

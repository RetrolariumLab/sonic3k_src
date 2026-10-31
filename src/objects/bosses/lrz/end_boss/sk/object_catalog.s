; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss and platform attributes, child creation, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_LRZEndBoss:
                dc.l    Map_LRZEndBoss
                dc.w    make_art_tile(ArtTile_LRZEndBoss,1,0)
                dc.w    $280
                dc.b    $28, $2C,   0, $B8
word_7A14C:
                dc.w    $280
                dc.b    $10, $10,   4, $9A
word_7A152:
                dc.w    $280
                dc.b    $10, $10,   5,   0
word_7A158:
                dc.w    $280
                dc.b    8,   8,  $A,   0
word_7A15E:
                dc.w    $200
                dc.b    $28,   4,   1,   0
word_7A164:
                dc.w    make_art_tile(ArtTile_LRZEndBoss,0,0)
                dc.w    $200
                dc.b    $C,   8,  $F,   0
ObjDat3_7A16C:
                dc.l    Map_LRZ3Platform
                dc.w    make_art_tile($001,3,0)
                dc.w    $280
                dc.b    $18, $10,   1,   0
ObjDat3_7A178:
                dc.l    Map_LRZ3Platform
; this is using the incorrect palette line
                dc.w    make_art_tile($001,3,0)
                dc.w    $280
                dc.b    $20, $18,   4,   0
word_7A184:
                dc.w    make_art_tile($001,2,0)
                dc.w    $100
                dc.b    $20,   8,   2,   0
ChildObjDat_7A18C:
                dc.w    2-1
                dc.l    loc_79BE6
                dc.b    0,-$12
                dc.l    loc_79C0C
                dc.b    -$15,   1
ChildObjDat_7A19A:
                dc.w    2-1
                dc.l    loc_79AAE
                dc.b    0,-$18
                dc.l    loc_79B7E
                dc.b    0,-$37
ChildObjDat_7A1A8:
                dc.w    1-1
                dc.l    loc_79BAC
                dc.b    0, $10
ChildObjDat_7A1B0:
                dc.w    1-1
                dc.l    loc_79D28
ChildObjDat_7A1B6:
                dc.w    1-1
                dc.l    loc_79E6C
ChildObjDat_7A1BC:
                dc.w    $A-1
                dc.l    loc_79E9C
byte_7A1C2:
                dc.b    2,   1,   2,   3, $FC
byte_7A1C7:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    6,   1
                dc.b    5,   0
                dc.b    6,   1
                dc.b    7,   3
                dc.b    8,   4
                dc.b    9,   5
                dc.b    $F4
byte_7A1D8:
                dc.b    $A,   2
                dc.b    $A,   2
                dc.b    $B,   3
                dc.b    $C,   4
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $F4
byte_7A1E5:
                dc.b    3,   2,   3, $FC
byte_7A1E9:
                dc.b    7,   4,   5, $FC
                even
Pal_LRZEndBoss:
                binclude "data/Levels/LRZ/Palettes/End Boss.bin"
                even

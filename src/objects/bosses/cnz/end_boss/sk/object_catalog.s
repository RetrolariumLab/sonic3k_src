; Owner: objects/bosses/cnz/end_boss/sk
; Responsibility: Carnival Night end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_CNZEndBoss:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $280
                dc.b    $40, $14,   0,   6
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $280
                dc.b    $20, $20,   5,   0
ObjDat3_6ED9C:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $280
                dc.b    $10, $10,   4, $8B
word_6EDA8:
                dc.w    $280
                dc.b    8, $10,  $A,   0
word_6EDAE:
                dc.w    $280
                dc.b    $14, $14,   0,   0
ObjDat3_6EDB4:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $200
                dc.b    8, $10,   1, $9E
ObjDat3_6EDC0:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $80
                dc.b    $10, $40,   6, $AB
ChildObjDat_6EDCC:
                dc.w    1-1
                dc.l    loc_6E82C
                dc.b    0, $14
ChildObjDat_6EDD4:
                dc.w    4-1
                dc.l    loc_6E95A
                dc.b    0,   8
ChildObjDat_6EDDC:
                dc.w    1-1
                dc.l    loc_6EADA
                dc.b    0, $4C
ChildObjDat_6EDE4:
                dc.w    2-1
                dc.l    loc_6EADA
                dc.b    -$C, $54
                dc.l    loc_6EADA
                dc.b    $C, $54
ChildObjDat_6EDF2:
                dc.w    2-1
                dc.l    loc_6E936
                dc.b    -8,   0
                dc.l    loc_6E936
                dc.b    8,   0
ChildObjDat_6EE00:
                dc.w    2-1
                dc.l    loc_6EBAC
                dc.b    -$14,   0
                dc.l    loc_6EBAC
                dc.b    $14,   0
byte_6EE0E:
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   4
                dc.b    3,   0
                dc.b    1,   9
                dc.b    $FC
byte_6EE1D:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   4
                dc.b    5,   0
                dc.b    4,   9
                dc.b    $FC
byte_6EE2C:
                dc.b    0,   9,   6,   9,   7, $F4
byte_6EE32:
                dc.b    9, $1F
                dc.b    6,   0
                dc.b    9,   2
                dc.b    7,   0
                dc.b    $FC
byte_6EE3B:
                dc.b    9, $24
                dc.b    6,   0
                dc.b    9,   2
                dc.b    7,   0
                dc.b    $FC
                dc.b    7,   0,   1, $FC
                even
Pal_CNZEndBoss:
                binclude "data/Levels/CNZ/Palettes/End Boss.bin"
                even

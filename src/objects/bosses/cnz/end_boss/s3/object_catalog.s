; Owner: objects/bosses/cnz/end_boss/s3
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
ObjDat3_4C872:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $280
                dc.b    $10, $10,   4, $8B
word_4C87E:
                dc.w    $280
                dc.b    8, $10,  $A,   0
word_4C884:
                dc.w    $280
                dc.b    $14, $14,   0,   0
ObjDat3_4C88A:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $200
                dc.b    8, $10,   1, $9E
ObjDat3_4C896:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $80
                dc.b    $10, $40,   6, $AB
ChildObjDat_4C8A2:
                dc.w    1-1
                dc.l    loc_4C33C
                dc.b    0, $14
ChildObjDat_4C8AA:
                dc.w    4-1
                dc.l    loc_4C45C
                dc.b    0,   8
ChildObjDat_4C8B2:
                dc.w    1-1
                dc.l    loc_4C5C6
                dc.b    0, $4C
ChildObjDat_4C8BA:
                dc.w    2-1
                dc.l    loc_4C5C6
                dc.b    -$C, $54
                dc.l    loc_4C5C6
                dc.b    $C, $54
ChildObjDat_4C8C8:
                dc.w    2-1
                dc.l    loc_4C43A
                dc.b    -8,   0
                dc.l    loc_4C43A
                dc.b    8,   0
ChildObjDat_4C8D6:
                dc.w    2-1
                dc.l    loc_4C688
                dc.b    -$14,   0
                dc.l    loc_4C688
                dc.b    $14,   0
byte_4C8E4:
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   4
                dc.b    3,   0
                dc.b    1,   9
                dc.b    $FC
byte_4C8F3:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   4
                dc.b    5,   0
                dc.b    4,   9
                dc.b    $FC
byte_4C902:
                dc.b    0,   9,   6,   9,   7, $F4
byte_4C908:
                dc.b    9, $1F
                dc.b    6,   0
                dc.b    9,   2
                dc.b    7,   0
                dc.b    $FC
byte_4C911:
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

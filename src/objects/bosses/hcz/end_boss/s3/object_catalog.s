; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_HCZEndBoss:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,1,1)
                dc.w    $100
                dc.b    $2C, $1C,   0,   6
word_49B6E:
                dc.w    $200
                dc.b    $C,   4,   1,   0
word_49B74:
                dc.w    $200
                dc.b    $1C,   4,   2,   0
word_49B7A:
                dc.w    $200
                dc.b    $1C,   4,   6,   0
word_49B80:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $14,  $C, $17,   0
word_49B88:
                dc.w    $80
                dc.b    $14, $30,  $D,   0
word_49B8E:
                dc.w    0
                dc.b    $10,   4, $1A,   0
word_49B94:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $C,   8, $18,   0
ObjDat3_49B9C:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $100
                dc.b    $C, $10,   8,   0
ObjDat3_49BA8:
                dc.l    Map_Explosion
                dc.w    make_art_tile(ArtTile_Explosion,0,1)
                dc.w    $80
                dc.b    $C,  $C,   0, $8B
ObjDat3_49BB4:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,0,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat3_49BC0:
                dc.l    Map_HCZWaterWall
                dc.w    make_art_tile(ArtTile_HCZCutsceneGeyser,2,0)
                dc.w    $280
                dc.b    $20, $60,   1,   0
ChildObjDat_49BCC:
                dc.w    5-1
                dc.l    loc_493CE
                dc.b    $23, $12
                dc.l    loc_493CE
                dc.b    $1B,  $A
                dc.l    loc_493CE
                dc.b    $13,  $A
                dc.l    loc_49566
                dc.b    0, $1C
                dc.l    loc_48FB2
                dc.b    0, $24
ChildObjDat_49BEC:
                dc.w    1-1
                dc.l    loc_493CE
                dc.b    $13,  $A
ChildObjDat_49BF4:
                dc.w    1-1
                dc.l    loc_49586
                dc.b    0,   0
ChildObjDat_49BFC:
                dc.w    1-1
                dc.l    loc_49078
                dc.b    0,   0
ChildObjDat_49C04:
                dc.w    1-1
                dc.l    loc_491E8
                dc.b    0,   0
ChildObjDat_49C0C:
                dc.w    2-1
                dc.l    loc_49260
                dc.b    -4,   0
                dc.l    loc_49260
                dc.b    4,   0
ChildObjDat_49C1A:
                dc.w    1-1
                dc.l    loc_492AC
                dc.b    0,   0
ChildObjDat_49C22:
                dc.w    5-1
                dc.l    loc_492CE
ChildObjDat_49C28:
                dc.w    $14-1
                dc.l    loc_49316
ChildObjDat_49C2E:
                dc.w    1-1
                dc.l    Obj_RobotnikShip2
                dc.b    0,  $C
ChildObjDat_49C36:
                dc.w    1-1
                dc.l    loc_495C6
byte_49C3C:
                dc.b    7,   8,   2,   3,   4,   5, $FC
byte_49C43:
                dc.b    0,   2,   3,   4,   5, $FC
byte_49C49:
                dc.b    7,   2,   3,   4,   5, $FC
byte_49C4F:
                dc.b    5,   8,   6,   7, $FC
byte_49C54:
                dc.b    3, $17, $17, $22, $16, $21, $15, $20, $F4
byte_49C5D:
                dc.b    3, $15, $20, $FC
byte_49C61:
                dc.b    3,  $D,  $F, $11, $FC
byte_49C66:
                dc.b    3, $24, $25, $26, $FC
byte_49C6B:
                dc.b    3, $27, $28, $29, $FC
byte_49C70:
                dc.b    3, $2A, $2B, $2C, $FC
byte_49C75:
                dc.b    3, $2D, $2E, $2F, $FC
byte_49C7A:
                dc.b    1, $1A, $23, $FC
byte_49C7E:
                dc.b    $18,   2
                dc.b    $18,   2
                dc.b    $30,   3
                dc.b    $19,   4
                dc.b    $F4
byte_49C87:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
byte_49CBE:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
byte_49CED:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
byte_49D14:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
byte_49D33:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
byte_49D4A:
                dc.b    7,   0,   0,   1,   2,   3,   4, $F4
                even
Pal_HCZEndBoss:
                binclude "data/Levels/HCZ/Palettes/End Boss.bin"
                even

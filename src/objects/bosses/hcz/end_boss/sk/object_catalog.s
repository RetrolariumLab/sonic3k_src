; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_HCZEndBoss:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,1,1)
                dc.w    $100
                dc.b    $2C, $1C,   0,   6
word_6BD2C:
                dc.w    $200
                dc.b    $C,   4,   1,   0
word_6BD32:
                dc.w    $200
                dc.b    $1C,   4,   2,   0
word_6BD38:
                dc.w    $200
                dc.b    $1C,   4,   6,   0
word_6BD3E:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $14,  $C, $17,   0
word_6BD46:
                dc.w    $80
                dc.b    $14, $30,  $D,   0
word_6BD4C:
                dc.w    0
                dc.b    $10,   4, $1A,   0
word_6BD52:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $C,   8, $18,   0
ObjDat3_6BD5A:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $100
                dc.b    $C, $10,   8,   0
ObjDat3_6BD66:
                dc.l    Map_Explosion
                dc.w    make_art_tile(ArtTile_Explosion,0,1)
                dc.w    $80
                dc.b    $C,  $C,   0, $8B
ObjDat3_6BD72:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,0,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat3_6BD7E:
                dc.l    Map_HCZWaterWall
                dc.w    make_art_tile(ArtTile_HCZCutsceneGeyser,2,0)
                dc.w    $280
                dc.b    $20, $60,   1,   0
ChildObjDat_6BD8A:
                dc.w    5-1
                dc.l    loc_6B5C4
                dc.b    $23, $12
                dc.l    loc_6B5C4
                dc.b    $1B,  $A
                dc.l    loc_6B5C4
                dc.b    $13,  $A
                dc.l    loc_6B75C
                dc.b    0, $1C
                dc.l    loc_6B1A8
                dc.b    0, $24
ChildObjDat_6BDAA:
                dc.w    1-1
                dc.l    loc_6B5C4
                dc.b    $13,  $A
ChildObjDat_6BDB2:
                dc.w    1-1
                dc.l    loc_6B77C
                dc.b    0,   0
ChildObjDat_6BDBA:
                dc.w    1-1
                dc.l    loc_6B26E
                dc.b    0,   0
ChildObjDat_6BDC2:
                dc.w    1-1
                dc.l    loc_6B3DE
                dc.b    0,   0
ChildObjDat_6BDCA:
                dc.w    2-1
                dc.l    loc_6B456
                dc.b    -4,   0
                dc.l    loc_6B456
                dc.b    4,   0
ChildObjDat_6BDD8:
                dc.w    1-1
                dc.l    loc_6B4A2
                dc.b    0,   0
ChildObjDat_6BDE0:
                dc.w    5-1
                dc.l    loc_6B4C4
ChildObjDat_6BDE6:
                dc.w    $14-1
                dc.l    loc_6B50C
ChildObjDat_6BDEC:
                dc.w    1-1
                dc.l    Obj_RobotnikShip2
                dc.b    0,  $C
byte_6BDF4:
                dc.b    7,   8,   2,   3,   4,   5, $FC
byte_6BDFB:
                dc.b    0,   2,   3,   4,   5, $FC
byte_6BE01:
                dc.b    7,   2,   3,   4,   5, $FC
byte_6BE07:
                dc.b    5,   8,   6,   7, $FC
byte_6BE0C:
                dc.b    3, $17, $17, $22, $16, $21, $15, $20, $F4
byte_6BE15:
                dc.b    3, $15, $20, $FC
byte_6BE19:
                dc.b    3,  $D,  $F, $11, $FC
byte_6BE1E:
                dc.b    3, $24, $25, $26, $FC
byte_6BE23:
                dc.b    3, $27, $28, $29, $FC
byte_6BE28:
                dc.b    3, $2A, $2B, $2C, $FC
byte_6BE2D:
                dc.b    3, $2D, $2E, $2F, $FC
byte_6BE32:
                dc.b    1, $1A, $23, $FC
byte_6BE36:
                dc.b    $18,   2
                dc.b    $18,   2
                dc.b    $30,   3
                dc.b    $19,   4
                dc.b    $F4
byte_6BE3F:
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
byte_6BE76:
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
byte_6BEA5:
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
byte_6BECC:
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
byte_6BEEB:
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
byte_6BF02:
                dc.b    7,   0,   0,   1,   2,   3,   4, $F4
                even
Pal_HCZEndBoss:
                binclude "data/Levels/HCZ/Palettes/End Boss.bin"
                even

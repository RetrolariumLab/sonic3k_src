; Owner: objects/bosses/lbz/final_boss_1/s3
; Responsibility: Launch Base first final boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZFinalBoss1:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $280
                dc.b    $20, $20,  $C,  $F
word_502B0:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $10,   4, $15,   0
word_502B8:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C, $10, $16,   0
ObjDat3_502C0:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $20, $14,   0, $AD
ObjDat3_502CC:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28, $18,   1, $AD
word_502D8:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $280
                dc.b    $C, $18,   9, $89
word_502E0:
                dc.w    $200
                dc.b    $10, $10, $2A,   0
word_502E6:
                dc.w    $180
                dc.b    $C,  $C,   3,   0
word_502EC:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $100
                dc.b    $18,   8,  $F,   0
word_502F4:
                dc.w    $100
                dc.b    8,   8, $1C,   0
ObjDat3_502FA:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C,  $C,  $C, $97
ObjDat3_50306:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28,   8,   2,   0
ObjDat3_50312:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $280
                dc.b    $10,  $C, $10,   0
ChildObjDat_5031E:
                dc.w    1-1
                dc.l    loc_4FEF2
                dc.b    0, $10
ChildObjDat_50326:
                dc.w    1-1
                dc.l    loc_4FF0A
                dc.b    0,   8
ChildObjDat_5032E:
                dc.w    3-1
                dc.l    loc_4FC30
                dc.b    0,   8
                dc.l    loc_4FC90
                dc.b    0, $30
                dc.l    loc_4FC98
                dc.b    0, $5C
ChildObjDat_50342:
                dc.w    4-1
                dc.l    loc_4FCC8
                dc.b    -$10,  -4
                dc.l    loc_4FCC8
                dc.b    $10,  -4
                dc.l    loc_4FCC8
                dc.b    -$10, $10
                dc.l    loc_4FCC8
                dc.b    $10, $10
ChildObjDat_5035C:
                dc.w    6-1
                dc.l    loc_4FCC8
                dc.b    -$10,  -8
                dc.l    loc_4FCC8
                dc.b    $10,  -8
                dc.l    loc_4FCC8
                dc.b    -$10, $10
                dc.l    loc_4FCC8
                dc.b    $10, $10
                dc.l    loc_4FCC8
                dc.b    -$14,-$20
                dc.l    loc_4FCC8
                dc.b    $14,-$20
ChildObjDat_50382:
                dc.w    2-1
                dc.l    loc_4FD52
                dc.b    0,   0
ChildObjDat_5038A:
                dc.w    1-1
                dc.l    loc_4FD98
                dc.b    -8,   0
                dc.w    1-1
                dc.l    loc_4FD98
                dc.b    8,   0
ChildObjDat_5039A:
                dc.w    1-1
                dc.l    loc_4FEAA
                dc.b    $20,   0
ChildObjDat_503A2:
                dc.w    2-1
                dc.l    loc_4FECE
                dc.b    -$14, $30
                dc.l    loc_4FECE
                dc.b    $14, $30
ChildObjDat_503B0:
                dc.w    1-1
                dc.l    loc_4FF80
                dc.b    0,   0
ChildObjDat_503B8:
                dc.w    1-1
                dc.l    loc_4FCF0
                dc.b    0,-$14
ChildObjDat_503C0:
                dc.w    2-1
                dc.l    loc_4FD1A
                dc.b    -$10,   0
                dc.l    loc_4FD1A
                dc.b    $10,   0
byte_503CE:
                dc.b    2,   9,  $A,  $B, $FC
byte_503D3:
                dc.b    0, $17, $17, $18, $19, $1A, $1B, $F4
byte_503DB:
                dc.b    0, $1C, $1C, $1D, $1E, $F4
byte_503E1:
                dc.b    0, $1F, $1F, $20, $21, $F4
byte_503E7:
                dc.b    1,  $C,  $D,  $E,  $D,  $C, $F4
                even
Pal_LBZFinalBoss1:
                binclude "data/Levels/LBZ/Palettes/Final Boss 1.bin"
                even

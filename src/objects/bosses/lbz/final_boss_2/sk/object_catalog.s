; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss object attributes, child construction, animation, mappings and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZFinalBoss2:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $1C, $20,   5,   0
ObjDat3_750C2:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $200
                dc.b    $28, $28,   0,   0
ObjDat3_750CE:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $180
                dc.b    $20, $10,   2,   0
word_750DA:
                dc.w    $80
                dc.b    $14, $14,   4,   0
word_750E0:
                dc.w    $180
                dc.b    8,   8,   3,   0
ObjDat3_750E6:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $300
                dc.b    $14,  $C,   1,   0
ObjDat3_750F2:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $C,  $C,  $C,   0
ObjDat3_750FE:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,1)
                dc.w    $100
                dc.b    $10, $14,  $D,   0
ObjDat3_7510A:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C, $10, $16,   0
ObjDat3_75116:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $10,   4, $15,   0
ChildObjDat_75122:
                dc.w    4-1
                dc.l    loc_749D0
                dc.b    $14, $24
                dc.l    loc_749AE
                dc.b    $C,-$14
                dc.l    loc_74B9E
                dc.b    0,-$18
                dc.l    loc_74BC0
                dc.b    $38,-$14
ChildObjDat_7513C:
                dc.w    1-1
                dc.l    loc_74C00
                dc.b    4,-$34
ChildObjDat_75144:
                dc.w    4-1
                dc.l    loc_74AFA
                dc.b    -$2A,  -2
                dc.l    loc_74AFA
                dc.b    -$4A,  -2
                dc.l    loc_74A9A
                dc.b    0,   0
                dc.l    loc_74C24
                dc.b    -$40,  -2
ChildObjDat_7515E:
                dc.w    4
                dc.l    loc_74D14
                dc.b    -$C,-$2C
                dc.l    loc_74D14
                dc.b    $14,-$2C
                dc.l    loc_74D14
                dc.b    $2C,-$18
                dc.l    loc_74D14
                dc.b    -$C,  -4
                dc.l    loc_74D14
                dc.b    $14,  -4
ChildObjDat_7517E:
                dc.w    1-1
                dc.l    loc_74D48
                dc.b    0,   8
ChildObjDat_75186:
                dc.w    1-1
                dc.l    loc_74E12
                dc.b    0, $10
ChildObjDat_7518E:
                dc.w    1-1
                dc.l    loc_74E30
byte_75194:
                dc.b    9,   7,   4,   5,   6,   5,   4, $FC
byte_7519C:
                dc.b    9,  $B,   8,   9,  $A,   9,   8, $FC
byte_751A4:                                             ; used in S3, unused in S3K
                dc.b    2,   4,   4,   5,   6, $F4
Pal_LBZFinalBoss2:
                binclude "data/Levels/LBZ/Palettes/Final Boss 2.bin"
                even

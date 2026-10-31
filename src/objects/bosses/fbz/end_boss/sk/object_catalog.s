; Owner: objects/bosses/fbz/end_boss/sk
; Responsibility: Flying Battery end-boss attributes, child construction, animation, mappings, palettes and circular lookup resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_FBZEndBoss:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss,1,1)
                dc.w    $200
                dc.b    $28, $18,   0, $16
word_70E98:
                dc.w    $280
                dc.b    $10, $20,   1, $A3
word_70E9E:
                dc.w    $200
                dc.b    8,   8,   2,   0
word_70EA4:
                dc.w    $180
                dc.b    $C,   8,   3,   0
word_70EAA:
                dc.w    $80
                dc.b    $14, $10,   8,   0
ObjDat3_70EB0:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss,0,1)
                dc.w    0
                dc.b    4,   8,   4, $8B
ObjDat3_70EBC:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    0
                dc.b    $10, $10,   0, $8B
ObjDat3_70EC8:
                dc.l    Map_FBZEndBossFlame
                dc.w    make_art_tile(ArtTile_FBZEndBossFlame,0,1)
                dc.w    0
                dc.b    $10, $10,   0, $8B
ObjDat_FBZExitDoor:
                dc.l    Map_FBZExitDoor
                dc.w    make_art_tile(ArtTile_FBZExitDoor,2,0)
                dc.w    $80
                dc.b    8, $20,   0, $D7
ChildObjDat_70EE0:
                dc.w    3-1
                dc.l    loc_70948
                dc.b    -$30, $48
                dc.l    loc_70948
                dc.b    $30, $48
                dc.l    loc_70AFC
                dc.b    0,-$28
ChildObjDat_70EF4:
                dc.w    1-1
                dc.l    loc_70A46
                dc.b    0,-$20
ChildObjDat_70EFC:
                dc.w    4-1
                dc.l    loc_70AA2
                dc.b    0,   0
ChildObjDat_70F04:
                dc.w    9-1
                dc.l    loc_70B8C
ChildObjDat_70F0A:
                dc.w    4-1
                dc.l    loc_70BD0
                dc.b    -$14,   8
                dc.l    loc_70BD0
                dc.b    $14,   8
                dc.l    loc_70BD0
                dc.b    -$10, $20
                dc.l    loc_70BD0
                dc.b    $10, $20
ChildObjDat_70F24:
                dc.w    4-1
                dc.l    loc_70BFE
                dc.b    -8,-$10
                dc.l    loc_70BFE
                dc.b    8,-$10
                dc.l    loc_70BFE
                dc.b    -8, $10
                dc.l    loc_70BFE
                dc.b    8, $10
byte_70F3E:
                dc.b    4,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    $F4
byte_70F61:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   2
                dc.b    2,   3
                dc.b    3,   4
                dc.b    4,   5
                dc.b    5,   6
                dc.b    $F4
byte_70F70:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   3
                dc.b    2,   4
                dc.b    3,   5
                dc.b    4,   6
                dc.b    $F4
                even
Map_FBZExitDoor:
                include "src/objects/shared/zones/fbz/map_exit_door.s"
Pal_FBZEndBoss:
                binclude "data/Levels/FBZ/Palettes/FBZ End Boss.bin"
                even
Map_FBZEndBoss:
                include "src/objects/shared/zones/fbz/map_end_boss.s"
Map_FBZEndBossFlame:
                include "src/objects/shared/zones/fbz/map_end_boss_flame.s"
FBZEndBoss_CircleLookup1:
                dc.b    0,   2,   4,   5,   7,   9,  $B,  $C,  $E, $10, $11, $13, $15, $17, $18, $1A, $1C, $1D, $1F, $20
                dc.b    $22, $23, $25, $27, $28, $29, $2B, $2C, $2E, $2F, $30, $32, $33, $34, $35, $37, $38, $39, $3A, $3B
                dc.b    $3C, $3D, $3E, $3F, $3F, $40, $41, $42, $43, $43, $44, $44, $45, $45, $46, $46, $47, $47, $47, $47
                dc.b    $48, $48, $48, $48
FBZEndBoss_CircleLookup2:
                dc.b    0,   1,   2,   2,   3,   4,   5,   5,   6,   7,   8,   9,   9,  $A,  $B,  $C,  $C,  $D,  $E,  $E
                dc.b    $F, $10, $10, $11, $12, $12, $13, $14, $14, $15, $15, $16, $17, $17, $18, $18, $19, $19, $1A, $1A
                dc.b    $1B, $1B, $1B, $1C, $1C, $1D, $1D, $1D, $1E, $1E, $1E, $1E, $1F, $1F, $1F, $1F, $1F, $20, $20, $20
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------
word_71142:
                dc.w    0,  $378,  $5F0,  $7F0
                dc.w    $2B8,  $2B8,  $6F0,  $6F0
word_71152:
                dc.w    $7C8,  $9C8,  $5F0,  $7F0
                dc.w    $8C8,  $8C8,  $6F0,  $6F0

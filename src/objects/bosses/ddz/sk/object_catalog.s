; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday boss, missile and asteroid attributes, child construction, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat3_831BA:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $280
                dc.b    8,   8, $1C,   0
word_831C6:
                dc.w    $280
                dc.b    4,   4, $24,   0
ObjDat3_831CC:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    $38, $2C, $38,   0
ObjDat3_831D8:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $280
                dc.b    $10, $18,   7,   0
ObjDat3_831E4:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $180
                dc.b    $10, $10,   6,   0
ObjDat_DDZMissile:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $180
                dc.b    $18, $18,   8,   0
word_831FC:
                dc.w    $180
                dc.b    8,   8, $12,   0
word_83202:
                dc.w    $200
                dc.b    8,   8, $18,   0
word_83208:
                dc.w    $300
                dc.b    $C,  $C, $29,   0
ObjDat3_8320E:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $200
                dc.b    $40, $24,   1,   0
ObjDat3_8321A:
                dc.l    Map_SuperSonic_Stars
                dc.w    make_art_tile(ArtTile_Shield,0,1)
                dc.w    $80
                dc.b    $18, $18,   0,   0
ObjDat3_83226:
                dc.l    Map_BossMasterEmerald
                dc.w    make_art_tile(ArtTile_BossMasterEmerald,3,0)
                dc.w    $280
                dc.b    $20, $18,   0,   0
ObjDat3_83232:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    $10,  $C, $31,   0
word_8323E:
                dc.w    $280
                dc.b    8, $10, $33,   0
ObjDat3_83244:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    8,   8, $25,   0
ChildObjDat_83250:
                dc.w    1-1
                dc.l    loc_8214A
ChildObjDat_83256:
                dc.w    1-1
                dc.l    loc_8218E
ChildObjDat_8325C:
                dc.w    1-1
                dc.l    loc_81E3C
ChildObjDat_83262:
                dc.w    3-1
                dc.l    loc_81F36
ChildObjDat_83268:
                dc.w    3-1
                dc.l    loc_81E82
ChildObjDat_8326E:
                dc.w    1-1
                dc.l    loc_81F14
ChildObjDat_83274:
                dc.w    3-1
                dc.l    loc_81D72
ChildObjDat_8327A:
                dc.w    1-1
                dc.l    loc_81CC6
                dc.b    $1C,  -4
ChildObjDat_83282:
                dc.w    2-1
                dc.l    loc_81F7E
ChildObjDat_83288:
                dc.w    4-1
                dc.l    loc_825CA
ChildObjDat_8328E:
                dc.w    4-1
                dc.l    loc_8249A
ChildObjDat_83294:
                dc.w    2-1
                dc.l    loc_82588
                dc.b    8,   0
                dc.l    loc_825BC
                dc.b    -$18,   0
ChildObjDat_832A2:
                dc.w    1-1
                dc.l    loc_826A0
byte_832A8:
                dc.b    3, $29, $2A, $2B, $2C, $FC
byte_832AE:
                dc.b    3, $2D, $2E, $2F, $30, $FC
byte_832B4:
                dc.b    $18,   3
                dc.b    $18,   3
                dc.b    $19,   3
                dc.b    $1A,   4
                dc.b    $1B,   5
                dc.b    $F4
byte_832BF:
                dc.b    1, $31, $32, $FC
byte_832C3:
                dc.b    $33,   3
                dc.b    $34,   3
                dc.b    $35,   3
                dc.b    $39,   7
                dc.b    $37,   3
                dc.b    $36,   3
                dc.b    $FC
byte_832D0:
                dc.b    $3A, $2F
                dc.b    $3B,   9
                dc.b    $3C,   9
                dc.b    $3B,   9
                dc.b    $FC
byte_832D9:
                dc.b    $3D, $2F
                dc.b    $3E,   9
                dc.b    $3F,   9
                dc.b    $3E,   9
                dc.b    $FC
                even
Map_DDZMissileAsteroid:
                include "src/objects/shared/zones/ddz/map_missile_asteroid.s"

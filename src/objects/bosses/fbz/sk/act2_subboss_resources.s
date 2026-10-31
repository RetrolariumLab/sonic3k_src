; Owner: objects/bosses/fbz/sk
; Responsibility: Flying Battery act-two subboss object construction, animation, palette, mappings and Sonic or Knuckles graphics load records
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_FBZ2Subboss:
                dc.l    Map_FBZ2Subboss
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0, $1C
word_703A2:
                dc.w    $80
                dc.b    8,   8,   1,   0
word_703A8:
                dc.w    $280
                dc.b    $C, $14,   2,   0
word_703AE:
                dc.w    $80
                dc.b    8, $60,   4,   0
word_703B4:
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $80
                dc.b    $18,   4,   5,   0
ObjDat3_703BC:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
ChildObjDat_703C8:
                dc.w    4-1
                dc.l    loc_6FF5C
                dc.b    0,   0
ChildObjDat_703D0:
                dc.w    2-1
                dc.l    loc_6FFDC
                dc.b    0,   0
                dc.l    loc_7002A
                dc.b    0,   0
ChildObjDat_703DE:
                dc.w    1-1
                dc.l    Obj_SpriteMask
ChildObjDat_703E4:
                dc.w    2-1
                dc.l    loc_70118
                dc.b    0,   0
ChildObjDat_703EC:
                dc.w    1-1
                dc.l    loc_70192
                dc.b    0,   8
byte_703F4:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
byte_70401:
                dc.b    $B, $40
                dc.b    5,  $A
                dc.b    $FC
byte_70406:
                dc.b    0,   6,   6,  $A,   7,  $A
                dc.b    $F8, .jump-byte_70406

                .jump:
                dc.b    0,   8,  $A, $FC
byte_70412:
                dc.b    0,   7
                dc.b    7,  $A
                dc.b    6,  $A
                dc.b    $F4
byte_70419:
                dc.b    5,   0,   1,   2,   1, $FC
                even
Pal_FBZ2Subboss:
                binclude "data/Levels/FBZ/Palettes/FBZ2 Subboss.bin"
                even
Map_FBZ2Subboss:
                include "src/objects/shared/zones/fbz/map_act_2_subboss.s"
PLC_FBZ2Subboss_SonicTails: plrlistheader
                plreq   ArtTile_FBZ2Subboss, ArtNem_FBZ2Subboss
                plreq   ArtTile_FBZRobotnikStand, ArtNem_FBZRobotnikStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_FBZ2Subboss_SonicTails_End:

PLC_FBZ2Subboss_Knuckles:   plrlistheader
                plreq   ArtTile_FBZ2Subboss, ArtNem_FBZ2Subboss
                plreq   ArtTile_FBZRobotnikStand, ArtNem_EggRoboStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_EggRoboRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_FBZ2Subboss_Knuckles_End:

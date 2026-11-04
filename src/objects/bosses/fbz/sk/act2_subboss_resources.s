; Owner: objects/bosses/fbz/sk
; Responsibility: Flying Battery act-two subboss object construction, animation, palette, mappings and Sonic or Knuckles graphics load records
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_FBZ2Subboss:
                dc.l    Map_FBZ2Subboss
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0, $1C
FBZAct2SK_CornerAttributes:
                dc.w    $80
                dc.b    8,   8,   1,   0
FBZAct2SK_FixedCoverAttributes:
                dc.w    $280
                dc.b    $C, $14,   2,   0
FBZAct2SK_BarrierAttributes:
                dc.w    $80
                dc.b    8, $60,   4,   0
FBZAct2SK_ChargeAttributes:
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $80
                dc.b    $18,   4,   5,   0
FBZAct2SK_OperatorAttributes:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
FBZAct2SK_CornerChildren:
                dc.w    4-1
                dc.l    FBZAct2SK_InitCornerAndRegister
                dc.b    0,   0
FBZAct2SK_SceneAttachmentChildren:
                dc.w    2-1
                dc.l    FBZAct2SK_InitFixedCover
                dc.b    0,   0
                dc.l    FBZAct2SK_InitOperatorAndIdleAnim
                dc.b    0,   0
FBZAct2SK_ParentFlagMaskChild:
                dc.w    1-1
                dc.l    Obj_SpriteMask
FBZAct2SK_SolidBarrierChildren:
                dc.w    2-1
                dc.l    FBZAct2SK_InitBarrierAndBindCorner
                dc.b    0,   0
FBZAct2SK_ChargeChild:
                dc.w    1-1
                dc.l    FBZAct2SK_InitAcceleratingCharge
                dc.b    0,   8
FBZAct2SK_OperatorIdleAnim:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
FBZAct2SK_ChargeAccelerateAnim:
                dc.b    $B, $40
                dc.b    5,  $A
                dc.b    $FC
FBZAct2SK_LaserFireAnim:
                dc.b    0,   6,   6,  $A,   7,  $A
                dc.b    $F8, .jump-FBZAct2SK_LaserFireAnim

                .jump:
                dc.b    0,   8,  $A, $FC
FBZAct2SK_LaserRetractAnim:
                dc.b    0,   7
                dc.b    7,  $A
                dc.b    6,  $A
                dc.b    $F4
FBZAct2SK_OperatorRunAnim:
                dc.b    5,   0,   1,   2,   1, $FC
                even
Pal_FBZ2Subboss:
                binclude "data/Levels/FBZ/Palettes/FBZ2 Subboss.bin"
                even
Map_FBZ2Subboss:
                include "src/objects/shared/zones/fbz/act2/mappings/subboss.s"
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

; Owner: objects/bosses/soz/end_boss/sk
; Responsibility: Sandopolis end-boss object attributes, construction records, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_SOZEndBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $300
                dc.b    $20, $20,  $A,   0
SOZBoss_VisibleFollowerAttributes:
                dc.l    Map_SOZEndBoss
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $280
                dc.b    $18, $1C,   6,   0
SOZBoss_FixedBodyAttributes:
                dc.l    Map_SOZEndBossBody
                dc.w    make_art_tile($001,0,0)
                dc.w    0
                dc.b    $10, $30,   0,   0
SOZEndBoss_FrontBasePartialAttributes:
                dc.w    $200
                dc.b    $18, $18,   0,   0
SOZEndBoss_RearBasePartialAttributes:
                dc.w    $300
                dc.b    $18, $18,   3,   0
SOZEndBoss_FrontMiddlePartialAttributes:
                dc.w    $180
                dc.b    $14, $14,   1,   0
SOZEndBoss_RearMiddlePartialAttributes:
                dc.w    $300
                dc.b    $14, $14,   4,   0
SOZEndBoss_FrontArmPartialAttributes:
                dc.w    $100
                dc.b    $28, $14,   2,   0
SOZEndBoss_RearArmPartialAttributes:
                dc.w    $300
                dc.b    $28, $14,   5,   0
SOZEndBoss_ChargeGeneratorFullAttributes:
                dc.l    Map_SOZEndBoss
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,1)
                dc.w    $180
                dc.b    8,   8,  $D,   0
SOZBoss_ChargeParticleAttributes:
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $200
                dc.b    4,   4,  $A,   0
SOZEndBoss_FiredShotPartial2Attributes:
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $300
                dc.b    $14, $14,  $E, $98
SOZEndBoss_SpriteMaskFullAttributes:
                dc.l    Map_SpriteMask
                dc.w    make_art_tile($000,0,0)
                dc.w    $280
                dc.b    $20, $20,   4,   0
SOZEndBoss_SixDistinctRootNormalChildren:
                dc.w    6-1
                dc.l    SOZBoss_InitUpperSolidBody
                dc.b    0,-$14
                dc.l    SOZBoss_InitLowerSolidBody
                dc.b    0, $40
                dc.l    SOZBoss_InitRightBarrier
                dc.b    $20,   0
                dc.l    SOZBoss_InitFixedBodyMask
                dc.b    0,   0
                dc.l    SOZBoss_InitVisibleFollower
                dc.b    0, $24
                dc.l    Obj_RobotnikHead4
                dc.b    0,-$1C
SOZEndBoss_ThreeFrontLinkedBodyActors:
                dc.w    3-1
                dc.l    SOZBoss_BindLimbMappingsAndDispatch
SOZEndBoss_ThreeRearLinkedBodyActors:
                dc.w    3-1
                dc.l    SOZEndBoss_SelectRearTreeSubtypeOffset
SOZBoss_ChargeGeneratorChild:
                dc.w    1-1
                dc.l    SOZBoss_InitChargeGenerator
                dc.b    -$18,-$2E
SOZEndBoss_TwentyRepeatedChargeParticles:
                dc.w    $14-1
                dc.l    SOZBoss_InitChargeParticleAndDelay
SOZBoss_MaskAndShotChildren:
                dc.w    2-1
                dc.l    SOZBoss_InitShortSpriteMask
                dc.b    0,-$14
                dc.l    SOZBoss_InitShotAndAimAtPlayer
                dc.b    4, -$A
SOZBoss_ChargeParticleAnim:
                dc.b    7,  $A,  $A,  $B,  $C, $F4
                even
Map_SOZEndBoss:
                include "src/objects/shared/zones/soz/mappings/end_boss.s"
Map_SOZEndBossBody:
                include "src/objects/shared/zones/soz/boss/mappings/body.s"
Pal_SOZEndBoss1:
                binclude "data/Levels/SOZ/Palettes/End Boss 1.bin"
                even
Pal_SOZEndBoss2:
                binclude "data/Levels/SOZ/Palettes/End Boss 2.bin"
                even
; ---------------------------------------------------------------------------
LRZMiniboss_CameraTriggerBounds:
                dc.w    $610,  $810, $2B00, $2D00
LRZMiniboss_CameraTargetBounds:
                dc.w    $710,  $710, $2C00, $2C00
                even

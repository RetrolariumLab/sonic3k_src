; Owner: objects/bosses/lbz/end_boss/sk
; Responsibility: Launch Base end-boss object attributes, child construction, raw animations and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZEndBoss:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $280
                dc.b    $20, $10,   0, $18
LBZEndBossSK_Runner_FullAttributes:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_FBZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
LBZEndBossSK_Operator_FullAttributes:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $300
                dc.b    $10,   8,   4,   0
LBZEndBossSK_Cover_FullAttributes:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    0
                dc.b    8, $80,  $C,   0
LBZEndBossSK_Trim_PartialAttributes:
                dc.w    $280
                dc.b    8, $18,   2,   0
LBZBossSK_TrimDebrisAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $D,   0
LBZBossSK_ShotAttributes:
                dc.w    $280
                dc.b    $10, $10,   5, $9A
LBZBossSK_SmallEffectAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
LBZBossSK_ShotDebrisAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $A,   0
LBZEndBossSK_Platform_FullAttributes:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,2,0)
                dc.w    $280
                dc.b    8,   8,  $E,   0
LBZBossSK_OperatorAndCoverChildren:
                dc.w    2-1
                dc.l    LBZBossSK_OperatorFollowDispatchDraw
                dc.b    0,  -8
                dc.l    LBZBossSK_InitSolidCover
                dc.b    -$18,-$70
LBZEndBossSK_Runner_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossSK_RunnerDispatchAndCull
                dc.b    $70,-$18
LBZEndBossSK_Trim_NormalThreeChildren:
                dc.w    3-1
                dc.l    LBZBossSK_TrimFollowDispatchAndDraw
                dc.b    -$18, $38
                dc.l    LBZBossSK_TrimFollowDispatchAndDraw
                dc.b    $18, $38
                dc.l    LBZBossSK_TrimFollowDispatchAndDraw
                dc.b    0, $38
LBZBossSK_TrimDebrisChildren:
                dc.w    3-1
                dc.l    LBZBossSK_InitTrimDebris
                dc.b    0,-$18
                dc.l    LBZBossSK_InitTrimDebris
                dc.b    0,  -8
                dc.l    LBZBossSK_InitTrimDebris
                dc.b    0,   8
LBZBossSK_LinkedPlatformChildren:
                dc.w    4-1
                dc.l    LBZBossSK_LeadPlatformDispatchAndDraw
LBZEndBossSK_Projectile_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossSK_ShotDispatchAndDraw
                dc.b    0,   0
LBZEndBossSK_SmallEffect_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossSK_InitSmallEffectAndDelay
                dc.b    0, $10
LBZBossSK_ShotBreakupChildren:
                dc.w    $C-1
                dc.l    LBZBossSK_InitShotDebris
                dc.b    -8,  -8
                dc.l    LBZBossSK_InitShotDebris
                dc.b    8,  -8
                dc.l    LBZBossSK_InitShotDebris
                dc.b    -8,   8
                dc.l    LBZBossSK_InitShotDebris
                dc.b    8,   8
                dc.l    LBZBossSK_InitShotDebris
                dc.b    -$10,-$10
                dc.l    LBZBossSK_InitShotDebris
                dc.b    $10,-$10
                dc.l    LBZBossSK_InitShotDebris
                dc.b    -$10, $10
                dc.l    LBZBossSK_InitShotDebris
                dc.b    $10, $10
                dc.l    LBZBossSK_InitSmallEffectAndDelay
                dc.b    -8,   6
                dc.l    LBZBossSK_InitSmallEffectAndDelay
                dc.b    6,   8
                dc.l    LBZBossSK_InitSmallEffectAndDelay
                dc.b    -8,  -6
                dc.l    LBZBossSK_InitSmallEffectAndDelay
                dc.b    6,  -8
LBZEndBossSK_Runner_UniformRawRunFrames:
                dc.b    7,   0,   1,   2,   1, $FC
LBZBossSK_OperatorBattleAnim:
                dc.b    7,   0,   1, $FC
LBZBossSK_ShotLoopAnim:
                dc.b    0,   5,   6, $FC
LBZBossSK_SmallEffectDeleteAnim:
                dc.b    5,   7,   7,   8,   9, $F4
                even
Pal_LBZEndBoss:
                binclude "data/Levels/LBZ/Palettes/End Boss.bin"
                even
LBZEndBossSK_StoredAuxiliaryMappingTable:
                dc.w    LBZBossSK_StoredAuxMappingFrame0-LBZEndBossSK_StoredAuxiliaryMappingTable
                dc.w    LBZBossSK_StoredAuxMappingFrame1-LBZEndBossSK_StoredAuxiliaryMappingTable
LBZBossSK_StoredAuxMappingFrame0:
                dc.w    8
                dc.b    $80, $07,   0,   0, $FF, $F8
                dc.b    $A0, $07,   0,   0, $FF, $F8
                dc.b    $C0, $07,   0,   0, $FF, $F8
                dc.b    $E0, $07,   0,   0, $FF, $F8
                dc.b    $00, $07,   0,   0, $FF, $F8
                dc.b    $20, $07,   0,   0, $FF, $F8
                dc.b    $40, $07,   0,   0, $FF, $F8
                dc.b    $60, $07,   0,   0, $FF, $F8
LBZBossSK_StoredAuxMappingFrame1:
                dc.w    2
                dc.b    $EC, $07,   0,   0, $FF, $F8
                dc.b    $F4, $07,   0,   0, $FF, $F8

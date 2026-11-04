; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss attributes, child construction, animation, palette and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_DEZEndBoss:
                dc.l    Map_DEZEndBoss
                dc.w    make_art_tile(ArtTile_DEZEndBoss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
DEZBossBumper_PartialAttributeRecord:
                dc.w    $180
                dc.b    $18, $18,   4, $D7
DEZBoss_SleeveAttributes:
                dc.w    $200
                dc.b    $18,   4, $16, $9C
DEZBoss_SleeveOverlayAttributes:
                dc.w    $200
                dc.b    $18,  $C, $13, $9C
DEZBossCapsule_PartialAttributeRecord:
                dc.w    $280
                dc.b    $10, $18, $11,   0
DEZBoss_CapsuleFragmentAttributes:
                dc.w    $280
                dc.b    8,   8, $1F, $98
DEZBoss_DefeatFragmentAttributes:
                dc.w    0
                dc.b    $28, $28, $22,   0
DEZBossExitRobotnik_FullAttributeRecord:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
DEZBossExitPanel_FullAttributeRecord:
                dc.l    Map_DEZEndBoss
                dc.w    make_art_tile(ArtTile_DEZEndBoss,1,1)
                dc.w    $180
                dc.b    $C, $14, $14,   0
DEZBoss_ExitSceneChildren:
                dc.w    2-1
                dc.l    DEZBoss_InitEscapingRobotnik
                dc.b    0,   0
                dc.l    DEZBoss_InitAftermathPiece
                dc.b    0,   0
DEZEndBoss_SingleTargetBumperSimpleChild:
                dc.w    1-1
                dc.l    DEZBoss_InitBumperAndTarget
DEZBoss_SleeveAndCapsuleChildren:
                dc.w    2-1
                dc.l    DEZBoss_InitSleeveAndOverlay
                dc.b    0, $14
                dc.l    DEZBoss_InitAttachedCapsule
                dc.b    0,  $C
DEZBoss_SleeveOverlayChild:
                dc.w    1-1
                dc.l    DEZBoss_InitSleeveOverlay
DEZBoss_CapsuleFragmentChildren:
                dc.w    3-1
                dc.l    DEZBoss_InitFragmentAndReparent
                dc.b    -$10,  -9
                dc.l    DEZBoss_InitFragmentAndReparent
                dc.b    0, -$C
                dc.l    DEZBoss_InitFragmentAndReparent
                dc.b    $10,  -9
DEZBoss_DefeatFragmentChildren:
                dc.w    6-1
                dc.l    DEZBoss_InitDefeatFragment
DEZBoss_DefeatSweepChildren:
                dc.w    2-1
                dc.l    DEZBoss_InitExplosionSweep
DEZEndBossAttack_FixedDelayOpenSequence:
                dc.b    3,   0,   1,   2, $F4
DEZEndBossAttack_FixedDelayCloseSequence:
                dc.b    3,   2,   1,   0, $F4
DEZRollingCapsule_FixedDelayTwoFrameLoop:
                dc.b    3, $11, $12, $FC
DEZBossExitRobotnik_FrameDelayLoop:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
DEZBoss_SleeveLoopAnim:
                dc.b    $16,   0
                dc.b    $17,   1
                dc.b    $1E,   1
                dc.b    $18,   0
                dc.b    $19,   1
                dc.b    $1E,   1
                dc.b    $1A,   0
                dc.b    $1B,   1
                dc.b    $1E,   4
                dc.b    $1C,   0
                dc.b    $1D,   1
                dc.b    $1E,   1
                dc.b    $FC
                even
Pal_DEZEndBoss:
                binclude "data/Levels/DEZ/Palettes/End Boss.bin"
                even
DEZBoss_BumperQuarterTurnLookup:
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    $B
                dc.b    $C
                dc.b    $D
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $10
                dc.b    $11
                dc.b    $12
                dc.b    $13
                dc.b    $14
                dc.b    $15
                dc.b    $15
                dc.b    $16
                dc.b    $17
                dc.b    $18
                dc.b    $19
                dc.b    $19
                dc.b    $1A
                dc.b    $1B
                dc.b    $1C
                dc.b    $1C
                dc.b    $1D
                dc.b    $1E
                dc.b    $1E
                dc.b    $1F
                dc.b    $20
                dc.b    $20
                dc.b    $21
                dc.b    $21
                dc.b    $22
                dc.b    $22
                dc.b    $23
                dc.b    $23
                dc.b    $24
                dc.b    $24
                dc.b    $25
                dc.b    $25
                dc.b    $25
                dc.b    $26
                dc.b    $26
                dc.b    $26
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                even

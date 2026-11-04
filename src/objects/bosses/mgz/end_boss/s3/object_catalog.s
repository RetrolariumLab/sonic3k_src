; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_MGZDrillBoss:
                dc.l    Map_MGZEndBoss
                dc.w    make_art_tile(ArtTile_MGZEndBoss,1,0)
                dc.w    $300
                dc.b    $24, $20,   0,  $F
MGZBossS3_RootCoverAttributes:
                dc.w    $380
                dc.b    $10, $10,   1,   0
MGZBossS3_CarrierAttributes:
                dc.w    $300
                dc.b    $18, $18,   2,   0
MGZBossS3_DrillAttributes:
                dc.w    $280
                dc.b    $C,  $C,   9, $8B
MGZBossS3_TrailAndShotAttributes:
                dc.w    $200
                dc.b    4,   4, $16, $98
MGZBossS3_PoseAttachmentAttributes:
                dc.w    $180
                dc.b    $C,  $C,   6,   0
MGZBossS3_PoseHazardAttributes:
                dc.w    make_art_tile(ArtTile_MGZEndBoss,0,0)
                dc.w    $180
                dc.b    $C,  $C, $19, $9A
MGZBossS3_ArrivalDebrisAttributes:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZEndBossDebris,2,1)
                dc.w    $100
                dc.b    $10, $10,   0,   0
MGZBossS3_UnusedVisualAttributes:
                dc.w    $200
                dc.b    $10,   4,   0,   0
MGZEndBossS3_ScaledFlyby_FullAttributes:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_MGZEndBossScaled,1,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
MGZBossS3_MainAttachmentChildren:
                dc.w    4-1
                dc.l    MGZBossS3_InitRootCover
                dc.b    -$14,  $F
                dc.l    MGZBossS3_CarrierDispatchAndDraw
                dc.b    -$1C, $10
                dc.l    MGZBossS3_InitPoseAttachment
                dc.b    8, $18
                dc.l    MGZBossS3_InitPoseAttachment
                dc.b    -$C, $18
MGZBossS3_CarrierDrillChild:
                dc.w    1-1
                dc.l    MGZBossS3_DrillDispatchAndDraw
                dc.b    -$17,   0
MGZBossS3_PoseHazardChild:
                dc.w    1-1
                dc.l    MGZBossS3_InitPoseHazardAndCacheBoss
                dc.b    0, $10
MGZBossS3_RightArrivalDebrisChildren:
                dc.w    $A-1
                dc.l    MGZBossS3_InitArrivalDebris
                dc.b    $18,-$40
MGZBossS3_LeftArrivalDebrisChildren:
                dc.w    $A-1
                dc.l    MGZBossS3_InitArrivalDebris
                dc.b    -$18,-$40
MGZBossS3_DrillPoseCoverChild:
                dc.w    1-1
                dc.l    MGZBossS3_InitTemporaryCoverPose
                dc.b    $C,   0
MGZBossS3_LeftTrailChildren:
                dc.w    8-1
                dc.l    MGZBossS3_InitTrailMotionAndDelay
                dc.b    -$10,   0
MGZBossS3_RightTrailChildren:
                dc.w    8-1
                dc.l    MGZBossS3_InitTrailMotionAndDelay
                dc.b    $10,   0
MGZBossS3_DrillPassEmitterChild:
                dc.w    1-1
                dc.l    MGZBossS3_InitPassEmitter
                dc.b    0,   0
MGZBossS3_EmitterProjectileChild:
                dc.w    1-1
                dc.l    MGZBossS3_InitPassShotAndCacheDrill
                dc.b    0,   0
MGZBossS3_DefeatFragmentChildren:
                dc.w    3-1
                dc.l    MGZBossS3_InitDefeatFragment
                dc.b    $C,-$14
                dc.l    MGZBossS3_InitDefeatFragment
                dc.b    -$10,   8
                dc.l    MGZBossS3_InitDefeatFragment
                dc.b    $14,   8
MGZBossS3_ScaledFlybyChild:
                dc.w    1-1
                dc.l    MGZBossS3_InitScaledFlyby
                dc.b    0,   0
MGZBossS3_UnusedDelayFiveAnim:                          ; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
MGZBossS3_DrillExtendFrames9:
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $B,   7
                dc.b    9,   6
                dc.b    $A,   6
                dc.b    $B,   6
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $F8, MGZBossS3_DrillFastFrames9-MGZBossS3_DrillExtendFrames9
MGZBossS3_DrillFastFrames9:
                dc.b    9,   2
                dc.b    $A,   2
                dc.b    $B,   2
                dc.b    $FC
MGZBossS3_DrillExtendFrames12:
                dc.b    $C,   7
                dc.b    $D,   7
                dc.b    $E,   7
                dc.b    $C,   6
                dc.b    $D,   6
                dc.b    $E,   6
                dc.b    $C,   5
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $C,   4
                dc.b    $D,   4
                dc.b    $E,   4
                dc.b    $C,   3
                dc.b    $D,   3
                dc.b    $E,   3
                dc.b    $F8, MGZBossS3_DrillFastFrames12-MGZBossS3_DrillExtendFrames12
MGZBossS3_DrillFastFrames12:
                dc.b    $C,   2
                dc.b    $D,   2
                dc.b    $E,   2
                dc.b    $FC
MGZBossS3_DrillExtendFrames32:
                dc.b    $20,   7
                dc.b    $21,   7
                dc.b    $22,   7
                dc.b    $20,   6
                dc.b    $21,   6
                dc.b    $22,   6
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22,   5
                dc.b    $20,   4
                dc.b    $21,   4
                dc.b    $22,   4
                dc.b    $20,   3
                dc.b    $21,   3
                dc.b    $22,   3
                dc.b    $F8, MGZBossS3_DrillFastFrames32-MGZBossS3_DrillExtendFrames32
MGZBossS3_DrillFastFrames32:
                dc.b    $20,   2
                dc.b    $21,   2
                dc.b    $22,   2
                dc.b    $FC
MGZEndBossS3_Drill_AngleSixHeldFrameLoop:
                dc.b    $14, $7F
                dc.b    $14, $7F
                dc.b    $FC
MGZBossS3_DrillHoldFrame20:
                dc.b    $13, $7F
                dc.b    $13, $7F
                dc.b    $FC
MGZBossS3_DrillFastFrames38:
                dc.b    $26,   2
                dc.b    $27,   2
                dc.b    $28,   2
                dc.b    $FC
MGZBossS3_DrillExtendFrames15:
                dc.b    $F,   7
                dc.b    $10,   7
                dc.b    $11,   7
                dc.b    $F,   6
                dc.b    $10,   6
                dc.b    $11,   6
                dc.b    $F,   5
                dc.b    $10,   5
                dc.b    $11,   5
                dc.b    $F,   4
                dc.b    $10,   4
                dc.b    $11,   4
                dc.b    $F,   3
                dc.b    $10,   3
                dc.b    $11,   3
                dc.b    $F8, MGZBossS3_DrillFastFrames15-MGZBossS3_DrillExtendFrames15
MGZBossS3_DrillFastFrames15:
                dc.b    $F,   2
                dc.b    $10,   2
                dc.b    $11,   2
                dc.b    $FC
MGZBossS3_DrillRetractFrames9:
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    9,   6
                dc.b    $A,   6
                dc.b    $B,   6
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $B,   7
                dc.b    $F4
MGZBossS3_DrillRetractFrames12:
                dc.b    $C,   3
                dc.b    $D,   3
                dc.b    $E,   3
                dc.b    $C,   4
                dc.b    $D,   4
                dc.b    $E,   4
                dc.b    $C,   5
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $C,   6
                dc.b    $D,   6
                dc.b    $E,   6
                dc.b    $C,   7
                dc.b    $D,   7
                dc.b    $E,   7
                dc.b    $F4
MGZBossS3_DrillRetractFrames32:
                dc.b    $20,   3
                dc.b    $21,   3
                dc.b    $22,   3
                dc.b    $20,   4
                dc.b    $21,   4
                dc.b    $22,   4
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22,   5
                dc.b    $20,   6
                dc.b    $21,   6
                dc.b    $22,   6
                dc.b    $20,   7
                dc.b    $21,   7
                dc.b    $22,   7
                dc.b    $F4
MGZBossS3_DrillRetractFrames15:
                dc.b    $F,   3
                dc.b    $10,   3
                dc.b    $11,   3
                dc.b    $F,   4
                dc.b    $10,   4
                dc.b    $11,   4
                dc.b    $F,   5
                dc.b    $10,   5
                dc.b    $11,   5
                dc.b    $F,   6
                dc.b    $10,   6
                dc.b    $11,   6
                dc.b    $F,   7
                dc.b    $10,   7
                dc.b    $11,   7
                dc.b    $F4
MGZBossS3_LegacyVisualIdleAnim:
                dc.b    5,   0,   1, $FC
                even
Pal_MGZEndBoss:
                binclude "data/Levels/MGZ/Palettes/End Boss.bin"
                even

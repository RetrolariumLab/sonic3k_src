; Owner: objects/ending/sk
; Responsibility: Ending object attributes, child creation records and raw animation streams
; Source provenance and ranges: config/reconstruction/source_layout.json
EndingSSZKnucklesPlane_InitialAttributes:
                dc.l    Map_KnuxEnding
                dc.w    make_art_tile(ArtTile_Ending_SSZKnuckles,0,1)
                dc.w    $200
                dc.b    $20, $20,   5,   0
EndingTornado_Attributes:
                dc.l    Map_SonicPlane
                dc.w    make_art_tile(ArtTile_Ending_Plane,0,1)
                dc.w    $200
                dc.b    $40, $20,   1,   0
EndingSceneProxy_Attributes:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $20, $14,   0,   0
EndingPlanePoseDetail_Attributes:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $C,  $C,   0,   0
EndingPlaneBlinkDetail_PartialAttributes:
                dc.w    $200
                dc.b    4,   8,   4,   0
EndData_PlaneCyclingDetailPartAttrs:
                dc.w    $180
                dc.b    $C,   4, $16,   0
EndingPlaneWideDetail_PartialAttributes:
                dc.w    $200
                dc.b    $40, $10,   9,   0
EndData_EmeraldCarrierAttrs:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $80, $10,   7,   0
EndData_SmallPlaneOutcomeArtAndAttrs:
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,2,0)
                dc.w    $200
                dc.b    4,   4, $11,   0
EndingSKBanner_Attributes:
                dc.l    Map_SKPoseBanner
                dc.w    make_art_tile(ArtTile_Ending_Logo,1,1)
                dc.w    $180
                dc.b    $40, $14,   0,   0
EndingS3KBanner_Attributes:
                dc.l    Map_S3PoseBanner
                dc.w    make_art_tile(ArtTile_Ending_Logo,1,1)
                dc.w    $180
                dc.b    $30, $10,   0,   0
EndingBannerOptionalOverlay_Attributes:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $180
                dc.b    8,   4,   2,   0
EndingBannerFrameZeroOverlay_Attributes:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $180
                dc.b    $20,   4,   0,   0
EndingBannerFrameOneOverlay_Attributes:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $300
                dc.b    $38,   8,   1,   0
EndingS3GraphicsBanner_Attributes:
                dc.l    Map_S3EndingGraphics
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,1,1)
                dc.w    $180
                dc.b    $50, $50,   0,   0
EndingSonicPose_PartialAttributes:
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,0,1)
                dc.w    $100
                dc.b    $20, $20,   1,   0
EndingTailsPose_PartialAttributes:
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,0,1)
                dc.w    $100
                dc.b    $20, $20,  $A,   0
EndingTailsPoseTail_PartialAttributes:
                dc.w    $100
                dc.b    $C,  $C,  $A,   0
EndingKnucklesGroupPose_Attributes:
                dc.l    Map_Knuckles
                dc.w    make_art_tile(ArtTile_Ending_Knuckles,2,1)
                dc.w    $100
                dc.b    $20, $20, $D8,   0
EndingResultEmerald_Attributes:
                dc.l    Map_SSZMasterEmerald
                dc.w    make_art_tile(ArtTile_Ending_MasterEmerald,0,1)
                dc.w    $300
                dc.b    $20, $18,   2,   0
EndingEggmanEyecatch_Attributes:
                dc.l    Map_EndingEyecatchEggman
                dc.w    make_art_tile(ArtTile_Ending_EyecatchEggman,1,1)
                dc.w    $200
                dc.b    $38, $20,   0,   0
EndingEggRoboEyecatch_Attributes:
                dc.l    Map_EndingEyecatchEggRobo
                dc.w    make_art_tile(ArtTile_Ending_EyecatchEggRobo,1,1)
                dc.w    $200
                dc.b    $38, $20,   0,   0
EndData_EggRoboFixedDetailPartAttrs:
                dc.w    $180
                dc.b    $38, $20,   4,   0
EndData_EggRoboSignalDetailPartAttrs:
                dc.w    $180
                dc.b    8,   8,   2,   0
EndingAttachedMasterEmerald_ChildRecord:
                dc.w    1-1
                dc.l    EndingAttachedMasterEmerald_Initialize
                dc.b    4,-$10
EndingTornado_ChildRecord:
                dc.w    1-1
                dc.l    EndingTornado_DispatchStateAndSubSprites
                dc.b    -$20, $2B
EndingPlaneAttachment_ChildRecord:
                dc.w    1-1
                dc.l    EndPlaneChild_InitFromParent
                dc.b    0,-$10
EndData_PlanePoseDetailChildRecord:
                dc.w    2-1
                dc.l    EndScenery_InitPoseDetailAndPriority
EndingPlaneBlinkDetail_ChildRecord:
                dc.w    1-1
                dc.l    EndingPlaneBlinkDetail_Initialize
                dc.b    $1C,   0
EndingPlanePoseOffsetDetail_ChildRecord:
                dc.w    1-1
                dc.l    EndingPlanePoseOffsetDetail_Initialize
                dc.b    -$A,  $C
EndingPlaneWideDetail_ChildRecord:
                dc.w    1-1
                dc.l    EndingPlaneWideDetail_Initialize
                dc.b    -$22,  -2
EndingEmeraldCarrier_ChildRecord:
                dc.w    1-1
                dc.l    EndEmerald_InitCarrierPlaneExtension
                dc.b    -$40,  -4
EndData_ThreeCharacterPoseChildren:
                dc.w    3-1
                dc.l    EndingSonicPose_Initialize
                dc.b    0,   0
                dc.l    EndingTailsPose_InitializeAndCreateTail
                dc.b    0,   0
                dc.l    EndingKnucklesGroupPose_Initialize
                dc.b    0,   0
EndingTailsPoseTail_NormalChildRecord:
                dc.w    1-1
                dc.l    EndingTailsPoseTail_Initialize
                dc.b    -$10,   8
EndData_SmallPlaneOutcomeChild:
                dc.w    1-1
                dc.l    EndingSmallPlaneOutcomeDetail_Initialize
                dc.b    -$10,   5
EndingSwayingAnimals_SimpleChildRecord:
                dc.w    5-1
                dc.l    EndingSwayingAnimal_Initialize
EndingJumpingAnimals_SimpleChildRecord:
                dc.w    2-1
                dc.l    EndingJumpingAnimal_InitializeDelay
EndingEggRoboEyecatch_DetailChildRecords:
                dc.w    2-1
                dc.l    EndingEggRoboFixedDetail_Initialize
                dc.b    0,-$10
                dc.l    EndVillain_InitSignalDetailDelay
                dc.b    0,-$14
EndData_SmallPlaneCyclingChild:
                dc.w    1-1
                dc.l    EndingSmallPlaneCyclingDetail_Initialize
                dc.b    -6,   7
EndData_SSZPlaneMissingOutcomeAnim:
                dc.b    5,  $B,   6,   5,   7,  $B,   6,  $B, $FC
EndData_SSZPlaneEmeraldHoldAnim:
                dc.b    4, $7F,   4, $7F, $FC
EndData_SSZPlaneEmeraldApexAnim:
                dc.b    4,   0,   4, $3F,   1,   5,   2,   5,   3, $3F,   4, $7F,   4, $7F, $FC
EndingReturnPlane_RawFrameDelayScript:
                dc.b    1,  $F,   2,  $F,   3, $7F,   3, $7F, $FC
EndData_SonicPoseSignalWaitAnim:
                dc.b    $F,   1,   2, $FC
EndingSonicPose_FinalRawAnimation:
                dc.b    7,   1,   1,   3,   4
                dc.b    $F8, .jump-EndingSonicPose_FinalRawAnimation

                .jump:
                dc.b    $7F,   4,   4, $FC
EndingTailsPose_RawAnimation:
                dc.b    $F,  $A,  $B, $FC
EndingTailsPoseTail_RawAnimation:
                dc.b    $B,   5,   6,   7,   8,   9, $FC
EndingIslandLiftWorldEffect_RawAnimation:
                dc.b    7,   0,   1,   2,   3, $FC
EndData_LiftProjectedDetailAnim:
                dc.b    7,   4,   5,   6, $FC
EndingIslandLiftGroup43_RawAnimation:
                dc.b    7,   7,   8,   9, $1A, $1A, $1A, $FC
EndingIslandLiftGroup44_RawAnimation:
                dc.b    7,  $A,  $B,  $C,  $D, $FC
EndingIslandLiftGroup45_RawAnimation:
                dc.b    $B,  $E,  $F, $10, $11, $FC
EndingIslandLiftGroup46_RawAnimation:
                dc.b    $B, $12, $13, $14, $15, $FC
EndingIslandLiftGroup47_RawAnimation:
                dc.b    $B, $16, $17, $18, $19, $FC
EndingSwayingAnimal_RawAnimation:
                dc.b    5,   2,   3,   4,   3, $FC
EndData_EggRoboSignalDetailAnim:
                dc.b    2,   0,   2,   1,   6,  $F,   2,   1,   6,   7,   2,   1,   6,   3,   2,   1
                dc.b    6,   1,   2,   1,   6,   1,   2, $13,   3, $3F, $F4
EndingEggRoboEyecatch_RawAnimation:
                dc.b    $E,   0,   1, $FC
EndingEggmanEyecatch_RawAnimation:
                dc.b    $B,   0,   1, $FC
EndingKnucklesSoloPose_RawAnimation:
                dc.b    5,   0,   0,   1,   2
                dc.b    $F8, .jump-EndingKnucklesSoloPose_RawAnimation

                .jump:
                dc.b    $7F,   2,   2, $FC
                even

; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene tracking slots, object attributes and child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjSlot_CutsceneKnux:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_CutsceneKnux
                dc.w    $180
                dc.b    $1C, $18, $16,   0
ObjSlot_CutsceneKnux_MHZ2:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_MHZKnuxPullSwitch
                dc.w    $180
                dc.b    $1C, $18,   3,   0
ObjSlot_KnuxIntroLay:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_Player_2,0,0)
                dc.w    $2E,     0
                dc.l    Map_KnuxIntroLay
                dc.w    $180
                dc.b    $1C, $18,   0,   0
ObjSlot_HPZKnucklesGrab:                                ; unused
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_HPZKnucklesGrab
                dc.w    $180
                dc.b    $1C, $18,   2,   0
ObjDat_CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_GrayButton,0,1)
                dc.w    $100
                dc.b    $10,   8,   0,   0
SKLbzCutscene_BombAttributes:
                dc.l    Map_LBZKnuxBomb
                dc.w    make_art_tile(ArtTile_LBZKnuxBomb,1,1)
                dc.w    $80
                dc.b    8,   8,   0,   0
SKSceneData_LBZ2PillarAttrs:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat_LBZKnuxPillar:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $80,   1,   0
SKAizCutscene_CorkFloorAttributes:
                dc.l    Map_AIZCorkFloor
                dc.w    make_art_tile($001,2,0)
                dc.w    $180
                dc.b    $10, $18,   0,   0
SKSceneData_MHZ1PeeringAttrs:
                dc.l    Map_MHZKnuxPeer
                dc.w    make_art_tile(ArtTile_MHZKnuxPeer,1,0)
                dc.w    $180
                dc.b    $10, $10,   4,   0
ObjDat_MHZ1CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_MHZ1CutsceneButton,0,0)
                dc.w    $100
                dc.b    $80, $80,   0,   0
SKMhzActTwoCutscene_SwitchAttributes:
                dc.l    Map_MHZKnuxSwitch
                dc.w    make_art_tile(ArtTile_MHZKnuxSwitch,1,1)
                dc.w    $300
                dc.b    $10, $10,   0,   0
SKMhzActOneCutscene_DoorAttributes:
                dc.l    Map_MHZKnuxDoor
                dc.w    make_art_tile(ArtTile_MHZMisc+$82,3,0)
                dc.w    $80
                dc.b    $10, $20,   0,   0
SKMhzSceneBossLeaf_Attributes:
                dc.l    Map_MHZKnuxLeaves
                dc.w    make_art_tile(ArtTile_MHZMisc+$21,3,1)
                dc.w    0
                dc.b    4,   4,   0,   0
SKLrzCutscene_BoulderAttributes:
                dc.l    Map_LRZKnuxBoulder
                dc.w    make_art_tile(ArtTile_LRZKnuxBoulder,2,0)
                dc.w    $200
                dc.b    $20, $20,   0,   0
SKOpeningCutscene_BombAttributes:
                dc.l    Map_KnuxIntroBomb
                dc.w    make_art_tile(ArtTile_KnuxIntroBomb,1,0)
                dc.w    $180
                dc.b    $C, $10,   0,   0
SKOpeningBomb_FlamePartialAttributes:
                dc.w    $100
                dc.b    8,   8,   1,   0
SKOpeningBomb_SmokePartialAttributes:
                dc.w    $100
                dc.b    8,   8,   5,   0
ObjDat_SSZCutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_SSZCutsceneButton,0,0)
                dc.w    $180
                dc.b    $10,   8,   1,   0
SKSszCutscene_SmallDeathEggAttributes:
                dc.l    Map_SSZDeathEggSmall
                dc.w    make_art_tile(ArtTile_SSZDeathEggSmall,3,0)
                dc.w    $380
                dc.b    $3C, $30,   0,   0
SKSceneData_SSZDeathEggCloudSlotAttrs:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_SSZDeathEggCloud,3,0)
                dc.w    $10,     2
                dc.l    Map_SSZDeathEggCloud
                dc.w    $280
                dc.b    $40, $10,   0,   0
SKSszSmallDeathEgg_SpriteMaskAttributes:
                dc.l    Map_SpriteMask
                dc.w    make_art_tile($000,0,0)
                dc.w    $200
                dc.b    $40, $30,  $C,   0
SKSceneData_SSZDeathEggPiecePartialAttrs:
                dc.w    $300
                dc.b    4, $1C,   1,   0
SKSceneData_SSZDeathEggParticlePartAttrs:
                dc.w    make_art_tile(ArtTile_SSZDeathEggSmall,0,0)
                dc.w    $280
                dc.b    8,   8,   4,   0
SKHpzKnuckles_FollowingDustAttributes:
                dc.l    Map_DashDust
                dc.w    make_art_tile(ArtTile_HPZKnuxBossDust,0,0)
                dc.w    $80
                dc.b    $10, $10,  $A,   0
SKHpzSszSceneShip_CoreAttributes:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    0
                dc.b    $1C, $20,  $A,   0
SKHpzSszCrane_LiftingHeadAttributes:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_HPZSSZBossCrane,0,1)
                dc.w    $180
                dc.b    $14, $14,   0,   0
SKSceneData_CraneFrameFollowerPartAttrs:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
SKSceneData_CraneOffsetFollowerPartAttrs:
                dc.w    $180
                dc.b    4, $80,   4,   0
SKHpzEmeraldLift_InitialSparkAttributes:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    0
                dc.b    $C,  $C, $12,   0
SKSceneData_HPZEmeraldFragmentAttrs:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,0)
                dc.w    $180
                dc.b    4,   8, $18,   0
SKHpzCrane_ChainBranchRootAttributes:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_HPZSSZBossCrane,0,0)
                dc.w    0
                dc.b    8,   8, $12,   0
SKHpzCrane_ChainSegmentPartialAttributes:
                dc.w    0
                dc.b    8,   8, $12,   0
SKHpzEscape_PlatformAttributes:
                dc.l    Map_LRZ3Platform
                dc.w    make_art_tile($001,2,1)
                dc.w    0
                dc.b    $10, $20,   6,   0
SKSceneData_HPZPlatformFragmentPartAttrs:
                dc.w    0
                dc.b    4,   4,   7,   0
SKHpzKnuckles_DizzyStarsAttributes:
                dc.l    Map_HPZKnuxDizzyStars
                dc.w    make_art_tile(ArtTile_HPZKnuxDizzy,1,0)
                dc.w    $180
                dc.b    $C,   4,   1,   0
SKSceneData_AIZ2SolidChildren:
                dc.w    1-1
                dc.l    SKAIZScene_ResolveAct2SolidChild
SKSceneData_CNZ2TallSolidChildren:
                dc.w    1-1
                dc.l    SKCNZScene_ResolveInvisibleSolidChild
                dc.b    -$20,-$6C
SKSceneData_CNZ2CameraRestoreChildren:
                dc.w    3-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
SKSceneData_LBZ1RangeLockChildren:
                dc.w    1-1
                dc.l    SKLBZScene_CheckPlayersAndSignalP1
                dc.b    -$40,   0
SKLbzActOneCutscene_BombSpawnList:
                dc.w    1-1
                dc.l    SKLBZScene_InitBombAndPlaySound
                dc.b    -8,-$10
SKSceneData_LBZ1RisingExplosionChildren:
                dc.w    4-1
                dc.l    SKLBZScene_InitExplosionColumn
SKSceneData_LBZ2PillarChildren:
                dc.w    4-1
                dc.l    SKLBZScene_InitPillarMotionAndRestX
                dc.b    2, $24
SKSceneData_AIZ1CorkFloorChildren:
                dc.w    1-1
                dc.l    SKAIZScene_InitCorkAndCheckParent
                dc.b    0, $18
SKHczActTwoCutscene_ButtonChildSpawnList:
                dc.w    1-1
                dc.l    Obj_CutsceneButton
                dc.b    0,  $C
SKSceneData_MHZ1KnuxDispatcherChildren:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
SKSceneData_MHZ1PeeringChildren:
                dc.w    1-1
                dc.l    MHZ1Scene_InitPeerAndStartEightStepRun
SKMhzActOneCutscene_DoorSpawnList:
                dc.w    1-1
                dc.l    MHZ1Scene_InitDoorAndLinkButton
SKMhzActTwoCutscene_SwitchChildSpawnList:
                dc.w    1-1
                dc.l    MHZ2Scene_InitLinkedOrStandaloneSwitch
                dc.b    -8,   0
SKSceneData_SSZDeathEggCompositeChildren:
                dc.w    7-1
                dc.l    SSZScene_InitBackgroundSpriteMask
                dc.b    0,   0
                dc.l    SSZScene_DispatchMoveAndDrawCloud
                dc.b    0,-$33
                dc.l    SSZScene_InitTimedChildEffect
                dc.b    -$20, $1D
                dc.l    SSZScene_InitTimedChildEffect
                dc.b    -$10, $1D
                dc.l    SSZScene_InitTimedChildEffect
                dc.b    8, $1D
                dc.l    SSZScene_InitTimedChildEffect
                dc.b    $10, $1D
                dc.l    SSZScene_InitTimedChildEffect
                dc.b    $28, $1D
SKSceneData_SSZDeathEggParticleChildren:
                dc.w    1-1
                dc.l    SSZScene_InitSmallEggParticle
SKSszCutscene_SmallDeathEggRootSpawnList:
                dc.w    1-1
                dc.l    SSZScene_InitSmallDeathEggAndPalette
SKHpzEncounter_SpinPhaseDustSpawnList:
                dc.w    1-1
                dc.l    HPZKnux_InitDustAndCheckDashGate
SKSceneData_HPZCameraExplosionChildren:
                dc.w    $10-1
                dc.l    HPZEffect_InitDelayedExplosion
SKHpzShip_LiftingCraneHeadSpawnList:
                dc.w    1-1
                dc.l    HPZShipCrane_InitOverlayAndBeam
                dc.b    0, $23
SKSceneData_CraneFollowerChildren:
                dc.w    2-1
                dc.l    HPZShipCrane_InitCraneOverlay
                dc.b    0,   0
                dc.l    HPZShipCrane_InitCraneBeam
                dc.b    0,-$30
SKSceneData_HPZEmeraldSparkChildren:
                dc.w    $F-1
                dc.l    HPZEffect_InitSparkAndTickDelay
SKHpzShip_TwoCraneBranchRootsSpawnList:
                dc.w    2-1
                dc.l    HPZEffect_InitCraneRootAndSelectGroup
                dc.b    8,  -4
SKHpzCrane_NegativePhaseChainSpawnList:
                dc.w    $A-1
                dc.l    HPZCrane_InitNegativePhase
SKHpzCrane_PositivePhaseChainSpawnList:
                dc.w    $A-1
                dc.l    HPZCrane_InitSecondTargetBank
SKSceneData_HPZEmeraldFragmentChildren:
                dc.w    5-1
                dc.l    HPZEffect_InitEmeraldPiece
SKHpzEscape_PlatformSpawnList:
                dc.w    1-1
                dc.l    HPZScenePlatform_InitFixedPosition
SKHpzKnuckles_DizzyStarsSpawnList:
                dc.w    1-1
                dc.l    HPZScenePlatform_InitDizzyStarsLifetime
SKSceneData_HPZPlatformFragmentChildren:
                dc.w    $20-1
                dc.l    HPZScenePlatform_InitFragmentAndScatter
SKSceneData_OpeningBombExplosionChildren:
                dc.w    $A-1
                dc.l    KnuxOpening_InitDelayedExplosion
SKOpeningCutscene_EightAnimalSpawnList:
                dc.w    8-1
                dc.l    KnuxOpening_SelectAnimalPosAndBounds
SKOpeningBomb_FlameChildSpawnList:
                dc.w    1-1
                dc.l    KnuxOpening_InitAttachedBombFlame
                dc.b    0,-$14
SKOpeningBomb_EmittedSmokeSpawnList:
                dc.w    1-1
                dc.l    KnuxOpening_InitSmokeDrift

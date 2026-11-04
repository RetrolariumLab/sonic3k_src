; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene DPLC pointer records and raw animation or script streams
; Source provenance and ranges: config/reconstruction/source_layout.json
DPLCPtr_CutsceneKnux:
                dc.l    ArtUnc_CutsceneKnux
                dc.l    DPLC_CutsceneKnux
DPLCPtr_MHZKnuxPress:
                dc.l    ArtUnc_MHZKnuxPress
                dc.l    DPLC_MHZKnuxPress
DPLCPtr_KnuxIntroLay:
                dc.l    ArtUnc_KnuxIntroLay
                dc.l    DPLC_KnuxIntroLay
DPLCPtr_HPZKnucklesGrab:
                dc.l    ArtUnc_HPZKnucklesGrab
                dc.l    DPLC_HPZKnucklesGrab
DPLCPtr_SSZKnucklesTired:
                dc.l    ArtUnc_SSZKnucklesTired
                dc.l    DPLC_SSZKnucklesTired
DPLCPtr_SSZDeathEggCloud:
                dc.l    ArtUnc_SSZDeathEggCloud
                dc.l    DPLC_SSZDeathEggCloud
SKSceneAnim_LBZ2ShakeLoop:
                dc.b    7,   1,   2,   3, $FC
SKSceneAnim_KnuxTravelLoop:
                dc.b    4,  $A,  $B,  $C,  $D,  $E,  $F, $10, $11, $FC
SKSceneAnim_KnuxFastTravelLoop:
                dc.b    1, $12, $13, $14, $15, $FC
SKKnucklesCutscene_LeapPhaseBodyLoop:
                dc.b    1,   8,   4,   8,   5,   8,   6,   8,   7, $FC
SKSceneAnim_KnuxWaitWithTailLoop:
                dc.b    7, $1C, $1C, $1D
                dc.b    $F8, SKSceneAnim_KnuxWaitTailFrames1E1F-SKSceneAnim_KnuxWaitWithTailLoop
SKSceneAnim_KnuxWaitTailFrames1E1F:
                dc.b    7, $1E, $1F, $FC
SKSceneAnim_LBZ1PreBombSequence:
                dc.b    $16,   7
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $19, $13
                dc.b    $1A,   7
                dc.b    $1B,   0
                dc.b    $F4
SKSceneAnim_LBZ2PreTurnSequence:
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22, $14
                dc.b    $23,   3
                dc.b    $24,  $F
                dc.b    $21,   5
                dc.b    $20,   5
                dc.b    $F4
SKSceneAnim_MHZ1PeeringSequence:
                dc.b    0,   4
                dc.b    0,   9
                dc.b    1, $1D
                dc.b    0,   4
                dc.b    2,   4
                dc.b    3, $1D
                dc.b    2,   4
                dc.b    0,   4
                dc.b    1, $1D
                dc.b    0,   4
                dc.b    $F4
SKSceneAnim_MHZ2BlowerSequence:
                dc.b    3,   7
                dc.b    3, $1F
                dc.b    0,   7
                dc.b    1, $1F
                dc.b    2,   7
                dc.b    1, $7F
                dc.b    2,   7
                dc.b    1, $1F
                dc.b    2,   7
                dc.b    1,  $F
                dc.b    2,   7
                dc.b    1,  $B
                dc.b    2,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    $F4
SKSceneAnim_SSZTiredLeadIn:
                dc.b    0,   7
                dc.b    0,   7
                dc.b    $F8, SKSszHpzKnuckles_TiredBodyTimedLoop-SKSceneAnim_SSZTiredLeadIn
SKSszHpzKnuckles_TiredBodyTimedLoop:
                dc.b    1,  $B
                dc.b    2,   5
                dc.b    3,  $B
                dc.b    2,  $B
                dc.b    1,  $B
                dc.b    $FC
SKSceneAnim_SSZCrouchingPlayerReaction:
                dc.b    4,   7
                dc.b    4,   7
                dc.b    5,   7
                dc.b    6, $1F
                dc.b    $F8, .jump-SKSceneAnim_SSZCrouchingPlayerReaction

                .jump:
                dc.b    5,  $F
                dc.b    6, $1F
                dc.b    $FC
SKSceneAnim_SSZDeathEggCloud:
                dc.b    0,   5
                dc.b    0,   5
                dc.b    1,   7
                dc.b    2,   9
                dc.b    3,   9
                dc.b    4,  $B
                dc.b    5,  $C
                dc.b    6,  $D
                dc.b    7,  $E
                dc.b    8,  $F
                dc.b    9, $13
                dc.b    $A, $1D
                dc.b    $B, $27
                dc.b    $C, $63
                dc.b    $F8, .jump-SKSceneAnim_SSZDeathEggCloud

                .jump:
                dc.b    $B, $3B
                dc.b    $A, $63
                dc.b    $B, $3B
                dc.b    $C, $63
                dc.b    $FC
SKSceneAnim_SSZDeathEggBackgroundPiece:
                dc.b    6,   0
                dc.b    6, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    2,   9
                dc.b    3,   9
                dc.b    $F4
SKSceneAnim_HPZEncounterOpening:
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DE,  $B
                dc.b    $FF, $FC
SKHpzKnuckles_FrontContactBodyFrameLoop:
                dc.b    4, $D8, $D9, $DA, $DB, $FF, $FC
SKSceneAnim_HPZFrontCounterRecoil:
                dc.b    $DA,   5, $9B,   5, $9C,  $F, $FF, $F4
SKHpzKnuckles_NonfinalHitBodyFrameLoop:
                dc.b    1,   0, $8D, $FF, $FC
SKSceneAnim_KnuxJumpAndFastTravel:
                dc.b    1, $9A, $96, $9A, $97, $9A, $98, $9A, $99, $FF, $FC
SKHpzKnuckles_PreJumpBodyFrameSequence:
                dc.b    3, $DA, $DA, $9B, $9C, $9B, $FF, $F4
SKHpzKnuckles_DescendingBodyTimedLoop:
                dc.b    $C0,   5
                dc.b    $CA,   5
                dc.b    $CB, $7F
                dc.b    $CB, $7F
                dc.b    $CB, $7F
                dc.b    $FF, $FC
SKHpzKnuckles_LandingBodyFrameSequence:
                dc.b    5, $CC, $9B, $9C, $9B, $FF, $F4
SKSceneAnim_HPZShipDepartureLanding:
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $7F
                dc.b    4, $1F
                dc.b    $FF, $F4
SKSceneAnim_HPZTravelWindupWithTailLoop:
                dc.b    3, $DA, $DA, $9B, $9C, $FF
                dc.b    $F8, .jump-SKSceneAnim_HPZTravelWindupWithTailLoop

                .jump:
                dc.b    0, $86, $87, $86, $88, $86, $89, $86, $8A, $86, $8B, $FF, $FC
SKSceneAnim_HPZGrabFloorRecovery:
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $3F
                dc.b    $FF, $F4
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $7F
                dc.b    6,   3
                dc.b    $FF, $F4
SKSceneAnim_KnuxTravelLoopDelay4:
                dc.b    4,   7,   8,   1,   2,   3,   4,   5,   6, $FF, $FC
SKKnucklesCutscene_SharedTravelBodyLoop:
                dc.b    3,   7,   8,   1,   2,   3,   4,   5,   6, $FF, $FC
SKHpzKnuckles_FollowingDustFrameLoop:
                dc.b    1,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
SKSceneAnim_HPZEmeraldSparkInitial:
                dc.b    1, $12, $12, $13, $14, $15, $F4
SKSceneAnim_HPZEmeraldSparkRising:
                dc.b    3, $16, $16, $17, $F4
SKSceneAnim_HPZSecondRecoveryGrab:
                dc.b    6, $3F
                dc.b    6, $3F
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6, $5F
                dc.b    $FF, $F4
SKHpzKnuckles_DizzyStarsFrameLoop:
                dc.b    5,   1,   2,   3,   4, $FC
SKSceneAnim_HPZLowerGrabFrames9And10:
                dc.b    7,   9,  $A, $FF, $FC
SKSceneAnim_HPZUpperGrabFrames11And12:
                dc.b    5,  $B,  $C, $FF, $FC
SKSceneAnim_HPZPostGrabCollapse:
                dc.b    $56,   7
                dc.b    $56, $1F
                dc.b    $DE,   0
                dc.b    $DE,  $F
                dc.b    $56, $3F
                dc.b    $FF, $F4
SKSceneAnim_LRZSignalReaction:
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $DC,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DE,   0
                dc.b    $FF, $F4
SKSceneAnim_LRZPostSignalReaction:
                dc.b    $DE,   7
                dc.b    $DE,   7
                dc.b    $56,   0
                dc.b    $FF, $F4
SKSceneAnim_HPZGrabFrames14To18:
                dc.b    $E, $59
                dc.b    $E, $77
                dc.b    $F, $07
                dc.b    $10, $1D
                dc.b    $11, $07
                dc.b    $12, $07
                dc.b    $11, $07
                dc.b    $12, $07
                dc.b    $F, $07
                dc.b    $FF, $F4
SKSceneAnim_OpeningLyingFrames0And1:
                dc.b    $13,   0,   1, $FC
SKSceneAnim_OpeningLyingFrames423:
                dc.b    4, $6F
                dc.b    4, $6F
                dc.b    2,   7
                dc.b    3, $7F
                dc.b    $FC
SKSceneAnim_OpeningGrabFrames3To10:
                dc.b    3,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $5F
                dc.b    6, $1F
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,  $F
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $F4
SKOpeningBomb_FlameFrameLoop:
                dc.b    3,   1,   2,   3,   4, $FC
SKOpeningBomb_EmittedSmokeFrameSequence:
                dc.b    5,   5,   5,   6,   7,   8, $F4
                even

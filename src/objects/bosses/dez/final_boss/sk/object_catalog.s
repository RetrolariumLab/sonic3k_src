; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss object attributes, child construction, animation and palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
DEZFinalIntroSlidingPiece_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    $20, $20,   5,   0
DEZFinalArmSegment_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    $10, $60,   0,   0
DEZFinalScriptedAttack_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,1)
                dc.w    $300
                dc.b    $10, $10,   6, $8B
DEZFinalBeamGate_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile($001,1,0)
                dc.w    $180
                dc.b    $40, $40, $1E,   0
DEZFinalBeamCharge_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $180
                dc.b    $10, $24, $1A,   0
DEZFinalChargeParticle_PartialAttributes:
                dc.w    $200
                dc.b    4,   4, $1B,   0
DEZFinalHead_Attributes:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    4, $20, $18,   0
DEZFinalMasterEmerald_Attributes:
                dc.l    Map_BossMasterEmerald
                dc.w    make_art_tile(ArtTile_BossMasterEmerald,2,0)
                dc.w    $300
                dc.b    $20, $18,   1,   0
DEZFinalIntroRobotnikRun_Attributes:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_DEZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
DEZFinalEscapeShip_Attributes:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $200
                dc.b    $20, $20,   5,   0
DEZFinalEscapeCrane_Attributes:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_DEZBossCrane,0,0)
                dc.w    $200
                dc.b    $14, $14,   0,   0
DEZFinalEscapeFallingDebris_Attributes:
                dc.l    Map_DEZFinalBossDebris
                dc.w    make_art_tile(ArtTile_DEZFinalBossDebris,2,1)
                dc.w    $300
                dc.b    $18, $10,   0,   0
DEZFinalArmControllers_SimpleChildRecord:
                dc.w    2-1
                dc.l    DEZFinal_ArmDispatchOrSignalDefeat
DEZFinalArmSegments_NormalChildRecords:
                dc.w    3-1
                dc.l    DEZFinal_InitArmSegmentHealth
                dc.b    0,-$10
                dc.l    DEZFinal_InitArmSegmentHealth
                dc.b    -$20,-$10
                dc.l    DEZFinal_InitArmSegmentHealth
                dc.b    $20,-$10
DEZFinalChargeParticle_SimpleChildRecord:
                dc.w    1-1
                dc.l    DEZFinal_InitRandomChargeParticle
DEZFinal_EscapeCraneAndEmeraldChildren:
                dc.w    2-1
                dc.l    DEZEscapeCrane_DispatchAndDraw
                dc.b    0, $23
                dc.l    DEZFinal_InitMasterEmerald
                dc.b    0, $3B
DEZFinalArm_ImpactExtensionRawAnimation:
                dc.b    0,   1
                dc.b    1,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    4,   0
                dc.b    $F4
DEZFinalArm_ImpactRetractionRawAnimation:
                dc.b    4,   3
                dc.b    3,   3
                dc.b    2,   3
                dc.b    1,   3
                dc.b    0,  $F
                dc.b    $F4
DEZFinal_IntroRobotnikRunAnim:
                dc.b    2,   0,   1,   2,   1, $FC
DEZFinal_BeamChargeFlickerAnim:
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   4
                dc.b    $1A,   0
                dc.b    $1F,   4
                dc.b    $1A,   0
                dc.b    $1F,   3
                dc.b    $1A,   0
                dc.b    $1F,   3
                dc.b    $1A,   0
                dc.b    $1F,   2
                dc.b    $1A,   0
                dc.b    $1F,   2
                dc.b    $1A,   0
                dc.b    $1F,   1
                dc.b    $1A,   0
                dc.b    $1F,   1
                dc.b    $F4, $1A
                dc.b    0, $1F
                dc.b    0, $1A
                dc.b    0, $1F
                dc.b    0, $F4
DEZFinal_ChargeParticleDeleteAnim:
                dc.b    $1B,   7
                dc.b    $1B,   7
                dc.b    $1C,   5
                dc.b    $1D,   3
                dc.b    $F4
DEZFinal_ActiveBeamAnim:
                dc.b    0,   0
                dc.b    6,   0
                dc.b    $E,   1
                dc.b    $16,   2
                dc.b    $1E,   3
                dc.b    $16,   1
                dc.b    $E,   2
                dc.b    6,   3
                dc.b    0,   0
                dc.b    $F4
                even

DEZMasterEmerald_TwoSlotPalettePrograms:    palscriptptr .hdr1, .data1
                palscriptptr .hdr2, .data2
                .hdr1:  palscripthdr Normal_palette_line_3+$12, 1, 0
                .data1: palscriptdata 15,$660
                palscriptdata 18,$680
                palscriptdata 7, $880
                palscriptdata 7, $6A2
                palscriptdata 5, $AC0
                palscriptdata 5, $CE8
                palscriptdata 5, $AC0
                palscriptdata 7, $6A2
                palscriptdata 7, $880
                palscriptdata 18,$680
                palscriptrept
                .hdr2:  palscripthdr Normal_palette_line_3+$16, 1, 0
                .data2: palscriptdata 15,$6A0
                palscriptdata 9, $8C0
                palscriptdata 9, $AC0
                palscriptdata 7, $CE0
                palscriptdata 7, $CE6
                palscriptdata 5, $CE8
                palscriptdata 5, $EEC
                palscriptdata 5, $CE8
                palscriptdata 7, $CE6
                palscriptdata 7, $CE0
                palscriptdata 9, $AC0
                palscriptdata 9, $8C0
                palscriptrept

DDZMasterEmerald_TwoSlotPalettePrograms:    palscriptptr .hdr1, .data1
                palscriptptr .hdr2, .data2
                .hdr1:  palscripthdr Normal_palette_line_4+$12, 1, 0
                .data1: palscriptdata 15,$660
                palscriptdata 18,$680
                palscriptdata 7, $880
                palscriptdata 7, $6A2
                palscriptdata 5, $AC0
                palscriptdata 5, $CE8
                palscriptdata 5, $AC0
                palscriptdata 7, $6A2
                palscriptdata 7, $880
                palscriptdata 18,$680
                palscriptrept
                .hdr2:  palscripthdr Normal_palette_line_4+$16, 1, 0
                .data2: palscriptdata 15,$6A0
                palscriptdata 9, $8C0
                palscriptdata 9, $AC0
                palscriptdata 7, $CE0
                palscriptdata 7, $CE6
                palscriptdata 5, $CE8
                palscriptdata 5, $EEC
                palscriptdata 5, $CE8
                palscriptdata 7, $CE6
                palscriptdata 7, $CE0
                palscriptdata 9, $AC0
                palscriptdata 9, $8C0
                palscriptrept

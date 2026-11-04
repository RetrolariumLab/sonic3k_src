; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Mecha Sonic tracking slots, object attributes, children, animation, pattern records, mappings and palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjSlot_MechaSonic:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_MechaSonic,1,1)
                dc.w    $28,     0
                dc.l    Map_MechaSonic
                dc.w    $280
                dc.b    $20, $20,   0, $23
SSZMechaCollisionProxy_PartialAttributes:
                dc.w    $80
                dc.b    $10, $10,   0,   0
SSZMechaRollingTrail_Attributes:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,0,1)
                dc.w    $200
                dc.b    $C,   4,   0,   0
ObjDat_MechaSonic_Sparks:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    $14, $10,   4,   0
SSZMechaSignalEffect_Attributes:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    4,   4, $11,   0
SSZMechaActiveEffect_Attributes:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $280
                dc.b    $18, $18,   8,   0
SSZMechaActiveParticle_PartialAttributes:
                dc.w    $280
                dc.b    4,   4,   8,   0
SSZMechaLaser_Attributes:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    $18, $18,  $A, $86
SSZSuperMechaRadialProjectile_Attributes:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $280
                dc.b    8,   8, $15, $87
SSZMechaMasterEmerald_Attributes:
                dc.l    Map_SSZMasterEmerald
                dc.w    make_art_tile(ArtTile_Ending_MasterEmerald,0,1)
                dc.w    $300
                dc.b    $20, $18,   0,   0
SSZCraneShipFragment_Attributes:
                dc.l    Map_RoboshipPieces
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    0
                dc.b    $1C, $20,   0,   0
SSZMechaDefeatFragment_Attributes:
                dc.l    Map_MechaSonicPieces
                dc.w    make_art_tile(ArtTile_MechaSonic,1,1)
                dc.w    0
                dc.b    4,   8,   0,   0
SSZMechaCollisionProxy_SimpleChildRecord:
                dc.w    1-1
                dc.l    SSZMechaCollisionProxy_Initialize
SSZMecha_RollTrailFirstPairChildren:
                dc.w    1
                dc.l    loc_7C902
SSZMecha_RollTrailSingleChild:
                dc.w    1-1
                dc.l    loc_7C902
SSZMecha_RollTrailSecondPairChildren:
                dc.w    2-1
                dc.l    loc_7C8FE
SSZMechaSparks_SimpleChildRecord:
                dc.w    1-1
                dc.l    Obj_MechaSonic_Sparks
SSZMechaSignalEffect_NormalChildRecord:
                dc.w    1-1
                dc.l    loc_7C886
                dc.b    -4,  $C
SSZMechaActiveEffect_NormalChildRecord:
                dc.w    1-1
                dc.l    loc_7C78E
                dc.b    $14,  -4
SSZMechaActiveParticle_SimpleChildRecord:
                dc.w    1-1
                dc.l    loc_7C7D4
SSZMecha_RadialBurstChild:
                dc.w    8-1
                dc.l    loc_7C726
SSZMechaLaser_NormalChildRecord:
                dc.w    1-1
                dc.l    loc_7C744
                dc.b    -7,  -8
                dc.w    1-1
                dc.l    loc_7C818
SSZCraneGrabber_NormalChildRecord:
                dc.w    1-1
                dc.l    loc_7CCFE
                dc.b    0, $23
SSZCraneShipFragments_SimpleChildRecord:
                dc.w    4-1
                dc.l    loc_7CE6C
SSZMecha_DefeatFragmentChild:
                dc.w    $10-1
                dc.l    loc_7CE90
SSZMecha_FinalExplosionEmitterChild:
                dc.w    3-1
                dc.l    loc_7CF14
DPLCPtr_MechaSonic:
                dc.l    ArtUnc_MechaSonic
                dc.l    DPLC_MechaSonic
SSZMecha_LandHoldFrame8Anim:
                dc.b    3,   0
                dc.b    4,   1
                dc.b    5,   2
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   5
                dc.b    $F8, .jump-SSZMecha_LandHoldFrame8Anim

                .jump:
                dc.b    8, $7F
                dc.b    $FC
SSZMecha_LandHoldFrame12Anim:
                dc.b    3,   0
                dc.b    4,   1
                dc.b    5,   2
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   4
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    $C,   4
                dc.b    $F8, .jump-SSZMecha_LandHoldFrame12Anim

                .jump:
                dc.b    $C, $7F
                dc.b    $FC
SSZMecha_PaletteReturnFallAnim:
                dc.b    $13,   5
                dc.b    $13,   5
                dc.b    8, $7F
                dc.b    $F8, SSZMecha_LandHoldFrame8Anim.jump-SSZMecha_PaletteReturnFallAnim
SSZMecha_NormalLandingAnim:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    $F4
SSZMecha_RollingEntryAnim:
                dc.b    3,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, SSZMecha_RollingFramesRawAnimation-SSZMecha_RollingEntryAnim
SSZMecha_RollingFramesRawAnimation:
                dc.b    3,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    $FC
SSZMecha_TargetedDiveAnim:
                dc.b    8,   0
                dc.b    7,   3
                dc.b    6,   3
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, SSZMecha_RollingFramesRawAnimation-SSZMecha_TargetedDiveAnim
SSZMecha_DiveReturnAnim:
                dc.b    6,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    8, $1F
                dc.b    $F4
SSZMecha_JumpAttackPrepAnim:
                dc.b    0,   0
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   0
                dc.b    $F4
SSZMecha_JumpingAttackFlightRawAnimation:
                dc.b    1,   0
                dc.b    1,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, SSZMecha_RollingFramesRawAnimation-SSZMecha_JumpingAttackFlightRawAnimation
SSZMecha_DiagonalDiveBrakeAnim:
                dc.b    $12,   0
                dc.b    $12,   5
                dc.b    $D,   3
                dc.b    8,   5
                dc.b    1,   1
                dc.b    $F4
SSZMecha_DiagonalReturnJumpPrepAnim:
                dc.b    1,   3
                dc.b    1,   7
                dc.b    2,   7
                dc.b    1,   3
                dc.b    8,   0
                dc.b    $F4
SSZMecha_HighReturnJumpFlipAnim:
                dc.b    8,   5
                dc.b    8,   5
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $C,   3
                dc.b    $40|8, $7F
                dc.b    $F8, SSZMecha_LandHoldFrame8Anim.jump-SSZMecha_HighReturnJumpFlipAnim
SSZKnucklesMecha_HoverEntryRawAnimation:
                dc.b    8,   5
                dc.b    $13,   5
                dc.b    $14, $7F
                dc.b    $F8, .jump-SSZKnucklesMecha_HoverEntryRawAnimation

                .jump:
                dc.b    $15, $7F
                dc.b    $FC
SSZMecha_RadialBurstAnim:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    $10,  $F
                dc.b    1,   5
                dc.b    $11, $17
                dc.b    0,   5
                dc.b    8,   3
                dc.b    $F4
SSZMecha_LandThenDashAnim:
                dc.b    1,   5
                dc.b    2, $1F
                dc.b    $F4
SSZMecha_DashStopThenJumpPrepAnim:
                dc.b    2,   0
                dc.b    1,   5
                dc.b    0, $3F
                dc.b    $F4
SSZMecha_AltLandThenJumpPrepAnim:
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    0, $3F
                dc.b    $F4
SSZMecha_TransformLandingAnim:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    $13,   5
                dc.b    $15,   3
                dc.b    $F4
SSZMecha_RestartTransformLandingAnim:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    $13,   5
                dc.b    $15, $7F
                dc.b    $F4
SSZMecha_SmallJumpLandingAnim:
                dc.b    3,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   3
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    0,   3
                dc.b    $F4
SSZMecha_AltTransformReturnJumpAnim:
                dc.b    $C,   3
                dc.b    $C,   3
                dc.b    $A,   3
                dc.b    9,   3
                dc.b    8,   3
                dc.b    $F8, SSZMecha_TransformReturnHoldFrame8-SSZMecha_AltTransformReturnJumpAnim
SSZMecha_PostBattleSettlingRawAnimation:
                dc.b    $E,   5
                dc.b    $E,   5
                dc.b    $F,   3
                dc.b    $F8, .jump-SSZMecha_PostBattleSettlingRawAnimation

                .jump:
                dc.b    $F, $7F
                dc.b    $FC
SSZMecha_RecoverThenActAnim:
                dc.b    $F,   5
                dc.b    $E,   5
                dc.b    2,   1
                dc.b    $F4
SSZMecha_PreJumpCallbackRawAnimation:
                dc.b    2,   5
                dc.b    2,  $F
                dc.b    1,   5
                dc.b    8,   0
                dc.b    $F4
SSZMecha_PrepareRiseAnim:
                dc.b    1,   3
                dc.b    1,   3
                dc.b    2,  $F
                dc.b    1,   3
                dc.b    8,   0
                dc.b    $F4
SSZMecha_PostBattleJumpFlipRawAnimation:
                dc.b    8,   7
                dc.b    8,   7
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $C,   5
                dc.b    $40|8, $7F
                dc.b    $F8, SSZMecha_TransformReturnHoldFrame8-SSZMecha_PostBattleJumpFlipRawAnimation
SSZMecha_TransformReturnHoldFrame8:
                dc.b    8, $7F
                dc.b    $FC
                dc.b    2,   5
                dc.b    2,   5
                dc.b    1,   5
                dc.b    8,   0
                dc.b    $F4
SSZMecha_DashBrakeCrossStreamAnim:
                dc.b    8,   1
                dc.b    8,   1
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    $B,   1
                dc.b    $C,   0
                dc.b    $40|8, $7F
                dc.b    $F8, SSZMecha_RiseThenTransformAnim.jump-SSZMecha_DashBrakeCrossStreamAnim
SSZMecha_HoverTurnAnim:
                dc.b    8,   3
                dc.b    8,   3
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $C,   3
                dc.b    $40|8,   3
                dc.b    $F4
SSZMecha_RiseThenTransformAnim:
                dc.b    8,   3
                dc.b    8,  $F
                dc.b    1

                .jump:
                dc.b    5
                dc.b    $10,  $F
                dc.b    1,   5
                dc.b    $11,   0
                dc.b    $F4
SSZMecha_AccelerateAttackAnim:
                dc.b    8,   1
                dc.b    8,   1
                dc.b    $D,   5
                dc.b    $12, $7F
                dc.b    $F8, .jump-SSZMecha_AccelerateAttackAnim

                .jump:
                dc.b    $12, $7F
                dc.b    $FC
SSZMechaRollingTrail_RawAnimation:
                dc.b    1,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    0,   0
                dc.b    $FC
SSZMecha_ParentReleaseSignalAnim:
                dc.b    $11,   3
                dc.b    $11,   3
                dc.b    0,   3
                dc.b    $11,   3
                dc.b    0,   3
                dc.b    $11,   3
                dc.b    $12, $1B
                dc.b    $13,   5
                dc.b    $14, $3F
                dc.b    $F4
SSZMechaActiveEffect_UniformRawAnimation:
                dc.b    0,   0,   8,   9,   0, $17, $18, $FC
SSZMecha_ActiveParticleDeleteAnim:
                dc.b    $E,   1
                dc.b    $E,   1
                dc.b    $F,   2
                dc.b    $10,   3
                dc.b    $F4
SSZMecha_AimedLaserPrepAnim:
                dc.b    0
                dc.b    $A,  $A,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $C,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $D,   0
                dc.b    $19,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $F4
SSZMechaLaser_FlightUniformRawAnimation:
                dc.b    0
                dc.b    0,  $D, $16
                dc.b    0,  $D,  $C, $16
                dc.b    0,  $D, $16
                dc.b    0,  $D, $19, $16
                dc.b    $FC
SSZMecha_StationaryLaserDeleteAnim:
                dc.b    0
                dc.b    $B,  $B,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $B,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $F4
                even
Map_RoboshipPieces:
                include "src/objects/shared/robotnik/mappings/ship_pieces.s"
Map_SSZMasterEmerald:
                include "src/objects/shared/ssz_master_emerald/mappings/master_emerald.s"
Map_MechaSonicPieces:
                include "src/objects/shared/mecha_sonic/mappings/pieces.s"

MechaSonic_IdleFlashPaletteScript:  palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 0
                .data:  palscriptfile 50,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 5, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 50,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 20,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptrept

Pal_SSZGHZMisc: equ     MechaSonic_IdleFlashPaletteScript.data  ; yeah Sonic 3 is a fun game

MechaSonic_TransformFlashPaletteScript: palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 0
                .data:  palscriptfile 3, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptrept

MechaSonic_EnterSuperPaletteScript: palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 30,"data/General/Sprites/Mecha Sonic/Palettes/Flash 3.bin"
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$00, 16, 0
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 1.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 2.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 3.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 2.bin"
                palscriptrept

MechaSonic_ReturnToMainPaletteScript:   palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 6,  "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 6,  "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 128,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$00, 16, 0
                palscriptfile 128,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptrept

MechaSonic_RestoreSuperPaletteScript:   palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptloop MechaSonic_EnterSuperPaletteScript.headr2

SSZMecha_HoverShiftPaletteScript:   palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptrun

SSZMasterEmeraldColorCycle_IndexedScript:
                dc.l    SSZMecha_EmeraldColorPairOffsets
                dc.w    2-1
                dc.b    0,  $F
                dc.b    1,   9
                dc.b    2,   9
                dc.b    3,   7
                dc.b    4,   7
                dc.b    5,   5
                dc.b    6,   5
                dc.b    5,   5
                dc.b    4,   7
                dc.b    3,   7
                dc.b    2,   9
                dc.b    1,   9
                dc.b    $FF, $FC
SSZMecha_EmeraldColorPairOffsets:
                dc.w    SSZMasterEmeraldColorCycle_ColorPair0-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair1-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair2-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair3-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair4-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair5-SSZMecha_EmeraldColorPairOffsets
                dc.w    SSZMasterEmeraldColorCycle_ColorPair6-SSZMecha_EmeraldColorPairOffsets
SSZMasterEmeraldColorCycle_ColorPair0:
                dc.w    $480,  $6A0
SSZMasterEmeraldColorCycle_ColorPair1:
                dc.w    $680,  $8A0
SSZMasterEmeraldColorCycle_ColorPair2:
                dc.w    $680,  $8C0
SSZMasterEmeraldColorCycle_ColorPair3:
                dc.w    $6A0,  $AC0
SSZMasterEmeraldColorCycle_ColorPair4:
                dc.w    $8A0,  $AE0
SSZMasterEmeraldColorCycle_ColorPair5:
                dc.w    $8C0,  $CE0
SSZMasterEmeraldColorCycle_ColorPair6:
                dc.w    $AC0,  $EE0
; ---------------------------------------------------------------------------
DEZMiniboss_CameraTriggerAndArenaBounds:
                dc.w    $18C,  $38C, $3400, $3780
                dc.w    $28C,  $28C, $3680, $36C0

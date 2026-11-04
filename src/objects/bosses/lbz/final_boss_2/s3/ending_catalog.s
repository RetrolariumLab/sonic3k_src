; Owner: objects/bosses/lbz/final_boss_2/s3
; Responsibility: Launch Base second final boss and unused Robotnik attributes, child records, ending poses, palettes and fade catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_LBZFinalBoss2:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $1C, $20,   5,   0
LBZBoss2S3_BodyPartAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $200
                dc.b    $28, $28,   0,   0
LBZBoss2S3_PrimaryArmAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $180
                dc.b    $20, $10,   2,   0
LBZBoss2S3_ArmSegmentAttributes:
                dc.w    $80
                dc.b    $14, $14,   4,   0
LBZBoss2S3_SecondaryArmAttributes:
                dc.w    $180
                dc.b    8,   8,   3,   0
LBZBoss2S3_CoverAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $300
                dc.b    $14,  $C,   1,   0
LBZBoss2S3_TilePartAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $C,  $C,  $C,   0
LBZBoss2S3_BodyFragmentAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,1)
                dc.w    $100
                dc.b    $10, $14,  $D,   0
LBZBoss2S3_FallingDebrisAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,2,0)
                dc.w    $300
                dc.b    $C,  $C,   7,   0
LBZBoss2S3_DeathEggPieceAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $380
                dc.b    $18, $18,   0,   0
LBZBoss2S3_SparkleAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   3,   0
LBZBoss2S3_SparkleTrailAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   4,   0
ObjDat_LBZ2UnusedRobotnik:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
LBZBoss2S3_EndingPoseAttributes:
                dc.l    Map_SonicTailsEndPoses
                dc.w    make_art_tile(ArtTile_Ending_S3EndPose,0,1)
                dc.w    $300
                dc.b    $40, $40,   0,   0
LBZBoss2S3_BodyPartChildren:
                dc.w    4-1
                dc.l    LBZBoss2S3_ArmDispatchAndDraw
                dc.b    $14, $24
                dc.l    LBZBoss2S3_InitBodyPartAndFollow
                dc.b    $C,-$14
                dc.l    LBZBoss2S3_InitCoverAndFollow
                dc.b    0,-$18
                dc.l    LBZBoss2S3_InitCollisionFlashVisual
                dc.b    $38,-$14
LBZBoss2S3_TouchProxyChild:
                dc.w    1-1
                dc.l    LBZBoss2S3_InitInvisibleTouchProxy
                dc.b    4,-$34
LBZBoss2S3_PrimaryArmChildren:
                dc.w    4-1
                dc.l    LBZBoss2S3_InitSegmentAndCacheBoss
                dc.b    -$2A,  -2
                dc.l    LBZBoss2S3_InitSegmentAndCacheBoss
                dc.b    -$4A,  -2
                dc.l    LBZBoss2S3_InitFollowerAndReparent
                dc.b    0,   0
                dc.l    LBZBoss2S3_CaptureProbeCacheBoss
                dc.b    -$40,  -2
LBZBoss2S3_DefeatFragmentChildren:
                dc.w    5-1
                dc.l    LBZBoss2S3_InitBodyFragment
                dc.b    -$C,-$2C
                dc.l    LBZBoss2S3_InitBodyFragment
                dc.b    $14,-$2C
                dc.l    LBZBoss2S3_InitBodyFragment
                dc.b    $2C,-$18
                dc.l    LBZBoss2S3_InitBodyFragment
                dc.b    -$C,  -4
                dc.l    LBZBoss2S3_InitBodyFragment
                dc.b    $14,  -4
LBZBoss2S3_EndingBurstChildren:
                dc.w    2-1
                dc.l    LBZBoss2S3_InitExplosionTravel
LBZBoss2S3_DeathEggPieceChildren:
                dc.w    7-1
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    0,   0
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    -$10, $28
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    -$70,   0
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    -$48, $28
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    $18, $10
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    -$24,  -8
                dc.l    LBZBoss2S3_InitDeathEggPiece
                dc.b    -$50, $1C
LBZBoss2S3_DeathEggSparkleChild:
                dc.w    1-1
                dc.l    LBZBoss2S3_InitSparkleAndTryTrail
LBZBoss2S3_SparkleTrailChild:
                dc.w    1-1
                dc.l    LBZBoss2S3_InitFallingSparkleTrail
LBZBoss2S3_EndingWhiteFadeChild:
                dc.w    1-1
                dc.l    S3PalEffect_InitWhitePasses
LBZBoss2S3_EndingTargetFadeChild:
                dc.w    1-1
                dc.l    S3PalEffect_InitTargetPasses
LBZBoss2S3_ArmSegmentDefaultAnim:
                dc.b    9,   7,   4,   5,   6,   5,   4, $FC
LBZBoss2S3_ArmSegmentAlternateAnim:
                dc.b    9,  $B,   8,   9,  $A,   9,   8, $FC
LBZBoss2S3_SparkleTrailDeleteAnim:
                dc.b    2,   4,   4,   5,   6, $F4
LBZBoss2S3_EndingFirstExternalAnim:
                dc.b    5, $C4
                dc.b    0, $55
                dc.b    0, $59
                dc.b    1, $5A
                dc.b    1, $FF
LBZBoss2S3_EndingSecondExternalAnim:
                dc.b    7, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $59
                dc.b    1, $55
                dc.b    0, $56
                dc.b    0, $57
                dc.b    0, $57
                dc.b    0, $57
                dc.b    0, $FF
LBZBoss2S3_EndingAnimByCharacter:
                dc.l    LBZBoss2S3_EndingSonicExternalAnim
                dc.l    LBZBoss2S3_EndingTailsExternalAnim
LBZBoss2S3_EndingSonicExternalAnim:
                dc.b    $F, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $FF
LBZBoss2S3_EndingTailsExternalAnim:
                dc.b    $7F, $A6
                dc.b    0, $A6
                dc.b    0, $A6
                dc.b    0, $A6
                dc.b    0, $FF
Pal_LBZFinalBoss2:
                binclude "data/Levels/LBZ/Palettes/Final Boss 2.bin"
                even
Pal_LBZEnding:
                binclude "data/Levels/LBZ/Palettes/Ending.bin"
                even
Pal_SonicEndPose:
                binclude "data/General/Ending/Palettes/Sonic End Pose.bin"
                even
Pal_TailsEndPose:
                binclude "data/General/Ending/Palettes/Tails End Pose.bin"
                even
Pal_SuperSonicEndPose:
                binclude "data/General/Ending/Palettes/S3 Super Sonic End Pose.bin"
                even
Map_SonicTailsEndPoses:
                include "src/ui/shared/ending/mappings/sonic_tails_s3.s"

PalSPtr_LBZFinalBoss2_FadeIn:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_4+$16, 4, 2-1
                .data:  palscriptdata 16, $ECE, $E8A, $E48, $E46
                palscriptdata 16, $CAC, $C68, $C46, $A44
                palscriptdata 16, $A88, $A46, $824, $622
                palscriptdata 16, $844, $622, $400, $200
                palscriptrun

PalSPtr_LBZFinalBoss2_FadeOut:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_4+$16, 4, 2-1
                .data:  palscriptdata 16, $844, $622, $400, $200
                palscriptdata 16, $A88, $A46, $824, $622
                palscriptdata 16, $CAC, $C68, $C46, $A44
                palscriptdata 16, $ECE, $E8A, $E48, $E46
                palscriptrun

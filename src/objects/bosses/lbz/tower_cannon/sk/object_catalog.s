; Owner: objects/bosses/lbz/tower_cannon/sk
; Responsibility: Launch Base first final-boss variants object attributes, child construction, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZFinalBoss1:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $280
                dc.b    $20, $20,  $C,  $F
LBZBoss1SK_PrimarySectionAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $20, $14,   0, $AD
LBZBoss1SK_LowerSectionAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28, $18,   1, $AD
LBZBoss1SK_SectionFlameAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $280
                dc.b    $C, $18,   9, $89
LBZBoss1SK_SectionDebrisAttributes:
                dc.w    $200
                dc.b    $10, $10, $2A,   0
LBZFinalBoss1SK_Cannon_PartialAttributes:
                dc.w    $180
                dc.b    $C,  $C,   3,   0
LBZBoss1SK_LaserChargeAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $100
                dc.b    $18,   8,  $F,   0
LBZBoss1SK_LaserTrailAttributes:
                dc.w    $100
                dc.b    8,   8, $1C,   0
LBZFinalBoss1SK_Orbiter_FullAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C,  $C,  $C, $97
LBZFinalBoss1SK_TopTrim_FullAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28,   8,   2,   0
LBZBoss1SK_HitOverlayAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $280
                dc.b    $10,  $C, $10,   0
LBZBoss1SK_FallingDebrisAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,2,0)
                dc.w    $300
                dc.b    $C,  $C,   7,   0
LBZBoss1SK_DeathEggPieceAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $380
                dc.b    $18, $18,   0,   0
LBZBoss1SK_DeathEggParticleAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   3,   0
LBZBoss1SK_DeathEggNestedFxAttributes:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   4,   0
LBZBoss1SK_BodySectionChildren:
                dc.w    3-1
                dc.l    LBZBoss1SK_InitPrimarySectionAndCannons
                dc.b    0,   8
                dc.l    LBZBoss1SK_InitMiddleSection
                dc.b    0, $30
                dc.l    LBZBoss1SK_InitLowerSectionAndFlames
                dc.b    0, $5C
LBZBoss1SK_BreakupFourDebrisChildren:
                dc.w    4-1
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    -$10,  -4
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    $10,  -4
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    -$10, $10
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    $10, $10
LBZBoss1SK_BreakupSixDebrisChildren:
                dc.w    6-1
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    -$10,  -8
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    $10,  -8
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    -$10, $10
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    $10, $10
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    -$14,-$20
                dc.l    LBZBoss1SK_InitSectionDebris
                dc.b    $14,-$20
LBZBoss1SK_SectionCannonChildren:
                dc.w    2-1
                dc.l    LBZBoss1SK_InitCannonAndCacheRoot
                dc.b    0,   0
LBZBoss1SK_CannonChargeChildren:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitLaserCharge
                dc.b    -8,   0
                dc.w    1-1
                dc.l    LBZBoss1SK_InitLaserCharge
                dc.b    8,   0
LBZBoss1SK_LaserTrailChild:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitLaserTrail
                dc.b    $20,   0
LBZBoss1SK_LowerSectionFlameChildren:
                dc.w    2-1
                dc.l    LBZBoss1SK_InitSectionFlame
                dc.b    -$14, $30
                dc.l    LBZBoss1SK_InitSectionFlame
                dc.b    $14, $30
LBZBoss1SK_OrbiterChild:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitOrbiter
                dc.b    0,   0
LBZBoss1SK_TopTrimChild:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitTopTrim
                dc.b    0,-$14
LBZBoss1SK_HitOverlayChildren:
                dc.w    2-1
                dc.l    LBZBoss1SK_InitHitOverlay
                dc.b    -$10,   0
                dc.l    LBZBoss1SK_InitHitOverlay
                dc.b    $10,   0
LBZBoss1SK_EndingBurstChildren:
                dc.w    2-1
                dc.l    LBZBoss1SK_InitBurstController
LBZBoss1SK_DeathEggPieceChildren:
                dc.w    7-1
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    0,   0
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    -$10, $28
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    -$70,   0
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    -$48, $28
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    $18, $10
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    -$24,  -8
                dc.l    LBZBoss1SK_InitDeathEggPiece
                dc.b    -$50, $1C
LBZBoss1SK_DeathEggParticleChild:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitDeathEggParticle
LBZBoss1SK_DeathEggNestedParticleChild:
                dc.w    1-1
                dc.l    LBZBoss1SK_InitDeathEggNestedParticle
LBZBoss1SK_SectionFlameAnim:
                dc.b    2,   9,  $A,  $B, $FC
LBZBoss1SK_LaserChargeLaunchAnim:
                dc.b    0, $17, $17, $18, $19, $1A, $1B, $F4
LBZBoss1SK_LaserTrailEvenAnim:
                dc.b    0, $1C, $1C, $1D, $1E, $F4
LBZBoss1SK_LaserTrailOddAnim:
                dc.b    0, $1F, $1F, $20, $21, $F4
LBZBoss1SK_OrbiterFlipCycleAnim:
                dc.b    1,  $C,  $D,  $E,  $D,  $C, $F4
LBZBoss1SK_DeathEggNestedParticleAnim:
                dc.b    2,   4,   4,   5,   6, $F4
LBZBoss1SK_EndingP1FrameFlipAnim:
                dc.b    5, $C4
                dc.b    0, $55
                dc.b    0, $59
                dc.b    1, $5A
                dc.b    1,   0
LBZBoss1SK_EndingP2FrameFlipAnim:
                dc.b    5, $C4
                dc.b    0, $55
                dc.b    0, $59
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1,   0
                even
Pal_LBZFinalBoss1:
                binclude "data/Levels/LBZ/Palettes/Final Boss 1.bin"
                even
Pal_LBZEnding:
                binclude "data/Levels/LBZ/Palettes/Ending.bin"
                even
; ---------------------------------------------------------------------------
LBZBoss1SK_EarlierBossCameraTrigger:
                dc.w    $460,  $6A0, $3900, $3B20
LBZBoss1SK_EarlierBossCameraTarget:
                dc.w    $5A0,  $5A0, $3A20, $3A20

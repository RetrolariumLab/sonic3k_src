; Owner: objects/bosses/lbz/final_boss_1/s3
; Responsibility: Launch Base first final boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZFinalBoss1:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $280
                dc.b    $20, $20,  $C,  $F
LBZBoss1S3_AlternateUndersideAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $10,   4, $15,   0
LBZBoss1S3_PayloadAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C, $10, $16,   0
LBZBoss1S3_PrimarySectionAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $20, $14,   0, $AD
LBZBoss1S3_LowerSectionAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28, $18,   1, $AD
LBZBoss1S3_SectionFlameAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $280
                dc.b    $C, $18,   9, $89
LBZBoss1S3_SectionDebrisAttributes:
                dc.w    $200
                dc.b    $10, $10, $2A,   0
LBZFinalBoss1S3_Cannon_PartialAttributes:
                dc.w    $180
                dc.b    $C,  $C,   3,   0
LBZBoss1S3_LaserChargeAttributes:
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,0,1)
                dc.w    $100
                dc.b    $18,   8,  $F,   0
LBZBoss1S3_LaserTrailAttributes:
                dc.w    $100
                dc.b    8,   8, $1C,   0
LBZFinalBoss1S3_Orbiter_FullAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C,  $C,  $C, $97
LBZFinalBoss1S3_TopTrim_FullAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $28,   8,   2,   0
LBZBoss1S3_HitOverlayAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $280
                dc.b    $10,  $C, $10,   0
LBZBoss1S3_AlternateUndersideChild:
                dc.w    1-1
                dc.l    LBZBoss1S3_InitAlternateUnderside
                dc.b    0, $10
LBZBoss1S3_AlternatePayloadChild:
                dc.w    1-1
                dc.l    LBZBoss1S3_PayloadDispatchAndDraw
                dc.b    0,   8
LBZBoss1S3_BodySectionChildren:
                dc.w    3-1
                dc.l    LBZBoss1S3_InitPrimarySectionAndCannons
                dc.b    0,   8
                dc.l    LBZBoss1S3_InitMiddleSection
                dc.b    0, $30
                dc.l    LBZBoss1S3_InitLowerSectionAndFlames
                dc.b    0, $5C
LBZBoss1S3_BreakupFourDebrisChildren:
                dc.w    4-1
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    -$10,  -4
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    $10,  -4
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    -$10, $10
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    $10, $10
LBZBoss1S3_BreakupSixDebrisChildren:
                dc.w    6-1
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    -$10,  -8
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    $10,  -8
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    -$10, $10
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    $10, $10
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    -$14,-$20
                dc.l    LBZBoss1S3_InitSectionDebris
                dc.b    $14,-$20
LBZBoss1S3_SectionCannonChildren:
                dc.w    2-1
                dc.l    LBZBoss1S3_InitCannonAndCacheRoot
                dc.b    0,   0
LBZBoss1S3_CannonChargeChildren:
                dc.w    1-1
                dc.l    LBZBoss1S3_InitLaserCharge
                dc.b    -8,   0
                dc.w    1-1
                dc.l    LBZBoss1S3_InitLaserCharge
                dc.b    8,   0
LBZBoss1S3_LaserTrailChild:
                dc.w    1-1
                dc.l    LBZBoss1S3_InitLaserTrail
                dc.b    $20,   0
LBZBoss1S3_LowerSectionFlameChildren:
                dc.w    2-1
                dc.l    LBZBoss1S3_InitSectionFlame
                dc.b    -$14, $30
                dc.l    LBZBoss1S3_InitSectionFlame
                dc.b    $14, $30
LBZBoss1S3_OrbiterChild:
                dc.w    1-1
                dc.l    LBZBoss1S3_InitOrbiter
                dc.b    0,   0
LBZBoss1S3_TopTrimChild:
                dc.w    1-1
                dc.l    LBZBoss1S3_InitTopTrim
                dc.b    0,-$14
LBZBoss1S3_HitOverlayChildren:
                dc.w    2-1
                dc.l    LBZBoss1S3_InitHitOverlay
                dc.b    -$10,   0
                dc.l    LBZBoss1S3_InitHitOverlay
                dc.b    $10,   0
LBZBoss1S3_SectionFlameAnim:
                dc.b    2,   9,  $A,  $B, $FC
LBZBoss1S3_LaserChargeLaunchAnim:
                dc.b    0, $17, $17, $18, $19, $1A, $1B, $F4
LBZBoss1S3_LaserTrailEvenAnim:
                dc.b    0, $1C, $1C, $1D, $1E, $F4
LBZBoss1S3_LaserTrailOddAnim:
                dc.b    0, $1F, $1F, $20, $21, $F4
LBZBoss1S3_OrbiterFlipCycleAnim:
                dc.b    1,  $C,  $D,  $E,  $D,  $C, $F4
                even
Pal_LBZFinalBoss1:
                binclude "data/Levels/LBZ/Palettes/Final Boss 1.bin"
                even

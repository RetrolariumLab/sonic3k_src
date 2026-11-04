; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss object attributes, child records, splash DPLC, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_HCZMiniboss_Loop:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,  $F
ObjDat_HCZMiniboss_Rockets:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $200
                dc.b    $10, $10,   1, $8B
HCZMiniS3_RocketTipAttributes:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15,   0
ObjDat2_HCZMiniboss_Engine:
                dc.w    make_art_tile(ArtTile_HCZMiniboss,0,1)
                dc.w    $280
                dc.b    $10, $10, $15, $92
HCZMiniS3_VortexAttributes:
                dc.l    Map_HCZMiniboss
                dc.w    make_art_tile(ArtTile_HCZMiniboss,1,1)
                dc.w    $280
                dc.b    $10, $28, $16,   0
HCZMiniS3_ParticleAttributes:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,1,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
HCZMiniS3_SplashArtSlots:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_HCZMinibossSplash,0,1)
                dc.w    $10,     0
                dc.l    Map_HCZMinibossSplash
                dc.w    $80
                dc.b    $10, $10,   0,   0
HCZMiniS3_BossFragmentAttributes:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
HCZMiniS3_VortexDebrisAttributes:
                dc.w    $280
                dc.b    $14, $24,   0,   0
Child1_HCZMiniboss_RocketsEngine:
                dc.w    5-1
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    $18, $18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    -$18,-$18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    -$18, $18
                dc.l    Obj_HCZMiniboss_Rockets
                dc.b    $18,-$18
                dc.l    Obj_HCZMiniboss_Engine
                dc.b    0, $24
HCZMiniS3_VortexChild:
                dc.w    1-1
                dc.l    HCZMiniS3_VortexDispatchAndDraw
                dc.b    0,   0
HCZMiniS3_RocketTipChild:
                dc.w    1-1
                dc.l    HCZMiniS3_InitRocketTip
                dc.b    0,   0
HCZMiniS3_SurfaceSplashChildren:
                dc.w    3-1
                dc.l    HCZMiniS3_InitSlottedWaterSplash
                dc.b    0,   0
                dc.l    HCZMiniS3_InitSlottedWaterSplash
                dc.b    -$10,   0
                dc.l    HCZMiniS3_InitSlottedWaterSplash
                dc.b    $10,   0
HCZMiniS3_VortexOrbitChildren:
                dc.w    $1E-1
                dc.l    HCZMiniS3_InitRandomOrbitParticle
HCZMiniS3_WaterExitParticleChild:
                dc.w    1-1
                dc.l    HCZMiniS3_InitWaterExitParticle
HCZMiniS3_ExitTransportSoloChild:
                dc.w    1-1
                dc.l    HCZMiniS3_TransportWaitForP1Underwater
HCZMiniS3_ExitTransportPairChildren:
                dc.w    2-1
                dc.l    HCZMiniS3_TransportWaitForP1Underwater
HCZMiniS3_BossFragmentChildren:
                dc.w    4-1
                dc.l    HCZMiniS3_InitBossFragmentFlicker
                dc.b    -$C, -$C
                dc.l    HCZMiniS3_InitBossFragmentFlicker
                dc.b    -$C,  $C
                dc.l    HCZMiniS3_InitBossFragmentFlicker
                dc.b    $C, -$C
                dc.l    HCZMiniS3_InitBossFragmentFlicker
                dc.b    $C,  $C
HCZMiniS3_VortexDebrisChildren:
                dc.w    5-1
                dc.l    HCZMiniS3_InitFallingVortexDebris
                dc.b    0,-$24
                dc.l    HCZMiniS3_InitFallingVortexDebris
                dc.b    -8,   0
                dc.l    HCZMiniS3_InitFallingVortexDebris
                dc.b    8,   0
                dc.l    HCZMiniS3_InitFallingVortexDebris
                dc.b    -$C, $30
                dc.l    HCZMiniS3_InitFallingVortexDebris
                dc.b    $C, $30
DPLCPtr_HCZMinibossSplash:
                dc.l    ArtUnc_DashDust
                dc.l    DPLC_HCZMinibossSplash
HCZMiniS3_VortexAccelerationAnim:
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $16,   6
                dc.b    $17,   6
                dc.b    $18,   6
                dc.b    $16,   5
                dc.b    $17,   5
                dc.b    $18,   5
                dc.b    $16,   4
                dc.b    $17,   4
                dc.b    $18,   4
                dc.b    $16,   3
                dc.b    $17,   3
                dc.b    $18,   3
                dc.b    $16,   2
                dc.b    $17,   2
                dc.b    $18,   2
                dc.b    $F4
HCZMiniS3_VortexActiveAnim:
                dc.b    1, $16, $17, $18, $FC
HCZMiniS3_VortexDecelerationAnim:
                dc.b    $16,   2
                dc.b    $17,   2
                dc.b    $18,   2
                dc.b    $16,   3
                dc.b    $17,   3
                dc.b    $18,   3
                dc.b    $16,   4
                dc.b    $17,   4
                dc.b    $18,   4
                dc.b    $16,   5
                dc.b    $17,   5
                dc.b    $18,   5
                dc.b    $16,   6
                dc.b    $17,   6
                dc.b    $18,   6
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $F4
HCZMiniS3_SplashDPLCAnimation:
                dc.b    3,   0,   1,   2,   3,   4,   5,   6,   7,   8, $F4
HCZMiniS3_ParticleAnimBase0:
                dc.b    0,   0, $16, $FC
HCZMiniS3_ParticleAnimBase1:
                dc.b    0,   1, $16, $FC
HCZMiniS3_ParticleAnimBase2:
                dc.b    0,   2, $16, $FC
HCZMiniS3_ParticleAnimBase3:
                dc.b    0,   3, $16, $FC
                even
Pal_HCZMiniboss:
                binclude "data/Levels/HCZ/Palettes/Miniboss.bin"
                even
Pal_HCZMinibossWater:
                binclude "data/Levels/HCZ/Palettes/Miniboss Water.bin"
                even

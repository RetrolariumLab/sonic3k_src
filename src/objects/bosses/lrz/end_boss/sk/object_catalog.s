; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss and platform attributes, child creation, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_LRZEndBoss:
                dc.l    Map_LRZEndBoss
                dc.w    make_art_tile(ArtTile_LRZEndBoss,1,0)
                dc.w    $280
                dc.b    $28, $2C,   0, $B8
LRZBossProjectile_PartialAttributes:
                dc.w    $280
                dc.b    $10, $10,   4, $9A
LRZBossShotEffect_PartialAttributes:
                dc.w    $280
                dc.b    $10, $10,   5,   0
LRZBossProjectileTrail_PartialAttributes:
                dc.w    $280
                dc.b    8,   8,  $A,   0
LRZBossSurfaceEffect_PartialAttributes:
                dc.w    $200
                dc.b    $28,   4,   1,   0
LRZBoss_StatusDisplayAttributes:
                dc.w    make_art_tile(ArtTile_LRZEndBoss,0,0)
                dc.w    $200
                dc.b    $C,   8,  $F,   0
LRZBossSmallPlatform_FullAttributes:
                dc.l    Map_LRZ3Platform
                dc.w    make_art_tile($001,3,0)
                dc.w    $280
                dc.b    $18, $10,   1,   0
LRZBoss_LargePlatformAttributes:
                dc.l    Map_LRZ3Platform
; this is using the incorrect palette line
                dc.w    make_art_tile($001,3,0)
                dc.w    $280
                dc.b    $20, $18,   4,   0
LRZBoss_PlatformOverlayAttributes:
                dc.w    make_art_tile($001,2,0)
                dc.w    $100
                dc.b    $20,   8,   2,   0
LRZBoss_SurfaceAndDisplayChildren:
                dc.w    2-1
                dc.l    LRZBoss_InitSurfaceEffect
                dc.b    0,-$12
                dc.l    LRZBoss_InitStatusDisplay
                dc.b    -$15,   1
LRZBoss_ShotAndEffectChildren:
                dc.w    2-1
                dc.l    LRZBossProjectile_InitializeUpwardLaunch
                dc.b    0,-$18
                dc.l    LRZBoss_InitShotEffect
                dc.b    0,-$37
LRZBossProjectile_SingleTrailNormalChild:
                dc.w    1-1
                dc.l    LRZBoss_InitShotTrailAndMotion
                dc.b    0, $10
LRZRisingPlatform_SingleRepeatedChild:
                dc.w    1-1
                dc.l    LRZBoss_InitRisingPlatform
LRZBoss_PlatformOverlayChild:
                dc.w    1-1
                dc.l    LRZBoss_InitPlatformOverlay
LRZBoss_PlatformDebrisChildren:
                dc.w    $A-1
                dc.l    LRZBoss_InitPlatformDebris
LRZBossSurfaceEffect_UniformFrameLoop:
                dc.b    2,   1,   2,   3, $FC
LRZBoss_ShotEffectDeleteAnim:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    6,   1
                dc.b    5,   0
                dc.b    6,   1
                dc.b    7,   3
                dc.b    8,   4
                dc.b    9,   5
                dc.b    $F4
LRZBoss_ShotTrailDeleteAnim:
                dc.b    $A,   2
                dc.b    $A,   2
                dc.b    $B,   3
                dc.b    $C,   4
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $F4
LRZBossPlatformOverlay_UniformFrameLoop:
                dc.b    3,   2,   3, $FC
LRZBossLargePlatform_UniformFrameLoop:
                dc.b    7,   4,   5, $FC
                even
Pal_LRZEndBoss:
                binclude "data/Levels/LRZ/Palettes/End Boss.bin"
                even

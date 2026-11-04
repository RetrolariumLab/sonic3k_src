; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday boss, missile and asteroid attributes, child construction, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
DDZFirstPhaseTurret_Attributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $280
                dc.b    8,   8, $1C,   0
DDZTurretShot_PartialAttributes:
                dc.w    $280
                dc.b    4,   4, $24,   0
DDZFirstPhaseVulnerableBody_Attributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    $38, $2C, $38,   0
DDZ_Phase1DetailAttributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $280
                dc.b    $10, $18,   7,   0
DDZ_Phase2DetailAttributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,1)
                dc.w    $180
                dc.b    $10, $10,   6,   0
ObjDat_DDZMissile:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $180
                dc.b    $18, $18,   8,   0
DDZ_MissileFlamePartialAttributes:
                dc.w    $180
                dc.b    8,   8, $12,   0
DDZ_TrailPuffPartialAttributes:
                dc.w    $200
                dc.b    8,   8, $18,   0
DDZAsteroidFragment_PartialAttributes:
                dc.w    $300
                dc.b    $C,  $C, $29,   0
DDZSecondPhaseAttachedParts_Attributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $200
                dc.b    $40, $24,   1,   0
DDZSuperPlayerTrailingStars_Attributes:
                dc.l    Map_SuperSonic_Stars
                dc.w    make_art_tile(ArtTile_Shield,0,1)
                dc.w    $80
                dc.b    $18, $18,   0,   0
DDZMasterEmerald_Attributes:
                dc.l    Map_BossMasterEmerald
                dc.w    make_art_tile(ArtTile_BossMasterEmerald,3,0)
                dc.w    $280
                dc.b    $20, $18,   0,   0
DDZHorizontalHeavyProjectile_Attributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    $10,  $C, $31,   0
DDZ_HeavyShotFrontPartialAttrs:
                dc.w    $280
                dc.b    8, $10, $33,   0
DDZCurvedHeavyProjectile_Attributes:
                dc.l    Map_DDZMissileAsteroid
                dc.w    make_art_tile(ArtTile_DDZMisc,2,0)
                dc.w    $300
                dc.b    8,   8, $25,   0
DDZMissileRearFlame_SimpleChildRecord:
                dc.w    1-1
                dc.l    DDZ_InitMissileFlame
DDZ_MissileFlamePuffChild:
                dc.w    1-1
                dc.l    DDZ_InitMissileTrailPuff
DDZ_Phase1VulnerableBodyChild:
                dc.w    1-1
                dc.l    DDZ_Phase1TargetDispatchAndDraw
DDZ_Phase1FlickerDetailChildren:
                dc.w    3-1
                dc.l    DDZ_InitPhase1FlickerPart
DDZFirstPhaseTurrets_SimpleChildRecord:
                dc.w    3-1
                dc.l    DDZ_InitTurretOffsetAndShotTimer
DDZTurretShot_SimpleChildRecord:
                dc.w    1-1
                dc.l    DDZ_InitTurretShotAndVelocity
DDZ_Phase2AttachedPartChildren:
                dc.w    3-1
                dc.l    DDZ_InitPhase2PartAndEmeraldChild
DDZMasterEmerald_NormalChildRecord:
                dc.w    1-1
                dc.l    DDZ_InitMasterEmeraldAndCheckPalette
                dc.b    $1C,  -4
DDZ_Phase2FlickerDetailChildren:
                dc.w    2-1
                dc.l    DDZ_InitPhase2FlickerPart
DDZ_CurvedHeavyShotChildren:
                dc.w    4-1
                dc.l    DDZ_InitHeavyCurveShot
DDZ_HorizontalHeavyShotChildren:
                dc.w    4-1
                dc.l    DDZ_InitHeavyLinearShot
DDZ_HorizontalHeavyShotEffects:
                dc.w    2-1
                dc.l    DDZ_InitHeavyShotFrontChild
                dc.b    8,   0
                dc.l    DDZ_InitHeavyShotRearTrail
                dc.b    -$18,   0
DDZ_CurvedHeavyShotPuffChild:
                dc.w    1-1
                dc.l    DDZ_InitHeavyCurveShotPuff
DDZ_AsteroidFragmentSubtype0Anim:
                dc.b    3, $29, $2A, $2B, $2C, $FC
DDZ_AsteroidFragmentOtherAnim:
                dc.b    3, $2D, $2E, $2F, $30, $FC
DDZ_TrailPuffDeleteAnim:
                dc.b    $18,   3
                dc.b    $18,   3
                dc.b    $19,   3
                dc.b    $1A,   4
                dc.b    $1B,   5
                dc.b    $F4
DDZ_HorizontalHeavyShotAnim:
                dc.b    1, $31, $32, $FC
DDZ_HorizontalHeavyShotFrontAnim:
                dc.b    $33,   3
                dc.b    $34,   3
                dc.b    $35,   3
                dc.b    $39,   7
                dc.b    $37,   3
                dc.b    $36,   3
                dc.b    $FC
DDZ_Phase2AttachedPart0Anim:
                dc.b    $3A, $2F
                dc.b    $3B,   9
                dc.b    $3C,   9
                dc.b    $3B,   9
                dc.b    $FC
DDZ_Phase2AttachedPart4Anim:
                dc.b    $3D, $2F
                dc.b    $3E,   9
                dc.b    $3F,   9
                dc.b    $3E,   9
                dc.b    $FC
                even
Map_DDZMissileAsteroid:
                include "src/objects/shared/zones/ddz/mappings/missile_asteroid.s"

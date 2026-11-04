; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_AIZEndBoss:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,1,1)  ; VRAM
                dc.w    $280                            ; Priority
                dc.b    $28, $20,   0, $10              ; Width, Height, Frame, Collision
AIZBossS3_AttachmentAttributes:
                dc.w    $200
                dc.b    $24, $14,   1,   0
AIZBossS3_AttackPieceAttributes:
                dc.w    $180
                dc.b    $C,  $C,   4,   0
AIZBossS3_ChargeAttributes:
                dc.w    $100
                dc.b    8,   4,  $B, $97
AIZBossS3_ShotAttributes:
                dc.w    $100
                dc.b    $14, $18,  $F, $9A
AIZBossS3_TrailAttributes:
                dc.w    $100
                dc.b    8,   8, $18,   0
AIZEndBossS3_Splash_PartialArtAttributes:
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $30, $30, $24,   0
ObjDat_AIZEndBoss2:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $18, $10, $21,   0
AIZBossS3_DebrisAttributes:
                dc.w    $180
                dc.b    $10, $10,   0,   0
AIZBossS3_SideAttachmentChildren:
                dc.w    2-1
                dc.l    AIZBossS3_AttachmentFollowAndDispatch
                dc.b    $14,  -4
                dc.l    AIZBossS3_AttachmentFollowAndDispatch
                dc.b    -$14,  -4
AIZBossS3_AttackPieceChild:
                dc.w    1-1
                dc.l    AIZBossS3_AttackPieceDispatchAndDraw
                dc.b    -$1C,   0
AIZEndBossS3_Root_OneSplashNormalRecord:
                dc.w    1-1
                dc.l    AIZBossS3_InitSplashBySubtype
                dc.b    0,   0
AIZBossS3_EmergenceEffectChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitEmergenceEffect
                dc.b    0,-$30
AIZBossS3_ChargeRightChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitChargeAndCacheBoss
                dc.b    3,   5
AIZBossS3_ChargeCenterChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitChargeAndCacheBoss
                dc.b    0,   7
AIZBossS3_ChargeLeftChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitChargeAndCacheBoss
                dc.b    -3,   5
AIZBossS3_ReleasedShotChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitShotMotion
                dc.b    0,   0
AIZBossS3_ShotTrailChild:
                dc.w    1-1
                dc.l    AIZBossS3_InitStationaryShotTrail
                dc.b    0,   0
AIZBossS3_DefeatDebrisChildren:
                dc.w    6-1
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    -$10,-$10
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    $10,-$10
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    -$10,   8
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    $10,   8
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    -$C, $18
                dc.l    AIZBossS3_InitDebrisBySubtype
                dc.b    $C, $18
AIZBossS3_DefeatCapsuleChild:
                dc.w    1-1
                dc.l    Obj_EggCapsule
AIZBossS3_CutsceneKnucklesChild:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
AIZBossS3_SubmergedBlinkAnim:
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $F4
AIZBossS3_BodyEmergeAnim:
                dc.b    $1B,   0
                dc.b    $1B,   4
                dc.b    $1C,   5
                dc.b    $1D,   6
                dc.b    0,   0
                dc.b    $F4
AIZBossS3_AttachmentEmergeAnim:
                dc.b    $1E,   0
                dc.b    $1E,   4
                dc.b    $1F,   5
                dc.b    $20,   6
                dc.b    1,   0
                dc.b    $F4
AIZBossS3_ChargeOuterBlinkAnim:
                dc.b    0
                dc.b    7, $2B
                dc.b    7, $2B
                dc.b    8, $2B
                dc.b    8, $2B
                dc.b    9, $2B
                dc.b    9, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $F4
AIZBossS3_ChargeInnerBlinkAnim:
                dc.b    0
                dc.b    $B, $2B
                dc.b    $B, $2B
                dc.b    $C, $2B
                dc.b    $C, $2B
                dc.b    $D, $2B
                dc.b    $D, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $F4
AIZBossS3_ShotOuterAngleAnim:
                dc.b    1, $26, $27, $28, $29, $FC
AIZBossS3_ShotInnerAngleAnim:
                dc.b    1, $16, $17, $2F, $30, $FC
AIZBossS3_ShotGroundAnim:
                dc.b    1, $10, $11, $2D, $2E, $FC
AIZBossS3_TrailMovingXAnim:
                dc.b    $12,   0
                dc.b    $12,   9
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $F4
AIZBossS3_TrailZeroXAnim:
                dc.b    $18,   0
                dc.b    $18,   9
                dc.b    $19,   2
                dc.b    $1A,   2
                dc.b    $F4
AIZBossS3_EmergenceEffectAnim:
                dc.b    $21,   0
                dc.b    $21,   4
                dc.b    $22,   5
                dc.b    $23,   6
                dc.b    $F4
AIZBossS3_SplashStartAnim:
                dc.b    $2B|$00,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $F4
AIZBossS3_SplashFallAnim:
                dc.b    $2B|$00,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $31|$00,   0
                dc.b    $31|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $31|$00,   0
                dc.b    $31|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $F4
                even
Pal_AIZEndBoss:
                binclude "data/Levels/AIZ/Palettes/End Boss.bin"
                even

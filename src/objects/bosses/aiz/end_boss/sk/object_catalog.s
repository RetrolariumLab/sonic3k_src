; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_AIZEndBoss:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,1,1)  ; VRAM
                dc.w    $280                            ; Priority
                dc.b    $28, $20,   0, $10              ; Width, Height, Frame, Collision
AIZBossSK_AttachmentAttributes:
                dc.w    $200
                dc.b    $24, $14,   1,   0
AIZBossSK_AttackPieceAttributes:
                dc.w    $180
                dc.b    $C,  $C,   4,   0
AIZBossSK_ChargeAttributes:
                dc.w    $100
                dc.b    8,   4,  $B, $97
AIZBossSK_ShotAttributes:
                dc.w    $100
                dc.b    $14, $18,  $F, $9A
AIZBossSK_TrailAttributes:
                dc.w    $100
                dc.b    8,   8, $18,   0
AIZEndBossSK_Splash_PartialArtAttributes:
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $30, $30, $24,   0
ObjDat_AIZEndBoss2:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $18, $10, $21,   0
AIZBossSK_DebrisAttributes:
                dc.w    $180
                dc.b    $10, $10,   0,   0
AIZBossSK_SideAttachmentChildren:
                dc.w    2-1
                dc.l    AIZBossSK_AttachmentFollowAndDispatch
                dc.b    $14,  -4
                dc.l    AIZBossSK_AttachmentFollowAndDispatch
                dc.b    -$14,  -4
AIZBossSK_AttackPieceChild:
                dc.w    1-1
                dc.l    AIZBossSK_AttackPieceDispatchAndDraw
                dc.b    -$1C,   0
AIZEndBossSK_Root_OneSplashNormalRecord:
                dc.w    1-1
                dc.l    AIZBossSK_InitSplashBySubtype
                dc.b    0,   0
AIZBossSK_EmergenceEffectChild:
                dc.w    1-1
                dc.l    AIZBossSK_InitEmergenceEffect
                dc.b    0,-$30
AIZBossSK_ChargeRightChild:
                dc.w    1-1
                dc.l    AIZBossSK_InitChargeAndCacheBoss
                dc.b    3,   5
AIZEndBossSK_Emitter_CentralNormalRecord:
                dc.w    1-1
                dc.l    AIZBossSK_InitChargeAndCacheBoss
                dc.b    0,   7
AIZBossSK_ChargeLeftChild:
                dc.w    1-1
                dc.l    AIZBossSK_InitChargeAndCacheBoss
                dc.b    -3,   5
AIZBossSK_ReleasedShotChild:
                dc.w    1-1
                dc.l    AIZBossSK_InitShotMotion
                dc.b    0,   0
AIZBossSK_ShotTrailChild:
                dc.w    1-1
                dc.l    AIZBossSK_InitStationaryShotTrail
                dc.b    0,   0
AIZBossSK_DefeatDebrisChildren:
                dc.w    6-1
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    -$10,-$10
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    $10,-$10
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    -$10,   8
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    $10,   8
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    -$C, $18
                dc.l    AIZBossSK_InitDebrisBySubtype
                dc.b    $C, $18
AIZBossSK_DefeatCapsuleChild:
                dc.w    1-1
                dc.l    Obj_EggCapsule
AIZBossSK_CutsceneKnucklesChild:                        ; used in S3, unused in S&K
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
AIZBossSK_SubmergedBlinkAnim:
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
AIZBossSK_BodyEmergeAnim:
                dc.b    $1B,   0
                dc.b    $1B,   4
                dc.b    $1C,   5
                dc.b    $1D,   6
                dc.b    0,   0
                dc.b    $F4
AIZBossSK_AttachmentEmergeAnim:
                dc.b    $1E,   0
                dc.b    $1E,   4
                dc.b    $1F,   5
                dc.b    $20,   6
                dc.b    1,   0
                dc.b    $F4
AIZBossSK_ChargeOuterBlinkAnim:
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
AIZBossSK_ChargeInnerBlinkAnim:
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
AIZBossSK_ShotOuterAngleAnim:
                dc.b    1, $26, $27, $28, $29, $FC
AIZBossSK_ShotInnerAngleAnim:
                dc.b    1, $16, $17, $2F, $30, $FC
AIZBossSK_ShotGroundAnim:
                dc.b    1, $10, $11, $2D, $2E, $FC
AIZBossSK_TrailMovingXAnim:
                dc.b    $12,   0
                dc.b    $12,   9
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $F4
AIZBossSK_TrailZeroXAnim:
                dc.b    $18,   0
                dc.b    $18,   9
                dc.b    $19,   2
                dc.b    $1A,   2
                dc.b    $F4
AIZBossSK_EmergenceEffectAnim:
                dc.b    $21,   0
                dc.b    $21,   4
                dc.b    $22,   5
                dc.b    $23,   6
                dc.b    $F4
AIZBossSK_SplashStartAnim:
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
AIZBossSK_SplashFallAnim:
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

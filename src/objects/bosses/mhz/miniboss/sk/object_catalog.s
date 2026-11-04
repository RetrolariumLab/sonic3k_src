; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss and tree object attributes, construction, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_MHZMiniboss:
                dc.l    Map_MHZMiniboss
                dc.w    make_art_tile(ArtTile_MHZMiniboss,1,1)
                dc.w    $200
                dc.b    $48, $40,   0,  $F
MHZMini_ArtPriorityBounds:
                dc.w    make_art_tile(ArtTile_MHZMiniboss,0,1)
                dc.w    $280
                dc.b    $C,  $C, $16, $9A
ObjDat_MHZMinibossTree:
                dc.l    Map_MHZMinibossTree
                dc.w    make_art_tile($001,3,0)
                dc.w    $380
                dc.b    $14, $90,   5,   0
MHZMinibossLog_FullAttributes:
                dc.l    Map_MHZMinibossLog
                dc.w    make_art_tile(ArtTile_MHZMinibossLog,3,0)
                dc.w    $380
                dc.b    $14, $14,   6, $86
MHZMinibossThrownActor_PartialAttributes:
                dc.w    $300
                dc.b    8,   8, $18, $8B
MHZMini_LinkedBodyChildren:
                dc.w    1
                dc.l    MHZMini_InitLeafSpawner
                dc.b    0,   0
                dc.l    MHZMini_InitLeafSpawner
                dc.b    0,   0
                dc.l    MHZMini_LogSyncAndSubmitTouch
                dc.b    0,   0
MHZMinibossTree_SingleLogSimpleChild:
                dc.w    1-1
                dc.l    MHZMini_InitLogHeightAndMotion
MHZMinibossRoot_SingleThrownNormalChild:
                dc.w    1-1
                dc.l    MHZMini_ThrownActorDispatchAndDraw
                dc.b    0,  -8
MHZMini_RecoveryChild:
                dc.w    1-1
                dc.l    MHZMini_InitFlickerFollower
                dc.b    1, $13
MHZMinibossRoot_DefaultFrameDelayLoop:
                dc.b    0,  $B
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,  $B
                dc.b    2,   5
                dc.b    1,   5
                dc.b    $FC
MHZMini_ChopAnim:
                dc.b    4, $27
                dc.b    4, $27
                dc.b    7,   2
                dc.b    9,   2
                dc.b    $C,   2
                dc.b    $D, $3B
                dc.b    $B,   2
                dc.b    9,   2
                dc.b    7,   2
                dc.b    4, $27
                dc.b    $F4
MHZMini_StuckChopAnim:
                dc.b    4, $27
                dc.b    4, $27
                dc.b    7,   2
                dc.b    9,   2
                dc.b    $C,   2
                dc.b    $D, $27
                dc.b    $10,   3
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12, $31
                dc.b    $F4
MHZMini_RecoilAnim:
                dc.b    $A,   3
                dc.b    $A,   3
                dc.b    8,   3
                dc.b    6,   3
                dc.b    $F8, .jump-MHZMini_RecoilAnim

                .jump:
                dc.b    6, $7F
                dc.b    6, $7F
                dc.b    $FC
MHZMini_ThrowAnim:
                dc.b    $F, $31
                dc.b    $F, $31
                dc.b    $13,   4
                dc.b    $14,   4
                dc.b    $15,   4
                dc.b    $F4
MHZMinibossRoot_LongFrameFivePairLoop:
                dc.b    5, $7F
                dc.b    5, $7F
                dc.b    $FC
MHZMinibossLog_UniformRollingFrameLoop:
                dc.b    1,   0,   1,   2,   3,   4,   5,   6,   7, $FC
MHZMinibossThrownActor_FrameDelayLoop:
                dc.b    $18,   3
                dc.b    $19,   3
                dc.b    $1A,   3
                dc.b    $1B,   3
                dc.b    $1C,  $B
                dc.b    $FC
                even
Pal_MHZMiniboss:
                binclude "data/Levels/MHZ/Palettes/Miniboss.bin"
                even
PLC_MHZMiniboss_Explosion:  plrlistheader
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_MHZMiniboss_Explosion_End:

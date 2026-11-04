; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_HCZEndBoss:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,1,1)
                dc.w    $100
                dc.b    $2C, $1C,   0,   6
HCZBossS3_FixedPlateAttributes:
                dc.w    $200
                dc.b    $C,   4,   1,   0
HCZEndBossS3_Fan_PartialAttributeRecord:
                dc.w    $200
                dc.b    $1C,   4,   2,   0
HCZEndBossS3_Bomb_PartialAttributeRecord:
                dc.w    $200
                dc.b    $1C,   4,   6,   0
HCZBossS3_ColumnAttributes:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $14,  $C, $17,   0
HCZBossS3_VortexAttributes:
                dc.w    $80
                dc.b    $14, $30,  $D,   0
HCZBossS3_SurfaceEdgeAttributes:
                dc.w    0
                dc.b    $10,   4, $1A,   0
HCZBossS3_BombSplashAttributes:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $C,   8, $18,   0
HCZBossS3_GeyserLayerAttributes:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $100
                dc.b    $C, $10,   8,   0
HCZBossS3_ExplosionAttributes:
                dc.l    Map_Explosion
                dc.w    make_art_tile(ArtTile_Explosion,0,1)
                dc.w    $80
                dc.b    $C,  $C,   0, $8B
HCZEndBossS3_Bubble_FullAttributeRecord:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,0,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
HCZBossS3_ExitGeyserAttributes:
                dc.l    Map_HCZWaterWall
                dc.w    make_art_tile(ArtTile_HCZCutsceneGeyser,2,0)
                dc.w    $280
                dc.b    $20, $60,   1,   0
HCZBossS3_BodyAttachmentChildren:
                dc.w    5-1
                dc.l    HCZBossS3_BombDispatchAndDraw
                dc.b    $23, $12
                dc.l    HCZBossS3_BombDispatchAndDraw
                dc.b    $1B,  $A
                dc.l    HCZBossS3_BombDispatchAndDraw
                dc.b    $13,  $A
                dc.l    HCZBossS3_InitFixedPlate
                dc.b    0, $1C
                dc.l    HCZBossS3_FanDispatchFollowAndDraw
                dc.b    0, $24
HCZBossS3_ReplacementBombChild:
                dc.w    1-1
                dc.l    HCZBossS3_BombDispatchAndDraw
                dc.b    $13,  $A
; The Jawz enemy also uses this child record
HCZBossS3_ExplosionChild:
                dc.w    1-1
                dc.l    HCZBossS3_InitExplosion
                dc.b    0,   0
HCZEndBossS3_Fan_OneNormalColumnRecord:
                dc.w    1-1
                dc.l    HCZBossS3_ColumnDispatchSolidAndDraw
                dc.b    0,   0
HCZBossS3_ColumnVortexChild:
                dc.w    1-1
                dc.l    HCZBossS3_VortexDispatchAndDraw
                dc.b    0,   0
HCZEndBossS3_Surface_TwoNormalEdgeRecord:
                dc.w    2-1
                dc.l    HCZBossS3_InitSurfaceEdge
                dc.b    -4,   0
                dc.l    HCZBossS3_InitSurfaceEdge
                dc.b    4,   0
HCZBossS3_BombSplashChild:
                dc.w    1-1
                dc.l    HCZBossS3_InitBombSplashAtWater
                dc.b    0,   0
HCZBossS3_BombGeyserChildren:
                dc.w    5-1
                dc.l    HCZBossS3_InitGeyserLayerAndEdges
HCZBossS3_ColumnBubbleChildren:
                dc.w    $14-1
                dc.l    HCZBossS3_InitRandomColumnBubble
HCZEndBossS3_Root_OneNormalShipTwoRecord:
                dc.w    1-1
                dc.l    Obj_RobotnikShip2
                dc.b    0,  $C
HCZBossS3_ExitCoordinatorChild:
                dc.w    1-1
                dc.l    HCZBossS3_ExitQueueGeyserArt
HCZEndBossS3_Fan_AcceleratingRawStream:
                dc.b    7,   8,   2,   3,   4,   5, $FC
HCZEndBossS3_Fan_UniformActiveRawStream:
                dc.b    0,   2,   3,   4,   5, $FC
HCZEndBossS3_Fan_DeceleratingRawStream:
                dc.b    7,   2,   3,   4,   5, $FC
HCZBossS3_BombDetonationAnim:
                dc.b    5,   8,   6,   7, $FC
HCZBossS3_ColumnBuildAnim:
                dc.b    3, $17, $17, $22, $16, $21, $15, $20, $F4
HCZBossS3_ColumnTravelAnim:
                dc.b    3, $15, $20, $FC
HCZBossS3_VortexHeight0Anim:
                dc.b    3,  $D,  $F, $11, $FC
HCZBossS3_VortexHeight1Anim:
                dc.b    3, $24, $25, $26, $FC
HCZBossS3_VortexHeight2Anim:
                dc.b    3, $27, $28, $29, $FC
HCZBossS3_VortexHeight3Anim:
                dc.b    3, $2A, $2B, $2C, $FC
HCZBossS3_VortexHeight4And5Anim:
                dc.b    3, $2D, $2E, $2F, $FC
HCZBossS3_SurfaceEdgeAnim:
                dc.b    1, $1A, $23, $FC
HCZBossS3_BombSplashAnim:
                dc.b    $18,   2
                dc.b    $18,   2
                dc.b    $30,   3
                dc.b    $19,   4
                dc.b    $F4
HCZBossS3_GeyserLayer0Anim:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
HCZBossS3_GeyserLayer1Anim:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
HCZBossS3_GeyserLayer2Anim:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
HCZBossS3_GeyserLayer3Anim:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
HCZBossS3_GeyserLayer4Anim:
                dc.b    8,   0
                dc.b    8,   0
                dc.b    $1B,   0
                dc.b    9,   0
                dc.b    $1C,   0
                dc.b    $A,   0
                dc.b    $1D,   0
                dc.b    $B,   2
                dc.b    $1E,   2
                dc.b    $C,   3
                dc.b    $1F,   3
                dc.b    $F4
HCZEndBossS3_Explosion_UniformRawStream:
                dc.b    7,   0,   0,   1,   2,   3,   4, $F4
                even
Pal_HCZEndBoss:
                binclude "data/Levels/HCZ/Palettes/End Boss.bin"
                even

; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_HCZEndBoss:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,1,1)
                dc.w    $100
                dc.b    $2C, $1C,   0,   6
HCZBossSK_FixedPlateAttributes:
                dc.w    $200
                dc.b    $C,   4,   1,   0
HCZEndBossSK_Fan_PartialAttributeRecord:
                dc.w    $200
                dc.b    $1C,   4,   2,   0
HCZEndBossSK_Bomb_PartialAttributeRecord:
                dc.w    $200
                dc.b    $1C,   4,   6,   0
HCZBossSK_ColumnAttributes:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $14,  $C, $17,   0
HCZBossSK_VortexAttributes:
                dc.w    $80
                dc.b    $14, $30,  $D,   0
HCZBossSK_SurfaceEdgeAttributes:
                dc.w    0
                dc.b    $10,   4, $1A,   0
HCZBossSK_BombSplashAttributes:
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $80
                dc.b    $C,   8, $18,   0
HCZBossSK_GeyserLayerAttributes:
                dc.l    Map_HCZEndBoss
                dc.w    make_art_tile(ArtTile_HCZEndBoss,0,1)
                dc.w    $100
                dc.b    $C, $10,   8,   0
HCZBossSK_ExplosionAttributes:
                dc.l    Map_Explosion
                dc.w    make_art_tile(ArtTile_Explosion,0,1)
                dc.w    $80
                dc.b    $C,  $C,   0, $8B
HCZEndBossSK_Bubble_FullAttributeRecord:
                dc.l    Map_Bubbler
                dc.w    make_art_tile(ArtTile_Bubbles,0,1)
                dc.w    $280
                dc.b    $10, $10,   0,   0
HCZBossSK_ExitGeyserAttributes:
                dc.l    Map_HCZWaterWall
                dc.w    make_art_tile(ArtTile_HCZCutsceneGeyser,2,0)
                dc.w    $280
                dc.b    $20, $60,   1,   0
HCZBossSK_BodyAttachmentChildren:
                dc.w    5-1
                dc.l    HCZBossSK_BombDispatchAndDraw
                dc.b    $23, $12
                dc.l    HCZBossSK_BombDispatchAndDraw
                dc.b    $1B,  $A
                dc.l    HCZBossSK_BombDispatchAndDraw
                dc.b    $13,  $A
                dc.l    HCZBossSK_InitFixedPlate
                dc.b    0, $1C
                dc.l    HCZBossSK_FanDispatchFollowAndDraw
                dc.b    0, $24
HCZBossSK_ReplacementBombChild:
                dc.w    1-1
                dc.l    HCZBossSK_BombDispatchAndDraw
                dc.b    $13,  $A
; The Jawz enemy also uses this child record
HCZBossSK_ExplosionChild:
                dc.w    1-1
                dc.l    HCZBossSK_InitExplosion
                dc.b    0,   0
HCZEndBossSK_Fan_OneNormalColumnRecord:
                dc.w    1-1
                dc.l    HCZBossSK_ColumnDispatchSolidAndDraw
                dc.b    0,   0
HCZBossSK_ColumnVortexChild:
                dc.w    1-1
                dc.l    HCZBossSK_VortexDispatchAndDraw
                dc.b    0,   0
HCZEndBossSK_Surface_TwoNormalEdgeRecord:
                dc.w    2-1
                dc.l    HCZBossSK_InitSurfaceEdge
                dc.b    -4,   0
                dc.l    HCZBossSK_InitSurfaceEdge
                dc.b    4,   0
HCZBossSK_BombSplashChild:
                dc.w    1-1
                dc.l    HCZBossSK_InitBombSplashAtWater
                dc.b    0,   0
HCZBossSK_BombGeyserChildren:
                dc.w    5-1
                dc.l    HCZBossSK_InitGeyserLayerAndEdges
HCZBossSK_ColumnBubbleChildren:
                dc.w    $14-1
                dc.l    HCZBossSK_InitRandomColumnBubble
HCZEndBossSK_Root_OneNormalShipTwoRecord:
                dc.w    1-1
                dc.l    Obj_RobotnikShip2
                dc.b    0,  $C
HCZEndBossSK_Fan_AcceleratingRawStream:
                dc.b    7,   8,   2,   3,   4,   5, $FC
HCZEndBossSK_Fan_UniformActiveRawStream:
                dc.b    0,   2,   3,   4,   5, $FC
HCZEndBossSK_Fan_DeceleratingRawStream:
                dc.b    7,   2,   3,   4,   5, $FC
HCZBossSK_BombDetonationAnim:
                dc.b    5,   8,   6,   7, $FC
HCZBossSK_ColumnBuildAnim:
                dc.b    3, $17, $17, $22, $16, $21, $15, $20, $F4
HCZBossSK_ColumnTravelAnim:
                dc.b    3, $15, $20, $FC
HCZBossSK_VortexHeight0Anim:
                dc.b    3,  $D,  $F, $11, $FC
HCZBossSK_VortexHeight1Anim:
                dc.b    3, $24, $25, $26, $FC
HCZBossSK_VortexHeight2Anim:
                dc.b    3, $27, $28, $29, $FC
HCZBossSK_VortexHeight3Anim:
                dc.b    3, $2A, $2B, $2C, $FC
HCZBossSK_VortexHeight4And5Anim:
                dc.b    3, $2D, $2E, $2F, $FC
HCZBossSK_SurfaceEdgeAnim:
                dc.b    1, $1A, $23, $FC
HCZBossSK_BombSplashAnim:
                dc.b    $18,   2
                dc.b    $18,   2
                dc.b    $30,   3
                dc.b    $19,   4
                dc.b    $F4
HCZBossSK_GeyserLayer0Anim:
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
HCZBossSK_GeyserLayer1Anim:
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
HCZBossSK_GeyserLayer2Anim:
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
HCZBossSK_GeyserLayer3Anim:
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
HCZBossSK_GeyserLayer4Anim:
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
HCZEndBossSK_Explosion_UniformRawStream:
                dc.b    7,   0,   0,   1,   2,   3,   4, $F4
                even
Pal_HCZEndBoss:
                binclude "data/Levels/HCZ/Palettes/End Boss.bin"
                even

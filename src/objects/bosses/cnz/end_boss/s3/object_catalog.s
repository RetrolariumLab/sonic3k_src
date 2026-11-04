; Owner: objects/bosses/cnz/end_boss/s3
; Responsibility: Carnival Night end-boss object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_CNZEndBoss:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $280
                dc.b    $40, $14,   0,   6
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $280
                dc.b    $20, $20,   5,   0
CNZBossCore_Attributes:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $280
                dc.b    $10, $10,   4, $8B
CNZBossCoreFragment_PartialAttributes:
                dc.w    $280
                dc.b    8, $10,  $A,   0
CNZBossShellFragment_PartialAttributes:
                dc.w    $280
                dc.b    $14, $14,   0,   0
CNZBossMagnet_Attributes:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $200
                dc.b    8, $10,   1, $9E
CNZBossElectricEffect_Attributes:
                dc.l    Map_CNZEndBoss
                dc.w    make_art_tile(ArtTile_CNZEndBoss,1,0)
                dc.w    $80
                dc.b    $10, $40,   6, $AB
CNZEndBoss_CoreChildRecord:
                dc.w    1-1
                dc.l    CNZBossCore_DispatchStateAndHandleDefeat
                dc.b    0, $14
CNZEndBoss_RepeatedMagnetChildRecord:
                dc.w    4-1
                dc.l    CNZBossS3_OrbitDispatchAndMove
                dc.b    0,   8
CNZBossMagnet_ElectricChildRecord:
                dc.w    1-1
                dc.l    CNZBossElectricEffect_Initialize
                dc.b    0, $4C
CNZEndBoss_ElectricPairChildRecords:
                dc.w    2-1
                dc.l    CNZBossElectricEffect_Initialize
                dc.b    -$C, $54
                dc.l    CNZBossElectricEffect_Initialize
                dc.b    $C, $54
CNZBossCore_FragmentChildRecords:
                dc.w    2-1
                dc.l    CNZBossCoreFragment_Initialize
                dc.b    -8,   0
                dc.l    CNZBossCoreFragment_Initialize
                dc.b    8,   0
CNZEndBoss_ShellFragmentChildRecords:
                dc.w    2-1
                dc.l    CNZBossShellFragment_InitializeAndDraw
                dc.b    -$14,   0
                dc.l    CNZBossShellFragment_InitializeAndDraw
                dc.b    $14,   0
CNZBossMagnet_RawFrameDelayScript:
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    3,   0
                dc.b    1,   4
                dc.b    3,   0
                dc.b    1,   9
                dc.b    $FC
CNZBossCore_RawFrameDelayScript:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    4,   4
                dc.b    5,   0
                dc.b    4,   9
                dc.b    $FC
CNZBossS3_CallbackAnimation:
                dc.b    0,   9,   6,   9,   7, $F4
CNZBossS3_LegacyShortDelayAnim:
                dc.b    9, $1F
                dc.b    6,   0
                dc.b    9,   2
                dc.b    7,   0
                dc.b    $FC
CNZBossS3_LegacyLongDelayAnim:
                dc.b    9, $24
                dc.b    6,   0
                dc.b    9,   2
                dc.b    7,   0
                dc.b    $FC
                dc.b    7,   0,   1, $FC
                even
Pal_CNZEndBoss:
                binclude "data/Levels/CNZ/Palettes/End Boss.bin"
                even

; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss attributes, child creation, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_MHZEndBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $20, $20,  $A,   0
MHZEndBoss_VisualOverlayFullAttributes:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,0)
                dc.w    $280
                dc.b    $80, $80,   1,   0
MHZEndBoss_WeatherMachineFullAttributes:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,0)
                dc.w    $200
                dc.b    $80, $80,   4, $11
MHZEndBoss_ShieldSpikeFullAttributes:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,0,0)
                dc.w    $200
                dc.b    $10, $10, $11, $8B
MHZBoss_WeatherPairAttributes:
                dc.w    $180
                dc.b    $10, $10,   5,   0
MHZBoss_DiagonalEffectAttributes:
                dc.w    $180
                dc.b    $80, $80,  $E,   0
MHZBoss_TouchProxyAttributes:
                dc.w    $200
                dc.b    $18, $28,   0, $25
MHZEndBoss_BreakupFragmentFullAttributes:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,1)
                dc.w    $80
                dc.b    $80, $80,   0,   0
MHZBoss_LayeredOverlayChildren:
                dc.w    2-1
                dc.l    MHZBoss_InitLayeredOverlay
MHZBoss_PriorityOverlayChild:
                dc.w    1-1
                dc.l    MHZBoss_InitPriorityOverlay
MHZBoss_SpikeWeatherProxyChildren:
                dc.w    4-1
                dc.l    MHZBoss_InitShieldSpike
                dc.b    -$14, $18
                dc.l    MHZBoss_InitShieldSpike
                dc.b    -$2C, $18
                dc.l    MHZBoss_InitWeatherMachine
                dc.b    $11,-$51
                dc.l    MHZBoss_InitPairedTouchProxy
                dc.b    $21,-$10
MHZEndBoss_RobotnikHeadNormalRecord:
                dc.w    1-1
                dc.l    Obj_RobotnikHead4
                dc.b    0,-$1C
MHZBoss_WeatherPairChildren:
                dc.w    2-1
                dc.l    MHZBoss_InitWeatherPairEffect
MHZBoss_DiagonalEffectChildren:
                dc.w    4-1
                dc.l    MHZBoss_InitDiagonalWeatherEffect
MHZBoss_BreakupFragmentChildren:
                dc.w    6-1
                dc.l    MHZBoss_InitBreakupFragment
MHZEndBoss_WeatherPrimaryFrameDelayLoop:
                dc.b    5,   1
                dc.b    6,   3
                dc.b    7,   5
                dc.b    8,   7
                dc.b    0,   9
                dc.b    $FC
MHZBoss_WeatherPairAnim:
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    $B,   1
                dc.b    $C,   1
                dc.b    $FC
MHZBoss_DiagonalEffectAnim:
                dc.b    1,  $D,  $E,  $F, $10, $FC
                even
Pal_MHZEndBoss:
                binclude "data/Levels/MHZ/Palettes/End Boss.bin"
                even
MHZEndBoss_CameraTriggerAndTargetBounds:
                dc.w    0,  $300, $3AA0, $3D90
                dc.w    $280,  $280, $3C90, $3C90
PLC_MHZEndBoss_Explosion:   plrlistheader
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
                plreq   ArtTile_Explosion, ArtNem_Explosion
PLC_MHZEndBoss_Explosion_End:

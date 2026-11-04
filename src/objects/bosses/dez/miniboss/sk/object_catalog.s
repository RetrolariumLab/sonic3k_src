; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss attributes, child construction, animation, palette and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_DEZMiniboss:
                dc.l    Map_DEZMiniboss
                dc.w    make_art_tile(ArtTile_DEZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
DEZMinibossEye_PartialAttributes:
                dc.w    $200
                dc.b    $C,  $C,   2, $17
DEZMinibossOrbitHazard_PartialAttributes:
                dc.w    $180
                dc.b    $10, $10, $15, $86
DEZMini_RadialShotAttributes:
                dc.w    $100
                dc.b    4,   4, $15, $98
DEZMini_RandomDebrisAttributes:
                dc.w    $80
                dc.b    8,   8, $12,   0
DEZMini_DelayedSideDebrisAttributes:
                dc.w    $180
                dc.b    $10, $18, $11,   0
DEZMini_OrbitPlatformAttributes:
                dc.w    $300
                dc.b    $18, $10,   1,   0
DEZMini_PlatformContactAttributes:
                dc.w    $280
                dc.b    $18,   4,  $B, $9E
DEZMini_BeamControllerAttributes:
                dc.w    $380
                dc.b    $10, $80,   6,   0
DEZMini_BeamSideDetailAttributes:
                dc.w    $300
                dc.b    8,   4,   8,   0
DEZMini_DefeatFragmentAttributes:
                dc.w    $100
                dc.b    $10, $14, $23,   0
DEZMinibossEye_NormalChildRecord:
                dc.w    1-1
                dc.l    DEZMinibossEye_DispatchAndDrawOrFlicker
                dc.b    0,  -4
DEZMini_OrbitHazardChild:
                dc.w    8-1
                dc.l    DEZMinibossOrbitHazard_Initialize
DEZMini_RadialShotChild:
                dc.w    8-1
                dc.l    DEZMini_InitRadialShot
DEZMini_RandomDebrisChild:
                dc.w    1-1
                dc.l    DEZMini_InitRandomDebris
DEZMini_DelayedSideDebrisChildren:
                dc.w    2-1
                dc.l    DEZMini_InitDelayedSideDebris
                dc.b    -$28,   0
                dc.l    DEZMini_InitDelayedSideDebris
                dc.b    $28,   0
DEZMini_OrbitPlatformChildren:
                dc.w    1
                dc.l    DEZMini_InitPlatformSeparation
DEZMini_PlatformContactChild:
                dc.w    1-1
                dc.l    DEZMinibossPlatformContact_Initialize
                dc.b    0,   4
DEZMini_BeamControllerChild:
                dc.w    1-1
                dc.l    DEZMinibossBeam_InitializeExtension
                dc.b    0, $1E
DEZMini_BeamSideDetailChild:
                dc.w    2-1
                dc.l    DEZMini_InitBeamEndAndSide
DEZMini_DefeatFragmentChildren:
                dc.w    4-1
                dc.l    DEZMini_InitDefeatFragment
                dc.b    -$10,   0
                dc.l    DEZMini_InitDefeatFragment
                dc.b    $10,   0
                dc.l    DEZMini_InitDefeatFragment
                dc.b    -$C, $18
                dc.l    DEZMini_InitDefeatFragment
                dc.b    $C, $18
DEZMini_PlatformContactAnim:
                dc.b    1,  $B,  $C,  $D,  $E,  $F, $10, $FC
DEZMini_BeamSideDetailAnim:
                dc.b    0,   8,   7,   9,   7,  $A,   7, $FC
                even
Pal_DEZMiniboss1:
                binclude "data/Levels/DEZ/Palettes/Miniboss 1.bin"
                even
Pal_DEZMiniboss2:
                binclude "data/Levels/DEZ/Palettes/Miniboss 2.bin"
                even
DEZMini_FormTwoHitPaletteScript:    palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$16, 3, 11-1
                .data:  palscriptdata 8, $66A, $448, $226
                palscriptdata 8, $66C, $44A, $228
                palscriptdata 8, $66A, $448, $226
                palscriptdata 8, $666, $444, $222
                palscriptrun

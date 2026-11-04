; Owner: objects/bosses/lrz/miniboss/sk
; Responsibility: Lava Reef miniboss object attributes, child creation, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_LRZMiniboss:
                dc.l    Map_LRZMiniboss
                dc.w    make_art_tile(ArtTile_LRZMiniboss,1,1)
                dc.w    0
                dc.b    $30, $80,   1,   0
LRZMini_ArmBaseAndMiddleAttributes:
                dc.w    0
                dc.b    8,   8,   8,   0
LRZMinibossArmTerminal_PartialAttributes:
                dc.w    0
                dc.b    $10, $10,   6,   6
LRZMini_ArmShotAttributes:
                dc.w    0
                dc.b    4,   4,   9, $98
LRZMini_ArmHitOverlayAttributes:
                dc.w    0
                dc.b    $10, $10,  $A,   0
LRZMinibossRootDebris_PartialAttributes:
                dc.w    $80
                dc.b    $18, $14,  $C,   0
LRZMinibossLeftArm_TwelveLinkTreeRecord:
                dc.w    $C-1
                dc.l    LRZMini_ChooseArmLinkInitializer
LRZMinibossRightArm_TwelveLinkTreeRecord:
                dc.w    $C-1
                dc.l    LRZMini_InitRightArmChain
LRZMini_ArmShotChild:
                dc.w    1-1
                dc.l    LRZMini_InitArmShot
                dc.b    8,   0
LRZMini_ArmHitOverlayChild:
                dc.w    1-1
                dc.l    LRZMini_InitArmHitOverlay
LRZMini_DefeatDebrisChildren:
                dc.w    $B-1
                dc.l    LRZMini_InitDefeatDebris
                dc.b    0, -$C
                dc.l    LRZMini_InitDefeatDebris
                dc.b    -$19, -$C
                dc.l    LRZMini_InitDefeatDebris
                dc.b    $19, -$C
                dc.l    LRZMini_InitDefeatDebris
                dc.b    -$C, $22
                dc.l    LRZMini_InitDefeatDebris
                dc.b    $C, $22
                dc.l    LRZMini_InitDefeatDebris
                dc.b    -8, $36
                dc.l    LRZMini_InitDefeatDebris
                dc.b    8, $36
                dc.l    LRZMini_InitDefeatDebris
                dc.b    -$12,   4
                dc.l    LRZMini_InitDefeatDebris
                dc.b    $12,   4
                dc.l    LRZMini_InitDefeatDebris
                dc.b    -$12,  $C
                dc.l    LRZMini_InitDefeatDebris
                dc.b    $12,  $C
LRZMinibossRoot_RiseFrameDelayLoop:
                dc.b    5,   0
                dc.b    5,   5
                dc.b    4,   1
                dc.b    3,   2
                dc.b    2,   3
                dc.b    1, $7F
                dc.b    1, $7F
                dc.b    $FC
LRZMini_SlamImpactAnim:
                dc.b    3,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    $F4
LRZMinibossRoot_RetractionFrameDelayLoop:
                dc.b    4,   3
                dc.b    4,   3
                dc.b    3,   3
                dc.b    2,   3
                dc.b    1, $7F
                dc.b    1, $7F
                dc.b    $FC
LRZMinibossArmTerminal_UniformFrameLoop:
                dc.b    1,   6,   7,  $B, $FC
                even
Pal_LRZMiniboss1:
                binclude "data/Levels/LRZ/Palettes/Miniboss 1.bin"
                even
Pal_LRZMiniboss2:
                binclude "data/Levels/LRZ/Palettes/Miniboss 2.bin"
                even
Pal_LRZMiniboss3:
                binclude "data/Levels/LRZ/Palettes/Miniboss 3.bin"
                even
LRZMini_CompletionPaletteScript:    palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_3+$02, 5, 2-1
                .data:  palscriptdata 4, $0EE, $0AE, $06E, $00E, $00A
                palscriptdata 4, $0CC, $08C, $04A, $00A, $008
                palscriptdata 4, $0AA, $06A, $026, $028, $006
                palscriptdata 4, $0CC, $08C, $04A, $00A, $008
                palscriptdata 16,$0EE, $0AE, $06E, $00E, $00A
                palscriptdata 4, $0CC, $0AC, $06C, $00C, $208
                palscriptdata 4, $0CC, $08C, $06C, $22A, $226
                palscriptdata 4, $0AA, $28A, $24A, $228, $224
                palscriptdata 4, $288, $268, $248, $424, $222
                palscriptdata 4, $266, $246, $226, $422, $222
                palscriptdata 4, $266, $244, $224, $422, $222
                palscriptdata 4, $244, $222, $224, $422, $222
                palscriptdata 8, $222, $222, $224, $422, $222
                palscriptrun

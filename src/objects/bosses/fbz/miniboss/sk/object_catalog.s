; Owner: objects/bosses/fbz/miniboss/sk
; Responsibility: Flying Battery miniboss object attributes, child records and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_FBZMiniboss:
                dc.l    Map_FBZMiniboss
                dc.w    make_art_tile(ArtTile_FBZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
FBZMiniSK_TrimAttributes:
                dc.w    $100
                dc.b    8,   8,   1,   0
FBZMiniSK_ArmRootAttributes:
                dc.w    $300
                dc.b    $18, $10,   5,   0
FBZMiniSK_LinkAttributes:
                dc.w    $280
                dc.b    8,   8,   6,   0
FBZMiniSK_HandAttributes:
                dc.w    $200
                dc.b    $18, $18,   7,   0
FBZMiniSK_EyeAttributes:
                dc.w    $100
                dc.b    $10,   8,   8,   0
FBZMiniSK_WarningAttributes:
                dc.w    $180
                dc.b    $10,   8, $11,   0
FBZMiniSK_TopButtonAttributes:                          ; used in S3, unused in S&K
                dc.w    $280
                dc.b    $10,   8,   4,   0
FBZMiniSK_UnusedCapsuleAttributes:                      ; unused
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $100
                dc.b    8,   8,   0,   0
FBZMiniSK_MainBodyChildren:
                dc.w    7-1
                dc.l    FBZMiniSK_TrimDispatchAndDraw
                dc.b    -$10,  -8
                dc.l    FBZMiniSK_TrimDispatchAndDraw
                dc.b    $10,  -8
                dc.l    FBZMiniSK_TrimDispatchAndDraw
                dc.b    0,  -8
                dc.l    FBZMiniSK_ButtonDispatchSolidAndCull
                dc.b    0,-$24
                dc.l    FBZMiniSK_EyeDispatchAndDraw
                dc.b    0,  -8
                dc.l    FBZMiniSK_ArmDispatchAndDraw
                dc.b    0,   0
                dc.l    FBZMiniSK_ArmDispatchAndDraw
                dc.b    0,   0
FBZMiniSK_LinkedArmChildren:
                dc.w    5-1
                dc.l    FBZMiniSK_LinkDispatchAndDraw
FBZMiniSK_PaletteWarningChild:
                dc.w    1-1
                dc.l    FBZMiniSK_InitPaletteWarning
                dc.b    0,  -8
FBZMiniSK_ReleasedBodyChild:
                dc.w    1-1
                dc.l    FBZMiniSK_InitReleasedBody
                dc.b    3,   9,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
                even
Pal_FBZMiniboss:
                binclude "data/Levels/FBZ/Palettes/FBZ Miniboss.bin"
                even
FBZMiniSK_WarningPaletteScript: palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$1E, 1, 7-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 4, $644
                palscriptrun

Map_FBZMiniboss:
                include "src/objects/shared/zones/fbz/mappings/miniboss.s"
; ---------------------------------------------------------------------------
FBZMiniSK_ActTwoArenaCameraBounds:
                dc.w    $560,  $660, $2900, $2C00
                dc.w    $5E0,  $5E0, $2900, $2900

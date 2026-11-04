; Owner: objects/bosses/fbz/miniboss/s3
; Responsibility: Flying Battery miniboss object attributes, child records and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_FBZMiniboss:
                dc.l    Map_FBZMiniboss
                dc.w    make_art_tile(ArtTile_FBZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
FBZMiniS3_TrimAttributes:
                dc.w    $100
                dc.b    8,   8,   1,   0
FBZMiniS3_ArmRootAttributes:
                dc.w    $300
                dc.b    $18, $10,   5,   0
FBZMiniS3_LinkAttributes:
                dc.w    $280
                dc.b    8,   8,   6,   0
FBZMiniS3_HandAttributes:
                dc.w    $200
                dc.b    $18, $18,   7,   0
FBZMiniS3_EyeAttributes:
                dc.w    $100
                dc.b    $10,   8,   8,   0
FBZMiniS3_WarningAttributes:
                dc.w    $180
                dc.b    $10,   8, $11,   0
FBZMiniS3_TopButtonAttributes:
                dc.w    $280
                dc.b    $10,   8,   4,   0
FBZMiniS3_UnusedCapsuleAttributes:                      ; unused
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $100
                dc.b    8,   8,   0,   0
FBZMiniS3_ReleasedBodyAttributes:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule-$46,0,1)
                dc.w    $200
                dc.b    $20, $20,   1,   0
FBZMiniS3_MainBodyChildren:
                dc.w    7-1
                dc.l    FBZMiniS3_TrimDispatchAndDraw
                dc.b    -$10,  -8
                dc.l    FBZMiniS3_TrimDispatchAndDraw
                dc.b    $10,  -8
                dc.l    FBZMiniS3_TrimDispatchAndDraw
                dc.b    0,  -8
                dc.l    FBZMiniS3_ButtonDispatchSolidAndCull
                dc.b    0,-$28
                dc.l    FBZMiniS3_EyeDispatchAndDraw
                dc.b    0,  -8
                dc.l    FBZMiniS3_ArmDispatchAndDraw
                dc.b    0,   0
                dc.l    FBZMiniS3_ArmDispatchAndDraw
                dc.b    0,   0
FBZMiniS3_LinkedArmChildren:
                dc.w    5-1
                dc.l    FBZMiniS3_LinkDispatchAndDraw
FBZMiniS3_PaletteWarningChild:
                dc.w    1-1
                dc.l    FBZMiniS3_InitPaletteWarning
                dc.b    0,  -8
FBZMiniS3_ReleasedBodyChild:
                dc.w    1-1
                dc.l    FBZMiniS3_InitReleasedBody
FBZMiniS3_FreedAnimalChildren:
                dc.w    5-1
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    0,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $1C,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$1C,  -4
                dc.b    3,   9,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
                even
Pal_FBZMiniboss:
                binclude "data/Levels/FBZ/Palettes/S3 Miniboss.bin"
                even
FBZMiniS3_WarningPaletteScript: palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$1E, 1, 7-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 4, $644
                palscriptrun

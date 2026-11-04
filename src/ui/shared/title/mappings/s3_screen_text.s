; Data owner: ui/shared/title
; Provenance and source range: config/reconstruction/source_layout.json
Map_TitleScreenText_:
                dc.w    SharedTitleText_FirstMenuOptionPieces-Map_TitleScreenText_
                dc.w    SharedTitleText_SecondMenuOptionPieces-Map_TitleScreenText_
                dc.w    S3Title_LevelSelectionTextMap-Map_TitleScreenText_
                dc.w    SharedTitleText_CopyrightPieces-Map_TitleScreenText_
SharedTitleText_FirstMenuOptionPieces:  dc.w    7
                dc.b    0,  $C, $20,   0,   0,   0
                dc.b    0,  $C, $20,   4,   0, $20
                dc.b    0,  $C, $20,   8,   0, $40
                dc.b    $10,  $C,   0,  $C,   0,   0
                dc.b    $10,  $C,   0, $10,   0, $20
                dc.b    $10,  $C,   0, $14,   0, $40
                dc.b    0,   4, $20, $24, $FF, $EC
SharedTitleText_SecondMenuOptionPieces: dc.w    7
                dc.b    0,  $C,   0,   0,   0,   0
                dc.b    0,  $C,   0,   4,   0, $20
                dc.b    0,  $C,   0,   8,   0, $40
                dc.b    $10,  $C, $20,  $C,   0,   0
                dc.b    $10,  $C, $20, $10,   0, $20
                dc.b    $10,  $C, $20, $14,   0, $40
                dc.b    $10,   4, $20, $24, $FF, $EC
S3Title_LevelSelectionTextMap:  dc.w    4
                dc.b    8,  $C, $20, $18,   0,   0
                dc.b    8,  $C, $20, $1C,   0, $20
                dc.b    8,  $C, $20, $20,   0, $40
                dc.b    8,   4, $20, $24, $FF, $EC
SharedTitleText_CopyrightPieces:    dc.w    3
                dc.b    0,   0,   0, $26,   0,   0
                dc.b    0,  $C,   0, $27,   0, $10
                dc.b    0,  $C,   0, $2B,   0, $38

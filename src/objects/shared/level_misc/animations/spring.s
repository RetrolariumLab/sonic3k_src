; Data owner: objects/shared/level_misc
; Provenance and source range: config/reconstruction/source_layout.json
Ani_Spring_:
                dc.w    SpringAnimation_VerticalIdle-Ani_Spring_
                dc.w    SpringAnimation_VerticalLaunch-Ani_Spring_
                dc.w    SpringAnimation_HorizontalIdle-Ani_Spring_
                dc.w    SpringAnimation_HorizontalLaunch-Ani_Spring_
                dc.w    SpringAnimation_DiagonalIdle-Ani_Spring_
                dc.w    SpringAnimation_DiagonalLaunch-Ani_Spring_
SpringAnimation_VerticalIdle:   dc.b    $F,   0, $FF
SpringAnimation_VerticalLaunch: dc.b    0,   1,   0,   0,   2,   2,   2,   2,   2,   2, $FD,   0

SpringAnimation_HorizontalIdle:     dc.b    $F,   3, $FF
SpringAnimation_HorizontalLaunch:   dc.b    0,   4,   3,   3,   5,   5,   5,   5,   5,   5, $FD,   2

SpringAnimation_DiagonalIdle:   dc.b    $F,   7, $FF
SpringAnimation_DiagonalLaunch: dc.b    0,   8,   7,   7,   9,   9,   9,   9,   9,   9, $FD,   4
                even

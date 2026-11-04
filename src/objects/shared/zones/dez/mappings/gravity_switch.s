; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZGravitySwitch_:
                dc.w    DEZMap_GravitySwitch_RestFourPieces-Map_DEZGravitySwitch_
                dc.w    DEZMap_GravitySwitch_PressedTwoPieces-Map_DEZGravitySwitch_
DEZMap_GravitySwitch_RestFourPieces:    dc.w    4
                dc.b    $F8,   4,   0,   0, $FF, $F0
                dc.b    $F8,   4,   8,   0,   0,   0
                dc.b    0,   4,   0,   2, $FF, $F0
                dc.b    0,   4,   8,   2,   0,   0
DEZMap_GravitySwitch_PressedTwoPieces:  dc.w    2
                dc.b    $F8,   4,   0,   0, $FF, $F0
                dc.b    $F8,   4,   8,   0,   0,   0

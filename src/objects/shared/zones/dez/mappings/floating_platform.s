; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZFloatingPlatform_:
                dc.w    DEZMap_FloatingPlatform_TwoPiecePhase-Map_DEZFloatingPlatform_
                dc.w    DEZFloatPlatMap_WithCenterPiece-Map_DEZFloatingPlatform_
DEZMap_FloatingPlatform_TwoPiecePhase:  dc.w    2
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   8,   0,   0,   0
DEZFloatPlatMap_WithCenterPiece:    dc.w    3
                dc.b    $FC,   8,   0, $10, $FF, $F4
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   8,   0,   0,   0

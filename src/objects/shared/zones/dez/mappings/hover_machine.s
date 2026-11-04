; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZHoverMachine_:
                dc.w    DEZMap_HoverMachine_RootPhaseZero-Map_DEZHoverMachine_
                dc.w    DEZMap_HoverMachine_RootPhaseOne-Map_DEZHoverMachine_
                dc.w    DEZHoverMap_FieldActor-Map_DEZHoverMachine_
DEZMap_HoverMachine_RootPhaseZero:  dc.w    2
                dc.b    $F8,  $E, $10,   0, $FF, $F0
                dc.b    $F0,   4, $10,  $C, $FF, $F8
DEZMap_HoverMachine_RootPhaseOne:   dc.w    2
                dc.b    $F8,  $E, $10,   0, $FF, $F0
                dc.b    $F0,   4, $10, $1E, $FF, $F8
DEZHoverMap_FieldActor: dc.w    1
                dc.b    $F0,  $F,   0,  $E, $FF, $F0

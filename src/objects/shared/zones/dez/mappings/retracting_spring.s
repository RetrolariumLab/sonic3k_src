; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZRetractingSpring_:
                dc.w    DEZMap_RetractingSpring_IdleThreePieces-Map_DEZRetractingSpring_
                dc.w    DEZRetractSpringMap_LaunchStart-Map_DEZRetractingSpring_
                dc.w    DEZRetractSpringMap_LaunchExtended-Map_DEZRetractingSpring_
DEZMap_RetractingSpring_IdleThreePieces:    dc.w    3
                dc.b    0,  $D,   0,   0, $FF, $F0
                dc.b    $F0,  $C, $E1, $72, $FF, $F0
                dc.b    $F8,   4, $E1, $7A, $FF, $F8
DEZRetractSpringMap_LaunchStart:    dc.w    2
                dc.b    0,  $D,   0,   0, $FF, $F0
                dc.b    $F8,  $C, $E1, $72, $FF, $F0
DEZRetractSpringMap_LaunchExtended: dc.w    3
                dc.b    0,  $D,   0,   0, $FF, $F0
                dc.b    $E0,  $C, $E1, $72, $FF, $F0
                dc.b    $E8,   6, $E1, $7C, $FF, $F8

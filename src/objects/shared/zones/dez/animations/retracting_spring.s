; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Ani_DEZRetractingSpring_:
                dc.w    DEZAni_RetractingSpring_IdleZeroLoop-Ani_DEZRetractingSpring_
                dc.w    DEZRetractSpringAni_LaunchThenIdle-Ani_DEZRetractingSpring_
DEZAni_RetractingSpring_IdleZeroLoop:   dc.b    $F,   0, $FF
DEZRetractSpringAni_LaunchThenIdle:     dc.b    0,   1,   0,   0,   2,   2,   2,   2,   2,   2, $FD,   0
                even

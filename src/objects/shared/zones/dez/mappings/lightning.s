; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZLightning_:
                dc.w    DEZMap_Lightning_BlankBetweenPulses-Map_DEZLightning_
                dc.w    DEZMap_Lightning_PulsePhaseOne-Map_DEZLightning_
                dc.w    DEZMap_Lightning_PulsePhaseTwo-Map_DEZLightning_
                dc.w    DEZMap_Lightning_TouchQueuedPhaseThree-Map_DEZLightning_
                dc.w    DEZMap_Lightning_PulsePhaseFour-Map_DEZLightning_
DEZMap_Lightning_BlankBetweenPulses:    dc.w    0
DEZMap_Lightning_PulsePhaseOne:         dc.w    1
                dc.b    $E8,   5,   0,   0, $FF, $F8
DEZMap_Lightning_PulsePhaseTwo: dc.w    1
                dc.b    $E8,   7,   0,   4, $FF, $F8
DEZMap_Lightning_TouchQueuedPhaseThree: dc.w    2
                dc.b    $E8,   5,   8,   0, $FF, $F8
                dc.b    $F8,   7,   8,   4, $FF, $F8
DEZMap_Lightning_PulsePhaseFour:    dc.w    2
                dc.b    $E8,   5,   0,   0, $FF, $F8
                dc.b    $F8,   7,   0,   4, $FF, $F8

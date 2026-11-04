; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZRotatingPlatform_:
                dc.w    SSZMap_RotatingPlatform_CycleFirstPhase-Map_SSZRotatingPlatform_
                dc.w    SSZMap_RotatingPlatform_CycleSecondPhase-Map_SSZRotatingPlatform_
                dc.w    SSZMap_RotatingPlatform_CycleThirdPhase-Map_SSZRotatingPlatform_
SSZMap_RotatingPlatform_CycleFirstPhase:    dc.w    2
                dc.b    $E0,  $B,   0,   0, $FF, $F4
                dc.b    0,  $B, $10,   0, $FF, $F4
SSZMap_RotatingPlatform_CycleSecondPhase:   dc.w    2
                dc.b    $E0,  $B,   0,  $C, $FF, $F4
                dc.b    0,  $B, $10,  $C, $FF, $F4
SSZMap_RotatingPlatform_CycleThirdPhase:    dc.w    2
                dc.b    $E0,  $B,   0, $18, $FF, $F4
                dc.b    0,  $B, $10, $18, $FF, $F4

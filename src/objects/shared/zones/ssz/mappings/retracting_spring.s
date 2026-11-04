; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZRetractingSpring_:
                dc.w    SSZMap_RetractingSpring_RetractedBlank-Map_SSZRetractingSpring_
                dc.w    SSZMap_RetractingSpring_FirstExtension-Map_SSZRetractingSpring_
                dc.w    SSZMap_RetractingSpring_SecondExtension-Map_SSZRetractingSpring_
                dc.w    SSZRetractSpringMap_ExtendedAndRest-Map_SSZRetractingSpring_
                dc.w    SSZRetractSpringMap_PrelaunchCompression-Map_SSZRetractingSpring_
                dc.w    SSZMap_RetractingSpring_LaunchRecovery-Map_SSZRetractingSpring_
SSZMap_RetractingSpring_RetractedBlank: dc.w    0
SSZMap_RetractingSpring_FirstExtension: dc.w    1
                dc.b    8,  $C, $28, $1B, $FF, $F8
SSZMap_RetractingSpring_SecondExtension:    dc.w    5
                dc.b    $F8,  $E,   8,   0, $FF, $F8
                dc.b    $F0,   8, $28, $1F, $FF, $F6
                dc.b    $F8,   8, $28, $22, $FF, $EE
                dc.b    0,   4, $28, $25, $FF, $EE
                dc.b    8,   0, $28, $27, $FF, $EE
SSZRetractSpringMap_ExtendedAndRest:    dc.w    4
                dc.b    $F0,   8,   8,  $C, $FF, $F8
                dc.b    $F8,  $E,   8,  $F, $FF, $F8
                dc.b    $F8,   1,   8, $2C, $FF, $F0
                dc.b    $F0,   3, $28, $28, $FF, $E8
SSZRetractSpringMap_PrelaunchCompression:   dc.w    3
                dc.b    $F0,   8,   8,  $C, $FF, $F8
                dc.b    $F8,  $E,   8,  $F, $FF, $F8
                dc.b    $F0,   3, $28, $28, $FF, $F0
SSZMap_RetractingSpring_LaunchRecovery: dc.w    4
                dc.b    $F0,   8,   8,  $C, $FF, $F8
                dc.b    $F8,  $E,   8,  $F, $FF, $F8
                dc.b    $F8,   9,   8, $2E, $FF, $E0
                dc.b    $F0,   3, $28, $28, $FF, $D8

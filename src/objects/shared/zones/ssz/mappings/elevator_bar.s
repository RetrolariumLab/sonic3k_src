; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZElevatorBar_:
                dc.w    SSZMap_ElevatorBar_OrdinaryHangingBar-Map_SSZElevatorBar_
                dc.w    SSZMap_ElevatorBar_CarrierWidePivot-Map_SSZElevatorBar_
                dc.w    SSZElevatorBarMap_ChainLink-Map_SSZElevatorBar_
                dc.w    SSZMap_ElevatorBar_CarrierEndpoint-Map_SSZElevatorBar_
                dc.w    SSZMap_ElevatorBar_CarrierNarrowPivot-Map_SSZElevatorBar_
SSZMap_ElevatorBar_OrdinaryHangingBar:  dc.w    4
                dc.b    $FE,   8,   0,   0, $FF, $D0
                dc.b    $FE,   8,   0,   0, $FF, $E8
                dc.b    $FE,   8,   0,   0,   0,   0
                dc.b    $FE,   8,   0,   0,   0, $18
SSZMap_ElevatorBar_CarrierWidePivot:    dc.w    5
                dc.b    $FE,   8,   0,   0, $FF, $CD
                dc.b    $FE,   8,   0,   0, $FF, $E5
                dc.b    $F8,   5, $20, $10, $FF, $F8
                dc.b    $FE,   8,   0,   0,   0,   0
                dc.b    $FE,   8,   0,   0,   0, $18
SSZElevatorBarMap_ChainLink:    dc.w    1
                dc.b    $F8,   5,   0,  $C, $FF, $F8
SSZMap_ElevatorBar_CarrierEndpoint: dc.w    2
                dc.b    $F4,  $A,   0,   3, $FF, $E8
                dc.b    $F4,  $A,   8,   3,   0,   0
SSZMap_ElevatorBar_CarrierNarrowPivot:  dc.w    1
                dc.b    $F8,   5, $20, $10, $FF, $F8

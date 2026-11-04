; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZGHZMisc_:
                dc.w    SSZMap_GHZMisc_TouchChainTipEvenPhase-Map_SSZGHZMisc_
                dc.w    SSZMap_GHZMisc_TouchChainTipOddPhase-Map_SSZGHZMisc_
                dc.w    SSZMap_GHZMisc_ChainAnchor-Map_SSZGHZMisc_
                dc.w    SSZMap_GHZMisc_ChainSegment-Map_SSZGHZMisc_
SSZMap_GHZMisc_TouchChainTipEvenPhase:  dc.w    4
                dc.b    $E8,  $A,   0,   0, $FF, $E8
                dc.b    $E8,  $A,   0,   9,   0,   0
                dc.b    0,  $A,   0, $12, $FF, $E8
                dc.b    0,  $A,   8, $12,   0,   0
SSZMap_GHZMisc_TouchChainTipOddPhase:   dc.w    4
                dc.b    $E8,  $A,   0, $1B, $FF, $E8
                dc.b    $E8,  $A,   8, $1B,   0,   0
                dc.b    0,  $A, $10, $1B, $FF, $E8
                dc.b    0,  $A, $18, $1B,   0,   0
SSZMap_GHZMisc_ChainAnchor: dc.w    1
                dc.b    $F8,   5,   0, $24, $FF, $F8
SSZMap_GHZMisc_ChainSegment:    dc.w    1
                dc.b    $F8,   5,   0, $28, $FF, $F8

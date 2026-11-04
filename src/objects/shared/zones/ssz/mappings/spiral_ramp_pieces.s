; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZSpiralRampPieces_:
                dc.w    SSZSpiralRampMap_RampFragment-Map_SSZSpiralRampPieces_
                dc.w    SSZSpiralRampMap_MarkerFrame2-Map_SSZSpiralRampPieces_
                dc.w    SSZSpiralRampMap_MarkerFrame3-Map_SSZSpiralRampPieces_
SSZSpiralRampMap_RampFragment:  dc.w    1
                dc.b    $F8,   5,   0,   1, $FF, $F8
SSZSpiralRampMap_MarkerFrame2:  dc.w    2
                dc.b    $F8,   0, $40, $65, $FF, $F8
                dc.b    $F8,   0, $40, $67,   0,   0
SSZSpiralRampMap_MarkerFrame3:  dc.w    2
                dc.b    $F8,   0, $48, $65,   0,   0
                dc.b    $F8,   0, $48, $67, $FF, $F8

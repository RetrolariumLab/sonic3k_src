; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZFloatingPlatform_:
                dc.w    SSZFloatingMap_HiddenColumnRoot-Map_SSZFloatingPlatform_
                dc.w    SSZFloatingMap_Platform-Map_SSZFloatingPlatform_
                dc.w    SSZMap_FloatingPlatform_IntactColumn-Map_SSZFloatingPlatform_
                dc.w    SSZFloatingMap_ColumnLeftShard-Map_SSZFloatingPlatform_
                dc.w    SSZFloatingMap_ColumnRightShard-Map_SSZFloatingPlatform_
                dc.w    SSZFloatingMap_ColumnBottomLeft-Map_SSZFloatingPlatform_
                dc.w    SSZFloatingMap_ColumnBottomRight-Map_SSZFloatingPlatform_
SSZFloatingMap_HiddenColumnRoot:    dc.w    0
SSZFloatingMap_Platform:            dc.w    2
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   8,   0,   0,   0
SSZMap_FloatingPlatform_IntactColumn:   dc.w    4
                dc.b    $E0,  $D,   0,   0, $FF, $F0
                dc.b    $F0,  $D,   0,   0, $FF, $F0
                dc.b    0,  $D,   0,   0, $FF, $F0
                dc.b    $10,  $D,   0,   8, $FF, $F0
SSZFloatingMap_ColumnLeftShard: dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $F8
SSZFloatingMap_ColumnRightShard:    dc.w    1
                dc.b    $F8,   5,   0,   4, $FF, $F8
SSZFloatingMap_ColumnBottomLeft:    dc.w    1
                dc.b    $F8,   5,   0,   8, $FF, $F8
SSZFloatingMap_ColumnBottomRight:   dc.w    1
                dc.b    $F8,   5,   0,  $C, $FF, $F8

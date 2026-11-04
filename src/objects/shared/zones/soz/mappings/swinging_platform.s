; Data owner: objects/shared/zones/soz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SOZSwingingPlatform_:
                dc.w    SOZSwingPlatformMap_PlatformBody-Map_SOZSwingingPlatform_
                dc.w    SOZSwingPlatformMap_ChainLink-Map_SOZSwingingPlatform_
                dc.w    SOZSwingPlatformMap_FirstLinkAndPreview-Map_SOZSwingingPlatform_
; The mapping declares four pieces. Six extra bytes precede the next mapping
SOZSwingPlatformMap_PlatformBody:   dc.w    4
                dc.b    $F0,  $D, $18, $10, $FF, $E0
                dc.b    $F0,  $D, $10, $10,   0,   0
                dc.b    0,   9, $10, $18, $FF, $E8
                dc.b    0,   9, $18, $18,   0,   0
                dc.b    $31, $7C,   3, $C9,   0,  $A
SOZSwingPlatformMap_ChainLink:  dc.w    1
                dc.b    $F8,   5,   3, $C8, $FF, $F8
SOZSwingPlatformMap_FirstLinkAndPreview:    dc.w    2
                dc.b    $F0,   7,   3, $CC, $FF, $F0
                dc.b    $F0,   7,  $B, $CC,   0,   0

; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZCollapsingBridge_:
                dc.w    SSZBridgeMap_HorizontalBridgeAndPiece-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_HorizontalFragmentOne-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_HorizontalFragmentTwo-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_DiagonalWhole-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_DiagonalFragmentFour-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_DiagonalFragmentFive-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeFirstWholeStage-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeFirstMiddleStage-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeFirstLastAndFragment-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeRampDecorationNine-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeRampDecorationTen-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeSecondWholeStage-Map_SSZCollapsingBridge_
                dc.w    SSZMap_Bridge_EscapeSecondMiddleStage-Map_SSZCollapsingBridge_
                dc.w    SSZBridgeMap_EscapePenultimatePiece-Map_SSZCollapsingBridge_
SSZBridgeMap_HorizontalBridgeAndPiece:  dc.w    2
                dc.b    $F8,  $E,   0,   0, $FF, $E0
                dc.b    $F8,  $E,   0,   0,   0,   0
SSZMap_Bridge_HorizontalFragmentOne:    dc.w    1
                dc.b    $F8,   6,   0,   0, $FF, $F8
SSZMap_Bridge_HorizontalFragmentTwo:    dc.w    1
                dc.b    $F8,   6,   0,   6, $FF, $F8
SSZMap_Bridge_DiagonalWhole:    dc.w    4
                dc.b    0,  $F,   0,  $C, $FF, $C0
                dc.b    $F8,  $F,   0,  $C, $FF, $E0
                dc.b    $F0,  $F,   0,  $C,   0,   0
                dc.b    $E8,  $F,   0,  $C,   0, $20
SSZMap_Bridge_DiagonalFragmentFour: dc.w    1
                dc.b    $F0,   7,   0,  $C, $FF, $F8
SSZMap_Bridge_DiagonalFragmentFive: dc.w    1
                dc.b    $F0,   7,   0, $14, $FF, $F8
SSZMap_Bridge_EscapeFirstWholeStage:    dc.w    3
                dc.b    $F8,  $F,   0,  $C, $FF, $D0
                dc.b    $F0,  $F,   0,  $C, $FF, $F0
                dc.b    $E8,  $F,   0,  $C,   0, $10
SSZMap_Bridge_EscapeFirstMiddleStage:   dc.w    2
                dc.b    $F0,  $F,   0,  $C, $FF, $F0
                dc.b    $E8,  $F,   0,  $C,   0, $10
SSZMap_Bridge_EscapeFirstLastAndFragment:   dc.w    1
                dc.b    $E8,  $F,   0,  $C,   0, $10
SSZMap_Bridge_EscapeRampDecorationNine: dc.w    4
                dc.b    $E4,   8,   0,   0, $FF, $F8
                dc.b    $EC,  $E,   0,   3, $FF, $F0
                dc.b    4,   9,   0,  $F, $FF, $F0
                dc.b    $14,   4,   0, $15, $FF, $F8
SSZMap_Bridge_EscapeRampDecorationTen:  dc.w    4
                dc.b    $FC,   7,   0, $17, $FF, $E8
                dc.b    $E4,   9,   0, $1F,   0,   0
                dc.b    $F4,  $F,   0, $25, $FF, $F8
                dc.b    $14,   4,   0, $35, $FF, $F8
SSZMap_Bridge_EscapeSecondWholeStage:   dc.w    3
                dc.b    $E8,  $F,   8,  $C, $FF, $D0
                dc.b    $F0,  $F,   8,  $C, $FF, $F0
                dc.b    $F8,  $F,   8,  $C,   0, $10
SSZMap_Bridge_EscapeSecondMiddleStage:  dc.w    2
                dc.b    $E8,  $F,   8,  $C, $FF, $D0
                dc.b    $F0,  $F,   8,  $C, $FF, $F0
SSZBridgeMap_EscapePenultimatePiece:    dc.w    1
                dc.b    $E8,  $F,   8,  $C, $FF, $D0

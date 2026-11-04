; Data owner: objects/shared/zones/soz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SOZCollapsingBridge_:
                dc.w    SOZMap_CollapsingBridge_IntactFivePieces-Map_SOZCollapsingBridge_
                dc.w    SOZBridgeMap_DefaultBreakOrder-Map_SOZCollapsingBridge_
                dc.w    SOZBridgeMap_AlternateBreakOrder-Map_SOZCollapsingBridge_
SOZMap_CollapsingBridge_IntactFivePieces:   dc.w    5   ; DATA XREF: ROM:0002127A o
                dc.b    $F0,  $D, $10,   8, $FF, $E0
                dc.b    $F0,  $D, $10, $10,   0,  0
                dc.b    0,  $D, $10,   0, $FF, $E0
                dc.b    $10,  $D, $10,   0, $FF, $E0
                dc.b    $20,  $D, $10,   0, $FF, $E0
SOZBridgeMap_DefaultBreakOrder: dc.w    $A              ; DATA XREF: ROM:0002127A o
                dc.b    $F0,   5, $10,   8, $FF, $E0
                dc.b    $F0,   5, $10,  $C, $FF, $F0
                dc.b    $F0,   5, $10, $10,   0,  0
                dc.b    $F0,   5, $10, $14,   0, $10
                dc.b    0,   5, $10,   0, $FF, $E0
                dc.b    0,   5, $10,   4, $FF, $F0
                dc.b    $10,   5, $10,   0, $FF, $E0
                dc.b    $10,   5, $10,   4, $FF, $F0
                dc.b    $20,   5, $10,   0, $FF, $E0
                dc.b    $20,   5, $10,   4, $FF, $F0
SOZBridgeMap_AlternateBreakOrder:   dc.w    $A          ; DATA XREF: ROM:0002127A o
                dc.b    $F0,   5, $10, $14,   0, $10
                dc.b    $F0,   5, $10,   8, $FF, $E0
                dc.b    $F0,   5, $10,  $C, $FF, $F0
                dc.b    $F0,   5, $10, $10,   0,  0
                dc.b    0,   5, $10,   0, $FF, $E0
                dc.b    0,   5, $10,   4, $FF, $F0
                dc.b    $10,   5, $10,   0, $FF, $E0
                dc.b    $10,   5, $10,   4, $FF, $F0
                dc.b    $20,   5, $10,   0, $FF, $E0
                dc.b    $20,   5, $10,   4, $FF, $F0

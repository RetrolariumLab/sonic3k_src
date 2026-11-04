; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZLiftPad_:
                dc.w    DEZMap_LiftPad_OrdinaryRootThreePieces-Map_DEZLiftPad_
                dc.w    DEZMap_LiftPad_ArmLinkAndHelperMain-Map_DEZLiftPad_
                dc.w    DEZMap_LiftPad_FirstEmbeddedArmPiece-Map_DEZLiftPad_
DEZMap_LiftPad_OrdinaryRootThreePieces: dc.w    3
                dc.b    $F8,   9,   0,   0, $FF, $E8
                dc.b    $F8,   9,   8,   0,   0,   0
                dc.b    $F8,   5,   0,   6,   0, $18
DEZMap_LiftPad_ArmLinkAndHelperMain:    dc.w    1
                dc.b    $FC,   0,   0,  $A, $FF, $FC
DEZMap_LiftPad_FirstEmbeddedArmPiece:   dc.w    1
                dc.b    $F8,   5,   0,   6, $FF, $F8

; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZConveyorPad_:
                dc.w    DEZConveyorPadMap_NarrowSharedPhase-Map_DEZConveyorPad_
                dc.w    DEZConveyorPadMap_NarrowSharedPhase-Map_DEZConveyorPad_
                dc.w    DEZMap_ConveyorPad_NarrowPhaseTwo-Map_DEZConveyorPad_
                dc.w    DEZMap_ConveyorPad_NarrowPhaseThree-Map_DEZConveyorPad_
                dc.w    DEZConveyorPadMap_WidePhaseAndPreview-Map_DEZConveyorPad_
DEZConveyorPadMap_NarrowSharedPhase:    dc.w    8
                dc.b    $F0,  $D,   0, $68, $FF, $C0
                dc.b    $F0,  $D,   0, $70, $FF, $E0
                dc.b    $F0,  $D,   8, $70,   0,   0
                dc.b    $F0,  $D,   8, $68,   0, $20
                dc.b    0,  $D, $18, $18, $FF, $C0
                dc.b    0,  $D, $18, $10, $FF, $E0
                dc.b    0,  $D, $18,   8,   0,   0
                dc.b    0,  $D, $18,   0,   0, $20
DEZMap_ConveyorPad_NarrowPhaseTwo:  dc.w    8
                dc.b    $F0,  $D,   0, $68, $FF, $C0
                dc.b    $F0,  $D,   0, $70, $FF, $E0
                dc.b    $F0,  $D,   8, $70,   0,   0
                dc.b    $F0,  $D,   8, $68,   0, $20
                dc.b    0,  $D, $18, $38, $FF, $C0
                dc.b    0,  $D, $18, $30, $FF, $E0
                dc.b    0,  $D, $18, $28,   0,   0
                dc.b    0,  $D, $18, $20,   0, $20
DEZMap_ConveyorPad_NarrowPhaseThree:    dc.w    8
                dc.b    $F0,  $D,   0, $68, $FF, $C0
                dc.b    $F0,  $D,   0, $70, $FF, $E0
                dc.b    $F0,  $D,   8, $70,   0,   0
                dc.b    $F0,  $D,   8, $68,   0, $20
                dc.b    0,  $D, $18, $60, $FF, $C0
                dc.b    0,  $D, $18, $58, $FF, $E0
                dc.b    0,  $D, $18, $48,   0,   0
                dc.b    0,  $D, $18, $40,   0, $20
Map_DEZConveyorPad2:
Map_DEZConveyorPad2_:
                dc.w    DEZConveyorPadMap_WidePhaseAndPreview-Map_DEZConveyorPad2_
                dc.w    DEZConveyorPadMap_WidePhaseAndPreview-Map_DEZConveyorPad2_
                dc.w    DEZMap_ConveyorPad_WidePhaseTwo-Map_DEZConveyorPad2_
                dc.w    DEZMap_ConveyorPad_WidePhaseThree-Map_DEZConveyorPad2_
DEZConveyorPadMap_WidePhaseAndPreview:  dc.w    $10
                dc.b    $F0,  $D,   0,   0, $FF, $80
                dc.b    $F0,  $D,   0,   8, $FF, $A0
                dc.b    $F0,  $D,   0, $10, $FF, $C0
                dc.b    $F0,  $D,   0,   8, $FF, $E0
                dc.b    $F0,  $D,   0, $10,   0,   0
                dc.b    $F0,  $D,   0,   8,   0, $20
                dc.b    $F0,  $D,   0, $10,   0, $40
                dc.b    $F0,  $D,   0, $18,   0, $60
                dc.b    0,  $D, $18, $18, $FF, $80
                dc.b    0,  $D, $18, $10, $FF, $A0
                dc.b    0,  $D, $18,   8, $FF, $C0
                dc.b    0,  $D, $18, $10, $FF, $E0
                dc.b    0,  $D, $18,   8,   0,   0
                dc.b    0,  $D, $18, $10,   0, $20
                dc.b    0,  $D, $18,   8,   0, $40
                dc.b    0,  $D, $18,   0,   0, $60
DEZMap_ConveyorPad_WidePhaseTwo:    dc.w    $10
                dc.b    $F0,  $D,   0, $20, $FF, $80
                dc.b    $F0,  $D,   0, $28, $FF, $A0
                dc.b    $F0,  $D,   0, $30, $FF, $C0
                dc.b    $F0,  $D,   0, $28, $FF, $E0
                dc.b    $F0,  $D,   0, $30,   0,   0
                dc.b    $F0,  $D,   0, $28,   0, $20
                dc.b    $F0,  $D,   0, $30,   0, $40
                dc.b    $F0,  $D,   0, $38,   0, $60
                dc.b    0,  $D, $18, $38, $FF, $80
                dc.b    0,  $D, $18, $30, $FF, $A0
                dc.b    0,  $D, $18, $28, $FF, $C0
                dc.b    0,  $D, $18, $30, $FF, $E0
                dc.b    0,  $D, $18, $28,   0,   0
                dc.b    0,  $D, $18, $30,   0, $20
                dc.b    0,  $D, $18, $28,   0, $40
                dc.b    0,  $D, $18, $20,   0, $60
DEZMap_ConveyorPad_WidePhaseThree:  dc.w    $10
                dc.b    $F0,  $D,   0, $40, $FF, $80
                dc.b    $F0,  $D,   0, $48, $FF, $A0
                dc.b    $F0,  $D,   0, $50, $FF, $C0
                dc.b    $F0,  $D,   0, $48, $FF, $E0
                dc.b    $F0,  $D,   0, $50,   0,   0
                dc.b    $F0,  $D,   0, $48,   0, $20
                dc.b    $F0,  $D,   0, $58,   0, $40
                dc.b    $F0,  $D,   0, $60,   0, $60
                dc.b    0,  $D, $18, $60, $FF, $80
                dc.b    0,  $D, $18, $58, $FF, $A0
                dc.b    0,  $D, $18, $48, $FF, $C0
                dc.b    0,  $D, $18, $50, $FF, $E0
                dc.b    0,  $D, $18, $48,   0,   0
                dc.b    0,  $D, $18, $50,   0, $20
                dc.b    0,  $D, $18, $48,   0, $40
                dc.b    0,  $D, $18, $40,   0, $60

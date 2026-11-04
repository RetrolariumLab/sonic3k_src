; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Ani_DEZConveyorPad_:
                dc.w    DEZAni_ConveyorPad_Forward123Loop-Ani_DEZConveyorPad_
                dc.w    DEZAni_ConveyorPad_Reverse321Loop-Ani_DEZConveyorPad_
                dc.w    DEZAni_ConveyorPad_IdleFrameOneLoop-Ani_DEZConveyorPad_
DEZAni_ConveyorPad_Forward123Loop:      dc.b    1,   1,   2,   3, $FF
DEZAni_ConveyorPad_Reverse321Loop:      dc.b    1,   3,   2,   1, $FF
DEZAni_ConveyorPad_IdleFrameOneLoop:    dc.b    $F,   1, $FF
                even

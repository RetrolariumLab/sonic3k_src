; Data owner: objects/shared/bubbles
; Provenance and source range: config/reconstruction/source_layout.json
Ani_AirCountdown_:
                dc.w    AirCountdown_FormNumber0-Ani_AirCountdown_
                dc.w    AirCountdown_FormNumber1-Ani_AirCountdown_
                dc.w    AirCountdown_FormNumber2-Ani_AirCountdown_
                dc.w    AirCountdown_FormNumber3-Ani_AirCountdown_
                dc.w    AirCountdown_FormNumber4-Ani_AirCountdown_
                dc.w    AirCountdown_FormNumber5-Ani_AirCountdown_
                dc.w    AirCountdown_FormSmallBubble-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber0-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber1-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber2-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber3-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber4-Ani_AirCountdown_
                dc.w    AirCountdown_BlinkNumber5-Ani_AirCountdown_
                dc.w    AirCountdown_SurfaceAdvance-Ani_AirCountdown_
                dc.w    AirCountdown_FormDrowningBubble-Ani_AirCountdown_
AirCountdown_FormNumber0:       dc.b    5,   0,   1,   2,   3,   4,   9,  $D, $FC
AirCountdown_FormNumber1:       dc.b    5,   0,   1,   2,   3,   4,  $C, $12, $FC
AirCountdown_FormNumber2:       dc.b    5,   0,   1,   2,   3,   4,  $C, $11, $FC
AirCountdown_FormNumber3:       dc.b    5,   0,   1,   2,   3,   4,  $B, $10, $FC
AirCountdown_FormNumber4:       dc.b    5,   0,   1,   2,   3,   4,  $C,  $F, $FC
AirCountdown_FormNumber5:       dc.b    5,   0,   1,   2,   3,   4,  $A,  $E, $FC
AirCountdown_FormSmallBubble:   dc.b    $E,   0,   1,   2, $FC
AirCountdown_BlinkNumber0:      dc.b    7, $16,  $D, $16,  $D, $16,  $D, $FC
AirCountdown_BlinkNumber1:      dc.b    7, $16, $12, $16, $12, $16, $12, $FC
AirCountdown_BlinkNumber2:      dc.b    7, $16, $11, $16, $11, $16, $11, $FC
AirCountdown_BlinkNumber3:      dc.b    7, $16, $10, $16, $10, $16, $10, $FC
AirCountdown_BlinkNumber4:      dc.b    7, $16,  $F, $16,  $F, $16,  $F, $FC
AirCountdown_BlinkNumber5:      dc.b    7, $16,  $E, $16,  $E, $16,  $E, $FC
; The script advances the routine with $FC immediately after the delay byte
AirCountdown_SurfaceAdvance:        dc.b    $E, $FC
AirCountdown_FormDrowningBubble:    dc.b    $E,   1,   2,   3,   4, $FC,   0

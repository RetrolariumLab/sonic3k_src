; Data owner: objects/shared/bubbles
; Provenance and source range: config/reconstruction/source_layout.json
Ani_Bubbler_:
                dc.w    Bubbler_Animation0_SmallBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_Animation1_MediumBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_FormLargeAirBubble-Ani_Bubbler_
                dc.w    Bubbler_FormFastLargeBubble-Ani_Bubbler_
                dc.w    Bubbler_Anim45_SurfaceAdvance-Ani_Bubbler_
                dc.w    Bubbler_Anim45_SurfaceAdvance-Ani_Bubbler_
                dc.w    Bubbler_Anim67_LargePop-Ani_Bubbler_
                dc.w    Bubbler_Anim67_LargePop-Ani_Bubbler_
                dc.w    Bubbler_GeneratorLoop-Ani_Bubbler_
Bubbler_Animation0_SmallBubbleFormation:    dc.b    $E,   0,   1,   2, $FC
Bubbler_Animation1_MediumBubbleFormation:   dc.b    $E,   1,   2,   3,   4, $FC
Bubbler_FormLargeAirBubble:                 dc.b    $E,   2,   3,   4,   5,   6, $FC
Bubbler_FormFastLargeBubble:                dc.b    2,   5,   6, $FC
Bubbler_Anim45_SurfaceAdvance:              dc.b    4, $FC
Bubbler_Anim67_LargePop:                    dc.b    4,   7,   8, $FC
Bubbler_GeneratorLoop:                      dc.b    $F, $13, $14, $15, $FF
                even

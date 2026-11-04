; Data owner: objects/shared/bubbles
; Provenance and source range: config/reconstruction/source_layout.json
Ani_Bubbler_:
                dc.w    Bubbler_Animation0_SmallBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_Animation1_MediumBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_Animation2_LargeCollectableAirBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_Animation3_FastLargeBubbleFormation-Ani_Bubbler_
                dc.w    Bubbler_Animation4_5_SmallOrMediumSurfaceRoutineAdvance-Ani_Bubbler_
                dc.w    Bubbler_Animation4_5_SmallOrMediumSurfaceRoutineAdvance-Ani_Bubbler_
                dc.w    Bubbler_Animation6_7_LargeSurfaceOrCollectedBubblePop-Ani_Bubbler_
                dc.w    Bubbler_Animation6_7_LargeSurfaceOrCollectedBubblePop-Ani_Bubbler_
                dc.w    Bubbler_Animation8_StationaryGeneratorLoop-Ani_Bubbler_
Bubbler_Animation0_SmallBubbleFormation:                    dc.b    $E,   0,   1,   2, $FC
Bubbler_Animation1_MediumBubbleFormation:                   dc.b    $E,   1,   2,   3,   4, $FC
Bubbler_Animation2_LargeCollectableAirBubbleFormation:      dc.b    $E,   2,   3,   4,   5,   6, $FC
Bubbler_Animation3_FastLargeBubbleFormation:                dc.b    2,   5,   6, $FC
Bubbler_Animation4_5_SmallOrMediumSurfaceRoutineAdvance:    dc.b    4, $FC
Bubbler_Animation6_7_LargeSurfaceOrCollectedBubblePop:      dc.b    4,   7,   8, $FC
Bubbler_Animation8_StationaryGeneratorLoop:                 dc.b    $F, $13, $14, $15, $FF
                even

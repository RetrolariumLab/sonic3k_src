; Data owner: objects/shared/shields
; Provenance and source range: config/reconstruction/source_layout.json
Map_SuperSonic_Stars_:
                dc.w    SuperStarTrail_Frame0_Mapping-Map_SuperSonic_Stars_
                dc.w    SuperStarTrail_Frames1_5_Mapping-Map_SuperSonic_Stars_
                dc.w    SuperStarTrail_Frames2_4_Mapping-Map_SuperSonic_Stars_
                dc.w    SuperStarTrail_Frame3_Mapping-Map_SuperSonic_Stars_
                dc.w    SuperStarTrail_Frames2_4_Mapping-Map_SuperSonic_Stars_
                dc.w    SuperStarTrail_Frames1_5_Mapping-Map_SuperSonic_Stars_
Map_SuperSonic_Stars2:
Map_SuperSonic_Stars2_:
                dc.w    SuperStarBurst_Frames0_2_Mapping-Map_SuperSonic_Stars2_
                dc.w    SuperStarBurst_Frame1_Mapping-Map_SuperSonic_Stars2_
                dc.w    SuperStarBurst_Frames0_2_Mapping-Map_SuperSonic_Stars2_
                dc.w    SuperStarBurst_Frame3_Mapping-Map_SuperSonic_Stars2_
SuperStarTrail_Frame0_Mapping:      dc.w    0
SuperStarTrail_Frames1_5_Mapping:   dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $F8
SuperStarTrail_Frames2_4_Mapping:   dc.w    4
                dc.b    $F0,   5,   0,   4, $FF, $F0
                dc.b    $F0,   5,   8,   4,   0,   0
                dc.b    0,   5, $10,   4, $FF, $F0
                dc.b    0,   5, $18,   4,   0,   0
SuperStarTrail_Frame3_Mapping:  dc.w    4
                dc.b    $E8,  $A,   0,   8, $FF, $E8
                dc.b    $E8,  $A,   8,   8,   0,   0
                dc.b    0,  $A, $10,   8, $FF, $E8
                dc.b    0,  $A, $18,   8,   0,   0
SuperStarBurst_Frames0_2_Mapping:   dc.w    1
                dc.b    $FC,   0,   0, $11, $FF, $FC
SuperStarBurst_Frame1_Mapping:  dc.w    1
                dc.b    $F8,   5,   0, $12, $FF, $F8
SuperStarBurst_Frame3_Mapping:  dc.w    1
                dc.b    $F8,   5,   0, $16, $FF, $F8

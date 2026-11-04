; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_KnuxEndPose_:
                dc.w    EndKnux_InitialPoseMap-Map_KnuxEndPose_
                dc.w    EndKnux_IntermediatePoseMap-Map_KnuxEndPose_
                dc.w    EndKnux_FinalPoseMap-Map_KnuxEndPose_
EndKnux_InitialPoseMap: dc.w    1
                dc.b    $F8,   5,   0, $10, $FF, $F8
EndKnux_IntermediatePoseMap:    dc.w    2
                dc.b    $F0,  $F,   0, $26, $FF, $F0
                dc.b    $10,   4,   0, $36,   0,   0
EndKnux_FinalPoseMap:   dc.w    8
                dc.b    $CC,  $F,   0, $38,   0,   0
                dc.b    $CC,   5,   0, $48, $FF, $F0
                dc.b    $DC,  $F,   0, $4C, $FF, $E0
                dc.b    $EC,  $D,   0, $5C,   0,   0
                dc.b    $FC,  $F,   0, $64, $FF, $E0
                dc.b    $FC,   6,   0, $74,   0,   0
                dc.b    $14,   9,   0, $7A,   0,   0
                dc.b    $1C,   6,   0, $80, $FF, $F0

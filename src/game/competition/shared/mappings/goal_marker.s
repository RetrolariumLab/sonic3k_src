; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Map_2PGoalMarker_:
                dc.w    CompetitionGoalMarker_FirstCyclePieces-Map_2PGoalMarker_
                dc.w    CompetitionGoalMarker_SecondCyclePieces-Map_2PGoalMarker_
                dc.w    CompetitionGoalMarker_ThirdCyclePieces-Map_2PGoalMarker_
                dc.w    CompetitionGoalMarker_FourthCyclePieces-Map_2PGoalMarker_
CompetitionGoalMarker_FirstCyclePieces: dc.w    2
                dc.b    $EC,   2,   0,   0, $FF, $FC
                dc.b    4,   1,   0,   3, $FF, $FC
CompetitionGoalMarker_SecondCyclePieces:    dc.w    2
                dc.b    $EC,   2,   0,   5, $FF, $FC
                dc.b    4,   1,   0,   3, $FF, $FC
CompetitionGoalMarker_ThirdCyclePieces: dc.w    2
                dc.b    $EC,   2,   0,   8, $FF, $FC
                dc.b    4,   1,   0,   3, $FF, $FC
CompetitionGoalMarker_FourthCyclePieces:    dc.w    2
                dc.b    $EC,   2,   0,  $B, $FF, $FC
                dc.b    4,   1,   0,   3, $FF, $FC

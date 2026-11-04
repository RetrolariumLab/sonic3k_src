; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Map_2PPosition_:
                dc.w    RaceUnusedPos_InitialMap-Map_2PPosition_
                dc.w    RaceUnusedPos_P1MarkerMap-Map_2PPosition_
                dc.w    RaceUnusedPos_P2MarkerMap-Map_2PPosition_
                dc.w    RaceUnusedPos_RetainedMap3-Map_2PPosition_
                dc.w    RaceUnusedPos_RetainedMap4-Map_2PPosition_
RaceUnusedPos_InitialMap:   dc.w    1
                dc.b    $FC,   0,   0,   0, $FF, $FC
RaceUnusedPos_P1MarkerMap:  dc.w    1
                dc.b    $FC,   0,   0,   1, $FF, $FC
RaceUnusedPos_P2MarkerMap:  dc.w    1
                dc.b    $FC,   0,   0,   2, $FF, $FC
RaceUnusedPos_RetainedMap3: dc.w    1
                dc.b    $FC,   0,   0,   3, $FF, $FC
RaceUnusedPos_RetainedMap4: dc.w    1
                dc.b    $FC,   0,   0,   4, $FF, $FC

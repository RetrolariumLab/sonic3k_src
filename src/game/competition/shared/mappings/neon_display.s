; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Map_2PNeonDisplay_:
                dc.w    RaceNeon_Countdown1PrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_Countdown2PrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_Countdown3PrimaryMap-Map_2PNeonDisplay_
                dc.w    CompetitionNeon_StartSignalPrimaryPieces-Map_2PNeonDisplay_
                dc.w    RaceNeon_FirstFinishPrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_P2FinishPrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_LateFinishPrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_BothFinishedPrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_TransitionPrimaryMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_Countdown1AlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_Countdown2AlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_Countdown3AlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_StartAlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_FirstFinishAlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_P2FinishAlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_LateFinishAlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_BothFinishedAlternateMap-Map_2PNeonDisplay_
                dc.w    RaceNeon_TransitionAlternateMap-Map_2PNeonDisplay_
                dc.w    CompetitionNeon_EmptyDelayAndIdleFrame-Map_2PNeonDisplay_
RaceNeon_Countdown1PrimaryMap:  dc.w    7
                dc.b    $E8,   8,   0,   0, $FF, $A8
                dc.b    $F0,   0,   0,   0, $FF, $A0
                dc.b    $F0,   1,   0,   0, $FF, $C0
                dc.b    0,   8,   0,   0, $FF, $A8
                dc.b    8,   1,   0,   0, $FF, $C0
                dc.b    $10,   0,   0,   0, $FF, $A0
                dc.b    $18,   8,   0,   0, $FF, $A8
RaceNeon_Countdown2PrimaryMap:  dc.w    8
                dc.b    $E8,   8,   0,   0, $FF, $A8
                dc.b    $F0,   0,   0,   0, $FF, $A0
                dc.b    $F0,   1,   0,   0, $FF, $C0
                dc.b    0,   0,   0,   0, $FF, $B8
                dc.b    8,   0,   0,   0, $FF, $B0
                dc.b    $10,   0,   0,   0, $FF, $A8
                dc.b    $18,  $C,   0,   0, $FF, $A0
                dc.b    $18,   0,   0,   0, $FF, $C0
RaceNeon_Countdown3PrimaryMap:  dc.w    3
                dc.b    $E8,   3,   0,   0, $FF, $B0
                dc.b    $F0,   0,   0,   0, $FF, $A8
                dc.b    8,   2,   0,   0, $FF, $B0
CompetitionNeon_StartSignalPrimaryPieces:   dc.w    $10
                dc.b    $F0,   3,   0,   0, $FF, $80
                dc.b    $E8,   8,   0,   0, $FF, $88
                dc.b    $F0,   0,   0,   0, $FF, $A0
                dc.b    $10,   0,   0,   0, $FF, $80
                dc.b    $18,   8,   0,   0, $FF, $88
                dc.b    0,   8,   0,   0, $FF, $90
                dc.b    8,   1,   0,   0, $FF, $A0
                dc.b    $E8,   8,   0,   0, $FF, $B8
                dc.b    $18,   8,   0,   0, $FF, $B8
                dc.b    $F0,   3,   0,   0, $FF, $B0
                dc.b    $F0,   3,   0,   0, $FF, $D0
                dc.b    $10,   0,   0,   0, $FF, $B0
                dc.b    $10,   0,   0,   0, $FF, $D0
                dc.b    $E8,   3,   0,   0, $FF, $E4
                dc.b    8,   0,   0,   0, $FF, $E4
                dc.b    $18,   0,   0,   0, $FF, $E4
RaceNeon_FirstFinishPrimaryMap: dc.w    $1B
                dc.b    $E0,   3,   0,   0, $FF, $90
                dc.b    0,   3,   0,   0, $FF, $90
                dc.b    $E0,  $C,   0,   0, $FF, $98
                dc.b    $F8,   8,   0,   0, $FF, $98
                dc.b    $E0,   3,   0,   0, $FF, $C2
                dc.b    0,   3,   0,   0, $FF, $C2
                dc.b    $E0,   3,   0,   0, $FF, $D4
                dc.b    0,   3,   0,   0, $FF, $D4
                dc.b    $F0,   0,   0,   0, $FF, $DC
                dc.b    $F8,   0,   0,   0, $FF, $E4
                dc.b    0,   0,   0,   0, $FF, $EC
                dc.b    $E0,   3,   0,   0, $FF, $F4
                dc.b    0,   3,   0,   0, $FF, $F4
                dc.b    $E0,   3,   0,   0,   0,   6
                dc.b    0,   3,   0,   0,   0,   6
                dc.b    $E0,   8,   0,   0,   0, $20
                dc.b    $E8,   1,   0,   0,   0, $18
                dc.b    $E8,   0,   0,   0,   0, $38
                dc.b    $F8,   8,   0,   0,   0, $20
                dc.b    0,   2,   0,   0,   0, $38
                dc.b    $10,   0,   0,   0,   0, $18
                dc.b    $18,   8,   0,   0,   0, $20
                dc.b    $E0,   3,   0,   0,   0, $48
                dc.b    0,   3,   0,   0,   0, $48
                dc.b    $F8,   8,   0,   0,   0, $50
                dc.b    $E0,   3,   0,   0,   0, $68
                dc.b    0,   3,   0,   0,   0, $68
RaceNeon_P2FinishPrimaryMap:    dc.w    $13
                dc.b    $E0,   3,   0,   0, $FF, $B8
                dc.b    $E0,   3,   0,   0, $FF, $E8
                dc.b    0,   2,   0,   0, $FF, $B8
                dc.b    0,   2,   0,   0, $FF, $E8
                dc.b    $18,   0,   0,   0, $FF, $C0
                dc.b    $18,   0,   0,   0, $FF, $E0
                dc.b    $10,   0,   0,   0, $FF, $C8
                dc.b    $10,   0,   0,   0, $FF, $D8
                dc.b    8,   0,   0,   0, $FF, $D0
                dc.b    $E0,   3,   0,   0,   0,   0
                dc.b    0,   3,   0,   0,   0,   0
                dc.b    $E0,   3,   0,   0,   0, $18
                dc.b    0,   3,   0,   0,   0, $18
                dc.b    $E8,   0,   0,   0,   0, $20
                dc.b    $F0,   0,   0,   0,   0, $28
                dc.b    $F8,   0,   0,   0,   0, $30
                dc.b    0,   0,   0,   0,   0, $38
                dc.b    $E0,   3,   0,   0,   0, $40
                dc.b    0,   3,   0,   0,   0, $40
RaceNeon_LateFinishPrimaryMap:  dc.w    $15
                dc.b    $E0,   3,   0,   0, $FF, $A8
                dc.b    0,   3,   0,   0, $FF, $A8
                dc.b    $18,  $C,   0,   0, $FF, $B0
                dc.b    $E0,   8,   0,   0, $FF, $E0
                dc.b    $18,   8,   0,   0, $FF, $E0
                dc.b    $E8,   2,   0,   0, $FF, $D8
                dc.b    0,   2,   0,   0, $FF, $D8
                dc.b    $E8,   2,   0,   0, $FF, $F8
                dc.b    0,   2,   0,   0, $FF, $F8
                dc.b    $E0,   8,   0,   0,   0, $10
                dc.b    $E8,   1,   0,   0,   0,   8
                dc.b    $E8,   0,   0,   0,   0, $28
                dc.b    $F8,   8,   0,   0,   0, $10
                dc.b    0,   2,   0,   0,   0, $28
                dc.b    $10,   0,   0,   0,   0,   8
                dc.b    $18,   8,   0,   0,   0, $10
                dc.b    $E0,   3,   0,   0,   0, $38
                dc.b    0,   3,   0,   0,   0, $38
                dc.b    $E0,  $C,   0,   0,   0, $40
                dc.b    $18,  $C,   0,   0,   0, $40
                dc.b    $FC,   8,   0,   0,   0, $40
RaceNeon_BothFinishedPrimaryMap:    dc.w    $B
                dc.b    $E0,  $C,   0,   0, $FF, $C8
                dc.b    $E0,   0,   0,   0, $FF, $E8
                dc.b    $E8,   3,   0,   0, $FF, $D8
                dc.b    8,   2,   0,   0, $FF, $D8
                dc.b    $E0,   3,   0,   0,   0,   0
                dc.b    0,   3,   0,   0,   0,   0
                dc.b    $E0,   3,   0,   0,   0, $18
                dc.b    0,   3,   0,   0,   0, $18
                dc.b    $E0,  $C,   0,   0,   0, $20
                dc.b    $18,  $C,   0,   0,   0, $20
                dc.b    $FC,   8,   0,   0,   0, $20
RaceNeon_TransitionPrimaryMap:  dc.w    $16
                dc.b    $E0,   3,   0,   0, $FF, $90
                dc.b    0,   3,   0,   0, $FF, $90
                dc.b    $E0,  $C,   0,   0, $FF, $98
                dc.b    $F8,   8,   0,   0, $FF, $98
                dc.b    $E0,   8,   0,   0, $FF, $C8
                dc.b    $F8,   8,   0,   0, $FF, $C8
                dc.b    $E8,   2,   0,   0, $FF, $C0
                dc.b    $E8,   2,   0,   0, $FF, $E0
                dc.b    0,   3,   0,   0, $FF, $C0
                dc.b    0,   3,   0,   0, $FF, $E0
                dc.b    $18,   8,   0,   0, $FF, $F8
                dc.b    $E0,   3,   0,   0, $FF, $F0
                dc.b    0,   2,   0,   0, $FF, $F0
                dc.b    $E0,   3,   0,   0,   0, $10
                dc.b    0,   2,   0,   0,   0, $10
                dc.b    $E0,   3,   0,   0,   0, $20
                dc.b    0,   3,   0,   0,   0, $20
                dc.b    $18,  $C,   0,   0,   0, $28
                dc.b    $E0,  $C,   0,   0,   0, $48
                dc.b    $E0,   0,   0,   0,   0, $68
                dc.b    $E8,   3,   0,   0,   0, $58
                dc.b    8,   2,   0,   0,   0, $58
RaceNeon_Countdown1AlternateMap:    dc.w    7
                dc.b    $E8,   8,   0,   4, $FF, $A8
                dc.b    $F0,   0,   0,   4, $FF, $A0
                dc.b    $F0,   1,   0,   4, $FF, $C0
                dc.b    0,   8,   0,   4, $FF, $A8
                dc.b    8,   1,   0,   4, $FF, $C0
                dc.b    $10,   0,   0,   4, $FF, $A0
                dc.b    $18,   8,   0,   4, $FF, $A8
RaceNeon_Countdown2AlternateMap:    dc.w    8
                dc.b    $E8,   8,   0,   4, $FF, $A8
                dc.b    $F0,   0,   0,   4, $FF, $A0
                dc.b    $F0,   1,   0,   4, $FF, $C0
                dc.b    0,   0,   0,   4, $FF, $B8
                dc.b    8,   0,   0,   4, $FF, $B0
                dc.b    $10,   0,   0,   4, $FF, $A8
                dc.b    $18,  $C,   0,   4, $FF, $A0
                dc.b    $18,   0,   0,   4, $FF, $C0
RaceNeon_Countdown3AlternateMap:    dc.w    3
                dc.b    $E8,   3,   0,   4, $FF, $B0
                dc.b    $F0,   0,   0,   4, $FF, $A8
                dc.b    8,   2,   0,   4, $FF, $B0
RaceNeon_StartAlternateMap: dc.w    $10
                dc.b    $F0,   3,   0,   4, $FF, $80
                dc.b    $E8,   8,   0,   4, $FF, $88
                dc.b    $F0,   0,   0,   4, $FF, $A0
                dc.b    $10,   0,   0,   4, $FF, $80
                dc.b    $18,   8,   0,   4, $FF, $88
                dc.b    0,   8,   0,   4, $FF, $90
                dc.b    8,   1,   0,   4, $FF, $A0
                dc.b    $E8,   8,   0,   4, $FF, $B8
                dc.b    $18,   8,   0,   4, $FF, $B8
                dc.b    $F0,   3,   0,   4, $FF, $B0
                dc.b    $F0,   3,   0,   4, $FF, $D0
                dc.b    $10,   0,   0,   4, $FF, $B0
                dc.b    $10,   0,   0,   4, $FF, $D0
                dc.b    $E8,   3,   0,   4, $FF, $E4
                dc.b    8,   0,   0,   4, $FF, $E4
                dc.b    $18,   0,   0,   4, $FF, $E4
RaceNeon_FirstFinishAlternateMap:   dc.w    $1B
                dc.b    $E0,   3,   0,   4, $FF, $90
                dc.b    0,   3,   0,   4, $FF, $90
                dc.b    $E0,  $C,   0,   4, $FF, $98
                dc.b    $F8,   8,   0,   4, $FF, $98
                dc.b    $E0,   3,   0,   4, $FF, $C2
                dc.b    0,   3,   0,   4, $FF, $C2
                dc.b    $E0,   3,   0,   4, $FF, $D4
                dc.b    0,   3,   0,   4, $FF, $D4
                dc.b    $F0,   0,   0,   4, $FF, $DC
                dc.b    $F8,   0,   0,   4, $FF, $E4
                dc.b    0,   0,   0,   4, $FF, $EC
                dc.b    $E0,   3,   0,   4, $FF, $F4
                dc.b    0,   3,   0,   4, $FF, $F4
                dc.b    $E0,   3,   0,   4,   0,   6
                dc.b    0,   3,   0,   4,   0,   6
                dc.b    $E0,   8,   0,   4,   0, $20
                dc.b    $E8,   1,   0,   4,   0, $18
                dc.b    $E8,   0,   0,   4,   0, $38
                dc.b    $F8,   8,   0,   4,   0, $20
                dc.b    0,   2,   0,   4,   0, $38
                dc.b    $10,   0,   0,   4,   0, $18
                dc.b    $18,   8,   0,   4,   0, $20
                dc.b    $E0,   3,   0,   4,   0, $48
                dc.b    0,   3,   0,   4,   0, $48
                dc.b    $F8,   8,   0,   4,   0, $50
                dc.b    $E0,   3,   0,   4,   0, $68
                dc.b    0,   3,   0,   4,   0, $68
RaceNeon_P2FinishAlternateMap:  dc.w    $13
                dc.b    $E0,   3,   0,   4, $FF, $B8
                dc.b    $E0,   3,   0,   4, $FF, $E8
                dc.b    0,   2,   0,   4, $FF, $B8
                dc.b    0,   2,   0,   4, $FF, $E8
                dc.b    $18,   0,   0,   4, $FF, $C0
                dc.b    $18,   0,   0,   4, $FF, $E0
                dc.b    $10,   0,   0,   4, $FF, $C8
                dc.b    $10,   0,   0,   4, $FF, $D8
                dc.b    8,   0,   0,   4, $FF, $D0
                dc.b    $E0,   3,   0,   4,   0,   0
                dc.b    0,   3,   0,   4,   0,   0
                dc.b    $E0,   3,   0,   4,   0, $18
                dc.b    0,   3,   0,   4,   0, $18
                dc.b    $E8,   0,   0,   4,   0, $20
                dc.b    $F0,   0,   0,   4,   0, $28
                dc.b    $F8,   0,   0,   4,   0, $30
                dc.b    0,   0,   0,   4,   0, $38
                dc.b    $E0,   3,   0,   4,   0, $40
                dc.b    0,   3,   0,   4,   0, $40
RaceNeon_LateFinishAlternateMap:    dc.w    $15
                dc.b    $E0,   3,   0,   4, $FF, $A8
                dc.b    0,   3,   0,   4, $FF, $A8
                dc.b    $18,  $C,   0,   4, $FF, $B0
                dc.b    $E0,   8,   0,   4, $FF, $E0
                dc.b    $18,   8,   0,   4, $FF, $E0
                dc.b    $E8,   2,   0,   4, $FF, $D8
                dc.b    0,   2,   0,   4, $FF, $D8
                dc.b    $E8,   2,   0,   4, $FF, $F8
                dc.b    0,   2,   0,   4, $FF, $F8
                dc.b    $E0,   8,   0,   4,   0, $10
                dc.b    $E8,   1,   0,   4,   0,   8
                dc.b    $E8,   0,   0,   4,   0, $28
                dc.b    $F8,   8,   0,   4,   0, $10
                dc.b    0,   2,   0,   4,   0, $28
                dc.b    $10,   0,   0,   4,   0,   8
                dc.b    $18,   8,   0,   4,   0, $10
                dc.b    $E0,   3,   0,   4,   0, $38
                dc.b    0,   3,   0,   4,   0, $38
                dc.b    $E0,  $C,   0,   4,   0, $40
                dc.b    $18,  $C,   0,   4,   0, $40
                dc.b    $FC,   8,   0,   4,   0, $40
RaceNeon_BothFinishedAlternateMap:  dc.w    $B
                dc.b    $E0,  $C,   0,   4, $FF, $C8
                dc.b    $E0,   0,   0,   4, $FF, $E8
                dc.b    $E8,   3,   0,   4, $FF, $D8
                dc.b    8,   2,   0,   4, $FF, $D8
                dc.b    $E0,   3,   0,   4,   0,   0
                dc.b    0,   3,   0,   4,   0,   0
                dc.b    $E0,   3,   0,   4,   0, $18
                dc.b    0,   3,   0,   4,   0, $18
                dc.b    $E0,  $C,   0,   4,   0, $20
                dc.b    $18,  $C,   0,   4,   0, $20
                dc.b    $FC,   8,   0,   4,   0, $20
RaceNeon_TransitionAlternateMap:    dc.w    $16
                dc.b    $E0,   3,   0,   4, $FF, $90
                dc.b    0,   3,   0,   4, $FF, $90
                dc.b    $E0,  $C,   0,   4, $FF, $98
                dc.b    $F8,   8,   0,   4, $FF, $98
                dc.b    $E0,   8,   0,   4, $FF, $C8
                dc.b    $F8,   8,   0,   4, $FF, $C8
                dc.b    $E8,   2,   0,   4, $FF, $C0
                dc.b    $E8,   2,   0,   4, $FF, $E0
                dc.b    0,   3,   0,   4, $FF, $C0
                dc.b    0,   3,   0,   4, $FF, $E0
                dc.b    $18,   8,   0,   4, $FF, $F8
                dc.b    $E0,   3,   0,   4, $FF, $F0
                dc.b    0,   2,   0,   4, $FF, $F0
                dc.b    $E0,   3,   0,   4,   0, $10
                dc.b    0,   2,   0,   4,   0, $10
                dc.b    $E0,   3,   0,   4,   0, $20
                dc.b    0,   3,   0,   4,   0, $20
                dc.b    $18,  $C,   0,   4,   0, $28
                dc.b    $E0,  $C,   0,   4,   0, $48
                dc.b    $E0,   0,   0,   4,   0, $68
                dc.b    $E8,   3,   0,   4,   0, $58
                dc.b    8,   2,   0,   4,   0, $58
CompetitionNeon_EmptyDelayAndIdleFrame: dc.w    0

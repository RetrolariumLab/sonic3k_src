; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Ani_2PNeonDisplay_:
                dc.w    RaceNeon_BlankBeforeCountdownAnim-Ani_2PNeonDisplay_
                dc.w    RaceNeon_CountdownAnim-Ani_2PNeonDisplay_
                dc.w    CompetitionNeon_AnimateEmptyIdle-Ani_2PNeonDisplay_
                dc.w    RaceNeon_FirstFinishAnim-Ani_2PNeonDisplay_
                dc.w    RaceNeon_AlternateFinishAnim-Ani_2PNeonDisplay_
                dc.w    RaceNeon_LateFinishAnim-Ani_2PNeonDisplay_
                dc.w    RaceNeon_BothFinishedAnim-Ani_2PNeonDisplay_
                dc.w    RaceNeon_TransitionOverlayAnim-Ani_2PNeonDisplay_
RaceNeon_BlankBeforeCountdownAnim:  dc.b    $3B, $12, $FD,   1
RaceNeon_CountdownAnim:             dc.b    5,   0,   9,   0,   9,   0,   9,   0,   9,   0,   9,   1,  $A,   1,  $A,   1,  $A,   1,  $A,   1
                dc.b    $A,   2,  $B,   2,  $B,   2,  $B,   2,  $B,   2,  $B,   3,  $C,   3,  $C,   3,  $C,   3,  $C,   3
                dc.b    $C, $FD,   2
CompetitionNeon_AnimateEmptyIdle:   dc.b    $3B, $12, $FF
RaceNeon_FirstFinishAnim:           dc.b    5,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4
                dc.b    $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D,   4,  $D, $FD,   2, $FF
RaceNeon_AlternateFinishAnim:   dc.b    5,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5
                dc.b    $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E,   5,  $E, $FD,   2, $FF
RaceNeon_LateFinishAnim:    dc.b    5,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6
                dc.b    $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F,   6,  $F, $FD,   2, $FF
RaceNeon_BothFinishedAnim:  dc.b    5,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10,   7
                dc.b    $10,   7, $10,   7, $10,   7, $10,   7, $10,   7, $10, $FD,   2, $FF
RaceNeon_TransitionOverlayAnim: dc.b    5,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11,   8
                dc.b    $11,   8, $11,   8, $11,   8, $11,   8, $11,   8, $11, $FD,   2, $FF

; Data owner: objects/shared/dash_dust
; Provenance and source range: config/reconstruction/source_layout.json
Ani_DashDust2P_:
                dc.w    CompetitionDust_Animation0_IdleBlankLoop-Ani_DashDust2P_
                dc.w    CompDustAnim_BlankSplashToIdle-Ani_DashDust2P_
                dc.w    CompDustAnim_ChargeLoop-Ani_DashDust2P_
                dc.w    CompDustAnim_SmokeThenAdvance-Ani_DashDust2P_
CompetitionDust_Animation0_IdleBlankLoop:   dc.b    $1F,   0, $FF
CompDustAnim_BlankSplashToIdle:             dc.b    3,   0, $FD,   0
CompDustAnim_ChargeLoop:                    dc.b    1,   1,   2,   3,   4, $FF
CompDustAnim_SmokeThenAdvance:              dc.b    5,   5,   6,   7, $FC
                even

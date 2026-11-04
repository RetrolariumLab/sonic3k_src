; Data owner: objects/shared/dash_dust
; Provenance and source range: config/reconstruction/source_layout.json
Ani_DashSplashDrown_:
                dc.w    DashDust_Animation0_IdleBlankLoop-Ani_DashSplashDrown_
                dc.w    DashDust_Animation1_WaterSplashThenIdle-Ani_DashSplashDrown_
                dc.w    DashDust_Animation2_ChargeDustLoop-Ani_DashSplashDrown_
                dc.w    DashDustAnim_SmokeThenAdvance-Ani_DashSplashDrown_
                dc.w    DashDust_Animation4_GroundSplashThenIdle-Ani_DashSplashDrown_
DashDust_Animation0_IdleBlankLoop:          dc.b    $1F,   0, $FF
DashDust_Animation1_WaterSplashThenIdle:    dc.b    3,   1,   2,   3,   4,   5,   6,   7,   8,   9, $FD,   0
DashDust_Animation2_ChargeDustLoop:         dc.b    1,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FF
DashDustAnim_SmokeThenAdvance:              dc.b    3, $11, $12, $13, $14, $FC
DashDust_Animation4_GroundSplashThenIdle:   dc.b    5, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $FD,   0
                even

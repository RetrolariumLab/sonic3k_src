; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Ani_2PItem_:
                dc.w    CompetitionItem_AnimateSpeedIncreaseIcon-Ani_2PItem_
                dc.w    CompetitionItem_AnimateSpeedDecreaseIcon-Ani_2PItem_
                dc.w    CompItem_SwapIconAnim-Ani_2PItem_
                dc.w    CompItem_RingIconAnim-Ani_2PItem_
                dc.w    CompetitionItem_AnimateRollingHazardIdle-Ani_2PItem_
                dc.w    CompItem_MomentumTrapIdleAnim-Ani_2PItem_
                dc.w    CompItem_FlipLauncherIdleAnim-Ani_2PItem_
                dc.w    CompetitionItem_AnimateEmptyPickupState-Ani_2PItem_
                dc.w    CompItem_RingEffectAdvanceAnim-Ani_2PItem_
                dc.w    CompItem_SharedEffectBlankBackstepAnim-Ani_2PItem_
                dc.w    CompItem_LauncherContactEffectAnim-Ani_2PItem_
                dc.w    CompItem_HazardEndAdvanceAnim-Ani_2PItem_
CompetitionItem_AnimateSpeedIncreaseIcon:   dc.b    $1F,   0, $FF
CompetitionItem_AnimateSpeedDecreaseIcon:   dc.b    $1F,   1, $FF
CompItem_SwapIconAnim:                      dc.b    $1F,   2, $FF
CompItem_RingIconAnim:                      dc.b    7,   3,   4,   5, $19, $FF
CompetitionItem_AnimateRollingHazardIdle:   dc.b    $1F, $11, $FF
CompItem_MomentumTrapIdleAnim:              dc.b    $1F,   6, $FF
CompItem_FlipLauncherIdleAnim:              dc.b    $1F,   7, $FF
CompetitionItem_AnimateEmptyPickupState:    dc.b    $1F, $1A, $FF
CompItem_RingEffectAdvanceAnim:             dc.b    5,   9,  $A,  $B,  $C, $FC
CompItem_SharedEffectBlankBackstepAnim:     dc.b    5,  $D,  $E,  $F, $10, $FC, $1A, $FE,   1
CompItem_LauncherContactEffectAnim:         dc.b    $B,   8,   7, $FD,   9
CompItem_HazardEndAdvanceAnim:              dc.b    5, $1B, $1C, $1D, $1E, $1F, $FC
                even

; Data owner: objects/shared/shields
; Provenance and source range: config/reconstruction/source_layout.json
Ani_InstaShield_:
                dc.w    InstaShield_Animation0_IdleBlankLoop-Ani_InstaShield_
                dc.w    InstaShieldAnim_AttackToIdle-Ani_InstaShield_
InstaShield_Animation0_IdleBlankLoop:   dc.b    $1F,   6, $FF
; Hold the blank recovery frame before the return to idle
InstaShieldAnim_AttackToIdle:   dc.b    0,   0,   1,   2,   3,   4,   5,   6,   6,   6,   6,   6,   6,   6,   7, $FD,   0
                even

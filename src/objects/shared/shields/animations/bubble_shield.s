; Data owner: objects/shared/shields
; Provenance and source range: config/reconstruction/source_layout.json
Ani_BubbleShield_:
                dc.w    BubbleShieldAnim_IdleLoop-Ani_BubbleShield_
                dc.w    BubbleShieldAnim_AttackToIdle-Ani_BubbleShield_
                dc.w    BubbleShieldAnim_BounceToIdle-Ani_BubbleShield_
BubbleShieldAnim_IdleLoop:  dc.b    1,   0,   9,   0,   9,   0,   9,   1,  $A,   1,  $A,   1,  $A,   2,   9,   2,   9,   2,   9,   3
                dc.b    $A,   3,  $A,   3,  $A,   4,   9,   4,   9,   4,   9,   5,  $A,   5,  $A,   5,  $A,   6,   9,   6
                dc.b    9,   6,   9,   7,  $A,   7,  $A,   7,  $A,   8,   9,   8,   9,   8,   9, $FF
BubbleShieldAnim_AttackToIdle:  dc.b    5,   9,  $B,  $B,  $B, $FD,   0
BubbleShieldAnim_BounceToIdle:  dc.b    5,  $C,  $C,  $B, $FD,   0
                even

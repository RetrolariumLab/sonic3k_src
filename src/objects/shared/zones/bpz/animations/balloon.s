; Data owner: objects/shared/zones/bpz
; Provenance and source range: config/reconstruction/source_layout.json
Ani_BPZBalloon_:
                dc.w    CommonBPZBalloon_IdleStandardAnimation-Ani_BPZBalloon_
                dc.w    BPZBalloon_UpperConeBounceAnim-Ani_BPZBalloon_
                dc.w    BPZBalloon_RadialBounceAnim-Ani_BPZBalloon_
                dc.w    BPZBalloon_RecoveryAnim-Ani_BPZBalloon_
CommonBPZBalloon_IdleStandardAnimation: dc.b    5,   0,   1,   2,   3,   4,   6,   5,   5,   5,   5,   5,   6,   5, $FE,   2
BPZBalloon_UpperConeBounceAnim:         dc.b    2,   7,   8, $FD,   3
BPZBalloon_RadialBounceAnim:            dc.b    2,   8, $FD,   3
BPZBalloon_RecoveryAnim:                dc.b    $1F,   9, $FD,   0
                even

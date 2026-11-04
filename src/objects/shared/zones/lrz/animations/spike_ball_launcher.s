; Data owner: objects/shared/zones/lrz
; Provenance and source range: config/reconstruction/source_layout.json
Ani_LRZSpikeBallLauncher_:
                dc.w    LRZBallLaunchAni_HoldThenCharge-Ani_LRZSpikeBallLauncher_
                dc.w    LRZBallLaunchAni_ChargeThenLaunch-Ani_LRZSpikeBallLauncher_
LRZBallLaunchAni_HoldThenCharge:    dc.b    3, $7F, $FC, $FF, $FD,   1
LRZBallLaunchAni_ChargeThenLaunch:  dc.b    4,  $D,   3,  $D,   4,  $B
                dc.b    3,  $B,   4,   9,   3,   9
                dc.b    4,   7,   3,   7,   4,   5
                dc.b    3,   5,   4,   3,   3,   3
                dc.b    4,   1,   3,   1,   4,   0
                dc.b    3,   0,   4,   0,   3,   0
                dc.b    4,   0,   3,   0,   4,   0
                dc.b    3,   0,   4,   0,   3,   0
                dc.b    4,   0,   3,   0,   4,   0
                dc.b    3,   0,   4,   0,   3,   0
                dc.b    4,   0,   3,   0,   4,   0
                dc.b    3,   0,   4,   0,   3,   0
                dc.b    4,   0,   3,   0,   4,   0
                dc.b    3,   0,   4,   0,   3,   0
                dc.b    $FC, $FF, $FD,   0
                even

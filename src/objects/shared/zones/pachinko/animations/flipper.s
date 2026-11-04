; Data owner: objects/shared/zones/pachinko
; Provenance and source range: config/reconstruction/source_layout.json
Ani_PachinkoFlipper_:
                dc.w    PachinkoFlipperSTD_Idle-Ani_PachinkoFlipper_
                dc.w    PachinkoFlipperSTD_LaunchThenReturnIdle-Ani_PachinkoFlipper_
PachinkoFlipperSTD_Idle:                    dc.b    $1F,   4, $FF
PachinkoFlipperSTD_LaunchThenReturnIdle:    dc.b    1,   3,   2,   1,   0,   1,   2,   3, $FD,   0
                even

; Data owner: objects/shared/level_misc
; Provenance and source range: config/reconstruction/source_layout.json
Ani_Bumper_:
                dc.w    BumperAnimation_Idle-Ani_Bumper_
                dc.w    BumperAnimation_Contact-Ani_Bumper_
BumperAnimation_Idle:       dc.b    $F,   0, $FF
BumperAnimation_Contact:    dc.b    3,   1,   0,   1, $FD,   0
                even

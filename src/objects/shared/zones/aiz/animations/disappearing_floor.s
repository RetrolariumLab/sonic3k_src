; Data owner: objects/shared/zones/aiz
; Provenance and source range: config/reconstruction/source_layout.json
Ani_AIZDisappearingFloor_:
                dc.w    AIZDisappearFloor_IdleAnim-Ani_AIZDisappearingFloor_
                dc.w    AIZDisappearFloor_RiseAnim-Ani_AIZDisappearingFloor_
                dc.w    AIZDisappearFloor_FallAnim-Ani_AIZDisappearingFloor_
AIZDisappearFloor_IdleAnim: dc.b    0, $1F, $FF
; The rising stream falls through to the descending frames
AIZDisappearFloor_RiseAnim: dc.b    1,   1,   2,   1,   3,   1,   4,   1,   5, $7F,   5, $3F
AIZDisappearFloor_FallAnim: dc.b    4,   3,   3,   2,   2,   1,   1,   1, $FD,   0
                even

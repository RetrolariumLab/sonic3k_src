; Data owner: game/blue_sphere/shared/blue_sphere
; Provenance and source range: config/reconstruction/source_layout.json
Ani_BlueSphereCharSprite_:
                dc.w    BSFooter_RightmostAnim-Ani_BlueSphereCharSprite_
                dc.w    BlueSphereFooter_AnimateThirdWideSprite-Ani_BlueSphereCharSprite_
                dc.w    BlueSphereFooter_AnimateSecondTallSprite-Ani_BlueSphereCharSprite_
                dc.w    BSFooter_LeftmostAnim-Ani_BlueSphereCharSprite_
BSFooter_LeftmostAnim:                      dc.b    0, $3F,   1,   1,   2,   7,   1,   1, $FF
BlueSphereFooter_AnimateSecondTallSprite:   dc.b    3,  $F,   4,  $F, $FF
BlueSphereFooter_AnimateThirdWideSprite:    dc.b    5, $3F,   6,  $F, $FF
BSFooter_RightmostAnim:                     dc.b    7, $1F,   8,   7,   7,   7,   8,   7,   7,   7,   8,   7,   7,   7,   8,   7, $FF
                even

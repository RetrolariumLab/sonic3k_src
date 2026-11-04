; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Ani_SSZMTZOrbs_:
                dc.w    SSZAni_MTZOrb_StoredBackShapeHold-Ani_SSZMTZOrbs_
                dc.w    SSZAni_MTZOrb_StoredFrontMiddleCycle-Ani_SSZMTZOrbs_
                dc.w    SSZAni_MTZOrb_DetachTransformation-Ani_SSZMTZOrbs_
                dc.w    SSZAni_MTZOrb_StoredLaserShapeCycle-Ani_SSZMTZOrbs_
                dc.w    SSZMTZOrb_FinalAlternatingAnim-Ani_SSZMTZOrbs_
                dc.w    SSZMTZOrb_ExtendedHoldThenLaserAnim-Ani_SSZMTZOrbs_
                dc.w    SSZMTZOrb_ContactShapeAnim-Ani_SSZMTZOrbs_
                dc.w    SSZAni_MTZOrb_StoredExtendedAliasCycle-Ani_SSZMTZOrbs_
SSZAni_MTZOrb_StoredBackShapeHold:      dc.b    $F,   2, $FF
SSZAni_MTZOrb_StoredFrontMiddleCycle:   dc.b    1,   0,   1, $FF
SSZAni_MTZOrb_DetachTransformation:     dc.b    3,   2,   2,   2,   2,   2,   2,   2,   2,   3,   4,   3,   4,   3,   4,   5,   6,   7,   8, $FE,   1
SSZAni_MTZOrb_StoredLaserShapeCycle:    dc.b    7,  $C,  $D, $FF
SSZMTZOrb_FinalAlternatingAnim:         dc.b    7,  $E,  $F,  $E,  $F,  $E,  $F,  $E,  $F, $FD,   3
SSZMTZOrb_ExtendedHoldThenLaserAnim:    dc.b    7, $10, $10, $10, $10, $10, $10, $10, $10, $FD,   3
SSZMTZOrb_ContactShapeAnim:             dc.b    1,  $E, $FC
SSZAni_MTZOrb_StoredExtendedAliasCycle: dc.b    7, $11, $FF
                even

; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Ani_SSZBouncyCloud_:
                dc.w    SSZAni_BouncyCloud_IdleStandardCycle-Ani_SSZBouncyCloud_
                dc.w    SSZCloudAni_CompressionHold-Ani_SSZBouncyCloud_
                dc.w    SSZCloudAni_ParticleFrames-Ani_SSZBouncyCloud_
SSZAni_BouncyCloud_IdleStandardCycle:   dc.b    $B,   3,   4,   5,   6,   7, $FF
SSZCloudAni_CompressionHold:            dc.b    $FF,   0, $FF
SSZCloudAni_ParticleFrames:             dc.b    1,  $B,   2,   5, $FC
                even

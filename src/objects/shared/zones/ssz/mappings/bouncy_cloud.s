; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZBouncyCloud_:
                dc.w    SSZCloudMap_CompressedAndDebugBody-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_ParticleFirstPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_ParticleSecondPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_IdleFirstPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_IdleSecondPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_IdleThirdPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_IdleFourthPhase-Map_SSZBouncyCloud_
                dc.w    SSZMap_BouncyCloud_IdleFifthPhase-Map_SSZBouncyCloud_
SSZCloudMap_CompressedAndDebugBody: dc.w    2
                dc.b    $F0,  $B,   0,   0, $FF, $E8
                dc.b    $F0,  $B,   0,  $C,   0,   0
SSZMap_BouncyCloud_ParticleFirstPhase:  dc.w    1
                dc.b    $FC,   0,   0, $18, $FF, $FC
SSZMap_BouncyCloud_ParticleSecondPhase: dc.w    1
                dc.b    $FC,   0,   0, $19, $FF, $FC
SSZMap_BouncyCloud_IdleFirstPhase:  dc.w    2
                dc.b    $F0,  $F,   0, $1A, $FF, $E0
                dc.b    $F0,  $F,   0, $2A,   0,   0
SSZMap_BouncyCloud_IdleSecondPhase: dc.w    3
                dc.b    $F0,  $F,   0, $3A, $FF, $E0
                dc.b    $F0,   8,   0, $4A,   0,   0
                dc.b    $F8,  $E,   0, $4D,   0,   0
SSZMap_BouncyCloud_IdleThirdPhase:  dc.w    3
                dc.b    $F0,  $F,   0, $59, $FF, $E0
                dc.b    $F0,   8,   0, $69,   0,   0
                dc.b    $F8,  $E,   0, $6C,   0,   0
SSZMap_BouncyCloud_IdleFourthPhase: dc.w    2
                dc.b    $F0,  $F,   0, $78, $FF, $E0
                dc.b    $F0,  $F,   0, $88,   0,   0
SSZMap_BouncyCloud_IdleFifthPhase:  dc.w    2
                dc.b    $F0,  $F,   0, $98, $FF, $E0
                dc.b    $F0,  $F,   0, $A8,   0,   0

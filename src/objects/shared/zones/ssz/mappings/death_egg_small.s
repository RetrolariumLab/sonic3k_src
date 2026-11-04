; Data owner: objects/shared/zones/ssz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SSZDeathEggSmall_:
                dc.w    SSZMap_DeathEggSmall_MainSixteenPieces-Map_SSZDeathEggSmall_
                dc.w    SSZMap_DeathEggSmall_AttachedRawPhaseOne-Map_SSZDeathEggSmall_
                dc.w    SSZMap_DeathEggSmall_AttachedRawPhaseTwo-Map_SSZDeathEggSmall_
                dc.w    SSZSmallEggMap_AttachedPhase3-Map_SSZDeathEggSmall_
                dc.w    SSZMap_DeathEggSmall_ParticleEvenPhase-Map_SSZDeathEggSmall_
                dc.w    SSZMap_DeathEggSmall_ParticleOddPhase-Map_SSZDeathEggSmall_
                dc.w    SSZSmallEggMap_AttachedBlank-Map_SSZDeathEggSmall_
SSZMap_DeathEggSmall_MainSixteenPieces: dc.w    $10
                dc.b    $D8,  $A,   0,   0, $FF, $D0
                dc.b    $F0,  $D,   0,   9, $FF, $C8
                dc.b    $D0,  $F,   0, $11, $FF, $E8
                dc.b    $F0,  $D,   0, $21, $FF, $E8
                dc.b    $D0,   5,   0, $29,   0,   8
                dc.b    $D8,   4,   0, $2D,   0, $18
                dc.b    $E0,  $F,   0, $2F,   0,   8
                dc.b    $E0,   3,   0, $3F,   0, $28
                dc.b    0,  $E,   0, $43, $FF, $D0
                dc.b    $18,   9,   0, $4F, $FF, $D8
                dc.b    $28,   0,   0, $55, $FF, $E8
                dc.b    0,  $F,   0, $56, $FF, $F0
                dc.b    $20,  $D,   0, $66, $FF, $F0
                dc.b    0,  $E,   8, $43,   0, $10
                dc.b    $18,   9,   8, $4F,   0, $10
                dc.b    $28,   0,   8, $55,   0, $10
SSZMap_DeathEggSmall_AttachedRawPhaseOne:   dc.w    3
                dc.b    $E4,   0,   0, $6E, $FF, $FC
                dc.b    $EC,   2,   0, $6F, $FF, $FC
                dc.b    4,   2,   0, $6F, $FF, $FC
SSZMap_DeathEggSmall_AttachedRawPhaseTwo:   dc.w    3
                dc.b    $E4,   0,   0, $72, $FF, $FC
                dc.b    $EC,   2,   0, $73, $FF, $FC
                dc.b    4,   2,   0, $73, $FF, $FC
SSZSmallEggMap_AttachedPhase3:  dc.w    3
                dc.b    $E4,   0,   0, $76, $FF, $FC
                dc.b    $EC,   2,   0, $77, $FF, $FC
                dc.b    4,   2,   0, $77, $FF, $FC
SSZMap_DeathEggSmall_ParticleEvenPhase: dc.w    1
                dc.b    $FC,   0,   0, $7A, $FF, $FC
SSZMap_DeathEggSmall_ParticleOddPhase:  dc.w    2
                dc.b    $FC,   0,   0, $7A, $FF, $FC
                dc.b    $F9,   4,   0, $7B, $FF, $F8
SSZSmallEggMap_AttachedBlank:   dc.w    0

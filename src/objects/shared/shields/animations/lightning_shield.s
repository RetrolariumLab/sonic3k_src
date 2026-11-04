; Data owner: objects/shared/shields
; Provenance and source range: config/reconstruction/source_layout.json
Ani_LightningShield_:
                dc.w    SKLightningAnim_IdleOrbitLoop-Ani_LightningShield_
                dc.w    SKLightningAnim_SparkThenDelete-Ani_LightningShield_
                dc.w    SKLightningAnim_HyperSparkThenDelete-Ani_LightningShield_
SKLightningAnim_IdleOrbitLoop:  dc.b    1,   0,   0,   1,   1,   2,   2,   3,   3,   4,   4,   5,   5,   6,   6,   7,   7,   8,   8,   9
                dc.b    $A,  $B, $16, $16, $15, $15, $14, $14, $13, $13, $12, $12
                dc.b    $11, $11, $10, $10,  $F,  $F,  $E,  $E,   9,  $A,  $B, $FF
SKLightningAnim_SparkThenDelete:    dc.b    0,  $C,  $D, $17,  $C,  $D, $17,  $C,  $D, $17,  $C,  $D, $17,  $C,  $D, $17,  $C,  $D, $17,  $C
                dc.b    $D, $FC, $FF
SKLightningAnim_HyperSparkThenDelete:   dc.b    3,   0,   1,   2, $FC, $FF
                even

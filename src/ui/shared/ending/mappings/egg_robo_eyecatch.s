; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_EndingEyecatchEggRobo_:
                dc.w    EndEggRobo_PortraitMap1-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_PortraitMap2-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_AttachedEffectMap1-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_AttachedEffectMap2-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_RetainedWideMap-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_RetainedTileMap-Map_EndingEyecatchEggRobo_
                dc.w    EndEggRobo_BlankEffectMap-Map_EndingEyecatchEggRobo_
EndEggRobo_PortraitMap1:    dc.w    8
                dc.b    $E4,   4,   0,   0, $FF, $F0
                dc.b    $EC,   8,   0,   2, $FF, $E8
                dc.b    $F4,  $B,   0,   5, $FF, $E8
                dc.b    $14,   4,   0, $11, $FF, $F0
                dc.b    $E4,   4,   8,   0,   0,   0
                dc.b    $EC,   8,   8,   2,   0,   0
                dc.b    $F4,  $B,   8,   5,   0,   0
                dc.b    $14,   4,   8, $11,   0,   0
EndEggRobo_PortraitMap2:    dc.w    6
                dc.b    $E4,   5,   0, $13, $FF, $F0
                dc.b    $F4,  $B,   0, $17, $FF, $E8
                dc.b    $14,   4,   0, $23, $FF, $F0
                dc.b    $E4,   5,   8, $13,   0,   0
                dc.b    $F4,  $B,   8, $17,   0,   0
                dc.b    $14,   4,   8, $23,   0,   0
EndEggRobo_AttachedEffectMap1:  dc.w    1
                dc.b    $FC,   4,   0, $25, $FF, $F8
EndEggRobo_AttachedEffectMap2:  dc.w    1
                dc.b    $FC,   4,   0, $27, $FF, $F8
EndEggRobo_RetainedWideMap: dc.w    6
                dc.b    $FC,   1,   0, $29, $FF, $CC
                dc.b    $F4,  $E,   0, $2B, $FF, $D4
                dc.b    $F4,   0,   0, $37, $FF, $F4
                dc.b    $FC,  $D,   0, $38, $FF, $F4
                dc.b    $F4,   8,   0, $40,   0, $14
                dc.b    $FC,  $D,   0, $43,   0, $14
EndEggRobo_RetainedTileMap: dc.w    1
                dc.b    $FC,   0,   0, $4B, $FF, $FC
EndEggRobo_BlankEffectMap:  dc.w    0

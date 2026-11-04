; Data owner: game/special_stage/shared/special_stage
; Provenance and source range: config/reconstruction/source_layout.json
Map_GetBlueSpheres_:
                dc.w    SStageCue_OpeningLeftMapping-Map_GetBlueSpheres_
                dc.w    SStageCue_OpeningRightMapping-Map_GetBlueSpheres_
                dc.w    SStageCue_CompletionLeftMapping-Map_GetBlueSpheres_
                dc.w    SStageCue_CompletionRightMapping-Map_GetBlueSpheres_
SStageCue_OpeningLeftMapping:   dc.w    3
                dc.b    $F8,   5,   1, $99, $FF, $B0
                dc.b    $F8,   9,   0,   0, $FF, $C0
                dc.b    $F8,  $D,   0,   6, $FF, $E0
SStageCue_OpeningRightMapping:  dc.w    3
                dc.b    $F8,  $D,   0,  $E,   0,   8
                dc.b    $F8,   9,   0, $16,   0, $28
                dc.b    $F8,   5,   9, $99,   0, $40
SStageCue_CompletionLeftMapping:    dc.w    2
                dc.b    $F8,   5,   1, $99, $FF, $D4
                dc.b    $F8,  $D,   0, $1C, $FF, $E4
SStageCue_CompletionRightMapping:   dc.w    2
                dc.b    $F8,   9,   0, $24,   0,   4
                dc.b    $F8,   5,   9, $99,   0, $1C

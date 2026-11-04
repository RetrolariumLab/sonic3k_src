; Data owner: game/blue_sphere/shared/blue_sphere
; Provenance and source range: config/reconstruction/source_layout.json
Map_BlueSpheresText_:
                dc.w    BSText_LevelSelectionMap-Map_BlueSpheresText_
                dc.w    BSText_PackedStageSelectionMap-Map_BlueSpheresText_
                dc.w    BSText_CodeEntryMap-Map_BlueSpheresText_
                dc.w    BSText_PlayerOptionMap-Map_BlueSpheresText_
                dc.w    BSText_DifficultyMap-Map_BlueSpheresText_
                dc.w    BSText_FinalDifficultyMap-Map_BlueSpheresText_
BSText_LevelSelectionMap:   dc.w    4
                dc.b    $F8,   5,   0,   4, $FF, $EC
                dc.b    $F8,   1,   0,   8, $FF, $FC
                dc.b    $F8,   1,   0,   6,   0,   4
                dc.b    $F8,   1,   0,   4,   0,  $C
BSText_PackedStageSelectionMap: dc.w    5
                dc.b    $F8,   1,   0, $4A, $FF, $EC
                dc.b    $F8,   1,   0, $40, $FF, $F4
                dc.b    $F8,   1,   0, $46, $FF, $FC
                dc.b    $F8,   1,   0, $4C,   0,   4
                dc.b    $F8,   1,   0,   6,   0,  $C
BSText_CodeEntryMap:    dc.w    3
                dc.b    $F8,   9,   0,  $A,   0,   0
                dc.b    $F8,   1,   0,   6,   0, $18
                dc.b    $F8,   1,   0, $10,   0, $20
BSText_PlayerOptionMap: dc.w    5
                dc.b    $F8,   1,   0, $4A, $FF, $EC
                dc.b    $F8,   1,   0, $40, $FF, $F4
                dc.b    $F8,   1,   0, $46, $FF, $FC
                dc.b    $F8,   1,   0, $4E,   0,   4
                dc.b    $F8,   1,   0, $40,   0,  $C
BSText_DifficultyMap:   dc.w    8
                dc.b    $F8,   1,   0,  $E, $FF, $D8
                dc.b    $F8,   5,   0, $3A, $FF, $E0
                dc.b    $F8,   1,   0, $3C, $FF, $F0
                dc.b    $F8,   1,   0, $3A, $FF, $F8
                dc.b    $F8,   1,   0,  $A,   0,   0
                dc.b    $F8,   1,   0, $3E,   0,   8
                dc.b    $F8,   1,   0,   4,   0, $10
                dc.b    $F8,   5,   0, $40,   0, $18
BSText_FinalDifficultyMap:  dc.w    $B
                dc.b    $F8,   1,   0,  $E, $FF, $D8
                dc.b    $F8,   5,   0, $3A, $FF, $E0
                dc.b    $F8,   1,   0, $3C, $FF, $F0
                dc.b    $F8,   1,   0, $3A, $FF, $F8
                dc.b    $F8,   1,   0,  $A,   0,   0
                dc.b    $F8,   1,   0, $3E,   0,   8
                dc.b    $F8,   1,   0,   4,   0, $10
                dc.b    $F8,   5,   0, $40,   0, $18
                dc.b    8,   9,   0, $44, $FF, $F4
                dc.b    8,   5,   0,   0, $FF, $E4
                dc.b    8,   5,   0,   0,   0,  $C

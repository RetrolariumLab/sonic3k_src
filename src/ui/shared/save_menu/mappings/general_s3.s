; Data owner: ui/shared/save_menu
; Provenance and source range: config/reconstruction/source_layout.json
Map_SaveScreen_:
                dc.w    S3SaveMenuMapping_EmptyMappingFrame-Map_SaveScreen_
                dc.w    S3Save_CenterCursorMap-Map_SaveScreen_
                dc.w    S3SaveMenuMapping_OuterMenuCursorPieces-Map_SaveScreen_
                dc.w    S3SaveMenuMapping_FixedMenuHeadingPieces-Map_SaveScreen_
                dc.w    S3Save_CombinedChoiceMap-Map_SaveScreen_
                dc.w    S3Save_SonicChoiceMap-Map_SaveScreen_
                dc.w    S3Save_TailsChoiceMap-Map_SaveScreen_
                dc.w    S3Save_KnucklesChoiceMap-Map_SaveScreen_
                dc.w    S3Save_EraseChildInitialMap-Map_SaveScreen_
                dc.w    S3Save_EraseChildCycleMap1-Map_SaveScreen_
                dc.w    S3Save_EraseChildCycleMap2-Map_SaveScreen_
                dc.w    S3Save_EraseChildCycleMap3-Map_SaveScreen_
                dc.w    S3Save_EraseConfirmationMap-Map_SaveScreen_
                dc.w    S3Save_EraseMainBlinkMap1-Map_SaveScreen_
                dc.w    S3Save_EraseMainBlinkMap2-Map_SaveScreen_
                dc.w    S3Save_NoSaveChildMap-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap1-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap2-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap3-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap4-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap5-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap6-Map_SaveScreen_
                dc.w    S3Save_ChaosEmeraldMap7-Map_SaveScreen_
                dc.w    S3Save_ProgressCardMap-Map_SaveScreen_
                dc.w    S3Save_CompletedCardMap1-Map_SaveScreen_
                dc.w    S3Save_CompletedCardMap2-Map_SaveScreen_
                dc.w    S3Save_RaisedProgressMarkerMap-Map_SaveScreen_
S3SaveMenuMapping_EmptyMappingFrame:    dc.w    0
S3Save_CenterCursorMap:                 dc.w    $12
                dc.b    $A8,   0,   1,   7, $FF, $D8
                dc.b    $A8,  $C,   1,   8, $FF, $E0
                dc.b    $A8,  $C,   1,   8,   0,   0
                dc.b    $A8,   0,   9,   7,   0, $20
                dc.b    $B0,   3,   1,  $C, $FF, $D8
                dc.b    $D0,   3,   1,  $C, $FF, $D8
                dc.b    $F0,   3,   1,  $C, $FF, $D8
                dc.b    $10,   3,   1,  $C, $FF, $D8
                dc.b    $30,   2,   1,  $C, $FF, $D8
                dc.b    $B0,   3,   9,  $C,   0, $20
                dc.b    $D0,   3,   9,  $C,   0, $20
                dc.b    $F0,   3,   9,  $C,   0, $20
                dc.b    $10,   3,   9,  $C,   0, $20
                dc.b    $30,   2,   9,  $C,   0, $20
                dc.b    $48,   1,   1, $10, $FF, $D8
                dc.b    $48,  $D,   1, $12, $FF, $E0
                dc.b    $48,  $D,   1, $12,   0,   0
                dc.b    $48,   1,   9, $10,   0, $20
S3SaveMenuMapping_OuterMenuCursorPieces:    dc.w    $E
                dc.b    $AE,   0,   0, $F9, $FF, $D8
                dc.b    $AE,  $C,   0, $FA, $FF, $E0
                dc.b    $AE,  $C,   0, $FA,   0,   0
                dc.b    $AE,   0,   8, $F9,   0, $20
                dc.b    $B6,   3,   0, $FE, $FF, $D8
                dc.b    $D6,   3,   0, $FE, $FF, $D8
                dc.b    $F6,   0,   0, $FE, $FF, $D8
                dc.b    $B6,   3,   0, $FE,   0, $20
                dc.b    $D6,   3,   0, $FE,   0, $20
                dc.b    $F6,   0,   0, $FE,   0, $20
                dc.b    $FE,   0,   1,   2, $FF, $D8
                dc.b    $FE,  $C,   1,   3, $FF, $E0
                dc.b    $FE,  $C,   1,   3,   0,   0
                dc.b    $FE,   0,   9,   2,   0, $20
S3SaveMenuMapping_FixedMenuHeadingPieces:   dc.w    4
                dc.b    $F4,  $E, $20, $42, $FF, $C8
                dc.b    $F4,  $E, $20, $4E, $FF, $E8
                dc.b    $F4,  $E, $20, $5A,   0,   8
                dc.b    $F4,   6, $20, $66,   0, $28
S3Save_CombinedChoiceMap:   dc.w    6
                dc.b    $D8,  $E, $28, $6C, $FF, $E8
                dc.b    $F0,   9, $28, $78, $FF, $F0
                dc.b    $D6,   0, $28, $7E,   0,   0
                dc.b    $DE,  $D, $28, $7F, $FF, $F8
                dc.b    $EE,  $D, $28, $87,   0,   0
                dc.b    $F6,   0, $28, $8F, $FF, $F8
S3Save_SonicChoiceMap:  dc.w    2
                dc.b    $D8,  $E, $28, $6C, $FF, $EE
                dc.b    $F0,   9, $28, $78, $FF, $F6
S3Save_TailsChoiceMap:  dc.w    4
                dc.b    $D8,   0, $20, $7E, $FF, $FF
                dc.b    $E0,  $D, $20, $7F, $FF, $EF
                dc.b    $F0,  $D, $20, $87, $FF, $E7
                dc.b    $F8,   0, $20, $8F,   0,   7
S3Save_KnucklesChoiceMap:   dc.w    3
                dc.b    $D8,  $E, $28, $90, $FF, $F3
                dc.b    $F0,   8, $28, $9C, $FF, $F3
                dc.b    $F8,  $C, $28, $9F, $FF, $F3
S3Save_EraseChildInitialMap:    dc.w    2
                dc.b    $B8,  $E, $20, $A3, $FF, $E4
                dc.b    $B8,   2, $20, $AF,   0,   4
S3Save_EraseChildCycleMap1: dc.w    1
                dc.b    $B8,  $A, $20, $B2, $FF, $EC
S3Save_EraseChildCycleMap2: dc.w    1
                dc.b    $B8,   2, $20, $BB, $FF, $F4
S3Save_EraseChildCycleMap3: dc.w    1
                dc.b    $B8,  $A, $20, $B2, $FF, $EC
S3Save_EraseConfirmationMap:    dc.w    2
                dc.b    $B8,  $E, $20, $BE, $FF, $E4
                dc.b    $B8,   2, $20, $CA,   0,   4
S3Save_EraseMainBlinkMap1:  dc.w    3
                dc.b    $D0,  $F, $20, $CD, $FF, $EC
                dc.b    $D8,   2, $20, $DD,   0,  $C
                dc.b    $F0,   9, $20, $E0, $FF, $F4
S3Save_EraseMainBlinkMap2:  dc.w    3
                dc.b    $D0,  $F, $20, $E6, $FF, $EC
                dc.b    $D8,   2, $20, $F6,   0,  $C
                dc.b    $F0,   9, $20, $E0, $FF, $F4
S3Save_NoSaveChildMap:  dc.w    2
                dc.b    $C6,   5,   1, $1E, $FF, $F8
                dc.b    2,   5, $11, $1E, $FF, $F8
S3Save_ChaosEmeraldMap1:    dc.w    1
                dc.b    $CE,   0, $41, $22, $FF, $FC
S3Save_ChaosEmeraldMap2:    dc.w    1
                dc.b    $D8,   0, $41, $23, $FF, $E8
S3Save_ChaosEmeraldMap3:    dc.w    1
                dc.b    $D8,   0, $41, $24,   0, $10
S3Save_ChaosEmeraldMap4:    dc.w    1
                dc.b    $EE,   0, $41, $25, $FF, $E3
S3Save_ChaosEmeraldMap5:    dc.w    1
                dc.b    $EE,   0, $41, $26,   0, $15
S3Save_ChaosEmeraldMap6:    dc.w    1
                dc.b    $FF,   0, $41, $27, $FF, $F1
S3Save_ChaosEmeraldMap7:    dc.w    1
                dc.b    $FF,   0, $41, $28,   0,   7
S3Save_ProgressCardMap: dc.w    6
                dc.b    $80,  $F, $63, $1B, $FF, $D8
                dc.b    $80,  $F, $63, $2B, $FF, $F8
                dc.b    $80,   7, $63, $3B,   0, $18
                dc.b    $A0,  $E, $63, $43, $FF, $D8
                dc.b    $A0,  $E, $63, $4F, $FF, $F8
                dc.b    $A0,   6, $63, $5B,   0, $18
S3Save_CompletedCardMap1:   dc.w    6
                dc.b    $80,  $F, $61, $29, $FF, $D8
                dc.b    $80,  $F, $61, $39, $FF, $F8
                dc.b    $80,   7, $61, $49,   0, $18
                dc.b    $A0,  $E, $61, $51, $FF, $D8
                dc.b    $A0,  $E, $61, $5D, $FF, $F8
                dc.b    $A0,   6, $61, $69,   0, $18
S3Save_CompletedCardMap2:   dc.w    6
                dc.b    $80,  $F, $61, $6F, $FF, $D8
                dc.b    $80,  $F, $61, $7F, $FF, $F8
                dc.b    $80,   7, $61, $8F,   0, $18
                dc.b    $A0,  $E, $61, $97, $FF, $D8
                dc.b    $A0,  $E, $61, $A3, $FF, $F8
                dc.b    $A0,   6, $61, $AF,   0, $18
S3Save_RaisedProgressMarkerMap: dc.w    2
                dc.b    $80,   5,   1, $1E, $FF, $F8
                dc.b    $B8,   5, $11, $1E, $FF, $F8

; Data owner: ui/shared/save_menu
; Provenance and source range: config/reconstruction/source_layout.json
Map_SaveScreen_:
                dc.w    SKSaveMenuMapping_EmptyMappingFrame-Map_SaveScreen_
                dc.w    SKSave_CenterCursorMap-Map_SaveScreen_
                dc.w    SKSaveMenuMapping_OuterMenuCursorPieces-Map_SaveScreen_
                dc.w    SKSaveMenuMapping_FixedMenuHeadingPieces-Map_SaveScreen_
                dc.w    SKSave_CombinedChoiceMap-Map_SaveScreen_
                dc.w    SKSave_SonicChoiceMap-Map_SaveScreen_
                dc.w    SKSave_TailsChoiceMap-Map_SaveScreen_
                dc.w    SKSave_KnucklesChoiceMap-Map_SaveScreen_
                dc.w    SKSave_EraseChildInitialMap-Map_SaveScreen_
                dc.w    SKSave_EraseChildCycleMap1-Map_SaveScreen_
                dc.w    SKSave_EraseChildCycleMap2-Map_SaveScreen_
                dc.w    SKSave_EraseChildCycleMap3-Map_SaveScreen_
                dc.w    SKSave_EraseConfirmationMap-Map_SaveScreen_
                dc.w    SKSave_EraseMainBlinkMap1-Map_SaveScreen_
                dc.w    SKSave_EraseMainBlinkMap2-Map_SaveScreen_
                dc.w    SKSave_NoSaveChildMap-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap1-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap2-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap3-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap4-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap5-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap6-Map_SaveScreen_
                dc.w    SKSave_ChaosEmeraldMap7-Map_SaveScreen_
                dc.w    SKSave_ProgressCardMap-Map_SaveScreen_
                dc.w    SKSave_CompletedCardMap1-Map_SaveScreen_
                dc.w    SKSave_CompletedCardMap2-Map_SaveScreen_
                dc.w    SKSave_RaisedProgressMarkerMap-Map_SaveScreen_
                dc.w    SKSave_AllSuperCompletedCardMap-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap1-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap2-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap3-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap4-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap5-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap6-Map_SaveScreen_
                dc.w    SKSave_SuperEmeraldMap7-Map_SaveScreen_
                dc.w    SKSave_AlternateCharacterCardMap-Map_SaveScreen_
SKSaveMenuMapping_EmptyMappingFrame:    dc.w    0
SKSave_CenterCursorMap:                 dc.w    $12
                dc.b    $A8,   0,   1,   7, $FF, $D8
                dc.b    $A8,  $C,   1,   8, $FF, $E0
                dc.b    $A8,  $C,   1,   8,   0,   0
                dc.b    $A8,   0,   9,   7,   0, $20
                dc.b    $B0,   3,   1,  $C, $FF, $D8
                dc.b    $D0,   3,   1,  $C, $FF, $D8
                dc.b    $F0,   3,   1,  $C, $FF, $D8
                dc.b    $10,   3,   1,  $C, $FF, $D8
                dc.b    $30,   3,   1,  $C, $FF, $D8
                dc.b    $B0,   3,   9,  $C,   0, $20
                dc.b    $D0,   3,   9,  $C,   0, $20
                dc.b    $F0,   3,   9,  $C,   0, $20
                dc.b    $10,   3,   9,  $C,   0, $20
                dc.b    $30,   3,   9,  $C,   0, $20
                dc.b    $50,   1,   1, $10, $FF, $D8
                dc.b    $50,  $D,   1, $12, $FF, $E0
                dc.b    $50,  $D,   1, $12,   0,   0
                dc.b    $50,   1,   9, $10,   0, $20
SKSaveMenuMapping_OuterMenuCursorPieces:    dc.w    $E
                dc.b    $A6,   0,   0, $F9, $FF, $D8
                dc.b    $A6,  $C,   0, $FA, $FF, $E0
                dc.b    $A6,  $C,   0, $FA,   0,   0
                dc.b    $A6,   0,   8, $F9,   0, $20
                dc.b    $AE,   3,   0, $FE, $FF, $D8
                dc.b    $CE,   3,   0, $FE, $FF, $D8
                dc.b    $EE,   0,   0, $FE, $FF, $D8
                dc.b    $AE,   3,   0, $FE,   0, $20
                dc.b    $CE,   3,   0, $FE,   0, $20
                dc.b    $EE,   0,   0, $FE,   0, $20
                dc.b    $F6,   0,   1,   2, $FF, $D8
                dc.b    $F6,  $C,   1,   3, $FF, $E0
                dc.b    $F6,  $C,   1,   3,   0,   0
                dc.b    $F6,   0,   9,   2,   0, $20
SKSaveMenuMapping_FixedMenuHeadingPieces:   dc.w    4
                dc.b    $F4,  $E, $20, $42, $FF, $C8
                dc.b    $F4,  $E, $20, $4E, $FF, $E8
                dc.b    $F4,  $E, $20, $5A,   0,   8
                dc.b    $F4,   6, $20, $66,   0, $28
SKSave_CombinedChoiceMap:   dc.w    6
                dc.b    $D8,  $E, $28, $6C, $FF, $E8
                dc.b    $F0,   9, $28, $78, $FF, $F0
                dc.b    $D6,   0, $28, $7E,   0,   0
                dc.b    $DE,  $D, $28, $7F, $FF, $F8
                dc.b    $EE,  $D, $28, $87,   0,   0
                dc.b    $F6,   0, $28, $8F, $FF, $F8
SKSave_SonicChoiceMap:  dc.w    2
                dc.b    $D8,  $E, $28, $6C, $FF, $EE
                dc.b    $F0,   9, $28, $78, $FF, $F6
SKSave_TailsChoiceMap:  dc.w    4
                dc.b    $D8,   0, $20, $7E, $FF, $FF
                dc.b    $E0,  $D, $20, $7F, $FF, $EF
                dc.b    $F0,  $D, $20, $87, $FF, $E7
                dc.b    $F8,   0, $20, $8F,   0,   7
SKSave_KnucklesChoiceMap:   dc.w    3
                dc.b    $D8,  $E, $28, $90, $FF, $F3
                dc.b    $F0,   8, $28, $9C, $FF, $F3
                dc.b    $F8,  $C, $28, $9F, $FF, $F3
SKSave_EraseChildInitialMap:    dc.w    2
                dc.b    $B8,  $E, $20, $A3, $FF, $E4
                dc.b    $B8,   2, $20, $AF,   0,   4
SKSave_EraseChildCycleMap1: dc.w    1
                dc.b    $B8,  $A, $20, $B2, $FF, $EC
SKSave_EraseChildCycleMap2: dc.w    1
                dc.b    $B8,   2, $20, $BB, $FF, $F4
SKSave_EraseChildCycleMap3: dc.w    1
                dc.b    $B8,  $A, $20, $B2, $FF, $EC
SKSave_EraseConfirmationMap:    dc.w    2
                dc.b    $B8,  $E, $20, $BE, $FF, $E4
                dc.b    $B8,   2, $20, $CA,   0,   4
SKSave_EraseMainBlinkMap1:  dc.w    3
                dc.b    $D0,  $F, $20, $CD, $FF, $EC
                dc.b    $D8,   2, $20, $DD,   0,  $C
                dc.b    $F0,   9, $20, $E0, $FF, $F4
SKSave_EraseMainBlinkMap2:  dc.w    3
                dc.b    $D0,  $F, $20, $E6, $FF, $EC
                dc.b    $D8,   2, $20, $F6,   0,  $C
                dc.b    $F0,   9, $20, $E0, $FF, $F4
SKSave_NoSaveChildMap:  dc.w    2
                dc.b    $C6,   5,   1, $1E, $FF, $F8
                dc.b    2,   5, $11, $1E, $FF, $F8
SKSave_ChaosEmeraldMap1:    dc.w    1
                dc.b    $CE,   0, $C1, $22, $FF, $FC
SKSave_ChaosEmeraldMap2:    dc.w    1
                dc.b    $D8,   0, $41, $23, $FF, $E8
SKSave_ChaosEmeraldMap3:    dc.w    1
                dc.b    $D8,   0, $41, $24,   0, $10
SKSave_ChaosEmeraldMap4:    dc.w    1
                dc.b    $EE,   0, $41, $25, $FF, $E3
SKSave_ChaosEmeraldMap5:    dc.w    1
                dc.b    $EE,   0, $41, $26,   0, $15
SKSave_ChaosEmeraldMap6:    dc.w    1
                dc.b    $FF,   0, $41, $27, $FF, $F1
SKSave_ChaosEmeraldMap7:    dc.w    1
                dc.b    $FF,   0, $41, $28,   0,   7
SKSave_ProgressCardMap: dc.w    6
                dc.b    $88,  $F, $63, $1B, $FF, $D8
                dc.b    $88,  $F, $63, $2B, $FF, $F8
                dc.b    $88,   7, $63, $3B,   0, $18
                dc.b    $A8,  $E, $63, $43, $FF, $D8
                dc.b    $A8,  $E, $63, $4F, $FF, $F8
                dc.b    $A8,   6, $63, $5B,   0, $18
SKSave_CompletedCardMap1:   dc.w    6
                dc.b    $88,  $F, $61, $29, $FF, $D8
                dc.b    $88,  $F, $61, $39, $FF, $F8
                dc.b    $88,   7, $61, $49,   0, $18
                dc.b    $A8,  $E, $61, $51, $FF, $D8
                dc.b    $A8,  $E, $61, $5D, $FF, $F8
                dc.b    $A8,   6, $61, $69,   0, $18
SKSave_CompletedCardMap2:   dc.w    6
                dc.b    $88,  $F, $61, $6F, $FF, $D8
                dc.b    $88,  $F, $61, $7F, $FF, $F8
                dc.b    $88,   7, $61, $8F,   0, $18
                dc.b    $A8,  $E, $61, $97, $FF, $D8
                dc.b    $A8,  $E, $61, $A3, $FF, $F8
                dc.b    $A8,   6, $61, $AF,   0, $18
SKSave_RaisedProgressMarkerMap: dc.w    2
                dc.b    $88,   5,   1, $1E, $FF, $F8
                dc.b    $C0,   5, $11, $1E, $FF, $F8
SKSave_AllSuperCompletedCardMap:    dc.w    6
                dc.b    $88,  $F, $61, $B5, $FF, $D8
                dc.b    $88,  $F, $61, $C5, $FF, $F8
                dc.b    $88,   7, $61, $D5,   0, $18
                dc.b    $A8,  $E, $61, $DD, $FF, $D8
                dc.b    $A8,  $E, $61, $E9, $FF, $F8
                dc.b    $A8,   6, $61, $F5,   0, $18
SKSave_SuperEmeraldMap1:    dc.w    1
                dc.b    $CE,   5, $C2, $2F, $FF, $F8
SKSave_SuperEmeraldMap2:    dc.w    1
                dc.b    $D8,   5, $42, $33, $FF, $E4
SKSave_SuperEmeraldMap3:    dc.w    1
                dc.b    $D8,   5, $42, $37,   0,  $C
SKSave_SuperEmeraldMap4:    dc.w    1
                dc.b    $EE,   5, $42, $3B, $FF, $DF
SKSave_SuperEmeraldMap5:    dc.w    1
                dc.b    $EE,   5, $42, $3F,   0, $11
SKSave_SuperEmeraldMap6:    dc.w    1
                dc.b    $FF,   5, $C2, $43, $FF, $ED
SKSave_SuperEmeraldMap7:    dc.w    1
                dc.b    $FF,   5, $C2, $47,   0,   3
SKSave_AlternateCharacterCardMap:   dc.w    6
                dc.b    $88,  $F, $62, $7D, $FF, $D8
                dc.b    $A8,  $E, $62, $8D, $FF, $D8
                dc.b    $88,  $F, $62, $99, $FF, $F8
                dc.b    $A8,  $E, $62, $A9, $FF, $F8
                dc.b    $88,   7, $62, $B5,   0, $18
                dc.b    $A8,   6, $62, $BD,   0, $18

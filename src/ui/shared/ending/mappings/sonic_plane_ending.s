; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_SonicPlaneEnding_:
                dc.w    EndingPlaneExtra_EmptyActorFrame-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_ThreePiecePlaneMap1-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_ThreePiecePlaneMap2-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_FourPiecePlaneMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_NarrowBlinkMap-Map_SonicPlaneEnding_
                dc.w    EndingPlaneExtra_SquareAuxiliaryPiece-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_SmallDepartingPlaneMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_ExtendedStripMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_LongStripMapFrames8And9-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_LongStripMapFrames8And9-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_TailsAttachMap10And11-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_TailsAttachMap10And11-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_SonicPrimaryAttachmentMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_TailsPrimaryAttachmentMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_SonicSecondaryAttachMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_TailsSecondaryAttachMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_TwoPieceAttachmentMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_Pal2SingleTileMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_KnuxPlaneAttachmentMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_KnuxPrimaryAttachmentMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_KnuxMissingOutcomeMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_KnuxOtherOutcomeMap-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_PoseOffsetBlinkMap1-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_PoseOffsetBlinkMap2-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_ParentFlagBlinkMap1-Map_SonicPlaneEnding_
                dc.w    EndPlaneExtra_ParentFlagBlinkMap2-Map_SonicPlaneEnding_
                dc.w    EndingPlaneExtra_FinalSmallAircraftPiece-Map_SonicPlaneEnding_
EndingPlaneExtra_EmptyActorFrame:   dc.w    0
EndPlaneExtra_ThreePiecePlaneMap1:  dc.w    3
                dc.b    $F0,  $A,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   0,   9, $FF, $F8
                dc.b    $F8,   1,   0, $19,   0, $18
EndPlaneExtra_ThreePiecePlaneMap2:  dc.w    3
                dc.b    $F0,  $A,   0, $1B, $FF, $E0
                dc.b    $F0,  $F,   0, $24, $FF, $F8
                dc.b    $F8,   1,   0, $34,   0, $18
EndPlaneExtra_FourPiecePlaneMap:    dc.w    4
                dc.b    $F0,  $A,   0, $36, $FF, $E0
                dc.b    $E8,   9,   0, $3F,   0,   0
                dc.b    $F8,  $E,   0, $45, $FF, $F8
                dc.b    $F8,   1,   0, $51,   0, $18
EndPlaneExtra_NarrowBlinkMap:   dc.w    1
                dc.b    $F8,   1,   0, $53, $FF, $FC
EndingPlaneExtra_SquareAuxiliaryPiece:  dc.w    1
                dc.b    $F8,   5,   0, $55, $FF, $F8
EndPlaneExtra_SmallDepartingPlaneMap:   dc.w    2
                dc.b    $F8,   0,   0, $59,   0,   0
                dc.b    0,   4,   0, $5A, $FF, $F8
EndPlaneExtra_ExtendedStripMap: dc.w    $A
                dc.b    $F4,   2,   0, $5C, $FF, $F8
                dc.b    $FC,   0,   0, $5F,   0,   0
                dc.b    $FC,   0,   0, $60,   0,   0
                dc.b    $FC,   0,   0, $60,   0,   7
                dc.b    $FC,   0,   0, $60,   0,  $E
                dc.b    $FC,   0,   0, $60,   0, $15
                dc.b    $FC,   0,   0, $60,   0, $1C
                dc.b    $FC,   0,   0, $60,   0, $23
                dc.b    $FC,   0,   0, $60,   0, $2A
                dc.b    $FC,   0,   0, $60,   0, $31
EndPlaneExtra_LongStripMapFrames8And9:  dc.w    $A
                dc.b    $FA,   1,   0, $61, $FF, $E0
                dc.b    $FC,   0,   0, $63, $FF, $FC
                dc.b    $FC,   0,   0, $63, $FF, $F8
                dc.b    $FC,   0,   0, $63, $FF, $F4
                dc.b    $FC,   0,   0, $63, $FF, $F0
                dc.b    $FC,   0,   0, $63, $FF, $EC
                dc.b    $FC,   0,   0, $63, $FF, $E8
                dc.b    $FC,   0,   0, $63, $FF, $E4
                dc.b    $F8,  $D, $40, $79, $FF, $C4
                dc.b    8,   4, $40, $81, $FF, $CC
EndPlaneExtra_TailsAttachMap10And11:    dc.w    2
                dc.b    0,   0,   0, $64, $FF, $EC
                dc.b    $F8,   9,   0, $65, $FF, $F4
EndPlaneExtra_SonicPrimaryAttachmentMap:    dc.w    1
                dc.b    $FC,   4,   0, $6B, $FF, $F8
EndPlaneExtra_TailsPrimaryAttachmentMap:    dc.w    1
                dc.b    $FC,   4,   0, $6D, $FF, $F8
EndPlaneExtra_SonicSecondaryAttachMap:  dc.w    1
                dc.b    $F4,   6,   0, $6F, $FF, $F8
EndPlaneExtra_TailsSecondaryAttachMap:  dc.w    1
                dc.b    $F8,   5,   0, $75, $FF, $F4
EndPlaneExtra_TwoPieceAttachmentMap:    dc.w    2
                dc.b    $F4,  $D,   0, $79, $FF, $F0
                dc.b    4,   4,   0, $81, $FF, $F8
EndPlaneExtra_Pal2SingleTileMap:    dc.w    1
                dc.b    $FC,   0,   0, $83, $FF, $FC
EndPlaneExtra_KnuxPlaneAttachmentMap:   dc.w    2
                dc.b    0,   0, $20, $64, $FF, $EC
                dc.b    $F8,   9, $20, $65, $FF, $F4
EndPlaneExtra_KnuxPrimaryAttachmentMap: dc.w    1
                dc.b    $FC,   4, $20, $6D, $FF, $F8
EndPlaneExtra_KnuxMissingOutcomeMap:    dc.w    2
                dc.b    $F0,   9,   0, $89, $FF, $F0
                dc.b    0,   4,   0, $8F, $FF, $F8
EndPlaneExtra_KnuxOtherOutcomeMap:  dc.w    4
                dc.b    $F0,   9,   0, $89, $FF, $F0
                dc.b    0,   4,   0, $8F, $FF, $F8
                dc.b    $E8,  $D, $40, $79, $FF, $F2
                dc.b    $F8,   4, $40, $81, $FF, $FA
EndPlaneExtra_PoseOffsetBlinkMap1:  dc.w    1
                dc.b    $FC,   4,   0, $84, $FF, $F4
EndPlaneExtra_PoseOffsetBlinkMap2:  dc.w    1
                dc.b    $FC,   0,   0, $86, $FF, $FC
EndPlaneExtra_ParentFlagBlinkMap1:  dc.w    1
                dc.b    $FC,   0,   0, $87, $FF, $FC
EndPlaneExtra_ParentFlagBlinkMap2:  dc.w    1
                dc.b    $FC,   0,   0, $88, $FF, $FC
EndingPlaneExtra_FinalSmallAircraftPiece:   dc.w    1
                dc.b    0,   4,   0, $5A, $FF, $F8

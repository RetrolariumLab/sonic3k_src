; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_SonicPlane_:
                dc.w    EndingPlaneMapping_EmptyActorFrame-Map_SonicPlane_
                dc.w    EndPlane_MainBodyMap-Map_SonicPlane_
                dc.w    EndPlane_NarrowPanelMap1-Map_SonicPlane_
                dc.w    EndPlane_NarrowPanelMap2-Map_SonicPlane_
                dc.w    EndPlane_NarrowPanelMap3-Map_SonicPlane_
                dc.w    EndPlane_NarrowPanelMap4-Map_SonicPlane_
                dc.w    EndPlane_WideThreePieceMap1-Map_SonicPlane_
                dc.w    EndPlane_WideThreePieceMap2-Map_SonicPlane_
                dc.w    EndPlane_EightPieceStripMap-Map_SonicPlane_
                dc.w    EndPlane_SixPieceStripMap-Map_SonicPlane_
                dc.w    EndPlane_MirroredStripMap-Map_SonicPlane_
                dc.w    EndingPlaneMapping_MirroredTwoPieceStrip-Map_SonicPlane_
                dc.w    EndPlane_SonicModeAttachmentMap-Map_SonicPlane_
EndingPlaneMapping_EmptyActorFrame: dc.w    0
EndPlane_MainBodyMap:               dc.w    8
                dc.b    $E0,   9,   0,   0, $FF, $C4
                dc.b    $F0,  $E,   0,   6, $FF, $C4
                dc.b    $F0,   7,   0, $12, $FF, $E4
                dc.b    $F8,  $A,   0, $20, $FF, $F4
                dc.b    $E8,  $D,   0, $29,   0,  $C
                dc.b    $E8,   0,   0, $31,   0, $2C
                dc.b    $F8,  $E,   0, $32,   0,  $C
                dc.b    $10,   5,   0, $44,   0, $1C
EndPlane_NarrowPanelMap1:   dc.w    1
                dc.b    $F4,   6,   0, $3E, $FF, $F8
EndPlane_NarrowPanelMap2:   dc.w    1
                dc.b    $F4,   6,   0, $48, $FF, $F8
EndPlane_NarrowPanelMap3:   dc.w    1
                dc.b    $F4,   6,   0, $4E, $FF, $F8
EndPlane_NarrowPanelMap4:   dc.w    1
                dc.b    $F4,   6,   0, $54, $FF, $F8
EndPlane_WideThreePieceMap1:    dc.w    3
                dc.b    $F8,  $D,   0, $5A, $FF, $E4
                dc.b    $F8,   9,   0, $62,   0,   4
                dc.b    $F8,  $D,   0, $68, $FF, $C4
EndPlane_WideThreePieceMap2:    dc.w    3
                dc.b    $F8,  $D,   0, $5A, $FF, $E4
                dc.b    $F8,   9,   0, $62,   0,   4
                dc.b    $F8,   5,   0, $70, $FF, $D4
EndPlane_EightPieceStripMap:    dc.w    8
                dc.b    $F8,   5,   0, $74, $FF, $C4
                dc.b    $F8,   5,   0, $78, $FF, $D4
                dc.b    $F8,   5,   0, $78, $FF, $E4
                dc.b    $F8,   5,   0, $78, $FF, $F4
                dc.b    $F8,   5,   0, $78,   0,   4
                dc.b    $F8,   5,   0, $78,   0, $14
                dc.b    $F8,   1,   0, $78,   0, $24
                dc.b    $F8,   5,   8, $74,   0, $2C
EndPlane_SixPieceStripMap:  dc.w    6
                dc.b    $F8,   5,   0, $7C, $FF, $D0
                dc.b    $F8,   5,   0, $80, $FF, $E0
                dc.b    $F8,   5,   0, $80, $FF, $F0
                dc.b    $F8,   5,   0, $80,   0,   0
                dc.b    $F8,   5,   0, $80,   0, $10
                dc.b    $F8,   5,   8, $7C,   0, $20
EndPlane_MirroredStripMap:  dc.w    3
                dc.b    $FC,  $C,   0, $84, $FF, $DC
                dc.b    $FC,   0,   0, $85, $FF, $FC
                dc.b    $FC,  $C,   8, $84,   0,   4
EndingPlaneMapping_MirroredTwoPieceStrip:   dc.w    2
                dc.b    $FC,   8,   0, $88, $FF, $E8
                dc.b    $FC,   8,   8, $88,   0,   0
EndPlane_SonicModeAttachmentMap:    dc.w    1
                dc.b    $F8,   9,   0, $1A, $FF, $F4

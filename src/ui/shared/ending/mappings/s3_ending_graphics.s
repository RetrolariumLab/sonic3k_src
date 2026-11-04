; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_EndingGraphics_:
                dc.w    S3EndingMapping_BouncingLogoPieces-Map_EndingGraphics_
                dc.w    S3End_LogoCharacterIdleMap1-Map_EndingGraphics_
                dc.w    S3End_LogoCharacterIdleMap2-Map_EndingGraphics_
                dc.w    S3End_LogoCharacterReadyMap-Map_EndingGraphics_
                dc.w    S3End_LogoCharacterHeldMap-Map_EndingGraphics_
                dc.w    S3End_LogoAttachmentMap1-Map_EndingGraphics_
                dc.w    S3End_LogoAttachmentMap2-Map_EndingGraphics_
                dc.w    S3End_LogoAttachmentMap3-Map_EndingGraphics_
                dc.w    S3End_LogoAttachmentMap4-Map_EndingGraphics_
                dc.w    S3End_LogoAttachmentMap5-Map_EndingGraphics_
                dc.w    S3End_LogoSideActorMap1-Map_EndingGraphics_
                dc.w    S3End_LogoSideActorMap2-Map_EndingGraphics_
                dc.w    S3End_TryAgainLoopMap1-Map_EndingGraphics_
                dc.w    S3End_TryAgainLoopMap2-Map_EndingGraphics_
                dc.w    S3End_TryAgainActionMap1-Map_EndingGraphics_
                dc.w    S3End_TryAgainActionMap2-Map_EndingGraphics_
                dc.w    S3End_TryAgainActionMap3-Map_EndingGraphics_
S3EndingMapping_BouncingLogoPieces: dc.w    $10
                dc.b    $C0,  $F,   0,   0, $FF, $C0
                dc.b    $C0,  $F,   0, $10, $FF, $E0
                dc.b    $C0,  $F,   0, $20,   0,   0
                dc.b    $C0,  $F,   0, $30,   0, $20
                dc.b    $E0,   7,   0, $40,   0, $30
                dc.b    $E0,  $A,   0, $48,   0, $18
                dc.b    $E0,  $F,   0, $51, $FF, $F8
                dc.b    $E0,  $F,   0, $61, $FF, $D8
                dc.b    $E0,   8,   0, $71, $FF, $C0
                dc.b    $E8,   0,   0, $74, $FF, $D0
                dc.b    0,   6,   0, $75, $FF, $E8
                dc.b    0,  $F,   0, $7B, $FF, $F8
                dc.b    $18,   3,   0, $8B,   0, $18
                dc.b    $20,  $F,   0, $8F, $FF, $F8
                dc.b    $18,   1,   0, $9F, $FF, $F0
                dc.b    $28,   6,   0, $A1, $FF, $E8
S3End_LogoCharacterIdleMap1:    dc.w    3
                dc.b    $EC,  $B,   0, $A7, $FF, $F4
                dc.b    $F4,   1,   0, $B3,   0,  $C
                dc.b    $C,   8,   0, $B5, $FF, $FC
S3End_LogoCharacterIdleMap2:    dc.w    3
                dc.b    $EC,  $B,   0, $A7, $FF, $F4
                dc.b    $F4,   1,   0, $B3,   0,  $C
                dc.b    $C,   8,   0, $B8, $FF, $FC
S3End_LogoCharacterReadyMap:    dc.w    4
                dc.b    $F4,   0,   0, $BB, $FF, $EC
                dc.b    $EC,   9,   0, $BC, $FF, $F4
                dc.b    $FC,  $D,   0, $C2, $FF, $F4
                dc.b    $C,   4,   0, $CA, $FF, $FC
S3End_LogoCharacterHeldMap: dc.w    3
                dc.b    $F4,   0,   0, $CC, $FF, $EC
                dc.b    $EC,  $E,   0, $CD, $FF, $F4
                dc.b    4,   9,   0, $D9, $FF, $F4
S3End_LogoAttachmentMap1:   dc.w    1
                dc.b    $F4,   6,   0, $DF, $FF, $FC
S3End_LogoAttachmentMap2:   dc.w    2
                dc.b    $F4,   0,   0, $E5,   0,   4
                dc.b    $FC,   9,   0, $E6, $FF, $F4
S3End_LogoAttachmentMap3:   dc.w    2
                dc.b    $F4,   4,   0, $EC, $FF, $FC
                dc.b    $FC,   9,   0, $EE, $FF, $F4
S3End_LogoAttachmentMap4:   dc.w    1
                dc.b    $FC,   9,   0, $F4, $FF, $F4
S3End_LogoAttachmentMap5:   dc.w    2
                dc.b    $F4,   4,   0, $FA, $FF, $FC
                dc.b    $FC,   9,   0, $FC, $FF, $F4
S3End_LogoSideActorMap1:    dc.w    2
                dc.b    $EC,   0,   1,   2, $FF, $F4
                dc.b    $F4,  $B,   1,   3, $FF, $F4
S3End_LogoSideActorMap2:    dc.w    2
                dc.b    $EC,   0,   1,   2, $FF, $F4
                dc.b    $F4,  $B,   1,  $F, $FF, $F4
S3End_TryAgainLoopMap1: dc.w    5
                dc.b    $E4,   0,   1, $1B, $FF, $FC
                dc.b    $EC,  $F,   1, $1C, $FF, $EC
                dc.b    $EC,   2,   1, $2C,   0,  $C
                dc.b    $C,  $D,   1, $2F, $FF, $EC
                dc.b    $14,   0,   1, $37,   0,  $C
S3End_TryAgainLoopMap2: dc.w    5
                dc.b    $E4,   0,   1, $38, $FF, $FC
                dc.b    $EC,  $F,   1, $39, $FF, $EC
                dc.b    $F4,   1,   1, $49,   0,  $C
                dc.b    $C,  $D,   1, $4B, $FF, $EC
                dc.b    $14,   0,   1, $37,   0,  $C
S3End_TryAgainActionMap1:   dc.w    2
                dc.b    $EC,   9,   1, $53, $FF, $F0
                dc.b    $FC,  $E,   1, $59, $FF, $F0
S3End_TryAgainActionMap2:   dc.w    2
                dc.b    $EC,   9,   1, $53, $FF, $F0
                dc.b    $FC,  $E,   1, $65, $FF, $F0
S3End_TryAgainActionMap3:   dc.w    3
                dc.b    $EC,  $B,   1, $71, $FF, $F0
                dc.b    $F4,   1,   1, $7D,   0,   8
                dc.b    $C,  $C,   1, $7F, $FF, $F0

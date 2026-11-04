; Owner: objects/interface/sk
; Responsibility: Special-stage results object initialization records and callback catalog
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKSSResults_InitialElementRecords:
                dc.l    SKSSResults_SetSpecialTextFrame
                dc.w    $120,  $4E0,  $100
                dc.b    $17, $60
                dc.l    SKSSResults_SetSpecialTextFrame
                dc.w    $C0,  $4C0,  $118
                dc.b    $18, $58
                dc.l    SKSSResults_MoveAndReadRingBonus
                dc.w    $178,  $578,  $118
                dc.b    1, $40
                dc.l    SKSSResults_SetSpecialTextFrame
                dc.w    $C0,  $500,  $128
                dc.b    $19, $40
                dc.l    SKSSResults_MoveAndReadPerfectBonus
                dc.w    $178,  $5B8,  $128
                dc.b    1, $40
                dc.l    SKSSResults_Keep50RingContinueLabel
                dc.w    $C0,  $540,  $138
                dc.b    $1A, $48
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $120,  $120,   $D0
                dc.b    $1B,   0
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $110,  $110,   $E8
                dc.b    $1C,   1
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $130,  $130,   $E8
                dc.b    $1D,   2
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $100,  $100,   $D0
                dc.b    $1E,   3
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $140,  $140,   $D0
                dc.b    $1F,   4
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $F0,   $F0,   $E8
                dc.b    $20,   5
                dc.l    SKSSResults_BlinkCollectedEmerald
                dc.w    $150,  $150,   $E8
                dc.b    $21,   6
                dc.l    SKSSResults_KeepFailureWithOrdinaryArt
                dc.w    $120,  $460,   $A0
                dc.b    $22, $60
                dc.l    SKSSResults_ShiftSuccessNameForFullSet
                dc.w    $D4,  $394,   $98
                dc.b    $13, $48
                dc.l    SKSSResults_PrepCompanionTextForFullSet
                dc.w    $124,  $3E4,   $98
                dc.b    $23, $48
                dc.l    SKSSResults_SelectChaosOrSuperText
                dc.w    $120,  $460,   $B0
                dc.b    $24, $64
                dc.l    SKSSResults_KeepExtraTextForFullSet
                dc.w    $114,  $3D4,   $98
                dc.b    $25, $20
                dc.l    SKSSResults_KeepSuffixForSelectedSet
                dc.w    $118,  $458,   $B0
                dc.b    $26, $10
SKSSResults_FullSetMessageRecords:
                dc.l    SKSSResults_ApplyNameOffsetAndMove
                dc.w    $C0,  $3C0,   $98
                dc.b    $27, $38
                dc.l    SKSSResults_SetNameFrameAndWrappedArt
                dc.w    $100,  $400,   $98
                dc.b    $13, $48
                dc.l    SKSSResults_ApplyOppositeNameOffset
                dc.w    $150,  $450,   $98
                dc.b    $3A, $30
                dc.l    SKSSResults_ApplyNameOffsetAndMove
                dc.w    $C0,  $440,   $B0
                dc.b    $28, $20
                dc.l    SKSSResults_SetLockOnKnuxTextArt
                dc.w    $E8,  $468,   $B0
                dc.b    $12, $50
                dc.l    SKSSResults_SetNameFrameAndWrappedArt
                dc.w    $138,  $4B8,   $B0
                dc.b    $13, $48
SKSSResults_AltFullSetMessageRecords:
                dc.l    SKSSResults_SetNameFrameAndWrappedArt
                dc.w    $B8,  $3B8,   $98
                dc.b    $13, $48
                dc.l    SKSSResults_ApplyOppositeNameOffset
                dc.w    $148,  $448,   $98
                dc.b    $2E, $40
                dc.l    SKSSResults_MoveElementAndDraw
                dc.w    $120,  $4A0,   $B0
                dc.b    $2F, $60
SKSSResults_FinalHyperMessageRecords:
                dc.l    SKSSResults_ApplyNameOffsetAndMove
                dc.w    $C0,  $3C0,  $124
                dc.b    $2C, $38
                dc.l    SKSSResults_SetNameFrameAndWrappedArt
                dc.w    $100,  $400,  $124
                dc.b    $13, $48
                dc.l    SKSSResults_ApplyOppositeNameOffset
                dc.w    $150,  $450,  $124
                dc.b    $2D, $30
                dc.l    SKSSResults_ApplyNameOffsetAndMove
                dc.w    $C0,  $440,  $13C
                dc.b    $35, $20
                dc.l    SKSSResults_SetLockOnKnuxTextArt
                dc.w    $E8,  $468,  $13C
                dc.b    $12, $50
                dc.l    SKSSResults_SetNameFrameAndWrappedArt
                dc.w    $138,  $4B8,  $13C
                dc.b    $13, $48
                dc.l    SKSSResults_ReleasePaletteOnPriorArrival
                dc.w    0,     0,     0
                dc.b    0,   0

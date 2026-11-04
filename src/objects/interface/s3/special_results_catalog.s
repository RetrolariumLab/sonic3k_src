; Owner: objects/interface/s3
; Responsibility: Special-stage results object initialization records and callback catalog
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3SSResults_InitialElementRecords:
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $120,  $4E0,  $100
                dc.b    $17, $60
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $C0,  $4C0,  $118
                dc.b    $18, $58
                dc.l    S3SSResults_MoveAndReadRingBonus
                dc.w    $178,  $578,  $118
                dc.b    1, $40
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $C0,  $500,  $128
                dc.b    $19, $40
                dc.l    S3SSResults_MoveAndReadPerfectBonus
                dc.w    $178,  $5B8,  $128
                dc.b    1, $40
                dc.l    S3SSResults_Keep50RingContinueLabel
                dc.w    $C0,  $540,  $138
                dc.b    $1A, $48
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $120,  $120,   $D0
                dc.b    $1B,   0
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $110,  $110,   $E8
                dc.b    $1C,   1
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $130,  $130,   $E8
                dc.b    $1D,   2
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $100,  $100,   $D0
                dc.b    $1E,   3
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $140,  $140,   $D0
                dc.b    $1F,   4
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $F0,   $F0,   $E8
                dc.b    $20,   5
                dc.l    S3SSResults_BlinkCollectedEmerald
                dc.w    $150,  $150,   $E8
                dc.b    $21,   6
                dc.l    S3SSResults_KeepFailureWithSpheresLeft
                dc.w    $120,  $460,   $A0
                dc.b    $22, $60
                dc.l    S3SSResults_PrepSuccessNameAndFullShift
                dc.w    $D4,  $394,   $98
                dc.b    $13, $48
                dc.l    S3SSResults_PrepOppositeNameOffsetText
                dc.w    $124,  $3E4,   $98
                dc.b    $23, $48
                dc.l    S3SSResults_PrepEmeraldTextAndFullShift
                dc.w    $120,  $460,   $B0
                dc.b    $24, $64
                dc.l    S3SSResults_KeepExtraTextForFullSet
                dc.w    $114,  $3D4,   $98
                dc.b    $25, $20
                dc.l    S3SSResults_KeepSuffixAfterClear
                dc.w    $118,  $458,   $B0
                dc.b    $26, $10
S3SSResults_PostCollectionMessageRecords:
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $120,  $420,   $98
                dc.b    $27, $60
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $100,  $400,   $98
                dc.b    $13, $48
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $C0,  $440,   $B0
                dc.b    $28, $20
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $E8,  $468,   $B0
                dc.b    $12, $50
                dc.l    S3SSResults_MoveElementAndDraw
                dc.w    $138,  $4B8,   $B0
                dc.b    $13, $48

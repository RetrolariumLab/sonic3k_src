; Data owner: ui/shared/title
; Provenance and source range: config/reconstruction/source_layout.json
Map_TitleSonicAnim_:
                dc.w    SharedTitleSonic_FirstFingerStatePieces-Map_TitleSonicAnim_
                dc.w    SharedTitleSonic_SecondFingerStatePieces-Map_TitleSonicAnim_
                dc.w    SharedTitleSonic_FirstWinkStatePieces-Map_TitleSonicAnim_
                dc.w    SharedTitleSonic_SecondWinkStatePieces-Map_TitleSonicAnim_
                dc.w    S3Title_HiddenFingerAndWinkMap-Map_TitleSonicAnim_
SharedTitleSonic_FirstFingerStatePieces:    dc.w    4
                dc.b    $E4,  $B,   0,   0, $FF, $E8
                dc.b    $E4,  $B,   0,  $C,   0,   0
                dc.b    4,  $A,   0, $18, $FF, $E8
                dc.b    4,  $A,   0, $21,   0,   0
SharedTitleSonic_SecondFingerStatePieces:   dc.w    4
                dc.b    $E4,  $B,   0, $2A, $FF, $E8
                dc.b    $E4,  $B,   0, $36,   0,   0
                dc.b    4,  $A,   0, $42, $FF, $E8
                dc.b    4,  $A,   0, $4B,   0,   0
SharedTitleSonic_FirstWinkStatePieces:  dc.w    2
                dc.b    $E8,  $F,   0, $54, $FF, $F0
                dc.b    8,  $D,   0, $64, $FF, $F0
SharedTitleSonic_SecondWinkStatePieces: dc.w    2
                dc.b    $E8,  $F,   0, $6C, $FF, $F0
                dc.b    8,  $D,   0, $7C, $FF, $F0
S3Title_HiddenFingerAndWinkMap: dc.w    0

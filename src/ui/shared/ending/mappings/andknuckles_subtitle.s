; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_ANDKnuckles_:
                dc.w    EndingAndKnuckles_NarrowSubtitlePieces-Map_ANDKnuckles_
                dc.w    EndingAndKnuckles_WideSubtitlePieces-Map_ANDKnuckles_
                dc.w    EndSubtitle_RegionMarkMap-Map_ANDKnuckles_
EndingAndKnuckles_NarrowSubtitlePieces: dc.w    2
                dc.b    $FC,  $C,   0,   0, $FF, $E0
                dc.b    $FC,  $C,   0,   4,   0,   0
EndingAndKnuckles_WideSubtitlePieces:   dc.w    4
                dc.b    $F8,  $D,   0,   8, $FF, $C8
                dc.b    $F8,  $D,   0, $10, $FF, $E8
                dc.b    $F8,  $D,   0, $18,   0,   8
                dc.b    $F8,   5,   0, $20,   0, $28
EndSubtitle_RegionMarkMap:  dc.w    1
                dc.b    $FC,   4,   0, $24, $FF, $F8

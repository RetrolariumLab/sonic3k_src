; Data owner: ui/shared/title
; Provenance and source range: config/reconstruction/source_layout.json
Map_SKTitle_Icon_:
                dc.w    SKTitleIcon_FirstChoiceFrontNameMap-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_SecondChoiceFrontNameMap-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_FirstChoiceBackNameMap-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_SecondChoiceBackNameMap-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_NeutralPortraitMap-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_FirstChoiceLoopMap1-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_FirstChoiceLoopMap2-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_SecondChoiceLoopMap1-Map_SKTitle_Icon_
                dc.w    SKTitleIcon_SecondChoiceLoopMap2-Map_SKTitle_Icon_
SKTitleIcon_FirstChoiceFrontNameMap:    dc.w    2
                dc.b    $F8,  $D,   0,   0, $FF, $DC
                dc.b    $F8,  $D,   0,   8, $FF, $FC
SKTitleIcon_SecondChoiceFrontNameMap:   dc.w    2
                dc.b    $F8,  $D,   0, $10, $FF, $DC
                dc.b    $F8,  $D,   0, $18, $FF, $FC
SKTitleIcon_FirstChoiceBackNameMap: dc.w    4
                dc.b    $F7,  $D, $20, $20, $FF, $DB
                dc.b    $F7,  $D, $20, $28, $FF, $FB
                dc.b    $F7,  $D, $20, $30,   0, $1B
                dc.b    $F7,   1, $20, $38,   0, $3B
SKTitleIcon_SecondChoiceBackNameMap:    dc.w    4
                dc.b    $F7,  $D, $20, $3A, $FF, $DB
                dc.b    $F7,  $D, $20, $42, $FF, $FB
                dc.b    $F7,  $D, $20, $4A,   0, $1B
                dc.b    $F7,   1, $20, $52,   0, $3B
SKTitleIcon_NeutralPortraitMap: dc.w    1
                dc.b    $F4,  $A,   0, $66, $FF, $F4
SKTitleIcon_FirstChoiceLoopMap1:    dc.w    1
                dc.b    $F4,  $A,   0, $54, $FF, $F4
SKTitleIcon_FirstChoiceLoopMap2:    dc.w    1
                dc.b    $F4,  $A,   0, $5D, $FF, $F4
SKTitleIcon_SecondChoiceLoopMap1:   dc.w    1
                dc.b    $F4,  $A, $20, $6F, $FF, $F4
SKTitleIcon_SecondChoiceLoopMap2:   dc.w    1
                dc.b    $F4,  $A, $20, $78, $FF, $F4

; Data owner: objects/shared/buttons
; Provenance and source range: config/reconstruction/source_layout.json
Map_Button_:
                dc.w    SharedButtonMapping_Frame00-Map_Button_
                dc.w    SharedButtonMapping_Frame01-Map_Button_
                dc.w    SharedButtonMapping_DebugPreviewFrame02-Map_Button_
SharedButtonMapping_Frame00:    dc.w    2               ; DATA XREF: ROM:0002C71E o
                dc.b    $F4,  $C,   0,   0, $FF, $F0
                dc.b    $FC,   4,   0,   4, $FF, $F8
SharedButtonMapping_Frame01:    dc.w    1               ; DATA XREF: ROM:0002C71E o
                dc.b    $FC,  $C,   0,   0, $FF, $F0
SharedButtonMapping_DebugPreviewFrame02:    dc.w    2   ; DATA XREF: ROM:0002C71E o
                dc.b    $F8,  $C,   0,   0, $FF, $F0
                dc.b    0,   4,   0,   4, $FF, $F8

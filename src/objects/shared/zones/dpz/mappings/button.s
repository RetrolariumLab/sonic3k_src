; Data owner: objects/shared/zones/dpz
; Provenance and source range: config/reconstruction/source_layout.json
Map_DPZButton_:
                dc.w    CommonDPZButton_UnpressedMapFrame-Map_DPZButton_
                dc.w    CommonDPZButton_PressedMapFrame-Map_DPZButton_
CommonDPZButton_UnpressedMapFrame:  dc.w    1
                dc.b    $FC,   8,   0, $9C, $FF, $F4
CommonDPZButton_PressedMapFrame:    dc.w    1
                dc.b    $FC,   8,   0, $9F, $FF, $F4

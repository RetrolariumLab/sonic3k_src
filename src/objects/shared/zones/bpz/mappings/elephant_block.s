; Data owner: objects/shared/zones/bpz
; Provenance and source range: config/reconstruction/source_layout.json
Map_BPZElephantBlock_:
                dc.w    BPZElephant_EmbeddedMapFrame0-Map_BPZElephantBlock_
                dc.w    BPZElephant_EmbeddedMapFrame1-Map_BPZElephantBlock_
BPZElephant_EmbeddedMapFrame0:  dc.w    2
                dc.b    $F0,  $F,   0, $6E, $FF, $F8
                dc.b    $F0,  $F,   0, $7E,   0, $18
BPZElephant_EmbeddedMapFrame1:  dc.w    3
                dc.b    $F0,  $F,   0, $6E, $FF, $F8
                dc.b    $F0,  $F,   0, $7E,   0, $18
                dc.b    $F0,  $F,   0, $7E,   0, $38

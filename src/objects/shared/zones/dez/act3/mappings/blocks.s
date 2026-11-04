; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZ3Blocks_:
                dc.w    DEZMap_Act3Blocks_InitialColumnPattern-Map_DEZ3Blocks_
                dc.w    DEZ3BlockMap_MiddleColumn-Map_DEZ3Blocks_
                dc.w    DEZ3BlockMap_MiddleColumn-Map_DEZ3Blocks_
                dc.w    DEZMap_Act3Blocks_LastColumnPattern-Map_DEZ3Blocks_
DEZMap_Act3Blocks_InitialColumnPattern: dc.w    4
                dc.b    $F0,   5,   0,   0, $FF, $F0
                dc.b    $F0,   5,   0,   4,   0,   0
                dc.b    0,   5,   0, $10, $FF, $F0
                dc.b    0,   5,   0, $14,   0,   0
DEZ3BlockMap_MiddleColumn:  dc.w    4
                dc.b    $F0,   5,   0,   8, $FF, $F0
                dc.b    $F0,   5,   0,   4,   0,   0
                dc.b    0,   5,   0, $18, $FF, $F0
                dc.b    0,   5,   0, $14,   0,   0
DEZMap_Act3Blocks_LastColumnPattern:    dc.w    4
                dc.b    $F0,   5,   0,   8, $FF, $F0
                dc.b    $F0,   5,   0,  $C,   0,   0
                dc.b    0,   5,   0, $18, $FF, $F0
                dc.b    0,   5,   0, $10,   0,   0

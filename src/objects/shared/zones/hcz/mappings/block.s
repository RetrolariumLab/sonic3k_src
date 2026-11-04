; Data owner: objects/shared/zones/hcz
; Provenance and source range: config/reconstruction/source_layout.json
Map_HCZBlock_:
                dc.w    HCZBlockS3_MapSlot00-Map_HCZBlock_
                dc.w    HCZBlockS3_MapSlot01-Map_HCZBlock_
                dc.w    HCZBlockS3_MapSlot02-Map_HCZBlock_
                dc.w    HCZBlockS3_MapSlot03-Map_HCZBlock_
HCZBlockS3_MapSlot00:   dc.w    1
                dc.b    $F0,  $F,   0,   0, $FF, $F0
HCZBlockS3_MapSlot01:   dc.w    2
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   0,   0,   0,   0
HCZBlockS3_MapSlot02:   dc.w    3
                dc.b    $F0,  $F,   0,   0, $FF, $D0
                dc.b    $F0,  $F,   0,   0, $FF, $F0
                dc.b    $F0,  $F,   0,   0,   0, $10
HCZBlockS3_MapSlot03:   dc.w    4
                dc.b    $F0,  $F,   0,   0, $FF, $C0
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   0,   0,   0,   0
                dc.b    $F0,  $F,   0,   0,   0, $20

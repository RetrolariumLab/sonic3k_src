; Data owner: objects/shared/buggernaut
; Provenance and source range: config/reconstruction/source_layout.json
Map_Buggernaut_:
                dc.w    BuggernautS3_MapFrame00-Map_Buggernaut_
                dc.w    BuggernautS3_MapFrame01-Map_Buggernaut_
                dc.w    BuggernautS3_MapFrame02-Map_Buggernaut_
                dc.w    BuggernautS3_MapFrame03-Map_Buggernaut_
                dc.w    BuggernautS3_MapFrame04-Map_Buggernaut_
                dc.w    BuggernautS3_MapFrame05-Map_Buggernaut_
BuggernautS3_MapFrame00:    dc.w    1
                dc.b    $F8,   9,   0,   0, $FF, $F4
BuggernautS3_MapFrame01:    dc.w    3
                dc.b    $F8,   9,   0,   0, $FF, $F4
                dc.b    $EC,   5,   0,   6,   0,   4
                dc.b    $EC,   5,   8,   6, $FF, $F0
BuggernautS3_MapFrame02:    dc.w    3                   ; 4 pieces are defined
                dc.b    $F8,   9,   0,   0, $FF, $F4
                dc.b    $F8,   5,   0,   6, $FF, $F8
                dc.b    $FC,   5, $10,   6,   0,   4
                dc.b    $FC,   5, $18,   6, $FF, $F0
BuggernautS3_MapFrame03:    dc.w    1
                dc.b    $F8,   5,   0,  $A, $FF, $F8
BuggernautS3_MapFrame04:    dc.w    3
                dc.b    $F8,   5,   0,  $A, $FF, $F8
                dc.b    $F5,   4,   0,  $E,   0,   0
                dc.b    $F5,   4,   8,  $E, $FF, $F4
BuggernautS3_MapFrame05:    dc.w    3
                dc.b    $F8,   5,   0,  $A, $FF, $F8
                dc.b    $FD,   4, $10,  $E,   0,   0
                dc.b    $FD,   4, $18,  $E, $FF, $F4

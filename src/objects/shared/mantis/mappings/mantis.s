; Data owner: objects/shared/mantis
; Provenance and source range: config/reconstruction/source_layout.json
Map_Mantis_:
                dc.w    MantisS3_MapFrame00-Map_Mantis_
                dc.w    MantisS3_MapFrame01-Map_Mantis_
                dc.w    MantisS3_MapFrame02-Map_Mantis_
                dc.w    MantisS3_MapFrame03-Map_Mantis_
                dc.w    MantisS3_MapFrame04-Map_Mantis_
                dc.w    MantisS3_MapFrame05-Map_Mantis_
MantisS3_MapFrame00:    dc.w    3
                dc.b    $FA,  $A,   0,   9,   0,   0
                dc.b    $F4,  $A,   0,   0, $FF, $F4
                dc.b    $FA,  $A,   0,   9, $FF, $F8
MantisS3_MapFrame01:    dc.w    3
                dc.b    0,  $A,   0, $12,   0,   2
                dc.b    $F4,  $A,   0,   0, $FF, $F4
                dc.b    0,  $A,   0, $12, $FF, $FA
MantisS3_MapFrame02:    dc.w    7
                dc.b    2,   5,   0, $1B,   0,   7
                dc.b    $12,   1,   0, $1F,   0,  $F
                dc.b    $22,   4,   0, $21,   0,   7
                dc.b    $F4,  $A,   0,   0, $FF, $F4
                dc.b    2,   5,   0, $1B, $FF, $FF
                dc.b    $12,   1,   0, $1F,   0,   7
                dc.b    $22,   4,   0, $21, $FF, $FF
MantisS3_MapFrame03:    dc.w    3
                dc.b    $F9,  $A,   0,   9,   0,   0
                dc.b    $F4,  $A,   0,   0, $FF, $F4
                dc.b    $F9,  $A,   0,   9, $FF, $F8
MantisS3_MapFrame04:    dc.w    1
                dc.b    $FC,   0,   0, $23, $FF, $FC
MantisS3_MapFrame05:    dc.w    1
                dc.b    $FC,   0,   0, $24, $FF, $FC

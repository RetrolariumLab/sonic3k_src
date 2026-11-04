; Data owner: objects/shared/tails
; Provenance and source range: config/reconstruction/source_layout.json
Map_SStageTails_:
                dc.w    S3SpecialStageTails_EmptyMappingAndDplcFrame00-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame01-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame02-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame03-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame04-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame05-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame06-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame07-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame08-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame09-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame0A-Map_SStageTails_
                dc.w    S3SpecialStageTails_MappingFrame0B-Map_SStageTails_
PLC_SStageTails:
PLC_SStageTails_:
                dc.w    S3SpecialStageTails_EmptyMappingAndDplcFrame00-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame01-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame02-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame03-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame04-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame05-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame06-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame07-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame08-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame09-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame0A-PLC_SStageTails_
                dc.w    S3SpecialStageTails_DplcFrame0B-PLC_SStageTails_
S3SpecialStageTails_EmptyMappingAndDplcFrame00: dc.w    0
S3SpecialStageTails_MappingFrame09:             dc.w    1
                dc.b    $DD,  $B,   0,   0, $FF, $F4
S3SpecialStageTails_MappingFrame0A: dc.w    1
                dc.b    $DD,  $B,   0,   0, $FF, $F4
S3SpecialStageTails_MappingFrame0B: dc.w    1
                dc.b    $DD,  $B,   0,   0, $FF, $F4
S3SpecialStageTails_MappingFrame01: dc.w    2
                dc.b    $E1,  $C,   0,   0, $FF, $F4
                dc.b    $E9,  $B,   0,   4, $FF, $F4
S3SpecialStageTails_MappingFrame02: dc.w    3
                dc.b    $DD,  $C,   0,   0, $FF, $F3
                dc.b    $E5,  $B,   0,   4, $FF, $F3
                dc.b    5,   8,   0, $10, $FF, $F3
S3SpecialStageTails_MappingFrame03: dc.w    3
                dc.b    $DD,  $C,   0,   0, $FF, $F4
                dc.b    $E5,  $B,   0,   4, $FF, $F4
                dc.b    5,   4,   0, $10, $FF, $F4
S3SpecialStageTails_MappingFrame04: dc.w    3
                dc.b    $DD,  $B,   0,   0, $FF, $F5
                dc.b    $FD,   8,   0,  $C, $FF, $F5
                dc.b    5,   4,   0,  $F, $FF, $F5
S3SpecialStageTails_MappingFrame05: dc.w    3
                dc.b    $DD,  $C,   0,   0, $FF, $F4
                dc.b    $E5,  $B,   0,   4, $FF, $F4
                dc.b    5,   0,   0, $10, $FF, $F4
S3SpecialStageTails_MappingFrame06: dc.w    3
                dc.b    $DD,  $C,   8,   0, $FF, $EC
                dc.b    $E5,  $B,   8,   4, $FF, $F4
                dc.b    5,   4,   8, $10, $FF, $FC
S3SpecialStageTails_MappingFrame07: dc.w    3
                dc.b    $DD,  $B,   8,   0, $FF, $F3
                dc.b    $FD,   8,   8,  $C, $FF, $F3
                dc.b    5,   4,   8,  $F, $FF, $FB
S3SpecialStageTails_MappingFrame08: dc.w    3
                dc.b    $DD,  $C,   8,   0, $FF, $EC
                dc.b    $E5,  $B,   8,   4, $FF, $F4
                dc.b    5,   0,   8, $10,   0,   4
S3SpecialStageTails_DplcFrame09:    dc.w    1
                dc.w    $B000
S3SpecialStageTails_DplcFrame0A:    dc.w    1
                dc.w    $B00C
S3SpecialStageTails_DplcFrame0B:    dc.w    1
                dc.w    $B018
S3SpecialStageTails_DplcFrame01:    dc.w    2
                dc.w    $3024
                dc.w    $B028
S3SpecialStageTails_DplcFrame02:    dc.w    3
                dc.w    $3034
                dc.w    $B038
                dc.w    $2044
S3SpecialStageTails_DplcFrame03:    dc.w    3
                dc.w    $3047
                dc.w    $B04B
                dc.w    $1057
S3SpecialStageTails_DplcFrame04:    dc.w    3
                dc.w    $B059
                dc.w    $2065
                dc.w    $1068
S3SpecialStageTails_DplcFrame05:    dc.w    3
                dc.w    $306A
                dc.w    $B06E
                dc.w    $007A
S3SpecialStageTails_DplcFrame06:    dc.w    3
                dc.w    $3047
                dc.w    $B04B
                dc.w    $1057
S3SpecialStageTails_DplcFrame07:    dc.w    3
                dc.w    $B059
                dc.w    $2065
                dc.w    $1068
S3SpecialStageTails_DplcFrame08:    dc.w    3
                dc.w    $306A
                dc.w    $B06E
                dc.w    $007A

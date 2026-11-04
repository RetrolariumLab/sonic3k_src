; Data owner: objects/shared/sonic
; Provenance and source range: config/reconstruction/source_layout.json
Map_SStageSonic_:
                dc.w    SpecialStageSonic_EmptyMappingAndDplcFrame00-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame01-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame02-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame03-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame04-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame05-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame06-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame07-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame08-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame09-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame0A-Map_SStageSonic_
                dc.w    SpecialStageSonic_MappingFrame0B-Map_SStageSonic_
PLC_SStageSonic:
PLC_SStageSonic_:
                dc.w    SpecialStageSonic_EmptyMappingAndDplcFrame00-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame01-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame02-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame03-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame04-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame05-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame06-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame07-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame08-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame09-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame0A-PLC_SStageSonic_
                dc.w    SpecialStageSonic_DplcFrame0B-PLC_SStageSonic_
SpecialStageSonic_EmptyMappingAndDplcFrame00:   dc.w    0
SpecialStageSonic_MappingFrame01:               dc.w    2
                dc.b    $DD,  $F,   0,   0, $FF, $F0
                dc.b    $FD,   8,   0, $10, $FF, $F2
SpecialStageSonic_MappingFrame02:   dc.w    2
                dc.b    $D5,  $F,   0,   0, $FF, $F0
                dc.b    $F5,   9,   0, $10, $FF, $F1
SpecialStageSonic_MappingFrame03:   dc.w    3
                dc.b    $D5,  $F,   0,   0, $FF, $F0
                dc.b    $F5,   8,   0, $10, $FF, $F2
                dc.b    $FD,   5,   0, $13, $FF, $F2
SpecialStageSonic_MappingFrame04:   dc.w    3
                dc.b    $D5,  $F,   0,   0, $FF, $F0
                dc.b    $F5,   8,   0, $10, $FF, $F2
                dc.b    $FD,   5,   0, $13, $FF, $F2
SpecialStageSonic_MappingFrame05:   dc.w    3
                dc.b    $D5,  $F,   0,   0, $FF, $EE
                dc.b    $F5,   8,   0, $10, $FF, $F6
                dc.b    $FD,   1,   0, $13, $FF, $F6
SpecialStageSonic_MappingFrame06:   dc.w    3
                dc.b    $D5,  $F,   8,   0, $FF, $EF
                dc.b    $F5,   8,   8, $10, $FF, $F7
                dc.b    $FD,   5,   8, $13, $FF, $FF
SpecialStageSonic_MappingFrame07:   dc.w    3
                dc.b    $D5,  $F,   8,   0, $FF, $EF
                dc.b    $F5,   8,   8, $10, $FF, $F7
                dc.b    $FD,   5,   8, $13, $FF, $FF
SpecialStageSonic_MappingFrame08:   dc.w    3
                dc.b    $D5,  $F,   8,   0, $FF, $F0
                dc.b    $F5,   8,   8, $10, $FF, $F0
                dc.b    $FD,   1,   8, $13,   0,   0
SpecialStageSonic_MappingFrame09:   dc.w    1
                dc.b    $DA,  $F,   0,   0, $FF, $F0
SpecialStageSonic_MappingFrame0A:   dc.w    1
                dc.b    $DA,  $F,   0,   0, $FF, $F0
SpecialStageSonic_MappingFrame0B:   dc.w    1
                dc.b    $DA,  $F,   0,   0, $FF, $F0
SpecialStageSonic_DplcFrame01:  dc.w    2
                dc.w    $F000
                dc.w    $2010
SpecialStageSonic_DplcFrame02:  dc.w    2
                dc.w    $F013
                dc.w    $5023
SpecialStageSonic_DplcFrame03:  dc.w    3
                dc.w    $F029
                dc.w    $2039
                dc.w    $303C
SpecialStageSonic_DplcFrame04:  dc.w    3
                dc.w    $F040
                dc.w    $2050
                dc.w    $3053
SpecialStageSonic_DplcFrame05:  dc.w    3
                dc.w    $F057
                dc.w    $2067
                dc.w    $106A
SpecialStageSonic_DplcFrame06:  dc.w    3
                dc.w    $F029
                dc.w    $2039
                dc.w    $303C
SpecialStageSonic_DplcFrame07:  dc.w    3
                dc.w    $F040
                dc.w    $2050
                dc.w    $3053
SpecialStageSonic_DplcFrame08:  dc.w    3
                dc.w    $F057
                dc.w    $2067
                dc.w    $106A
SpecialStageSonic_DplcFrame09:  dc.w    1
                dc.w    $F06C
SpecialStageSonic_DplcFrame0A:  dc.w    1
                dc.w    $F07C
SpecialStageSonic_DplcFrame0B:  dc.w    1
                dc.w    $F08C

; Data owner: objects/shared/zones/mhz
; Provenance and source range: config/reconstruction/source_layout.json
Map_MHZEndBoss_:
                dc.w    MHZEndBoss_MapFrame00-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame01-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame02-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame03-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame04-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame05-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame06-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame07-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame08-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame09-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0A-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0B-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0C-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0D-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0E-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame0F-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame10-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame11-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame12-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame13-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame14-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame15-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame16-Map_MHZEndBoss_
                dc.w    MHZEndBoss_MapFrame17-Map_MHZEndBoss_
MHZEndBoss_MapFrame00:  dc.w    0
MHZEndBoss_MapFrame01:  dc.w    4
                dc.b    $B7,   5,   0, $72,   0, $10
                dc.b    $C3,  $F,   0,   0,   0,   0
                dc.b    $C3,   7,   0, $10,   0, $20
                dc.b    $C4,   7,   0, $51,   0, $30
MHZEndBoss_MapFrame02:
                dc.w    2                               ; Bug: This misses the last entry of the mappings. Change the 2 to a 3 to fix this bug
                dc.b    $DB,   9,   0, $D5, $FF, $FC
                dc.b    $F4,   7,   0, $43, $FF, $D8
                dc.b    $F4,   6,   0, $4B, $FF, $E8
MHZEndBoss_MapFrame03:  dc.w    8
                dc.b    $F4,   7,   0, $43, $FF, $F0
                dc.b    $F4,   6,   0, $4B,   0,   0
                dc.b    $E3,  $F,   0, $18,   0,   8
                dc.b    $E3,   7,   0, $28,   0, $28
                dc.b    $13,   0,   0, $30,   0,   0
                dc.b    3,  $E,   0, $31,   0,   8
                dc.b    3,   6,   0, $3D,   0, $28
                dc.b    $E4,   0,   0, $59,   0, $30
MHZEndBoss_MapFrame04:  dc.w    3
                dc.b    $EC,  $C,   0, $5A, $FF, $F4
                dc.b    $F4,   3,   0, $5E, $FF, $EC
                dc.b    $F4,  $F,   0, $62, $FF, $F4
MHZEndBoss_MapFrame05:  dc.w    1
                dc.b    $EE,  $F,   0, $76, $FF, $EF
MHZEndBoss_MapFrame06:  dc.w    1
                dc.b    $EE,  $F,   0, $86, $FF, $EF
MHZEndBoss_MapFrame07:  dc.w    2
                dc.b    $EC,   8,   0, $96, $FF, $F6
                dc.b    $F4,  $A,   0, $99, $FF, $EE
MHZEndBoss_MapFrame08:  dc.w    1
                dc.b    $EC,   5,   0, $A2, $FF, $EE
MHZEndBoss_MapFrame09:  dc.w    1
                dc.b    $E4,   5,   0, $A6, $FF, $E6
MHZEndBoss_MapFrame0A:  dc.w    1
                dc.b    $E4,   5,   0, $AA, $FF, $E6
MHZEndBoss_MapFrame0B:  dc.w    1
                dc.b    $E4,   5,   0, $AE, $FF, $E6
MHZEndBoss_MapFrame0C:  dc.w    1
                dc.b    $E4,   5,   0, $D1, $FF, $E6
MHZEndBoss_MapFrame0D:  dc.w    $A
                dc.b    $C6,   6,   0, $B2, $FF, $C6
                dc.b    $D6,   5,   0, $B8, $FF, $D6
                dc.b    $DB,   9,   0, $BC, $FF, $DB
                dc.b    $EB,   9,   0, $C2, $FF, $E3
                dc.b    $F0,   6,   0, $B2, $FF, $F0
                dc.b    0,   5,   0, $B8,   0,   0
                dc.b    5,   9,   0, $BC,   0,   5
                dc.b    $15,   9,   0, $C2,   0,  $D
                dc.b    $1A,   6,   0, $B2,   0, $1A
                dc.b    $2A,   5,   0, $B8,   0, $2A
MHZEndBoss_MapFrame0E:  dc.w    $A
                dc.b    $22,   6, $18, $B2,   0, $2A
                dc.b    $1A,   5, $18, $B8,   0, $1A
                dc.b    $15,   9, $18, $BC,   0,  $D
                dc.b    5,   9, $18, $C2,   0,   5
                dc.b    $F8,   6, $18, $B2,   0,   0
                dc.b    $F0,   5, $18, $B8, $FF, $F0
                dc.b    $EB,   9, $18, $BC, $FF, $E3
                dc.b    $DB,   9, $18, $C2, $FF, $DB
                dc.b    $CE,   6, $18, $B2, $FF, $D6
                dc.b    $C6,   5, $18, $B8, $FF, $C6
MHZEndBoss_MapFrame0F:  dc.w    $A
                dc.b    $C6,   9,   0, $BC, $FF, $C6
                dc.b    $D6,   9,   0, $C2, $FF, $CE
                dc.b    $DB,   6,   0, $B2, $FF, $DB
                dc.b    $EB,   5,   0, $B8, $FF, $EB
                dc.b    $F0,   9,   0, $BC, $FF, $F0
                dc.b    0,   9,   0, $C2, $FF, $F8
                dc.b    5,   6,   0, $B2,   0,   5
                dc.b    $15,   5,   0, $B8,   0, $15
                dc.b    $1A,   9,   0, $BC,   0, $1A
                dc.b    $2A,   9,   0, $C2,   0, $22
MHZEndBoss_MapFrame10:  dc.w    $A
                dc.b    $2A,   9, $18, $BC,   0, $22
                dc.b    $1A,   9, $18, $C2,   0, $1A
                dc.b    $D,   6, $18, $B2,   0, $15
                dc.b    5,   5, $18, $B8,   0,   5
                dc.b    0,   9, $18, $BC, $FF, $F8
                dc.b    $F0,   9, $18, $C2, $FF, $F0
                dc.b    $E3,   6, $18, $B2, $FF, $EB
                dc.b    $DB,   5, $18, $B8, $FF, $DB
                dc.b    $D6,   9, $18, $BC, $FF, $CE
                dc.b    $C6,   9, $18, $C2, $FF, $C6
MHZEndBoss_MapFrame11:  dc.w    1
                dc.b    $F4,  $A,   0, $C8, $FF, $F4
MHZEndBoss_MapFrame12:  dc.w    3
                dc.b    $B7,   5,   0, $72,   0, $10
                dc.b    $C3,  $F,   0,   0,   0,   0
                dc.b    $C3,   7,   0, $10,   0, $20
MHZEndBoss_MapFrame13:  dc.w    2
                dc.b    $E3,  $F,   0, $18,   0,   8
                dc.b    $E3,   7,   0, $28,   0, $28
MHZEndBoss_MapFrame14:  dc.w    3
                dc.b    $13,   0,   0, $30,   0,   0
                dc.b    3,  $E,   0, $31,   0,   8
                dc.b    3,   6,   0, $3D,   0, $28
MHZEndBoss_MapFrame15:  dc.w    2
                dc.b    $F4,   7,   0, $43, $FF, $D8
                dc.b    $F4,   6,   0, $4B, $FF, $E8
MHZEndBoss_MapFrame16:  dc.w    2
                dc.b    $F4,   7,   0, $43, $FF, $F0
                dc.b    $F4,   6,   0, $4B,   0,   0
MHZEndBoss_MapFrame17:  dc.w    2
                dc.b    $C4,   7,   0, $51,   0, $30
                dc.b    $E4,   0,   0, $59,   0, $30

; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene DPLC pointer records and raw animation or script streams
; Source provenance and ranges: config/reconstruction/source_layout.json
DPLCPtr_CutsceneKnux:
                dc.l    ArtUnc_CutsceneKnux
                dc.l    DPLC_CutsceneKnux
DPLCPtr_MHZKnuxPress:
                dc.l    ArtUnc_MHZKnuxPress
                dc.l    DPLC_MHZKnuxPress
DPLCPtr_KnuxIntroLay:
                dc.l    ArtUnc_KnuxIntroLay
                dc.l    DPLC_KnuxIntroLay
DPLCPtr_HPZKnucklesGrab:
                dc.l    ArtUnc_HPZKnucklesGrab
                dc.l    DPLC_HPZKnucklesGrab
DPLCPtr_SSZKnucklesTired:
                dc.l    ArtUnc_SSZKnucklesTired
                dc.l    DPLC_SSZKnucklesTired
DPLCPtr_SSZDeathEggCloud:
                dc.l    ArtUnc_SSZDeathEggCloud
                dc.l    DPLC_SSZDeathEggCloud
byte_6669A:
                dc.b    7,   1,   2,   3, $FC
byte_6669F:
                dc.b    4,  $A,  $B,  $C,  $D,  $E,  $F, $10, $11, $FC
byte_666A9:
                dc.b    1, $12, $13, $14, $15, $FC
byte_666AF:
                dc.b    1,   8,   4,   8,   5,   8,   6,   8,   7, $FC
byte_666B9:
                dc.b    7, $1C, $1C, $1D
                dc.b    $F8, byte_666BF-byte_666B9
byte_666BF:
                dc.b    7, $1E, $1F, $FC
byte_666C3:
                dc.b    $16,   7
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $19, $13
                dc.b    $1A,   7
                dc.b    $1B,   0
                dc.b    $F4
byte_666D2:
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22, $14
                dc.b    $23,   3
                dc.b    $24,  $F
                dc.b    $21,   5
                dc.b    $20,   5
                dc.b    $F4
byte_666E1:
                dc.b    0,   4
                dc.b    0,   9
                dc.b    1, $1D
                dc.b    0,   4
                dc.b    2,   4
                dc.b    3, $1D
                dc.b    2,   4
                dc.b    0,   4
                dc.b    1, $1D
                dc.b    0,   4
                dc.b    $F4
byte_666F6:
                dc.b    3,   7
                dc.b    3, $1F
                dc.b    0,   7
                dc.b    1, $1F
                dc.b    2,   7
                dc.b    1, $7F
                dc.b    2,   7
                dc.b    1, $1F
                dc.b    2,   7
                dc.b    1,  $F
                dc.b    2,   7
                dc.b    1,  $B
                dc.b    2,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    $F4
byte_66719:
                dc.b    0,   7
                dc.b    0,   7
                dc.b    $F8, byte_6671F-byte_66719
byte_6671F:
                dc.b    1,  $B
                dc.b    2,   5
                dc.b    3,  $B
                dc.b    2,  $B
                dc.b    1,  $B
                dc.b    $FC
byte_6672A:
                dc.b    4,   7
                dc.b    4,   7
                dc.b    5,   7
                dc.b    6, $1F
                dc.b    $F8, .jump-byte_6672A

                .jump:
                dc.b    5,  $F
                dc.b    6, $1F
                dc.b    $FC
byte_66739:
                dc.b    0,   5
                dc.b    0,   5
                dc.b    1,   7
                dc.b    2,   9
                dc.b    3,   9
                dc.b    4,  $B
                dc.b    5,  $C
                dc.b    6,  $D
                dc.b    7,  $E
                dc.b    8,  $F
                dc.b    9, $13
                dc.b    $A, $1D
                dc.b    $B, $27
                dc.b    $C, $63
                dc.b    $F8, .jump-byte_66739

                .jump:
                dc.b    $B, $3B
                dc.b    $A, $63
                dc.b    $B, $3B
                dc.b    $C, $63
                dc.b    $FC
byte_66760:
                dc.b    6,   0
                dc.b    6, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    1, $4D
                dc.b    2,   9
                dc.b    3,   9
                dc.b    $F4
byte_66771:
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DE,  $B
                dc.b    $FF, $FC
byte_667AD:
                dc.b    4, $D8, $D9, $DA, $DB, $FF, $FC
byte_667B4:
                dc.b    $DA,   5, $9B,   5, $9C,  $F, $FF, $F4
byte_667BC:
                dc.b    1,   0, $8D, $FF, $FC
byte_667C1:
                dc.b    1, $9A, $96, $9A, $97, $9A, $98, $9A, $99, $FF, $FC
byte_667CC:
                dc.b    3, $DA, $DA, $9B, $9C, $9B, $FF, $F4
byte_667D4:
                dc.b    $C0,   5
                dc.b    $CA,   5
                dc.b    $CB, $7F
                dc.b    $CB, $7F
                dc.b    $CB, $7F
                dc.b    $FF, $FC
byte_667E0:
                dc.b    5, $CC, $9B, $9C, $9B, $FF, $F4
byte_667E7:
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $7F
                dc.b    4, $1F
                dc.b    $FF, $F4
byte_667F5:
                dc.b    3, $DA, $DA, $9B, $9C, $FF
                dc.b    $F8, .jump-byte_667F5

                .jump:
                dc.b    0, $86, $87, $86, $88, $86, $89, $86, $8A, $86, $8B, $FF, $FC
byte_6680A:
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $3F
                dc.b    $FF, $F4
                dc.b    2,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $7F
                dc.b    6,   3
                dc.b    $FF, $F4
byte_66824:
                dc.b    4,   7,   8,   1,   2,   3,   4,   5,   6, $FF, $FC
byte_6682F:
                dc.b    3,   7,   8,   1,   2,   3,   4,   5,   6, $FF, $FC
byte_6683A:
                dc.b    1,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
byte_66843:
                dc.b    1, $12, $12, $13, $14, $15, $F4
byte_6684A:
                dc.b    3, $16, $16, $17, $F4
byte_6684F:
                dc.b    6, $3F
                dc.b    6, $3F
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6, $5F
                dc.b    $FF, $F4
byte_66875:
                dc.b    5,   1,   2,   3,   4, $FC
byte_6687B:
                dc.b    7,   9,  $A, $FF, $FC
byte_66880:
                dc.b    5,  $B,  $C, $FF, $FC
byte_66885:
                dc.b    $56,   7
                dc.b    $56, $1F
                dc.b    $DE,   0
                dc.b    $DE,  $F
                dc.b    $56, $3F
                dc.b    $FF, $F4
byte_66891:
                dc.b    $D8,   4
                dc.b    $D9,   4
                dc.b    $DA,   4
                dc.b    $DB,   4
                dc.b    $DC,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DC,   4
                dc.b    $DD,   4
                dc.b    $DE,   0
                dc.b    $FF, $F4
byte_668A7:
                dc.b    $DE,   7
                dc.b    $DE,   7
                dc.b    $56,   0
                dc.b    $FF, $F4
byte_668AF:
                dc.b    $E, $59
                dc.b    $E, $77
                dc.b    $F, $07
                dc.b    $10, $1D
                dc.b    $11, $07
                dc.b    $12, $07
                dc.b    $11, $07
                dc.b    $12, $07
                dc.b    $F, $07
                dc.b    $FF, $F4
byte_668C3:
                dc.b    $13,   0,   1, $FC
byte_668C7:
                dc.b    4, $6F
                dc.b    4, $6F
                dc.b    2,   7
                dc.b    3, $7F
                dc.b    $FC
byte_668D0:
                dc.b    3,   3
                dc.b    3,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    4, $5F
                dc.b    6, $1F
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    7,   2
                dc.b    6,  $F
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $F4
byte_66905:
                dc.b    3,   1,   2,   3,   4, $FC
byte_6690B:
                dc.b    5,   5,   5,   6,   7,   8, $F4
                even

; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_AIZEndBoss:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,1,1)  ; VRAM
                dc.w    $280                            ; Priority
                dc.b    $28, $20,   0, $10              ; Width, Height, Frame, Collision
word_69CE0:
                dc.w    $200
                dc.b    $24, $14,   1,   0
word_69CE6:
                dc.w    $180
                dc.b    $C,  $C,   4,   0
word_69CEC:
                dc.w    $100
                dc.b    8,   4,  $B, $97
word_69CF2:
                dc.w    $100
                dc.b    $14, $18,  $F, $9A
word_69CF8:
                dc.w    $100
                dc.b    8,   8, $18,   0
word_69CFE:
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $30, $30, $24,   0
ObjDat_AIZEndBoss2:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $18, $10, $21,   0
word_69D12:
                dc.w    $180
                dc.b    $10, $10,   0,   0
ChildObjDat_69D18:
                dc.w    2-1
                dc.l    loc_69622
                dc.b    $14,  -4
                dc.l    loc_69622
                dc.b    -$14,  -4
ChildObjDat_69D26:
                dc.w    1-1
                dc.l    loc_69738
                dc.b    -$1C,   0
ChildObjDat_69D2E:
                dc.w    1-1
                dc.l    loc_699C0
                dc.b    0,   0
ChildObjDat_69D36:
                dc.w    1-1
                dc.l    loc_69996
                dc.b    0,-$30
ChildObjDat_69D3E:
                dc.w    1-1
                dc.l    loc_69844
                dc.b    3,   5
ChildObjDat_69D46:
                dc.w    1-1
                dc.l    loc_69844
                dc.b    0,   7
ChildObjDat_69D4E:
                dc.w    1-1
                dc.l    loc_69844
                dc.b    -3,   5
ChildObjDat_69D56:
                dc.w    1-1
                dc.l    loc_698D2
                dc.b    0,   0
ChildObjDat_69D5E:
                dc.w    1-1
                dc.l    loc_6995A
                dc.b    0,   0
ChildObjDat_69D66:
                dc.w    6-1
                dc.l    loc_69A3A
                dc.b    -$10,-$10
                dc.l    loc_69A3A
                dc.b    $10,-$10
                dc.l    loc_69A3A
                dc.b    -$10,   8
                dc.l    loc_69A3A
                dc.b    $10,   8
                dc.l    loc_69A3A
                dc.b    -$C, $18
                dc.l    loc_69A3A
                dc.b    $C, $18
ChildObjDat_69D8C:
                dc.w    1-1
                dc.l    Obj_EggCapsule
ChildObjDat_69D92:                                      ; used in S3, unused in S&K
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
byte_69D98:
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $2B,   0
                dc.b    $2B,   0
                dc.b    0,   0
                dc.b    $F4
byte_69DB3:
                dc.b    $1B,   0
                dc.b    $1B,   4
                dc.b    $1C,   5
                dc.b    $1D,   6
                dc.b    0,   0
                dc.b    $F4
byte_69DBE:
                dc.b    $1E,   0
                dc.b    $1E,   4
                dc.b    $1F,   5
                dc.b    $20,   6
                dc.b    1,   0
                dc.b    $F4
byte_69DC9:
                dc.b    0
                dc.b    7, $2B
                dc.b    7, $2B
                dc.b    8, $2B
                dc.b    8, $2B
                dc.b    9, $2B
                dc.b    9, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $A, $2B
                dc.b    $F4
byte_69DF3:
                dc.b    0
                dc.b    $B, $2B
                dc.b    $B, $2B
                dc.b    $C, $2B
                dc.b    $C, $2B
                dc.b    $D, $2B
                dc.b    $D, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $E, $2B
                dc.b    $F4
byte_69E1D:
                dc.b    1, $26, $27, $28, $29, $FC
byte_69E23:
                dc.b    1, $16, $17, $2F, $30, $FC
byte_69E29:
                dc.b    1, $10, $11, $2D, $2E, $FC
byte_69E2F:
                dc.b    $12,   0
                dc.b    $12,   9
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $F4
byte_69E38:
                dc.b    $18,   0
                dc.b    $18,   9
                dc.b    $19,   2
                dc.b    $1A,   2
                dc.b    $F4
byte_69E41:
                dc.b    $21,   0
                dc.b    $21,   4
                dc.b    $22,   5
                dc.b    $23,   6
                dc.b    $F4
byte_69E4A:
                dc.b    $2B|$00,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $F4
byte_69E65:
                dc.b    $2B|$00,   0
                dc.b    $24|$00,   0
                dc.b    $24|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $2C|$00,   0
                dc.b    $2C|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $31|$00,   0
                dc.b    $31|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $31|$00,   0
                dc.b    $31|$40,   0
                dc.b    $2B|$40,   0
                dc.b    $F4
                even
Pal_AIZEndBoss:
                binclude "data/Levels/AIZ/Palettes/End Boss.bin"
                even

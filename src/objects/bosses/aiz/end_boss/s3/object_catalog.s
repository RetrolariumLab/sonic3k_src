; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_AIZEndBoss:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,1,1)  ; VRAM
                dc.w    $280                            ; Priority
                dc.b    $28, $20,   0, $10              ; Width, Height, Frame, Collision
word_47B36:
                dc.w    $200
                dc.b    $24, $14,   1,   0
word_47B3C:
                dc.w    $180
                dc.b    $C,  $C,   4,   0
word_47B42:
                dc.w    $100
                dc.b    8,   4,  $B, $97
word_47B48:
                dc.w    $100
                dc.b    $14, $18,  $F, $9A
word_47B4E:
                dc.w    $100
                dc.b    8,   8, $18,   0
word_47B54:
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $30, $30, $24,   0
ObjDat_AIZEndBoss2:
                dc.l    Map_AIZEndBoss
                dc.w    make_art_tile(ArtTile_AIZEndBoss,0,1)
                dc.w    $100
                dc.b    $18, $10, $21,   0
word_47B68:
                dc.w    $180
                dc.b    $10, $10,   0,   0
ChildObjDat_47B6E:
                dc.w    2-1
                dc.l    loc_47486
                dc.b    $14,  -4
                dc.l    loc_47486
                dc.b    -$14,  -4
ChildObjDat_47B7C:
                dc.w    1-1
                dc.l    loc_4759C
                dc.b    -$1C,   0
ChildObjDat_47B84:
                dc.w    1-1
                dc.l    loc_47806
                dc.b    0,   0
ChildObjDat_47B8C:
                dc.w    1-1
                dc.l    loc_477DC
                dc.b    0,-$30
ChildObjDat_47B94:
                dc.w    1-1
                dc.l    loc_4768A
                dc.b    3,   5
ChildObjDat_47B9C:
                dc.w    1-1
                dc.l    loc_4768A
                dc.b    0,   7
ChildObjDat_47BA4:
                dc.w    1-1
                dc.l    loc_4768A
                dc.b    -3,   5
ChildObjDat_47BAC:
                dc.w    1-1
                dc.l    loc_47718
                dc.b    0,   0
ChildObjDat_47BB4:
                dc.w    1-1
                dc.l    loc_477A0
                dc.b    0,   0
ChildObjDat_47BBC:
                dc.w    6-1
                dc.l    loc_47880
                dc.b    -$10,-$10
                dc.l    loc_47880
                dc.b    $10,-$10
                dc.l    loc_47880
                dc.b    -$10,   8
                dc.l    loc_47880
                dc.b    $10,   8
                dc.l    loc_47880
                dc.b    -$C, $18
                dc.l    loc_47880
                dc.b    $C, $18
ChildObjDat_47BE2:
                dc.w    1-1
                dc.l    Obj_EggCapsule
ChildObjDat_47BE8:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
byte_47BEE:
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
byte_47C09:
                dc.b    $1B,   0
                dc.b    $1B,   4
                dc.b    $1C,   5
                dc.b    $1D,   6
                dc.b    0,   0
                dc.b    $F4
byte_47C14:
                dc.b    $1E,   0
                dc.b    $1E,   4
                dc.b    $1F,   5
                dc.b    $20,   6
                dc.b    1,   0
                dc.b    $F4
byte_47C1F:
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
byte_47C49:
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
byte_47C73:
                dc.b    1, $26, $27, $28, $29, $FC
byte_47C79:
                dc.b    1, $16, $17, $2F, $30, $FC
byte_47C7F:
                dc.b    1, $10, $11, $2D, $2E, $FC
byte_47C85:
                dc.b    $12,   0
                dc.b    $12,   9
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $F4
byte_47C8E:
                dc.b    $18,   0
                dc.b    $18,   9
                dc.b    $19,   2
                dc.b    $1A,   2
                dc.b    $F4
byte_47C97:
                dc.b    $21,   0
                dc.b    $21,   4
                dc.b    $22,   5
                dc.b    $23,   6
                dc.b    $F4
byte_47CA0:
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
byte_47CBB:
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

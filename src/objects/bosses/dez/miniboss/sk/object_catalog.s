; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss attributes, child construction, animation, palette and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_DEZMiniboss:
                dc.l    Map_DEZMiniboss
                dc.w    make_art_tile(ArtTile_DEZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
word_7EF52:
                dc.w    $200
                dc.b    $C,  $C,   2, $17
word_7EF58:
                dc.w    $180
                dc.b    $10, $10, $15, $86
word_7EF5E:
                dc.w    $100
                dc.b    4,   4, $15, $98
word_7EF64:
                dc.w    $80
                dc.b    8,   8, $12,   0
word_7EF6A:
                dc.w    $180
                dc.b    $10, $18, $11,   0
word_7EF70:
                dc.w    $300
                dc.b    $18, $10,   1,   0
word_7EF76:
                dc.w    $280
                dc.b    $18,   4,  $B, $9E
word_7EF7C:
                dc.w    $380
                dc.b    $10, $80,   6,   0
word_7EF82:
                dc.w    $300
                dc.b    8,   4,   8,   0
word_7EF88:
                dc.w    $100
                dc.b    $10, $14, $23,   0
ChildObjDat_7EF8E:
                dc.w    1-1
                dc.l    loc_7E768
                dc.b    0,  -4
ChildObjDat_7EF96:
                dc.w    8-1
                dc.l    loc_7E80E
ChildObjDat_7EF9C:
                dc.w    8-1
                dc.l    loc_7E916
ChildObjDat_7EFA2:
                dc.w    1-1
                dc.l    loc_7EAB6
ChildObjDat_7EFA8:
                dc.w    2-1
                dc.l    loc_7EACC
                dc.b    -$28,   0
                dc.l    loc_7EACC
                dc.b    $28,   0
ChildObjDat_7EFB6:
                dc.w    1
                dc.l    loc_7E4CE
ChildObjDat_7EFBC:
                dc.w    1-1
                dc.l    loc_7E74A
                dc.b    0,   4
ChildObj_7EFC4:
                dc.w    1-1
                dc.l    loc_7E97E
                dc.b    0, $1E
ChildObjDat_7EFCC:
                dc.w    2-1
                dc.l    loc_7EA6C
ChildObjDat_7EFD2:
                dc.w    4-1
                dc.l    loc_7EB0E
                dc.b    -$10,   0
                dc.l    loc_7EB0E
                dc.b    $10,   0
                dc.l    loc_7EB0E
                dc.b    -$C, $18
                dc.l    loc_7EB0E
                dc.b    $C, $18
byte_7EFEC:
                dc.b    1,  $B,  $C,  $D,  $E,  $F, $10, $FC
byte_7EFF4:
                dc.b    0,   8,   7,   9,   7,  $A,   7, $FC
                even
Pal_DEZMiniboss1:
                binclude "data/Levels/DEZ/Palettes/Miniboss 1.bin"
                even
Pal_DEZMiniboss2:
                binclude "data/Levels/DEZ/Palettes/Miniboss 2.bin"
                even
word_7F03C:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$16, 3, 11-1
                .data:  palscriptdata 8, $66A, $448, $226
                palscriptdata 8, $66C, $44A, $228
                palscriptdata 8, $66A, $448, $226
                palscriptdata 8, $666, $444, $222
                palscriptrun

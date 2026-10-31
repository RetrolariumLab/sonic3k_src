; Owner: objects/bosses/fbz/miniboss/sk
; Responsibility: Flying Battery miniboss object attributes, child records and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_FBZMiniboss:
                dc.l    Map_FBZMiniboss
                dc.w    make_art_tile(ArtTile_FBZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_6FA40:
                dc.w    $100
                dc.b    8,   8,   1,   0
word_6FA46:
                dc.w    $300
                dc.b    $18, $10,   5,   0
word_6FA4C:
                dc.w    $280
                dc.b    8,   8,   6,   0
word_6FA52:
                dc.w    $200
                dc.b    $18, $18,   7,   0
word_6FA58:
                dc.w    $100
                dc.b    $10,   8,   8,   0
word_6FA5E:
                dc.w    $180
                dc.b    $10,   8, $11,   0
word_6FA64:                                             ; used in S3, unused in S&K
                dc.w    $280
                dc.b    $10,   8,   4,   0
ObjDat3_6FA6A:                                          ; unused
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $100
                dc.b    8,   8,   0,   0
ChildObjDat_6FA76:
                dc.w    7-1
                dc.l    loc_6F10E
                dc.b    -$10,  -8
                dc.l    loc_6F10E
                dc.b    $10,  -8
                dc.l    loc_6F10E
                dc.b    0,  -8
                dc.l    loc_6EFDA
                dc.b    0,-$24
                dc.l    loc_6F060
                dc.b    0,  -8
                dc.l    loc_6F178
                dc.b    0,   0
                dc.l    loc_6F178
                dc.b    0,   0
word_6FAA2:
                dc.w    5-1
                dc.l    loc_6F3DE
ChildObjDat_6FAA8:
                dc.w    1-1
                dc.l    loc_6F0CE
                dc.b    0,  -8
ChildObjDat_6FAB0:
                dc.w    1-1
                dc.l    loc_6F74C
                dc.b    3,   9,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
                even
Pal_FBZMiniboss:
                binclude "data/Levels/FBZ/Palettes/FBZ Miniboss.bin"
                even
word_6FAE0:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$1E, 1, 7-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 4, $644
                palscriptrun

Map_FBZMiniboss:
                include "src/objects/shared/zones/fbz/mappings/miniboss.s"
; ---------------------------------------------------------------------------
word_6FCFC:
                dc.w    $560,  $660, $2900, $2C00
                dc.w    $5E0,  $5E0, $2900, $2900

; Owner: objects/bosses/soz/miniboss/sk
; Responsibility: Sandopolis miniboss attributes, construction records, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_SOZMiniboss:
                dc.l    Map_SOZMiniboss
                dc.w    make_art_tile(ArtTile_SOZMiniboss,1,1)
                dc.w    $300
                dc.b    $24, $34,   0,   0
word_773B8:
                dc.w    $280
                dc.b    $14, $14,   0,   0
word_773BE:
                dc.w    $280
                dc.b    $34, $34, $18,   0
word_773C4:
                dc.w    $280
                dc.b    $C, $10, $1A, $A8
ObjDat3_773CA:
                dc.l    Map_SOZMinibossDust
                dc.w    make_art_tile(ArtTile_SOZSand,2,1)
                dc.w    $180
                dc.b    8,   8,   0,   0
ChildObjDat_773D6:
                dc.w    8-1
                dc.l    loc_76F0E
                dc.b    0,   0
ChildObjDat_773DE:
                dc.w    1-1
                dc.l    loc_77022
                dc.b    0, $40
ChildObjDat_773E6:
                dc.w    2-1
                dc.l    loc_76F46
                dc.b    -$C,-$1C
                dc.l    loc_76F46
                dc.b    0,   0
ChildObjDat_773F4:
                dc.w    2-1
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
ChildObjDat_77402:
                dc.w    6-1
                dc.l    loc_7706C
                dc.b    -4, $38
ChildObjDat_7740A:
                dc.w    6-1
                dc.l    loc_7706C
                dc.b    0,   4
Pal_SOZMinibossFade:
                binclude "data/Levels/SOZ/Palettes/Miniboss Fade.bin"
                even
Pal_SOZMinibossMain:
                binclude "data/Levels/SOZ/Palettes/Miniboss Main.bin"
                even
byte_77452:
                dc.b    0,   9
                dc.b    0, $1F
                dc.b    9,   9
                dc.b    $40|9,   9
                dc.b    0,   9
                dc.b    $F4
byte_7745D:
                dc.b    0,   9
                dc.b    0,   9
                dc.b    5,   4
                dc.b    6,   4
                dc.b    7,   4
                dc.b    8,   1
                dc.b    $F4
byte_7746A:
                dc.b    8,   4
                dc.b    7,   4
                dc.b    6,   4
                dc.b    5,   4
                dc.b    4,   4
                dc.b    3,   9
                dc.b    2,   9
                dc.b    1,   9
                dc.b    0, $1F
                dc.b    $F4
byte_7747D:
                dc.b    $F,   0, $19,   1, $F4
byte_77482:
                dc.b    0,   4
                dc.b    1,   4
                dc.b    2,   4
                dc.b    3,   4
                dc.b    4,   4
                dc.b    5,   9
                dc.b    6,   9
                dc.b    7,   5
                dc.b    8,   0
                dc.b    $F4
byte_77495:
                dc.b    3, $12, $12, $13, $14, $F4
byte_7749B:
                dc.b    0,   3
                dc.b    0,   3
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   7
                dc.b    $F4
                even
Map_SOZMiniboss:
                include "src/objects/shared/zones/soz/mappings/miniboss.s"
Map_SOZMinibossDust:
                include "src/objects/shared/zones/soz/miniboss/mappings/landing_dust.s"

; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Mecha Sonic tracking slots, object attributes, children, animation, pattern records, mappings and palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjSlot_MechaSonic:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_MechaSonic,1,1)
                dc.w    $28,     0
                dc.l    Map_MechaSonic
                dc.w    $280
                dc.b    $20, $20,   0, $23
word_7D3FC:
                dc.w    $80
                dc.b    $10, $10,   0,   0
ObjDat3_7D402:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,0,1)
                dc.w    $200
                dc.b    $C,   4,   0,   0
ObjDat_MechaSonic_Sparks:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    $14, $10,   4,   0
ObjDat3_7D41A:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    4,   4, $11,   0
ObjDat3_7D426:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $280
                dc.b    $18, $18,   8,   0
word_7D432:
                dc.w    $280
                dc.b    4,   4,   8,   0
ObjDat3_7D438:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $200
                dc.b    $18, $18,  $A, $86
ObjDat3_7D444:
                dc.l    Map_MechaSonicExtra
                dc.w    make_art_tile(ArtTile_MechaSonicExtra,1,1)
                dc.w    $280
                dc.b    8,   8, $15, $87
ObjDat3_7D450:
                dc.l    Map_SSZMasterEmerald
                dc.w    make_art_tile(ArtTile_Ending_MasterEmerald,0,1)
                dc.w    $300
                dc.b    $20, $18,   0,   0
ObjDat3_7D45C:
                dc.l    Map_RoboshipPieces
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    0
                dc.b    $1C, $20,   0,   0
ObjDat3_7D468:
                dc.l    Map_MechaSonicPieces
                dc.w    make_art_tile(ArtTile_MechaSonic,1,1)
                dc.w    0
                dc.b    4,   8,   0,   0
ChildObjDat_7D474:
                dc.w    1-1
                dc.l    loc_7C9BA
ChildObjDat_7D47A:
                dc.w    1
                dc.l    loc_7C902
ChildObjDat_7D480:
                dc.w    1-1
                dc.l    loc_7C902
ChildObjDat_7D486:
                dc.w    2-1
                dc.l    loc_7C8FE
ChildObjDat_7D48C:
                dc.w    1-1
                dc.l    Obj_MechaSonic_Sparks
ChildObjDat_7D492:
                dc.w    1-1
                dc.l    loc_7C886
                dc.b    -4,  $C
ChildObjDat_7D49A:
                dc.w    1-1
                dc.l    loc_7C78E
                dc.b    $14,  -4
ChildObjDat_7D4A2:
                dc.w    1-1
                dc.l    loc_7C7D4
ChildObjDat_7D4A8:
                dc.w    8-1
                dc.l    loc_7C726
ChildObjDat_7D4AE:
                dc.w    1-1
                dc.l    loc_7C744
                dc.b    -7,  -8
                dc.w    1-1
                dc.l    loc_7C818
ChildObjDat_7D4BC:
                dc.w    1-1
                dc.l    loc_7CCFE
                dc.b    0, $23
ChildObjDat_7D4C4:
                dc.w    4-1
                dc.l    loc_7CE6C
ChildObjDat_7D4CA:
                dc.w    $10-1
                dc.l    loc_7CE90
ChildObjDat_7D4D0:
                dc.w    3-1
                dc.l    loc_7CF14
DPLCPtr_MechaSonic:
                dc.l    ArtUnc_MechaSonic
                dc.l    DPLC_MechaSonic
byte_7D4DE:
                dc.b    3,   0
                dc.b    4,   1
                dc.b    5,   2
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   5
                dc.b    $F8, .jump-byte_7D4DE

                .jump:
                dc.b    8, $7F
                dc.b    $FC
byte_7D4EF:
                dc.b    3,   0
                dc.b    4,   1
                dc.b    5,   2
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   4
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    $C,   4
                dc.b    $F8, .jump-byte_7D4EF

                .jump:
                dc.b    $C, $7F
                dc.b    $FC
byte_7D508:
                dc.b    $13,   5
                dc.b    $13,   5
                dc.b    8, $7F
                dc.b    $F8, byte_7D4DE.jump-byte_7D508
byte_7D510:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    $F4
byte_7D519:
                dc.b    3,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, byte_7D523-byte_7D519
byte_7D523:
                dc.b    3,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    $FC
byte_7D52A:
                dc.b    8,   0
                dc.b    7,   3
                dc.b    6,   3
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, byte_7D523-byte_7D52A
byte_7D538:
                dc.b    6,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    8, $1F
                dc.b    $F4
byte_7D541:
                dc.b    0,   0
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   0
                dc.b    $F4
byte_7D54A:
                dc.b    1,   0
                dc.b    1,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F8, byte_7D523-byte_7D54A
byte_7D556:
                dc.b    $12,   0
                dc.b    $12,   5
                dc.b    $D,   3
                dc.b    8,   5
                dc.b    1,   1
                dc.b    $F4
byte_7D561:
                dc.b    1,   3
                dc.b    1,   7
                dc.b    2,   7
                dc.b    1,   3
                dc.b    8,   0
                dc.b    $F4
byte_7D56C:
                dc.b    8,   5
                dc.b    8,   5
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $C,   3
                dc.b    $40|8, $7F
                dc.b    $F8, byte_7D4DE.jump-byte_7D56C
byte_7D57C:
                dc.b    8,   5
                dc.b    $13,   5
                dc.b    $14, $7F
                dc.b    $F8, .jump-byte_7D57C

                .jump:
                dc.b    $15, $7F
                dc.b    $FC
byte_7D587:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    $10,  $F
                dc.b    1,   5
                dc.b    $11, $17
                dc.b    0,   5
                dc.b    8,   3
                dc.b    $F4
byte_7D596:
                dc.b    1,   5
                dc.b    2, $1F
                dc.b    $F4
byte_7D59B:
                dc.b    2,   0
                dc.b    1,   5
                dc.b    0, $3F
                dc.b    $F4
byte_7D5A2:
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    0, $3F
                dc.b    $F4
byte_7D5AB:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    $13,   5
                dc.b    $15,   3
                dc.b    $F4
byte_7D5B6:
                dc.b    1,   5
                dc.b    1,   5
                dc.b    2,   9
                dc.b    $13,   5
                dc.b    $15, $7F
                dc.b    $F4
byte_7D5C1:
                dc.b    3,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   1
                dc.b    6,   3
                dc.b    7,   4
                dc.b    8,   3
                dc.b    1,   5
                dc.b    2,   9
                dc.b    1,   5
                dc.b    0,   3
                dc.b    $F4
byte_7D5D8:
                dc.b    $C,   3
                dc.b    $C,   3
                dc.b    $A,   3
                dc.b    9,   3
                dc.b    8,   3
                dc.b    $F8, byte_7D61A-byte_7D5D8
byte_7D5E4:
                dc.b    $E,   5
                dc.b    $E,   5
                dc.b    $F,   3
                dc.b    $F8, .jump-byte_7D5E4

                .jump:
                dc.b    $F, $7F
                dc.b    $FC
byte_7D5EF:
                dc.b    $F,   5
                dc.b    $E,   5
                dc.b    2,   1
                dc.b    $F4
byte_7D5F6:
                dc.b    2,   5
                dc.b    2,  $F
                dc.b    1,   5
                dc.b    8,   0
                dc.b    $F4
byte_7D5FF:
                dc.b    1,   3
                dc.b    1,   3
                dc.b    2,  $F
                dc.b    1,   3
                dc.b    8,   0
                dc.b    $F4
byte_7D60A:
                dc.b    8,   7
                dc.b    8,   7
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $C,   5
                dc.b    $40|8, $7F
                dc.b    $F8, byte_7D61A-byte_7D60A
byte_7D61A:
                dc.b    8, $7F
                dc.b    $FC
                dc.b    2,   5
                dc.b    2,   5
                dc.b    1,   5
                dc.b    8,   0
                dc.b    $F4
byte_7D626:
                dc.b    8,   1
                dc.b    8,   1
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    $B,   1
                dc.b    $C,   0
                dc.b    $40|8, $7F
                dc.b    $F8, byte_7D645.jump-byte_7D626
byte_7D636:
                dc.b    8,   3
                dc.b    8,   3
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $C,   3
                dc.b    $40|8,   3
                dc.b    $F4
byte_7D645:
                dc.b    8,   3
                dc.b    8,  $F
                dc.b    1

                .jump:
                dc.b    5
                dc.b    $10,  $F
                dc.b    1,   5
                dc.b    $11,   0
                dc.b    $F4
byte_7D652:
                dc.b    8,   1
                dc.b    8,   1
                dc.b    $D,   5
                dc.b    $12, $7F
                dc.b    $F8, .jump-byte_7D652

                .jump:
                dc.b    $12, $7F
                dc.b    $FC
byte_7D65F:
                dc.b    1,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    0,   0
                dc.b    $FC
byte_7D668:
                dc.b    $11,   3
                dc.b    $11,   3
                dc.b    0,   3
                dc.b    $11,   3
                dc.b    0,   3
                dc.b    $11,   3
                dc.b    $12, $1B
                dc.b    $13,   5
                dc.b    $14, $3F
                dc.b    $F4
byte_7D67B:
                dc.b    0,   0,   8,   9,   0, $17, $18, $FC
byte_7D683:
                dc.b    $E,   1
                dc.b    $E,   1
                dc.b    $F,   2
                dc.b    $10,   3
                dc.b    $F4
byte_7D68C:
                dc.b    0
                dc.b    $A,  $A,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $C,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $D,   0
                dc.b    $19,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $F4
byte_7D6A3:
                dc.b    0
                dc.b    0,  $D, $16
                dc.b    0,  $D,  $C, $16
                dc.b    0,  $D, $16
                dc.b    0,  $D, $19, $16
                dc.b    $FC
byte_7D6B3:
                dc.b    0
                dc.b    $B,  $B,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $B,  $D,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $B,   0
                dc.b    $A,  $B,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $A,   0
                dc.b    $F4
                even
Map_RoboshipPieces:
                include "src/objects/shared/robotnik/map_robotnik_ship_pieces.s"
Map_SSZMasterEmerald:
                include "src/objects/shared/ssz_master_emerald/map_master_emerald.s"
Map_MechaSonicPieces:
                include "src/objects/shared/mecha_sonic/map_mecha_sonic_pieces.s"

word_7D842:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 0
                .data:  palscriptfile 50,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 5, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 50,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 20,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptrept

Pal_SSZGHZMisc: equ     word_7D842.data                 ; yeah Sonic 3 is a fun game

word_7D9EA:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 0
                .data:  palscriptfile 3, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 1, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptrept

word_7DA60:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 30,"data/General/Sprites/Mecha Sonic/Palettes/Flash 3.bin"
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$00, 16, 0
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 1.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 2.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 3.bin"
                palscriptfile 6, "data/General/Sprites/Mecha Sonic/Palettes/Super 2.bin"
                palscriptrept

word_7DB66:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 6,  "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 6,  "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 128,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$00, 16, 0
                palscriptfile 128,"data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptrept

word_7DC06:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 8, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptloop word_7DA60.headr2

word_7DC7E:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$00, 16, 2-1
                .data:  palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 2, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Flash 2.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Flash 1.bin"
                palscriptfile 4, "data/General/Sprites/Mecha Sonic/Palettes/Main.bin"
                palscriptrun

off_7DD5A:
                dc.l    off_7DD7A
                dc.w    2-1
                dc.b    0,  $F
                dc.b    1,   9
                dc.b    2,   9
                dc.b    3,   7
                dc.b    4,   7
                dc.b    5,   5
                dc.b    6,   5
                dc.b    5,   5
                dc.b    4,   7
                dc.b    3,   7
                dc.b    2,   9
                dc.b    1,   9
                dc.b    $FF, $FC
off_7DD7A:
                dc.w    word_7DD88-off_7DD7A
                dc.w    word_7DD8C-off_7DD7A
                dc.w    word_7DD90-off_7DD7A
                dc.w    word_7DD94-off_7DD7A
                dc.w    word_7DD98-off_7DD7A
                dc.w    word_7DD9C-off_7DD7A
                dc.w    word_7DDA0-off_7DD7A
word_7DD88:
                dc.w    $480,  $6A0
word_7DD8C:
                dc.w    $680,  $8A0
word_7DD90:
                dc.w    $680,  $8C0
word_7DD94:
                dc.w    $6A0,  $AC0
word_7DD98:
                dc.w    $8A0,  $AE0
word_7DD9C:
                dc.w    $8C0,  $CE0
word_7DDA0:
                dc.w    $AC0,  $EE0
; ---------------------------------------------------------------------------
word_7DDA4:
                dc.w    $18C,  $38C, $3400, $3780
                dc.w    $28C,  $28C, $3680, $36C0

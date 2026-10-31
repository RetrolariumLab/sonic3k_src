; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace Master or Super Emerald object attributes, animation, palette and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_HPZMasterEmerald:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,3,0)
                dc.w    $200
                dc.b    $20, $18,  $B,   0
word_90FB8:
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,0)
                dc.w    $180
                dc.b    $10, $10,  $C,   0
ObjDat_HPZSuperEmerald:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile($000,0,0)
                dc.w    $80
                dc.b    $18, $10, $1E,   0
ObjDat3_90FCC:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    0
                dc.b    $10, $80,   8,   0
ObjDat3_90FD8:
                dc.l    Map_HPZChaosEmeralds
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    $180
                dc.b    4,   4,   0,   0
ChildObjDat_90FE4:
                dc.w    1-1
                dc.l    loc_90734
ChildObjDat_90FEA:
                dc.w    1-1
                dc.l    loc_90D78
ChildObjDat_90FF0:
                dc.w    7-1
                dc.l    loc_90DFC
byte_90FF6:
                dc.b    0, $1D, $1F, $1D, $20, $1D, $21, $1D, $22, $1D, $23, $1D, $24, $1D, $F4
                even
Map_HPZEmeraldMisc:
                include "src/objects/shared/zones/hpz/map_emerald_misc_art.s"
Map_HPZChaosEmeralds:
                include "src/objects/shared/zones/hpz/map_chaos_emeralds.s"
off_914CE:
                dc.l    off_914EE
                dc.w    2-1
; this data here seems completely broken
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
off_914EE:
                dc.w    word_914FC-off_914EE
                dc.w    word_91500-off_914EE
                dc.w    word_91504-off_914EE
                dc.w    word_91508-off_914EE
                dc.w    word_9150C-off_914EE
                dc.w    word_91510-off_914EE
                dc.w    word_91514-off_914EE
word_914FC:
                dc.w    $6A0,   $660
word_91500:
                dc.w    $8C0,   $680
word_91504:
                dc.w    $AC0,   $680
word_91508:
                dc.w    $CE0,   $880
word_9150C:
                dc.w    $CE6,   $6A2
word_91510:
                dc.w    $CE8,   $AC0
word_91514:
                dc.w    $EEC,   $CE8

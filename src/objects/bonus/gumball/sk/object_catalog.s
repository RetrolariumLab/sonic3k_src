; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball object attributes, construction records, raw animations and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat3_6138C:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,0)
                dc.w    $200
                dc.b    $10, $20,   0,   0
ObjDat3_61398:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $40, $10, $13,   0
ObjDat3_613A4:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    4, $10, $12,   0
ObjDat_GumballMachine:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $18, $18,   5,   0
ObjDat3_613BC:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $14, $14,   2,   0
ObjDat3_613C8:
                dc.l    Map_Spring
                dc.w    make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dc.w    $100
                dc.b    $10, $10,   0,   0
ObjDat3_613D4:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    8,   8, $15,   0
ObjDat3_613E0:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,1)
                dc.w    $100
                dc.b    8,   8,   8,   0
ObjDat3_613EC:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    4, $10, $17,   0
ChildObjDat_613F8:
                dc.w    7-1
                dc.l    loc_60D58
                dc.b    0,   0
                dc.l    loc_60E4C
                dc.b    0, $24
                dc.l    loc_61044
                dc.b    0,   0
                dc.l    loc_60FFE
                dc.b    -$38,-$2C
                dc.l    loc_60FFE
                dc.b    0,-$2C
                dc.l    loc_60FFE
                dc.b    $38,-$2C
                dc.l    loc_60FFE
                dc.b    0,-$28
ChildObjDat_61424:
                dc.w    4-1
                dc.l    loc_60DAC
                dc.b    -$30,-$18
                dc.l    loc_60DAC
                dc.b    -$10,-$18
                dc.l    loc_60DAC
                dc.b    $10,-$18
                dc.l    loc_60DAC
                dc.b    $30,-$18
ChildObjDat_6143E:
                dc.w    $10-1
                dc.l    loc_6101E
ChildObjDat_61444:
                dc.w    1-1
                dc.l    loc_60EBA
ChildObjDat_6144A:
                dc.w    1-1
                dc.l    loc_610B6
byte_61450:
                dc.b    3,   5,   6,   7, $14,   5, $F4
                dc.b    $7F,   5,   5, $FC
byte_6145B:
                dc.b    2,   3,   3,   3,   4,  $F,   3,   3,   2,   3, $F4
byte_61466:
                dc.b    $7F,   8,   8, $FC
byte_6146A:
                dc.b    $7F,   9,   9, $FC
byte_6146E:
                dc.b    $7F,  $A,  $A, $FC
byte_61472:
                dc.b    $7F,  $B,  $B, $FC
byte_61476:
                dc.b    $7F,  $C,  $C, $FC
byte_6147A:
                dc.b    $7F,  $D,  $D, $FC
byte_6147E:
                dc.b    $7F,  $E,  $E, $FC
byte_61482:
                dc.b    $7F,  $F,  $F, $FC
byte_61486:
                dc.b    1, $10, $11, $FC
Map_GumballBonus:
                include "src/objects/shared/zones/gumball/map_gumball_bonus.s"

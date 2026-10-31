; Owner: objects/bosses/soz/end_boss/sk
; Responsibility: Sandopolis end-boss object attributes, construction records, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_SOZEndBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $300
                dc.b    $20, $20,  $A,   0
ObjDat3_78296:
                dc.l    Map_SOZEndBoss
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $280
                dc.b    $18, $1C,   6,   0
ObjDat3_782A2:
                dc.l    Map_SOZEndBossBody
                dc.w    make_art_tile($001,0,0)
                dc.w    0
                dc.b    $10, $30,   0,   0
word_782AE:
                dc.w    $200
                dc.b    $18, $18,   0,   0
word_782B4:
                dc.w    $300
                dc.b    $18, $18,   3,   0
word_782BA:
                dc.w    $180
                dc.b    $14, $14,   1,   0
word_782C0:
                dc.w    $300
                dc.b    $14, $14,   4,   0
word_782C6:
                dc.w    $100
                dc.b    $28, $14,   2,   0
word_782CC:
                dc.w    $300
                dc.b    $28, $14,   5,   0
ObjDat3_782D2:
                dc.l    Map_SOZEndBoss
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,1)
                dc.w    $180
                dc.b    8,   8,  $D,   0
word_782DE:
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $200
                dc.b    4,   4,  $A,   0
word_782E6:
                dc.w    make_art_tile(ArtTile_SOZEndBoss,1,0)
                dc.w    $300
                dc.b    $14, $14,  $E, $98
ObjDat3_782EE:
                dc.l    Map_SpriteMask
                dc.w    make_art_tile($000,0,0)
                dc.w    $280
                dc.b    $20, $20,   4,   0
ChildObjDat_782FA:
                dc.w    6-1
                dc.l    loc_77CB4
                dc.b    0,-$14
                dc.l    loc_77D1A
                dc.b    0, $40
                dc.l    loc_77D82
                dc.b    $20,   0
                dc.l    loc_77FFC
                dc.b    0,   0
                dc.l    loc_77DD8
                dc.b    0, $24
                dc.l    Obj_RobotnikHead4
                dc.b    0,-$1C
ChildObjDat_78320:
                dc.w    3-1
                dc.l    loc_77AB8
ChildObjDat_78326:
                dc.w    3-1
                dc.l    loc_77AB4
ChildObjDat_7832C:
                dc.w    1-1
                dc.l    loc_77DF8
                dc.b    -$18,-$2E
ChildObjDat_78334:
                dc.w    $14-1
                dc.l    loc_77E7C
ChildObjDat_7833A:
                dc.w    2-1
                dc.l    loc_77FCE
                dc.b    0,-$14
                dc.l    loc_77F3E
                dc.b    4, -$A
byte_78348:
                dc.b    7,  $A,  $A,  $B,  $C, $F4
                even
Map_SOZEndBoss:
                include "src/objects/shared/zones/soz/mappings/end_boss.s"
Map_SOZEndBossBody:
                include "src/objects/shared/zones/soz/boss/mappings/body.s"
Pal_SOZEndBoss1:
                binclude "data/Levels/SOZ/Palettes/End Boss 1.bin"
                even
Pal_SOZEndBoss2:
                binclude "data/Levels/SOZ/Palettes/End Boss 2.bin"
                even
; ---------------------------------------------------------------------------
word_784E0:
                dc.w    $610,  $810, $2B00, $2D00
word_784E8:
                dc.w    $710,  $710, $2C00, $2C00
                even

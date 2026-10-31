; Owner: objects/bosses/lbz/end_boss/sk
; Responsibility: Launch Base end-boss object attributes, child construction, raw animations and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZEndBoss:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $280
                dc.b    $20, $10,   0, $18
ObjDat3_740F8:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_FBZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
ObjDat3_74104:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $300
                dc.b    $10,   8,   4,   0
ObjDat3_74110:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    0
                dc.b    8, $80,  $C,   0
word_7411C:
                dc.w    $280
                dc.b    8, $18,   2,   0
word_74122:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $D,   0
word_7412A:
                dc.w    $280
                dc.b    $10, $10,   5, $9A
word_74130:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
word_74138:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $A,   0
ObjDat3_74140:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,2,0)
                dc.w    $280
                dc.b    8,   8,  $E,   0
ChildObjDat_7414C:
                dc.w    2-1
                dc.l    loc_73E0E
                dc.b    0,  -8
                dc.l    loc_73EA2
                dc.b    -$18,-$70
ChildObjDat_7415A:
                dc.w    1-1
                dc.l    loc_73D74
                dc.b    $70,-$18
ChildObjDat_74162:
                dc.w    3-1
                dc.l    loc_73C0A
                dc.b    -$18, $38
                dc.l    loc_73C0A
                dc.b    $18, $38
                dc.l    loc_73C0A
                dc.b    0, $38
ChildObjDat_74176:
                dc.w    3-1
                dc.l    loc_73C82
                dc.b    0,-$18
                dc.l    loc_73C82
                dc.b    0,  -8
                dc.l    loc_73C82
                dc.b    0,   8
ChildObjDat_7418A:
                dc.w    4-1
                dc.l    loc_73CB0
ChildObjDat_74190:
                dc.w    1-1
                dc.l    loc_73A92
                dc.b    0,   0
ChildObjDat_74198:
                dc.w    1-1
                dc.l    loc_73BA0
                dc.b    0, $10
ChildObjDat_741A0:
                dc.w    $C-1
                dc.l    loc_73BF6
                dc.b    -8,  -8
                dc.l    loc_73BF6
                dc.b    8,  -8
                dc.l    loc_73BF6
                dc.b    -8,   8
                dc.l    loc_73BF6
                dc.b    8,   8
                dc.l    loc_73BF6
                dc.b    -$10,-$10
                dc.l    loc_73BF6
                dc.b    $10,-$10
                dc.l    loc_73BF6
                dc.b    -$10, $10
                dc.l    loc_73BF6
                dc.b    $10, $10
                dc.l    loc_73BA0
                dc.b    -8,   6
                dc.l    loc_73BA0
                dc.b    6,   8
                dc.l    loc_73BA0
                dc.b    -8,  -6
                dc.l    loc_73BA0
                dc.b    6,  -8
byte_741EA:
                dc.b    7,   0,   1,   2,   1, $FC
byte_741F0:
                dc.b    7,   0,   1, $FC
byte_741F4:
                dc.b    0,   5,   6, $FC
byte_741F8:
                dc.b    5,   7,   7,   8,   9, $F4
                even
Pal_LBZEndBoss:
                binclude "data/Levels/LBZ/Palettes/End Boss.bin"
                even
Map_7421E:
                dc.w    word_74222-Map_7421E
                dc.w    word_74254-Map_7421E
word_74222:
                dc.w    8
                dc.b    $80, $07,   0,   0, $FF, $F8
                dc.b    $A0, $07,   0,   0, $FF, $F8
                dc.b    $C0, $07,   0,   0, $FF, $F8
                dc.b    $E0, $07,   0,   0, $FF, $F8
                dc.b    $00, $07,   0,   0, $FF, $F8
                dc.b    $20, $07,   0,   0, $FF, $F8
                dc.b    $40, $07,   0,   0, $FF, $F8
                dc.b    $60, $07,   0,   0, $FF, $F8
word_74254:
                dc.w    2
                dc.b    $EC, $07,   0,   0, $FF, $F8
                dc.b    $F4, $07,   0,   0, $FF, $F8

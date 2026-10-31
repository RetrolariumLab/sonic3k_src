; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss attributes, child creation, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_MHZEndBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $20, $20,  $A,   0
ObjDat3_76934:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,0)
                dc.w    $280
                dc.b    $80, $80,   1,   0
ObjDat3_76940:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,0)
                dc.w    $200
                dc.b    $80, $80,   4, $11
ObjDat3_7694C:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,0,0)
                dc.w    $200
                dc.b    $10, $10, $11, $8B
word_76958:
                dc.w    $180
                dc.b    $10, $10,   5,   0
word_7695E:
                dc.w    $180
                dc.b    $80, $80,  $E,   0
word_76964:
                dc.w    $200
                dc.b    $18, $28,   0, $25
ObjDat3_7696A:
                dc.l    Map_MHZEndBoss
                dc.w    make_art_tile(ArtTile_MHZEndBoss,1,1)
                dc.w    $80
                dc.b    $80, $80,   0,   0
ChildObjDat_76976:
                dc.w    2-1
                dc.l    loc_76502
ChildObjDat_7697C:
                dc.w    1-1
                dc.l    loc_764D0
ChildObjDat_76982:
                dc.w    4-1
                dc.l    loc_7665E
                dc.b    -$14, $18
                dc.l    loc_7665E
                dc.b    -$2C, $18
                dc.l    loc_76520
                dc.b    $11,-$51
                dc.l    loc_764A0
                dc.b    $21,-$10
ChildObjDat_7699C:
                dc.w    1-1
                dc.l    Obj_RobotnikHead4
                dc.b    0,-$1C
ChildObjDat_769A4:
                dc.w    2-1
                dc.l    loc_76604
ChildObjDat_769AA:
                dc.w    4-1
                dc.l    loc_76636
ChildObjDat_769B0:
                dc.w    6-1
                dc.l    loc_766CA
byte_769B6:
                dc.b    5,   1
                dc.b    6,   3
                dc.b    7,   5
                dc.b    8,   7
                dc.b    0,   9
                dc.b    $FC
byte_769C1:
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    9,   1
                dc.b    $A,   1
                dc.b    $B,   1
                dc.b    $C,   1
                dc.b    $FC
byte_769CE:
                dc.b    1,  $D,  $E,  $F, $10, $FC
                even
Pal_MHZEndBoss:
                binclude "data/Levels/MHZ/Palettes/End Boss.bin"
                even
word_769F4:
                dc.w    0,  $300, $3AA0, $3D90
                dc.w    $280,  $280, $3C90, $3C90
PLC_MHZEndBoss_Explosion:   plrlistheader
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
                plreq   ArtTile_Explosion, ArtNem_Explosion
PLC_MHZEndBoss_Explosion_End:

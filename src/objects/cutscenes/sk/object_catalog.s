; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene tracking slots, object attributes and child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjSlot_CutsceneKnux:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_CutsceneKnux
                dc.w    $180
                dc.b    $1C, $18, $16,   0
ObjSlot_CutsceneKnux_MHZ2:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_MHZKnuxPullSwitch
                dc.w    $180
                dc.b    $1C, $18,   3,   0
ObjSlot_KnuxIntroLay:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_Player_2,0,0)
                dc.w    $2E,     0
                dc.l    Map_KnuxIntroLay
                dc.w    $180
                dc.b    $1C, $18,   0,   0
ObjSlot_HPZKnucklesGrab:                                ; unused
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_HPZKnucklesGrab
                dc.w    $180
                dc.b    $1C, $18,   2,   0
ObjDat_CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_GrayButton,0,1)
                dc.w    $100
                dc.b    $10,   8,   0,   0
ObjDat3_6640E:
                dc.l    Map_LBZKnuxBomb
                dc.w    make_art_tile(ArtTile_LBZKnuxBomb,1,1)
                dc.w    $80
                dc.b    8,   8,   0,   0
ObjDat3_6641A:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat_LBZKnuxPillar:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $80,   1,   0
ObjDat3_66432:
                dc.l    Map_AIZCorkFloor
                dc.w    make_art_tile($001,2,0)
                dc.w    $180
                dc.b    $10, $18,   0,   0
ObjDat3_6643E:
                dc.l    Map_MHZKnuxPeer
                dc.w    make_art_tile(ArtTile_MHZKnuxPeer,1,0)
                dc.w    $180
                dc.b    $10, $10,   4,   0
ObjDat_MHZ1CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_MHZ1CutsceneButton,0,0)
                dc.w    $100
                dc.b    $80, $80,   0,   0
ObjDat3_66456:
                dc.l    Map_MHZKnuxSwitch
                dc.w    make_art_tile(ArtTile_MHZKnuxSwitch,1,1)
                dc.w    $300
                dc.b    $10, $10,   0,   0
ObjDat3_66462:
                dc.l    Map_MHZKnuxDoor
                dc.w    make_art_tile(ArtTile_MHZMisc+$82,3,0)
                dc.w    $80
                dc.b    $10, $20,   0,   0
ObjDat3_6646E:
                dc.l    Map_MHZKnuxLeaves
                dc.w    make_art_tile(ArtTile_MHZMisc+$21,3,1)
                dc.w    0
                dc.b    4,   4,   0,   0
ObjDat3_6647A:
                dc.l    Map_LRZKnuxBoulder
                dc.w    make_art_tile(ArtTile_LRZKnuxBoulder,2,0)
                dc.w    $200
                dc.b    $20, $20,   0,   0
ObjDat3_66486:
                dc.l    Map_KnuxIntroBomb
                dc.w    make_art_tile(ArtTile_KnuxIntroBomb,1,0)
                dc.w    $180
                dc.b    $C, $10,   0,   0
word_66492:
                dc.w    $100
                dc.b    8,   8,   1,   0
word_66498:
                dc.w    $100
                dc.b    8,   8,   5,   0
ObjDat_SSZCutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_SSZCutsceneButton,0,0)
                dc.w    $180
                dc.b    $10,   8,   1,   0
ObjDat3_664AA:
                dc.l    Map_SSZDeathEggSmall
                dc.w    make_art_tile(ArtTile_SSZDeathEggSmall,3,0)
                dc.w    $380
                dc.b    $3C, $30,   0,   0
ObjSlot_664B6:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_SSZDeathEggCloud,3,0)
                dc.w    $10,     2
                dc.l    Map_SSZDeathEggCloud
                dc.w    $280
                dc.b    $40, $10,   0,   0
ObjDat3_664C8:
                dc.l    Map_SpriteMask
                dc.w    make_art_tile($000,0,0)
                dc.w    $200
                dc.b    $40, $30,  $C,   0
word_664D4:
                dc.w    $300
                dc.b    4, $1C,   1,   0
word_664DA:
                dc.w    make_art_tile(ArtTile_SSZDeathEggSmall,0,0)
                dc.w    $280
                dc.b    8,   8,   4,   0
ObjDat3_664E2:
                dc.l    Map_DashDust
                dc.w    make_art_tile(ArtTile_HPZKnuxBossDust,0,0)
                dc.w    $80
                dc.b    $10, $10,  $A,   0
ObjDat3_664EE:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    0
                dc.b    $1C, $20,  $A,   0
ObjDat3_664FA:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_HPZSSZBossCrane,0,1)
                dc.w    $180
                dc.b    $14, $14,   0,   0
word_66506:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
word_6650C:
                dc.w    $180
                dc.b    4, $80,   4,   0
ObjDat3_66512:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    0
                dc.b    $C,  $C, $12,   0
ObjDat3_6651E:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,0)
                dc.w    $180
                dc.b    4,   8, $18,   0
ObjDat3_6652A:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_HPZSSZBossCrane,0,0)
                dc.w    0
                dc.b    8,   8, $12,   0
word_66536:
                dc.w    0
                dc.b    8,   8, $12,   0
ObjDat3_6653C:
                dc.l    Map_LRZ3Platform
                dc.w    make_art_tile($001,2,1)
                dc.w    0
                dc.b    $10, $20,   6,   0
word_66548:
                dc.w    0
                dc.b    4,   4,   7,   0
ObjDat3_6654E:
                dc.l    Map_HPZKnuxDizzyStars
                dc.w    make_art_tile(ArtTile_HPZKnuxDizzy,1,0)
                dc.w    $180
                dc.b    $C,   4,   1,   0
ChildObjDat_6655A:
                dc.w    1-1
                dc.l    loc_620EA
ChildObjDat_66560:
                dc.w    1-1
                dc.l    loc_62458
                dc.b    -$20,-$6C
ChildObjDat_66568:
                dc.w    3-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
ChildObjDat_6657C:
                dc.w    1-1
                dc.l    loc_627C6
                dc.b    -$40,   0
ChildObjDat_66584:
                dc.w    1-1
                dc.l    loc_6282A
                dc.b    -8,-$10
ChildObjDat_6658C:
                dc.w    4-1
                dc.l    loc_6285A
ChildObjDat_66592:
                dc.w    4-1
                dc.l    loc_629CE
                dc.b    2, $24
ChildObjDat_6659A:
                dc.w    1-1
                dc.l    loc_61F60
                dc.b    0, $18
ChildObjDat_665A2:
                dc.w    1-1
                dc.l    Obj_CutsceneButton
                dc.b    0,  $C
ChildObjDat_665AA:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
ChildObjDat_665B0:
                dc.w    1-1
                dc.l    loc_62F72
ChildObjDat_665B6:
                dc.w    1-1
                dc.l    loc_6300C
ChildObjDat_665BC:
                dc.w    1-1
                dc.l    loc_632CA
                dc.b    -8,   0
ChildObjDat_665C4:
                dc.w    7-1
                dc.l    loc_65B0E
                dc.b    0,   0
                dc.l    loc_65A8C
                dc.b    0,-$33
                dc.l    loc_65B42
                dc.b    -$20, $1D
                dc.l    loc_65B42
                dc.b    -$10, $1D
                dc.l    loc_65B42
                dc.b    8, $1D
                dc.l    loc_65B42
                dc.b    $10, $1D
                dc.l    loc_65B42
                dc.b    $28, $1D
ChildObjDat_665F0:
                dc.w    1-1
                dc.l    loc_65B70
ChildObjDat_665F6:
                dc.w    1-1
                dc.l    loc_659CC
ChildObjDat_665FC:
                dc.w    1-1
                dc.l    loc_64C24
ChildObjDat_66602:
                dc.w    $10-1
                dc.l    loc_652A2
ChildObjDat_66608:
                dc.w    1-1
                dc.l    loc_6502E
                dc.b    0, $23
ChildObjDat_66610:
                dc.w    2-1
                dc.l    loc_65138
                dc.b    0,   0
                dc.l    loc_6515E
                dc.b    0,-$30
ChildObjDat_6661E:
                dc.w    $F-1
                dc.l    loc_6518A
ChildSpriteDat_66624:
                dc.w    2-1
                dc.l    loc_6531E
                dc.b    8,  -4
ChildObjDat3_6662C:
                dc.w    $A-1
                dc.l    loc_65376
ChildObjDat3_66632:
                dc.w    $A-1
                dc.l    loc_65360
ChildObjDat_66638:
                dc.w    5-1
                dc.l    loc_65226
ChildObjDat_6663E:
                dc.w    1-1
                dc.l    loc_655B2
ChildObjDat_66644:
                dc.w    1-1
                dc.l    loc_6563A
ChildObjDat_6664A:
                dc.w    $20-1
                dc.l    loc_65602
ChildObjDat_66650:
                dc.w    $A-1
                dc.l    loc_6395C
ChildObjDat_66656:
                dc.w    8-1
                dc.l    loc_63694
ChildObjDat_6665C:
                dc.w    1-1
                dc.l    loc_638DC
                dc.b    0,-$14
ChildObjDat_66664:
                dc.w    1-1
                dc.l    loc_63916

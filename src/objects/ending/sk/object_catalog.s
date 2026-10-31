; Owner: objects/ending/sk
; Responsibility: Ending object attributes, child creation records and raw animation streams
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat3_600C2:
                dc.l    Map_KnuxEnding
                dc.w    make_art_tile(ArtTile_Ending_SSZKnuckles,0,1)
                dc.w    $200
                dc.b    $20, $20,   5,   0
ObjDat3_600CE:
                dc.l    Map_SonicPlane
                dc.w    make_art_tile(ArtTile_Ending_Plane,0,1)
                dc.w    $200
                dc.b    $40, $20,   1,   0
ObjDat3_600DA:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $20, $14,   0,   0
ObjDat3_600E6:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $C,  $C,   0,   0
word_600F2:
                dc.w    $200
                dc.b    4,   8,   4,   0
word_600F8:
                dc.w    $180
                dc.b    $C,   4, $16,   0
word_600FE:
                dc.w    $200
                dc.b    $40, $10,   9,   0
ObjDat3_60104:
                dc.l    Map_SonicPlaneEnding
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,0,1)
                dc.w    $200
                dc.b    $80, $10,   7,   0
word_60110:
                dc.w    make_art_tile(ArtTile_Ending_PlaneExtra,2,0)
                dc.w    $200
                dc.b    4,   4, $11,   0
ObjDat3_60118:
                dc.l    Map_SKPoseBanner
                dc.w    make_art_tile(ArtTile_Ending_Logo,1,1)
                dc.w    $180
                dc.b    $40, $14,   0,   0
ObjDat3_60124:
                dc.l    Map_S3PoseBanner
                dc.w    make_art_tile(ArtTile_Ending_Logo,1,1)
                dc.w    $180
                dc.b    $30, $10,   0,   0
ObjDat3_60130:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $180
                dc.b    8,   4,   2,   0
ObjDat3_6013C:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $180
                dc.b    $20,   4,   0,   0
ObjDat3_60148:
                dc.l    Map_ANDKnuckles
                dc.w    make_art_tile(ArtTile_Ending_ANDKnuckles,1,1)
                dc.w    $300
                dc.b    $38,   8,   1,   0
ObjDat3_60154:
                dc.l    Map_S3EndingGraphics
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,1,1)
                dc.w    $180
                dc.b    $50, $50,   0,   0
word_60160:
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,0,1)
                dc.w    $100
                dc.b    $20, $20,   1,   0
word_60168:
                dc.w    make_art_tile(ArtTile_Ending_S3Sprites,0,1)
                dc.w    $100
                dc.b    $20, $20,  $A,   0
word_60170:
                dc.w    $100
                dc.b    $C,  $C,  $A,   0
ObjDat3_60176:
                dc.l    Map_Knuckles
                dc.w    make_art_tile(ArtTile_Ending_Knuckles,2,1)
                dc.w    $100
                dc.b    $20, $20, $D8,   0
ObjDat3_60182:
                dc.l    Map_SSZMasterEmerald
                dc.w    make_art_tile(ArtTile_Ending_MasterEmerald,0,1)
                dc.w    $300
                dc.b    $20, $18,   2,   0
ObjDat3_6018E:
                dc.l    Map_EndingEyecatchEggman
                dc.w    make_art_tile(ArtTile_Ending_EyecatchEggman,1,1)
                dc.w    $200
                dc.b    $38, $20,   0,   0
ObjDat3_6019A:
                dc.l    Map_EndingEyecatchEggRobo
                dc.w    make_art_tile(ArtTile_Ending_EyecatchEggRobo,1,1)
                dc.w    $200
                dc.b    $38, $20,   0,   0
word_601A6:
                dc.w    $180
                dc.b    $38, $20,   4,   0
word_601AC:
                dc.w    $180
                dc.b    8,   8,   2,   0
ChildObjDat_601B2:
                dc.w    1-1
                dc.l    Obj_5EBC6
                dc.b    4,-$10
ChildObjDat_601BA:
                dc.w    1-1
                dc.l    Obj_5EA52
                dc.b    -$20, $2B
ChildObjDat_601C2:
                dc.w    1-1
                dc.l    Obj_5EB32
                dc.b    0,-$10
ChildObjDat_601CA:
                dc.w    2-1
                dc.l    loc_5ECB4
ChildObjDat_601D0:
                dc.w    1-1
                dc.l    loc_5EBF0
                dc.b    $1C,   0
ChildObjDat_601D8:
                dc.w    1-1
                dc.l    loc_5EC3C
                dc.b    -$A,  $C
ChildObjDat_601E0:
                dc.w    1-1
                dc.l    loc_5EC94
                dc.b    -$22,  -2
ChildObjDat_601E8:
                dc.w    1-1
                dc.l    loc_5DF80
                dc.b    -$40,  -4
ChildObjDat_601F0:
                dc.w    3-1
                dc.l    loc_5F31C
                dc.b    0,   0
                dc.l    loc_5F3AA
                dc.b    0,   0
                dc.l    loc_5F410
                dc.b    0,   0
ChildObjDat_60204:
                dc.w    1-1
                dc.l    loc_5F3EA
                dc.b    -$10,   8
ChildObjDat_6020C:
                dc.w    1-1
                dc.l    loc_5ED36
                dc.b    -$10,   5
ChildObjDat_60214:
                dc.w    5-1
                dc.l    loc_5E504
ChildObjDat_6021A:
                dc.w    2-1
                dc.l    loc_5E612
ChildObjDat_60220:
                dc.w    2-1
                dc.l    loc_5F690
                dc.b    0,-$10
                dc.l    loc_5F6A8
                dc.b    0,-$14
ChildObjDat_6022E:
                dc.w    1-1
                dc.l    loc_5ED6A
                dc.b    -6,   7
AniRaw_60236:
                dc.b    5,  $B,   6,   5,   7,  $B,   6,  $B, $FC
AniRaw_6023F:
                dc.b    4, $7F,   4, $7F, $FC
AniRaw_60244:
                dc.b    4,   0,   4, $3F,   1,   5,   2,   5,   3, $3F,   4, $7F,   4, $7F, $FC
AniRaw_60253:
                dc.b    1,  $F,   2,  $F,   3, $7F,   3, $7F, $FC
AniRaw_6025C:
                dc.b    $F,   1,   2, $FC
AniRaw_60260:
                dc.b    7,   1,   1,   3,   4
                dc.b    $F8, .jump-AniRaw_60260

                .jump:
                dc.b    $7F,   4,   4, $FC
AniRaw_6026B:
                dc.b    $F,  $A,  $B, $FC
AniRaw_6026F:
                dc.b    $B,   5,   6,   7,   8,   9, $FC
AniRaw_60276:
                dc.b    7,   0,   1,   2,   3, $FC
AniRaw_6027C:
                dc.b    7,   4,   5,   6, $FC
AniRaw_60281:
                dc.b    7,   7,   8,   9, $1A, $1A, $1A, $FC
AniRaw_60289:
                dc.b    7,  $A,  $B,  $C,  $D, $FC
AniRaw_6028F:
                dc.b    $B,  $E,  $F, $10, $11, $FC
AniRaw_60295:
                dc.b    $B, $12, $13, $14, $15, $FC
AniRaw_6029B:
                dc.b    $B, $16, $17, $18, $19, $FC
AniRaw_602A1:
                dc.b    5,   2,   3,   4,   3, $FC
AniRaw_602A7:
                dc.b    2,   0,   2,   1,   6,  $F,   2,   1,   6,   7,   2,   1,   6,   3,   2,   1
                dc.b    6,   1,   2,   1,   6,   1,   2, $13,   3, $3F, $F4
AniRaw_602C2:
                dc.b    $E,   0,   1, $FC
AniRaw_602C6:
                dc.b    $B,   0,   1, $FC
AniRaw_602CA:
                dc.b    5,   0,   0,   1,   2
                dc.b    $F8, .jump-AniRaw_602CA

                .jump:
                dc.b    $7F,   2,   2, $FC
                even

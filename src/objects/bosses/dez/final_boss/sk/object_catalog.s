; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss object attributes, child construction, animation and palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat3_81286:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    $20, $20,   5,   0
ObjDat3_81292:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    $10, $60,   0,   0
ObjDat3_8129E:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,1)
                dc.w    $300
                dc.b    $10, $10,   6, $8B
ObjDat3_812AA:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile($001,1,0)
                dc.w    $180
                dc.b    $40, $40, $1E,   0
ObjDat3_812B6:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $180
                dc.b    $10, $24, $1A,   0
word_812C2:
                dc.w    $200
                dc.b    4,   4, $1B,   0
ObjDat3_812C8:
                dc.l    Map_DEZFinalBossMisc
                dc.w    make_art_tile(ArtTile_DEZFinalBossMisc,1,0)
                dc.w    $280
                dc.b    4, $20, $18,   0
ObjDat3_812D4:
                dc.l    Map_BossMasterEmerald
                dc.w    make_art_tile(ArtTile_BossMasterEmerald,2,0)
                dc.w    $300
                dc.b    $20, $18,   1,   0
ObjDat3_812E0:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_DEZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
ObjDat3_812EC:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $200
                dc.b    $20, $20,   5,   0
ObjDat3_812F8:
                dc.l    Map_KnuxFinalBossCrane
                dc.w    make_art_tile(ArtTile_DEZBossCrane,0,0)
                dc.w    $200
                dc.b    $14, $14,   0,   0
ObjDat3_81304:
                dc.l    Map_DEZFinalBossDebris
                dc.w    make_art_tile(ArtTile_DEZFinalBossDebris,2,1)
                dc.w    $300
                dc.b    $18, $10,   0,   0
ChildObjDat_81310:
                dc.w    2-1
                dc.l    loc_80B22
ChildObjDat_81316:
                dc.w    3-1
                dc.l    loc_80CE2
                dc.b    0,-$10
                dc.l    loc_80CE2
                dc.b    -$20,-$10
                dc.l    loc_80CE2
                dc.b    $20,-$10
ChildObjDat_8132A:
                dc.w    1-1
                dc.l    loc_808AE
ChildObjDat_81330:
                dc.w    2-1
                dc.l    loc_804B0
                dc.b    0, $23
                dc.l    loc_806DA
                dc.b    0, $3B
byte_8133E:
                dc.b    0,   1
                dc.b    1,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    4,   0
                dc.b    $F4
byte_81349:
                dc.b    4,   3
                dc.b    3,   3
                dc.b    2,   3
                dc.b    1,   3
                dc.b    0,  $F
                dc.b    $F4
byte_81354:
                dc.b    2,   0,   1,   2,   1, $FC
byte_8135A:
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   5
                dc.b    $1A,   0
                dc.b    $1F,   4
                dc.b    $1A,   0
                dc.b    $1F,   4
                dc.b    $1A,   0
                dc.b    $1F,   3
                dc.b    $1A,   0
                dc.b    $1F,   3
                dc.b    $1A,   0
                dc.b    $1F,   2
                dc.b    $1A,   0
                dc.b    $1F,   2
                dc.b    $1A,   0
                dc.b    $1F,   1
                dc.b    $1A,   0
                dc.b    $1F,   1
                dc.b    $F4, $1A
                dc.b    0, $1F
                dc.b    0, $1A
                dc.b    0, $1F
                dc.b    0, $F4
byte_8138E:
                dc.b    $1B,   7
                dc.b    $1B,   7
                dc.b    $1C,   5
                dc.b    $1D,   3
                dc.b    $F4
byte_81397:
                dc.b    0,   0
                dc.b    6,   0
                dc.b    $E,   1
                dc.b    $16,   2
                dc.b    $1E,   3
                dc.b    $16,   1
                dc.b    $E,   2
                dc.b    6,   3
                dc.b    0,   0
                dc.b    $F4
                even

word_813AA:     palscriptptr .hdr1, .data1
                palscriptptr .hdr2, .data2
                .hdr1:  palscripthdr Normal_palette_line_3+$12, 1, 0
                .data1: palscriptdata 15,$660
                palscriptdata 18,$680
                palscriptdata 7, $880
                palscriptdata 7, $6A2
                palscriptdata 5, $AC0
                palscriptdata 5, $CE8
                palscriptdata 5, $AC0
                palscriptdata 7, $6A2
                palscriptdata 7, $880
                palscriptdata 18,$680
                palscriptrept
                .hdr2:  palscripthdr Normal_palette_line_3+$16, 1, 0
                .data2: palscriptdata 15,$6A0
                palscriptdata 9, $8C0
                palscriptdata 9, $AC0
                palscriptdata 7, $CE0
                palscriptdata 7, $CE6
                palscriptdata 5, $CE8
                palscriptdata 5, $EEC
                palscriptdata 5, $CE8
                palscriptdata 7, $CE6
                palscriptdata 7, $CE0
                palscriptdata 9, $AC0
                palscriptdata 9, $8C0
                palscriptrept

word_8141E:     palscriptptr .hdr1, .data1
                palscriptptr .hdr2, .data2
                .hdr1:  palscripthdr Normal_palette_line_4+$12, 1, 0
                .data1: palscriptdata 15,$660
                palscriptdata 18,$680
                palscriptdata 7, $880
                palscriptdata 7, $6A2
                palscriptdata 5, $AC0
                palscriptdata 5, $CE8
                palscriptdata 5, $AC0
                palscriptdata 7, $6A2
                palscriptdata 7, $880
                palscriptdata 18,$680
                palscriptrept
                .hdr2:  palscripthdr Normal_palette_line_4+$16, 1, 0
                .data2: palscriptdata 15,$6A0
                palscriptdata 9, $8C0
                palscriptdata 9, $AC0
                palscriptdata 7, $CE0
                palscriptdata 7, $CE6
                palscriptdata 5, $CE8
                palscriptdata 5, $EEC
                palscriptdata 5, $CE8
                palscriptdata 7, $CE6
                palscriptdata 7, $CE0
                palscriptdata 9, $AC0
                palscriptdata 9, $8C0
                palscriptrept

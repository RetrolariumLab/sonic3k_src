; Owner: objects/bosses/lbz/final_boss_2/s3
; Responsibility: Launch Base second final boss and unused Robotnik attributes, child records, ending poses, palettes and fade catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_LBZFinalBoss2:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $1C, $20,   5,   0
ObjDat3_51F24:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $200
                dc.b    $28, $28,   0,   0
ObjDat3_51F30:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $180
                dc.b    $20, $10,   2,   0
word_51F3C:
                dc.w    $80
                dc.b    $14, $14,   4,   0
word_51F42:
                dc.w    $180
                dc.b    8,   8,   3,   0
ObjDat3_51F48:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $300
                dc.b    $14,  $C,   1,   0
ObjDat3_51F54:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $C,  $C,  $C,   0
ObjDat3_51F60:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,1)
                dc.w    $100
                dc.b    $10, $14,  $D,   0
ObjDat3_51F6C:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,2,0)
                dc.w    $300
                dc.b    $C,  $C,   7,   0
ObjDat3_51F78:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $380
                dc.b    $18, $18,   0,   0
ObjDat3_51F84:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   3,   0
ObjDat3_51F90:
                dc.l    Map_LBZDeathEggSmall
                dc.w    make_art_tile(ArtTile_LBZ2DeathEggSmall,1,0)
                dc.w    $300
                dc.b    4,   4,   4,   0
ObjDat_LBZ2UnusedRobotnik:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
ObjDat3_51FA8:
                dc.l    Map_SonicTailsEndPoses
                dc.w    make_art_tile(ArtTile_Ending_S3EndPose,0,1)
                dc.w    $300
                dc.b    $40, $40,   0,   0
ChildObjDat_51FB4:
                dc.w    4-1
                dc.l    loc_511E8
                dc.b    $14, $24
                dc.l    loc_511CE
                dc.b    $C,-$14
                dc.l    loc_51392
                dc.b    0,-$18
                dc.l    loc_513AC
                dc.b    $38,-$14
ChildObjDat_51FCE:
                dc.w    1-1
                dc.l    loc_513E8
                dc.b    4,-$34
ChildObjDat_51FD6:
                dc.w    4-1
                dc.l    loc_512FC
                dc.b    -$2A,  -2
                dc.l    loc_512FC
                dc.b    -$4A,  -2
                dc.l    loc_512A6
                dc.b    0,   0
                dc.l    loc_5140A
                dc.b    -$40,  -2
ChildObjDat_51FF0:
                dc.w    5-1
                dc.l    loc_514F6
                dc.b    -$C,-$2C
                dc.l    loc_514F6
                dc.b    $14,-$2C
                dc.l    loc_514F6
                dc.b    $2C,-$18
                dc.l    loc_514F6
                dc.b    -$C,  -4
                dc.l    loc_514F6
                dc.b    $14,  -4
ChildObjDat_52010:
                dc.w    2-1
                dc.l    loc_51524
ChildObjDat_52016:
                dc.w    7-1
                dc.l    loc_516A4
                dc.b    0,   0
                dc.l    loc_516A4
                dc.b    -$10, $28
                dc.l    loc_516A4
                dc.b    -$70,   0
                dc.l    loc_516A4
                dc.b    -$48, $28
                dc.l    loc_516A4
                dc.b    $18, $10
                dc.l    loc_516A4
                dc.b    -$24,  -8
                dc.l    loc_516A4
                dc.b    -$50, $1C
ChildObjDat_52042:
                dc.w    1-1
                dc.l    loc_51AB8
ChildObjDat_52048:
                dc.w    1-1
                dc.l    loc_51B18
ChildObjDat_5204E:
                dc.w    1-1
                dc.l    loc_542B8
ChildObjDat_52054:
                dc.w    1-1
                dc.l    loc_54322
byte_5205A:
                dc.b    9,   7,   4,   5,   6,   5,   4, $FC
byte_52062:
                dc.b    9,  $B,   8,   9,  $A,   9,   8, $FC
byte_5206A:
                dc.b    2,   4,   4,   5,   6, $F4
byte_52070:
                dc.b    5, $C4
                dc.b    0, $55
                dc.b    0, $59
                dc.b    1, $5A
                dc.b    1, $FF
byte_5207A:
                dc.b    7, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $5A
                dc.b    1, $59
                dc.b    1, $55
                dc.b    0, $56
                dc.b    0, $57
                dc.b    0, $57
                dc.b    0, $57
                dc.b    0, $FF
off_52090:
                dc.l    byte_52098
                dc.l    byte_520D2
byte_52098:
                dc.b    $F, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $B1
                dc.b    0, $B2
                dc.b    0, $FF
byte_520D2:
                dc.b    $7F, $A6
                dc.b    0, $A6
                dc.b    0, $A6
                dc.b    0, $A6
                dc.b    0, $FF
Pal_LBZFinalBoss2:
                binclude "data/Levels/LBZ/Palettes/Final Boss 2.bin"
                even
Pal_LBZEnding:
                binclude "data/Levels/LBZ/Palettes/Ending.bin"
                even
Pal_SonicEndPose:
                binclude "data/General/Ending/Palettes/Sonic End Pose.bin"
                even
Pal_TailsEndPose:
                binclude "data/General/Ending/Palettes/Tails End Pose.bin"
                even
Pal_SuperSonicEndPose:
                binclude "data/General/Ending/Palettes/S3 Super Sonic End Pose.bin"
                even
Map_SonicTailsEndPoses:
                include "src/ui/shared/ending/mappings/sonic_tails_s3.s"

PalSPtr_LBZFinalBoss2_FadeIn:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_4+$16, 4, 2-1
                .data:  palscriptdata 16, $ECE, $E8A, $E48, $E46
                palscriptdata 16, $CAC, $C68, $C46, $A44
                palscriptdata 16, $A88, $A46, $824, $622
                palscriptdata 16, $844, $622, $400, $200
                palscriptrun

PalSPtr_LBZFinalBoss2_FadeOut:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_4+$16, 4, 2-1
                .data:  palscriptdata 16, $844, $622, $400, $200
                palscriptdata 16, $A88, $A46, $824, $622
                palscriptdata 16, $CAC, $C68, $C46, $A44
                palscriptdata 16, $ECE, $E8A, $E48, $E46
                palscriptrun

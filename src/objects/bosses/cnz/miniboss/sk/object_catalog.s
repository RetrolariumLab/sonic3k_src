; Owner: objects/bosses/cnz/miniboss/sk
; Responsibility: Carnival Night miniboss collision ranges, object attributes, child records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
CNZMiniboss_BaseRange:
                dc.w    -$18,   $30,  -$10,   $20
CNZMiniboss_CoilRange:
                dc.w    -$C,   $18,   $10,   $18
CNZMiniboss_CoilOpenRange:
                dc.w    -$C,   $18,   $10,   $38
ObjDat_CNZMiniboss:
                dc.l    Map_CNZMiniboss
                dc.w    make_art_tile(ArtTile_CNZMiniboss,1,1)
                dc.w    $280
                dc.b    $18, $30,   0,  $C
ObjDat3_CNZMinibossTop:
                dc.w    $200
                dc.b    $18, $10,   7, $AA
ObjDat3_CNZMinibossSpark:
                dc.w    $200
                dc.b    $C, $18,  $A, $92
ObjDat3_CNZMbossBounceEffect:
                dc.w    $100
                dc.b    8,   8,  $C,   0
ObjDat_CNZMinibossDebris:
                dc.l    Map_CNZMiniboss
                dc.w    make_art_tile(ArtTile_CNZMiniboss,1,1)
                dc.w    $100
                dc.b    $10, $10,   0,   0
Child1_CNZMinibossMakeTop:
                dc.w    2-1
                dc.l    Obj_CNZMinibossTop
                dc.b    0, $2C
                dc.l    Obj_CNZMinibossCoil
                dc.b    0, $1C
Child1_CNZMinibossTimedSparks:
                dc.w    2-1
                dc.l    Obj_CNZMinibossTimedSparks
                dc.b    -$14, $18
                dc.l    Obj_CNZMinibossTimedSparks
                dc.b    $14, $18
                dc.w    1-1
                dc.l    loc_6DEDE
                dc.b    0,  -4
Child1_CNZCoilOpenSparks:
                dc.w    3-1
                dc.l    Obj_CNZMinibossSparks
                dc.b    -4, $28
                dc.l    Obj_CNZMinibossSparks
                dc.b    4, $2C
                dc.l    Obj_CNZMinibossSparks
                dc.b    -4, $3C
Child1_CNZBounceEffect:
                dc.w    1-1
                dc.l    Obj_CNZMinibossBounceEffect
                dc.b    0,  -4
Child1_CNZMinibossExplosion:
                dc.w    1-1
                dc.l    Obj_CreateBossExplosion
                dc.b    0,   0
Child6_CNZMinibossMakeDebris:
                dc.w    9-1
                dc.l    Obj_CNZMinibossDebris
AniRaw_CNZMinibossOpening:
                dc.b    0,   3,   1,   3,   2,   3,   3,   3,   4,   3,   5,   3,   6,   3, $F4
AniRaw_CNZMinibossClosing:
                dc.b    6,   3,   5,   3,   4,   3,   3,   3,   2,   3,   1,   3,   0,   3, $F4
AniRaw_CNZMinibossTop:
                dc.b    7,   8,   7,   8,   9, $FC
AniRaw_CNZMinibossTop2:
                dc.b    0,   7,   8,   9, $FC
AniRaw_CNZMinibossTimedSparkLeft:
                dc.b    $A,   0, $11,   2,  $B,   0, $11,   2, $FC
AniRaw_CNZMinibossTimedSparkRight:
                dc.b    $F,   0, $11,   2, $10,   0, $11,   2, $FC
AniRaw_CNZMinibossSparks1:
                dc.b    $A,   0, $11,   7,  $B,   0, $11,   7, $FC
AniRaw_CNZMinibossSparks2:
                dc.b    $11,   0,  $F,   0, $11,   7, $10,   0, $11,   9, $FC
AniRaw_CNZMinibossSparks3:
                dc.b    $A,   0, $11,   7,  $B,   0, $11,  $B, $FC
AniRaw_CNZMBossBoundEffect:
                dc.b    $C,   0,  $D,   1,  $E,   1, $F4
                even
Pal_CNZMiniboss:
                binclude "data/Levels/CNZ/Palettes/Miniboss.bin"
                even
PalSPtr_CNZMinibossNormal:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 6, $020
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 4, $020
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, $B-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 1, $020
                palscriptrun

PalSPtr_CNZMinibossSparks:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, $31-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 1, $020
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 4-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 4, $020
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 2-1
                palscriptdata 96, $020
                palscriptloop PalSPtr_CNZMinibossNormal.headr3

PalSPtr_CNZMinibossOpen:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 0
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 8, $020
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 3, $020
                palscriptrept
; ---------------------------------------------------------------------------
word_6E46E:
                dc.w    0,  $300, $4660, $4860
word_6E476:
                dc.w    $240,  $240, $4760, $47E0

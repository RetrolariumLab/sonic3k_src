; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_MGZDrillBoss:
                dc.l    Map_MGZEndBoss
                dc.w    make_art_tile(ArtTile_MGZEndBoss,1,0)
                dc.w    $300
                dc.b    $24, $20,   0,  $F
word_4B390:
                dc.w    $380
                dc.b    $10, $10,   1,   0
word_4B396:
                dc.w    $300
                dc.b    $18, $18,   2,   0
word_4B39C:
                dc.w    $280
                dc.b    $C,  $C,   9, $8B
word_4B3A2:
                dc.w    $200
                dc.b    4,   4, $16, $98
word_4B3A8:
                dc.w    $180
                dc.b    $C,  $C,   6,   0
word_4B3AE:
                dc.w    make_art_tile(ArtTile_MGZEndBoss,0,0)
                dc.w    $180
                dc.b    $C,  $C, $19, $9A
ObjDat3_4B3B6:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZEndBossDebris,2,1)
                dc.w    $100
                dc.b    $10, $10,   0,   0
word_4B3C2:
                dc.w    $200
                dc.b    $10,   4,   0,   0
ObjDat3_4B3C8:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_MGZEndBossScaled,1,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
ChildObjDat_4B3D4:
                dc.w    4-1
                dc.l    loc_4A8D6
                dc.b    -$14,  $F
                dc.l    loc_4A5FC
                dc.b    -$1C, $10
                dc.l    loc_4AB4E
                dc.b    8, $18
                dc.l    loc_4AB4E
                dc.b    -$C, $18
ChildObjDat_4B3EE:
                dc.w    1-1
                dc.l    loc_4A69C
                dc.b    -$17,   0
ChildObjDat_4B3F6:
                dc.w    1-1
                dc.l    loc_4ABBE
                dc.b    0, $10
ChildObjDat_4B3FE:
                dc.w    $A-1
                dc.l    loc_4AC36
                dc.b    $18,-$40
ChildObjDat_4B406:
                dc.w    $A-1
                dc.l    loc_4AC36
                dc.b    -$18,-$40
ChildObjDat_4B40E:
                dc.w    1-1
                dc.l    loc_4A902
                dc.b    $C,   0
ChildObjDat_4B416:
                dc.w    8-1
                dc.l    loc_4AA86
                dc.b    -$10,   0
ChildObjDat_4B41E:
                dc.w    8-1
                dc.l    loc_4AA86
                dc.b    $10,   0
ChildObjDat_4B426:
                dc.w    1-1
                dc.l    loc_4A976
                dc.b    0,   0
ChildObjDat_4B42E:
                dc.w    1-1
                dc.l    loc_4A9CC
                dc.b    0,   0
ChildObjDat_4B436:
                dc.w    3-1
                dc.l    loc_4ACC6
                dc.b    $C,-$14
                dc.l    loc_4ACC6
                dc.b    -$10,   8
                dc.l    loc_4ACC6
                dc.b    $14,   8
ChildObjDat_4B44A:
                dc.w    1-1
                dc.l    loc_4ACFC
                dc.b    0,   0
byte_4B450:                                             ; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
byte_4B45B:
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $B,   7
                dc.b    9,   6
                dc.b    $A,   6
                dc.b    $B,   6
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $F8, byte_4B47B-byte_4B45B
byte_4B47B:
                dc.b    9,   2
                dc.b    $A,   2
                dc.b    $B,   2
                dc.b    $FC
byte_4B482:
                dc.b    $C,   7
                dc.b    $D,   7
                dc.b    $E,   7
                dc.b    $C,   6
                dc.b    $D,   6
                dc.b    $E,   6
                dc.b    $C,   5
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $C,   4
                dc.b    $D,   4
                dc.b    $E,   4
                dc.b    $C,   3
                dc.b    $D,   3
                dc.b    $E,   3
                dc.b    $F8, byte_4B4A2-byte_4B482
byte_4B4A2:
                dc.b    $C,   2
                dc.b    $D,   2
                dc.b    $E,   2
                dc.b    $FC
byte_4B4A9:
                dc.b    $20,   7
                dc.b    $21,   7
                dc.b    $22,   7
                dc.b    $20,   6
                dc.b    $21,   6
                dc.b    $22,   6
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22,   5
                dc.b    $20,   4
                dc.b    $21,   4
                dc.b    $22,   4
                dc.b    $20,   3
                dc.b    $21,   3
                dc.b    $22,   3
                dc.b    $F8, byte_4B4C9-byte_4B4A9
byte_4B4C9:
                dc.b    $20,   2
                dc.b    $21,   2
                dc.b    $22,   2
                dc.b    $FC
byte_4B4D0:
                dc.b    $14, $7F
                dc.b    $14, $7F
                dc.b    $FC
byte_4B4D5:
                dc.b    $13, $7F
                dc.b    $13, $7F
                dc.b    $FC
byte_4B4DA:
                dc.b    $26,   2
                dc.b    $27,   2
                dc.b    $28,   2
                dc.b    $FC
byte_4B4E1:
                dc.b    $F,   7
                dc.b    $10,   7
                dc.b    $11,   7
                dc.b    $F,   6
                dc.b    $10,   6
                dc.b    $11,   6
                dc.b    $F,   5
                dc.b    $10,   5
                dc.b    $11,   5
                dc.b    $F,   4
                dc.b    $10,   4
                dc.b    $11,   4
                dc.b    $F,   3
                dc.b    $10,   3
                dc.b    $11,   3
                dc.b    $F8, byte_4B501-byte_4B4E1
byte_4B501:
                dc.b    $F,   2
                dc.b    $10,   2
                dc.b    $11,   2
                dc.b    $FC
byte_4B508:
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    9,   4
                dc.b    $A,   4
                dc.b    $B,   4
                dc.b    9,   5
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    9,   6
                dc.b    $A,   6
                dc.b    $B,   6
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $B,   7
                dc.b    $F4
byte_4B527:
                dc.b    $C,   3
                dc.b    $D,   3
                dc.b    $E,   3
                dc.b    $C,   4
                dc.b    $D,   4
                dc.b    $E,   4
                dc.b    $C,   5
                dc.b    $D,   5
                dc.b    $E,   5
                dc.b    $C,   6
                dc.b    $D,   6
                dc.b    $E,   6
                dc.b    $C,   7
                dc.b    $D,   7
                dc.b    $E,   7
                dc.b    $F4
byte_4B546:
                dc.b    $20,   3
                dc.b    $21,   3
                dc.b    $22,   3
                dc.b    $20,   4
                dc.b    $21,   4
                dc.b    $22,   4
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22,   5
                dc.b    $20,   6
                dc.b    $21,   6
                dc.b    $22,   6
                dc.b    $20,   7
                dc.b    $21,   7
                dc.b    $22,   7
                dc.b    $F4
byte_4B565:
                dc.b    $F,   3
                dc.b    $10,   3
                dc.b    $11,   3
                dc.b    $F,   4
                dc.b    $10,   4
                dc.b    $11,   4
                dc.b    $F,   5
                dc.b    $10,   5
                dc.b    $11,   5
                dc.b    $F,   6
                dc.b    $10,   6
                dc.b    $11,   6
                dc.b    $F,   7
                dc.b    $10,   7
                dc.b    $11,   7
                dc.b    $F4
RawAni_4B584:
                dc.b    5,   0,   1, $FC
                even
Pal_MGZEndBoss:
                binclude "data/Levels/MGZ/Palettes/End Boss.bin"
                even

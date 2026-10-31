; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss object attributes, child creation records, animation and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_MGZDrillBoss:
                dc.l    Map_MGZEndBoss
                dc.w    make_art_tile(ArtTile_MGZEndBoss,1,0)
                dc.w    $300
                dc.b    $24, $20,   0,  $F
word_6D77C:
                dc.w    $380
                dc.b    $10, $10,   1,   0
word_6D782:
                dc.w    $300
                dc.b    $18, $18,   2,   0
word_6D788:
                dc.w    $280
                dc.b    $C,  $C,   9, $8B
word_6D78E:
                dc.w    $200
                dc.b    4,   4, $16, $98
word_6D794:
                dc.w    $300
                dc.b    4,   4, $16, $98
word_6D79A:
                dc.w    $180
                dc.b    $C,  $C,   6,   0
word_6D7A0:
                dc.w    make_art_tile(ArtTile_MGZEndBoss,0,0)
                dc.w    $180
                dc.b    $C,  $C, $19, $9A
ObjDat3_6D7A8:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZEndBossDebris,2,1)
                dc.w    $100
                dc.b    $10, $10,   0,   0
ObjDat3_6D7B4:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_MGZEndBossScaled,1,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
ChildObjDat_6D7C0:
                dc.w    4-1
                dc.l    loc_6CC46
                dc.b    -$14,  $F
                dc.l    loc_6C948
                dc.b    -$1C, $10
                dc.l    loc_6CEB0
                dc.b    8, $18
                dc.l    loc_6CEB0
                dc.b    -$C, $18
ChildObjDat_6D7DA:
                dc.w    1-1
                dc.l    loc_6C9E8
                dc.b    -$17,   0
ChildObjDat_6D7E2:
                dc.w    1-1
                dc.l    loc_6CF20
                dc.b    0, $10
ChildObjDat_6D7EA:
                dc.w    $A-1
                dc.l    loc_6CF9E
                dc.b    $18,-$40
ChildObjDat_6D7F2:
                dc.w    $A-1
                dc.l    loc_6CF9E
                dc.b    -$18,-$40
ChildObjDat_6D7FA:
                dc.w    1-1
                dc.l    loc_6CC72
                dc.b    $C,   0
ChildObjDat_6D802:
                dc.w    8-1
                dc.l    loc_6CDE8
                dc.b    -$10,   0
ChildObjDat_6D80A:
                dc.w    8-1
                dc.l    loc_6CDE8
                dc.b    $10,   0
ChildObjDat_6D812:
                dc.w    1-1
                dc.l    loc_6CCE6
                dc.b    0,   0
ChildObjDat_6D81A:
                dc.w    1-1
                dc.l    loc_6CD42
                dc.b    0,   0
ChildObjDat_6D822:
                dc.w    3-1
                dc.l    loc_6CFBE
                dc.b    $C,-$14
                dc.l    loc_6CFBE
                dc.b    -$10,   8
                dc.l    loc_6CFBE
                dc.b    $14,   8
ChildObjDat_6D836:
                dc.w    1-1
                dc.l    loc_6CFF4
                dc.b    0,   0
ChildObjDat_6D83E:
                dc.w    1-1
                dc.l    loc_6D16A
ChildObjDat_6D844:
                dc.w    1-1
                dc.l    loc_6D1BE
byte_6D84A:                                             ; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
byte_6D853:
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
                dc.b    $F8, byte_6D873-byte_6D853
byte_6D873:
                dc.b    9,   2
                dc.b    $A,   2
                dc.b    $B,   2
                dc.b    $FC
byte_6D87A:
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
                dc.b    $F8, byte_6D89A-byte_6D87A
byte_6D89A:
                dc.b    $C,   2
                dc.b    $D,   2
                dc.b    $E,   2
                dc.b    $FC
byte_6D8A1:
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
                dc.b    $F8, byte_6D8C1-byte_6D8A1
byte_6D8C1:
                dc.b    $20,   2
                dc.b    $21,   2
                dc.b    $22,   2
                dc.b    $FC
byte_6D8C8:
                dc.b    $14, $7F
                dc.b    $14, $7F
                dc.b    $FC
byte_6D8CD:
                dc.b    $13, $7F
                dc.b    $13, $7F
                dc.b    $FC
byte_6D8D2:
                dc.b    $26,   2
                dc.b    $27,   2
                dc.b    $28,   2
                dc.b    $FC
byte_6D8D9:
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
                dc.b    $F8, byte_6D8F9-byte_6D8D9
byte_6D8F9:
                dc.b    $F,   2
                dc.b    $10,   2
                dc.b    $11,   2
                dc.b    $FC
byte_6D900:
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
byte_6D91F:
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
byte_6D93E:
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
byte_6D95D:
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
Pal_MGZEndBoss:
                binclude "data/Levels/MGZ/Palettes/End Boss.bin"
                even

; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss attributes, child construction, animation, palette and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_DEZEndBoss:
                dc.l    Map_DEZEndBoss
                dc.w    make_art_tile(ArtTile_DEZEndBoss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_7FC50:
                dc.w    $180
                dc.b    $18, $18,   4, $D7
word_7FC56:
                dc.w    $200
                dc.b    $18,   4, $16, $9C
word_7FC5C:
                dc.w    $200
                dc.b    $18,  $C, $13, $9C
word_7FC62:
                dc.w    $280
                dc.b    $10, $18, $11,   0
word_7FC68:
                dc.w    $280
                dc.b    8,   8, $1F, $98
word_7FC6E:
                dc.w    0
                dc.b    $28, $28, $22,   0
ObjDat3_7FC74:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
ObjDat3_7FC80:
                dc.l    Map_DEZEndBoss
                dc.w    make_art_tile(ArtTile_DEZEndBoss,1,1)
                dc.w    $180
                dc.b    $C, $14, $14,   0
ChildObjDat_7FC8C:
                dc.w    2-1
                dc.l    loc_7F71C
                dc.b    0,   0
                dc.l    loc_7F782
                dc.b    0,   0
ChildObjDat_7FC9A:
                dc.w    1-1
                dc.l    loc_7F336
ChildObjDat_7FCA0:
                dc.w    2-1
                dc.l    loc_7F64A
                dc.b    0, $14
                dc.l    loc_7F398
                dc.b    0,  $C
ChildObjDat_7FCAE:
                dc.w    1-1
                dc.l    loc_7F6FA
ChildObjDat_7FCB4:
                dc.w    3-1
                dc.l    loc_7F60A
                dc.b    -$10,  -9
                dc.l    loc_7F60A
                dc.b    0, -$C
                dc.l    loc_7F60A
                dc.b    $10,  -9
ChildObjDat_7FCC8:
                dc.w    6-1
                dc.l    loc_7F7CE
ChildObjDat_7FCCE:
                dc.w    2-1
                dc.l    loc_7F7F6
byte_7FCD4:
                dc.b    3,   0,   1,   2, $F4
byte_7FCD9:
                dc.b    3,   2,   1,   0, $F4
byte_7FCDE:
                dc.b    3, $11, $12, $FC
byte_7FCE2:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
byte_7FCEF:
                dc.b    $16,   0
                dc.b    $17,   1
                dc.b    $1E,   1
                dc.b    $18,   0
                dc.b    $19,   1
                dc.b    $1E,   1
                dc.b    $1A,   0
                dc.b    $1B,   1
                dc.b    $1E,   4
                dc.b    $1C,   0
                dc.b    $1D,   1
                dc.b    $1E,   1
                dc.b    $FC
                even
Pal_DEZEndBoss:
                binclude "data/Levels/DEZ/Palettes/End Boss.bin"
                even
byte_7FD28:
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    $B
                dc.b    $C
                dc.b    $D
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $10
                dc.b    $11
                dc.b    $12
                dc.b    $13
                dc.b    $14
                dc.b    $15
                dc.b    $15
                dc.b    $16
                dc.b    $17
                dc.b    $18
                dc.b    $19
                dc.b    $19
                dc.b    $1A
                dc.b    $1B
                dc.b    $1C
                dc.b    $1C
                dc.b    $1D
                dc.b    $1E
                dc.b    $1E
                dc.b    $1F
                dc.b    $20
                dc.b    $20
                dc.b    $21
                dc.b    $21
                dc.b    $22
                dc.b    $22
                dc.b    $23
                dc.b    $23
                dc.b    $24
                dc.b    $24
                dc.b    $25
                dc.b    $25
                dc.b    $25
                dc.b    $26
                dc.b    $26
                dc.b    $26
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $27
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                dc.b    $28
                even

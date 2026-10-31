; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss and tree object attributes, construction, animation and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
ObjDat_MHZMiniboss:
                dc.l    Map_MHZMiniboss
                dc.w    make_art_tile(ArtTile_MHZMiniboss,1,1)
                dc.w    $200
                dc.b    $48, $40,   0,  $F
word_75E5E:
                dc.w    make_art_tile(ArtTile_MHZMiniboss,0,1)
                dc.w    $280
                dc.b    $C,  $C, $16, $9A
ObjDat_MHZMinibossTree:
                dc.l    Map_MHZMinibossTree
                dc.w    make_art_tile($001,3,0)
                dc.w    $380
                dc.b    $14, $90,   5,   0
ObjDat3_75E72:
                dc.l    Map_MHZMinibossLog
                dc.w    make_art_tile(ArtTile_MHZMinibossLog,3,0)
                dc.w    $380
                dc.b    $14, $14,   6, $86
word_75E7E:
                dc.w    $300
                dc.b    8,   8, $18, $8B
ChildObjDat_75E84:
                dc.w    1
                dc.l    loc_757C0
                dc.b    0,   0
                dc.l    loc_757C0
                dc.b    0,   0
                dc.l    loc_75B64
                dc.b    0,   0
ChildObjDat_75E98:
                dc.w    1-1
                dc.l    loc_75AD4
ChildObjDat_75E9E:
                dc.w    1-1
                dc.l    loc_7583A
                dc.b    0,  -8
ChildObjDat_75EA6:
                dc.w    1-1
                dc.l    loc_759C0
                dc.b    1, $13
byte_75EAE:
                dc.b    0,  $B
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,  $B
                dc.b    2,   5
                dc.b    1,   5
                dc.b    $FC
byte_75EBB:
                dc.b    4, $27
                dc.b    4, $27
                dc.b    7,   2
                dc.b    9,   2
                dc.b    $C,   2
                dc.b    $D, $3B
                dc.b    $B,   2
                dc.b    9,   2
                dc.b    7,   2
                dc.b    4, $27
                dc.b    $F4
byte_75ED0:
                dc.b    4, $27
                dc.b    4, $27
                dc.b    7,   2
                dc.b    9,   2
                dc.b    $C,   2
                dc.b    $D, $27
                dc.b    $10,   3
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12,   7
                dc.b    $11,   7
                dc.b    $12, $31
                dc.b    $F4
byte_75EF3:
                dc.b    $A,   3
                dc.b    $A,   3
                dc.b    8,   3
                dc.b    6,   3
                dc.b    $F8, .jump-byte_75EF3

                .jump:
                dc.b    6, $7F
                dc.b    6, $7F
                dc.b    $FC
byte_75F02:
                dc.b    $F, $31
                dc.b    $F, $31
                dc.b    $13,   4
                dc.b    $14,   4
                dc.b    $15,   4
                dc.b    $F4
byte_75F0D:
                dc.b    5, $7F
                dc.b    5, $7F
                dc.b    $FC
byte_75F12:
                dc.b    1,   0,   1,   2,   3,   4,   5,   6,   7, $FC
byte_75F1C:
                dc.b    $18,   3
                dc.b    $19,   3
                dc.b    $1A,   3
                dc.b    $1B,   3
                dc.b    $1C,  $B
                dc.b    $FC
                even
Pal_MHZMiniboss:
                binclude "data/Levels/MHZ/Palettes/Miniboss.bin"
                even
PLC_MHZMiniboss_Explosion:  plrlistheader
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_MHZMiniboss_Explosion_End:

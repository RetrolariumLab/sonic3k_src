; Owner: objects/level_end/s3
; Responsibility: Egg capsule object attributes, release child construction records and animal animation data
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_EggCapsule:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_54A88:
                dc.w    $200
                dc.b    $10,   8,   5,   0
ObjDat3_54A8E:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $180
                dc.b    $C,  $C,   0,   0
word_54A9A:
                dc.w    $280
                dc.b    8,   8,   2,   0
word_54AA0:
                dc.w    $200
                dc.b    $14,   4,   6,   0
ChildObjDat_54AA6:
                dc.w    1-1
                dc.l    loc_54672
                dc.b    0,-$28
ChildObjDat_54AAE:
                dc.w    1-1
                dc.l    loc_546AE
                dc.b    0, $28
ChildObjDat_54AB6:
                dc.w    2-1
                dc.l    loc_54758
                dc.b    -$14,-$24
                dc.l    loc_54758
                dc.b    $14,-$24
ChildObjDat_54AC4:
                dc.w    5-1
                dc.l    loc_5472C
                dc.b    0,  -8
                dc.l    loc_5472C
                dc.b    -$10,  -8
                dc.l    loc_5472C
                dc.b    $10,  -8
                dc.l    loc_5472C
                dc.b    -$18,  -8
                dc.l    loc_5472C
                dc.b    $18,  -8
ChildObjDat_54AE4:
                dc.w    9-1                             ; 15 entries are defined below
                dc.l    loc_54776
                dc.b    0,  -4
                dc.l    loc_54776
                dc.b    -8,  -4
                dc.l    loc_54776
                dc.b    8,  -4
                dc.l    loc_54776
                dc.b    $10,  -4
                dc.l    loc_54776
                dc.b    -$10,  -4
                dc.l    loc_54776
                dc.b    -$18,  -4
                dc.l    loc_54776
                dc.b    $18,  -4
                dc.l    loc_54776
                dc.b    -4,  -4
                dc.l    loc_54776
                dc.b    4,  -4
                dc.l    loc_54776
                dc.b    $C,  -4
                dc.l    loc_54776
                dc.b    -$C,  -4
                dc.l    loc_54776
                dc.b    -$14,  -4
                dc.l    loc_54776
                dc.b    $14,  -4
                dc.l    loc_54776
                dc.b    $1C,  -4
                dc.l    loc_54776
                dc.b    -$1C,  -4
byte_54B40:
                dc.b    0,   6,   7,   8,   9, $FC
                even

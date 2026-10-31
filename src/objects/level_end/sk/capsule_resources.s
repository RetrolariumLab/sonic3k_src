; Owner: objects/level_end/sk
; Responsibility: Egg capsule attributes, release child construction, animal animation and capsule mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_EggCapsule:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_86B3E:
                dc.w    $200
                dc.b    $10,   8,   5,   0
ObjDat3_86B44:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $180
                dc.b    $C,  $C,   0,   0
word_86B50:
                dc.w    $280
                dc.b    8,   8,   2,   0
word_86B56:
                dc.w    $200
                dc.b    $14,   4,   6,   0
ChildObjDat_86B5C:
                dc.w    1-1
                dc.l    loc_8671C
                dc.b    0,-$24
ChildObjDat_86B64:
                dc.w    1-1
                dc.l    loc_8675C
                dc.b    0, $24
ChildObjDat_86B6C:
                dc.w    2-1
                dc.l    loc_86802
                dc.b    -$14,-$24
                dc.l    loc_86802
                dc.b    $14,-$24
ChildObjDat_86B7A:
                dc.w    5-1
                dc.l    loc_867D6
                dc.b    0,  -8
                dc.l    loc_867D6
                dc.b    -$10,  -8
                dc.l    loc_867D6
                dc.b    $10,  -8
                dc.l    loc_867D6
                dc.b    -$18,  -8
                dc.l    loc_867D6
                dc.b    $18,  -8
ChildObjDat_86B9A:
                dc.w    9-1                             ; 15 entries are defined below
                dc.l    loc_86820
                dc.b    0,  -4
                dc.l    loc_86820
                dc.b    -8,  -4
                dc.l    loc_86820
                dc.b    8,  -4
                dc.l    loc_86820
                dc.b    $10,  -4
                dc.l    loc_86820
                dc.b    -$10,  -4
                dc.l    loc_86820
                dc.b    -$18,  -4
                dc.l    loc_86820
                dc.b    $18,  -4
                dc.l    loc_86820
                dc.b    -4,  -4
                dc.l    loc_86820
                dc.b    4,  -4
                dc.l    loc_86820
                dc.b    $C,  -4
                dc.l    loc_86820
                dc.b    -$C,  -4
                dc.l    loc_86820
                dc.b    -$14,  -4
                dc.l    loc_86820
                dc.b    $14,  -4
                dc.l    loc_86820
                dc.b    $1C,  -4
                dc.l    loc_86820
                dc.b    -$1C,  -4
byte_86BF6:
                dc.b    0,   6,   7,   8,   9, $FC
                even
Map_EggCapsule:
                include "src/objects/shared/egg_capsule/mappings/egg_capsule.s"

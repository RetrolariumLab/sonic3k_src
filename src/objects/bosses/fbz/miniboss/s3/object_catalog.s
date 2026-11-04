; Owner: objects/bosses/fbz/miniboss/s3
; Responsibility: Flying Battery miniboss object attributes, child records and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_FBZMiniboss:
                dc.l    Map_FBZMiniboss
                dc.w    make_art_tile(ArtTile_FBZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_4D474:
                dc.w    $100
                dc.b    8,   8,   1,   0
word_4D47A:
                dc.w    $300
                dc.b    $18, $10,   5,   0
word_4D480:
                dc.w    $280
                dc.b    8,   8,   6,   0
word_4D486:
                dc.w    $200
                dc.b    $18, $18,   7,   0
word_4D48C:
                dc.w    $100
                dc.b    $10,   8,   8,   0
word_4D492:
                dc.w    $180
                dc.b    $10,   8, $11,   0
word_4D498:
                dc.w    $280
                dc.b    $10,   8,   4,   0
ObjDat3_4D49E:                                          ; unused
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $100
                dc.b    8,   8,   0,   0
ObjDat3_4D4AA:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule-$46,0,1)
                dc.w    $200
                dc.b    $20, $20,   1,   0
ChildObjDat_4D4B6:
                dc.w    7-1
                dc.l    loc_4CB84
                dc.b    -$10,  -8
                dc.l    loc_4CB84
                dc.b    $10,  -8
                dc.l    loc_4CB84
                dc.b    0,  -8
                dc.l    loc_4CA50
                dc.b    0,-$28
                dc.l    loc_4CAE0
                dc.b    0,  -8
                dc.l    loc_4CBE8
                dc.b    0,   0
                dc.l    loc_4CBE8
                dc.b    0,   0
word_4D4E2:
                dc.w    5-1
                dc.l    loc_4CE44
ChildObjDat_4D4E8:
                dc.w    1-1
                dc.l    loc_4CB46
                dc.b    0,  -8
ChildObjDat_4D4F0:
                dc.w    1-1
                dc.l    loc_4D188
ChildObjDat_4D4F6:
                dc.w    5-1
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    0,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $1C,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$1C,  -4
                dc.b    3,   9,  $A,  $B,  $C,  $D,  $E,  $F, $10, $FC
                even
Pal_FBZMiniboss:
                binclude "data/Levels/FBZ/Palettes/S3 Miniboss.bin"
                even
word_4D540:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$1E, 1, 7-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 4, $644
                palscriptrun

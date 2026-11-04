; Owner: objects/level_end/s3
; Responsibility: Egg capsule object attributes, release child construction records and animal animation data
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
ObjDat_EggCapsule:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
S3Capsule_SharedButtonPartialAttributes:
                dc.w    $200
                dc.b    $10,   8,   5,   0
S3Capsule_ReleasedFragmentFullAttributes:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $180
                dc.b    $C,  $C,   0,   0
S3Capsule_FreedAnimalPartialAttributes:
                dc.w    $280
                dc.b    8,   8,   2,   0
S3Capsule_AnimatedFollowerAttrs:
                dc.w    $200
                dc.b    $14,   4,   6,   0
S3Capsule_GroundButtonChildList:
                dc.w    1-1
                dc.l    S3EggCapsule_InitGroundButton
                dc.b    0,-$28
S3Capsule_InvertedButtonChildList:
                dc.w    1-1
                dc.l    S3EggCapsule_InitInvertedPlunger
                dc.b    0, $28
S3Capsule_TwoAnimatedFollowerChildList:
                dc.w    2-1
                dc.l    S3EggCapsule_InitAnimatedFollower
                dc.b    -$14,-$24
                dc.l    S3EggCapsule_InitAnimatedFollower
                dc.b    $14,-$24
S3Capsule_FiveReleasedFragmentChildList:
                dc.w    5-1
                dc.l    S3EggCapsule_InitFragmentArt
                dc.b    0,  -8
                dc.l    S3EggCapsule_InitFragmentArt
                dc.b    -$10,  -8
                dc.l    S3EggCapsule_InitFragmentArt
                dc.b    $10,  -8
                dc.l    S3EggCapsule_InitFragmentArt
                dc.b    -$18,  -8
                dc.l    S3EggCapsule_InitFragmentArt
                dc.b    $18,  -8
; The count admits nine requests. Six trailing entries remain in the source data
S3Capsule_NineAnimalRequests:
                dc.w    9-1                             ; 15 entries are defined below
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    0,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -8,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    8,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$10,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$18,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $18,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -4,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    4,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $C,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$C,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$14,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $14,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    $1C,  -4
                dc.l    S3EggCapsule_InitFreedAnimal
                dc.b    -$1C,  -4
S3Capsule_AnimatedFollowerRawLoop:
                dc.b    0,   6,   7,   8,   9, $FC
                even

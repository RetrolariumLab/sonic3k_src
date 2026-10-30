; Owner: rendering/tile_animation/sk
; Responsibility: Tile-animation script catalog for Mushroom Hill through Death Egg
; Source provenance and ranges: config/reconstruction/source_layout.json

AniPLC_MHZ:     zoneanimstart
                zoneanimdecl -1, ArtUnc_AniMHZ__0, $025,$14,  4
                dc.b    0, $18
                dc.b    4,   0
                dc.b    0,   0
                dc.b    4,   0
                dc.b    8,   0
                dc.b    4,   0
                dc.b    8,   0
                dc.b    $C,   0
                dc.b    8,   0
                dc.b    $C,   0
                dc.b    8,   0
                dc.b    $C,   0
                dc.b    $10,   0
                dc.b    $C,   0
                dc.b    $10,   0
                dc.b    $14,   0
                dc.b    $10,   0
                dc.b    $14, $31
                dc.b    0,   0
                dc.b    $14,   0
                even
                zoneanimdecl -1, ArtUnc_AniMHZ__1, $019, $C,  4
                dc.b    0, $1D
                dc.b    4,   0
                dc.b    0,   0
                dc.b    4,   0
                dc.b    0,   0
                dc.b    4,   0
                dc.b    0,   0
                dc.b    4,   1
                dc.b    8, $1D
                dc.b    $C,   4
                dc.b    $10,   4
                dc.b    $14,   4
                even
                zoneanimdecl -1, ArtUnc_AniMHZ__2, $05D,  8,  8
                dc.b    0,   4
                dc.b    8,   4
                dc.b    $10,   6
                dc.b    8,   4
                dc.b    0,   4
                dc.b    $18,   4
                dc.b    $20,   6
                dc.b    $18,   4
                even
                zoneanimdecl -1, ArtUnc_AniMHZ__3, $01D,  8,  8
                dc.b    $10,   6
                dc.b    8,   4
                dc.b    0,   4
                dc.b    $18,   4
                dc.b    $20,   6
                dc.b    $18,   4
                dc.b    0,   4
                dc.b    8,   4
                even
                zoneanimend

AniPLC_LRZ1:    zoneanimstart
                zoneanimdecl 5, ArtUnc_AniLRZ1_0, $354,  4,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                even
                zoneanimdecl 5, ArtUnc_AniLRZ1_1, $350,  4,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                even
                zoneanimend

AniPLC_LRZ2:    zoneanimstart
                zoneanimdecl -1, ArtUnc_AniLRZ2_0, $358,  3,  6
                dc.b    0,   2
                dc.b    6,   2
                dc.b    $C,   1
                even
                zoneanimdecl 1, ArtUnc_AniLRZ2_1, $350,  8,  8
                dc.b    0
                dc.b    $38
                dc.b    $30
                dc.b    $28
                dc.b    $20
                dc.b    $18
                dc.b    $10
                dc.b    8
                even
                zoneanimend

AniPLC_SSZ:     zoneanimstart
                zoneanimdecl 7, ArtUnc_AniSSZ__0, $1F3,  4,$24
                dc.b    0
                dc.b    $24
                dc.b    $48
                dc.b    $6C
                even
                zoneanimdecl 7, ArtUnc_AniSSZ__1, $217,  4,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    $18
                even
                zoneanimdecl 7, ArtUnc_AniSSZ__2, $21F,  3,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    $18                             ; Unused; frame count is 3. There is no frame 4 in ArtUnc_AniSSZ__2, anyway
                even
                zoneanimdecl 2, ArtUnc_AniSSZ__3, $1D9,  4,  9
                dc.b    0
                dc.b    9
                dc.b    $12
                dc.b    $1B
                even
                zoneanimdecl 2, ArtUnc_AniSSZ__4, $1E2,  4,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                even
                zoneanimdecl 2, ArtUnc_AniSSZ__5, $1E6,  4, $D
                dc.b    0
                dc.b    $D
                dc.b    $1A
                dc.b    $27
                even
                zoneanimend

AniPLC_DEZ:     zoneanimstart
                zoneanimdecl 0, ArtUnc_AniDEZ__0, $0E4,  2,  2
                dc.b    0
                dc.b    2
                even
                zoneanimdecl 1, ArtUnc_AniDEZ__1, $1F4,  6,$1E
                dc.b    0
                dc.b    $1E
                dc.b    $3C
                dc.b    0
                dc.b    $1E
                dc.b    $3C
                even
                zoneanimdecl 3, ArtUnc_AniDEZ__2, $0EC,  8,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                dc.b    $10
                dc.b    $14
                dc.b    $18
                dc.b    $1C
                even
                zoneanimdecl -1, ArtUnc_AniDEZ__3, $05F,  4,  6
                dc.b    0,   9
                dc.b    6,   4
                dc.b    $C,   9
                dc.b    6,   4
                even
                zoneanimdecl 4, ArtUnc_AniDEZ__4, $04B,  4,  2
                dc.b    0
                dc.b    2
                dc.b    4
                dc.b    2
                even
                zoneanimdecl 4, ArtUnc_AniDEZ__5, $06B,  6,  3
                dc.b    0
                dc.b    3
                dc.b    6
                dc.b    0
                dc.b    3
                dc.b    6
                even
                zoneanimdecl 1, ArtUnc_AniDEZ__6, $028,  2,  8
                dc.b    0
                dc.b    8
                even
                zoneanimdecl 0, ArtUnc_AniDEZ__7, $26D,$84,  5
                dc.b    0
                dc.b    $2D
                dc.b    0
                dc.b    $2D
                dc.b    0
                dc.b    $2D
                dc.b    0
                dc.b    $2D
                dc.b    0
                dc.b    $2D
                dc.b    0
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    5
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $A
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $F
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $14
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $19
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $1E
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $23
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                dc.b    $28
                dc.b    $2D
                even
                zoneanimend

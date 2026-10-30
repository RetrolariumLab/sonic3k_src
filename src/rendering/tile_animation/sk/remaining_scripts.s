; Owner: rendering/tile_animation/sk
; Responsibility: Remaining zone, competition and bonus tile-animation script records
; Source provenance and ranges: config/reconstruction/source_layout.json

AniPLC_ALZ:     zoneanimstart
                zoneanimdecl 9, ArtUnc_AniALZ, $238,  3,$10
                dc.b    0
                dc.b    $10
                dc.b    $20
                even
                zoneanimend

AniPLC_BPZ:     zoneanimstart
                zoneanimdecl 7, ArtUnc_AniBPZ__0, $118,  6,  7
                dc.b    0
                dc.b    7
                dc.b    $E
                dc.b    $15
                dc.b    $1C
                dc.b    $23
                even
                zoneanimdecl 5, ArtUnc_AniBPZ__1, $11F, $A,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    $18
                dc.b    $20
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    $18
                dc.b    $20
                even
                zoneanimdecl 2, ArtUnc_AniBPZ__2, $127,  2,  3
                dc.b    0
                dc.b    3
                even
                zoneanimdecl 4, ArtUnc_AniBPZ__3, $12A,  2,  1
                dc.b    0
                dc.b    1
                even
                zoneanimend

AniPLC_DPZ:     zoneanimstart
                zoneanimdecl $B, ArtUnc_AniDPZ, $147,  5, $C
                dc.b    0
                dc.b    $C
                dc.b    $18
                dc.b    $24
                dc.b    $30
                even
                zoneanimend

AniPLC_Pachinko:    zoneanimstart
                zoneanimdecl 0, ArtUnc_AniPachinko, $125,  8,$26
                dc.b    $26
                dc.b    0
                dc.b    $4C
                dc.b    0
                dc.b    $72
                dc.b    0
                dc.b    $98
                dc.b    0
                even
                zoneanimend

AniPLC_NULL:    zoneanimstart
                zoneanimend

AniPLC_HPZ:     zoneanimstart
                zoneanimdecl 2, ArtUnc_AniHPZ__0, $2D0,  8,  3
                dc.b    0
                dc.b    3
                dc.b    6
                dc.b    9
                dc.b    $C
                dc.b    $F
                dc.b    $12
                dc.b    $15
                even
                zoneanimdecl 3, ArtUnc_AniHPZ__1, $2D3,  6,  2
                dc.b    0
                dc.b    2
                dc.b    4
                dc.b    6
                dc.b    8
                dc.b    $A
                even
                zoneanimdecl 2, ArtUnc_AniHPZ__2, $2D5,  8,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                dc.b    $10
                dc.b    $14
                dc.b    $18
                dc.b    $1C
                even
                zoneanimdecl 3, ArtUnc_AniHPZ__3, $2D9,  6,  3
                dc.b    0
                dc.b    3
                dc.b    6
                dc.b    9
                dc.b    $C
                dc.b    $F
                even
                zoneanimend

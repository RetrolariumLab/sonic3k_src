; Owner: rendering/tile_animation/s3
; Responsibility: Remaining zone, competition and bonus tile-animation script records
; Source provenance and ranges: config/reconstruction/source_layout.json

AniPLC_LRZ1:
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

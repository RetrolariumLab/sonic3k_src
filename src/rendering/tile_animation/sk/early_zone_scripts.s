; Owner: rendering/tile_animation/sk
; Responsibility: Tile-animation script catalog for the early cartridge zones
; Source provenance and ranges: config/reconstruction/source_layout.json

; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The AnimateTiles_DoAniPLC subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done

; zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_Flowers1, 6, 2
; -1   Global frame duration. If -1, then each frame will use its own duration, instead
; ArtUnc_Flowers1  Source address
; ArtTile_Flowers1 Destination VRAM address
; 6   Number of frames
; 2   Number of tiles to load into VRAM for each frame

; dc.b    0, $7F  ; Start of the script proper
; 0   Tile ID of first tile in ArtUnc_Flowers1 to transfer
; $7F   Frame duration. Only here if global duration is -1

AniPLC_AIZ1:    zoneanimstart
                zoneanimdecl -1, ArtUnc_AniAIZ1_0, $2E6,  9, $C
                dc.b    $3C, $4F
                dc.b    $30,   5
                dc.b    $18,   5
                dc.b    $C,   5
                dc.b    0, $4F
                dc.b    $C,   3
                dc.b    $18,   3
                dc.b    $24,   1
                dc.b    $30,   1
                even
                zoneanimdecl -1, ArtUnc_AniAIZ1_0, $2F2,  8, $C
                dc.b    $18,   5
                dc.b    $24,   5
                dc.b    $30,   5
                dc.b    $3C, $27
                dc.b    0,   5
                dc.b    $C,   5
                dc.b    $18,   5
                dc.b    $24,   5
                even
                zoneanimdecl -1, ArtUnc_AniAIZ1_1, $2FE,  8,  6
                dc.b    0,   7
                dc.b    6,   3
                dc.b    $C,   3
                dc.b    $12,   3
                dc.b    $18,   7
                dc.b    $12,   3
                dc.b    $C,   3
                dc.b    6,   3
                even
                zoneanimend

AniPLC_AIZ2:    zoneanimstart
                zoneanimdecl 3, ArtUnc_AniAIZ2_0, $0B3,  4,$17
                dc.b    0
                dc.b    $17
                dc.b    $2E
                dc.b    $45
                even
                zoneanimdecl -1, ArtUnc_AniAIZ2_1, $0CA,  9, $C
                dc.b    $3C, $4F
                dc.b    $30,   5
                dc.b    $18,   5
                dc.b    $C,   5
                dc.b    0, $4F
                dc.b    $C,   3
                dc.b    $18,   3
                dc.b    $24,   1
                dc.b    $30,   1
                even
                zoneanimdecl -1, ArtUnc_AniAIZ2_1, $0D6,  8, $C
                dc.b    $18,   5
                dc.b    $24,   5
                dc.b    $30,   5
                dc.b    $3C, $27
                dc.b    0,   5
                dc.b    $C,   5
                dc.b    $18,   5
                dc.b    $24,   5
                even
                zoneanimdecl 3, ArtUnc_AniAIZ2_2, $0E2,  4,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                even
                zoneanimdecl 3, ArtUnc_AniAIZ2_3, $0E6,  4,$18
                dc.b    0
                dc.b    $18
                dc.b    $30
                dc.b    $48
                even
                zoneanimend

AniPLC_HCZ1:    zoneanimstart
                zoneanimdecl -1, ArtUnc_AniHCZ1_0, $30C,  3,$24
                dc.b    0,   2
                dc.b    $24,   1
                dc.b    $48,   2
                even
                zoneanimdecl -1, ArtUnc_AniHCZ__1, $115,$10,  6
                dc.b    0,   4
                dc.b    6,   3
                dc.b    $C,   2
                dc.b    $12,   1
                dc.b    $18,   0
                dc.b    $1E,   1
                dc.b    $24,   2
                dc.b    $2A,   3
                dc.b    $30,   4
                dc.b    $2A,   3
                dc.b    $24,   2
                dc.b    $1E,   1
                dc.b    $18,   0
                dc.b    $12,   1
                dc.b    $C,   2
                dc.b    6,   3
                even
                zoneanimend

AniPLC_HCZ2:    zoneanimstart
                zoneanimdecl 3, ArtUnc_AniHCZ2_0, $25E,  4,$15
                dc.b    0
                dc.b    $15
                dc.b    $2A
                dc.b    $3F
                even
                zoneanimdecl -1, ArtUnc_AniHCZ__1, $115,$10,  6
                dc.b    0,   4
                dc.b    6,   3
                dc.b    $C,   2
                dc.b    $12,   1
                dc.b    $18,   0
                dc.b    $1E,   1
                dc.b    $24,   2
                dc.b    $2A,   3
                dc.b    $30,   4
                dc.b    $2A,   3
                dc.b    $24,   2
                dc.b    $1E,   1
                dc.b    $18,   0
                dc.b    $12,   1
                dc.b    $C,   2
                dc.b    6,   3
                even
                zoneanimend

AniPLC_MGZ:     zoneanimstart
                zoneanimdecl 9, ArtUnc_AniMGZ__0, $222,  6,$30
                dc.b    0
                dc.b    $30
                dc.b    $60
                dc.b    $90
                dc.b    $C0
                dc.b    $F0
                even
                zoneanimdecl -1, ArtUnc_AniMGZ__1, $252,  4,  1
                dc.b    0,   7
                dc.b    1,  $E
                dc.b    2,   7
                dc.b    1,  $E
                even
                zoneanimend

AniPLC_CNZ:     zoneanimstart
                zoneanimdecl 3, ArtUnc_AniCNZ__0, $2B2,$10,  9
                dc.b    0
                dc.b    $12
                dc.b    $24
                dc.b    $36
                dc.b    $48
                dc.b    $5A
                dc.b    $6C
                dc.b    $7E
                dc.b    9
                dc.b    $1B
                dc.b    $2D
                dc.b    $3F
                dc.b    $51
                dc.b    $63
                dc.b    $75
                dc.b    $87
                even
                zoneanimdecl 3, ArtUnc_AniCNZ__0, $2BB,$10,  9
                dc.b    9
                dc.b    $1B
                dc.b    $2D
                dc.b    $3F
                dc.b    $51
                dc.b    $63
                dc.b    $75
                dc.b    $87
                dc.b    0
                dc.b    $12
                dc.b    $24
                dc.b    $36
                dc.b    $48
                dc.b    $5A
                dc.b    $6C
                dc.b    $7E
                even
                zoneanimdecl 3, ArtUnc_AniCNZ__1, $2C4,$10,$10
                dc.b    0
                dc.b    $10
                dc.b    $20
                dc.b    $30
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                dc.b    $80
                dc.b    $90
                dc.b    $A0
                dc.b    $B0
                dc.b    $C0
                dc.b    $D0
                dc.b    $E0
                dc.b    $F0
                even
                zoneanimdecl 3, ArtUnc_AniCNZ__2, $2D4,  8,$20
                dc.b    0
                dc.b    $20
                dc.b    $40
                dc.b    $60
                dc.b    $80
                dc.b    $A0
                dc.b    $C0
                dc.b    $E0
                even
                zoneanimdecl 3, ArtUnc_AniCNZ__3, $2F4,  8,$10
                dc.b    0
                dc.b    $10
                dc.b    $20
                dc.b    $30
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                even
                zoneanimdecl 3, ArtUnc_AniCNZ__4, $304,  6,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    0
                dc.b    4
                dc.b    8
                even
                zoneanimdecl 1, ArtUnc_AniCNZ__5, $328,  4,$14
                dc.b    0
                dc.b    $14
                dc.b    $28
                dc.b    $3C
                even
                zoneanimend

AniPLC_FBZ1:    zoneanimstart
                zoneanimdecl $3F, ArtUnc_AniFBZ__0, $210,  2,$20
                dc.b    0
                dc.b    0
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__1, $230,  6,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    0
                dc.b    8
                dc.b    $10
                even
                zoneanimdecl 1, ArtUnc_AniFBZ__2, $238,  8,$10
                dc.b    0
                dc.b    $10
                dc.b    $20
                dc.b    $30
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__3, $200,  2,  8
                dc.b    0
                dc.b    8
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__4, $208,  6,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    0
                dc.b    8
                dc.b    $10
                even
                zoneanimend

AniPLC_FBZ2:    zoneanimstart
                zoneanimdecl 1, ArtUnc_AniFBZ__0, $210,  8,$20
                dc.b    0
                dc.b    $20
                dc.b    $40
                dc.b    $60
                dc.b    $80
                dc.b    $A0
                dc.b    $C0
                dc.b    $E0
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__1, $230,  6,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    0
                dc.b    8
                dc.b    $10
                even
                zoneanimdecl 1, ArtUnc_AniFBZ__2, $238,  8,$10
                dc.b    0
                dc.b    $10
                dc.b    $20
                dc.b    $30
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__3, $200,  2,  8
                dc.b    0
                dc.b    8
                even
                zoneanimdecl 7, ArtUnc_AniFBZ__4, $208,  6,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    0
                dc.b    8
                dc.b    $10
                even
                zoneanimend

AniPLC_ICZ:     zoneanimstart
                zoneanimdecl 3, ArtUnc_AniICZ__0, $11E,  8,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                dc.b    $10
                dc.b    $14
                dc.b    $18
                dc.b    $1C
                even
                zoneanimend

AniPLC_LBZ1:    zoneanimstart
                zoneanimdecl 2, ArtUnc_AniLBZ1_0, $365,  4,  8
                dc.b    0
                dc.b    8
                dc.b    $10
                dc.b    $18
                even
                zoneanimend

AniPLC_LBZSpec: zoneanimstart
                zoneanimdecl 7, ArtUnc_AniLBZ2_0, $170,  4,  5
                dc.b    0
                dc.b    5
                dc.b    $A
                dc.b    $F
                even
                zoneanimdecl 7, ArtUnc_AniLBZ2_1, $175,  6,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                dc.b    $10
                dc.b    $14
                even
                zoneanimend

AniPLC_LBZ2:    zoneanimstart
                zoneanimdecl 7, ArtUnc_AniLBZ2_0, $170,  4,  5
                dc.b    0
                dc.b    5
                dc.b    $A
                dc.b    $F
                even
                zoneanimdecl 7, ArtUnc_AniLBZ2_1, $175,  6,  4
                dc.b    0
                dc.b    4
                dc.b    8
                dc.b    $C
                dc.b    $10
                dc.b    $14
                even
                zoneanimend

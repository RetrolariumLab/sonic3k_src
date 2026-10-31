; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis ghost or capsule attributes, construction records, animation and pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

; ObjSlot_SOZGhosts:
Hyudoro_init_tbl:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_SOZGhosts,1,1)
                dc.w    $12
                dc.w    0
                dc.l    Map_SOZGhosts
                dc.w    0
                dc.b    $10, $14,   0,   0

; ObjDat_SOZGhostCapsule:
SOZ_capsule_init_tbl:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_SOZGhostCapsule,0,1)
                dc.w    $180
                dc.b    $30, $20,   0,   0

; ObjDat3_8F63A:
SOZ_capsule_Hyudoro_init_tbl:
                dc.l    Map_SOZGhosts
                dc.w    make_art_tile(ArtTile_SOZGhosts,1,1)
                dc.w    $200
                dc.b    $30, $20,   0,   0

; ChildObjDat_8F646:
SOZ_capsule_switch_set_tbl:
                dc.w    1-1
                dc.l    SOZ_capsule_switch
                dc.b    0,-$24

; ChildObjDat_8F64E:
SOZ_capsule_Hyudoro_set_tbl:
                dc.w    6-1
                dc.l    SOZ_capsule_Hyudoro
                dc.b    -8,  -4
                dc.l    SOZ_capsule_Hyudoro
                dc.b    8,  -4
                dc.l    SOZ_capsule_Hyudoro
                dc.b    $10,  -4
                dc.l    SOZ_capsule_Hyudoro
                dc.b    -$10,  -4
                dc.l    SOZ_capsule_Hyudoro
                dc.b    $18,  -4
                dc.l    SOZ_capsule_Hyudoro
                dc.b    -$18,  -4

; ChildObjDat_8F674:
Hyudoro_body_set_tbl:
                dc.w    1-1
                dc.l    Hyudoro_body

; DPLCPtr_SOZGhosts:
Hyudoro_DPLC_tbl:
                dc.l    ArtUnc_SOZGhosts
                dc.l    DPLC_SOZGhosts

; byte_8F682:
Hyudoro_apar_pg00:
                dc.b    $11,   3
                dc.b    $11,   3
                dc.b    $10,   3
                dc.b    $F,   4
                dc.b    $E,   4
                dc.b    $F8, Hyudoro_pg00-Hyudoro_apar_pg00

; byte_8F68E:
Hyudoro_pg00:
                dc.b    0,   3,   1,   3,   2,   4, $FC

; byte_8F695:
Hyudoro_apar_pg01:
                dc.b    $11,   3
                dc.b    $11,   3
                dc.b    $10,   3
                dc.b    $F,   4
                dc.b    $E,   4
                dc.b    $D,   4
                dc.b    $F8, Hyudoro_pg01-Hyudoro_apar_pg01

Hyudoro_pg01:
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   4
                dc.b    $FC

; byte_8F6AA:
Hyudoro_apar_pg02:
                dc.b    $11,   3
                dc.b    $11,   3
                dc.b    $10,   3
                dc.b    $F,   4
                dc.b    $E,   4
                dc.b    $D,   4
                dc.b    $F8, Hyudoro_pg02-Hyudoro_apar_pg02

Hyudoro_pg02:
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $C,   4
                dc.b    $FC

; byte_8F6BF:
Hyudoro_away_pg00:
                dc.b    $D,   4
                dc.b    $D,   4
                dc.b    $E,   4
                dc.b    $F,   4
                dc.b    $10,   3
                dc.b    $11,   3
                dc.b    $F4

; byte_8F6CC:
Hyudoro_chg_pg00:
                dc.b    3,   7
                dc.b    3,   7
                dc.b    4,   7
                dc.b    $F8, Hyudoro_pg01-Hyudoro_chg_pg00

; byte_8F6D4:
Hyudoro_chg_pg01:
                dc.b    8,   7
                dc.b    8,   7
                dc.b    9,   7
                dc.b    $F8, Hyudoro_pg02-Hyudoro_chg_pg01

DPLC_SOZGhosts:
                include "src/objects/shared/soz_ghosts/dplc/soz_ghosts.s"

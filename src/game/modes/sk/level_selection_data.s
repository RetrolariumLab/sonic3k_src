; Owner: game/modes/sk
; Responsibility: Level selection text, mapping offsets, identifier sequences and display asset storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; LevelSelect_DrawIcon and LevSel_IconTable used to be here

; ---------------------------------------------------------------------------
LevSel_MarkTable:                                       ; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
                dc.b    1,   6,   1, $24
                dc.b    1,   6,   2, $24
                dc.b    4,   6,   4, $24
                dc.b    4,   6,   5, $24
                dc.b    7,   6,   7, $24
                dc.b    7,   6,   8, $24
                dc.b    $A,   6,  $A, $24
                dc.b    $A,   6,  $B, $24
                dc.b    $D,   6,  $D, $24
                dc.b    $D,   6,  $E, $24
                dc.b    $10,   6, $10, $24
                dc.b    $10,   6, $11, $24
                dc.b    $13,   6, $13, $24
                dc.b    $13,   6, $14, $24
                dc.b    $16,   6, $16, $24
                dc.b    $16,   6, $17, $24
                dc.b    $19,   6, $19, $24
                dc.b    $19,   6, $1A, $24
; --- second column ---
                dc.b    1, $2C,   1, $4A
                dc.b    1, $2C,   2, $4A
                dc.b    4, $2C,   4, $4A
                dc.b    4, $2C,   5, $4A
                dc.b    7, $2C,   7, $4A
                dc.b    7, $2C,   8, $4A
                dc.b    $A, $2C,  $A, $4A
                dc.b    $A, $2C,  $B, $4A
                dc.b    $D, $2C,  $D, $4A
                dc.b    $D, $2C,  $E, $4A
                dc.b    $10, $2C, $10, $4A
                dc.b    $10, $2C, $11, $4A
                dc.b    $13, $2C, $13, $4A
                dc.b    $13, $2C, $14, $4A
                dc.b    $16, $2C, $16, $4A
LevSel_MappingOffsets:
                dc.w    planeLocH28(3,1)
                dc.w    planeLocH28(3,4)
                dc.w    planeLocH28(3,7)
                dc.w    planeLocH28(3,$A)
                dc.w    planeLocH28(3,$D)
                dc.w    planeLocH28(3,$10)
                dc.w    planeLocH28(3,$13)
                dc.w    planeLocH28(3,$16)
                dc.w    planeLocH28(3,$19)
                dc.w    planeLocH28($16,1)
                dc.w    planeLocH28($16,4)
                dc.w    planeLocH28($16,7)
                dc.w    planeLocH28($16,$A)
                dc.w    planeLocH28($16,$D)
                dc.w    planeLocH28($16,$10)
                dc.w    planeLocH28($16,$13)
                dc.w    planeLocH28($16,$16)
LevelSelectText:
                levselstr "ANGEL ISLAND"
                levselstr "HYDROCITY"
                levselstr "MARBLE GARDEN"
                levselstr "CARNIVAL NIGHT"
                levselstr "ICECAP"
                levselstr "LAUNCH BASE"
                levselstr "MUSHROOM HILL"
                levselstr "FLYING BATTERY"
                levselstr "SANDOPOLIS"
                levselstr "LAVA REEF"
                levselstr "LAVA REEF"
                levselstr "SKY SANCTUARY"
                levselstr "DEATHEGG"
                levselstr "THE DOOMSDAY"
                levselstr "BONUS"
                levselstr "SPECIAL STAGE"
                levselstr "SOUND TEST  *"
                even
AniPLC_SONICMILES:  zoneanimstart
; Sonic/Miles animated background
                zoneanimdecl -1, ArtUnc_SONICMILES, $001,  6, $A
                dc.b    0, $C7
                dc.b    $A,   5
                dc.b    $14,   5
                dc.b    $1E, $C7
                dc.b    $14,   5
                dc.b    $A,   5
                even
                zoneanimend
; ---------------------------------------------------------------------------

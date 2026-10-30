; Owner: game/modes/sk
; Responsibility: Save menu palettes, map-transfer descriptors, mapping owner and fixed menu-object creation records
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_Save_Chars:
                binclude "data/General/Save Menu/Palettes/Chars.bin"
                even
Pal_Save_Emeralds:
                binclude "data/General/Save Menu/Palettes/Emeralds.bin"
                even
Pal_Save_FinishCard1:
                binclude "data/General/Save Menu/Palettes/Finish Card 1.bin"
                even
Pal_Save_FinishCard2:
                binclude "data/General/Save Menu/Palettes/Finish Card 2.bin"
                even
Pal_Save_FinishCard3:
                binclude "data/General/Save Menu/Palettes/Finish Card 3.bin"
                even
Pal_Save_ZoneCard1:
                binclude "data/General/Save Menu/Palettes/Zone Card 1.bin"
                even
Pal_Save_ZoneCard2:
                binclude "data/General/Save Menu/Palettes/Zone Card 2.bin"
                even
Pal_Save_ZoneCard3:
                binclude "data/General/Save Menu/Palettes/Zone Card 3.bin"
                even
Pal_Save_ZoneCard4:
                binclude "data/General/Save Menu/Palettes/Zone Card 4.bin"
                even
Pal_Save_ZoneCard5:
                binclude "data/General/Save Menu/Palettes/Zone Card 5.bin"
                even
Pal_Save_ZoneCard6:
                binclude "data/General/Save Menu/Palettes/Zone Card 6.bin"
                even
Pal_Save_ZoneCard7:
                binclude "data/General/Save Menu/Palettes/Zone Card 7.bin"
                even
Pal_Save_ZoneCard8:
                binclude "data/General/Save Menu/Palettes/Zone Card 8.bin"
                even
Pal_Save_ZoneCard9:
                binclude "data/General/Save Menu/Palettes/Zone Card 9.bin"
                even
Pal_Save_ZoneCardA:
                binclude "data/General/Save Menu/Palettes/Zone Card A.bin"
                even
Pal_Save_ZoneCardB:
                binclude "data/General/Save Menu/Palettes/Zone Card B.bin"
                even
Pal_Save_ZoneCardC:
                binclude "data/General/Save Menu/Palettes/Zone Card C.bin"
                even
Pal_Save_ZoneCardD:
                binclude "data/General/Save Menu/Palettes/Zone Card D.bin"
                even
Pal_Save_ZoneCardE:
                binclude "data/General/Save Menu/Palettes/Zone Card E.bin"
                even
Pal_Save_ZoneCardF:
                binclude "data/General/Save Menu/Palettes/Zone Card F.bin"
                even
Pal_Save_ZoneCard10:
                binclude "data/General/Save Menu/Palettes/Zone Card 10.bin"
                even
Pal_Save_ZoneCard11:
                binclude "data/General/Save Menu/Palettes/Zone Card 11.bin"
                even
Pal_Save_ZoneCard12:
                binclude "data/General/Save Menu/Palettes/Zone Card 12.bin"
                even
word_CD58:
                dc.w    $12-1
                dc.l    RAM_start+$0222
                dc.w    VRAM_Plane_A_Name_Table+$102, $B-1,  $C-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$118, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$132, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$14C, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$166, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$180, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$19A, $D-1, $15-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E18, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E32, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E4C, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E66, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E80, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$E9A, $D-1,  $B-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$1B4, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$1CE, $D-1, $15-1
                dc.l    RAM_start+$0222
                dc.w    VRAM_Plane_A_Name_Table+$1E8, $B-1,  $C-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$EB4, $D-1,  $B-1
                dc.l    RAM_start+$0104
                dc.w    VRAM_Plane_A_Name_Table+$ECE, $D-1,  $B-1
Map_SaveScreen:
                include "src/ui/shared/save_menu/map_save_screen_general.s"
ObjDat_SaveScreen:
                dc.l    Draw_Sprite                     ; "Data Select" Text
                dc.w    $120                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $14C                            ; y_pos
                dc.b    3                               ; mapping_frame
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_Selector         ; Highlights the current selected slot
                dc.w    $120                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $E2                             ; y_pos
                dc.b    1                               ; mapping_frame
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_Delete_Save      ; Delete Icon that erases a saved game
                dc.w    $448                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $D8                             ; y_pos
                dc.b    $D                              ; mapping_frame
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_NoSave_Slot      ; Slot that starts a non-saving game
                dc.w    $B0                             ; x_pos, objoff_12 (x_pos copy)
                dc.w    $C8                             ; y_pos
                dc.b    0                               ; unused
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $110                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; mapping_frame
                dc.b    0                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $178                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    1                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $1E0                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    2                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $248                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    3                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $2B0                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    4                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $318                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    5                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $380                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    6                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $3E8                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $108                            ; y_pos
                dc.b    0                               ; unused
                dc.b    7                               ; Save Slot ID Number
; ---------------------------------------------------------------------------

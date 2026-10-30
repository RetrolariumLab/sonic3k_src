; Owner: game/modes/s3
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
Pal_Save_ZoneCard8:
                binclude "data/General/Save Menu/Palettes/Zone Card 8 S3.bin"
                even
Pal_Save_ZoneCard5:
                binclude "data/General/Save Menu/Palettes/Zone Card 5.bin"
                even
Pal_Save_ZoneCard6:
                binclude "data/General/Save Menu/Palettes/Zone Card 6.bin"
                even
word_BD16:
                dc.w    8-1
                dc.l    RAM_start+$0222
                dc.w    VRAM_Plane_A_Name_Table+$202, $B-1,  $C-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$218, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$232, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$24C, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$266, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$280, $D-1, $15-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$29A, $D-1, $15-1
                dc.l    RAM_start+$0222
                dc.w    VRAM_Plane_A_Name_Table+$2B4, $B-1,  $C-1
Map_SaveScreen:
                include "src/ui/shared/save_menu/map_save_screen_general_s3.s"
ObjDat_SaveScreen:
                dc.w    $A-1
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
                dc.w    $378                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $E0                             ; y_pos
                dc.b    $D                              ; mapping_frame
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_NoSave_Slot      ; Slot that starts a non-saving game
                dc.w    $B0                             ; x_pos, objoff_12 (x_pos copy)
                dc.w    $D0                             ; y_pos
                dc.b    0                               ; unused
                dc.b    0                               ; unused
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $110                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    0                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $178                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    1                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $1E0                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    2                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $248                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    3                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $2B0                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    4                               ; Save Slot ID Number
                dc.l    Obj_SaveScreen_Save_Slot        ; Save Slot
                dc.w    $318                            ; x_pos, objoff_12 (x_pos copy)
                dc.w    $118                            ; y_pos
                dc.b    0                               ; unused
                dc.b    5                               ; Save Slot ID Number
; ---------------------------------------------------------------------------

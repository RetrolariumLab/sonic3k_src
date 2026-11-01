; Owner: game/modes/sk
; Responsibility: Standalone copyright widget, map transfers, VRAM clearing, screen shake and background deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SKTitle_Copyright:
                move.l  #Map_SKTitle_Copyright,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_Menu,0,1),art_tile(a0)
                move.w  #$17F,x_pos(a0)
                move.w  #$152,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$2C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.l  #Obj_SKTitle_CopyrightDisplay,(a0)

Obj_SKTitle_CopyrightDisplay:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Copy_Map_Line_To_VRAM:
                subi.w  #$10,d1
                bcs.s   locret_5D22
                move.w  d1,d3
                andi.w  #7,d3
                bne.s   locret_5D22
                andi.w  #$F8,d1
                move.w  d1,d2
                add.w   d1,d1
                move.w  d1,d3
                lsl.w   #2,d1
                add.w   d3,d1
                lea     (a1,d1.w),a1
                lsl.w   #4,d2
                swap    d0
                add.w   d2,d0
                swap    d0
                moveq   #$28-1,d3
                lea     (VDP_data_port).l,a6
                move    #$2700,sr
                bsr.s   SKTitleWriteOneMapRowToVDPFromCommand
                move    #$2300,sr

locret_5D22:
                rts
; End of function Copy_Map_Line_To_VRAM

; =============== S U B R O U T I N E =======================================

RAM_Map_Data_To_VDP:
                lea     (VDP_data_port).l,a6
                moveq   #$28-1,d1
                moveq   #$20-1,d2

                .loop:
                movea.l a1,a2
                move.w  d1,d3
                bsr.s   SKTitleWriteOneMapRowToVDPFromCommand
                movea.l a2,a1
                addi.l  #$80<<16,d0
                dbf     d2,.loop
                rts
; End of function RAM_Map_Data_To_VDP

; =============== S U B R O U T I N E =======================================

SKTitleWriteOneMapRowToVDPFromCommand:
                move.l  d0,VDP_control_port-VDP_data_port(a6)

                .loop:
                move.w  (a1)+,(a6)
                dbf     d3,.loop
                rts
; End of function SKTitleWriteOneMapRowToVDPFromCommand

; =============== S U B R O U T I N E =======================================

ClearVRAMArea:
                lea     (VDP_data_port).l,a6
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                moveq   #0,d0

                .loop:
                move.l  d0,(a6)
                dbf     d3,.loop
                rts
; End of function ClearVRAMArea

; =============== S U B R O U T I N E =======================================

SKTitle_ScreenShake:
                tst.w   (Screen_shake_flag).w
                beq.s   locret_5D92                     ; If timer has run out, don't do anything
                subq.w  #1,(Screen_shake_flag).w
                bne.s   loc_5D72
                addq.w  #1,(Events_routine_fg).w        ; Increment title routine counter when this is done

loc_5D72:
                move.w  (V_int_run_count+2).w,d0
                andi.w  #$3F,d0                         ; Get frame counter then AND it for offset
                lea     (SKTitle_ShakeOffsets).l,a1
                lea     (a1,d0.w),a1
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,(Camera_Y_pos_P2_copy).w
                move.b  (a1)+,d0
                move.w  d0,(Camera_X_pos_P2_copy).w

locret_5D92:
                rts
; End of function SKTitle_ScreenShake

; =============== S U B R O U T I N E =======================================

SKTitle_DeformBG:
                move.w  (Camera_Y_pos).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_P2).w,(V_scroll_value_BG).w  ; Move BG position values to their proper spots
                moveq   #0,d2
                tst.w   (Screen_shake_flag).w
                beq.s   loc_5DB8
                move.w  (Camera_Y_pos_P2_copy).w,d0
                add.w   d0,(V_scroll_value).w
                add.w   d0,(V_scroll_value_BG).w        ; Shake the screen by the proper offsets if screen shaking is on
                move.w  (Camera_X_pos_P2_copy).w,d2     ; Move shake X amount to d2

loc_5DB8:
                lea     (H_scroll_buffer).w,a1
                move.w  (Events_routine_fg).w,d0
                bne.s   loc_5DE0

loc_5DC2:
                move.w  #224-1,d1                       ; If routine counter is zero
                move.w  (Camera_X_pos).w,d0
                add.w   d2,d0
                neg.w   d0
                swap    d0
                move.w  (Camera_X_pos_P2).w,d0
                add.w   d2,d0
                neg.w   d0

loc_5DD8:
                move.l  d0,(a1)+                        ; Do normal deformation, nothing special
                dbf     d1,loc_5DD8
                rts
; ---------------------------------------------------------------------------

loc_5DE0:
                subq.w  #1,d0
                bne.s   loc_5E0E
                add.w   (Camera_X_pos_P2).w,d2          ; If routine counter is 1
                neg.w   d2
                move.w  #112-1,d3

loc_5DEE:
                jsr     (Random_Number).l
                andi.w  #7,d0
                move.w  d0,(a1)+                        ; Shake the scanlines of the foreground (SEGA logo) by random amounts to simulate static
                move.w  d2,(a1)+
                swap    d0
                andi.w  #7,d0
                neg.w   d0
                move.w  d0,(a1)+
                move.w  d2,(a1)+
                dbf     d3,loc_5DEE
                rts
; ---------------------------------------------------------------------------

loc_5E0E:
                subq.w  #1,d0
                bne.s   loc_5DC2
                subq.w  #1,(Events_bg+$00).w            ; If routine counter is 2
                bne.s   loc_5E52
                addq.w  #1,(Events_routine_fg).w        ; If above timer has expired
                move    #$2700,sr
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$500,VRAM,WRITE),d0
                move.w  #$100-1,d3
                bsr.w   ClearVRAMArea                   ; Clear the Sega logo mappings from foreground
                move    #$2300,sr
                lea     (Pal_SKTitle_Knux).l,a0
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

loc_5E3E:
                move.l  (a0)+,(a2)+                     ; Load the knuckles palette into the final line
                dbf     d0,loc_5E3E
                move.l  #Obj_SKTitle_HandAnim,(Dynamic_object_RAM+object_size).w  ; Start hand animations
                moveq   #0,d2
                bra.w   loc_5DC2                        ; Then do normal deformation
; ---------------------------------------------------------------------------

loc_5E52:
                move.w  (Camera_X_pos_P2).w,d2
                neg.w   d2
                move.w  #112-1,d3

loc_5E5C:
                jsr     (Random_Number).l
                addq.w  #8,(a1)                         ; On every other line, alternate between moving the line randomly to the left and randomly to the right
                andi.w  #7,d0                           ; The result is a staticky phaseout effect of the SEGA logo
                add.w   d0,(a1)
                cmpi.w  #$FC,(a1)
                blt.s   loc_5E74
                move.w  #$FC,(a1)

loc_5E74:
                addq.w  #2,a1
                move.w  d2,(a1)+
                subq.w  #8,(a1)
                swap    d0
                andi.w  #7,d0
                sub.w   d0,(a1)
                cmpi.w  #-$104,(a1)
                bgt.s   loc_5E8C
                move.w  #-$104,(a1)

loc_5E8C:
                addq.w  #2,a1
                move.w  d2,(a1)+
                dbf     d3,loc_5E5C
                rts
; End of function SKTitle_DeformBG

; Owner: game/modes/s3
; Responsibility: Save selection mode initialization, active loop, navigation and product-specific save-slot presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
SaveScreen:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l

                dmaFillVRAM 0,$D000,$1000

                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8238,(a6)
                move.w  #$8338,(a6)
                move.w  #$8406,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9003,(a6)
                move.w  #$9280,(a6)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                clr.w   (Events_bg+$10).w
                clr.w   (Events_bg+$12).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (MapEni_SaveScreen_Layout).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_Save_Misc,0,1),d0
                jsr     (Eni_Decomp).l
                lea     word_BD16(pc),a0
                jsr     S3Save_UploadMapRectangles(pc)
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Save_Text),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S22POptions).l,a0
                jsr     (Nem_Decomp).l
                lea     NoSave_Delete_Text(pc),a1
                move.w  #VRAM_Plane_A_Name_Table+$D06,d0
                jsr     S3Save_WriteEncodedLabel(pc)
                move.w  #VRAM_Plane_A_Name_Table+$DB8,d0
                jsr     S3Save_WriteEncodedLabel(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     (KosArt_To_VDP).l
                move.l  #locret_B85A,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_SaveScreenMisc).l,a0    ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_Save_Misc),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_SaveMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

loc_B9D4:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B9D4
                lea     Pal_Save_Chars(pc),a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

loc_B9E0:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B9E0
                lea     (Object_RAM).w,a0
                lea     ObjDat_SaveScreen(pc),a1
                move.w  (a1)+,d0

loc_B9F0:
                move.l  (a1)+,(a0)
                move.w  #make_art_tile(ArtTile_Save_Misc,0,1),art_tile(a0)
                move.l  #Map_SaveScreen,mappings(a0)
                move.w  (a1),x_pos(a0)
                move.w  (a1)+,objoff_12(a0)             ; copy of object's x_pos
                move.w  (a1)+,y_pos(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,objoff_2E(a0)             ; used for save slot id
                move.b  #$40,render_flags(a0)           ; sets multi-sprite flag
                lea     next_object(a0),a0
                dbf     d0,loc_B9F0
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                lea     (Normal_palette_line_4).w,a0
                lea     (Target_palette_line_4).w,a1
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_4),d0

loc_BA3E:
                move.l  (a0),(a1)+
                clr.l   (a0)+
                dbf     d0,loc_BA3E
                lea     (ArtKos_SaveScreenS3Zone).l,a0
                lea     (RAM_start).l,a1
                jsr     (Kos_Decomp).l
                moveq   #signextendB(mus_DataSelect),d0
                jsr     (Play_Music).l
                move.l  #loc_BB0A,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

SaveScreen_MainLoop:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                move.w  d0,(H_scroll_buffer+2).w
                jsr     (Render_Sprites).l
                lea     (Normal_palette_line_3+$2).w,a0
                moveq   #$E,d0
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_BAC8
                lea     Pal_Save_Emeralds(pc),a1

loc_BAC0:
                move.w  (a1)+,(a0)+
                dbf     d0,loc_BAC0
                bra.s   loc_BAD0
; ---------------------------------------------------------------------------

loc_BAC8:
                move.w  #$CCC,(a0)+
                dbf     d0,loc_BAC8

loc_BAD0:
                cmpi.b  #GameMode_SaveScreen,(Game_mode).w  ; are we still in the savescreen mode?
                beq.s   SaveScreen_MainLoop             ; if so, loop
                moveq   #signextendB(sfx_EnterSS),d0
                jmp     (Play_SFX).l

; =============== S U B R O U T I N E =======================================

; Read the count-prefixed rectangle list and use a 128-cell-wide plane pitch
S3Save_UploadMapRectangles:
                move.w  (a0)+,d7

                .loop:
                movea.l (a0)+,a1
                move.w  (a0)+,d0
                bsr.s   S3Save_MakeVRAMWriteCommand
                move.w  (a0)+,d1
                move.w  (a0)+,d2
                jsr     (Plane_Map_To_VRAM_2).l
                dbf     d7,.loop
                rts
; End of function S3Save_UploadMapRectangles

; =============== S U B R O U T I N E =======================================

; The low word of d0 holds the VRAM byte address. Return the full VDP command in d0
S3Save_MakeVRAMWriteCommand:
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                ori.w   #$4000,d0
                swap    d0
                rts
; End of function S3Save_MakeVRAMWriteCommand

; ---------------------------------------------------------------------------
; selects whether to display the static screen, or new screen
; and is called during vblank
next_SaveSlot:  equ     8

loc_BB0A:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$C,d0
                lea     (MapPtrs_SaveScreenStatic).l,a2
                movea.l (a2,d0.w),a2
                lea     (Saved_data).w,a0
                move.w  #VRAM_Plane_A_Name_Table+$31A,d7
                moveq   #6-1,d6

loc_BB26:
                lea     (MapUnc_SaveScreenNEW).l,a1
                tst.b   (a0)                            ; is a game in progress?
                bmi.s   loc_BB32
                movea.l a2,a1

loc_BB32:
                move.w  d7,d0
                bsr.s   S3Save_MakeVRAMWriteCommand
                moveq   #10-1,d1
                moveq   #7-1,d2
                jsr     (Plane_Map_To_VRAM_2).l
                addi.w  #$1A,d7
                addq.w  #next_SaveSlot,a0
                dbf     d6,loc_BB26
                lea     (Saved_data).w,a0
                lea     (Dynamic_object_RAM+object_size).w,a3  ; load the first save slot object
                move.w  #VRAM_Plane_A_Name_Table+$B20,d7
                moveq   #6-1,d3

loc_BB58:
                move.w  d7,d0
                subq.w  #2,d0
                jsr     S3Save_MakeVRAMWriteCommand(pc)
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  #make_art_tile(ArtTile_Save_Misc+$12,0,1),(a6)
                lea     BlankSave_Text(pc),a1
                tst.b   (a0)
                bmi.s   loc_BB98
                lea     Clear_Text(pc),a1
                cmpi.w  #6,objoff_36(a3)
                bhi.s   loc_BB98
                lea     D_S_Zone_Text(pc),a1
                move.w  d7,d0
                subq.w  #2,d0
                jsr     S3Save_WriteEncodedLabel(pc)
                move.w  objoff_36(a3),d0
                move.b  DataSelectS3_ZoneNums(pc,d0.w),d0
                addi.w  #make_art_tile(ArtTile_Save_Text,1,1),d0
                move.w  d0,(a6)
                bra.s   loc_BB9E
; ---------------------------------------------------------------------------

loc_BB98:
                move.w  d7,d0
                jsr     S3Save_WriteEncodedLabel(pc)

loc_BB9E:
                addi.w  #$1A,d7
                addq.w  #next_SaveSlot,a0
                lea     next_object(a3),a3
                dbf     d3,loc_BB58
                rts
; ---------------------------------------------------------------------------
; byte_BBAE
DataSelectS3_ZoneNums:
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    5
                dc.b    5
                dc.b    6
                dc.b    0
                even

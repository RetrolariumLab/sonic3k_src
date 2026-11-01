; Owner: game/modes/sk
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
                lea     word_CD58(pc),a0
                jsr     SKSaveCopyListedMapRectanglesToWideVDPPlane(pc)
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Save_Text),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S22POptions).l,a0
                jsr     (Nem_Decomp).l
                lea     NoSave_Delete_Text(pc),a1
                move.w  #VRAM_Plane_A_Name_Table+$C06,d0
                jsr     SKSaveWriteEncodedLabelTilesUntilNegativeTerminator(pc)
                move.w  #VRAM_Plane_A_Name_Table+$C0C,d0
                jsr     SKSaveWriteEncodedLabelTilesUntilNegativeTerminator(pc)
                move.w  #VRAM_Plane_A_Name_Table+$CEC,d0
                jsr     SKSaveWriteEncodedLabelTilesUntilNegativeTerminator(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     (KosArt_To_VDP).l
                move.l  #locret_C56E,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_SaveScreenMisc).l,a0    ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_Save_Misc),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_SaveScreen).l,a0        ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_Save_Extra),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_SaveMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

loc_C710:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_C710
                lea     Pal_Save_Chars(pc),a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

loc_C71C:

                move.l  (a0)+,(a1)+
                dbf     d0,loc_C71C
                lea     (Object_RAM).w,a0
                lea     ObjDat_SaveScreen(pc),a1
                moveq   #$C-1,d0

loc_C72C:
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
                dbf     d0,loc_C72C
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                lea     (Normal_palette_line_4).w,a0
                lea     (Target_palette_line_4).w,a1
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_4),d0

loc_C77A:
                move.l  (a0),(a1)+
                clr.l   (a0)+
                dbf     d0,loc_C77A
                lea     (ArtKos_SaveScreenS3Zone).l,a0
                lea     (RAM_start).l,a1
                jsr     (Kos_Decomp).l
                lea     (RAM_start+$2BC0).l,a0
                lea     (RAM_start+$2300).l,a1
                move.w  #bytesToXcnt($1180,8),d0

loc_C7A4:
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                dbf     d0,loc_C7A4
                lea     (ArtKos_SaveScreenSKZone).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKos_SaveScreenPortrait).l,a0
                jsr     (Kos_Decomp).l
                lea     -$8C0(a1),a0
                move.w  #bytesToLcnt($540),d0

loc_C7CC:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_C7CC
                moveq   #signextendB(mus_DataSelect),d0
                jsr     (Play_Music).l
                move.l  #loc_C890,(_unkEF44_1).w
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
                move.w  (Emerald_flicker_flag).w,d1
                addq.w  #1,d1
                cmpi.w  #3,d1
                blo.s   loc_C83C
                moveq   #0,d1

loc_C83C:
                move.w  d1,(Emerald_flicker_flag).w
                beq.s   loc_C84E
                lea     Pal_Save_Emeralds(pc),a1

loc_C846:
                move.w  (a1)+,(a0)+
                dbf     d0,loc_C846
                bra.s   loc_C856
; ---------------------------------------------------------------------------

loc_C84E:
                move.w  #$EEE,(a0)+
                dbf     d0,loc_C84E

loc_C856:
                cmpi.b  #GameMode_SaveScreen,(Game_mode).w  ; are we still in the savescreen mode?
                beq.s   SaveScreen_MainLoop             ; if so, loop
                moveq   #signextendB(sfx_EnterSS),d0
                jmp     (Play_SFX).l

; =============== S U B R O U T I N E =======================================

SKSaveCopyListedMapRectanglesToWideVDPPlane:
                move.w  (a0)+,d7

                .loop:
                movea.l (a0)+,a1
                move.w  (a0)+,d0
                bsr.s   SKSaveConvertVRAMWordAddressToWriteCommand
                move.w  (a0)+,d1
                move.w  (a0)+,d2
                jsr     (Plane_Map_To_VRAM_2).l
                dbf     d7,.loop
                rts
; End of function SKSaveCopyListedMapRectanglesToWideVDPPlane

; =============== S U B R O U T I N E =======================================

SKSaveConvertVRAMWordAddressToWriteCommand:
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                ori.w   #$4000,d0
                swap    d0
                rts
; End of function SKSaveConvertVRAMWordAddressToWriteCommand

; ---------------------------------------------------------------------------
; selects whether to display the static screen, or new screen
; and is called during vblank
next_SaveSlot:  equ     $A

loc_C890:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$C,d0
                lea     (MapPtrs_SaveScreenStatic).l,a2
                movea.l (a2,d0.w),a2
                adda.l  #LockOnROM_Start,a2
                move.w  #VRAM_Plane_A_Name_Table+$21A,d7
                lea     (Saved_data).w,a0
                moveq   #8-1,d6

loc_C8B2:
                lea     (MapUnc_SaveScreenNEW).l,a1
                tst.b   (a0)                            ; is a game in progress?
                bmi.s   loc_C8BE
                movea.l a2,a1

loc_C8BE:
                move.w  d7,d0
                bsr.s   SKSaveConvertVRAMWordAddressToWriteCommand
                moveq   #10-1,d1
                moveq   #7-1,d2
                jsr     (Plane_Map_To_VRAM_2).l
                addi.w  #$1A,d7
                lea     next_SaveSlot(a0),a0
                dbf     d6,loc_C8B2
                lea     (Dynamic_object_RAM+object_size).w,a3  ; load the first save slot object
                move.w  #VRAM_Plane_A_Name_Table+$A20,d7
                lea     (Saved_data).w,a0
                moveq   #8-1,d3

loc_C8E6:
                move.w  d7,d0
                subq.w  #2,d0
                jsr     SKSaveConvertVRAMWordAddressToWriteCommand(pc)
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  #make_art_tile(ArtTile_Save_Misc+$12,0,1),(a6)
                lea     BlankSave_Text(pc),a1
                tst.b   (a0)
                bmi.s   loc_C946
                lea     Clear_Text(pc),a1
                move.b  objoff_3A(a3),d0
                cmp.b   objoff_37(a3),d0
                bne.s   loc_C912
                tst.b   objoff_3B(a3)
                bne.s   loc_C946

loc_C912:
                lea     D_S_Zone_Text(pc),a1
                move.w  d7,d0
                subq.w  #2,d0
                jsr     SKSaveWriteEncodedLabelTilesUntilNegativeTerminator(pc)
                move.w  objoff_36(a3),d0
                add.w   d0,d0
                moveq   #0,d1
                move.b  DataSelect_Zone_Nums(pc,d0.w),d1
                bpl.s   loc_C932
                move.w  #high_priority,d1
                bra.s   loc_C936
; ---------------------------------------------------------------------------

loc_C932:
                addi.w  #make_art_tile(ArtTile_Save_Text,1,1),d1

loc_C936:
                move.w  d1,(a6)
                moveq   #0,d1
                move.b  DataSelect_Zone_Nums+1(pc,d0.w),d1
                addi.w  #make_art_tile(ArtTile_Save_Text,1,1),d1
                move.w  d1,(a6)
                bra.s   loc_C94C
; ---------------------------------------------------------------------------

loc_C946:
                move.w  d7,d0
                jsr     SKSaveWriteEncodedLabelTilesUntilNegativeTerminator(pc)

loc_C94C:
                addi.w  #$1A,d7
                lea     next_SaveSlot(a0),a0
                lea     next_object(a3),a3
                dbf     d3,loc_C8E6
                bra.s   loc_C97A
; ---------------------------------------------------------------------------
; shows level number 1-14
; NOTE: $FF acts as zero
; byte_C95E
DataSelect_Zone_Nums:
                dc.b    $FF,   1                        ; 01
                dc.b    $FF,   2                        ; 02
                dc.b    $FF,   3                        ; 03
                dc.b    $FF,   4                        ; 04
                dc.b    $FF,   5                        ; 05
                dc.b    $FF,   6                        ; 06
                dc.b    $FF,   7                        ; 07
                dc.b    $FF,   8                        ; 08
                dc.b    $FF,   9                        ; 09
                dc.b    1,   0                          ; 10
                dc.b    1,   1                          ; 11
                dc.b    1,   2                          ; 12
                dc.b    1,   3                          ; 13
                dc.b    1,   4                          ; 14
; ---------------------------------------------------------------------------

loc_C97A:
                lea     Map_DataSelect_Player_LivesContinues(pc),a2
                lea     (Dynamic_object_RAM+object_size).w,a3
                move.w  #VRAM_Plane_A_Name_Table+$1220,d7
                lea     (Saved_data).w,a0
                moveq   #8-1,d6

loc_C98C:
                move.w  objoff_34(a3),d0
                bne.s   loc_C994
                moveq   #1,d0

loc_C994:
                tst.b   (a0)
                bpl.s   loc_C99A
                moveq   #0,d0

loc_C99A:
                lsl.w   #5,d0
                movea.l a2,a1
                adda.w  d0,a1
                move.w  d7,d0
                bsr.w   SKSaveConvertVRAMWordAddressToWriteCommand
                moveq   #3-1,d1
                moveq   #5-1,d2
                jsr     (Plane_Map_To_VRAM_2).l
                tst.b   (a0)
                bpl.s   loc_C9CC
                lea     word_DB08(pc),a1
                move.w  d7,d0
                addq.w  #6,d0
                bsr.w   SKSaveConvertVRAMWordAddressToWriteCommand
                moveq   #2-1,d1
                moveq   #5-1,d2
                jsr     (Plane_Map_To_VRAM_2).l
                bra.s   loc_CA02
; ---------------------------------------------------------------------------

loc_C9CC:
                move.b  objoff_3E(a3),d0
                jsr     SKSaveBuildTwoDigitLifeContinueMapWithBlankTens(pc)
                move.w  d7,d0
                addq.w  #6,d0
                bsr.w   SKSaveConvertVRAMWordAddressToWriteCommand
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM_2).l
                move.b  objoff_3F(a3),d0
                jsr     SKSaveBuildTwoDigitLifeContinueMapWithBlankTens(pc)
                move.w  d7,d0
                addi.w  #$306,d0
                bsr.w   SKSaveConvertVRAMWordAddressToWriteCommand
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM_2).l

loc_CA02:
                addi.w  #$1A,d7
                lea     next_SaveSlot(a0),a0
                lea     next_object(a3),a3
                dbf     d6,loc_C98C
                rts

; =============== S U B R O U T I N E =======================================

SKSaveBuildTwoDigitLifeContinueMapWithBlankTens:
                moveq   #0,d1

loc_CA16:
                addq.w  #1,d1
                subi.b  #$A,d0
                bcc.s   loc_CA16
                subq.w  #1,d1
                addi.b  #$A,d0
                lea     (_unkEEEA).w,a1
                lsl.w   #2,d1
                bne.s   loc_CA2E
                moveq   #$28,d1

loc_CA2E:
                move.w  DataSelect_LifeContinue_Nums(pc,d1.w),(a1)
                move.w  DataSelect_LifeContinue_Nums+2(pc,d1.w),4(a1)
                andi.w  #$FF,d0
                lsl.w   #2,d0
                move.w  DataSelect_LifeContinue_Nums(pc,d0.w),2(a1)
                move.w  DataSelect_LifeContinue_Nums+2(pc,d0.w),6(a1)
                rts
; End of function SKSaveBuildTwoDigitLifeContinueMapWithBlankTens

; ---------------------------------------------------------------------------
; word_CA4C
DataSelect_LifeContinue_Nums:
                dc.w    make_art_tile(ArtTile_Save_Extra+$46,1,1), make_art_tile(ArtTile_Save_Extra+$47,1,1)  ; 0
                dc.w    make_art_tile(ArtTile_Save_Extra+$48,1,1), make_art_tile(ArtTile_Save_Extra+$49,1,1)  ; 1
                dc.w    make_art_tile(ArtTile_Save_Extra+$4A,1,1), make_art_tile(ArtTile_Save_Extra+$4B,1,1)  ; 2
                dc.w    make_art_tile(ArtTile_Save_Extra+$4C,1,1), make_art_tile(ArtTile_Save_Extra+$4D,1,1)  ; 3
                dc.w    make_art_tile(ArtTile_Save_Extra+$4E,1,1), make_art_tile(ArtTile_Save_Extra+$4F,1,1)  ; 4
                dc.w    make_art_tile(ArtTile_Save_Extra+$50,1,1), make_art_tile(ArtTile_Save_Extra+$51,1,1)  ; 5
                dc.w    make_art_tile(ArtTile_Save_Extra+$52,1,1), make_art_tile(ArtTile_Save_Extra+$53,1,1)  ; 6
                dc.w    make_art_tile(ArtTile_Save_Extra+$54,1,1), make_art_tile(ArtTile_Save_Extra+$55,1,1)  ; 7
                dc.w    make_art_tile(ArtTile_Save_Extra+$56,1,1), make_art_tile(ArtTile_Save_Extra+$57,1,1)  ; 8
                dc.w    make_art_tile(ArtTile_Save_Extra+$58,1,1), make_art_tile(ArtTile_Save_Extra+$59,1,1)  ; 9
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)  ; blank

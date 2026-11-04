; Owner: game/special_stage/sk
; Responsibility: Special-stage results mode setup, display loop, palette and product-specific result loading resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SpecialStage_Results:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  (Current_special_stage).w,d0
                move.b  d0,(Current_special_stage_2).w
                move.b  (HPZ_current_special_stage).w,d1
                beq.s   loc_2DF82
                andi.b  #$7F,d1
                move.b  d1,d0
                bra.s   loc_2DF8C
; ---------------------------------------------------------------------------

loc_2DF82:
                addq.b  #1,d0
                cmpi.b  #7,d0
                blo.s   loc_2DF8C
                moveq   #0,d0

loc_2DF8C:
                move.b  d0,(Current_special_stage).w
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8B03,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9001,(a6)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame_SpecialStage).l
                clr.w   (Competition_mode).w
                clr.w   (Plane_buffer).w
                clr.w   (Special_V_int_routine).w
                clr.b   (Update_HUD_timer).w
                clr.w   (Palette_fade_timer).w
                move.w  (Current_zone_and_act).w,(Special_stage_zone_and_act).w
                lea     PLC_SpecialResultsText(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     (ArtKosM_ResultsGeneral).l,a1
                move.w  #tiles_to_bytes($5B8),d2
                jsr     (Queue_Kos_Module).l
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2E04E
                lea     (ArtKosM_SSResultsSUPERk).l,a1
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_2E06A
                lea     (ArtKosM_SSResultsHYPERk).l,a1
                bra.s   loc_2E06A
; ---------------------------------------------------------------------------

loc_2E04E:
                lea     (ArtKosM_SSResultsSUPER).l,a1
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_2E06A
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_2E06A
                lea     (ArtKosM_SSResultsHYPER).l,a1

loc_2E06A:
                move.w  #tiles_to_bytes($50F),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_ResultsSONIC).l,a1
                cmpi.w  #1,(Player_mode).w
                bls.s   loc_2E0A2
                lea     (ArtKosM_ResultsKNUCKLES).l,a1
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_2E0A2
                lea     (ArtKosM_ResultsMILES).l,a1
                tst.b   (Graphics_flags).w
                bpl.s   loc_2E0A2
                lea     (ArtKosM_ResultsTAILS).l,a1

loc_2E0A2:
                move.w  #tiles_to_bytes($4F1),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SSResults).l,a1
                move.w  #tiles_to_bytes($523),d2
                jsr     (Queue_Kos_Module).l
                move.l  #SKLevelResults_SpecialVIntReturn,(_unkEF44_1).w

loc_2E0C4:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                jsr     (Process_Nem_Queue_Init).l
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   loc_2E0C4
                tst.l   (Nem_decomp_queue).w
                bne.s   loc_2E0C4
                jsr     (HUD_DrawInitial).l
                move.b  #1,(Update_HUD_score).w
                lea     Pal_Results(pc),a0
                lea     (Normal_palette).w,a1
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette),d0

loc_2E104:
                move.l  (a0),(a1)+
                move.l  (a0)+,Target_palette-Normal_palette-4(a1)
                dbf     d0,loc_2E104
                jsr     SStageResults_AdjustCharacterPalettes(pc)
                tst.w   (SK_alone_flag).w
                bne.w   loc_2E226
                tst.b   (SK_special_stage_flag).w
                beq.w   loc_2E226
                lea     Pal_Results(pc),a0
                lea     (Normal_palette).w,a1
                moveq   #bytesToLcnt($20),d0

loc_2E12C:
                move.l  (a0)+,d1
                move.l  d1,Target_palette_line_2-Normal_palette(a1)
                move.l  d1,Normal_palette_line_2-Normal_palette(a1)
                move.l  d1,Target_palette-Normal_palette(a1)
                move.l  d1,(a1)+
                dbf     d0,loc_2E12C
                jsr     SStageResults_AdjustCharacterPalettes(pc)
                lea     (Pal_HPZIntro+$20).l,a0
                lea     (Normal_palette_line_3).w,a1
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_3),d0

loc_2E150:
                move.l  #$CCC0CCC,(a1)+
                move.l  (a0)+,Target_palette_line_3-Normal_palette_line_3-4(a1)
                dbf     d0,loc_2E150
                lea     (Layout_HPZ).l,a0
                lea     (Level_layout_header).w,a1
                move.w  #bytesToLcnt(Level_layout_main_end-Level_layout_header),d0

loc_2E16C:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_2E16C
                lea     (HPZ_128x128_Primary_Kos).l,a0
                lea     (RAM_start).l,a1
                jsr     (Kos_Decomp).l
                lea     (HPZ_128x128_Secondary_Kos).l,a0
                jsr     (Kos_Decomp).l
                lea     (HPZ_16x16_Primary_Kos).l,a0
                lea     (Block_table).w,a1
                jsr     (Kos_Decomp).l
                lea     (HPZ_16x16_Secondary_Kos).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKosM_HPZ_Primary).l,a1
                move.w  (a1),d4
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_HPZ_Secondary).l,a1
                move.w  d4,d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_48,d0
                jsr     (Load_PLC).l
                move.w  #$1701,(Current_zone_and_act).w
                move.w  #$15A0,(Camera_X_pos).w
                move.w  #$240,(Camera_Y_pos).w
                clr.b   (Object_load_routine).w
                jsr     (Load_Sprites).l
                moveq   #0,d0
                move.b  (Current_special_stage_2).w,d0
                add.w   d0,d0
                lea     word_2E398(pc),a0
                move.w  (a0,d0.w),(Camera_X_pos).w
                move    #$2700,sr
                jsr     (j_LevelSetup).l
                move    #$2300,sr
                tst.w   (Special_stage_spheres_left).w
                bne.s   loc_2E226
                move.b  (Current_special_stage_2).w,d0
                ori.b   #$80,d0
                move.b  d0,(_unkFAC0).w
                st      (_unkFAC1).w

loc_2E226:
                jsr     (Init_SpriteTable).l
                move.w  #$98,(_unkEF68).w
                st      (HPZ_special_stage_completed).w
                move.l  #Obj_SpecialStage_Results,(Dynamic_object_RAM+(object_size*29)).w
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l

loc_2E24C:
                move.b  #VInt_ID_8,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                move.w  (Emerald_flicker_flag).w,d1
                addq.w  #1,d1
                cmpi.w  #3,d1
                blo.s   loc_2E270
                moveq   #0,d1

loc_2E270:
                move.w  d1,(Emerald_flicker_flag).w
                jsr     (Process_Sprites).l
                tst.w   (SK_alone_flag).w
                bne.s   loc_2E28C
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2E28C
                jsr     (ScreenEvents).l

loc_2E28C:
                jsr     (Render_Sprites).l
                jsr     (Process_Nem_Queue_Init).l
                jsr     (Process_Kos_Module_Queue).l
                tst.w   (Palette_fade_timer).w
                beq.s   loc_2E2B0
                bmi.s   loc_2E2B0
                subq.w  #1,(Palette_fade_timer).w
                jsr     (Pal_FromWhite).l

loc_2E2B0:
                cmpi.b  #GameMode_SpecialStageResults,(Game_mode).w
                beq.s   loc_2E24C
                move.w  (Special_stage_zone_and_act).w,(Current_zone_and_act).w
                rts

; =============== S U B R O U T I N E =======================================

SStageResults_AdjustCharacterPalettes:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2E2F6
                lea     (Normal_palette+$4).w,a0
                move.l  #$84E040C,d0
                move.l  d0,Target_palette-Normal_palette(a0)
                move.l  d0,(a0)+
                move.l  #$2060080,d0
                tst.w   (SK_alone_flag).w
                bne.s   loc_2E2EE
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2E2EE
                move.w  #$EE,d0

loc_2E2EE:
                move.l  d0,Target_palette-Normal_palette(a0)
                move.l  d0,(a0)
                bra.s   locret_2E30E
; ---------------------------------------------------------------------------

loc_2E2F6:
                tst.w   (SK_alone_flag).w
                bne.s   locret_2E30E
                tst.b   (SK_special_stage_flag).w
                beq.s   locret_2E30E
                move.w  #$EE,(Normal_palette_line_2+$A).w
                move.w  #$EE,(Target_palette_line_2+$A).w

locret_2E30E:
                rts
; End of function SStageResults_AdjustCharacterPalettes

; ---------------------------------------------------------------------------
PLC_SpecialResultsText: plrlistheader
                plreq   ArtTile_Ring, ArtNem_RingHUDText
PLC_SpecialResultsText_End:

Pal_Results:
                binclude "data/General/Special Stage/Palettes/Results.bin"
                even

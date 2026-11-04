; Owner: game/special_stage/s3
; Responsibility: Special-stage results mode setup, display loop, palette and product-specific result loading resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SpecialStage_Results:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9011,(a6)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                jsr     (SaveGame_SpecialStage).l
                clr.w   (Competition_mode).w
                clr.w   (Plane_buffer).w
                clr.w   (Special_V_int_routine).w
                clr.b   (Update_HUD_timer).w
                moveq   #PLCID_00,d0
                jsr     (Load_PLC_2).l
                lea     (ArtKosM_ResultsGeneral).l,a1
                move.w  #tiles_to_bytes($520),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_ResultsSONIC).l,a1
                cmpi.w  #1,(Player_mode).w
                bls.s   loc_2D2DE
                lea     (ArtKosM_ResultsKNUCKLES).l,a1
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_2D2DE
                lea     (ArtKosM_ResultsMILES).l,a1
                tst.b   (Graphics_flags).w
                bpl.s   loc_2D2DE
                lea     (ArtKosM_ResultsTAILS).l,a1

loc_2D2DE:
                move.w  #tiles_to_bytes($580),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SSResults).l,a1
                move.w  #tiles_to_bytes($001),d2
                jsr     (Queue_Kos_Module).l
                move.l  #S3LevelResults_SpecialVIntReturn,(_unkEF44_1).w

loc_2D300:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                jsr     (Process_Nem_Queue_Init).l
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   loc_2D300
                tst.l   (Nem_decomp_queue).w
                bne.s   loc_2D300
                jsr     (HUD_DrawInitial).l
                move.b  #1,(Update_HUD_score).w
                lea     Pal_Results(pc),a0
                lea     (Normal_palette).w,a1
                moveq   #bytesToLcnt($80),d0

loc_2D340:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_2D340
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2D35C
                move.l  #$84E040C,(Normal_palette+4).w
                move.w  #$206,(Normal_palette+8).w

loc_2D35C:
                jsr     (Init_SpriteTable).l
                move.l  #Obj_SpecialStage_Results,(Dynamic_object_RAM+object_size).w
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l

loc_2D378:
                move.b  #VInt_ID_8,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                cmpi.b  #GameMode_SpecialStageResults,(Game_mode).w
                beq.s   loc_2D378
                rts
; ---------------------------------------------------------------------------
Pal_Results:
                binclude "data/General/Special Stage/Palettes/Results S3.bin"
                even

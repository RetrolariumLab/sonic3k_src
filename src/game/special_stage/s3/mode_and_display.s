; Owner: game/special_stage/s3
; Responsibility: Special stage entry, layout preparation, active mode loop and palette/map display updates
; Source provenance and ranges: config/reconstruction/source_layout.json
SpecialStage:
                moveq   #signextendB(cmd_Stop),d0
                bsr.w   Play_Music
                bsr.w   Clear_Nem_Queue
                bsr.w   Pal_FadeToWhite
                move    #$2700,sr
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$9001,(a6)
                move.w  #$9200,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8720,(a6)
                clr.b   (Water_full_screen_flag).w
                move.w  #$8C81,(a6)
                bsr.w   Clear_DisplayData
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clearRAM Stat_table,(Pos_table-Stat_table)
                jsr     (Init_SpriteTable).l
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                lea     (Pal_SStage_Main).l,a1
                lea     (Target_palette).w,a2
                move.w  #bytesToWcnt(Target_palette_end-Target_palette),d0

S3SS_CopyTargetPaletteAndPrepStage:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SS_CopyTargetPaletteAndPrepStage
                move.l  #vdpComm(tiles_to_bytes($000),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageLayout).l,a0
                bsr.w   Nem_Decomp
                lea     (MapUnc_SStageLayout).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Sphere),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageSphere).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Ring),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageRing).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_BG),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageBG).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_GetBlueSpheres),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_GetBlueSpheres).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_GetBlueSpheres+$199),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_GBSArrow).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Digits),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageDigits).l,a0
                bsr.w   Nem_Decomp
                lea     (ArtNem_SStageDigits).l,a0
                lea     (H_scroll_buffer+$20).w,a4
                bsr.w   Nem_Decomp_To_RAM
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Icons),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageIcons).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_SStage_Shadow),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_SStageShadow).l,a0
                bsr.w   Nem_Decomp
                lea     (MapUnc_SSNum000).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$084,VRAM,WRITE),d0
                moveq   #8-1,d1
                moveq   #3-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (MapUnc_SSNum000).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$0BC,VRAM,WRITE),d0
                moveq   #8-1,d1
                moveq   #3-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (RAM_start).l,a1
                lea     (MapEni_SStageBG).l,a0
                move.w  #make_art_tile(ArtTile_SStage_BG,2,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #64-1,d1
                moveq   #32-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (SStageLayoutPtrs).l,a2
                tst.b   (Debug_cheat_flag).w
                beq.s   S3SS_ChooseStageOrBypassSearch
                move.w  (Sound_test_sound).w,d0
                btst    #button_A,(Ctrl_1_held).w
                bne.s   S3SS_MaskStageIndexAndPrepCopy

S3SS_ChooseStageOrBypassSearch:
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                cmpi.w  #7,(Chaos_emerald_count).w
                bcc.s   S3SS_MaskStageIndexAndPrepCopy
                lea     (Collected_emeralds_array).w,a1

S3SS_FindUncollectedStage:
                tst.b   (a1,d0.w)
                beq.s   S3SS_MaskStageIndexAndPrepCopy
                addq.w  #1,d0
                cmpi.w  #7,d0
                bcs.s   S3SS_FindUncollectedStage
                moveq   #0,d0
                bra.s   S3SS_FindUncollectedStage
; ---------------------------------------------------------------------------

S3SS_MaskStageIndexAndPrepCopy:
                andi.w  #7,d0
                move.b  d0,(Current_special_stage).w
                move.w  d0,d1
                lsl.w   #2,d0
                movea.l (a2,d0.w),a2
                lea     (Level_layout_header).w,a3
                move.w  #bytesToLcnt($400),d0

S3SS_CopyLayoutAndSeedActors:
                move.l  (a2)+,(a3)+
                dbf     d0,S3SS_CopyLayoutAndSeedActors
                move.w  (a2)+,(Special_stage_angle).w
                move.w  (a2)+,(Special_stage_X_pos).w
                move.w  (a2)+,(Special_stage_Y_pos).w
                move.w  (a2)+,(Special_stage_rings_left).w
                lsl.w   #4,d1
                lea     (SS_Pal_Map_Ptrs).l,a1
                lea     (Target_palette).w,a2
                movea.l 4(a1,d1.w),a1
                move.l  a1,(Special_stage_palette_addr).w
                move.l  (a1)+,$70(a2)
                move.l  (a1)+,$74(a2)
                move.l  (a1)+,$78(a2)
                move.l  (a1)+,$7C(a2)
                move.l  $10(a1),$50(a2)
                move.w  $14(a1),$54(a2)
                bsr.w   SStage_CountInitialBlueSpheres
                bsr.w   Load_SSSprite_Mappings
                clr.b   (Level_started_flag).w
                move.b  #$FF,(Special_stage_sphere_HUD_flag).w
                move.b  #$80,(Special_stage_extra_life_flags).w
                move.w  #$1000,(Special_stage_rate).w
                move.w  #30*60,(Special_stage_rate_timer).w
                move.w  #0,(Camera_X_pos_copy).w
                move.w  #0,(Camera_Y_pos_copy).w
                move.w  #-1,(Screen_Y_wrap_value).w
                move.l  #SStagePlayer_InitializePrimaryCharacter,(Player_1).w
                move.l  #S3SS_InitPrimaryShadowPosition,(Dynamic_object_RAM+object_size).w
                tst.w   (Player_option).w
                bne.s   S3SS_InitInstructionsAndDisplay
                move.l  #SStageTails_InitializeFollower,(Player_2).w
                move.l  #S3SS_InitFollowerShadowPosition,(Dynamic_object_RAM+(object_size*2)).w

S3SS_InitInstructionsAndDisplay:
                move.l  #SStageIcons_Initialize,(Reserved_object_3).w
                move.l  #SStageCue_InitializePair,(Dynamic_object_RAM).w
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   SStage_UpdateBackgroundScroll
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #VInt_ID_1C,(V_int_routine).w
                bsr.w   Wait_VSync
                move.b  #0,(Special_stage_fade_timer).w
                move.w  #$8C89,(VDP_control_port).l
                moveq   #signextendB(mus_SpecialStage),d0
                bsr.w   Play_Music
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromWhite

S3SS_RunActiveStageUntilModeChanges:
                bsr.w   Pause_Game
                move.b  #VInt_ID_1C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   SStage_UpdateBackgroundScroll
                bsr.w   SStage_UpdateClearSequence
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_SpecialStage3,(Game_mode).w
                beq.s   S3SS_RunActiveStageUntilModeChanges
                tst.w   (Demo_mode_flag).w
                beq.s   S3SS_Start60VBlankOutro
                move.b  #GameMode_SegaScreen,(Game_mode).w

S3SS_Start60VBlankOutro:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

S3SS_SimulateOutroAndFadeWhite:
                move.b  #VInt_ID_1C,(V_int_routine).w
                bsr.w   Wait_VSync
                jsr     (Process_Sprites).l
                bsr.w   Animate_SSRings
                bsr.w   Touch_SSSprites
                jsr     (Render_Sprites).l
                jsr     Draw_SSSprites(pc)
                bsr.w   SStage_UpdateBackgroundScroll
                bsr.w   SStage_UpdateClearSequence
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   S3SS_FinishOutroAndAdvanceStage
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToWhite

S3SS_FinishOutroAndAdvanceStage:
                tst.w   (Demo_timer).w
                bne.s   S3SS_SimulateOutroAndFadeWhite
                addq.b  #1,(Current_special_stage).w
                cmpi.b  #7,(Current_special_stage).w
                bcs.s   S3SStage_ReturnAfterSpecialStageOutro
                move.b  #0,(Current_special_stage).w

S3SStage_ReturnAfterSpecialStageOutro:
                rts

; =============== S U B R O U T I N E =======================================

Rotate_SSPal:
                tst.b   (Special_stage_fade_timer).w
                bne.s   S3SS_PaletteRotationReturn
                lea     (SS_Pal_Map_Ptrs).l,a1
                move.w  (Special_stage_anim_frame).w,d0
                cmpi.w  #$10,d0
                blo.s   S3SS_SelectPalettePhaseWindow
                tst.b   (Special_stage_turning).w
                bpl.s   S3SS_PaletteRotationReturn
                move.b  (Special_stage_palette_frame).w,d0
                andi.w  #$F,d0

S3SS_SelectPalettePhaseWindow:
                andi.w  #$E,d0
                neg.w   d0
                addi.w  #$10,d0
                movea.l (Special_stage_palette_addr).w,a1
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_4+$10).w,a2
                move.w  #bytesToWcnt($10),d0

S3SS_CopyRotatingPaletteSlice:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SS_CopyRotatingPaletteSlice

S3SS_PaletteRotationReturn:
                rts
; End of function Rotate_SSPal

; =============== S U B R O U T I N E =======================================

Update_SSMap:
                lea     (VDP_data_port).l,a6
                lea     (SS_Pal_Map_Ptrs).l,a1
                move.w  (Special_stage_anim_frame).w,d0
                cmp.b   (Special_stage_prev_anim_frame).w,d0
                beq.s   S3SS_ConsumeSphereHUDDirtyFlag
                move.b  d0,(Special_stage_prev_anim_frame).w
                lsl.w   #3,d0
                movea.l (a1,d0.w),a3
                lea     $10E(a3),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$19E,VRAM,WRITE),(VDP_control_port).l  ; VRAM write $C19E
                moveq   #$A-1,d1

S3SS_WriteGlobeSeam:
                move.w  (a1)+,(a6)
                dbf     d1,S3SS_WriteGlobeSeam
                lea     $140(a3),a3
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$200,VRAM,WRITE),d0  ; VRAM write $C200
                moveq   #$28-1,d1
                moveq   #$18-1,d2
                move.l  #$80<<16,d4

S3SS_SelectNextGlobeRow:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  d1,d3

S3SS_WriteGlobeRowAndAdvance:
                move.w  (a3)+,(a6)
                dbf     d3,S3SS_WriteGlobeRowAndAdvance
                add.l   d4,d0
                dbf     d2,S3SS_SelectNextGlobeRow

S3SS_ConsumeSphereHUDDirtyFlag:
                tst.b   (Special_stage_sphere_HUD_flag).w
                beq.s   S3SS_ConsumeRingHUDDirtyBit
                move.b  #0,(Special_stage_sphere_HUD_flag).w
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$086,VRAM,WRITE),d0  ; VRAM write $C086
                move.w  (Special_stage_spheres_left).w,d1
                bsr.w   Draw_SSNum

S3SS_ConsumeRingHUDDirtyBit:
                tst.b   (Special_stage_extra_life_flags).w
                bpl.s   S3SS_DisplayUpdateReturn
                bclr    #7,(Special_stage_extra_life_flags).w
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$0BE,VRAM,WRITE),d0  ; VRAM write $C0BE
                move.w  (Special_stage_ring_count).w,d1
                bsr.w   Draw_SSNum

S3SS_DisplayUpdateReturn:
                rts
; End of function Update_SSMap

; Owner: game/level/s3
; Responsibility: Level initialization, gameplay loop and product-specific attract/demo mode transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
Level:
                bset    #7,(Game_mode).w                ; Set bit 7 of F600 is indicate that we're loading the level
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.s   loc_46C2                        ; If so, branch (Sonic 1 leftover)
                moveq   #signextendB(cmd_FadeOut),d0    ; If a demo
                bsr.w   Play_SFX

loc_46C2:
                clr.w   (Kos_decomp_queue_count).w
                clearRAM Kos_decomp_stored_registers,(Kos_decomp_module_end-Kos_decomp_stored_registers)  ; Clear the KosM bytes
                bsr.w   Clear_Nem_Queue                 ; Clear PLCs
                bsr.w   Pal_FadeToBlack
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.w   loc_479A                        ; If so, branch (Sonic 1 leftover)
                move    #$2700,sr
                bsr.w   Clear_DisplayData               ; Clear the screen
                move    #$2300,sr
                moveq   #0,d0
                move.w  d0,(Level_frame_counter).w
                tst.b   (Last_star_post_hit).w
                beq.s   loc_471E                        ; If no starpost was set, branch
                tst.b   (Special_bonus_entry_flag).w
                bne.s   loc_4712                        ; Otherwise, ensure that the proper level ID is set to account for levels that use multiple ones in an act
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                bra.s   loc_471E
; ---------------------------------------------------------------------------

loc_4712:
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w

loc_471E:
                move.w  (Current_zone_and_act).w,d0

; Useless code. Player_mode has not been set yet, and level $D00 has the same PLCs as level 0
                bne.s   loc_4736
                cmpi.w  #2,(Player_mode).w              ; If level is Angel Island 1
                beq.s   loc_4732
                tst.b   (Last_star_post_hit).w          ; If character is Sonic
                beq.s   loc_4736                        ; And no starpost is set

loc_4732:
                move.w  #$D00,d0                        ; Set the level ID to skip the intro

loc_4736:
                ror.b   #1,d0
                lsr.w   #4,d0
                andi.w  #$1F8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d0,d1
                lea     (LevelLoadBlock).l,a2
                moveq   #0,d0
                move.b  (a2,d1.w),d0                    ; Get the first PLC number for the level
                beq.s   loc_4756
                bsr.w   Load_PLC

loc_4756:
                bsr.w   LevelLoad_ActiveCharacter
                tst.b   (Last_star_post_hit).w
                bne.w   loc_4782
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_4782
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_4782
                moveq   #PLCID_01,d0                    ; If in AIZ intro
                jsr     (Load_PLC_2).l
                moveq   #PLCID_0A,d0
                bsr.w   Load_PLC                        ; Load the AIZ Intro graphics
                bra.s   loc_479A
; ---------------------------------------------------------------------------

loc_4782:
                moveq   #PLCID_06,d0
                tst.w   (Competition_mode).w
                bne.s   loc_4796
                moveq   #PLCID_01,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_4796
                moveq   #PLCID_07,d0

loc_4796:
                bsr.w   Load_PLC

loc_479A:
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clearRAM Lag_frame_count,(Nem_decomp_queue-Lag_frame_count)
                clearRAM Tails_CPU_interact,(Sprite_table-Tails_CPU_interact)
                clearRAM Oscillating_table,(AIZ_vine_angle-Oscillating_table)
                clearRAM _unkFA80,(DMA_queue-_unkFA80)
                jsr     (Init_SpriteTable).l
                lea     (VDP_control_port).l,a6
                move.w  #$8B03,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$857C,(a6)
                move.w  #$9001,(a6)
                move.w  #$8004,(a6)
                move.w  #$9200,(a6)
                move.w  #$8720,(a6)
                move.w  #$8C81,(a6)
                tst.b   (Debug_cheat_flag).w
                beq.s   loc_484A
                btst    #button_C,(Ctrl_1_held).w
                beq.s   loc_483C
                move.w  #$8C89,(a6)

loc_483C:
                btst    #button_A,(Ctrl_1_held).w
                beq.s   loc_484A
                move.b  #1,(Debug_mode_flag).w

loc_484A:
                move.w  #$8AFF,(H_int_counter_command).w
                tst.w   (Competition_mode).w
                beq.s   loc_4886
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt,(H_int_addr).w
                move.w  #$8014,(a6)
                move.w  #$8220,(a6)
                move.w  #$8405,(a6)
                move.w  #$8A6B,(H_int_counter_command).w
                move.w  #$9003,(a6)
                cmpi.b  #$F,(Current_zone).w
                bne.s   loc_4886
                move.w  #$9011,(a6)

loc_4886:
                move.w  (H_int_counter_command).w,(a6)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                moveq   #PalID_SonicTails,d0
                bsr.w   LoadPalette_Immediate
                bsr.w   CheckLevelForWater
                clearRAM Water_palette_line_2,(Water_palette_end-Water_palette_line_2)
                tst.b   (Water_flag).w
                beq.s   loc_48BA
                move.w  #$8014,(a6)

loc_48BA:
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.w   loc_4942                        ; If so, branch (Sonic 1 leftover)
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #7,d0
                lea     (LevelMusic_Playlist).l,a1
                move.b  (a1,d0.w),d0
                move.w  d0,(Current_music).w
                bsr.w   Play_Music
                tst.w   (Current_zone_and_act).w
                bne.s   loc_48F2
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_48F2
                tst.b   (Last_star_post_hit).w
                beq.s   loc_4934

loc_48F2:
                cmpi.b  #$15,(Current_zone).w
                bhi.s   loc_4934
                move.l  #Obj_TitleCard,(Dynamic_object_RAM+(object_size*5)).w

loc_4902:
                move.b  #VInt_ID_C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.w   (Dynamic_object_RAM+(object_size*5)+objoff_48).w
                bne.s   loc_4902
                tst.l   (Nem_decomp_queue).w
                bne.s   loc_4902

loc_4934:
                move    #$2700,sr
                jsr     (HUD_DrawInitial).l
                move    #$2300,sr

loc_4942:
                moveq   #PalID_SonicTails,d0
                bsr.w   LoadPalette
                jsr     (Get_LevelSizeStart).l
                jsr     (DeformBgLayer).l
                bsr.w   LoadLevelLoadBlock
                jsr     (LoadLevelLoadBlock2).l
                move    #$2700,sr
                jsr     (j_LevelSetup).l
                move    #$2300,sr
                jsr     (Animate_Init).l
                jsr     (ConvertCollisionArray).l
                bsr.w   LoadSolids
                bsr.w   Handle_Onscreen_Water_Height
                move.w  (Ctrl_2).w,(_unkFF7C).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.w  #0,(Ctrl_1).w
                move.w  #0,(Ctrl_2).w
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.b  #0,(Level_started_flag).w
                tst.b   (Water_flag).w
                beq.s   loc_49DC
                cmpi.b  #1,(Current_zone).w             ; Is current zone Hydrocity?
                beq.s   loc_49C6                        ; If so, branch
                cmpi.b  #1,(Current_zone).w             ; Is current zone Hydrocity?
                bne.s   loc_49DC                        ; If not, branch

loc_49C6:
                move.l  #Obj_HCZWaveSplash,(Wave_Splash).w
                move.l  #Obj_HCZWaterSplash,(Dynamic_object_RAM+(object_size*2)).w
                move.b  #1,(Dynamic_object_RAM+(object_size*2)+subtype).w

loc_49DC:
                moveq   #0,d0
                tst.b   (Last_star_post_hit).w
                bne.s   loc_4A0C
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.b  d0,(Extra_life_flags).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.b  d0,(Saved2_status_secondary).w
                move.b  d0,(Saved_status_secondary).w
                cmpi.b  #$13,(Current_zone).w
                bhs.s   loc_4A0C
                move.b  d0,(Respawn_table_keep).w

loc_4A0C:
                move.b  d0,(Time_over_flag).w
                move.w  d0,(Debug_placement_mode).w
                move.w  d0,(Restart_level_flag).w
                move.b  d0,(Teleport_active_timer).w
                move.b  d0,(Teleport_active_flag).w
                move.w  d0,(Total_ring_count).w
                move.w  d0,(Total_ring_count_P2).w
                move.w  d0,(Monitors_broken).w
                move.w  d0,(Monitors_broken_P2).w
                move.w  d0,(Loser_time_left).w
                move.b  d0,(LRZ_rocks_routine).w
                bsr.w   OscillateNumInit
                move.b  #1,(Update_HUD_score).w
                move.b  #1,(Update_HUD_ring_count).w
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Level_started_flag).w
                bsr.w   SpawnLevelMainSprites
                jsr     (Load_Sprites).l
                jsr     (Load_Rings).l
                jsr     (S2_SpecialCNZBumpers).l
                jsr     (Draw_LRZ_Special_Rock_Sprites).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Animate_Tiles).l
                move.w  #1800,(Demo_timer).w
                tst.w   (Demo_mode_flag).w
                bpl.s   loc_4AA2
                move.w  #540,(Demo_timer).w
                cmpi.w  #4,(Ending_demo_number).w
                bne.s   loc_4AA2
                move.w  #510,(Demo_timer).w

loc_4AA2:
                bsr.w   LoadWaterPalette
                clearRAM Water_palette_line_2,(Water_palette_end-Water_palette_line_2)
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jsr     GetDemoPtr(pc)
                tst.w   (Competition_mode).w
                bne.w   loc_4C1C
                tst.w   (Current_zone_and_act).w
                bne.s   loc_4ADA
                tst.b   (Last_star_post_hit).w
                beq.s   loc_4AE8

loc_4ADA:
                cmpi.b  #$E,(Current_zone).w
                bhs.s   loc_4AE8
                jsr     (PLCLoad_AnimalsAndExplosion).l

loc_4AE8:
                move.w  #$2030-1,(Palette_fade_info).w
                jsr     (Pal_FillBlack).l
                move.w  #$16,(Palette_fade_timer).w
                move.w  #$16,(Dynamic_object_RAM+(object_size*5)+objoff_2E).w
                andi.b  #$7F,(Last_star_post_hit).w
                bclr    #7,(Game_mode).w

LevelLoop:
                bsr.w   Pause_Game
                move.b  #VInt_ID_8,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                addq.w  #1,(Level_frame_counter).w
                bsr.w   Demo_PlayRecord
                jsr     (Animate_Palette).l
                jsr     (SpecialEvents).l
                jsr     (Process_Sprites).l
                tst.w   (Restart_level_flag).w
                bne.w   Level
                jsr     (DeformBgLayer).l
                jsr     (ScreenEvents).l
                bsr.w   Handle_Onscreen_Water_Height
                bsr.w   UpdateWaterSurface
                jsr     (Load_Rings).l
                jsr     (Animate_Tiles).l
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                bsr.w   OscillateNumDo
                bsr.w   ChangeRingFrame
                jsr     (Render_Sprites).l
                jsr     (Load_Sprites).l
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.s   DemoMode
                cmpi.b  #GameMode_Level,(Game_mode).w
                beq.w   LevelLoop
                rts
; ---------------------------------------------------------------------------

DemoMode:
                tst.w   (Restart_level_flag).w
                bne.s   loc_4BB2
                tst.w   (Demo_timer).w
                beq.s   loc_4BB2
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.w   LevelLoop
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_4BB2:
                cmpi.b  #GameMode_Demo,(Game_mode).w
                bne.s   loc_4BC2
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_4BC2:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

loc_4BD2:
                move.b  #VInt_ID_8,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.w   Demo_PlayRecord
                jsr     (Process_Sprites).l
                jsr     (DeformBgLayer).l
                jsr     (ScreenEvents).l
                jsr     (Render_Sprites).l
                jsr     (Load_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   loc_4C14
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToBlack

loc_4C14:
                tst.w   (Demo_timer).w
                bne.s   loc_4BD2
                rts
; ---------------------------------------------------------------------------

loc_4C1C:
                move.w  #0,(_unkFF7E).w
                tst.b   (Debug_cheat_flag).w
                beq.s   loc_4C3C
                move.b  (_unkFF7C).w,d0
                cmpi.b  #$A0,d0
                bne.s   loc_4C3C
                move.w  (Sound_test_sound).w,d0
                lsl.w   #8,d0
                move.w  d0,(_unkFF7E).w

loc_4C3C:
                move.w  #$40-1,(Palette_fade_info).w
                jsr     (Pal_FillBlack).l
                move.w  #$16,(Palette_fade_timer).w
                move.w  #0,(_unkFF7C).w
                bclr    #7,(Game_mode).w

loc_4C5A:
                bsr.w   Pause_Game
                move.b  #VInt_ID_8,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                addq.w  #1,(Level_frame_counter).w
                move.w  #4,-(sp)
                bra.s   loc_4CBC
; ---------------------------------------------------------------------------

loc_4C78:
                move.w  (_unkFF7E).w,d0
                add.w   d0,(_unkFF7C).w
                bcc.s   loc_4CCC
                bsr.w   Pause_Game
                move.w  #$100,(Z80_bus_request).l       ; stop the Z80
                bsr.w   Poll_Controllers
                startZ80
                move.w  #0,(DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                lea     (Sprite_table_input).w,a5

loc_4CAC:
                move.w  #0,(a5)
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.s   loc_4CAC

loc_4CBC:
                bsr.w   Demo_PlayRecord
                jsr     (Process_Sprites).l
                jsr     (DeformBgLayer).l

loc_4CCC:
                subq.w  #1,(sp)
                bne.s   loc_4C78
                addq.w  #2,sp
                tst.w   (Restart_level_flag).w
                bne.w   Level
                jsr     (ScreenEvents).l
                jsr     (Animate_Tiles).l
                jsr     (Render_Sprites).l
                jsr     (Animate_Palette).l
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.s   loc_4D10
                cmpi.b  #GameMode_Level,(Game_mode).w
                beq.w   loc_4C5A
                rts
; ---------------------------------------------------------------------------

loc_4D10:
                tst.w   (Restart_level_flag).w
                bne.s   loc_4D2E
                tst.w   (Demo_timer).w
                beq.s   loc_4D2E
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.w   loc_4C5A
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_4D2E:
                cmpi.b  #GameMode_Demo,(Game_mode).w
                bne.s   loc_4D3E
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_4D3E:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

loc_4D4E:
                move.b  #VInt_ID_8,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.w   Demo_PlayRecord
                jsr     (Process_Sprites).l
                jsr     (DeformBgLayer).l
                jsr     (ScreenEvents).l
                jsr     (Render_Sprites).l
                jsr     (Load_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   loc_4D90
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToBlack

loc_4D90:
                tst.w   (Demo_timer).w
                bne.s   loc_4D4E
                rts

; Owner: game/level/sk
; Responsibility: Level initialization, gameplay loop and product-specific attract/demo mode transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
Level:
                bset    #7,(Game_mode).w                ; Set bit 7 of F600 is indicate that we're loading the level
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.s   SKLevel_ResetDecodersAndPickFade  ; If so, branch (Sonic 1 leftover)
                moveq   #signextendB(cmd_FadeOut),d0    ; If a demo
                bsr.w   Play_SFX

SKLevel_ResetDecodersAndPickFade:
                clr.w   (Ending_running_flag).w
                clr.w   (Kos_decomp_queue_count).w
                clearRAM Kos_decomp_stored_registers,(Kos_decomp_module_end-Kos_decomp_stored_registers)  ; Clear the KosM bytes
                bsr.w   Clear_Nem_Queue                 ; Clear PLCs
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.s   SKLevel_FadePreviousLevelToWhite
                tst.b   (Respawn_table_keep).w
                beq.s   SKLevel_FadePreviousLevelToBlack
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKLevel_FadePreviousLevelToWhite

SKLevel_FadePreviousLevelToBlack:
                bsr.w   Pal_FadeToBlack                 ; If any normal level
                bra.s   SKLevel_ResetDisplayAndStarPosts
; ---------------------------------------------------------------------------

SKLevel_FadePreviousLevelToWhite:
                bsr.w   Pal_FadeToWhite                 ; If level being loaded is the special stage arena or an ending

SKLevel_ResetDisplayAndStarPosts:
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.w   SKLevel_ClearLevelRAMAndInitializeVideo  ; If so, branch (Sonic 1 leftover)
                move    #$2700,sr
                bsr.w   Clear_DisplayData               ; Clear the screen
                move    #$2300,sr
                moveq   #0,d0
                move.w  d0,(Level_frame_counter).w
                tst.b   (Last_star_post_hit).w
                beq.s   SKLevel_ChooseInitialResourceLookupID  ; If no starpost was set, branch
                tst.b   (Special_bonus_entry_flag).w
                bne.s   SKLevel_RestoreBonusReturnZoneIDs  ; Otherwise, ensure that the proper level ID is set to account for levels that use multiple ones in an act
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                bra.s   SKLevel_ChooseInitialResourceLookupID
; ---------------------------------------------------------------------------

SKLevel_RestoreBonusReturnZoneIDs:
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w

SKLevel_ChooseInitialResourceLookupID:
                move.w  (Current_zone_and_act).w,d0

; Useless code. Player_mode has not been set yet, and level $D00 has the same PLCs as level 0
                bne.s   SKLevel_SkipFBZ2InitialPLCAtExactPostSix
                cmpi.w  #2,(Player_mode).w              ; If level is Angel Island 1
                bhs.s   SKLevel_UseAIZPostIntroInitialLookup
                tst.b   (Last_star_post_hit).w          ; If character is Sonic
                beq.s   SKLevel_SkipFBZ2InitialPLCAtExactPostSix  ; And no lamppost is set

SKLevel_UseAIZPostIntroInitialLookup:
                move.w  #$D00,d0                        ; Set the level ID to skip the intro

SKLevel_SkipFBZ2InitialPLCAtExactPostSix:
                cmpi.w  #$401,(Current_zone_and_act).w  ; If level is Flying Battery 2
                bne.s   SKLevel_LoadInitialDescriptorPLC
                cmpi.b  #6,(Last_star_post_hit).w       ; ...and lamppost is 6 or above (the one before the rising floor at the end)
                beq.s   SKLevel_LoadCharacterAndChooseIntroArt  ; ...don't bother loading level PLCs

SKLevel_LoadInitialDescriptorPLC:
                ror.b   #1,d0
                lsr.w   #4,d0
                andi.w  #$1F8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d0,d1
                lea     (LevelLoadBlock).l,a2
                moveq   #0,d0
                move.b  (a2,d1.w),d0                    ; Get the first PLC number for the level
                beq.s   SKLevel_LoadCharacterAndChooseIntroArt
                bsr.w   Load_PLC

SKLevel_LoadCharacterAndChooseIntroArt:
                bsr.w   LevelLoad_ActiveCharacter
                tst.b   (Last_star_post_hit).w
                bne.w   SKLevel_ChooseRegularCharacterPLC
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   SKLevel_ChooseRegularCharacterPLC
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKLevel_ChooseRegularCharacterPLC
                moveq   #PLCID_01,d0                    ; If in AIZ intro
                jsr     (Load_PLC_2).l
                moveq   #PLCID_0A,d0
                bsr.w   Load_PLC                        ; Load the AIZ Intro graphics
                bra.s   SKLevel_ClearLevelRAMAndInitializeVideo
; ---------------------------------------------------------------------------

SKLevel_ChooseRegularCharacterPLC:
                moveq   #PLCID_06,d0
                tst.w   (Competition_mode).w
                bne.s   SKLevel_SubmitChosenCharacterPLC
                moveq   #PLCID_05,d0
                cmpi.w  #3,(Player_mode).w
                beq.s   SKLevel_SubmitChosenCharacterPLC
                moveq   #PLCID_01,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   SKLevel_SubmitChosenCharacterPLC
                moveq   #PLCID_07,d0
                tst.b   (Graphics_flags).w
                bmi.s   SKLevel_SubmitChosenCharacterPLC
                moveq   #PLCID_52,d0

SKLevel_SubmitChosenCharacterPLC:
                bsr.w   Load_PLC

SKLevel_ClearLevelRAMAndInitializeVideo:
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
                beq.s   SKLevel_ConfigureCompHInt
                btst    #button_A,(Ctrl_1).w
                beq.s   SKLevel_ConfigureCompHInt
                move.b  #1,(Debug_mode_flag).w

SKLevel_ConfigureCompHInt:
                move.w  #$8AFF,(H_int_counter_command).w
                tst.w   (Competition_mode).w
                beq.s   SKLevel_ResetDmaAndPickPalette
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt,(H_int_addr).w
                move.w  #$8014,(a6)
                move.w  #$8220,(a6)
                move.w  #$8405,(a6)
                move.w  #$8A6B,(H_int_counter_command).w
                move.w  #$9003,(a6)
                cmpi.b  #$F,(Current_zone).w
                bne.s   SKLevel_ResetDmaAndPickPalette
                move.w  #$9011,(a6)

SKLevel_ResetDmaAndPickPalette:
                move.w  (H_int_counter_command).w,(a6)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                moveq   #PalID_SonicTails,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_LoadPaletteAndCheckWater
                moveq   #PalID_Knuckles,d0

SKLevel_LoadPaletteAndCheckWater:
                bsr.w   LoadPalette_Immediate
                bsr.w   CheckLevelForWater
                clearRAM Water_palette_line_2,(Water_palette_end-Water_palette_line_2)
                tst.b   (Water_flag).w
                beq.s   SKLevel_PickMusicAndAIZOverride
                move.w  #$8014,(a6)

SKLevel_PickMusicAndAIZOverride:
                tst.w   (Demo_mode_flag).w              ; Are we on an ending demo? (Sonic 1 leftover)
                bmi.w   SKLevel_InitGeometryAndResources  ; If so, branch (Sonic 1 leftover)
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #7,d0
                lea     (LevelMusic_Playlist).l,a1
                move.b  (a1,d0.w),d0
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   SKLevel_TryKnuxMHZIntroMusic
                cmpi.b  #3,(Last_star_post_hit).w
                bne.s   SKLevel_TryKnuxMHZIntroMusic
                moveq   #signextendB(mus_AIZ1),d0

SKLevel_TryKnuxMHZIntroMusic:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKLevel_PlayMusicAndCheckTitle
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_PlayMusicAndCheckTitle
                tst.w   (SK_alone_flag).w
                beq.s   SKLevel_PlayMusicAndCheckTitle
                tst.b   (Last_star_post_hit).w
                bne.s   SKLevel_PlayMusicAndCheckTitle
                moveq   #signextendB(mus_Knuckles),d0

SKLevel_PlayMusicAndCheckTitle:
                move.w  d0,(Current_music).w
                bsr.w   Play_Music
                tst.w   (Current_zone_and_act).w
                bne.s   SKLevel_TryLoadKnuxIntroAnimals
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKLevel_TryCreateTitleCard
                tst.b   (Last_star_post_hit).w
                beq.w   SKLevel_ClearActThreeAndUploadInitialHUD
                bra.s   SKLevel_TryCreateTitleCard
; ---------------------------------------------------------------------------

SKLevel_TryLoadKnuxIntroAnimals:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKLevel_TryCreateTitleCard
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_TryCreateTitleCard
                tst.w   (SK_alone_flag).w
                beq.s   SKLevel_TryCreateTitleCard
                tst.b   (Last_star_post_hit).w
                bne.s   SKLevel_TryCreateTitleCard
                move    #$2700,sr
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Animals1),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_Squirrel).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Animals2),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_Chicken).l,a0
                jsr     (Nem_Decomp).l
                bra.s   SKLevel_ClearActThreeAndUploadInitialHUD
; ---------------------------------------------------------------------------

SKLevel_TryCreateTitleCard:
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKLevel_ClearActThreeAndUploadInitialHUD
                tst.b   (Act3_flag).w
                bne.s   SKLevel_ClearActThreeAndUploadInitialHUD
                move.l  #Obj_TitleCard,(Dynamic_object_RAM+(object_size*5)).w

SKLevel_WaitForTitleCardAndNemQueue:
                move.b  #VInt_ID_C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.w   (Dynamic_object_RAM+(object_size*5)+objoff_48).w
                bne.s   SKLevel_WaitForTitleCardAndNemQueue
                tst.l   (Nem_decomp_queue).w
                bne.s   SKLevel_WaitForTitleCardAndNemQueue

SKLevel_ClearActThreeAndUploadInitialHUD:
                clr.b   (Act3_flag).w
                move    #$2700,sr
                jsr     (HUD_DrawInitial).l
                move    #$2300,sr

SKLevel_InitGeometryAndResources:
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
                beq.s   SKLevel_InstallMHZPollenSpawner
                cmpi.b  #1,(Current_zone).w
                beq.s   SKLevel_InstallHCZWaterSplashActors
                cmpi.b  #1,(Current_zone).w
                bne.s   SKLevel_InstallMHZPollenSpawner

SKLevel_InstallHCZWaterSplashActors:
                move.l  #Obj_HCZWaveSplash,(Wave_Splash).w
                move.l  #Obj_HCZWaterSplash,(Dynamic_object_RAM+(object_size*2)).w
                move.b  #1,(Dynamic_object_RAM+(object_size*2)+subtype).w

SKLevel_InstallMHZPollenSpawner:
                cmpi.b  #7,(Current_zone).w
                bne.s   SKLevel_ResetFreshRunState
                move.l  #Obj_MHZ_Pollen_Spawner,(Dynamic_object_RAM+object_size).w

SKLevel_ResetFreshRunState:
                moveq   #0,d0
                tst.b   (Last_star_post_hit).w
                bne.s   SKLevel_ResetTransientStateAndStartHUD
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.b  d0,(Extra_life_flags).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.b  d0,(Saved_status_secondary).w
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.s   SKLevel_ClearRespawnRetention
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKLevel_ClearRespawnRetention
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKLevel_ResetTransientStateAndStartHUD
                cmpi.b  #$16,(Current_zone).w
                bhs.s   SKLevel_ClearSecondarySavedShield
                cmpi.b  #$13,(Current_zone).w
                bhs.s   SKLevel_ResetTransientStateAndStartHUD

SKLevel_ClearSecondarySavedShield:
                move.b  d0,(Saved2_status_secondary).w

SKLevel_ClearRespawnRetention:
                move.b  d0,(Respawn_table_keep).w

SKLevel_ResetTransientStateAndStartHUD:
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
                move.b  d0,(Super_Sonic_Knux_flag).w
                bsr.w   OscillateNumInit
                move.b  #1,(Update_HUD_score).w
                move.b  #1,(Update_HUD_ring_count).w
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Level_started_flag).w
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.s   SKLevel_DisableArenaTimer
                cmpi.w  #$1701,(Current_zone_and_act).w
                bne.s   SKLevel_PrimeActorsAndUnlock

SKLevel_DisableArenaTimer:
                clr.b   (Update_HUD_timer).w
                clr.b   (Level_started_flag).w

SKLevel_PrimeActorsAndUnlock:
                bsr.w   SpawnLevelMainSprites
                jsr     (Load_Sprites).l
                jsr     (Load_Rings).l
                jsr     (Draw_LRZ_Special_Rock_Sprites).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Animate_Tiles).l
                move.w  #1800,(Demo_timer).w
                bsr.w   LoadWaterPalette
                clearRAM Water_palette_line_2,(Water_palette_end-Water_palette_line_2)
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jsr     GetDemoPtr(pc)
                tst.w   (Competition_mode).w
                bne.w   SKLevel_ChooseCompetitionExtraStepRate
                tst.w   (Current_zone_and_act).w
                bne.s   SKLevel_LoadAnimalsForRegularZone
                tst.b   (Last_star_post_hit).w
                beq.s   SKLevel_StartFadeAndSeedInput

SKLevel_LoadAnimalsForRegularZone:
                cmpi.b  #$E,(Current_zone).w
                bhs.s   SKLevel_StartFadeAndSeedInput
                jsr     (PLCLoad_AnimalsAndExplosion).l

SKLevel_StartFadeAndSeedInput:
                move.w  #$2030-1,(Palette_fade_info).w
                jsr     (Pal_FillBlack).l
                move.w  #$16,(Palette_fade_timer).w
                move.w  #$16,(Dynamic_object_RAM+(object_size*5)+objoff_2E).w
                move.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask)<<8,(Ctrl_1).w
                move.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask)<<8,(Ctrl_2).w
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
                jsr     (Load_Sprites).l
                jsr     (Process_Sprites).l
                tst.w   (Restart_level_flag).w
                bne.w   Level
                jsr     (DeformBgLayer).l
                jsr     (ScreenEvents).l
                bsr.w   Handle_Onscreen_Water_Height
                jsr     (Load_Rings).l
                cmpi.b  #9,(Current_zone).w
                bne.s   Level_NotLRZ
                jsr     (Draw_LRZ_Special_Rock_Sprites).l

Level_NotLRZ:
                jsr     (Animate_Tiles).l
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                bsr.w   OscillateNumDo
                bsr.w   ChangeRingFrame
                jsr     (Render_Sprites).l
                cmpi.b  #$15,(Current_zone).w
                bne.s   Level_NotSlots
                jsr     (Slots_RenderLayout).l
                jsr     (Slots_CycleOptions).l

Level_NotSlots:
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.s   DemoMode
                cmpi.b  #GameMode_Level,(Game_mode).w
                beq.w   LevelLoop
                rts
; ---------------------------------------------------------------------------

DemoMode:
                tst.w   (Restart_level_flag).w
                bne.s   SKLevel_ResolveExpiredRegularDemoMode
                tst.w   (Demo_timer).w
                beq.s   SKLevel_ResolveExpiredRegularDemoMode
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.w   LevelLoop
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKLevel_ResolveExpiredRegularDemoMode:
                cmpi.b  #GameMode_Demo,(Game_mode).w
                bne.s   SKLevel_InitializeRegularExitFade
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKLevel_InitializeRegularExitFade:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

SKLevel_RunRegularExitFadeFrame:
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
                bpl.s   SKLevel_TestRegularExitFadeTimer
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToBlack

SKLevel_TestRegularExitFadeTimer:
                tst.w   (Demo_timer).w
                bne.s   SKLevel_RunRegularExitFadeFrame
                rts
; ---------------------------------------------------------------------------

SKLevel_ChooseCompetitionExtraStepRate:
                move.w  #0,(_unkFF7E).w
                tst.b   (Debug_cheat_flag).w
                beq.s   SKLevel_InitCompFadeAndFraction
                move.b  (_unkFF7C).w,d0
                cmpi.b  #$A0,d0
                bne.s   SKLevel_InitCompFadeAndFraction
                move.w  (Sound_test_sound).w,d0
                lsl.w   #8,d0
                move.w  d0,(_unkFF7E).w

SKLevel_InitCompFadeAndFraction:
                move.w  #$40-1,(Palette_fade_info).w
                jsr     (Pal_FillBlack).l
                move.w  #$16,(Palette_fade_timer).w
                move.w  #0,(_unkFF7C).w
                bclr    #7,(Game_mode).w

SKLevel_BeginCompetitionVideoFrame:
                bsr.w   Pause_Game
                move.b  #VInt_ID_8,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                addq.w  #1,(Level_frame_counter).w
                move.w  #4,-(sp)
                bra.s   SKLevel_RunCompetitionSimulationStep
; ---------------------------------------------------------------------------

; Carry from the fractional accumulator admits another simulation step
SKLevel_TryCompExtraStep:
                move.w  (_unkFF7E).w,d0
                add.w   d0,(_unkFF7C).w
                bcc.s   SKLevel_FinishCompStepsAndRender
                bsr.w   Pause_Game
                move.w  #$100,(Z80_bus_request).l       ; stop the Z80
                bsr.w   Poll_Controllers
                startZ80
                move.w  #0,(DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                lea     (Sprite_table_input).w,a5

SKLevel_ClearCompSpriteBuckets:
                move.w  #0,(a5)
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.s   SKLevel_ClearCompSpriteBuckets

SKLevel_RunCompetitionSimulationStep:
                bsr.w   Demo_PlayRecord
                jsr     (Process_Sprites).l
                jsr     (DeformBgLayer).l

SKLevel_FinishCompStepsAndRender:
                subq.w  #1,(sp)
                bne.s   SKLevel_TryCompExtraStep
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
                beq.s   SKLevel_TestCompetitionDemoContinuation
                cmpi.b  #GameMode_Level,(Game_mode).w
                beq.w   SKLevel_BeginCompetitionVideoFrame
                rts
; ---------------------------------------------------------------------------

SKLevel_TestCompetitionDemoContinuation:
                tst.w   (Restart_level_flag).w
                bne.s   SKLevel_HandleExpiredCompDemo
                tst.w   (Demo_timer).w
                beq.s   SKLevel_HandleExpiredCompDemo
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.w   SKLevel_BeginCompetitionVideoFrame
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKLevel_HandleExpiredCompDemo:
                cmpi.b  #GameMode_Demo,(Game_mode).w
                bne.s   SKLevel_InitializeCompetitionExitFade
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKLevel_InitializeCompetitionExitFade:
                move.w  #60,(Demo_timer).w
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w

SKLevel_RunCompetitionExitFadeFrame:
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
                bpl.s   SKLevel_TestCompetitionExitFadeTimer
                move.w  #2,(Pal_fade_delay).w
                bsr.w   Pal_ToBlack

SKLevel_TestCompetitionExitFadeTimer:
                tst.w   (Demo_timer).w
                bne.s   SKLevel_RunCompetitionExitFadeFrame
                rts

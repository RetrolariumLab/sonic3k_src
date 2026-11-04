; Owner: game/level/sk
; Responsibility: Per-level descriptor loading, water applicability and underwater palette selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock:
                move.w  (Current_zone_and_act).w,d0
                bne.s   SKEnv_QueueLevelArtFromRecord
                cmpi.w  #2,(Player_mode).w
                bhs.s   SKEnv_SelectAIZMainLoadRecord
                tst.b   (Last_star_post_hit).w
                beq.s   SKEnv_QueueLevelArtFromRecord

SKEnv_SelectAIZMainLoadRecord:
                move.w  #$D00,d0

SKEnv_QueueLevelArtFromRecord:
                ror.b   #1,d0
                lsr.w   #4,d0
                andi.w  #$1F8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     (LevelLoadBlock).l,a4
                lea     (a4,d0.w),a4
                move.l  (a4)+,d0
                andi.l  #$FFFFFF,d0
                move.l  d0,d7
                movea.l d0,a1
                move.w  (a1),d4
                move.w  #0,d2
                jsr     (Queue_Kos_Module).l
                move.l  (a4)+,d0
                andi.l  #$FFFFFF,d0
                cmp.l   d0,d7
                beq.s   SKEnv_WaitForLevelArtModules
                movea.l d0,a1
                move.w  d4,d2
                jsr     (Queue_Kos_Module).l

SKEnv_WaitForLevelArtModules:
                move.b  #VInt_ID_C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   SKEnv_WaitForLevelArtModules
                rts
; End of function LoadLevelLoadBlock

; =============== S U B R O U T I N E =======================================

CheckLevelForWater:
                cmpi.w  #0,(Current_zone_and_act).w
                beq.s   SKEnv_EnableWaterAndSetHInt
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   SKEnv_CheckHCZOrCNZWater
                cmpi.w  #1,(Apparent_zone_and_act).w
                bne.s   SKEnv_EnableWaterAndSetHInt
                cmpi.w  #3,(Player_mode).w
                bne.s   SKEnv_EnableWaterAndSetHInt

SKEnv_CheckHCZOrCNZWater:
                cmpi.b  #1,(Current_zone).w
                beq.s   SKEnv_EnableWaterAndSetHInt
                cmpi.w  #$301,(Current_zone_and_act).w
                bne.s   SKEnv_CheckOtherWaterActs
                cmpi.w  #3,(Player_mode).w
                bne.s   SKEnv_EnableWaterAndSetHInt

SKEnv_CheckOtherWaterActs:
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   SKEnv_EnableWaterAndSetHInt
                cmpi.w  #$601,(Current_zone_and_act).w
                beq.s   SKEnv_EnableWaterAndSetHInt
                move.w  #$1000,d0
                move.w  d0,(Water_level).w
                move.w  d0,(Mean_water_level).w
                move.w  d0,(Target_water_level).w
                move.b  #0,(Water_flag).w
                rts
; ---------------------------------------------------------------------------

SKEnv_EnableWaterAndSetHInt:
                move.b  #1,(Water_flag).w
                move.w  #0,(Competition_mode).w
                tst.b   (Water_flag).w
                beq.s   LoadWaterPalette
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt2,(H_int_addr).w
                cmpi.b  #1,(Current_zone).w
                beq.s   SKEnv_InitWaterHeightsAndTransition
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   SKEnv_InitWaterHeightsAndTransition
                move.l  #HInt4,(H_int_addr).w

SKEnv_InitWaterHeightsAndTransition:
                move.l  #WaterTransition_AIZ1,(Water_palette_data_addr).w
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$FFFE,d0
                lea     (StartingWaterHeights).l,a1
                move.w  (a1,d0.w),d0
                move.w  d0,(Water_level).w
                move.w  d0,(Mean_water_level).w
                move.w  d0,(Target_water_level).w
                clr.b   (Water_entered_counter).w
                clr.b   (Water_full_screen_flag).w
                move.b  #1,(Water_speed).w
; End of function CheckLevelForWater

; =============== S U B R O U T I N E =======================================

LoadWaterPalette:
                tst.b   (Water_flag).w
                beq.w   SKEnv_WaterPaletteReturn
                moveq   #PalID_AIZ_Water,d0
                cmpi.w  #0,(Current_zone_and_act).w
                beq.w   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_AIZ2_Water,d0
                move.l  #WaterTransition_AIZ2,(Water_palette_data_addr).w
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_HCZ1_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_HCZ2_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$101,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_CNZ_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$301,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_ICZ2_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_LBZ_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                moveq   #PalID_LBZ2_Water,d0
                move.l  #WaterTransition_LBZ2,(Water_palette_data_addr).w
                cmpi.w  #$601,(Current_zone_and_act).w
                beq.s   SKEnv_LoadWaterPaletteBanks
                nop

SKEnv_LoadWaterPaletteBanks:
                move.w  d0,d1
                bsr.w   LoadPalette2
                move.w  d1,d0
                bsr.w   LoadPalette2_Immediate
                tst.b   (Last_star_post_hit).w
                beq.s   SKEnv_TryKnuxWaterColors
                move.b  (Saved_water_full_screen_flag).w,(Water_full_screen_flag).w

SKEnv_TryKnuxWaterColors:
                cmpi.w  #3,(Player_mode).w
                beq.s   SKEnv_CopyKnuxWaterTriplet

SKEnv_WaterPaletteReturn:
                rts
; ---------------------------------------------------------------------------

SKEnv_CopyKnuxWaterTriplet:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                lea     Pal_WaterKnux(pc,d0.w),a1
                move.l  (a1),(Water_palette+$4).w
                move.w  4(a1),(Water_palette+$8).w
                move.l  (a1),(Target_water_palette+$4).w
                move.w  4(a1),(Target_water_palette+$8).w
                rts
; End of function LoadWaterPalette

; ---------------------------------------------------------------------------
Pal_WaterKnux:
                binclude "data/Levels/Misc/Palettes/Water Knuckles Patch.bin"
                even
; ---------------------------------------------------------------------------

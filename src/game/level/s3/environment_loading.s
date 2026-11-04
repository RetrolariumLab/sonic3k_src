; Owner: game/level/s3
; Responsibility: Per-level descriptor loading, water applicability and underwater palette selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S2_DemoDat_AIZ:
                binclude "data/Levels/AIZ/Demodata/1 Proto.bin"
                even

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock:
                move.w  (Current_zone_and_act).w,d0
                bne.s   S3Env_QueueLevelArtFromRecord
                cmpi.w  #2,(Player_mode).w
                beq.s   S3Env_SelectAIZMainLoadRecord
                tst.b   (Last_star_post_hit).w
                beq.s   S3Env_QueueLevelArtFromRecord

S3Env_SelectAIZMainLoadRecord:
                move.w  #$D00,d0

S3Env_QueueLevelArtFromRecord:
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
                beq.s   S3Env_WaitForLevelArtModules
                movea.l d0,a1
                move.w  d4,d2
                jsr     (Queue_Kos_Module).l

S3Env_WaitForLevelArtModules:
                move.b  #VInt_ID_C,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                bsr.w   Process_Nem_Queue_Init
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   S3Env_WaitForLevelArtModules
                rts
; End of function LoadLevelLoadBlock

; =============== S U B R O U T I N E =======================================

CheckLevelForWater:
                cmpi.b  #0,(Current_zone).w
                beq.s   S3Env_EnableWaterAndSetHInt
                cmpi.b  #1,(Current_zone).w
                beq.s   S3Env_EnableWaterAndSetHInt
                cmpi.w  #$301,(Current_zone_and_act).w
                beq.s   S3Env_EnableWaterAndSetHInt
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   S3Env_EnableWaterAndSetHInt
                cmpi.w  #$601,(Current_zone_and_act).w
                bne.s   S3Env_TryInstallWaterHInt

S3Env_EnableWaterAndSetHInt:
                move.b  #1,(Water_flag).w
                move.w  #0,(Competition_mode).w

S3Env_TryInstallWaterHInt:
                tst.b   (Water_flag).w
                beq.s   LoadWaterPalette
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt2,(H_int_addr).w
                cmpi.b  #1,(Current_zone).w
                beq.s   S3Env_InitWaterHeightsAndTransition
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   S3Env_InitWaterHeightsAndTransition
                move.l  #HInt4,(H_int_addr).w

S3Env_InitWaterHeightsAndTransition:
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
                beq.w   S3Env_WaterPaletteReturn
                moveq   #PalID_AIZ_Water,d0
                cmpi.w  #0,(Current_zone_and_act).w
                beq.w   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_AIZ2_Water,d0
                move.l  #WaterTransition_AIZ2,(Water_palette_data_addr).w
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_HCZ1_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_HCZ2_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$101,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_CNZ_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$301,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_ICZ2_Water,d0
                move.l  #WaterTransition_CNZ2ICZ2,(Water_palette_data_addr).w
                cmpi.w  #$501,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_LBZ_Water,d0
                move.l  #WaterTransition_HCZLBZ1,(Water_palette_data_addr).w
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                moveq   #PalID_LBZ2_Water,d0
                move.l  #WaterTransition_LBZ2,(Water_palette_data_addr).w
                cmpi.w  #$601,(Current_zone_and_act).w
                beq.s   S3Env_LoadWaterPaletteBanks
                nop

S3Env_LoadWaterPaletteBanks:
                move.w  d0,d1
                bsr.w   LoadPalette2
                move.w  d1,d0
                bsr.w   LoadPalette2_Immediate
                tst.b   (Last_star_post_hit).w
                beq.s   S3Env_WaterPaletteReturn
                move.b  (Saved_water_full_screen_flag).w,(Water_full_screen_flag).w

S3Env_WaterPaletteReturn:
                rts
; End of function LoadWaterPalette

; ---------------------------------------------------------------------------
; unused
                subq.w  #1,$24(a0)
                bpl.s   S3Env_RetainedTryRefreshPlane
                move.w  #7,$24(a0)
                moveq   #0,d0
                move.b  $2E(a0),d0
                addq.b  #1,$2E(a0)
                move.b  S3Env_RetainedFirstCopyPages(pc,d0.w),d0
                bne.s   S3Env_RetainedBindFirstRamCopy
                move.b  #1,$2E(a0)
                move.b  S3Env_RetainedFirstCopyPages(pc),d0

S3Env_RetainedBindFirstRamCopy:
                lsl.w   #7,d0
                lea     (RAM_start).l,a1
                lea     (a1,d0.w),a1
                lea     (RAM_start+$200).l,a2
                move.w  #bytesToWcnt($100),d0

S3Env_RetainedCopyFirstRamBlock:
                move.w  (a1)+,(a2)+
                dbf     d0,S3Env_RetainedCopyFirstRamBlock
                moveq   #0,d0
                move.b  $2F(a0),d0
                addq.b  #1,$2F(a0)
                move.b  S3Env_RetainedSecondCopyPages(pc,d0.w),d0
                bne.s   S3Env_RetainedBindSecondRamCopy
                move.b  #1,$2F(a0)
                move.b  S3Env_RetainedSecondCopyPages(pc),d0

S3Env_RetainedBindSecondRamCopy:
                lsl.w   #7,d0
                lea     (RAM_start).l,a1
                lea     (a1,d0.w),a1
                lea     (RAM_start+$F00).l,a2
                move.w  #bytesToWcnt($80),d0

S3Env_RetainedCopySecondRamBlock:
                move.w  (a1)+,(a2)+
                dbf     d0,S3Env_RetainedCopySecondRamBlock

S3Env_RetainedTryRefreshPlane:
                cmpi.w  #6,$24(a0)
                beq.w   S3Env_RetainedRefreshPlane
                rts
; ---------------------------------------------------------------------------
S3Env_RetainedFirstCopyPages:
                dc.b    2, $12,   6, $14,   8, $16,  $A, $18,  $C, $18,  $A, $16,   8, $14,   6, $12
                dc.b    3, $1A,  $E, $1C, $10, $1C,  $E, $1A,   0,   0
S3Env_RetainedSecondCopyPages:
                dc.b    2, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D
                dc.b    $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D
                dc.b    $3E, $3F, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D
                dc.b    $4E, $4D, $4C, $4B, $4A, $49, $48, $47, $46, $45, $44, $43, $42, $41, $40, $3F
                dc.b    $3E, $3D, $3C, $3B, $3A, $39, $38, $37, $36, $35, $34, $33, $32, $31, $30, $2F
                dc.b    $2E, $2D, $2C, $2B, $2A, $29, $28, $27, $26, $25, $24, $23, $22, $21, $20, $1F
                dc.b    2, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D
                dc.b    $5E, $5D, $5C, $5B, $5A, $59, $58, $57, $56, $55, $54, $53, $52, $51, $50, $4F
                dc.b    0,   0
                even
; ---------------------------------------------------------------------------

S3Env_RetainedRefreshPlane:
                move    #$2700,sr
                movem.l d0-a6,-(sp)
                lea     (Plane_buffer).w,a0
                lea     (Block_table).w,a2
                lea     (Level_layout_main).w,a3
                move.w  #$C000,d7
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF0,d0
                jsr     (Refresh_PlaneFull).l
                movem.l (sp)+,d0-a6
                move    #$2300,sr
                rts
; ---------------------------------------------------------------------------

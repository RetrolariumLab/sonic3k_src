; Owner: game/modes/sk
; Responsibility: Competition results initialization, win and loss displays, totals and results resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_Results:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C89,(a6)
                move.w  #$9011,(a6)
                jsr     Menu_FillPlaneAWithPriorityBlankTiles(pc)
                move.w  #VRAM_Plane_A_Name_Table+$1AA,d0
                jsr     Menu_ClearNineByEightTileArea(pc)
                move.w  #VRAM_Plane_A_Name_Table+$82A,d0
                jsr     Menu_ClearNineByEightTileArea(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                clr.w   (Competition_mode).w
                clr.b   (Level_started_flag).w
                move.w  #$1E,(Events_bg+$16).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     (MapEni_CompetitionResultsLED).l,a0
                lea     (RAM_start+$1000).l,a1
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),d0
                jsr     (Eni_Decomp).l
                lea     SKCompResults_InitialPlaneTransfers(pc),a0
                jsr     Copy_Listed_Data_To_VRAM(pc)
                jsr     SKComp_BuildRaceResults(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #SKSS_NoOpVBlankReturn,(MenuVInterruptCallbackPointer).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_CompetitionLevel).l,a0  ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source, used by the next two KosArt_To_VDP also
                movea.w #tiles_to_bytes(ArtTile_Competition_LevSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionResults).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_Results),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionPlayer).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_CharSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_CompetitionMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

SKCompResults_CopyBackgroundPalette:
                move.l  (a0)+,(a1)+
                dbf     d0,SKCompResults_CopyBackgroundPalette
                lea     (Pal_Competition2).l,a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

SKCompResults_CopyCharacterPalettes:
                move.l  (a0)+,(a1)+
                dbf     d0,SKCompResults_CopyCharacterPalettes
                lea     (Pal_CompetitionResults).l,a0
                moveq   #bytesToLcnt(Target_palette_end-Target_palette_line_4),d0

SKCompResults_CopyPaletteAndPrepActors:
                move.l  (a0)+,(a1)+
                dbf     d0,SKCompResults_CopyPaletteAndPrepActors
                lea     (Object_RAM).w,a0
                lea     CompetitionResults_ActorRecords(pc),a1
                move.w  (a1)+,d0

SKCompResults_BuildActorsAndFadeIn:
                move.l  (a1)+,(a0)
                move.l  #Map_CompetitionSelect,mappings(a0)
                move.w  (a1),x_pos(a0)
                move.w  (a1)+,$12(a0)
                move.w  (a1),y_pos(a0)
                move.w  (a1)+,$16(a0)
                move.w  (a1)+,d1
                addi.w  #make_art_tile(ArtTile_Competition_LevSel,0,1),d1
                move.w  d1,art_tile(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,SKCompResults_BuildActorsAndFadeIn
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

SKCompResults_RunResultsAndBlinkWinner:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                move.w  (SceneColumnOrCompBlinkVRAM).w,d7
                beq.s   SKCompResults_Tick30FrameInputLockout
                btst    #3,(Level_frame_counter+1).w
                bne.s   SKCompResults_DrawWinningTotalNormal
                lea     (Plane_buffer+$20).w,a1
                jsr     CompetitionMenuUploadEightByTwoTileBlock(pc)
                bra.s   SKCompResults_Tick30FrameInputLockout
; ---------------------------------------------------------------------------

SKCompResults_DrawWinningTotalNormal:
                move.l  (SceneAuxiliaryXOrCompetitionTime).w,d6
                jsr     SKComp_DrawPackedTime(pc)

SKCompResults_Tick30FrameInputLockout:
                tst.w   (Events_bg+$16).w
                beq.s   SKCompResults_ReadActiveControllers
                subq.w  #1,(Events_bg+$16).w
                bra.s   SKCompResults_UpdateAndRenderActors
; ---------------------------------------------------------------------------

SKCompResults_ReadActiveControllers:
                move.b  (Ctrl_1_pressed).w,d0
                tst.b   (Not_ghost_flag).w
                beq.s   SKCompResults_RouteControlsByPage
                or.b    (Ctrl_2_pressed).w,d0

SKCompResults_RouteControlsByPage:
                move.w  (H_scroll_buffer).w,d1
                beq.s   SKCompResults_BeginSecondPageOnConfirm
                cmpi.w  #$FF78,d1
                beq.s   SKCompResults_ExitSecondPageOnConfirm
                bra.s   SKCompResults_SlidePageLeftToEndpoint
; ---------------------------------------------------------------------------

SKCompResults_BeginSecondPageOnConfirm:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   SKCompResults_UpdateAndRenderActors

SKCompResults_SlidePageLeftToEndpoint:
                subq.w  #8,d1
                move.w  d1,(H_scroll_buffer).w
                bra.s   SKCompResults_UpdateAndRenderActors
; ---------------------------------------------------------------------------

SKCompResults_ExitSecondPageOnConfirm:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   SKCompResults_UpdateAndRenderActors
                move.b  #GameMode_CompetitionMenu,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKCompResults_UpdateAndRenderActors:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bra.w   SKCompResults_RunResultsAndBlinkWinner
; ---------------------------------------------------------------------------

SKCompResults_UpdatePlayerIcon:
                move.l  #Map_CompetitionPlayerSprite,mappings(a0)
                move.w  #make_art_tile(ArtTile_Competition_CharSel,1,1),art_tile(a0)
                move.b  (P1_character).w,d0
                tst.b   $2E(a0)
                beq.s   SKCompResults_StorePlayerIconFrame
                move.b  (P2_character).w,d0

SKCompResults_StorePlayerIconFrame:
                move.b  d0,mapping_frame(a0)
                jmp     Obj_Competition_StaticSprite(pc)
; ---------------------------------------------------------------------------

CompetitionResults_UpdateWinLoseTieIcon:
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),art_tile(a0)
                move.b  (SceneRowAnchorOrCompetitionWinCounts).w,d0
                move.b  (SceneRowAnchorOrCompetitionWinCounts+1).w,d1
                tst.b   $2E(a0)
                beq.s   SKCompResults_ComparePlayerWinCounts
                exg     d0,d1

SKCompResults_ComparePlayerWinCounts:
                moveq   #$D,d2
                cmp.b   d0,d1
                beq.s   SKCompResults_StoreFrameAndBlinkWinner
                bcs.s   CompetitionResults_FinalizeNonTieFrame
                addq.w  #1,d2

CompetitionResults_FinalizeNonTieFrame:
                subq.b  #2,d2

SKCompResults_StoreFrameAndBlinkWinner:
                move.b  d2,mapping_frame(a0)
                cmpi.b  #$B,d2
                bne.w   Obj_Competition_StaticSprite
                btst    #3,(Level_frame_counter+1).w
                bne.w   Obj_Competition_StaticSprite
                rts

; =============== S U B R O U T I N E =======================================

; Draw both players' five-zone results and totals, count per-zone wins and prepare the fastest-total blink palette
SKComp_BuildRaceResults:
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.w  #$C15A,d7
                jsr     SKCompDrawFiveSequentialTimeRows(pc)
                move.w  #$C7DA,d7
                jsr     SKCompDrawFiveSequentialTimeRows(pc)
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                jsr     SKComp_SumFivePackedTimes(pc)
                move.w  #$C65A,d7
                move.l  d6,(SceneAuxiliaryXOrCompetitionTime).w
                move.w  d7,(SceneColumnOrCompBlinkVRAM).w
                jsr     SKComp_DrawPackedTime(pc)
                jsr     SKComp_SumFivePackedTimes(pc)
                move.w  #$CCDA,d7
                cmp.l   (SceneAuxiliaryXOrCompetitionTime).w,d6
                bhi.s   SKCompResults_DrawP2TotalAndPrepRaceRows
                bne.s   SKCompResults_BlinkP2TotalIfFaster
                clr.w   (SceneColumnOrCompBlinkVRAM).w
                bra.s   SKCompResults_DrawP2TotalAndPrepRaceRows
; ---------------------------------------------------------------------------

SKCompResults_BlinkP2TotalIfFaster:
                move.l  d6,(SceneAuxiliaryXOrCompetitionTime).w
                move.w  d7,(SceneColumnOrCompBlinkVRAM).w

SKCompResults_DrawP2TotalAndPrepRaceRows:
                jsr     SKComp_DrawPackedTime(pc)
                clr.w   (SceneRowAnchorOrCompetitionWinCounts).w
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$148,VRAM,WRITE),d5
                moveq   #5-1,d7

SKCompResults_CompareTimesAndCountWins:
                lea     (MapUnc_ResultsWin).l,a1
                lea     (MapUnc_ResultsLose).l,a2
                addq.b  #1,(SceneRowAnchorOrCompetitionWinCounts).w
                move.l  (a0)+,d0
                cmp.l   x_pos(a0),d0
                beq.s   SKCompResults_UseTieMapsWithoutWin
                bcs.s   SKCompResults_UploadMapsAndPrepBlink
                exg     a1,a2
                subq.b  #1,(SceneRowAnchorOrCompetitionWinCounts).w
                addq.b  #1,(SceneRowAnchorOrCompetitionWinCounts+1).w
                bra.s   SKCompResults_UploadMapsAndPrepBlink
; ---------------------------------------------------------------------------

SKCompResults_UseTieMapsWithoutWin:
                lea     (MapUnc_ResultsTie).l,a1
                movea.l a1,a2
                subq.b  #1,(SceneRowAnchorOrCompetitionWinCounts).w

SKCompResults_UploadMapsAndPrepBlink:
                move.l  d5,d0
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM).l
                movea.l a2,a1
                move.l  d5,d0
                addi.l  #$680<<16,d0
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM).l
                addi.l  #$100<<16,d5
                dbf     d7,SKCompResults_CompareTimesAndCountWins
                move.w  (SceneColumnOrCompBlinkVRAM).w,d7
                beq.s   SKCompResults_OutcomeRowsReturn
                move.l  (SceneAuxiliaryXOrCompetitionTime).w,d6
                jsr     SKComp_DrawPackedTime(pc)
                lea     (Plane_buffer).w,a0
                lea     $20(a0),a1
                moveq   #$10-1,d0

SKCompResults_BuildWinnerBlinkTiles:
                move.w  (a0)+,d1
                andi.w  #$9FFF,d1
                ori.w   #palette_line_3,d1
                move.w  d1,(a1)+
                dbf     d0,SKCompResults_BuildWinnerBlinkTiles

SKCompResults_OutcomeRowsReturn:
                rts
; End of function SKComp_BuildRaceResults

; =============== S U B R O U T I N E =======================================

SKCompDrawFiveSequentialTimeRows:
                moveq   #5-1,d0

SKCompResults_DrawFiveRaceTimes:
                move.w  d0,-(sp)
                move.l  (a0)+,d6
                jsr     SKComp_DrawPackedTime(pc)
                addi.w  #$100,d7
                move.w  (sp)+,d0
                dbf     d0,SKCompResults_DrawFiveRaceTimes
                rts
; End of function SKCompDrawFiveSequentialTimeRows

; =============== S U B R O U T I N E =======================================

; Carry at 100 hundredths and 60 seconds. Cap the minutes at 99
SKComp_SumFivePackedTimes:
                clr.l   (ResultsNumericAccumulator).w
                moveq   #5-1,d7

SKCompResults_AccumulateHundredths:
                move.l  (a0)+,d6
                lea     (ResultsNumericAccumulatorEnd).w,a1
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   SKCompResults_AccumulateSeconds
                subi.b  #100,(a1)
                addq.b  #1,-1(a1)

SKCompResults_AccumulateSeconds:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKCompResults_AccumulateMinutesCap99
                subi.b  #60,(a1)
                addq.b  #1,-1(a1)

SKCompResults_AccumulateMinutesCap99:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   SKCompResults_RepeatAndReturnPackedTotal
                move.b  #99,(a1)

SKCompResults_RepeatAndReturnPackedTotal:
                dbf     d7,SKCompResults_AccumulateHundredths
                move.l  (ResultsNumericAccumulator).w,d6
                rts
; End of function SKComp_SumFivePackedTimes

; ---------------------------------------------------------------------------
CompetitionResults_ActorRecords:
                dc.w    8-1
                dc.l    Obj_Competition_StaticSprite
                dc.w    $148,   $A1, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,   $B9, palette_line_0
                dc.b    0,   0
                dc.l    SKCompResults_UpdatePlayerIcon
                dc.w    $14D,   $D3, palette_line_0
                dc.b    0,   0
                dc.l    CompetitionResults_UpdateWinLoseTieIcon
                dc.w    $CC,   $BC, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14A,  $109, palette_line_1
                dc.b    4,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,  $121, palette_line_0
                dc.b    0,   0
                dc.l    SKCompResults_UpdatePlayerIcon
                dc.w    $14D,  $13B, palette_line_0
                dc.b    0,   1
                dc.l    CompetitionResults_UpdateWinLoseTieIcon
                dc.w    $CC,  $124, palette_line_0
                dc.b    0,   1
SKCompResults_InitialPlaneTransfers:
                dc.w    9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_B_Name_Table+$000,  40-1,  28-1
                dc.l    RAM_start+$1000
                dc.w    VRAM_Plane_A_Name_Table+$204,  15-1,   6-1
                dc.l    RAM_start+$1000
                dc.w    VRAM_Plane_A_Name_Table+$884,  15-1,   6-1
                dc.l    MapUnc_CompetitionResultsLetters
                dc.w    VRAM_Plane_A_Name_Table+$142,   2-1,  10-1
                dc.l    MapUnc_CompetitionResultsLetters
                dc.w    VRAM_Plane_A_Name_Table+$7C2,   2-1,  10-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$152,   4-1,  10-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$7D2,   4-1,  10-1
                dc.l    MapUnc_CompetitionResultsTOTAL
                dc.w    VRAM_Plane_A_Name_Table+$650,   5-1,   2-1
                dc.l    MapUnc_CompetitionResultsTOTAL
                dc.w    VRAM_Plane_A_Name_Table+$CD0,   5-1,   2-1
; ---------------------------------------------------------------------------

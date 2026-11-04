; Owner: game/modes/ending/sk
; Responsibility: Ending credit progression, character-specific pose graphics and scrolling tile transfer helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SKCredits_DispatchScrollState:
                move.w  (SceneCreditStateOrBossMotionPlanX).w,d0
                move.w  SKCredits_ScrollStateOffsets(pc,d0.w),d0
                jmp     SKCredits_ScrollStateOffsets(pc,d0.w)
; End of function SKCredits_DispatchScrollState

; ---------------------------------------------------------------------------
SKCredits_ScrollStateOffsets:
                dc.w    SKCredits_InitScrollAndTryMusic-SKCredits_ScrollStateOffsets
                dc.w    SKCredits_TickDelayThenQueuePose-SKCredits_ScrollStateOffsets
                dc.w    SKCredits_ScrollAndCheckTileCrossing-SKCredits_ScrollStateOffsets
                dc.w    SKCredits_FinishedCreditsReturn-SKCredits_ScrollStateOffsets
; ---------------------------------------------------------------------------

SKCredits_InitScrollAndTryMusic:
                addq.w  #2,(SceneCreditStateOrBossMotionPlanX).w
                clr.b   (EndingCreditsFinishedSignal).w
                clr.l   (Camera_Y_pos).w
                clr.l   (V_scroll_value).w
                clr.w   (SceneActorOrWorldOffset).w
                cmpi.w  #3,(Player_mode).w
                bne.s   SKCredits_SelectParamsAndLoadFont
                jsr     (AllocateObject).l
                bne.s   SKCredits_SelectParamsAndLoadFont
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_CreditsK,subtype(a1)

SKCredits_SelectParamsAndLoadFont:
                bsr.w   SKCredits_SelectScrollSpeedAndDelay
                move.w  #$EEE,(Normal_palette+$2).w
                move.w  #$EE,(Normal_palette_line_2+$2).w
                lea     PLC_SKCredits(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_SKCredits:  plrlistheader
                plreq   ArtTile_Ending_CreditsText, ArtNem_CreditsText
PLC_SKCredits_End:
; ---------------------------------------------------------------------------

SKCredits_TickDelayThenQueuePose:
                subq.w  #1,(CreditsDelayOrSegaCompletionLatch).w
                bpl.s   SKCredits_ScrollDelayReturn
                addq.w  #2,(SceneCreditStateOrBossMotionPlanX).w
                bsr.w   SKCredits_QueueEndingPoseArt

SKCredits_ScrollDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKCredits_ScrollAndCheckTileCrossing:
                move.l  (Camera_Y_pos).w,d0
                move.l  d0,d1
                add.l   (EndingCreditsFixedPointScrollIncrement).w,d0
                move.l  d0,(Camera_Y_pos).w
                swap    d0
                swap    d1
                eor.w   d0,d1
                btst    #4,d1
                beq.s   SKCredits_ScrollTextUpdateReturn
                lsl.w   #4,d0
                addi.w  #$E00,d0
                move.w  d0,d1
                andi.w  #$F00,d1
                bsr.w   SKCredits_ClearTwoPlaneRows
                moveq   #0,d2
                tst.w   (SK_alone_flag).w
                beq.s   SKCredits_SelectPartAndCheckTextRow
                moveq   #8,d2

SKCredits_SelectPartAndCheckTextRow:
                add.w   (SceneActorOrWorldOffset).w,d2
                movea.l SKCredits_CreditPartPointers(pc,d2.w),a1
                move.w  (SceneCreditIndexOrBossMotionPlanAngle).w,d2
                move.w  (a1,d2.w),d2
                lea     (a1,d2.w),a1
                move.w  (a1)+,d2
                cmpi.w  #-8,d2
                beq.s   SKCredits_PartTransitionOffsets
                cmpi.w  #-$C,d2
                beq.s   SKCredits_FinishCreditsAndSignalScene
                move.w  d2,d3
                andi.w  #$FF00,d0
                andi.w  #$FF00,d3
                cmp.w   d0,d3
                bne.s   SKCredits_ScrollTextUpdateReturn
                move.w  #make_art_tile(ArtTile_Ending_CreditsText,0,1),d6
                bclr    #0,d2
                beq.s   SKCredits_UploadTwoRowsAndAdvance
                move.w  #make_art_tile(ArtTile_Ending_CreditsText,1,1),d6

SKCredits_UploadTwoRowsAndAdvance:
                andi.w  #$FFE,d2
                bsr.w   SKCredits_BuildAndUploadText
                addq.w  #2,(SceneCreditIndexOrBossMotionPlanAngle).w

SKCredits_ScrollTextUpdateReturn:
                rts
; ---------------------------------------------------------------------------
SKCredits_CreditPartPointers:
                dc.l    CreditsText_Part1
                dc.l    CreditsText_Part2
                dc.l    CreditsText_Part1_SK
                dc.l    CreditsText_Part2_SK
; ---------------------------------------------------------------------------

SKCredits_PartTransitionOffsets:
                addq.w  #4,(SceneActorOrWorldOffset).w
                clr.w   (SceneCreditIndexOrBossMotionPlanAngle).w
                rts
; ---------------------------------------------------------------------------

SKCredits_FinishCreditsAndSignalScene:
                addq.w  #2,(SceneCreditStateOrBossMotionPlanX).w
                clr.l   (Timer).w
                st      (Events_fg_4).w
                st      (EndingCreditsFinishedSignal).w
                cmpi.w  #3,(Player_mode).w
                beq.s   SKCredits_TryKnucklesHandoff
                rts
; ---------------------------------------------------------------------------

SKCredits_TryKnucklesHandoff:
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   SKCredits_ClearKnucklesSceneLatch
                jsr     (AllocateObject).l
                bne.s   SKCredits_HandoffSpawnReturn
                move.l  #EndingResults_SelectProgramAndStartDelay,(a1)

SKCredits_HandoffSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKCredits_ClearKnucklesSceneLatch:
                clr.b   (EndingCloudSpawnFrameMask).w
                rts
; ---------------------------------------------------------------------------

SKCredits_FinishedCreditsReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Clear forty columns of each plane A row
SKCredits_ClearTwoPlaneRows:
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                move.w  d1,d2
                addi.w  #VRAM_Plane_A_Name_Table,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  #$80<<16,d3
                moveq   #0,d4
                moveq   #2-1,d5

SKCredits_SelectPlaneRowToClear:
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                moveq   #$28-1,d6

; The row clear exits with SR set to $2300
SKCredits_ClearFortyColumns:
                move.w  d4,(a6)
                dbf     d6,SKCredits_ClearFortyColumns
                add.l   d3,d2
                dbf     d5,SKCredits_SelectPlaneRowToClear
                move    #$2300,sr

SKCredits_RowOrGlyphReturn:
                rts
; End of function SKCredits_ClearTwoPlaneRows

; =============== S U B R O U T I N E =======================================

; Upload the computed width of both scratch rows to consecutive plane A rows
SKCredits_BuildAndUploadText:
                bsr.w   SKCredits_BuildGlyphRows
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                addi.w  #VRAM_Plane_A_Name_Table,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  d2,d3
                addi.l  #$80<<16,d3
                lea     (Chunk_table+$7000).l,a1
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                subq.w  #1,d0
                move.w  d0,d1

SKCredits_UploadTopGlyphRow:
                move.w  (a1)+,(a6)
                dbf     d0,SKCredits_UploadTopGlyphRow
                lea     (Chunk_table+$7080).l,a1
                move.l  d3,VDP_control_port-VDP_data_port(a6)

; The final row upload exits with SR set to $2300
SKCredits_UploadBottomGlyphRow:
                move.w  (a1)+,(a6)
                dbf     d1,SKCredits_UploadBottomGlyphRow
                move    #$2300,sr
                rts
; End of function SKCredits_BuildAndUploadText

; =============== S U B R O U T I N E =======================================

; Expand a null-terminated ASCII line to variable-width glyphs in two scratch rows
SKCredits_BuildGlyphRows:
                lea     (Chunk_table+$7000).l,a2
                lea     (Chunk_table+$7080).l,a3
                moveq   #0,d0

SKCredits_DecodeNextGlyph:
                moveq   #0,d1
                move.b  (a1)+,d1
                beq.s   SKCredits_RowOrGlyphReturn
                cmpi.b  #" ",d1
                beq.w   SKCredits_AppendBlankColumn
                cmpi.b  #"?",d1
                beq.w   SKCredits_SelectQuestionMark
                cmpi.b  #"!",d1
                beq.s   SKCredits_SelectExclamation
                cmpi.b  #"&",d1
                beq.s   SKCredits_SelectAmpersand
                cmpi.b  #")",d1
                beq.s   SKCredits_SelectRightParen
                cmpi.b  #"(",d1
                beq.s   SKCredits_SelectLeftParen
                cmpi.b  #".",d1
                beq.s   SKCredits_SelectPeriod
                cmpi.b  #"I",d1
                beq.s   SKCredits_SelectNarrowI
                addq.w  #2,d0
                subi.b  #"A",d1
                lsl.w   #3,d1
                lea     CreditsText_PlaneMap(pc),a4
                adda.w  d1,a4

SKCredits_AppendTwoColumnGlyph:
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                bra.s   SKCredits_DecodeNextGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectNarrowI:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.LetterI(pc),a4

SKCredits_AppendOneColumnGlyph:
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                bra.s   SKCredits_DecodeNextGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectPeriod:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.Period(pc),a4
                bra.s   SKCredits_AppendOneColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectLeftParen:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.LeftBracket(pc),a4
                bra.s   SKCredits_AppendOneColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectRightParen:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.RightBracket(pc),a4
                bra.s   SKCredits_AppendOneColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectAmpersand:
                addq.w  #2,d0
                lea     CreditsText_PlaneMap.Ampersand(pc),a4
                bra.s   SKCredits_AppendTwoColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectExclamation:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.Exclamation(pc),a4
                bra.s   SKCredits_AppendOneColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_SelectQuestionMark:
                addq.w  #2,d0
                lea     CreditsText_PlaneMap.QuestionMark(pc),a4
                bra.s   SKCredits_AppendTwoColumnGlyph
; ---------------------------------------------------------------------------

SKCredits_AppendBlankColumn:
                addq.w  #1,d0
                clr.w   (a2)+
                clr.w   (a3)+
                bra.w   SKCredits_DecodeNextGlyph
; End of function SKCredits_BuildGlyphRows

; =============== S U B R O U T I N E =======================================

; Queue AND Knuckles art, then select banner and pose by product, character and emerald completion
SKCredits_QueueEndingPoseArt:
                lea     (ArtKosM_ANDKnuckles).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_ANDKnuckles),d2
                jsr     (Queue_Kos_Module).l
                move.w  (Player_mode).w,d0
                moveq   #0,d1
                andi.w  #3,d0
                subq.w  #2,d0
                bmi.s   SKCredits_AddLockOnPoseStride
                beq.s   SKCredits_AddCharacterPoseStride
                addi.w  #$18,d1

SKCredits_AddCharacterPoseStride:
                addi.w  #$18,d1

SKCredits_AddLockOnPoseStride:
                tst.w   (SK_alone_flag).w
                bne.s   SKCredits_SelectCompletionPoseColumn
                addi.w  #$C,d1

SKCredits_SelectCompletionPoseColumn:
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   SKCredits_DispatchSelectedPoseLoader
                beq.s   SKCredits_AddFinalPoseStride
                addi.w  #4,d1

SKCredits_AddFinalPoseStride:
                addi.w  #4,d1

SKCredits_DispatchSelectedPoseLoader:
                movea.l SKCredits_PoseLoaderPointers(pc,d1.w),a2
                jmp     (a2)
; End of function SKCredits_QueueEndingPoseArt

; ---------------------------------------------------------------------------
SKCredits_PoseLoaderPointers:
                dc.l    SKCredits_QueueStandaloneBanner
                dc.l    SKCredits_QueueStandaloneBanner
                dc.l    SKCredits_QueueStandaloneBanner
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCredits_QueueLockOnBannerThenLoadS3
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCredits_QueueLockOnBannerThenLoadS3
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCredits_QueueLockOnBannerThenLoadS3
                dc.l    SKCredits_QueueStandaloneBanner
                dc.l    SKCredits_LoadKnuxAndStandaloneBanner
                dc.l    SKCredits_LoadKnuxAndStandaloneBanner
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCredits_LoadKnuxAndLockOnBanner
                dc.l    SKCredits_LoadS3ArtBeforeKnuxAndBanner
; ---------------------------------------------------------------------------

SKCredits_LoadKnuxAndStandaloneBanner:
                lea     PLC_CreditsKnuxPose(pc),a1
                jsr     (Load_PLC_Raw).l

SKCredits_QueueStandaloneBanner:
                lea     (ArtKosM_SKPoseBanner).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Logo),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

SKCredits_LoadS3ArtBeforeKnuxAndBanner:
                lea     PLC_S3EndingGraphics(pc),a1
                jsr     (Load_PLC_Raw).l

SKCredits_LoadKnuxAndLockOnBanner:
                lea     PLC_CreditsKnuxPose(pc),a1
                jsr     (Load_PLC_Raw).l

; =============== S U B R O U T I N E =======================================

SKCreditsQueueSonicThreePoseBannerArt:
                lea     (ArtKosM_S3PoseBanner).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Logo),d2
                jmp     (Queue_Kos_Module).l
; End of function SKCreditsQueueSonicThreePoseBannerArt

; ---------------------------------------------------------------------------

SKCredits_QueueLockOnBannerThenLoadS3:
                bsr.s   SKCreditsQueueSonicThreePoseBannerArt
                lea     PLC_S3EndingGraphics(pc),a1
                jmp     (Load_PLC_Raw).l

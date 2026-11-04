; Owner: game/level/zones/lrz/sk
; Responsibility: Lava Reef act-three screen and background events, deformation and coordinated scene objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LRZ3_ScreenInit:
                clr.w   (Camera_max_X_pos).w
                lea     (Player_1).w,a1
                cmpi.w  #$480,x_pos(a1)
                blo.s   SKLRZ3Events_RefreshInitialForeground
                lea     (Target_palette_line_2).w,a1
                lea     (Pal_LRZBossFire).l,a5
                moveq   #bytesToLcnt($60),d0

SKLRZ3Events_CopyPaletteAndSetLateStart:
                move.l  (a5)+,(a1)+
                dbf     d0,SKLRZ3Events_CopyPaletteAndSetLateStart

                .offset: set Stack_contents-(Target_palette_line_4+$20)
                move.w  #$9C0,.offset+$10(a1)
                move.w  #$36C,.offset+$14(a1)
                move.w  #$920,d0
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_X_pos).w
                clr.w   (Camera_X_pos+2).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  #$2F0,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_Y_pos).w
                clr.w   (Camera_Y_pos+2).w
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$14,(Special_events_routine).w
                move.w  #$10,(Events_bg+$00).w
                move.w  #$2D,(Events_bg+$02).w
                move.w  #$C,(Events_routine_fg).w

SKLRZ3Events_RefreshInitialForeground:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

LRZ3_ScreenEvent:
                move.w  (Events_routine_fg).w,d0
                jmp     LRZ3_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ3_ScreenEvent_Index:
                bra.w   SKLRZ3Events_TryRestoreSavedRings
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_RefreshLivesAndCheckLayout
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_TryEnableAutoscroll
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ApplyImpactChunkRequest
; ---------------------------------------------------------------------------

SKLRZ3Events_TryRestoreSavedRings:
                move.w  (Act3_ring_count).w,d0
                beq.s   SKLRZ3Events_TryRestoreSavedTimer
                clr.w   (Act3_ring_count).w
                move.w  d0,(Ring_count).w
                move.b  #1,(Update_HUD_ring_count).w

SKLRZ3Events_TryRestoreSavedTimer:
                move.l  (Act3_timer).w,d0
                beq.s   SKLRZ3Events_AdvanceForegroundState
                clr.l   (Act3_timer).w
                move.l  d0,(Timer).w
                st      (Update_HUD_timer).w

SKLRZ3Events_AdvanceForegroundState:
                addq.w  #4,(Events_routine_fg).w

SKLRZ3Events_RefreshLivesAndCheckLayout:
                move.b  #1,(Update_HUD_life_count).w
                tst.w   (Events_fg_4).w
                beq.s   SKLRZ3Events_TryPinCameraMinY
                clr.w   (Events_fg_4).w
                movea.w $24(a3),a1
                move.b  #$16,(a1)+
                move.b  #$15,(a1)+
                move.b  #$16,(a1)+
                move.b  #$15,(a1)+
                move.b  #$16,(a1)
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

SKLRZ3Events_TryPinCameraMinY:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SKLRZ3Events_ApplyImpactChunkRequest
                move.w  d0,(Camera_min_Y_pos).w
                bra.s   SKLRZ3Events_ApplyImpactChunkRequest
; ---------------------------------------------------------------------------

SKLRZ3Events_TryEnableAutoscroll:
                tst.w   (Events_fg_4).w
                beq.s   SKLRZ3Events_ApplyImpactChunkRequest
                clr.w   (Events_fg_4).w
                clr.w   (Camera_X_pos+2).w
                clr.w   (Camera_Y_pos+2).w
                move.w  #$14,(Special_events_routine).w
                addq.w  #4,(Events_routine_fg).w

SKLRZ3Events_ApplyImpactChunkRequest:
                move.w  (Events_bg+$0C).w,d1
                beq.s   SKLRZ3Events_DrawForeground
                move.w  d1,d3
                lsr.w   #7,d3
                move.w  (Events_bg+$0E).w,d0
                move.w  d0,d2
                lsr.w   #5,d2
                andi.w  #$FFFC,d2
                movea.w (a3,d2.w),a1
                move.b  #$17,(a1,d3.w)
                move.b  #$17,1(a1,d3.w)
                moveq   #-$80,d2
                and.w   d2,d0
                and.w   d2,d1
                moveq   #$30,d2
                add.w   d2,d0
                add.w   d2,d1
                moveq   #$A,d6
                moveq   #5-1,d2

SKLRZ3Events_DrawImpactRowsAndClearX:
                movem.w d0-d2/d6,-(sp)
                jsr     (Setup_TileRowDraw).l
                movem.w (sp)+,d0-d2/d6
                addi.w  #$10,d0
                dbf     d2,SKLRZ3Events_DrawImpactRowsAndClearX
                clr.w   (Events_bg+$0C).w

SKLRZ3Events_DrawForeground:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

LRZ3_BackgroundInit:
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Events_InitArenaColumnState
                move.l  #LRZ3HazardSurface_Initialize,(a1)

SKLRZ3Events_InitArenaColumnState:
                lea     (HScroll_table).w,a1
                move.l  #$600050,d0
                moveq   #$14-1,d1

SKLRZ3Events_InitColumnOffsetPairs:
                move.l  d0,(a1)+
                dbf     d1,SKLRZ3Events_InitColumnOffsetPairs
                lea     (HScroll_table+$100).w,a1
                move.l  #$30303030,d0
                moveq   #$30-1,d1

SKLRZ3Events_FillSlopeAndRefresh:
                move.l  d0,(a1)+
                dbf     d1,SKLRZ3Events_FillSlopeAndRefresh
                move.w  (a3),$7C(a3)
                jsr     PositionLrz3DistantBackground(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                jsr     (Refresh_PlaneFull).l
                jmp     ApplyLrz3HeatRippleOrPlainScroll(pc)
; ---------------------------------------------------------------------------

LRZ3_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     LRZ3_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ3_BackgroundEvent_Index:
                bra.w   SKLRZ3Events_TryEnterArenaApproach
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_CheckArenaCameraTrigger
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_PositionReturnBackground
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_CheckArenaColumnExit
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_DrawSteadyArena
; ---------------------------------------------------------------------------

SKLRZ3Events_TryEnterArenaApproach:
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   SKLRZ3Events_PositionDistantBackground
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKLRZ3Events_CheckArenaCameraTrigger
; ---------------------------------------------------------------------------

SKLRZ3Events_PositionDistantBackground:
                jsr     PositionLrz3DistantBackground(pc)

SKLRZ3Events_DrawAndRestoreCachedPos:
                jsr     (DrawBGAsYouMove).l
                move.w  (Events_bg+$04).w,d0
                beq.s   SKLRZ3Events_ComposeHeatOrPlainScroll
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Events_bg+$06).w,(Camera_Y_pos_BG_copy).w

SKLRZ3Events_ComposeHeatOrPlainScroll:
                jmp     ApplyLrz3HeatRippleOrPlainScroll(pc)
; ---------------------------------------------------------------------------

SKLRZ3Events_CheckArenaCameraTrigger:
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   SKLRZ3Events_CacheArenaAndBeginReturn
                cmpi.w  #$A00,(Camera_X_pos).w
                bne.s   SKLRZ3Events_DrawArenaBeforeTrigger
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SKLRZ3Events_DrawArenaBeforeTrigger
                move.w  #$A00,(Camera_max_X_pos).w
                move.w  d0,(Camera_min_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Events_EnableColumnVInt
                move.l  #Obj_LRZEndBoss,(a1)

; Enable column updates even if the boss allocation failed
SKLRZ3Events_EnableColumnVInt:
                move.w  #4,(Special_V_int_routine).w
                addq.w  #8,(Events_routine_bg).w
                bra.s   SKLRZ3Events_CheckArenaColumnExit
; ---------------------------------------------------------------------------

SKLRZ3Events_DrawArenaBeforeTrigger:
                jsr     PositionLrz3BossArenaBackground(pc)
                jsr     (DrawBGAsYouMove).l
                jmp     ApplyLrz3HeatRippleOrPlainScroll(pc)
; ---------------------------------------------------------------------------

SKLRZ3Events_CacheArenaAndBeginReturn:
                move.w  (Camera_X_pos_BG_copy).w,(Events_bg+$04).w
                move.w  (Camera_Y_pos_BG_copy).w,(Events_bg+$06).w
                jsr     PositionLrz3DistantBackground(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKLRZ3Events_RedrawReturnTopDown
; ---------------------------------------------------------------------------

SKLRZ3Events_PositionReturnBackground:
                jsr     PositionLrz3DistantBackground(pc)

SKLRZ3Events_RedrawReturnTopDown:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertTopDown).l
                bpl.w   SKLRZ3Events_DrawAndRestoreCachedPos
                clr.w   (Events_bg+$04).w
                clr.w   (Events_routine_bg).w
                bra.w   SKLRZ3Events_DrawAndRestoreCachedPos
; ---------------------------------------------------------------------------

SKLRZ3Events_CheckArenaColumnExit:
                tst.w   (Events_fg_5).w
                beq.s   SKLRZ3Events_DrawArenaColumnBands
                tst.w   (Events_bg+$0A).w
                beq.s   SKLRZ3Events_EndColumnVIntMode

SKLRZ3Events_DrawArenaColumnBands:
                jsr     BuildLrz3ArenaColumnScroll(pc)
                lea     SKLRZ3Events_ColumnDeformationSpans(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$F,d6
                moveq   #$14,d5
                jsr     (DrawTilesVDeform2).l
                jsr     ApplyLrz3HeatRippleOrPlainScroll(pc)
                lea     (Vscroll_buffer).w,a1
                lea     (HScroll_table).w,a5
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                moveq   #$14-1,d1

SKLRZ3Events_WriteVerticalScrollPairs:
                move.w  (a5),d0
                move.l  d0,(a1)+
                addq.w  #4,a5
                dbf     d1,SKLRZ3Events_WriteVerticalScrollPairs
                rts
; ---------------------------------------------------------------------------

SKLRZ3Events_EndColumnVIntMode:
                clr.w   (Events_fg_5).w
                move.w  #$C,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_bg).w

SKLRZ3Events_DrawSteadyArena:
                jsr     PositionLrz3BossArenaBackground(pc)
                jsr     (DrawBGAsYouMove).l
                jmp     ApplyLrz3HeatRippleOrPlainScroll(pc)

; =============== S U B R O U T I N E =======================================

PositionLrz3DistantBackground:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #4,d0
                addi.w  #$10,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #4,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                asr.w   #1,d0
                move.w  d0,(Events_bg+$12).w
                rts
; End of function PositionLrz3DistantBackground

; =============== S U B R O U T I N E =======================================

PositionLrz3BossArenaBackground:
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$700,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$500,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                rts
; End of function PositionLrz3BossArenaBackground

; =============== S U B R O U T I N E =======================================

BuildLrz3ArenaColumnScroll:
                bsr.s   PositionLrz3BossArenaBackground
                lea     (HScroll_table).w,a1
                lea     $113(a1),a5
                moveq   #$30,d1
                moveq   #$14-1,d2

SKLRZ3Events_SampleSlopeForColumns:
                moveq   #0,d3
                move.b  (a5),d3
                sub.w   d1,d3
                add.w   d0,d3
                move.w  d3,(a1)
                addq.w  #4,a1
                addq.w  #8,a5
                dbf     d2,SKLRZ3Events_SampleSlopeForColumns
                rts
; End of function BuildLrz3ArenaColumnScroll

; =============== S U B R O U T I N E =======================================

ApplyLrz3HeatRippleOrPlainScroll:
                tst.b   (End_of_level_flag).w
                bne.s   SKLRZ3Events_ApplyPlainScroll
                tst.b   (_unkFACD).w
                bne.s   SKLRZ3Events_ApplyPlainScroll
                cmpi.w  #8,(Events_routine_fg).w
                bhs.s   SKLRZ3Events_BindHeatWaveReaders

SKLRZ3Events_ApplyPlainScroll:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SKLRZ3Events_BindHeatWaveReaders:
                lea     (H_scroll_buffer).w,a1
                lea     (AIZ2_SOZ1_LRZ3_FGDeformDelta).l,a5
                lea     (a5),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Level_frame_counter).w,d1
                add.w   d1,d1
                add.w   d1,d0
                andi.w  #$3E,d0
                adda.w  d0,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                asr.w   #1,d1
                add.w   d1,d0
                andi.w  #$3E,d0
                adda.w  d0,a6
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                neg.w   d1
                move.w  #$E0-1,d2

SKLRZ3Events_WriteHeatScrollPairs:
                move.w  (a5)+,d3
                add.w   d0,d3
                move.w  d3,(a1)+
                move.w  (a6)+,d3
                add.w   d1,d3
                move.w  d3,(a1)+
                dbf     d2,SKLRZ3Events_WriteHeatScrollPairs
                rts
; End of function ApplyLrz3HeatRippleOrPlainScroll

; ---------------------------------------------------------------------------

SKLRZ3Events_TickAutoscrollDelay:
                tst.w   (Events_bg+$02).w
                beq.s   SKLRZ3Events_LockAndDispatchAutoscroll
                subq.w  #1,(Events_bg+$02).w
                rts
; ---------------------------------------------------------------------------

SKLRZ3Events_LockAndDispatchAutoscroll:
                st      (Scroll_lock).w
                move.w  (Events_bg+$00).w,d0
                jmp     SKLRZ3Events_AutoscrollBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SKLRZ3Events_AutoscrollBranches:
                bra.w   SKLRZ3Events_ScrollRightToX0410
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ScrollUpRightToY0330
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ScrollRightToX0650
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ScrollUpRightToY02F0
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ScrollRightToX0910
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_ScrollDownRightToY0320
; ---------------------------------------------------------------------------
                bra.w   SKLRZ3Events_CheckAutoscrollFinish
; ---------------------------------------------------------------------------

SKLRZ3Events_ScrollRightToX0410:
                move.l  #$20000,d2
                moveq   #0,d1
                cmpi.w  #$410,(Camera_X_pos).w
                blo.w   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_ScrollUpRightToY0330:
                move.l  #$16A00,d2
                move.l  d2,d1
                neg.l   d1
                cmpi.w  #$330,(Camera_Y_pos).w
                bhi.w   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_ScrollRightToX0650:
                move.l  #$20000,d2
                moveq   #0,d1
                cmpi.w  #$650,(Camera_X_pos).w
                blo.w   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_ScrollUpRightToY02F0:
                move.l  #$16A00,d2
                move.l  d2,d1
                neg.l   d1
                cmpi.w  #$2F0,(Camera_Y_pos).w
                bhi.s   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_ScrollRightToX0910:
                move.l  #$20000,d2
                moveq   #0,d1
                cmpi.w  #$910,(Camera_X_pos).w
                blo.s   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_ScrollDownRightToY0320:
                move.l  #$1D900,d2
                move.l  #$C400,d1
                cmpi.w  #$320,(Camera_Y_pos).w
                blo.s   SKLRZ3Events_MoveCameraAndClampPlayers
                addq.w  #4,(Events_bg+$00).w

SKLRZ3Events_CheckAutoscrollFinish:
                move.l  #$20000,d2
                moveq   #0,d1
                cmpi.w  #$BBF,(Camera_X_pos).w
                blo.s   SKLRZ3Events_MoveCameraAndClampPlayers
                moveq   #0,d2
                cmpi.w  #$C50,(Player_1+x_pos).w
                blo.s   SKLRZ3Events_MoveCameraAndClampPlayers
                move.w  #$A00,(Camera_min_X_pos).w
                move.w  #$BC0,(Camera_max_X_pos).w
                move.w  #$560,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                clr.b   (Scroll_lock).w
                clr.w   (Special_events_routine).w
                rts
; ---------------------------------------------------------------------------

; Restore the camera X and step with MOVEM.W before constraining P2. This sign-extends the step's low word
SKLRZ3Events_MoveCameraAndClampPlayers:
                add.l   d1,(Camera_Y_pos).w
                move.w  (Camera_Y_pos).w,d1
                move.w  d1,(Camera_Y_pos).w
                move.w  d1,(Camera_Y_pos_copy).w
                move.w  d1,(Camera_min_Y_pos).w
                move.w  d1,(Camera_max_Y_pos).w
                move.w  d1,(Camera_target_max_Y_pos).w
                add.l   d2,(Camera_X_pos).w
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                movem.w d0/d2,-(sp)
                lea     (Player_1).w,a1
                bsr.s   ConstrainPlayerDuringLrz3Autoscroll
                movem.w (sp)+,d0/d2
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

ConstrainPlayerDuringLrz3Autoscroll:
                cmpi.b  #5,anim(a1)
                bne.s   SKLRZ3Events_CheckLeftMarginOrCrush
                clr.b   anim(a1)

SKLRZ3Events_CheckLeftMarginOrCrush:
                addi.w  #$10,d0
                cmp.w   x_pos(a1),d0
                bls.s   SKLRZ3Events_TryClampRight
                btst    #Status_Push,status(a1)
                beq.s   SKLRZ3Events_ClampLeftAndSetSpeed
                lea     (a1),a0
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

SKLRZ3Events_ClampLeftAndSetSpeed:
                move.w  d0,x_pos(a1)
                asr.l   #8,d2
                move.w  d2,ground_vel(a1)
                bra.s   SKLRZ3Events_PlayerClampReturn
; ---------------------------------------------------------------------------

SKLRZ3Events_TryClampRight:
                addi.w  #$110,d0
                cmp.w   x_pos(a1),d0
                bhi.s   SKLRZ3Events_PlayerClampReturn
                move.w  d0,x_pos(a1)

SKLRZ3Events_PlayerClampReturn:
                rts
; End of function ConstrainPlayerDuringLrz3Autoscroll

; ---------------------------------------------------------------------------

LRZ3HazardSurface_Initialize:
                move.l  #SKLRZ3Events_SelectHazardCollision,(a0)
                move.b  #$C0,height_pixels(a0)
                move.w  #$640,y_pos(a0)
                bset    #7,status(a0)

SKLRZ3Events_SelectHazardCollision:
                cmpi.w  #$C,(Events_routine_bg).w
                bne.w   LRZ3HazardSurface_ApplyFlatCollision
                move.w  (Events_bg+$0A).w,d0
                tst.b   (Events_bg+$09).w
                beq.s   LRZ3HazardSurface_DecreaseTiltAmplitude
                cmpi.w  #$80,d0
                bhs.s   LRZ3HazardSurface_PrepareSlopeProfile
                addq.w  #1,d0
                bra.s   LRZ3HazardSurface_PrepareSlopeProfile
; ---------------------------------------------------------------------------

LRZ3HazardSurface_DecreaseTiltAmplitude:
                tst.w   d0
                beq.s   LRZ3HazardSurface_PrepareSlopeProfile
                subq.w  #1,d0

LRZ3HazardSurface_PrepareSlopeProfile:
                move.w  d0,(Events_bg+$0A).w
                swap    d0
                clr.w   d0
                asr.l   #8,d0
                move.w  d0,d1
                swap    d0
                moveq   #$30,d2
                moveq   #0,d3
                move.w  #$B0-1,d4
                tst.b   (Events_bg+$08).w
                bne.s   SKLRZ3Events_BindReverseSlopeBuffer
                lea     (HScroll_table+$110).w,a1

LRZ3HazardSurface_WriteForwardMainSlope:
                move.b  d2,(a1)+
                add.w   d1,d3
                addx.w  d0,d2
                dbf     d4,LRZ3HazardSurface_WriteForwardMainSlope
                moveq   #$30,d2
                moveq   #0,d3
                moveq   #$10-1,d4
                lea     (HScroll_table+$110).w,a1

SKLRZ3Events_WriteSlopeBackward:
                sub.w   d1,d3
                subx.w  d0,d2
                move.b  d2,-(a1)
                dbf     d4,SKLRZ3Events_WriteSlopeBackward
                bra.s   SKLRZ3Events_ApplySlopedTopSolid
; ---------------------------------------------------------------------------

SKLRZ3Events_BindReverseSlopeBuffer:
                lea     (HScroll_table+$1B0).w,a1

LRZ3HazardSurface_WriteReverseMainSlope:
                move.b  d2,-(a1)
                add.w   d1,d3
                addx.w  d0,d2
                dbf     d4,LRZ3HazardSurface_WriteReverseMainSlope
                moveq   #$30,d2
                moveq   #0,d3
                moveq   #$10-1,d4
                lea     (HScroll_table+$1B0).w,a1

SKLRZ3Events_WriteSlopeForward:
                sub.w   d1,d3
                subx.w  d0,d2
                move.b  d2,(a1)+
                dbf     d4,SKLRZ3Events_WriteSlopeForward

SKLRZ3Events_ApplySlopedTopSolid:
                move.w  #$A0,d1
                lea     (HScroll_table+$110).w,a2
                move.w  #$AA0,d4
                move.w  d4,x_pos(a0)
                jsr     (SolidObjectTopSloped2).l
                bra.s   SKLRZ3Events_CalcRiderDrift
; ---------------------------------------------------------------------------

LRZ3HazardSurface_ApplyFlatCollision:
                move.w  #$180,d1
                move.w  #$40,d2
                move.w  #$30,d3
                move.w  #$B80,d4
                move.w  d4,x_pos(a0)
                jsr     (SolidObjectTop).l

SKLRZ3Events_CalcRiderDrift:
                move.w  (Events_bg+$0A).w,d0
                swap    d0
                clr.w   d0
                lsr.l   #7,d0
                move.l  d0,d1
                lsr.l   #1,d1
                add.l   d1,d0
                tst.b   (Events_bg+$08).w
                bne.s   SKLRZ3Events_StoreDriftAndCheckP1
                neg.l   d0

SKLRZ3Events_StoreDriftAndCheckP1:
                move.l  d0,(Events_bg+$14).w
                btst    #p1_standing_bit,status(a0)
                beq.s   LRZ3HazardSurface_CheckSecondaryHazard
                lea     (Player_1).w,a1
                tst.b   (End_of_level_flag).w
                bne.s   LRZ3HazardSurface_DisplacePrimaryRider
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   LRZ3HazardSurface_DisplacePrimaryRider
                tst.b   (_unkFACD).w
                bne.s   LRZ3HazardSurface_DisplacePrimaryRider
                jsr     (HurtPlayerFromSolidHazard).l

LRZ3HazardSurface_DisplacePrimaryRider:
                move.l  (Events_bg+$14).w,d0
                add.l   d0,x_pos(a1)

LRZ3HazardSurface_CheckSecondaryHazard:
                btst    #p2_standing_bit,status(a0)
                beq.s   LRZ3HazardSurface_ReturnFromUpdate
                lea     (Player_2).w,a1
                tst.b   (End_of_level_flag).w
                bne.s   LRZ3HazardSurface_DisplaceSecondaryRider
                tst.b   (_unkFACD).w
                bne.s   LRZ3HazardSurface_DisplaceSecondaryRider
                jsr     (HurtPlayerFromSolidHazard).l

LRZ3HazardSurface_DisplaceSecondaryRider:
                move.l  (Events_bg+$14).w,d0
                add.l   d0,x_pos(a1)

LRZ3HazardSurface_ReturnFromUpdate:
                rts
; ---------------------------------------------------------------------------
SKLRZ3Events_ColumnDeformationSpans:
                dc.w    $310,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10
                dc.w    $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10, $7FFF

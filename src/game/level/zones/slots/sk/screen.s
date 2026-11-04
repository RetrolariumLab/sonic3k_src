; Owner: game/level/zones/slots/sk
; Responsibility: Rotating slot bonus screen setup, progression events and background control
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Slots_ScreenInit:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w
                rts
; ---------------------------------------------------------------------------

Slots_ScreenEvent:
                move.w  (Events_routine_fg).w,d0
                jmp     Slots_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Slots_ScreenEvent_Index:
                bra.w   SlotsScreen_InitPrivateForegroundPos
; ---------------------------------------------------------------------------
                bra.w   SlotsScreen_ApproachFGCenterAndDrawEdges
; ---------------------------------------------------------------------------

SlotsScreen_InitPrivateForegroundPos:
                addq.w  #4,(Events_routine_fg).w
                move.w  #$400,d1
                sub.w   (Events_bg+$00).w,d1
                add.w   (Camera_X_pos_copy).w,d1
                move.w  d1,(_unkEE98).w
                andi.w  #$FFF0,d1
                move.w  d1,(_unkEEA0).w
                move.w  #$400,d0
                sub.w   (Events_bg+$02).w,d0
                add.w   (Camera_Y_pos_copy).w,d0
                move.w  d0,(_unkEE9C).w
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(_unkEEA2).w
                jmp     (Refresh_PlaneDirect).l
; ---------------------------------------------------------------------------

SlotsScreen_ApproachFGCenterAndDrawEdges:
                moveq   #$20,d1
                move.w  #$400,d0
                sub.w   (Events_bg+$00).w,d0
                add.w   (Camera_X_pos_copy).w,d0
                lea     (_unkEE98).w,a1
                bsr.s   ApproachSlotsPlaneCoordinateByLimit
                move.w  #$400,d0
                sub.w   (Events_bg+$02).w,d0
                add.w   (Camera_Y_pos_copy).w,d0
                lea     (_unkEE9C).w,a1
                bsr.s   ApproachSlotsPlaneCoordinateByLimit
                lea     (_unkEE98).w,a6
                lea     (_unkEEA0).w,a5
                move.w  (_unkEE9C).w,d1
                moveq   #$F,d6
                jsr     (Draw_TileColumn).l
                lea     (_unkEE9C).w,a6
                lea     (_unkEEA2).w,a5
                move.w  (_unkEE98).w,d1
                moveq   #$15,d6
                jmp     (Draw_TileRow).l

; =============== S U B R O U T I N E =======================================

ApproachSlotsPlaneCoordinateByLimit:
                sub.w   (a1),d0
                smi     d2
                bpl.s   SlotsScreen_LimitAbsoluteCoordDelta
                neg.w   d0

SlotsScreen_LimitAbsoluteCoordDelta:
                cmp.w   d1,d0
                bls.s   SlotsScreen_RestoreCoordDeltaSign
                move.w  d1,d0

SlotsScreen_RestoreCoordDeltaSign:
                tst.b   d2
                beq.s   SlotsScreen_ApplyLimitedCoordStep
                neg.w   d0

SlotsScreen_ApplyLimitedCoordStep:
                add.w   d0,(a1)
                rts
; End of function ApproachSlotsPlaneCoordinateByLimit

; ---------------------------------------------------------------------------

Slots_BackgroundInit:
                lea     (HScroll_table).w,a1
                moveq   #$80-1,d0

SlotsScreen_ClearScrollAndRefreshBG:
                clr.l   (a1)+
                dbf     d0,SlotsScreen_ClearScrollAndRefreshBG
                moveq   #0,d1
                moveq   #0,d0
                move.l  d0,(Camera_Y_pos_BG_copy).w
                jsr     (Refresh_PlaneFull).l
                jmp     SlotsScreen_Compose224ScrollRows(pc)
; ---------------------------------------------------------------------------

Slots_BackgroundEvent:
                move.l  #$400,d0
                tst.w   (SStage_scalar_index_1).w
                bpl.s   SlotsScreen_AccelerateVerticalDrift
                neg.l   d0

SlotsScreen_AccelerateVerticalDrift:
                add.l   (Events_bg+$06).w,d0
                move.l  #$8000,d1
                cmp.l   d1,d0
                bgt.s   SlotsScreen_SelectSignedDriftLimit
                neg.l   d1
                cmp.l   d1,d0
                bge.s   SlotsScreen_IntegrateBGYAndInitCommands

SlotsScreen_SelectSignedDriftLimit:
                move.l  d1,d0

SlotsScreen_IntegrateBGYAndInitCommands:
                move.l  d0,(Events_bg+$06).w
                add.l   d0,(Camera_Y_pos_BG_copy).w
                andi.w  #$FF,(Camera_Y_pos_BG_copy).w
                lea     ((RAM_start+$1000)&$FFFFFF).l,a0
                move.l  a0,(Plane_buffer_2_addr).w
                clr.w   (a0)
                clr.w   (Events_bg+$04).w
                lea     SlotsScreen_BandMotionAndTileRecords(pc),a5
                lea     (HScroll_table+$020).w,a6
                moveq   #8-1,d6

SlotsScreen_IntegrateBandPhase:
                move.l  a5,-(sp)
                move.w  d6,-(sp)
                move.w  (a5),d0
                move.l  2(a5),d1
                add.l   d1,(a6)
                bcc.s   SlotsScreen_WrapBandPhaseAtPeriod
                add.w   d0,(a6)
                bra.s   SlotsScreen_MarkBandPhaseWrapped
; ---------------------------------------------------------------------------

SlotsScreen_WrapBandPhaseAtPeriod:
                move.w  (a6),d1
                sub.w   d0,d1
                bcs.s   SlotsScreen_ThrottleBandAnimation
                move.w  d1,(a6)

SlotsScreen_MarkBandPhaseWrapped:
                st      $A(a6)

SlotsScreen_ThrottleBandAnimation:
                move.w  $A(a5),d5
                beq.s   SlotsScreen_TickBandTimerOrWrap
                tst.w   (Events_bg+$04).w
                bne.w   SlotsScreen_AdvanceDescriptorAndState

SlotsScreen_TickBandTimerOrWrap:
                subq.w  #1,4(a6)
                bmi.s   SlotsScreen_ReloadBandTimer
                tst.w   $A(a6)
                beq.s   SlotsScreen_AdvanceDescriptorAndState
                bra.s   SlotsScreen_AdvanceBandFrameAndWrap
; ---------------------------------------------------------------------------

SlotsScreen_ReloadBandTimer:
                move.w  6(a5),4(a6)

SlotsScreen_AdvanceBandFrameAndWrap:
                move.w  6(a6),d0
                addq.w  #1,d0
                cmp.w   8(a5),d0
                blo.s   SlotsScreen_StoreBandFrameAndPickUpdate
                moveq   #0,d0

SlotsScreen_StoreBandFrameAndPickUpdate:
                move.w  d0,6(a6)
                clr.w   $A(a6)
                st      (Events_bg+$04).w
                tst.w   d5
                bne.s   SlotsScreen_OffsetDestinationOnOddFrame
                move.w  (a5),d0
                add.w   d0,8(a6)
                bra.s   SlotsScreen_AdvanceDescriptorAndState
; ---------------------------------------------------------------------------

SlotsScreen_OffsetDestinationOnOddFrame:
                btst    #0,7(a6)
                beq.s   SlotsScreen_PrepFramePeriodProduct
                add.w   $C(a5),d5

SlotsScreen_PrepFramePeriodProduct:
                moveq   #0,d1
                move.w  (a5),d2
                move.w  6(a6),d3
                subq.w  #1,d3
                bcs.s   SlotsScreen_AppendBandTileRowCommands

SlotsScreen_AddPeriodPerSourceFrame:
                add.w   d2,d1
                dbf     d3,SlotsScreen_AddPeriodPerSourceFrame

SlotsScreen_AppendBandTileRowCommands:
                move.w  $10(a5),d0
                move.w  $12(a5),d6
                movem.l d1/d5-d6/a5,-(sp)
                jsr     (SetupExplicitTileRowDraw).l
                movem.l (sp)+,d1/d5-d6/a5
                tst.w   $E(a5)
                beq.s   SlotsScreen_AdvanceDescriptorAndState
                addi.w  #$10,d0
                addi.w  #$100,d5
                jsr     (SetupExplicitTileRowDraw).l

SlotsScreen_AdvanceDescriptorAndState:
                move.w  (sp)+,d6
                movea.l (sp)+,a5
                lea     $14(a5),a5
                lea     $C(a6),a6
                dbf     d6,SlotsScreen_IntegrateBandPhase
                lea     (HScroll_table).w,a1
                lea     (HScroll_table+$020).w,a5
                moveq   #8-1,d0

SlotsScreen_WriteAndDuplicateBandScroll:
                move.w  (a5),d1
                add.w   8(a5),d1
                move.w  d1,(a1)+
                move.w  d1,$E(a1)
                lea     $C(a5),a5
                dbf     d0,SlotsScreen_WriteAndDuplicateBandScroll

; The tail discards the callback return address to bypass the default scroll continuation
SlotsScreen_Compose224ScrollRows:
                lea     Slots_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                lea     (H_scroll_buffer).w,a1
                move.w  (_unkEE98).w,d3
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  #$E0-1,d1
                jsr     (ApplyDeformation2).l
                move.w  (_unkEE9C).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------
Slots_BGDeformArray:
                dc.w    $20,   $20,   $20,   $20,   $30,   $20,   $10,   $20
                dc.w    $20,   $20,   $20,   $20,   $30,   $20,   $10, $7FFF
SlotsScreen_BandMotionAndTileRecords:
                dc.w    $48,     0, $C000,     8,     8, $E000, $FFFE,     1,     0,   $19
                dc.w    $48,     0, $C000,     9,     8, $E200, $FFFE,     1,   $20,   $19
                dc.w    $50,     0, $A000,    $B,   $10, $E400,     0,     1,   $40,   $19
                dc.w    $40,     0, $E000,     4,     8,     0,     0,     0,     0,     0
                dc.w    $40,     1,     0,     3,     8,     0,     0,     0,     0,     0
                dc.w    $48,     0, $C000,    $A,     8, $EB00, $FFFE,     1,   $B0,   $19
                dc.w    $58,     0, $8000,     7,     4, $ED00, $FFFE,     0,   $D0,   $19
                dc.w    $40,     0, $E000,     5,     8,     0,     0,     0,     0,     0

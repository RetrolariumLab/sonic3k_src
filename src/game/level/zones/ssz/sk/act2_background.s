; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-two background initialization, event state, deformation and private records
; Source provenance and ranges: config/reconstruction/source_layout.json
SSZ2_DeformArray:
                dc.w    $800
                dc.w    $24
                dc.w    4
                dc.w    $14
                dc.w    4
                dc.w    $1C
                dc.w    4
                dc.w    $20
                dc.w    $8080
                dc.w    $7FFF
SSZ2_BGDeformArray:
                dc.w    $120
                dc.w    8
                dc.w    8
                dc.w    4
                dc.w    4
                dc.w    8
                dc.w    8
                dc.w    $18
                dc.w    $10
                dc.w    $10
                dc.w    $7FFF
; ---------------------------------------------------------------------------

SSZ2_BackgroundInit:
                clr.l   (SceneAuxiliaryYOrVerticalMotion).w
                jsr     BuildSsz2EndingStageScrollTables(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     ComposeSsz2EndingScrollBuffersByStage(pc)
; ---------------------------------------------------------------------------

SSZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SSZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ2_BackgroundEvent_Index:
                bra.w   SKSSZ2BG_DrawEndingBackground
; ---------------------------------------------------------------------------
                lea     (Level_layout_main).w,a3

SKSSZ2BG_DrawEndingBackground:
                jsr     BuildSsz2EndingStageScrollTables(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jsr     ComposeSsz2EndingScrollBuffersByStage(pc)
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

BuildSsz2EndingStageScrollTables:
                tst.w   (Events_routine_bg).w
                beq.s   SKSSZ2BG_SelectEndingScrollTables

SKSSZ2BG_AdvancePanoramaDrift:
                lea     (HScroll_table).w,a1
                move.l  (a1),d0
                addi.l  #$8000,(a1)+
                lea     $16(a1),a1
                move.w  #$5E,-(a1)
                clr.w   d0
                move.l  d0,d1
                asr.l   #3,d1
                moveq   #8-1,d2

SKSSZ2BG_WritePanoramaBands:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,SKSSZ2BG_WritePanoramaBands
                rts
; ---------------------------------------------------------------------------

SKSSZ2BG_SelectEndingScrollTables:
                cmpi.w  #$18,(Events_routine_fg).w
                bhs.w   SKSSZ2BG_BeginLateForegroundBands
                cmpi.w  #$C,(Events_routine_fg).w
                bhs.w   SKSSZ2BG_ScrollTableReturn
                lea     (HScroll_table).w,a1
                move.l  (a1),d2
                addi.l  #$1000,(a1)+
                clr.w   (a1)+
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d1
                asr.l   #1,d0
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1)
                move.w  d0,4(a1)
                move.w  d0,8(a1)
                move.w  d0,$10(a1)
                move.w  d0,$36(a1)
                move.w  d0,$3A(a1)
                move.w  d0,$3E(a1)
                move.w  d0,$46(a1)
                swap    d0
                add.l   d2,d1
                add.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                move.w  d0,$A(a1)
                move.w  d0,$E(a1)
                move.w  d0,$14(a1)
                move.w  d0,$3C(a1)
                move.w  d0,$40(a1)
                move.w  d0,$44(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                move.w  d0,$C(a1)
                move.w  d0,$16(a1)
                move.w  d0,$34(a1)
                move.w  d0,$38(a1)
                move.w  d0,$42(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$12(a1)
                swap    d0
                lea     $18(a1),a1
                moveq   #9-1,d2

SKSSZ2BG_WriteEarlyParallaxBands:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,SKSSZ2BG_WriteEarlyParallaxBands
                cmpi.w  #4,(Events_routine_fg).w
                bhi.s   SKSSZ2BG_ReorderEarlyBands
                lea     (HScroll_table+$02A).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                moveq   #9-1,d1

SKSSZ2BG_FillBandsFromCameraX:
                move.w  d0,(a1)+
                dbf     d1,SKSSZ2BG_FillBandsFromCameraX
                bra.s   SKSSZ2BG_CalcEarlyBackgroundY
; ---------------------------------------------------------------------------

SKSSZ2BG_ReorderEarlyBands:
                lea     (HScroll_table+$004).w,a1
                move.w  $2A(a1),$2C(a1)
                move.w  $28(a1),d0
                move.w  d0,$2A(a1)
                move.w  d0,$2E(a1)
                move.w  $26(a1),$28(a1)
                move.w  $24(a1),$26(a1)
                move.w  $22(a1),$30(a1)
                move.w  $1E(a1),$32(a1)
                move.w  $1A(a1),$34(a1)

SKSSZ2BG_CalcEarlyBackgroundY:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$320,d0
                sub.w   (SceneAuxiliaryYOrVerticalMotion).w,d0
                move.w  (Special_V_int_routine).w,d1
                subq.w  #4,d1
                beq.s   SKSSZ2BG_SetEarlyPosAndBindRamp
                subq.w  #4,d1
                beq.s   SKSSZ2BG_SetEarlyPosAndBindRamp
                addq.w  #8,d0

SKSSZ2BG_SetEarlyPosAndBindRamp:
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  #$5E,(Camera_X_pos_BG_copy).w
                lea     (HScroll_table+$0D0).w,a5
                lea     (a5),a6
                move.w  (Events_bg+$00).w,d0
                smi     d6
                bpl.s   SKSSZ2BG_CalcHorizontalRampStep
                neg.w   d0

SKSSZ2BG_CalcHorizontalRampStep:
                swap    d0
                clr.w   d0
                asr.l   #7,d0
                move.w  d0,d1
                swap    d0
                moveq   #0,d2
                moveq   #0,d3
                moveq   #$40-1,d4
                tst.b   d6
                bne.s   SKSSZ2BG_WriteHorizontalRampRight

SKSSZ2BG_WriteHorizontalRampLeft:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,-(a5)
                move.w  d2,d5
                neg.w   d5
                move.w  d5,(a6)+
                dbf     d4,SKSSZ2BG_WriteHorizontalRampLeft
                bra.s   SKSSZ2BG_BindVerticalRamp
; ---------------------------------------------------------------------------

SKSSZ2BG_WriteHorizontalRampRight:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,(a6)+
                move.w  d2,d5
                neg.w   d5
                move.w  d5,-(a5)
                dbf     d4,SKSSZ2BG_WriteHorizontalRampRight

SKSSZ2BG_BindVerticalRamp:
                lea     (HScroll_table+$160).w,a5
                lea     (a5),a6
                move.w  (Events_bg+$00).w,d0
                smi     d6
                bpl.s   SKSSZ2BG_CalcVerticalRampStep
                neg.w   d0

SKSSZ2BG_CalcVerticalRampStep:
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.w  d0,d1
                swap    d0
                moveq   #0,d2
                moveq   #0,d3
                moveq   #8-1,d4
                tst.b   d6
                bne.s   SKSSZ2BG_WriteVerticalRampForward

SKSSZ2BG_WriteVerticalRampBackward:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,-(a5)
                move.w  d2,d5
                neg.w   d5
                move.w  d5,(a6)+
                dbf     d4,SKSSZ2BG_WriteVerticalRampBackward
                bra.s   SKSSZ2BG_SelectVerticalSampleWindow
; ---------------------------------------------------------------------------

SKSSZ2BG_WriteVerticalRampForward:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,(a6)+
                move.w  d2,d5
                neg.w   d5
                move.w  d5,-(a5)
                dbf     d4,SKSSZ2BG_WriteVerticalRampForward

SKSSZ2BG_SelectVerticalSampleWindow:
                lea     (HScroll_table+$170).w,a1
                lea     (HScroll_table+$140).w,a5
                move.w  (Camera_X_pos_BG_copy).w,d0
                move.w  d0,d1
                andi.w  #$F,d1
                beq.s   SKSSZ2BG_BindVerticalSampleWindow
                addi.w  #$10,d0

SKSSZ2BG_BindVerticalSampleWindow:
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                adda.w  d0,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                addq.w  #8,d0
                moveq   #$14-1,d1

; Read and write forward through the same scroll table. The source window can overlap the output
SKSSZ2BG_WriteVerticalSamples:
                move.w  (a5)+,d2
                add.w   d0,d2
                move.w  d2,(a1)+
                dbf     d1,SKSSZ2BG_WriteVerticalSamples

SKSSZ2BG_ScrollTableReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZ2BG_BeginLateForegroundBands:
                lea     (HScroll_table).w,a1
                move.l  (a1),d0
                subi.l  #$10000,(a1)+
                lea     $110(a1),a1
                clr.w   d0
                move.l  d0,d1
                asr.l   #5,d1
                moveq   #$20-1,d2

SKSSZ2BG_WriteLateForegroundBands:
                swap    d0
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,SKSSZ2BG_WriteLateForegroundBands
                move.w  (a1),d0
                neg.w   d0
                move.w  d0,-4(a1)
                move.w  d0,-$C(a1)
                move.w  8(a1),d0
                neg.w   d0
                move.w  d0,-8(a1)
                move.w  $10(a1),d0
                neg.w   d0
                move.w  d0,-2(a1)
                move.w  $18(a1),d0
                neg.w   d0
                move.w  d0,-$E(a1)
                move.w  $20(a1),d0
                neg.w   d0
                move.w  d0,-$A(a1)
                move.w  $28(a1),d0
                neg.w   d0
                move.w  d0,-6(a1)
                rts
; End of function BuildSsz2EndingStageScrollTables

; =============== S U B R O U T I N E =======================================

ComposeSsz2EndingScrollBuffersByStage:
                tst.w   (Events_routine_bg).w
                beq.s   SKSSZ2BG_SelectEndingDeformation
                lea     SSZ2_BGDeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

SKSSZ2BG_SelectEndingDeformation:
                cmpi.w  #$18,(Events_routine_fg).w
                bhs.w   SKSSZ2BG_ApplyLateForegroundScroll
                cmpi.w  #$C,(Events_routine_fg).w
                bhs.w   SKSSZ2BG_ApplyPlainEndingScroll
                lea     SKSSZ2FG_ForegroundScrollSpans(pc),a4
                lea     (HScroll_table+$004).w,a5
                jsr     (ApplyFGDeformation).l
                lea     (H_scroll_buffer+2).w,a1
                lea     (HScroll_table+$050).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$100,d0
                bmi.s   SKSSZ2BG_ClipEarlyOverlay
                subi.w  #$80,d0
                bpl.s   SKSSZ2BG_PrepareVerticalScrollExport
                move.w  d0,d1
                neg.w   d0
                addi.w  #$80,d1
                add.w   d1,d1
                adda.w  d1,a5
                bra.s   SKSSZ2BG_PrepareOverlayCopy
; ---------------------------------------------------------------------------

SKSSZ2BG_ClipEarlyOverlay:
                neg.w   d0
                cmpi.w  #$E0,d0
                bhs.s   SKSSZ2BG_PrepareVerticalScrollExport
                move.w  d0,d1
                addi.w  #-$E0,d0
                neg.w   d0
                cmpi.w  #$80,d0
                blo.s   SKSSZ2BG_SkipClippedOverlayLines
                move.w  #$80,d0

SKSSZ2BG_SkipClippedOverlayLines:
                lsl.w   #2,d1
                adda.w  d1,a1

SKSSZ2BG_PrepareOverlayCopy:
                subq.w  #1,d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                neg.w   d1

SKSSZ2BG_WriteBackgroundScrollHalves:
                move.w  (a5)+,d2
                add.w   d1,d2
                move.w  d2,(a1)
                addq.w  #4,a1
                dbf     d0,SKSSZ2BG_WriteBackgroundScrollHalves

SKSSZ2BG_PrepareVerticalScrollExport:
                lea     (Vscroll_buffer).w,a1
                lea     (HScroll_table+$170).w,a5
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                moveq   #$14-1,d1

SKSSZ2BG_WriteVerticalScrollPairs:
                move.w  (a5)+,d0
                move.l  d0,(a1)+
                dbf     d1,SKSSZ2BG_WriteVerticalScrollPairs
                rts
; ---------------------------------------------------------------------------

SKSSZ2BG_ApplyPlainEndingScroll:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SKSSZ2BG_ApplyLateForegroundScroll:
                lea     SSZ2_DeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyFGDeformation).l
; End of function ComposeSsz2EndingScrollBuffersByStage

; ---------------------------------------------------------------------------

SKSSZ2BG_DispatchEndingMotion:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SKSSZ2BG_EndingMotionBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SKSSZ2BG_EndingMotionBranches:
                bra.w   SKSSZ2BG_BobAndWaitForMotionSignal
; ---------------------------------------------------------------------------
                bra.w   SKSSZ2BG_SelectEmeraldOrOrdinaryMove
; ---------------------------------------------------------------------------
                bra.w   SKSSZ2BG_MoveFinalCameraAndTryHandoff
; ---------------------------------------------------------------------------

; With a negative foreground signal, wait for two changes to zero amplitude before advancing
SKSSZ2BG_BobAndWaitForMotionSignal:
                tst.w   (Special_V_int_routine).w
                beq.w   SKSSZ2BG_EndingMotionReturn
                addi.l  #$11B,(SceneAuxiliaryYOrVerticalMotion).w
                move.l  #$2000,d0
                move.l  #$4A,d1
                jsr     (Gradual_SwingOffset).l
                cmp.w   (Events_bg+$00).w,d0
                beq.w   SKSSZ2BG_EndingMotionReturn
                move.w  d0,(Events_bg+$00).w
                bne.w   SKSSZ2BG_EndingMotionReturn
                tst.w   (Events_fg_4).w
                bpl.w   SKSSZ2BG_EndingMotionReturn
                tst.b   $38(a0)
                bne.s   SKSSZ2BG_AcknowledgeAndSetEndingVInt
                st      $38(a0)
                bra.w   SKSSZ2BG_EndingMotionReturn
; ---------------------------------------------------------------------------

SKSSZ2BG_AcknowledgeAndSetEndingVInt:
                clr.w   (Events_fg_4).w
                move.w  #$C,(Special_V_int_routine).w
                addq.b  #4,routine(a0)

SKSSZ2BG_SelectEmeraldOrOrdinaryMove:
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   SKSSZ2BG_AccelEmeraldMotion
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   SKSSZ2BG_AccelOrdinaryMotion

SKSSZ2BG_AccelEmeraldMotion:
                cmpi.w  #$8000,$3C(a0)
                bhs.s   SKSSZ2BG_StepEmeraldMotion
                addi.w  #$20,$3C(a0)

SKSSZ2BG_StepEmeraldMotion:
                move.l  $3A(a0),d0
                sub.l   d0,(SceneAuxiliaryYOrVerticalMotion).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$318,d0
                sub.w   (SceneAuxiliaryYOrVerticalMotion).w,d0
                cmpi.w  #$D0,d0
                beq.s   SKSSZ2BG_SignalEmeraldAccentOnce
                bcs.s   SKSSZ2BG_TryFinishEmeraldMotion
                subq.w  #1,(Camera_Y_pos).w
                bra.s   SKSSZ2BG_TryFinishEmeraldMotion
; ---------------------------------------------------------------------------

SKSSZ2BG_SignalEmeraldAccentOnce:
                tst.b   $39(a0)
                bne.s   SKSSZ2BG_TryFinishEmeraldMotion
                st      $39(a0)
                st      (SceneOutcomeOrActorReadySignal).w

SKSSZ2BG_TryFinishEmeraldMotion:
                cmpi.w  #$2A0,(Camera_Y_pos).w
                bne.w   SKSSZ2BG_EndingMotionReturn
                st      (Events_fg_4+1).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZ2BG_AccelOrdinaryMotion:
                cmpi.w  #$8000,$3C(a0)
                bhs.s   SKSSZ2BG_StepOrdinaryMotion
                addi.w  #$20,$3C(a0)

SKSSZ2BG_StepOrdinaryMotion:
                move.l  $3A(a0),d0
                add.l   d0,(SceneAuxiliaryYOrVerticalMotion).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$318,d0
                sub.w   (SceneAuxiliaryYOrVerticalMotion).w,d0
                cmpi.w  #$D0,d0
                beq.s   SKSSZ2BG_SignalOrdinaryAccentOnce
                bcc.s   SKSSZ2BG_TryBeginFinalCameraMove
                addq.w  #1,(Camera_Y_pos).w
                bra.s   SKSSZ2BG_TryBeginFinalCameraMove
; ---------------------------------------------------------------------------

SKSSZ2BG_SignalOrdinaryAccentOnce:
                tst.b   $39(a0)
                bne.s   SKSSZ2BG_TryBeginFinalCameraMove
                st      $39(a0)
                st      (SceneOutcomeOrActorReadySignal).w

SKSSZ2BG_TryBeginFinalCameraMove:
                cmpi.w  #$600,(Camera_Y_pos).w
                bne.s   SKSSZ2BG_EndingMotionReturn
                st      (Events_fg_4+1).w
                addq.b  #4,routine(a0)

; Attempt the handoff only once speed turns negative and integer camera Y is exactly $804
SKSSZ2BG_MoveFinalCameraAndTryHandoff:
                cmpi.w  #$18,(Events_routine_fg).w
                blo.s   SKSSZ2BG_EndingMotionReturn
                move.l  $3A(a0),d0
                add.l   d0,(Camera_Y_pos).w
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$7D0,d0
                blo.s   SKSSZ2BG_EndingMotionReturn
                subi.l  #$98,$3A(a0)
                bpl.s   SKSSZ2BG_EndingMotionReturn
                cmpi.w  #$804,(Camera_Y_pos).w
                bne.s   SKSSZ2BG_EndingMotionReturn
                jsr     (AllocateObject).l
                bne.s   SKSSZ2BG_DeleteEndingMotionActor
                move.l  #EndingResults_SelectProgramAndStartDelay,(a1)

SKSSZ2BG_DeleteEndingMotionActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZ2BG_EndingMotionReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZ2BG_InitKnucklesIslandMask:
                move.l  #SKSSZ2BG_TryMoveMaskWithPanorama,(a0)
                move.b  #$40,render_flags(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$380,priority(a0)
                move.l  #Map_KnuxEndingIslandMask,mappings(a0)
                move.w  #$122,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #8,mainspr_childsprites(a0)

SKSSZ2BG_TryMoveMaskWithPanorama:
                tst.w   (Events_routine_bg).w
                beq.s   SKSSZ2BG_BindMaskSpriteRows
                cmpi.w  #$80,(Camera_Y_pos_BG_copy).w
                bne.s   SKSSZ2BG_StepPanoramaY
                bra.s   SKSSZ2BG_ConvertPanoramaYToMaskScreenY
; ---------------------------------------------------------------------------

SKSSZ2BG_StepPanoramaY:
                subi.l  #$6000,(Camera_Y_pos_BG_copy).w

SKSSZ2BG_ConvertPanoramaYToMaskScreenY:
                move.w  (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$1D0,d0
                neg.w   d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)

SKSSZ2BG_BindMaskSpriteRows:
                lea     sub2_x_pos(a0),a1
                move.w  y_pos(a0),d0
                subi.w  #$40,d0
                moveq   #1,d2

SKSSZ2BG_ResetFirstColumnXForEachMaskRow:
                move.w  #$A2,d1
                moveq   #4-1,d3

SKSSZ2BG_PlaceMaskSprite:
                move.w  d1,(a1)+
                move.w  d0,(a1)+
                addq.w  #2,a1
                addi.w  #$40,d1
                dbf     d3,SKSSZ2BG_PlaceMaskSprite
                addi.w  #$40,d0
                dbf     d2,SKSSZ2BG_ResetFirstColumnXForEachMaskRow
                cmpi.w  #$18,(Events_routine_fg).w
                bne.s   SKSSZ2BG_DrawIslandMask
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZ2BG_DrawIslandMask:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_KnuxEndingIslandMask:
                include "src/ui/shared/ending/mappings/knuckles_island_mask.s"

; =============== S U B R O U T I N E =======================================

CycleSsz2EndingWaterPalette:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   SKSSZ2BG_WaterCycleReturn
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKSSZ2BG_WaterCycleReturn
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,d0
                cmpi.w  #$30,d0
                blo.s   SKSSZ2BG_ApplyWaterCycleFrame
                moveq   #0,d0

SKSSZ2BG_ApplyWaterCycleFrame:
                move.w  d0,(Palette_cycle_counter0).w
                move.l  Pal_EndingWater(pc,d0.w),(Normal_palette_line_4+$1A).w
                move.w  Pal_EndingWater+$4(pc,d0.w),(Normal_palette_line_4+$1E).w

SKSSZ2BG_WaterCycleReturn:
                rts
; End of function CycleSsz2EndingWaterPalette

; ---------------------------------------------------------------------------
Pal_EndingWater:
                binclude "data/General/Ending/Palettes/Water Cycle.bin"
                even

; =============== S U B R O U T I N E =======================================

CycleSsz2EmeraldEndingAccentPalette:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   SKSSZ2BG_EmeraldAccentReturn
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKSSZ2BG_EmeraldAccentReturn
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,d0
                cmpi.w  #$38,d0
                blo.s   SKSSZ2BG_ApplyEmeraldAccentFrame
                moveq   #0,d0

SKSSZ2BG_ApplyEmeraldAccentFrame:
                move.w  d0,(Palette_cycle_counter0).w
                move.l  SKSSZ2BG_EmeraldAccentColors(pc,d0.w),(Normal_palette_line_4+$16).w

SKSSZ2BG_EmeraldAccentReturn:
                rts
; End of function CycleSsz2EmeraldEndingAccentPalette

; ---------------------------------------------------------------------------
SKSSZ2BG_EmeraldAccentColors:
                dc.w    $C40,  $400
                dc.w    $E68,  $600
                dc.w    $E80,  $800
                dc.w    $E80,  $800
                dc.w    $EE0,  $A00
                dc.w    $EE0,  $A00
                dc.w    $EE0,  $C00
                dc.w    $C40,  $C00
                dc.w    $E68,  $C00
                dc.w    $E80,  $400
                dc.w    $E80,  $600
                dc.w    $EE0,  $A00
                dc.w    $EA4,  $800
                dc.w    $EA4,  $400

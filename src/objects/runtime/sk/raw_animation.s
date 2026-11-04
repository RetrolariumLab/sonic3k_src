; Owner: objects/runtime/sk
; Responsibility: Raw animation interpreters, external-player frames, result checks, flip or delay variants and animation state setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Raw:
                movea.l $30(a0),a1
; End of function Animate_Raw

; =============== S U B R O U T I N E =======================================

Animate_RawNoSST:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnFromSingleDelayHoldOrFrameWrite
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   SKRawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawAnimation_ReturnFromSingleDelayHoldOrFrameWrite:
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn:
                neg.b   d1
                jsr     SKRawAnimation_SingleDelayCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawNoSST

SKRawAnimation_SingleDelayCommandBranchSlotsRestartJumpCallback:
                bra.w   AnimateRaw_Restart              ; FC
; ---------------------------------------------------------------------------
                bra.w   AnimateRaw_Jump                 ; F8
; ---------------------------------------------------------------------------
                bra.w   AnimateRaw_CustomCode           ; F4
; ---------------------------------------------------------------------------

AnimateRaw_Jump:
                move.b  2(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

AnimateRaw_Restart:
                move.b  1(a1),mapping_frame(a0)
                move.b  (a1),anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

AnimateRaw_CustomCode:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

Animate_RawAdjustFlipX:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnFromHorizontalSingleFlipHoldOrEmission
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   SKRawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                bclr    #6,d1
                beq.s   SKRawAnimation_ReloadSingleDelayAndStoreHorizontalFlipStrippedFrame
                bchg    #0,render_flags(a0)

SKRawAnimation_ReloadSingleDelayAndStoreHorizontalFlipStrippedFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawAnimation_ReturnFromHorizontalSingleFlipHoldOrEmission:
                rts
; End of function Animate_RawAdjustFlipX

; ---------------------------------------------------------------------------

Animate_RawAdjustFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnFromVerticalSingleFlipHoldOrEmission
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.w   SKRawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                bclr    #6,d1
                beq.s   SKRawAnimation_ReloadSingleDelayAndStoreVerticalFlipStrippedFrame
                bchg    #1,render_flags(a0)

SKRawAnimation_ReloadSingleDelayAndStoreVerticalFlipStrippedFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawAnimation_ReturnFromVerticalSingleFlipHoldOrEmission:
                rts

; =============== S U B R O U T I N E =======================================

Animate_ExternalPlayerSprite:
                subq.b  #1,anim_frame_timer(a1)
                bpl.s   SKRawAnimation_TailLoadExternalPlayerPatternsAfterTimerHoldOrFramePair
                move.b  (a2),anim_frame_timer(a1)
                moveq   #0,d0
                move.b  anim_frame(a1),d0
                addq.b  #2,d0
                move.b  d0,anim_frame(a1)
                move.b  1(a2,d0.w),d1
                beq.s   SKRawAnimation_LoadExternalPlayerPatternsThenTailInvokeControllerCallback
                move.b  d1,mapping_frame(a1)
                bclr    #0,render_flags(a1)
                tst.b   2(a2,d0.w)
                beq.s   SKRawAnimation_TailLoadExternalPlayerPatternsAfterTimerHoldOrFramePair
                bset    #0,render_flags(a1)

SKRawAnimation_TailLoadExternalPlayerPatternsAfterTimerHoldOrFramePair:
                jmp     Player_Load_PLC2(pc)
; ---------------------------------------------------------------------------

SKRawAnimation_LoadExternalPlayerPatternsThenTailInvokeControllerCallback:
                jsr     Player_Load_PLC2(pc)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Animate_ExternalPlayerSprite

; =============== S U B R O U T I N E =======================================

Animate_RawCheckResult:
                movea.l $30(a0),a1
; End of function Animate_RawCheckResult

; =============== S U B R O U T I N E =======================================

Animate_RawNoSSTCheckResult:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnEscapedSingleDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                lea     1(a1,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                cmpi.b  #-1,d1
                beq.s   SKRawAnimation_DecodeFfEscapedSingleCommandAndReturnMinusOneAfterCursorClear
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnEscapedSingleDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_DecodeFfEscapedSingleCommandAndReturnMinusOneAfterCursorClear:
                move.b  (a2)+,d1
                neg.b   d1
                jsr     SKRawAnimation_EscapedSingleCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                moveq   #-1,d2
                rts
; End of function Animate_RawNoSSTCheckResult

SKRawAnimation_EscapedSingleCommandBranchSlotsRestartJumpCallback:
                bra.w   SKRawAnimation_ReloadEscapedSingleFirstFrameAndDelayBeforeMinusOneReturn
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_JumpEscapedSingleBySignedByteAndPublishPointer
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_TailInvokeEscapedSingleCallbackBeforeOuterResultEpilogue
; ---------------------------------------------------------------------------

SKRawAnimation_JumpEscapedSingleBySignedByteAndPublishPointer:
                move.b  (a2)+,d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawAnimation_ReloadEscapedSingleFirstFrameAndDelayBeforeMinusOneReturn:
                move.b  1(a1),mapping_frame(a0)
                move.b  (a1),anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_TailInvokeEscapedSingleCallbackBeforeOuterResultEpilogue:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

Set_Raw_Animation:
                move.l  a1,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; End of function Set_Raw_Animation

; =============== S U B R O U T I N E =======================================

Stop_Object:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                rts
; End of function Stop_Object

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelay:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   SKRawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler:
                neg.b   d1
                jsr     SKRawAnimation_MultiDelayCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawMultiDelay

SKRawAnimation_MultiDelayCommandBranchSlotsRestartJumpCallback:
                bra.w   SKRawAnimation_EmitFirstMultiDelayPairWithOneResultBeforeOuterClear
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_JumpMultiDelayBySignedByteAndPublishScriptPointer
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_InvokeMultiDelayCallbackThenReturnMinusOneBeforeOuterClear
; ---------------------------------------------------------------------------

SKRawAnimation_JumpMultiDelayBySignedByteAndPublishScriptPointer:
                move.b  1(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawAnimation_EmitFirstMultiDelayPairWithOneResultBeforeOuterClear:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_InvokeMultiDelayCallbackThenReturnMinusOneBeforeOuterClear:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jsr     (a1)
                moveq   #-1,d2
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipX:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelayFlipX:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnHorizontalMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   SKRawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                bclr    #6,d1
                beq.s   SKRawAnimation_EmitHorizontalMultiDelayFrameAndDelayWithOneResult
                bchg    #0,render_flags(a0)

SKRawAnimation_EmitHorizontalMultiDelayFrameAndDelayWithOneResult:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnHorizontalMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipX

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnVerticalMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.w   SKRawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                bclr    #6,d1
                beq.s   SKRawAnimation_EmitVerticalMultiDelayFrameAndDelayWithOneResult
                bchg    #1,render_flags(a0)

SKRawAnimation_EmitVerticalMultiDelayFrameAndDelayWithOneResult:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnVerticalMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipY

; =============== S U B R O U T I N E =======================================

Animate_Raw2MultiDelay:
                movea.l $30(a0),a1

Animate_Raw2NoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnEscapedMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                lea     (a1,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                cmpi.b  #-1,d1
                beq.s   SKRawAnimation_DecodeFfEscapedMultiCommandAndClearCursorAfterHandler
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnEscapedMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_DecodeFfEscapedMultiCommandAndClearCursorAfterHandler:
                move.b  (a2)+,d1
                neg.b   d1
                jsr     SKRawAnimation_EscapedMultiDelayCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_Raw2MultiDelay

SKRawAnimation_EscapedMultiDelayCommandBranchSlotsRestartJumpCallback:
                bra.w   SKRawAnimation_EmitEscapedMultiFirstPairWithMinusOneBeforeOuterClear
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_JumpEscapedMultiBySignedByteAndPublishPointer
; ---------------------------------------------------------------------------
                bra.w   SKRawAnimation_InvokeEscapedMultiCallbackThenMinusOneBeforeCursorClear
; ---------------------------------------------------------------------------

SKRawAnimation_JumpEscapedMultiBySignedByteAndPublishPointer:
                move.b  (a2)+,d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawAnimation_EmitEscapedMultiFirstPairWithMinusOneBeforeOuterClear:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #-1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_InvokeEscapedMultiCallbackThenMinusOneBeforeCursorClear:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jsr     (a1)
                moveq   #-1,d2
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawGetFaster:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   SKRawAnimation_TickAcceleratingRawAnimationAndReduceDelayOnlyAtNegativeMarker
                move.b  (a1),$2E(a0)
                clr.b   $2F(a0)

SKRawAnimation_TickAcceleratingRawAnimationAndReduceDelayOnlyAtNegativeMarker:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnAcceleratingTimerHoldWithZeroResult
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  2(a1,d0.w),d1
                bpl.s   SKRawAnimation_CommitAcceleratingCursorFrameDelayAndOneResult
                moveq   #0,d0
                move.b  2(a1),d1
                tst.b   d2
                beq.s   SKRawAnimation_CountZeroDelayLoopAndInvokeCallbackAtUnsignedThreshold
                subq.b  #1,d2
                move.b  d2,$2E(a0)

SKRawAnimation_CommitAcceleratingCursorFrameDelayAndOneResult:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_ReturnAcceleratingTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_CountZeroDelayLoopAndInvokeCallbackAtUnsignedThreshold:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   SKRawAnimation_ReturnMinusOneForZeroDelayLoopEvenWithoutCallback
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jsr     (a2)

SKRawAnimation_ReturnMinusOneForZeroDelayLoopEvenWithoutCallback:
                moveq   #-1,d2
                rts
; End of function Animate_RawGetFaster

; ---------------------------------------------------------------------------

Animate_RawGetSlower:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   SKRawAnimation_TickDeceleratingRawAndIncrementDelayOnlyAtNegativeMarker
                clr.w   $2E(a0)

SKRawAnimation_TickDeceleratingRawAndIncrementDelayOnlyAtNegativeMarker:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  1(a1,d0.w),d1
                bpl.s   SKRawAnimation_CommitDeceleratingFrameAndCompareDelayToHeaderThreshold
                moveq   #0,d0
                move.b  1(a1),d1
                addq.b  #1,d2

SKRawAnimation_CommitDeceleratingFrameAndCompareDelayToHeaderThreshold:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                cmp.b   (a1),d2
                bhs.s   SKRawAnimation_CountDeceleratingThresholdVisitsAndTailInvokeCallback
                move.b  d2,$2E(a0)

SKRawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter:
                rts
; ---------------------------------------------------------------------------

SKRawAnimation_CountDeceleratingThresholdVisitsAndTailInvokeCallback:
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   SKRawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jmp     (a2)
; End of function Animate_RawGetSlower

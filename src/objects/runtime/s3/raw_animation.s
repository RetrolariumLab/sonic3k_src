; Owner: objects/runtime/s3
; Responsibility: Raw animation interpreters, flip variants, multi-delay streams and accelerating or decelerating animation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Raw:
                movea.l $30(a0),a1
; End of function Animate_Raw

; =============== S U B R O U T I N E =======================================

Animate_RawNoSST:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnFromSingleDelayHoldOrFrameWrite
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   S3RawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawAnimation_ReturnFromSingleDelayHoldOrFrameWrite:
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn:
                neg.b   d1
                jsr     S3RawAnimation_SingleDelayCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawNoSST

S3RawAnimation_SingleDelayCommandBranchSlotsRestartJumpCallback:
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
                bpl.s   S3RawAnimation_ReturnFromHorizontalSingleFlipHoldOrEmission
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   S3RawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                bclr    #6,d1
                beq.s   S3RawAnimation_ReloadSingleDelayAndStoreHorizontalFlipStrippedFrame
                bchg    #0,render_flags(a0)

S3RawAnimation_ReloadSingleDelayAndStoreHorizontalFlipStrippedFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawAnimation_ReturnFromHorizontalSingleFlipHoldOrEmission:
                rts
; End of function Animate_RawAdjustFlipX

; ---------------------------------------------------------------------------

Animate_RawAdjustFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnFromVerticalSingleFlipHoldOrEmission
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.w   S3RawAnimation_DispatchSignedSingleDelayCommandThenClearCursorAfterReturn
                bclr    #6,d1
                beq.s   S3RawAnimation_ReloadSingleDelayAndStoreVerticalFlipStrippedFrame
                bchg    #1,render_flags(a0)

S3RawAnimation_ReloadSingleDelayAndStoreVerticalFlipStrippedFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawAnimation_ReturnFromVerticalSingleFlipHoldOrEmission:
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelay:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   S3RawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_ReturnMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler:
                neg.b   d1
                jsr     S3RawAnimation_MultiDelayCommandBranchSlotsRestartJumpCallback-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawMultiDelay

S3RawAnimation_MultiDelayCommandBranchSlotsRestartJumpCallback:
                bra.w   S3RawAnimation_EmitFirstMultiDelayPairWithOneResultBeforeOuterClear
; ---------------------------------------------------------------------------
                bra.w   S3RawAnimation_JumpMultiDelayBySignedByteAndPublishScriptPointer
; ---------------------------------------------------------------------------
                bra.w   S3RawAnimation_InvokeMultiDelayCallbackThenReturnMinusOneBeforeOuterClear
; ---------------------------------------------------------------------------

S3RawAnimation_JumpMultiDelayBySignedByteAndPublishScriptPointer:
                move.b  1(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

S3RawAnimation_EmitFirstMultiDelayPairWithOneResultBeforeOuterClear:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_InvokeMultiDelayCallbackThenReturnMinusOneBeforeOuterClear:
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
                bpl.s   S3RawAnimation_ReturnHorizontalMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   S3RawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                bclr    #6,d1
                beq.s   S3RawAnimation_EmitHorizontalMultiDelayFrameAndDelayWithOneResult
                bchg    #0,render_flags(a0)

S3RawAnimation_EmitHorizontalMultiDelayFrameAndDelayWithOneResult:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_ReturnHorizontalMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipX

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnVerticalMultiDelayTimerHoldWithZeroResult
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.w   S3RawAnimation_DispatchSignedMultiDelayCommandAndClearCursorAfterHandler
                bclr    #6,d1
                beq.s   S3RawAnimation_EmitVerticalMultiDelayFrameAndDelayWithOneResult
                bchg    #1,render_flags(a0)

S3RawAnimation_EmitVerticalMultiDelayFrameAndDelayWithOneResult:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_ReturnVerticalMultiDelayTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipY

; =============== S U B R O U T I N E =======================================

Animate_RawGetFaster:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   S3RawAnimation_TickAcceleratingRawAnimationAndReduceDelayOnlyAtNegativeMarker
                move.b  (a1),$2E(a0)
                clr.b   $2F(a0)

S3RawAnimation_TickAcceleratingRawAnimationAndReduceDelayOnlyAtNegativeMarker:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnAcceleratingTimerHoldWithZeroResult
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  2(a1,d0.w),d1
                bpl.s   S3RawAnimation_CommitAcceleratingCursorFrameDelayAndOneResult
                moveq   #0,d0
                move.b  2(a1),d1
                tst.b   d2
                beq.s   S3RawAnimation_CountZeroDelayLoopAndInvokeCallbackAtUnsignedThreshold
                subq.b  #1,d2
                move.b  d2,$2E(a0)

S3RawAnimation_CommitAcceleratingCursorFrameDelayAndOneResult:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_ReturnAcceleratingTimerHoldWithZeroResult:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_CountZeroDelayLoopAndInvokeCallbackAtUnsignedThreshold:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   S3RawAnimation_ReturnMinusOneForZeroDelayLoopEvenWithoutCallback
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jsr     (a2)

S3RawAnimation_ReturnMinusOneForZeroDelayLoopEvenWithoutCallback:
                moveq   #-1,d2
                rts
; End of function Animate_RawGetFaster

; ---------------------------------------------------------------------------

Animate_RawGetSlower:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   S3RawAnimation_TickDeceleratingRawAndIncrementDelayOnlyAtNegativeMarker
                clr.w   $2E(a0)

S3RawAnimation_TickDeceleratingRawAndIncrementDelayOnlyAtNegativeMarker:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  1(a1,d0.w),d1
                bpl.s   S3RawAnimation_CommitDeceleratingFrameAndCompareDelayToHeaderThreshold
                moveq   #0,d0
                move.b  1(a1),d1
                addq.b  #1,d2

S3RawAnimation_CommitDeceleratingFrameAndCompareDelayToHeaderThreshold:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                cmp.b   (a1),d2
                bhs.s   S3RawAnimation_CountDeceleratingThresholdVisitsAndTailInvokeCallback
                move.b  d2,$2E(a0)

S3RawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter:
                rts
; ---------------------------------------------------------------------------

S3RawAnimation_CountDeceleratingThresholdVisitsAndTailInvokeCallback:
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   S3RawAnimation_ReturnFromDeceleratingHoldBelowThresholdOrIncompleteCounter
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jmp     (a2)
; End of function Animate_RawGetSlower

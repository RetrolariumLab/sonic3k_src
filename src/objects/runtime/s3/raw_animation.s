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
                bpl.s   S3RawSingle_FrameReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   S3RawSingle_DispatchCommand
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawSingle_FrameReturn:
                rts
; ---------------------------------------------------------------------------

; Clear the frame cursor after the command handler returns
S3RawSingle_DispatchCommand:
                neg.b   d1
                jsr     S3RawSingle_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawNoSST

; The four-byte branch slots implement $FC restart, $F8 jump and $F4 callback
S3RawSingle_CommandTable:
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
                bpl.s   S3RawSingle_HFlipReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   S3RawSingle_DispatchCommand
                bclr    #6,d1
                beq.s   S3RawSingle_StoreHFlipFrame
                bchg    #0,render_flags(a0)

S3RawSingle_StoreHFlipFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawSingle_HFlipReturn:
                rts
; End of function Animate_RawAdjustFlipX

; ---------------------------------------------------------------------------

Animate_RawAdjustFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawSingle_VFlipReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.w   S3RawSingle_DispatchCommand
                bclr    #6,d1
                beq.s   S3RawSingle_StoreVFlipFrame
                bchg    #1,render_flags(a0)

S3RawSingle_StoreVFlipFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

S3RawSingle_VFlipReturn:
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelay:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawMulti_HoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   S3RawMulti_DispatchCommand
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawMulti_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; Clear the frame cursor after the handler. Its D2 result survives
S3RawMulti_DispatchCommand:
                neg.b   d1
                jsr     S3RawMulti_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawMultiDelay

; The four-byte branch slots implement $FC restart, $F8 jump and $F4 callback
S3RawMulti_CommandTable:
                bra.w   S3RawMulti_FirstPairReturnOne
; ---------------------------------------------------------------------------
                bra.w   S3RawMulti_JumpSignedByte
; ---------------------------------------------------------------------------
                bra.w   S3RawMulti_CallbackReturnMinusOne
; ---------------------------------------------------------------------------

S3RawMulti_JumpSignedByte:
                move.b  1(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

S3RawMulti_FirstPairReturnOne:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawMulti_CallbackReturnMinusOne:
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
                bpl.s   S3RawMulti_HFlipHoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   S3RawMulti_DispatchCommand
                bclr    #6,d1
                beq.s   S3RawMulti_HFlipFrameReturnOne
                bchg    #0,render_flags(a0)

S3RawMulti_HFlipFrameReturnOne:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawMulti_HFlipHoldReturnZero:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipX

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawMulti_VFlipHoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.w   S3RawMulti_DispatchCommand
                bclr    #6,d1
                beq.s   S3RawMulti_VFlipFrameReturnOne
                bchg    #1,render_flags(a0)

S3RawMulti_VFlipFrameReturnOne:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawMulti_VFlipHoldReturnZero:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipY

; =============== S U B R O U T I N E =======================================

Animate_RawGetFaster:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   S3RawAccel_Tick
                move.b  (a1),$2E(a0)
                clr.b   $2F(a0)

; Shorten the delay only when a negative frame byte restarts the loop
S3RawAccel_Tick:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawAccel_HoldReturnZero
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  2(a1,d0.w),d1
                bpl.s   S3RawAccel_StoreFrameReturnOne
                moveq   #0,d0
                move.b  2(a1),d1
                tst.b   d2
                beq.s   S3RawAccel_CountZeroDelayLoop
                subq.b  #1,d2
                move.b  d2,$2E(a0)

S3RawAccel_StoreFrameReturnOne:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

S3RawAccel_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; Call the continuation when the unsigned loop count reaches the script threshold
S3RawAccel_CountZeroDelayLoop:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   S3RawAccel_ZeroLoopReturnMinusOne
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jsr     (a2)

; D2 is -1 on every zero-delay loop, even before the callback threshold
S3RawAccel_ZeroLoopReturnMinusOne:
                moveq   #-1,d2
                rts
; End of function Animate_RawGetFaster

; ---------------------------------------------------------------------------

Animate_RawGetSlower:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   S3RawDecel_Tick
                clr.w   $2E(a0)

; Increase the delay only when a negative frame byte restarts the loop
S3RawDecel_Tick:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3RawDecel_Return
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  1(a1,d0.w),d1
                bpl.s   S3RawDecel_StoreFrameAndTestDelay
                moveq   #0,d0
                move.b  1(a1),d1
                addq.b  #1,d2

S3RawDecel_StoreFrameAndTestDelay:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                cmp.b   (a1),d2
                bhs.s   S3RawDecel_CountAndContinue
                move.b  d2,$2E(a0)

S3RawDecel_Return:
                rts
; ---------------------------------------------------------------------------

S3RawDecel_CountAndContinue:
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   S3RawDecel_Return
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jmp     (a2)
; End of function Animate_RawGetSlower

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
                bpl.s   SKRawSingle_FrameReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   SKRawSingle_DispatchCommand
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawSingle_FrameReturn:
                rts
; ---------------------------------------------------------------------------

; Clear the frame cursor after the command handler returns
SKRawSingle_DispatchCommand:
                neg.b   d1
                jsr     SKRawSingle_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawNoSST

; The four-byte branch slots implement $FC restart, $F8 jump and $F4 callback
SKRawSingle_CommandTable:
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
                bpl.s   SKRawSingle_HFlipReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   SKRawSingle_DispatchCommand
                bclr    #6,d1
                beq.s   SKRawSingle_StoreHFlipFrame
                bchg    #0,render_flags(a0)

SKRawSingle_StoreHFlipFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawSingle_HFlipReturn:
                rts
; End of function Animate_RawAdjustFlipX

; ---------------------------------------------------------------------------

Animate_RawAdjustFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawSingle_VFlipReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.w   SKRawSingle_DispatchCommand
                bclr    #6,d1
                beq.s   SKRawSingle_StoreVFlipFrame
                bchg    #1,render_flags(a0)

SKRawSingle_StoreVFlipFrame:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

SKRawSingle_VFlipReturn:
                rts

; =============== S U B R O U T I N E =======================================

Animate_ExternalPlayerSprite:
                subq.b  #1,anim_frame_timer(a1)
                bpl.s   SKExtPlayer_LoadPatterns
                move.b  (a2),anim_frame_timer(a1)
                moveq   #0,d0
                move.b  anim_frame(a1),d0
                addq.b  #2,d0
                move.b  d0,anim_frame(a1)
                move.b  1(a2,d0.w),d1
                beq.s   SKExtPlayer_LoadPatternsAndContinue
                move.b  d1,mapping_frame(a1)
                bclr    #0,render_flags(a1)
                tst.b   2(a2,d0.w)
                beq.s   SKExtPlayer_LoadPatterns
                bset    #0,render_flags(a1)

SKExtPlayer_LoadPatterns:
                jmp     Player_Load_PLC2(pc)
; ---------------------------------------------------------------------------

SKExtPlayer_LoadPatternsAndContinue:
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
                bpl.s   SKRawEscSingle_HoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                lea     1(a1,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                cmpi.b  #-1,d1
                beq.s   SKRawEscSingle_DispatchFF
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawEscSingle_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; The byte after $FF selects the command. Clear the cursor and return D2 = -1 after it runs
SKRawEscSingle_DispatchFF:
                move.b  (a2)+,d1
                neg.b   d1
                jsr     SKRawEscSingle_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                moveq   #-1,d2
                rts
; End of function Animate_RawNoSSTCheckResult

SKRawEscSingle_CommandTable:
                bra.w   SKRawEscSingle_ReloadFirstFrame
; ---------------------------------------------------------------------------
                bra.w   SKRawEscSingle_JumpSignedByte
; ---------------------------------------------------------------------------
                bra.w   SKRawEscSingle_TailCall
; ---------------------------------------------------------------------------

SKRawEscSingle_JumpSignedByte:
                move.b  (a2)+,d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawEscSingle_ReloadFirstFrame:
                move.b  1(a1),mapping_frame(a0)
                move.b  (a1),anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKRawEscSingle_TailCall:
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
                bpl.s   SKRawMulti_HoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   SKRawMulti_DispatchCommand
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawMulti_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; Clear the frame cursor after the handler. Its D2 result survives
SKRawMulti_DispatchCommand:
                neg.b   d1
                jsr     SKRawMulti_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawMultiDelay

; The four-byte branch slots implement $FC restart, $F8 jump and $F4 callback
SKRawMulti_CommandTable:
                bra.w   SKRawMulti_FirstPairReturnOne
; ---------------------------------------------------------------------------
                bra.w   SKRawMulti_JumpSignedByte
; ---------------------------------------------------------------------------
                bra.w   SKRawMulti_CallbackReturnMinusOne
; ---------------------------------------------------------------------------

SKRawMulti_JumpSignedByte:
                move.b  1(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawMulti_FirstPairReturnOne:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawMulti_CallbackReturnMinusOne:
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
                bpl.s   SKRawMulti_HFlipHoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   SKRawMulti_DispatchCommand
                bclr    #6,d1
                beq.s   SKRawMulti_HFlipFrameReturnOne
                bchg    #0,render_flags(a0)

SKRawMulti_HFlipFrameReturnOne:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawMulti_HFlipHoldReturnZero:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipX

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawMulti_VFlipHoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.w   SKRawMulti_DispatchCommand
                bclr    #6,d1
                beq.s   SKRawMulti_VFlipFrameReturnOne
                bchg    #1,render_flags(a0)

SKRawMulti_VFlipFrameReturnOne:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawMulti_VFlipHoldReturnZero:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipY

; =============== S U B R O U T I N E =======================================

Animate_Raw2MultiDelay:
                movea.l $30(a0),a1

Animate_Raw2NoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawEscMulti_HoldReturnZero
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                lea     (a1,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                cmpi.b  #-1,d1
                beq.s   SKRawEscMulti_DispatchFF
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawEscMulti_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; The byte after $FF selects the command. Clear the cursor after the handler sets D2
SKRawEscMulti_DispatchFF:
                move.b  (a2)+,d1
                neg.b   d1
                jsr     SKRawEscMulti_CommandTable-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_Raw2MultiDelay

SKRawEscMulti_CommandTable:
                bra.w   SKRawEscMulti_FirstPairReturnMinusOne
; ---------------------------------------------------------------------------
                bra.w   SKRawEscMulti_JumpSignedByte
; ---------------------------------------------------------------------------
                bra.w   SKRawEscMulti_CallbackReturnMinusOne
; ---------------------------------------------------------------------------

SKRawEscMulti_JumpSignedByte:
                move.b  (a2)+,d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

SKRawEscMulti_FirstPairReturnMinusOne:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #-1,d2
                rts
; ---------------------------------------------------------------------------

SKRawEscMulti_CallbackReturnMinusOne:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jsr     (a1)
                moveq   #-1,d2
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawGetFaster:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   SKRawAccel_Tick
                move.b  (a1),$2E(a0)
                clr.b   $2F(a0)

; Shorten the delay only when a negative frame byte restarts the loop
SKRawAccel_Tick:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawAccel_HoldReturnZero
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  2(a1,d0.w),d1
                bpl.s   SKRawAccel_StoreFrameReturnOne
                moveq   #0,d0
                move.b  2(a1),d1
                tst.b   d2
                beq.s   SKRawAccel_CountZeroDelayLoop
                subq.b  #1,d2
                move.b  d2,$2E(a0)

SKRawAccel_StoreFrameReturnOne:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

SKRawAccel_HoldReturnZero:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

; Call the continuation when the unsigned loop count reaches the script threshold
SKRawAccel_CountZeroDelayLoop:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   SKRawAccel_ZeroLoopReturnMinusOne
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jsr     (a2)

; D2 is -1 on every zero-delay loop, even before the callback threshold
SKRawAccel_ZeroLoopReturnMinusOne:
                moveq   #-1,d2
                rts
; End of function Animate_RawGetFaster

; ---------------------------------------------------------------------------

Animate_RawGetSlower:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   SKRawDecel_Tick
                clr.w   $2E(a0)

; Increase the delay only when a negative frame byte restarts the loop
SKRawDecel_Tick:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKRawDecel_Return
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  1(a1,d0.w),d1
                bpl.s   SKRawDecel_StoreFrameAndTestDelay
                moveq   #0,d0
                move.b  1(a1),d1
                addq.b  #1,d2

SKRawDecel_StoreFrameAndTestDelay:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                cmp.b   (a1),d2
                bhs.s   SKRawDecel_CountAndContinue
                move.b  d2,$2E(a0)

SKRawDecel_Return:
                rts
; ---------------------------------------------------------------------------

SKRawDecel_CountAndContinue:
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   SKRawDecel_Return
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jmp     (a2)
; End of function Animate_RawGetSlower

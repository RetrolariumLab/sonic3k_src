; Owner: objects/runtime/sk
; Responsibility: Combined motion, animation, waiting, music delay, collision and sprite drawing callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

MoveFall_AnimateRaw:
                jsr     (MoveSprite).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

Move_AnimateRaw:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

MoveSlowFall_AnimateRaw:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Swing_UpAndDown(pc)

Move_AnimateRaw_Wait:
                jsr     (MoveSprite2).l

SKRuntimeLifetime_RawWait_AnimateThenRunWordCountdownCallback:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Refresh_ChildPosWait:
                jsr     Refresh_ChildPosition(pc)

Wait_Draw:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Wait_FadeToLevelMusic:
                subq.w  #1,$2E(a0)
                bmi.s   SKRuntimeLifetime_MusicWait_ClearPriorVisibleFlagAndAttemptFadeController
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRuntimeLifetime_MusicWait_ClearPriorVisibleFlagAndAttemptFadeController:
                bclr    #7,render_flags(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SKRuntimeLifetime_MusicWait_TailCallStoredContinuationAfterAllocationAttempt
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKRuntimeLifetime_MusicWait_TailCallStoredContinuationAfterAllocationAttempt:
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

Wait_NewDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKRuntimeLifetime_NewDelayWait_ResetCounterAndTailCallStoredContinuation
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRuntimeLifetime_NewDelayWait_ResetCounterAndTailCallStoredContinuation:
                bclr    #7,render_flags(a0)
                move.w  #(2*60)-1,$2E(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

MoveWaitTouch:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

SKRuntimeLifetime_ChildRawTouch_RefreshPositionThenAnimatePairDelayAndQueueContact:  ; used in S3, unused in S&K
                jsr     Refresh_ChildPosition(pc)

AnimateRaw_DrawTouch:
                jsr     Animate_RawMultiDelay(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

AnimateRaw_MoveChkDel:
                jsr     Animate_Raw(pc)

MoveChkDel:
                jsr     (MoveSprite).l
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)

MoveTouchChkDel:
                jsr     (MoveSprite).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

Move_WaitNoFall:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Swing_MoveWaitNoFall:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jmp     Draw_And_Touch_Sprite(pc)
; End of function MoveFall_AnimateRaw

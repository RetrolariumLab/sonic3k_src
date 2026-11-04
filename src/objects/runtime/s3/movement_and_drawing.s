; Owner: objects/runtime/s3
; Responsibility: Combined motion, animation, waiting, collision and sprite drawing object callbacks
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

S3RuntimeLifetime_RawWait_AnimateThenRunWordCountdownCallback:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Refresh_ChildPosWait:
                jsr     Refresh_ChildPosition(pc)

Wait_Draw:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveWaitTouch:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

S3RuntimeLifetime_ChildRawTouch_RefreshPositionThenAnimatePairDelayAndQueueContact:
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

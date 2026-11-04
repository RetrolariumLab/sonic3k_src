; Owner: objects/runtime/s3
; Responsibility: Parent-aware child drawing, touch interaction, remembered placement and flicker-motion wrappers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Draw_And_Touch_Sprite:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_ScheduleChildDeletionForParentStatus
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ScheduleChildDeletionForParentStatus:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_ScheduleTouchChildDeletionForParentStatus
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ScheduleTouchChildDeletionForParentStatus:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_ClearRememberedChildTrackingAndScheduleDeletion
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ClearRememberedChildTrackingAndScheduleDeletion:
                bsr.w   Remove_From_TrackingSlot
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3RuntimeChildren_ScheduleChildDeletionForParentPrivateFlag
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ScheduleChildDeletionForParentPrivateFlag:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3RuntimeChildren_ScheduleTouchChildDeletionForParentPrivateFlag
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_DrawChildAfterParentStatusContactGate
                jsr     (Add_SpriteToCollisionResponseList).l

S3RuntimeChildren_DrawChildAfterParentStatusContactGate:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ScheduleTouchChildDeletionForParentPrivateFlag:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw:
                bset    #7,status(a0)
                move.l  #Obj_FlickerMove,(a0)
                clr.b   collision_flags(a0)
                bsr.w   Set_IndexedVelocity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3RuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3RuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3RuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw
                btst    #7,status(a1)
                beq.s   S3RuntimeChildren_EnqueueChildContactAndDrawWhileParentFlagsClear
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeChildren_EnqueueChildContactAndDrawWhileParentFlagsClear:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; End of function Draw_And_Touch_Sprite

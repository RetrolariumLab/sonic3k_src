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
                bne.s   S3Child_DeleteOnParentStatus
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Child_DeleteOnParentStatus:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3ChildTouch_DeleteOnParentStatus
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ChildTouch_DeleteOnParentStatus:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3Child_UntrackAndDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Child_UntrackAndDelete:
                bsr.w   Remove_From_TrackingSlot
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3Child_DeleteOnParentPrivateFlag
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Child_DeleteOnParentPrivateFlag:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3ChildTouch_DeleteOnParentPrivateFlag
                btst    #7,status(a1)
                bne.s   S3Child_DrawWithoutTouch
                jsr     (Add_SpriteToCollisionResponseList).l

S3Child_DrawWithoutTouch:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ChildTouch_DeleteOnParentPrivateFlag:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3Child_StartFlickerAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Clear collision flags and load the indexed velocity before drawing
S3Child_StartFlickerAndDraw:
                bset    #7,status(a0)
                move.l  #Obj_FlickerMove,(a0)
                clr.b   collision_flags(a0)
                bsr.w   Set_IndexedVelocity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3Child_StartFlickerAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3Child_StartFlickerAndDraw
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   S3Child_StartFlickerAndDraw
                btst    #7,status(a1)
                beq.s   S3ChildFlicker_DrawAndTouch
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ChildFlicker_DrawAndTouch:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; End of function Draw_And_Touch_Sprite

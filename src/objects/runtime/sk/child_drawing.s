; Owner: objects/runtime/sk
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
                bne.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   Go_Delete_Sprite
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_CheckParent:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   Go_Delete_Sprite
                rts
; ---------------------------------------------------------------------------

Child_AddToTouchList:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   Go_Delete_Sprite
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_84984
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_84984:
                bsr.w   Remove_From_TrackingSlot
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_8499E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8499E:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_849C2
                btst    #7,status(a1)
                bne.s   loc_849BC
                jsr     (Add_SpriteToCollisionResponseList).l

loc_849BC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_849C2:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_849D8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_849D8:
                bset    #7,status(a0)
                move.l  #Obj_FlickerMove,(a0)
                clr.b   collision_flags(a0)
                bsr.w   Set_IndexedVelocity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_849D8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_849D8
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_849D8
                btst    #7,status(a1)
                beq.s   loc_84A3C
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_84A3C:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

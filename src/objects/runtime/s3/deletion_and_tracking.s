; Owner: objects/runtime/s3
; Responsibility: Bounds-based object deletion, touch variants, flicker motion and object tracking slot removal
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Sprite_CheckDelete:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5371C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5371C:
                move.w  respawn_addr(a0),d0
                beq.s   loc_53728
                movea.w d0,a2
                bclr    #7,(a2)

loc_53728:
                bset    #7,status(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

Sprite_CheckDelete2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5374E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5374E:
                move.w  respawn_addr(a0),d0
                beq.s   loc_5375A
                movea.w d0,a2
                bclr    #7,(a2)

loc_5375A:
                bset    #4,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5371C
                rts
; ---------------------------------------------------------------------------

Sprite_CheckDeleteXY:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_FlickerMove:
                jsr     (MoveSprite).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                btst    #0,(V_int_run_count+3).w
                beq.w   locret_529CE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5371C
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5374E
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5371C
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouchXY:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteSlotted:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted:
                move.w  respawn_addr(a0),d0
                beq.s   Go_Delete_SpriteSlotted2
                movea.w d0,a2
                bclr    #7,(a2)

Go_Delete_SpriteSlotted2:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)

; =============== S U B R O U T I N E =======================================

Remove_From_TrackingSlot:
                move.b  ros_bit(a0),d0
                movea.w ros_addr(a0),a1
                bclr    d0,(a1)
                rts
; End of function Remove_From_TrackingSlot

; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouchSlotted:
                tst.b   status(a0)
                bmi.s   Go_Delete_SpriteSlotted3
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted3:
                move.l  #Delete_Current_Sprite,(a0)
                bra.s   Remove_From_TrackingSlot
; ---------------------------------------------------------------------------
                tst.b   status(a0)                      ; Unused, seems to be identical to the above
                bmi.s   Go_Delete_SpriteSlotted3
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0                    ; Next six are unused, virtually the same
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_539C4:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Go_Delete_Sprite:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                rts
; End of function Go_Delete_Sprite

; =============== S U B R O U T I N E =======================================

Go_Delete_Sprite_2:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #4,$38(a0)
                rts
; End of function Go_Delete_Sprite_2

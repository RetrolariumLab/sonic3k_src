; Owner: objects/runtime/s3
; Responsibility: Bounds-based object deletion, touch variants, flicker motion and object tracking slot removal
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Sprite_CheckDelete:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3Cull_ReleaseRespawnForStatusDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Cull_ReleaseRespawnForStatusDelete:
                move.w  respawn_addr(a0),d0
                beq.s   S3Cull_DeferStatusDelete
                movea.w d0,a2
                bclr    #7,(a2)

; Set bit 7 of status for children that follow the parent's deletion
S3Cull_DeferStatusDelete:
                bset    #7,status(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

Sprite_CheckDelete2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3Cull_ReleaseRespawnForPrivateDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Cull_ReleaseRespawnForPrivateDelete:
                move.w  respawn_addr(a0),d0
                beq.s   S3Cull_DeferPrivateDelete
                movea.w d0,a2
                bclr    #7,(a2)

; Use bit 4 of object field $38 to signal this deletion to children
S3Cull_DeferPrivateDelete:
                bset    #4,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3Cull_ReleaseRespawnForStatusDelete
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
                beq.w   S3Return_AttrSetup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3Cull_ReleaseRespawnForStatusDelete
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3Cull_ReleaseRespawnForPrivateDelete
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3Cull_ReleaseRespawnForStatusDelete
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

S3Capsule_CoarseCullOrDraw:
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

; Owner: objects/runtime/s3
; Responsibility: Sprite visibility tests, out-of-range deletion and touch-aware culling wrappers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_19C02
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19C02:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19C0E
                movea.w d0,a2
                bclr    #7,(a2)

loc_19C0E:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test2:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_19C26
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19C26:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19C32
                movea.w d0,a2
                bclr    #7,(a2)

loc_19C32:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_19C4C
                rts
; ---------------------------------------------------------------------------

loc_19C4C:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19C58
                movea.w d0,a2
                bclr    #7,(a2)

loc_19C58:
                bra.w   Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; ---------------------------------------------------------------------------
; unused
                tst.w   (Competition_mode).w
                bne.s   loc_19C8A
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_19C7A
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19C7A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19C86
                movea.w d0,a2
                bclr    #7,(a2)

loc_19C86:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_19C8A:
                move.w  x_pos(a0),d0
                andi.w  #$FF00,d0
                move.w  d0,d1
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$300,d0
                bhi.w   loc_19CA4
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19CA4:
                sub.w   (_unkF7DC).w,d1
                cmpi.w  #$300,d1
                bhi.w   loc_19CB4
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19CB4:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19CC0
                movea.w d0,a2
                bclr    #7,(a2)

loc_19CC0:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch3:
                move.w  x_pos(a0),d0

loc_19CC8:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_19CE2
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_19CE2:
                move.w  respawn_addr(a0),d0
                beq.s   loc_19CEE
                movea.w d0,a2
                bclr    #7,(a2)

loc_19CEE:
                bra.w   Delete_Current_Sprite

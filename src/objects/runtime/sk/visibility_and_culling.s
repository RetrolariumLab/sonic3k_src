; Owner: objects/runtime/sk
; Responsibility: Sprite visibility tests, out-of-range deletion and touch-aware culling wrappers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKDrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKDrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKDrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKDrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test2:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKAnchorDrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKAnchorDrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKAnchorDrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKAnchorDrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKRangeCull_ReleaseRespawn
                rts
; ---------------------------------------------------------------------------

SKRangeCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKRangeCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKRangeCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; ---------------------------------------------------------------------------
; unused
                tst.w   (Competition_mode).w
                bne.s   SKDualCull_CheckPrimaryWindow
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLegacyDrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKLegacyDrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKLegacyDrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKLegacyDrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

SKDualCull_CheckPrimaryWindow:
                move.w  x_pos(a0),d0
                andi.w  #$FF00,d0
                move.w  d0,d1
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$300,d0
                bhi.w   SKDualCull_CheckSecondaryWindow
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKDualCull_CheckSecondaryWindow:
                sub.w   (_unkF7DC).w,d1
                cmpi.w  #$300,d1
                bhi.w   SKDualCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKDualCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKDualCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKDualCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch3:
                move.w  x_pos(a0),d0

SKTouchCull_TestAnchorAndDraw:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKTouchCull_ReleaseRespawn
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKTouchCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKTouchCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKTouchCull_DeleteNow:
                bra.w   Delete_Current_Sprite

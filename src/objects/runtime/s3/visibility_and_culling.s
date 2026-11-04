; Owner: objects/runtime/s3
; Responsibility: Sprite visibility tests, out-of-range deletion and touch-aware culling wrappers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3DrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3DrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3DrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3DrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test2:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3AnchorDrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3AnchorDrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3AnchorDrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3AnchorDrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RangeCull_ReleaseRespawn
                rts
; ---------------------------------------------------------------------------

S3RangeCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3RangeCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3RangeCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; ---------------------------------------------------------------------------
; unused
                tst.w   (Competition_mode).w
                bne.s   S3DualCull_CheckPrimaryWindow
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LegacyDrawCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3LegacyDrawCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3LegacyDrawCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3LegacyDrawCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

S3DualCull_CheckPrimaryWindow:
                move.w  x_pos(a0),d0
                andi.w  #$FF00,d0
                move.w  d0,d1
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$300,d0
                bhi.w   S3DualCull_CheckSecondaryWindow
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3DualCull_CheckSecondaryWindow:
                sub.w   (AlternateObjectCullCoarseXOrigin).w,d1
                cmpi.w  #$300,d1
                bhi.w   S3DualCull_ReleaseRespawn
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3DualCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3DualCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3DualCull_DeleteNow:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch3:
                move.w  x_pos(a0),d0

S3TouchCull_TestAnchorAndDraw:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3TouchCull_ReleaseRespawn
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3TouchCull_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3TouchCull_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

S3TouchCull_DeleteNow:
                bra.w   Delete_Current_Sprite

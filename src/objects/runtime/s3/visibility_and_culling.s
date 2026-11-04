; Owner: objects/runtime/s3
; Responsibility: Sprite visibility tests, out-of-range deletion and touch-aware culling wrappers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RuntimeLifetime_ImmediateXDrawCull_ReleaseRespawnWhenOutside
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_ImmediateXDrawCull_ReleaseRespawnWhenOutside:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_ImmediateXDrawCull_ClearSlotAfterOptionalRespawnRelease
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_ImmediateXDrawCull_ClearSlotAfterOptionalRespawnRelease:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_OnScreen_Test2:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RuntimeLifetime_ImmediateSuppliedXDrawCull_ReleaseRespawnWhenOutside
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_ImmediateSuppliedXDrawCull_ReleaseRespawnWhenOutside:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_ImmediateSuppliedXDrawCull_ClearSlot
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_ImmediateSuppliedXDrawCull_ClearSlot:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RuntimeLifetime_ImmediateRangeOnlyCull_ReleaseRespawnWhenOutside
                rts
; ---------------------------------------------------------------------------

S3RuntimeLifetime_ImmediateRangeOnlyCull_ReleaseRespawnWhenOutside:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_ImmediateRangeOnlyCull_ClearSlot
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_ImmediateRangeOnlyCull_ClearSlot:
                bra.w   Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; ---------------------------------------------------------------------------
; unused
                tst.w   (Competition_mode).w
                bne.s   S3RuntimeLifetime_LegacyDualReferenceCull_TestPrimaryCoarseXWindow
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RuntimeLifetime_LegacyNormalDrawCull_ReleaseRespawnWhenOutside
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_LegacyNormalDrawCull_ReleaseRespawnWhenOutside:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_LegacyNormalDrawCull_ClearSlot
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_LegacyNormalDrawCull_ClearSlot:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_LegacyDualReferenceCull_TestPrimaryCoarseXWindow:
                move.w  x_pos(a0),d0
                andi.w  #$FF00,d0
                move.w  d0,d1
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$300,d0
                bhi.w   S3RuntimeLifetime_LegacyDualReferenceCull_TestSecondaryWordXWindow
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_LegacyDualReferenceCull_TestSecondaryWordXWindow:
                sub.w   (_unkF7DC).w,d1
                cmpi.w  #$300,d1
                bhi.w   S3RuntimeLifetime_LegacyDualReferenceCull_ReleaseRespawnOutsideBothWindows
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_LegacyDualReferenceCull_ReleaseRespawnOutsideBothWindows:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_LegacyDualReferenceCull_ClearSlotOutsideBothWindows
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_LegacyDualReferenceCull_ClearSlotOutsideBothWindows:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch3:
                move.w  x_pos(a0),d0

S3RuntimeLifetime_TouchDrawCull_TestSuppliedCoarseXAndRegisterContact:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3RuntimeLifetime_TouchDrawCull_ReleaseRespawnWhenSuppliedAnchorOutside
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

S3RuntimeLifetime_TouchDrawCull_ReleaseRespawnWhenSuppliedAnchorOutside:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_TouchDrawCull_ClearSlotAfterAnchorCull
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_TouchDrawCull_ClearSlotAfterAnchorCull:
                bra.w   Delete_Current_Sprite

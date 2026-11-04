; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss motion, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Try an explosion, delete immediately, and discard the return address to end this update
LRZBossShot_DeleteIfParentDefeated:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LRZBoss_ShotTryImpactExplosion
                rts
; ---------------------------------------------------------------------------

LRZBoss_ShotCheckBossSelfHit:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.w   LRZBoss_SharedReturn
                lea     LRZBoss_ShotSelfHitBounds(pc),a2
                jsr     (Check_InTheirRange).l
                beq.w   LRZBoss_SharedReturn
                bset    #6,status(a1)

LRZBoss_ShotTryImpactExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   LRZBoss_ShotDeleteAndAbortUpdate
                move.b  #6,subtype(a1)

; Discard the caller's return address after deleting the shot and playing the impact sound
LRZBoss_ShotDeleteAndAbortUpdate:
                jsr     (Delete_Current_Sprite).l
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp
                rts
; End of function LRZBossShot_DeleteIfParentDefeated

; ---------------------------------------------------------------------------
LRZBoss_ShotSelfHitBounds:
                dc.w    -$30,   $60,  -$30,   $60
; =============== S U B R O U T I N E =======================================

SetLRZLavaRiderHorizontalStreamVelocity:
                move.w  (Events_bg+$0A).w,d0
                move.w  (_unkFA84).w,d1
                lsr.w   #2,d1
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (_unkFAA2).w
                bne.s   LRZBoss_LavaRiderStoreStreamSpeed
                neg.w   d0

LRZBoss_LavaRiderStoreStreamSpeed:
                move.w  d0,x_vel(a0)
                rts
; End of function SetLRZLavaRiderHorizontalStreamVelocity

; =============== S U B R O U T I N E =======================================

MatchLRZLavaRiderHeightFromWorldXSample:
                move.w  x_pos(a0),d0
                subi.w  #$9E0,d0
                lsr.w   #1,d0
                lea     (HScroll_table+$100).w,a1
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                subi.w  #$30,d1
                neg.w   d1
                addi.w  #$612,d1
                add.w   angle(a0),d1
                move.w  d1,y_pos(a0)
                rts
; End of function MatchLRZLavaRiderHeightFromWorldXSample

; =============== S U B R O U T I N E =======================================

; The projectile sets status bit 6. Consume one HP per new flash, then run four-color recovery or defeat
LRZBoss_HandleSelfHitOrDefeat:
                btst    #6,status(a0)
                beq.s   LRZEndBossHit_ReturnWithoutDefeat
                tst.b   $20(a0)
                bne.s   LRZEndBossHit_SelectFourColorFlashOffset
                subq.b  #1,collision_property(a0)
                beq.s   LRZBoss_DefeatStopStreamAndExplode
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

LRZEndBossHit_SelectFourColorFlashOffset:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LRZBoss_HitCopyColorsAndTick
                addi.w  #2*4,d0

LRZBoss_HitCopyColorsAndTick:
                bsr.w   CopyLRZEndBossFourColorPalette
                subq.b  #1,$20(a0)
                bne.s   LRZEndBossHit_ReturnWithoutDefeat
                bclr    #6,status(a0)

LRZEndBossHit_ReturnWithoutDefeat:
                rts
; ---------------------------------------------------------------------------

LRZBoss_DefeatStopStreamAndExplode:
                move.l  #LRZBoss_SinkDuringDefeat,(a0)
                bset    #7,status(a0)
                clr.b   (_unkFAA3).w
                clr.w   (_unkFA84).w
                st      (Events_fg_5).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   LRZBoss_DefeatStopPressureAndScore
                move.b  #4,subtype(a1)

LRZBoss_DefeatStopPressureAndScore:
                clr.b   (Events_bg+$09).w
                jsr     (BossDefeated_StopTimer).l
                move.w  #$7F,$2E(a0)
                rts
; End of function LRZBoss_HandleSelfHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLRZEndBossFourColorPalette:
                lea     LRZBoss_HitPaletteDestinations(pc),a1
                lea     LRZEndBossHit_TwoFourColorSourceProfiles(pc,d0.w),a2
                jmp     (CopyWordData_4).l
; End of function CopyLRZEndBossFourColorPalette

; ---------------------------------------------------------------------------
LRZBoss_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
LRZEndBossHit_TwoFourColorSourceProfiles:
                dc.w    $406,  $646,  $424,     0
                dc.w    $EEE,  $EEE,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

; Near the boss, spawn debris, detach riders and schedule deletion. Discard the return address to end this update
LRZBossPlatform_TryShatter:
                movea.w (_unkFAA4).w,a1
                tst.w   (a1)
                beq.w   LRZBoss_SharedReturn
                lea     LRZBoss_PlatformShatterBounds(pc),a2
                jsr     (Check_InTheirRange).l
                beq.w   LRZBoss_SharedReturn
                lea     LRZBoss_PlatformDebrisChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Go_Delete_Sprite).l
                jsr     (Displace_PlayerOffObject).l
                moveq   #signextendB(sfx_Clank),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp
                rts
; End of function LRZBossPlatform_TryShatter

; ---------------------------------------------------------------------------
LRZBoss_PlatformShatterBounds:
                dc.w    -$40,   $80,  -$40,   $80

; =============== S U B R O U T I N E =======================================

IsLRZPlatformOriginInsideCameraViewport:
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                cmpi.w  #$140,d0
                bhs.s   LRZBoss_RejectOffscreenPlatform
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                cmpi.w  #$E0,d0
                bhs.s   LRZBoss_RejectOffscreenPlatform
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

LRZBoss_RejectOffscreenPlatform:
                moveq   #0,d0
                rts
; End of function IsLRZPlatformOriginInsideCameraViewport

; =============== S U B R O U T I N E =======================================

MoveLRZPlatformAndResolveTopSolidRiders:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                moveq   #$23,d1
                moveq   #$10,d2
                moveq   #$D,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectTop).l
; End of function MoveLRZPlatformAndResolveTopSolidRiders

; =============== S U B R O U T I N E =======================================

SeedLRZBossPlatformTenDebrisPieces:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  LRZBoss_PlatformDebrisFrames(pc,d0.w),mapping_frame(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                lea     LRZPlatformDebris_SignedSpawnOffsetPairs(pc,d1.w),a2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                add.w   d1,d1
                move.l  LRZPlatformDebris_TenPackedVelocityPairs(pc,d1.w),x_vel(a0)  ; and y_vel
                rts
; End of function SeedLRZBossPlatformTenDebrisPieces

; ---------------------------------------------------------------------------
LRZBoss_PlatformDebrisFrames:
                dc.b    1,   1,   1,   1,   1,   3,   2,   3,   2,   3
                even
LRZPlatformDebris_SignedSpawnOffsetPairs:
                dc.b    -$10,  -8
                dc.b    0,  -8
                dc.b    $10,  -8
                dc.b    -8,   8
                dc.b    8,   8
                dc.b    -$C,  -4
                dc.b    $C,  -4
                dc.b    -$14,   8
                dc.b    $14,   8
                dc.b    0,  $C
LRZPlatformDebris_TenPackedVelocityPairs:
                dc.w    -$280, -$300
                dc.w    $80, -$380
                dc.w    $280, -$300
                dc.w    -$200, -$280
                dc.w    $200, -$280
                dc.w    -$300, -$300
                dc.w    $300, -$280
                dc.w    -$300, -$380
                dc.w    $300, -$380
                dc.w    -$80, -$400
; ---------------------------------------------------------------------------

LRZBoss_WaitCapsuleAndInitPalette:
                tst.b   (_unkFACD).w
                beq.w   LRZBoss_SharedReturn
                move.l  #LRZBoss_RunCapsulePalette,(a0)
                lea     LRZMini_CompletionPaletteScript(pc),a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #LRZBoss_InstallCounterOnlyUpdate,(Palette_rotation_custom).w
                move.w  #$7FFF,(Palette_cycle_counter1).w

LRZBoss_RunCapsulePalette:
                jsr     (Run_PalRotationScript).l

LRZBoss_ForcePaletteCycleCounter:
                move.w  #$7FFF,(Palette_cycle_counter1).w
                rts
; ---------------------------------------------------------------------------

LRZBoss_InstallCounterOnlyUpdate:
                move.l  #LRZBoss_ForcePaletteCycleCounter,(a0)
                rts

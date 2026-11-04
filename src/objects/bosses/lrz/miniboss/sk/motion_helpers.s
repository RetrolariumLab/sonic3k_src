; Owner: objects/bosses/lrz/miniboss/sk
; Responsibility: Lava Reef miniboss child movement, collision, palette and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

CopyLRZMinibossPaletteLinesThreeAndFour:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

LRZMini_CopyUpperPaletteLines:
                move.l  (a1)+,(a2)+
                dbf     d0,LRZMini_CopyUpperPaletteLines
                rts
; End of function CopyLRZMinibossPaletteLinesThreeAndFour

; =============== S U B R O U T I N E =======================================

LRZMiniArm_TryBreakSegmentBySide:
                movea.w $44(a0),a1
                moveq   #6,d0
                btst    #0,render_flags(a0)
                beq.s   LRZMini_ArmCheckSideDefeat
                moveq   #7,d0

LRZMini_ArmCheckSideDefeat:
                btst    d0,$38(a1)
                beq.w   LRZMini_SharedReturn
                move.l  #Wait_Draw,(a0)
                move.w  #$80,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  #$2C,d1
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #LRZMini_ArmTryDefeatExplosion,$34(a0)
                rts
; End of function LRZMiniArm_TryBreakSegmentBySide

; ---------------------------------------------------------------------------

LRZMini_ArmTryDefeatExplosion:
                move.w  #$F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   LRZMini_ArmExplosionSpawnReturn
                move.b  #6,subtype(a1)

LRZMini_ArmExplosionSpawnReturn:
                rts

; =============== S U B R O U T I N E =======================================

SeedLRZMinibossArmProjectileVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.l  LRZMini_ArmShotVelocityPairs-4(pc,d0.w),x_vel(a0)  ; and y_vel
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   LRZMini_ArmShotVelocityReturn
                neg.w   x_vel(a0)

LRZMini_ArmShotVelocityReturn:
                rts
; End of function SeedLRZMinibossArmProjectileVelocity

; ---------------------------------------------------------------------------
LRZMini_ArmShotVelocityPairs:
                dc.w    $200,  $300
                dc.w    $200,  $200
                dc.w    $200,  $100

; =============== S U B R O U T I N E =======================================

; Pop the immediate BSR return into the wait callback and return past the rest of arm initialization
LRZMiniArm_DeferInitContinuation:
                move.l  (sp)+,$34(a0)
                move.l  #Wait_Draw,(a0)
                move.b  #$80,$3C(a0)
                move.b  #1,$40(a0)
                rts
; End of function LRZMiniArm_DeferInitContinuation

; =============== S U B R O U T I N E =======================================

PlaceLRZMinibossArmBaseAtCameraSide:
                move.w  #$20,d0
                btst    #0,render_flags(a0)
                beq.s   LRZMini_ArmPlaceAtCameraSide
                move.w  #$120,d0

LRZMini_ArmPlaceAtCameraSide:
                add.w   (Camera_X_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$1B8,d0
                move.w  d0,y_pos(a0)
                rts
; End of function PlaceLRZMinibossArmBaseAtCameraSide

; =============== S U B R O U T I N E =======================================

; The hit flash uses the existing misaligned six-color source offset. Defeat also destroys both arms
LRZMini_HandleHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   LRZMini_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   LRZMini_BeginDefeatFadeAndSign
                tst.b   $20(a0)
                bne.s   LRZMini_HitChooseFlashOffset
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

; The original parity offset skips two colors, though the reader copies six
LRZMini_HitChooseFlashOffset:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LRZMini_HitCopyColorsAndTick
; Bug: this should be 2*6
                addi.w  #2*2,d0

LRZMini_HitCopyColorsAndTick:
                bsr.w   LRZMini_CopyPalette6
                subq.b  #1,$20(a0)
                bne.s   LRZMini_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

LRZMini_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_BeginDefeatFadeAndSign:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.w  #$80,priority(a0)
                bset    #6,$38(a0)
                bset    #7,$38(a0)
                move.l  #LRZMini_TryPostSignPaletteActor,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jsr     (Displace_PlayerOffObject).l
                jmp     (BossDefeated_StopTimer).l
; End of function LRZMini_HandleHitFlashOrDefeat

; =============== S U B R O U T I N E =======================================

; d0.w is a source byte offset and can select the misaligned flash row
LRZMini_CopyPalette6:
                lea     LRZMini_HitPaletteDestinations(pc),a1
                lea     LRZMini_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_6).l
; End of function LRZMini_CopyPalette6

; ---------------------------------------------------------------------------
LRZMini_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$10
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
LRZMini_HitPaletteColorRows:
                dc.w    $2A,     6,     2,  $644,  $422,     0
                dc.w    $888,  $AAA,  $CCC,  $AAA,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

; Continue the active flash during noncolliding retraction. Zero HP still enters defeat
LRZMini_TickFlashWhileRetracting:
                tst.b   collision_property(a0)
                beq.s   LRZMini_BeginDefeatFadeAndSign
                tst.b   $20(a0)
                beq.s   LRZMini_RetractFlashReturn
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LRZMini_TickRetractHitFlash
; Bug: this should be 2*6
                addi.w  #2*2,d0

LRZMini_TickRetractHitFlash:
                bsr.s   LRZMini_CopyPalette6
                subq.b  #1,$20(a0)
                bne.s   LRZMini_RetractFlashReturn
                bclr    #6,status(a0)

LRZMini_RetractFlashReturn:
                rts
; End of function LRZMini_TickFlashWhileRetracting

; =============== S U B R O U T I N E =======================================

; A hit disables collision during the flash and spawns an impact. A defeated tip marks its side in the root
LRZMiniArmTip_HandleHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   LRZMini_ArmHitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   LRZMini_ArmChooseDefeatSide
                tst.b   $20(a0)
                bne.s   LRZMini_ArmTickHitRecovery
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     LRZMini_ArmHitOverlayChild(pc),a2
                jsr     (CreateChild6_Simple).l

LRZMini_ArmTickHitRecovery:
                subq.b  #1,$20(a0)
                bne.s   LRZMini_ArmHitUpdateReturn
                move.b  $25(a0),collision_flags(a0)

LRZMini_ArmHitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_ArmChooseDefeatSide:
                movea.w $44(a0),a1
                move.w  #6,d0
                btst    #0,render_flags(a0)
                beq.s   LRZMini_ArmSignalDefeatAndCheckBoth
                move.w  #7,d0

LRZMini_ArmSignalDefeatAndCheckBoth:
                bset    d0,$38(a1)
                move.b  $38(a1),d0
                andi.b  #$C0,d0
                cmpi.b  #$C0,d0
                bne.s   LRZMini_ArmHitUpdateReturn
                move.w  #$1F,$2E(a1)
                rts
; End of function LRZMiniArmTip_HandleHitOrDefeat

; Owner: objects/bosses/soz/end_boss/sk
; Responsibility: Sandopolis end-boss child motion, collision, palette and attack helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Reload the motion profile only during a negative joint-angle phase and at the edge in the travel direction
SOZBoss_TryReloadMotionAtBounds:
                tst.b   $3C(a0)
                bpl.s   SOZBoss_TurnBoundsReturn
                tst.w   x_vel(a0)
                bpl.s   SOZBoss_CheckRightLimitAndReset
                cmpi.w  #$4E80,x_pos(a0)
                bhs.s   SOZBoss_TurnBoundsReturn
                lea     SOZEndBoss_CatchUpSixWordMotionProfile(pc),a1
                bra.w   SOZBoss_LoadMotionProfile
; ---------------------------------------------------------------------------

SOZBoss_CheckRightLimitAndReset:
                cmpi.w  #$5210,x_pos(a0)
                bhs.w   SOZBoss_ChooseMotionProfile

SOZBoss_TurnBoundsReturn:
                rts
; End of function SOZBoss_TryReloadMotionAtBounds

; ---------------------------------------------------------------------------
SOZEndBoss_CatchUpSixWordMotionProfile:
                dc.w    $400,  $800, -$400,   $1F,    $F,     7

; =============== S U B R O U T I N E =======================================

TickSOZEndBossChargeAttackSpawnTimer:
                subq.w  #1,(SceneTimerOrSharedMotionRecordBase).w
                bpl.w   SOZBoss_SharedActorReturn
                move.w  #$200,(SceneTimerOrSharedMotionRecordBase).w
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                lea     SOZBoss_ChargeGeneratorChild(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function TickSOZEndBossChargeAttackSpawnTimer

; =============== S U B R O U T I N E =======================================

UpdateSOZEndBossSineBobFromAngleStep:
                move.b  angle(a0),d0
                sub.b   $3E(a0),d0
                move.b  d0,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function UpdateSOZEndBossSineBobFromAngleStep

; =============== S U B R O U T I N E =======================================

SOZBossUpper_CheckBothContacts:
                swap    d6
                moveq   #0,d0
                lea     (Player_1).w,a1
                bsr.w   SOZBossUpper_TryOpenEyeOrHurt
                moveq   #1,d0
                lea     (Player_2).w,a1
; End of function SOZBossUpper_CheckBothContacts

; =============== S U B R O U T I N E =======================================

; Eligible attacks from the left open the eye. Side contact from the right requests guarded damage
SOZBossUpper_TryOpenEyeOrHurt:
                btst    d0,d6
                beq.s   SOZBoss_UpperContactReturn
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SOZBoss_UpperContactHurtPlayer
                cmpi.b  #2,anim(a1)
                beq.s   SOZBoss_OpenEyeAndExposeBoss
                cmpi.b  #2,character_id(a1)
                bne.s   SOZBoss_OpenEyeAndExposeBoss
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   SOZBoss_UpperContactReturn

SOZBoss_OpenEyeAndExposeBoss:
                move.w  y_pos(a1),(Events_bg+$0A).w
                move.l  #SOZBoss_UpperBodySuspendDuringEye,(a0)
                move.w  #-$400,x_vel(a1)
                move.w  #-$300,y_vel(a1)
                movea.w parent3(a0),a2
                move.b  routine(a2),$42(a2)
                move.b  #$C,routine(a2)
                move.b  #$F,collision_flags(a2)
                jsr     (Displace_PlayerOffObject).l

SOZBoss_UpperContactReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_UpperContactHurtPlayer:
                jmp     (HurtPlayerFromSolidHazard).l
; End of function SOZBossUpper_TryOpenEyeOrHurt

; =============== S U B R O U T I N E =======================================

SOZBossLower_CheckBothContacts:
                swap    d6
                moveq   #0,d0
                moveq   #p1_standing_bit,d1
                lea     (Player_1).w,a1
                bsr.w   SOZBossLower_DetachOrHurt
                moveq   #1,d0
                moveq   #p2_standing_bit,d1
                lea     (Player_2).w,a1
; End of function SOZBossLower_CheckBothContacts

; =============== S U B R O U T I N E =======================================

; Check both side contact and stale standing attachment. The local damage gate can suppress the hurt request
SOZBossLower_DetachOrHurt:
                btst    d0,d6
                bne.s   SOZBoss_LowerDetachAndTryHurt
                bclr    d1,status(a0)
                beq.s   SOZBoss_LowerContactReturn

SOZBoss_LowerDetachAndTryHurt:
                bclr    #Status_OnObj,status(a1)
                tst.b   invulnerability_timer(a1)
                bne.s   SOZBoss_LowerContactReturn
                andi.b  #$9F,status(a0)
                jsr     (HurtPlayerFromSolidHazard).l

SOZBoss_LowerContactReturn:
                rts
; End of function SOZBossLower_DetachOrHurt

; =============== S U B R O U T I N E =======================================

SOZBossArm_CheckContactsWhileAlive:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   SOZBoss_ArmContactReturn
                swap    d6
                moveq   #0,d0
                lea     (Player_1).w,a1
                bsr.w   HurtSOZEndBossArmContactPlayerOnLeftSide
                moveq   #1,d0
                lea     (Player_2).w,a1
; End of function SOZBossArm_CheckContactsWhileAlive

; =============== S U B R O U T I N E =======================================

HurtSOZEndBossArmContactPlayerOnLeftSide:
                btst    d0,d6
                beq.s   SOZBoss_ArmContactReturn
                tst.b   $34(a1)
                bne.s   SOZBoss_ArmContactReturn
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SOZBoss_ArmContactReturn
                andi.b  #$9F,status(a0)
                jsr     (HurtPlayerFromSolidHazard).l

SOZBoss_ArmContactReturn:
                rts
; End of function HurtSOZEndBossArmContactPlayerOnLeftSide

; =============== S U B R O U T I N E =======================================

; Load signed fixed-point offsets and stagger the start delay across twenty particles
SOZBossCharge_InitParticle:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     SOZBoss_ChargeParticleOffsets(pc,d0.w),a1
                move.b  (a1)+,$3A(a0)
                move.b  (a1)+,$3C(a0)
                move.w  SOZBoss_ChargeParticleOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                addq.w  #2,d0
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; End of function SOZBossCharge_InitParticle

; ---------------------------------------------------------------------------
SOZBoss_ChargeParticleOffsets:
                dc.b    -$16,   2
                dc.b    -$10,  -8
                dc.b    -$14,   9
                dc.b    -$1B,  -4
                dc.b    -$D,   8
                dc.b    -$16,  -5
                dc.b    -$1F,   4
                dc.b    -$12,  $D
                dc.b    -$18,  -8
                dc.b    -$14,  -1
                dc.b    -$20,  -2
                dc.b    -$1C,  $C
                dc.b    -$1A,  -1
                dc.b    -$24,   9
                dc.b    -$1F, -$A
                dc.b    -$1A,   4
                dc.b    -$14,   2
                dc.b    -$16,   6
                dc.b    -$18, -$C
                dc.b    -$26,  $C
                even
; ---------------------------------------------------------------------------

SOZBoss_CheckExposedHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   SOZBoss_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   SOZBoss_BeginDefeatAndLockCamera
                tst.b   $20(a0)
                bne.s   SOZBoss_HitChooseFlashRow
                bset    #6,status(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

SOZBoss_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   SOZBoss_HitCopyColorsAndTick
                addi.w  #2*5,d0

; Copy only the first three colors from the selected five-color row
SOZBoss_HitCopyColorsAndTick:
                bsr.w   SOZBoss_CopyPalette3Of5
                subq.b  #1,$20(a0)
                bne.s   SOZBoss_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

SOZBoss_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_BeginDefeatAndLockCamera:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #SOZBoss_BeginDefeatDropAndRelease,$34(a0)
                move.w  #$55,(Events_fg_5).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                jmp     (BossDefeated_StopTimer).l

; =============== S U B R O U T I N E =======================================

SOZBoss_CopyPalette3Of5:
                lea     SOZBoss_HitPaletteDestinations(pc),a1
                lea     SOZBoss_HitPaletteColorRows(pc,d0.w),a2
; Bug: this should go to CopyWordData_5
                jmp     (CopyWordData_3).l
; End of function SOZBoss_CopyPalette3Of5

; ---------------------------------------------------------------------------
SOZBoss_HitPaletteDestinations:
                dc.w    Normal_palette_line_4+$0C, Normal_palette_line_4+$0E, Normal_palette_line_4+$10
                dc.w    Normal_palette_line_4+$12, Normal_palette_line_4+$14
SOZBoss_HitPaletteColorRows:
                dc.w    $6E,  $24C,   $28,     4,     2
                dc.w    $AAA,  $CCC,  $CCC,  $EEE,  $EEE

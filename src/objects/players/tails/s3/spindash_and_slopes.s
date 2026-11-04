; Owner: objects/players/tails/s3
; Responsibility: Tails spindash charge, slope resistance, rolling repulsion, slope detachment and airborne angle control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsSpindash_MaintainHeldChargeOrReleaseNormalTailsGeometry
                cmpi.b  #8,anim(a0)
                bne.s   S3TailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsSpindash_ApplyBoundsAttachmentAndBackgroundChecksAfterChargeStart
                move.b  #2,anim(a6)

S3TailsSpindash_ApplyBoundsAttachmentAndBackgroundChecksAfterChargeStart:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                sub.w   d1,x_pos(a0)

S3TailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext:
                rts
; ---------------------------------------------------------------------------

S3TailsSpindash_MaintainHeldChargeOrReleaseNormalTailsGeometry:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   S3TailsSpindash_DecayHeldSpindashChargeUsingLogicalWordShift
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  S3TailsSpindash_NormalTailsSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   S3TailsSpindash_StorePreFacingDashHistoryLagThenSignLaunchSpeed
                lea     (H_scroll_frame_offset_P2).w,a1

S3TailsSpindash_StorePreFacingDashHistoryLagThenSignLaunchSpeed:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsSpindash_CommitReleasedRollStopDustAndPlayDashSound
                neg.w   ground_vel(a0)

S3TailsSpindash_CommitReleasedRollStopDustAndPlayDashSound:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   S3TailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
; ---------------------------------------------------------------------------
S3TailsSpindash_NormalTailsSpindashLaunchSpeedWords:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
; ---------------------------------------------------------------------------

S3TailsSpindash_DecayHeldSpindashChargeUsingLogicalWordShift:
                tst.w   spin_dash_counter(a0)
                beq.s   S3TailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   S3TailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation
                move.w  #0,spin_dash_counter(a0)

S3TailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   S3TailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
                move.w  #$800,spin_dash_counter(a0)

S3TailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   S3TailsSpindash_AttachAndCheckBackgroundAfterActiveChargeOrRelease
                bcc.s   S3TailsSpindash_SubtractSpindashCameraRecoveryStep
                addq.w  #4,(a5)

S3TailsSpindash_SubtractSpindashCameraRecoveryStep:
                subq.w  #2,(a5)

S3TailsSpindash_AttachAndCheckBackgroundAfterActiveChargeOrRelease:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsSpindash_ReturnToOuterModeAfterChargeReleaseTail
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsSpindash_ReturnToOuterModeAfterChargeReleaseTail
                sub.w   d1,x_pos(a0)

S3TailsSpindash_ReturnToOuterModeAfterChargeReleaseTail:
                rts
; End of function Tails_Spindash

; =============== S U B R O U T I N E =======================================

Tails_SlopeResist:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   S3TailsSlope_ReturnAfterPrivateSlopeResistanceGateOrNegativeAddition
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   S3TailsSlope_ReturnAfterPrivateSlopeResistanceGateOrNegativeAddition
                bmi.s   S3TailsSlope_AddSlopeResistanceToNegativeGroundSpeed
                tst.w   d0
                beq.s   S3TailsSlope_ReturnAfterPositiveSlopeResistanceOrZeroForce
                add.w   d0,ground_vel(a0)

S3TailsSlope_ReturnAfterPositiveSlopeResistanceOrZeroForce:
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_AddSlopeResistanceToNegativeGroundSpeed:
                add.w   d0,ground_vel(a0)

S3TailsSlope_ReturnAfterPrivateSlopeResistanceGateOrNegativeAddition:
                rts
; End of function Tails_SlopeResist

; =============== S U B R O U T I N E =======================================

Tails_RollRepel:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   S3TailsSlope_ReturnAfterRollingSlopeGateOrNegativeForce
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   S3TailsSlope_ChooseRollingSlopeForceScaleForNegativeGroundSpeed
                tst.w   d0
                bpl.s   S3TailsSlope_AddRollingSlopeForceForNonnegativeGroundSpeed
                asr.l   #2,d0

S3TailsSlope_AddRollingSlopeForceForNonnegativeGroundSpeed:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_ChooseRollingSlopeForceScaleForNegativeGroundSpeed:
                tst.w   d0
                bmi.s   S3TailsSlope_AddRollingSlopeForceForNegativeGroundSpeed
                asr.l   #2,d0

S3TailsSlope_AddRollingSlopeForceForNegativeGroundSpeed:
                add.w   d0,ground_vel(a0)

S3TailsSlope_ReturnAfterRollingSlopeGateOrNegativeForce:
                rts
; End of function Tails_RollRepel

; =============== S U B R O U T I N E =======================================

Tails_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   S3TailsSlope_ReturnAfterPrivateSlopeRepelGateOrDetachment
                tst.w   move_lock(a0)
                bne.s   S3TailsSlope_DecrementPrivateSlopeMoveLockOnlyWhenNotSticky
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   S3TailsSlope_ReturnAfterPrivateSlopeRepelGateOrDetachment
                move.w  ground_vel(a0),d0
                bpl.s   S3TailsSlope_DetachSlowTailsFromNonflatSlopeAndLockControls
                neg.w   d0

S3TailsSlope_DetachSlowTailsFromNonflatSlopeAndLockControls:
                cmpi.w  #$280,d0
                bcc.s   S3TailsSlope_ReturnAfterPrivateSlopeRepelGateOrDetachment
                clr.w   ground_vel(a0)
                bset    #Status_InAir,status(a0)
                move.w  #30,move_lock(a0)

S3TailsSlope_ReturnAfterPrivateSlopeRepelGateOrDetachment:
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_DecrementPrivateSlopeMoveLockOnlyWhenNotSticky:
                subq.w  #1,move_lock(a0)
                rts
; End of function Tails_SlopeRepel

; =============== S U B R O U T I N E =======================================

Tails_JumpAngle:
                move.b  angle(a0),d0
                beq.s   S3TailsSlope_GateSecondaryFlipAndChooseGroundSpeedDirection
                bpl.s   S3TailsSlope_RecoverPositivePrimaryAngleTowardZero
                addq.b  #2,d0
                bcc.s   S3TailsSlope_JoinNegativePrimaryAngleRecoveryAtStore
                moveq   #0,d0

S3TailsSlope_JoinNegativePrimaryAngleRecoveryAtStore:
                bra.s   S3TailsSlope_StoreRecoveredPrimaryAngleBeforeFlipUpdate
; ---------------------------------------------------------------------------

S3TailsSlope_RecoverPositivePrimaryAngleTowardZero:
                subq.b  #2,d0
                bcc.s   S3TailsSlope_StoreRecoveredPrimaryAngleBeforeFlipUpdate
                moveq   #0,d0

S3TailsSlope_StoreRecoveredPrimaryAngleBeforeFlipUpdate:
                move.b  d0,angle(a0)

S3TailsSlope_GateSecondaryFlipAndChooseGroundSpeedDirection:
                move.b  flip_angle(a0),d0
                beq.s   S3TailsSlope_ReturnAfterPrimaryAngleAndOptionalSecondaryFlip
                tst.w   ground_vel(a0)
                bmi.s   S3TailsSlope_AdvanceLeftFlipUnlessFlipTypeSignReversesIt

S3TailsSlope_AdvanceRightFlipAndConsumeCountOnlyOnByteWrap:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   S3TailsSlope_JoinRightFlipAtSecondaryAngleStore
                subq.b  #1,flips_remaining(a0)
                bcc.s   S3TailsSlope_JoinRightFlipAtSecondaryAngleStore
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

S3TailsSlope_JoinRightFlipAtSecondaryAngleStore:
                bra.s   S3TailsSlope_StoreSecondaryFlipAngleAfterDirectionAndWrapHandling
; ---------------------------------------------------------------------------

S3TailsSlope_AdvanceLeftFlipUnlessFlipTypeSignReversesIt:
                tst.b   flip_type(a0)
                bmi.s   S3TailsSlope_AdvanceRightFlipAndConsumeCountOnlyOnByteWrap
                move.b  flip_speed(a0),d1
                sub.b   d1,d0
                bcc.s   S3TailsSlope_StoreSecondaryFlipAngleAfterDirectionAndWrapHandling
                subq.b  #1,flips_remaining(a0)
                bcc.s   S3TailsSlope_StoreSecondaryFlipAngleAfterDirectionAndWrapHandling
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

S3TailsSlope_StoreSecondaryFlipAngleAfterDirectionAndWrapHandling:
                move.b  d0,flip_angle(a0)

S3TailsSlope_ReturnAfterPrimaryAngleAndOptionalSecondaryFlip:
                rts
; End of function Tails_JumpAngle

; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles rolling speed, airborne direction input and jump peak deceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_RollSpeed:
                move.w  Max_speed-Max_speed(a4),d6
                asl.w   #1,d6
                move.w  Acceleration-Max_speed(a4),d5
                asr.w   #1,d5
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnucklesRolling_SetFixedRollingBrakeAndGateForcedLockedInput
                move.w  #6,d5

SKKnucklesRolling_SetFixedRollingBrakeAndGateForcedLockedInput:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection
                tst.b   status_secondary(a0)
                bmi.w   SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection
                tst.w   move_lock(a0)
                bne.s   SKKnucklesRolling_ApplyRollingFrictionEvenWithHeldDirectionsOrMoveLock
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesRolling_ApplyRightRollingInputAfterLeftInput
                bsr.w   KnucklesSKApplyRollingLeftInput

SKKnucklesRolling_ApplyRightRollingInputAfterLeftInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesRolling_ApplyRollingFrictionEvenWithHeldDirectionsOrMoveLock
                bsr.w   KnucklesSKApplyRollingRightInput

SKKnucklesRolling_ApplyRollingFrictionEvenWithHeldDirectionsOrMoveLock:
                move.w  ground_vel(a0),d0
                beq.s   SKKnucklesRolling_BuildWordMagnitudeForUnrollThreshold
                bmi.s   SKKnucklesRolling_ApplyNegativeRollingFrictionWithCarryClamp
                sub.w   d5,d0
                bcc.s   SKKnucklesRolling_StorePositiveRollingFrictionBeforeUnrollMagnitude
                move.w  #0,d0

SKKnucklesRolling_StorePositiveRollingFrictionBeforeUnrollMagnitude:
                move.w  d0,ground_vel(a0)
                bra.s   SKKnucklesRolling_BuildWordMagnitudeForUnrollThreshold
; ---------------------------------------------------------------------------

SKKnucklesRolling_ApplyNegativeRollingFrictionWithCarryClamp:
                add.w   d5,d0
                bcc.s   SKKnucklesRolling_StoreNegativeRollingFrictionBeforeUnrollMagnitude
                move.w  #0,d0

SKKnucklesRolling_StoreNegativeRollingFrictionBeforeUnrollMagnitude:
                move.w  d0,ground_vel(a0)

SKKnucklesRolling_BuildWordMagnitudeForUnrollThreshold:
                move.w  ground_vel(a0),d0
                bpl.s   SKKnucklesRolling_UnrollBelowUnsignedEightyOrMaintainForcedRoll
                neg.w   d0

SKKnucklesRolling_UnrollBelowUnsignedEightyOrMaintainForcedRoll:
                cmpi.w  #$80,d0
                bhs.s   SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnucklesRolling_RestoreForcedRollSpeedByFacingBelowUnrollThreshold
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesRolling_ApplyGravityAdjustedUnrollDeltaToIntegerY
                neg.w   d0

SKKnucklesRolling_ApplyGravityAdjustedUnrollDeltaToIntegerY:
                add.w   d0,y_pos(a0)
                bra.s   SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection
; ---------------------------------------------------------------------------

SKKnucklesRolling_RestoreForcedRollSpeedByFacingBelowUnrollThreshold:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection
                neg.w   ground_vel(a0)

SKKnucklesRolling_RecoverRollingCameraBeforeVelocityProjection:
                cmpi.w  #$60,(a5)
                beq.s   SKKnucklesRolling_ProjectRollingYAndClampPositiveProjectedXWord
                bcc.s   SKKnucklesRolling_SubtractRollingCameraRecoveryStep
                addq.w  #4,(a5)

SKKnucklesRolling_SubtractRollingCameraRecoveryStep:
                subq.w  #2,(a5)

SKKnucklesRolling_ProjectRollingYAndClampPositiveProjectedXWord:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   SKKnucklesRolling_ClampNegativeRollingProjectionWord
                move.w  #$1000,d1

SKKnucklesRolling_ClampNegativeRollingProjectionWord:
                cmpi.w  #-$1000,d1
                bge.s   SKKnucklesRolling_StoreRollingXAndTailBranchGroundObstruction
                move.w  #-$1000,d1

SKKnucklesRolling_StoreRollingXAndTailBranchGroundObstruction:
                move.w  d1,x_vel(a0)
                bra.w   SKKnucklesGround_GateSharedWalkingAndRollingObstructionProbe
; End of function Knux_RollSpeed

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKKnucklesRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration
                bpl.s   SKKnucklesRolling_BrakePositiveRollByFixedTwentyForLeftInput

SKKnucklesRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesRolling_BrakePositiveRollByFixedTwentyForLeftInput:
                sub.w   d4,d0
                bcc.s   SKKnucklesRolling_StoreLeftRollingBrakeAndReturn
                move.w  #-$80,d0

SKKnucklesRolling_StoreLeftRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function KnucklesSKApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKKnucklesRolling_BrakeNegativeRollByFixedTwentyForRightInput
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesRolling_BrakeNegativeRollByFixedTwentyForRightInput:
                add.w   d4,d0
                bcc.s   SKKnucklesRolling_StoreRightRollingBrakeAndReturn
                move.w  #$80,d0

SKKnucklesRolling_StoreRightRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function KnucklesSKApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

; sub_17680:
Knux_ChgJumpDir:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   SKKnucklesRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKKnucklesRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKKnucklesRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                move.w  d1,d0

SKKnucklesRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesRolling_CommitAirInputHorizontalVelocity
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKKnucklesRolling_CommitAirInputHorizontalVelocity
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKKnucklesRolling_CommitAirInputHorizontalVelocity
                move.w  d6,d0

SKKnucklesRolling_CommitAirInputHorizontalVelocity:
                move.w  d0,x_vel(a0)

SKKnucklesRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput:
                cmpi.w  #$60,(a5)
                beq.s   SKKnucklesRolling_GateAirDragByUnsignedUpwardVelocityWindow
                bcc.s   SKKnucklesRolling_SubtractAirCameraRecoveryStep
                addq.w  #4,(a5)

SKKnucklesRolling_SubtractAirCameraRecoveryStep:
                subq.w  #2,(a5)

SKKnucklesRolling_GateAirDragByUnsignedUpwardVelocityWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   SKKnucklesRolling_ReturnAfterAirDragOrRejectedVelocity
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   SKKnucklesRolling_ReturnAfterAirDragOrRejectedVelocity
                bmi.s   SKKnucklesRolling_ApplyNegativeQuotientAirDragWithBorrowPolarity
                sub.w   d1,d0
                bcc.s   SKKnucklesRolling_CommitPositiveQuotientAirDrag
                move.w  #0,d0

SKKnucklesRolling_CommitPositiveQuotientAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesRolling_ApplyNegativeQuotientAirDragWithBorrowPolarity:
                sub.w   d1,d0
                bcs.s   SKKnucklesRolling_CommitNegativeQuotientAirDrag
                move.w  #0,d0

SKKnucklesRolling_CommitNegativeQuotientAirDrag:
                move.w  d0,x_vel(a0)

SKKnucklesRolling_ReturnAfterAirDragOrRejectedVelocity:
                rts
; End of function Knux_ChgJumpDir

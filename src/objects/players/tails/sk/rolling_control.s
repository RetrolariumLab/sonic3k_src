; Owner: objects/players/tails/sk
; Responsibility: Tails rolling speed control and airborne input acceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_RollSpeed:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                asl.w   #1,d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asr.w   #1,d5
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsRolling_SetFixedRollingBrakeAndGateForcedOrLockedInput
                move.w  #6,d5

SKTailsRolling_SetFixedRollingBrakeAndGateForcedOrLockedInput:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.b   status_secondary(a0)
                bmi.w   SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.w   move_lock(a0)
                bne.s   SKTailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsRolling_ApplyRightRollingInputAfterLeftInput
                bsr.w   TailsSKApplyRollingLeftInput

SKTailsRolling_ApplyRightRollingInputAfterLeftInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   SKTailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput
                bsr.w   TailsSKApplyRollingRightInput

SKTailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy
                bmi.s   SKTailsRolling_ApplyNegativeRollingFrictionWithCarryClamp
                sub.w   d5,d0
                bcc.s   SKTailsRolling_StorePositiveRollingFrictionBeforeUnrollTest
                move.w  #0,d0

SKTailsRolling_StorePositiveRollingFrictionBeforeUnrollTest:
                move.w  d0,ground_vel(a0)
                bra.s   SKTailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy
; ---------------------------------------------------------------------------

SKTailsRolling_ApplyNegativeRollingFrictionWithCarryClamp:
                add.w   d5,d0
                bcc.s   SKTailsRolling_StoreNegativeRollingFrictionBeforeUnrollTest
                move.w  #0,d0

SKTailsRolling_StoreNegativeRollingFrictionBeforeUnrollTest:
                move.w  d0,ground_vel(a0)

SKTailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy:
                move.w  ground_vel(a0),d0
                bpl.s   SKTailsRolling_UnrollBelowUnsignedEightyOrRestoreForcedRollSpeed
                neg.w   d0

SKTailsRolling_UnrollBelowUnsignedEightyOrRestoreForcedRollSpeed:
                cmpi.w  #$80,d0
                bhs.s   SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsRolling_RestoreForcedRollSpeedByFacingAtUnrollThreshold
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsRolling_ApplyGravityAdjustedUnrollOffsetToIntegerY
                neg.w   d0

SKTailsRolling_ApplyGravityAdjustedUnrollOffsetToIntegerY:
                add.w   d0,y_pos(a0)
                bra.s   SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
; ---------------------------------------------------------------------------

SKTailsRolling_RestoreForcedRollSpeedByFacingAtUnrollThreshold:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                neg.w   ground_vel(a0)

SKTailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsRolling_ProjectRollingVelocityAndClampPositiveXWord
                bcc.s   SKTailsRolling_SubtractRollingCameraRecoveryStep
                addq.w  #4,(a5)

SKTailsRolling_SubtractRollingCameraRecoveryStep:
                subq.w  #2,(a5)

SKTailsRolling_ProjectRollingVelocityAndClampPositiveXWord:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   SKTailsRolling_ClampNegativeRollingXProjectionWord
                move.w  #$1000,d1

SKTailsRolling_ClampNegativeRollingXProjectionWord:
                cmpi.w  #-$1000,d1
                bge.s   SKTailsRolling_StoreRollingXAndTailBranchSharedObstruction
                move.w  #-$1000,d1

SKTailsRolling_StoreRollingXAndTailBranchSharedObstruction:
                move.w  d1,x_vel(a0)
                bra.w   SKTailsGround_GateProjectedGroundObstructionForWalkingAndRolling
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

TailsSKApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration
                bpl.s   SKTailsRolling_BrakePositiveRollForLeftHeldInput

SKTailsRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRolling_BrakePositiveRollForLeftHeldInput:
                sub.w   d4,d0
                bcc.s   SKTailsRolling_StoreLeftRollingBrakeAndReturn
                move.w  #-$80,d0

SKTailsRolling_StoreLeftRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsSKApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

TailsSKApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKTailsRolling_BrakeNegativeRollForRightHeldInput
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRolling_BrakeNegativeRollForRightHeldInput:
                add.w   d4,d0
                bcc.s   SKTailsRolling_StoreRightRollingBrakeAndReturn
                move.w  #$80,d0

SKTailsRolling_StoreRightRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsSKApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   SKTailsRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKTailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKTailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                move.w  d1,d0

SKTailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   SKTailsRolling_CommitAirHorizontalInputVelocity
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKTailsRolling_CommitAirHorizontalInputVelocity
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKTailsRolling_CommitAirHorizontalInputVelocity
                move.w  d6,d0

SKTailsRolling_CommitAirHorizontalInputVelocity:
                move.w  d0,x_vel(a0)

SKTailsRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsRolling_GateAirHorizontalDragByUnsignedUpwardVelocityWindow
                bcc.s   SKTailsRolling_SubtractAirCameraRecoveryStep
                addq.w  #4,(a5)

SKTailsRolling_SubtractAirCameraRecoveryStep:
                subq.w  #2,(a5)

SKTailsRolling_GateAirHorizontalDragByUnsignedUpwardVelocityWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   SKTailsRolling_ReturnAfterAirDragOrIneligibleVelocity
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   SKTailsRolling_ReturnAfterAirDragOrIneligibleVelocity
                bmi.s   SKTailsRolling_ApplyNegativeQuotientAirDragUsingBorrowPolarity
                sub.w   d1,d0
                bcc.s   SKTailsRolling_CommitNonnegativeQuotientAirDrag
                move.w  #0,d0

SKTailsRolling_CommitNonnegativeQuotientAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRolling_ApplyNegativeQuotientAirDragUsingBorrowPolarity:
                sub.w   d1,d0
                bcs.s   SKTailsRolling_CommitNegativeQuotientAirDrag
                move.w  #0,d0

SKTailsRolling_CommitNegativeQuotientAirDrag:
                move.w  d0,x_vel(a0)

SKTailsRolling_ReturnAfterAirDragOrIneligibleVelocity:
                rts
; End of function Tails_InputAcceleration_Freespace

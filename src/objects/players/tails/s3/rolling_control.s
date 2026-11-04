; Owner: objects/players/tails/s3
; Responsibility: Tails rolling speed control and airborne input acceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_RollSpeed:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                asl.w   #1,d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asr.w   #1,d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                asr.w   #2,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.b   status_secondary(a0)
                bmi.w   S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.w   move_lock(a0)
                bne.s   S3TailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsRolling_ApplyRightRollingInputAfterLeftInput
                bsr.w   TailsS3ApplyRollingLeftInput

S3TailsRolling_ApplyRightRollingInputAfterLeftInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput
                bsr.w   TailsS3ApplyRollingRightInput

S3TailsRolling_ApplyRollingFrictionRegardlessHeldHorizontalInput:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy
                bmi.s   S3TailsRolling_ApplyNegativeRollingFrictionWithCarryClamp
                sub.w   d5,d0
                bcc.s   S3TailsRolling_StorePositiveRollingFrictionBeforeUnrollTest
                move.w  #0,d0

S3TailsRolling_StorePositiveRollingFrictionBeforeUnrollTest:
                move.w  d0,ground_vel(a0)
                bra.s   S3TailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy
; ---------------------------------------------------------------------------

S3TailsRolling_ApplyNegativeRollingFrictionWithCarryClamp:
                add.w   d5,d0
                bcc.s   S3TailsRolling_StoreNegativeRollingFrictionBeforeUnrollTest
                move.w  #0,d0

S3TailsRolling_StoreNegativeRollingFrictionBeforeUnrollTest:
                move.w  d0,ground_vel(a0)

S3TailsRolling_ClassifyPostFrictionSpeedForProfileUnrollPolicy:
                tst.w   ground_vel(a0)
                bne.s   S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsRolling_RestoreForcedRollSpeedByFacingAtUnrollThreshold
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                bra.s   S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
; ---------------------------------------------------------------------------

S3TailsRolling_RestoreForcedRollSpeedByFacingAtUnrollThreshold:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection
                neg.w   ground_vel(a0)

S3TailsRolling_RecoverRollingCameraTargetBeforeVelocityProjection:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsRolling_ProjectRollingVelocityAndClampPositiveXWord
                bcc.s   S3TailsRolling_SubtractRollingCameraRecoveryStep
                addq.w  #4,(a5)

S3TailsRolling_SubtractRollingCameraRecoveryStep:
                subq.w  #2,(a5)

S3TailsRolling_ProjectRollingVelocityAndClampPositiveXWord:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   S3TailsRolling_ClampNegativeRollingXProjectionWord
                move.w  #$1000,d1

S3TailsRolling_ClampNegativeRollingXProjectionWord:
                cmpi.w  #-$1000,d1
                bge.s   S3TailsRolling_StoreRollingXAndTailBranchSharedObstruction
                move.w  #-$1000,d1

S3TailsRolling_StoreRollingXAndTailBranchSharedObstruction:
                move.w  d1,x_vel(a0)
                bra.w   S3TailsGround_GateProjectedGroundObstructionForWalkingAndRolling
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration
                bpl.s   S3TailsRolling_BrakePositiveRollForLeftHeldInput

S3TailsRolling_FaceLeftAndKeepRollAnimationWithoutAcceleration:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRolling_BrakePositiveRollForLeftHeldInput:
                sub.w   d4,d0
                bcc.s   S3TailsRolling_StoreLeftRollingBrakeAndReturn
                move.w  #-$80,d0

S3TailsRolling_StoreLeftRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   S3TailsRolling_BrakeNegativeRollForRightHeldInput
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRolling_BrakeNegativeRollForRightHeldInput:
                add.w   d4,d0
                bcc.s   S3TailsRolling_StoreRightRollingBrakeAndReturn
                move.w  #$80,d0

S3TailsRolling_StoreRightRollingBrakeAndReturn:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   S3TailsRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   S3TailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   S3TailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep
                move.w  d1,d0

S3TailsRolling_ApplyRightAirInputAfterOverspeedPreservingLeftStep:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsRolling_CommitAirHorizontalInputVelocity
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   S3TailsRolling_CommitAirHorizontalInputVelocity
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   S3TailsRolling_CommitAirHorizontalInputVelocity
                move.w  d6,d0

S3TailsRolling_CommitAirHorizontalInputVelocity:
                move.w  d0,x_vel(a0)

S3TailsRolling_RecoverAirCameraEvenWhenRollJumpBlocksInput:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsRolling_GateAirHorizontalDragByUnsignedUpwardVelocityWindow
                bcc.s   S3TailsRolling_SubtractAirCameraRecoveryStep
                addq.w  #4,(a5)

S3TailsRolling_SubtractAirCameraRecoveryStep:
                subq.w  #2,(a5)

S3TailsRolling_GateAirHorizontalDragByUnsignedUpwardVelocityWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   S3TailsRolling_ReturnAfterAirDragOrIneligibleVelocity
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   S3TailsRolling_ReturnAfterAirDragOrIneligibleVelocity
                bmi.s   S3TailsRolling_ApplyNegativeQuotientAirDragUsingBorrowPolarity
                sub.w   d1,d0
                bcc.s   S3TailsRolling_CommitNonnegativeQuotientAirDrag
                move.w  #0,d0

S3TailsRolling_CommitNonnegativeQuotientAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRolling_ApplyNegativeQuotientAirDragUsingBorrowPolarity:
                sub.w   d1,d0
                bcs.s   S3TailsRolling_CommitNegativeQuotientAirDrag
                move.w  #0,d0

S3TailsRolling_CommitNegativeQuotientAirDrag:
                move.w  d0,x_vel(a0)

S3TailsRolling_ReturnAfterAirDragOrIneligibleVelocity:
                rts
; End of function Tails_InputAcceleration_Freespace

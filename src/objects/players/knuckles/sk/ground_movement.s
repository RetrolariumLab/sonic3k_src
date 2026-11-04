; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_InputAcceleration_Path:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                move.w  Deceleration-Max_speed(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   SKKnucklesGround_ProjectGroundSpeedIntoUnclampedWalkingVelocity
                tst.w   move_lock(a0)
                bne.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesGround_ApplyRightGroundInputAfterLeftInput
                bsr.w   KnucklesSKApplyGroundLeftInput

SKKnucklesGround_ApplyRightGroundInputAfterLeftInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesGround_GateStationaryBalanceAndTwoPixelObjectEdges
                bsr.w   KnucklesSKApplyGroundRightInput

SKKnucklesGround_GateStationaryBalanceAndTwoPixelObjectEdges:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
                tst.w   ground_vel(a0)
                bne.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.w   SKKnucklesGround_ProbeTerrainBalanceAndPreferForwardTiltThree
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.w   SKKnucklesGround_PrioritizeDelayedDuckCameraOverLookUp
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #2,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #2,d1
                blt.s   SKKnucklesGround_ChooseObjectLeftBalanceFromExistingFacing
                cmp.w   d2,d1
                bge.s   SKKnucklesGround_ChooseObjectRightBalanceFromExistingFacing
                bra.w   SKKnucklesGround_PrioritizeDelayedDuckCameraOverLookUp
; ---------------------------------------------------------------------------

SKKnucklesGround_ChooseObjectRightBalanceFromExistingFacing:
                btst    #Status_Facing,status(a0)
                bne.s   SKKnucklesGround_TurnRightAndResumeObjectBalanceAtFrameFour
                move.b  #6,anim(a0)
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_TurnRightAndResumeObjectBalanceAtFrameFour:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_ChooseObjectLeftBalanceFromExistingFacing:
                btst    #Status_Facing,status(a0)
                beq.s   SKKnucklesGround_TurnLeftAndResumeObjectBalanceAtFrameFour
                move.b  #6,anim(a0)
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_TurnLeftAndResumeObjectBalanceAtFrameFour:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_ProbeTerrainBalanceAndPreferForwardTiltThree:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKKnucklesGround_PrioritizeDelayedDuckCameraOverLookUp
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKKnucklesGround_RequireRearTiltThreeForTerrainLeftBalance
                btst    #Status_Facing,status(a0)
                bne.s   SKKnucklesGround_TurnRightAndResumeTerrainBalanceAtFrameFour
                move.b  #6,anim(a0)
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_TurnRightAndResumeTerrainBalanceAtFrameFour:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_RequireRearTiltThreeForTerrainLeftBalance:
                cmpi.b  #3,tilt(a0)
                bne.s   SKKnucklesGround_PrioritizeDelayedDuckCameraOverLookUp
                btst    #Status_Facing,status(a0)
                beq.s   SKKnucklesGround_TurnLeftAndResumeTerrainBalanceAtFrameFour
                move.b  #6,anim(a0)
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_TurnLeftAndResumeTerrainBalanceAtFrameFour:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKKnucklesGround_PrioritizeDelayedDuckCameraOverLookUp:
                btst    #button_down,(Ctrl_1_held_logical).w
                beq.s   SKKnucklesGround_CheckDelayedLookUpOnlyWithoutDown
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKKnucklesGround_RecoverCameraTargetTowardSixtyWithUnsignedComparison
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnucklesGround_RaiseReverseGravityDuckCameraTargetTowardD8
                cmpi.w  #8,(a5)
                beq.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
                subq.w  #2,(a5)
                bra.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
; ---------------------------------------------------------------------------

SKKnucklesGround_RaiseReverseGravityDuckCameraTargetTowardD8:
                cmpi.w  #$D8,(a5)
                beq.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
                addq.w  #2,(a5)
                bra.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
; ---------------------------------------------------------------------------

SKKnucklesGround_CheckDelayedLookUpOnlyWithoutDown:
                btst    #button_up,(Ctrl_1_logical).w
                beq.s   SKKnucklesGround_ResetLookDelayBeforeCameraRecovery
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKKnucklesGround_RecoverCameraTargetTowardSixtyWithUnsignedComparison
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnucklesGround_LowerReverseGravityLookUpTargetToward18
                cmpi.w  #$C8,(a5)
                beq.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
                addq.w  #2,(a5)
                bra.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
; ---------------------------------------------------------------------------

SKKnucklesGround_LowerReverseGravityLookUpTargetToward18:
                cmpi.w  #$18,(a5)
                beq.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
                subq.w  #2,(a5)
                bra.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
; ---------------------------------------------------------------------------

SKKnucklesGround_ResetLookDelayBeforeCameraRecovery:
                move.b  #0,scroll_delay_counter(a0)

SKKnucklesGround_RecoverCameraTargetTowardSixtyWithUnsignedComparison:
                cmpi.w  #$60,(a5)
                beq.s   SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper
                bcc.s   SKKnucklesGround_SubtractTwoFromVerticalCameraRecoveryTarget
                addq.w  #4,(a5)

SKKnucklesGround_SubtractTwoFromVerticalCameraRecoveryTarget:
                subq.w  #2,(a5)

SKKnucklesGround_OverrideNeutralGroundFrictionForSuperOrHyper:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnucklesGround_ApplyGroundFrictionOnlyWithoutHeldHorizontalDirections
                move.w  #$C,d5

SKKnucklesGround_ApplyGroundFrictionOnlyWithoutHeldHorizontalDirections:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKKnucklesGround_ProjectGroundSpeedIntoUnclampedWalkingVelocity
                move.w  ground_vel(a0),d0
                beq.s   SKKnucklesGround_ProjectGroundSpeedIntoUnclampedWalkingVelocity
                bmi.s   SKKnucklesGround_ReduceNegativeGroundSpeedWithCarryClamp
                sub.w   d5,d0
                bcc.s   SKKnucklesGround_StorePositiveNeutralGroundFriction
                move.w  #0,d0

SKKnucklesGround_StorePositiveNeutralGroundFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKKnucklesGround_ProjectGroundSpeedIntoUnclampedWalkingVelocity
; ---------------------------------------------------------------------------

SKKnucklesGround_ReduceNegativeGroundSpeedWithCarryClamp:
                add.w   d5,d0
                bcc.s   SKKnucklesGround_StoreNegativeNeutralGroundFriction
                move.w  #0,d0

SKKnucklesGround_StoreNegativeNeutralGroundFriction:
                move.w  d0,ground_vel(a0)

SKKnucklesGround_ProjectGroundSpeedIntoUnclampedWalkingVelocity:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKKnucklesGround_GateSharedWalkingAndRollingObstructionProbe:
                btst    #6,object_control(a0)
                bne.w   SKKnucklesGround_ReturnAfterProjectionGateOrVerticalObstruction
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKKnucklesGround_ChooseObstructionDirectionFromGroundSpeedSign
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKKnucklesGround_ReturnAfterProjectionGateOrVerticalObstruction

SKKnucklesGround_ChooseObstructionDirectionFromGroundSpeedSign:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKKnucklesGround_ReturnAfterProjectionGateOrVerticalObstruction
                bmi.s   SKKnucklesGround_ProbeAheadAndRestoreRequestedDirectionBeforeResponse
                neg.w   d1

SKKnucklesGround_ProbeAheadAndRestoreRequestedDirectionBeforeResponse:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKKnucklesGround_ReturnAfterProjectionGateOrVerticalObstruction
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKKnucklesGround_RoundSavedDirectionAndResolveVelocityObstruction
                tst.b   d0
                bpl.s   SKKnucklesGround_RoundSavedDirectionAndResolveVelocityObstruction
                subq.b  #1,d0

SKKnucklesGround_RoundSavedDirectionAndResolveVelocityObstruction:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKKnucklesGround_AddScaledFloorGapToYVelocity
                cmpi.b  #$40,d0
                beq.s   SKKnucklesGround_ResolveLeftWallVelocityAndPushOnlyFacingLeft
                cmpi.b  #$80,d0
                beq.s   SKKnucklesGround_SubtractScaledCeilingGapFromYVelocity
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKKnucklesGround_ReturnAfterHorizontalResponseAndFacingDependentPush
                bset    #Status_Push,status(a0)

SKKnucklesGround_ReturnAfterHorizontalResponseAndFacingDependentPush:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGround_SubtractScaledCeilingGapFromYVelocity:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesGround_ResolveLeftWallVelocityAndPushOnlyFacingLeft:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKKnucklesGround_ReturnAfterHorizontalResponseAndFacingDependentPush
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesGround_AddScaledFloorGapToYVelocity:
                add.w   d1,y_vel(a0)

SKKnucklesGround_ReturnAfterProjectionGateOrVerticalObstruction:
                rts
; End of function Knux_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKKnucklesGround_FaceLeftAndRestartMovementOnlyWhenFacingChanged
                bpl.s   SKKnucklesGround_BrakePositiveGroundSpeedForLeftHeldInput

SKKnucklesGround_FaceLeftAndRestartMovementOnlyWhenFacingChanged:
                bset    #Status_Facing,status(a0)
                bne.s   SKKnucklesGround_AccelerateLeftWhilePreservingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKKnucklesGround_AccelerateLeftWhilePreservingExistingOverspeed:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKKnucklesGround_CommitLeftAccelerationAndMovementAnimation
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKKnucklesGround_CommitLeftAccelerationAndMovementAnimation
                move.w  d1,d0

SKKnucklesGround_CommitLeftAccelerationAndMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesGround_BrakePositiveGroundSpeedForLeftHeldInput:
                sub.w   d4,d0
                bcc.s   SKKnucklesGround_StoreLeftBrakeThenTestSkidWithDestroyedLowByte
                move.w  #-$80,d0

SKKnucklesGround_StoreLeftBrakeThenTestSkidWithDestroyedLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKKnucklesGround_ReturnAfterLeftSkidGateAndOptionalDustRequest
                cmpi.w  #$400,d0
                blt.s   SKKnucklesGround_ReturnAfterLeftSkidGateAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKKnucklesGround_ReturnAfterLeftSkidGateAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKKnucklesGround_ReturnAfterLeftSkidGateAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKKnucklesGround_ReturnAfterLeftSkidGateAndOptionalDustRequest:
                rts
; End of function KnucklesSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKKnucklesGround_BrakeNegativeGroundSpeedForRightHeldInput
                bclr    #Status_Facing,status(a0)
                beq.s   SKKnucklesGround_AccelerateRightWhilePreservingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKKnucklesGround_AccelerateRightWhilePreservingExistingOverspeed:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKKnucklesGround_CommitRightAccelerationAndMovementAnimation
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKKnucklesGround_CommitRightAccelerationAndMovementAnimation
                move.w  d6,d0

SKKnucklesGround_CommitRightAccelerationAndMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnucklesGround_BrakeNegativeGroundSpeedForRightHeldInput:
                add.w   d4,d0
                bcc.s   SKKnucklesGround_StoreRightBrakeThenTestSkidWithDestroyedLowByte
                move.w  #$80,d0

SKKnucklesGround_StoreRightBrakeThenTestSkidWithDestroyedLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKKnucklesGround_ReturnAfterRightSkidGateAndOptionalDustRequest
                cmpi.w  #-$400,d0
                bgt.s   SKKnucklesGround_ReturnAfterRightSkidGateAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKKnucklesGround_ReturnAfterRightSkidGateAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKKnucklesGround_ReturnAfterRightSkidGateAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKKnucklesGround_ReturnAfterRightSkidGateAndOptionalDustRequest:
                rts
; End of function KnucklesSKApplyGroundRightInput

; Owner: objects/players/tails/s3
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   S3TailsGround_ProjectGroundSpeedThroughSignedSineCosine
                tst.w   move_lock(a0)
                bne.w   S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_ApplyRightHeldInputAfterLeftInput
                bsr.w   TailsS3ApplyGroundLeftInput

S3TailsGround_ApplyRightHeldInputAfterLeftInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_GateStationaryFlatSectorBalanceAndIdleLook
                bsr.w   TailsS3ApplyGroundRightInput

S3TailsGround_GateStationaryFlatSectorBalanceAndIdleLook:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                tst.w   ground_vel(a0)
                bne.w   S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   S3TailsGround_ProbeTerrainBalanceAndPreferForwardTiltThree
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   S3TailsGround_SelectIdleVerticalLookWithProfilePriority
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   S3TailsGround_FaceLeftForStationaryBalance
                cmp.w   d2,d1
                bge.s   S3TailsGround_FaceRightForStationaryBalance
                bra.s   S3TailsGround_SelectIdleVerticalLookWithProfilePriority
; ---------------------------------------------------------------------------

S3TailsGround_ProbeTerrainBalanceAndPreferForwardTiltThree:
                jsr     (ChkFloorEdge).l
                cmpi.w  #$C,d1
                blt.s   S3TailsGround_SelectIdleVerticalLookWithProfilePriority
                cmpi.b  #3,next_tilt(a0)
                bne.s   S3TailsGround_RequireRearTiltThreeForLeftBalance

S3TailsGround_FaceRightForStationaryBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   S3TailsGround_SelectBalanceAnimationAndResetLookDelay
; ---------------------------------------------------------------------------

S3TailsGround_RequireRearTiltThreeForLeftBalance:
                cmpi.b  #3,tilt(a0)
                bne.s   S3TailsGround_SelectIdleVerticalLookWithProfilePriority

S3TailsGround_FaceLeftForStationaryBalance:
                bset    #Status_Facing,status(a0)

S3TailsGround_SelectBalanceAnimationAndResetLookDelay:
                move.b  #6,anim(a0)
                bra.s   S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

S3TailsGround_SelectIdleVerticalLookWithProfilePriority:
                btst    #button_up,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_CheckOtherIdleLookDirectionAndDelayedCameraTarget
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   S3TailsGround_RecoverVerticalCameraTargetTowardSixty
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #$C8,(a5)
                beq.s   S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
                addq.w  #2,(a5)
                bra.s   S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
; ---------------------------------------------------------------------------

S3TailsGround_CheckOtherIdleLookDirectionAndDelayedCameraTarget:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   S3TailsGround_RecoverVerticalCameraTargetTowardSixty
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #8,(a5)
                beq.s   S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
                subq.w  #2,(a5)
                bra.s   S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
; ---------------------------------------------------------------------------

S3TailsGround_ResetVerticalLookDelayBeforeCameraRecovery:
                move.b  #0,scroll_delay_counter(a0)

S3TailsGround_RecoverVerticalCameraTargetTowardSixty:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
                bcc.s   S3TailsGround_SubtractTwoFromCameraRecoveryTarget
                addq.w  #4,(a5)

S3TailsGround_SubtractTwoFromCameraRecoveryTarget:
                subq.w  #2,(a5)

S3TailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3TailsGround_ProjectGroundSpeedThroughSignedSineCosine
                move.w  ground_vel(a0),d0
                beq.s   S3TailsGround_ProjectGroundSpeedThroughSignedSineCosine
                bmi.s   S3TailsGround_ReduceNegativeNeutralGroundSpeedByAcceleration
                sub.w   d5,d0
                bcc.s   S3TailsGround_CommitPositiveNeutralGroundFriction
                move.w  #0,d0

S3TailsGround_CommitPositiveNeutralGroundFriction:
                move.w  d0,ground_vel(a0)
                bra.s   S3TailsGround_ProjectGroundSpeedThroughSignedSineCosine
; ---------------------------------------------------------------------------

S3TailsGround_ReduceNegativeNeutralGroundSpeedByAcceleration:
                add.w   d5,d0
                bcc.s   S3TailsGround_CommitNegativeNeutralGroundFriction
                move.w  #0,d0

S3TailsGround_CommitNegativeNeutralGroundFriction:
                move.w  d0,ground_vel(a0)

S3TailsGround_ProjectGroundSpeedThroughSignedSineCosine:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

S3TailsGround_GateProjectedGroundObstructionForWalkingAndRolling:
                btst    #6,object_control(a0)
                bne.w   S3TailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.s   S3TailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   S3TailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                bmi.s   S3TailsGround_ProbeAheadUsingSavedRequestedSurfaceDirection
                neg.w   d1

S3TailsGround_ProbeAheadUsingSavedRequestedSurfaceDirection:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   S3TailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   S3TailsGround_AddScaledFloorObstructionToYVelocity
                cmpi.b  #$40,d0
                beq.s   S3TailsGround_ResolveLeftWallVelocityAndPushOnlyWhenFacingLeft
                cmpi.b  #$80,d0
                beq.s   S3TailsGround_SubtractScaledCeilingObstructionFromYVelocity
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   S3TailsGround_ReturnAfterHorizontalObstructionAndOptionalPush
                bset    #Status_Push,status(a0)

S3TailsGround_ReturnAfterHorizontalObstructionAndOptionalPush:
                rts
; ---------------------------------------------------------------------------

S3TailsGround_SubtractScaledCeilingObstructionFromYVelocity:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_ResolveLeftWallVelocityAndPushOnlyWhenFacingLeft:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsGround_ReturnAfterHorizontalObstructionAndOptionalPush
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_AddScaledFloorObstructionToYVelocity:
                add.w   d1,y_vel(a0)

S3TailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

TailsS3ApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsGround_FaceLeftForNonpositiveGroundAcceleration
                bpl.s   S3TailsGround_BrakePositiveGroundSpeedForLeftInput

S3TailsGround_FaceLeftForNonpositiveGroundAcceleration:
                bset    #Status_Facing,status(a0)
                bne.s   S3TailsGround_AccelerateLeftWithoutClampingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

S3TailsGround_AccelerateLeftWithoutClampingExistingOverspeed:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   S3TailsGround_StoreLeftAccelerationAndSelectMovementAnimation
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   S3TailsGround_StoreLeftAccelerationAndSelectMovementAnimation
                move.w  d1,d0

S3TailsGround_StoreLeftAccelerationAndSelectMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_BrakePositiveGroundSpeedForLeftInput:
                sub.w   d4,d0
                bcc.s   S3TailsGround_StoreLeftBrakeAndTestSkidWithOverwrittenLowByte
                move.w  #-$80,d0

S3TailsGround_StoreLeftBrakeAndTestSkidWithOverwrittenLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   S3TailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                cmpi.w  #$400,d0
                blt.s   S3TailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   S3TailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

S3TailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest:
                rts
; End of function TailsS3ApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

TailsS3ApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   S3TailsGround_BrakeNegativeGroundSpeedForRightInput
                bclr    #Status_Facing,status(a0)
                beq.s   S3TailsGround_AccelerateRightWithoutClampingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

S3TailsGround_AccelerateRightWithoutClampingExistingOverspeed:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   S3TailsGround_StoreRightAccelerationAndSelectMovementAnimation
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   S3TailsGround_StoreRightAccelerationAndSelectMovementAnimation
                move.w  d6,d0

S3TailsGround_StoreRightAccelerationAndSelectMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_BrakeNegativeGroundSpeedForRightInput:
                add.w   d4,d0
                bcc.s   S3TailsGround_StoreRightBrakeAndTestSkidWithOverwrittenLowByte
                move.w  #$80,d0

S3TailsGround_StoreRightBrakeAndTestSkidWithOverwrittenLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   S3TailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                cmpi.w  #-$400,d0
                bgt.s   S3TailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   S3TailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

S3TailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest:
                rts
; End of function TailsS3ApplyGroundRightInput

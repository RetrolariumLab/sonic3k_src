; Owner: objects/players/tails/sk
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   SKTailsGround_ProjectGroundSpeedThroughSignedSineCosine
                tst.w   move_lock(a0)
                bne.w   SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsGround_ApplyRightHeldInputAfterLeftInput
                bsr.w   TailsSKApplyGroundLeftInput

SKTailsGround_ApplyRightHeldInputAfterLeftInput:
                btst    #button_right,(Ctrl_2_logical).w
                beq.s   SKTailsGround_GateStationaryFlatSectorBalanceAndIdleLook
                bsr.w   TailsSKApplyGroundRightInput

SKTailsGround_GateStationaryFlatSectorBalanceAndIdleLook:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                tst.w   ground_vel(a0)
                bne.w   SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsGround_ProbeTerrainBalanceAndPreferForwardTiltThree
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   SKTailsGround_SelectIdleVerticalLookWithProfilePriority
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   SKTailsGround_FaceLeftForStationaryBalance
                cmp.w   d2,d1
                bge.s   SKTailsGround_FaceRightForStationaryBalance
                bra.s   SKTailsGround_SelectIdleVerticalLookWithProfilePriority
; ---------------------------------------------------------------------------

SKTailsGround_ProbeTerrainBalanceAndPreferForwardTiltThree:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.s   SKTailsGround_SelectIdleVerticalLookWithProfilePriority
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKTailsGround_RequireRearTiltThreeForLeftBalance

SKTailsGround_FaceRightForStationaryBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   SKTailsGround_SelectBalanceAnimationAndResetLookDelay
; ---------------------------------------------------------------------------

SKTailsGround_RequireRearTiltThreeForLeftBalance:
                cmpi.b  #3,tilt(a0)
                bne.s   SKTailsGround_SelectIdleVerticalLookWithProfilePriority

SKTailsGround_FaceLeftForStationaryBalance:
                bset    #Status_Facing,status(a0)

SKTailsGround_SelectBalanceAnimationAndResetLookDelay:
                move.b  #6,anim(a0)
                bra.s   SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery
; ---------------------------------------------------------------------------

SKTailsGround_SelectIdleVerticalLookWithProfilePriority:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   SKTailsGround_CheckOtherIdleLookDirectionAndDelayedCameraTarget
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKTailsGround_RecoverVerticalCameraTargetTowardSixty
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsGround_MoveReverseGravityDuckCameraTowardD8
                cmpi.w  #8,(a5)
                beq.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
                subq.w  #2,(a5)
                bra.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
; ---------------------------------------------------------------------------

SKTailsGround_MoveReverseGravityDuckCameraTowardD8:
                cmpi.w  #$D8,(a5)
                beq.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
                addq.w  #2,(a5)
                bra.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
; ---------------------------------------------------------------------------

SKTailsGround_CheckOtherIdleLookDirectionAndDelayedCameraTarget:
                btst    #button_up,(Ctrl_2_logical).w
                beq.s   SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKTailsGround_RecoverVerticalCameraTargetTowardSixty
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsGround_MoveReverseGravityLookUpCameraToward18
                cmpi.w  #$C8,(a5)
                beq.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
                addq.w  #2,(a5)
                bra.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
; ---------------------------------------------------------------------------

SKTailsGround_MoveReverseGravityLookUpCameraToward18:
                cmpi.w  #$18,(a5)
                beq.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
                subq.w  #2,(a5)
                bra.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
; ---------------------------------------------------------------------------

SKTailsGround_ResetVerticalLookDelayBeforeCameraRecovery:
                move.b  #0,scroll_delay_counter(a0)

SKTailsGround_RecoverVerticalCameraTargetTowardSixty:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag
                bcc.s   SKTailsGround_SubtractTwoFromCameraRecoveryTarget
                addq.w  #4,(a5)

SKTailsGround_SubtractTwoFromCameraRecoveryTarget:
                subq.w  #2,(a5)

SKTailsGround_OverrideNeutralGroundFrictionForAnySuperTailsFlag:
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput
                move.w  #$C,d5

SKTailsGround_ApplyNeutralGroundFrictionOnlyWithoutHeldHorizontalInput:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKTailsGround_ProjectGroundSpeedThroughSignedSineCosine
                move.w  ground_vel(a0),d0
                beq.s   SKTailsGround_ProjectGroundSpeedThroughSignedSineCosine
                bmi.s   SKTailsGround_ReduceNegativeNeutralGroundSpeedByAcceleration
                sub.w   d5,d0
                bcc.s   SKTailsGround_CommitPositiveNeutralGroundFriction
                move.w  #0,d0

SKTailsGround_CommitPositiveNeutralGroundFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKTailsGround_ProjectGroundSpeedThroughSignedSineCosine
; ---------------------------------------------------------------------------

SKTailsGround_ReduceNegativeNeutralGroundSpeedByAcceleration:
                add.w   d5,d0
                bcc.s   SKTailsGround_CommitNegativeNeutralGroundFriction
                move.w  #0,d0

SKTailsGround_CommitNegativeNeutralGroundFriction:
                move.w  d0,ground_vel(a0)

SKTailsGround_ProjectGroundSpeedThroughSignedSineCosine:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKTailsGround_GateProjectedGroundObstructionForWalkingAndRolling:
                btst    #6,object_control(a0)
                bne.w   SKTailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKTailsGround_ChooseObstructionOffsetForSignedGroundDirection
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKTailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse

SKTailsGround_ChooseObstructionOffsetForSignedGroundDirection:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKTailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                bmi.s   SKTailsGround_ProbeAheadUsingSavedRequestedSurfaceDirection
                neg.w   d1

SKTailsGround_ProbeAheadUsingSavedRequestedSurfaceDirection:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKTailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKTailsGround_ClassifySavedObstructionDirectionAfterZoneEightTweak
                tst.b   d0
                bpl.s   SKTailsGround_ClassifySavedObstructionDirectionAfterZoneEightTweak
                subq.b  #1,d0

SKTailsGround_ClassifySavedObstructionDirectionAfterZoneEightTweak:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKTailsGround_AddScaledFloorObstructionToYVelocity
                cmpi.b  #$40,d0
                beq.s   SKTailsGround_ResolveLeftWallVelocityAndPushOnlyWhenFacingLeft
                cmpi.b  #$80,d0
                beq.s   SKTailsGround_SubtractScaledCeilingObstructionFromYVelocity
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKTailsGround_ReturnAfterHorizontalObstructionAndOptionalPush
                bset    #Status_Push,status(a0)

SKTailsGround_ReturnAfterHorizontalObstructionAndOptionalPush:
                rts
; ---------------------------------------------------------------------------

SKTailsGround_SubtractScaledCeilingObstructionFromYVelocity:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_ResolveLeftWallVelocityAndPushOnlyWhenFacingLeft:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsGround_ReturnAfterHorizontalObstructionAndOptionalPush
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_AddScaledFloorObstructionToYVelocity:
                add.w   d1,y_vel(a0)

SKTailsGround_ReturnAfterProjectionObstructionGateOrVerticalResponse:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

TailsSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsGround_FaceLeftForNonpositiveGroundAcceleration
                bpl.s   SKTailsGround_BrakePositiveGroundSpeedForLeftInput

SKTailsGround_FaceLeftForNonpositiveGroundAcceleration:
                bset    #Status_Facing,status(a0)
                bne.s   SKTailsGround_AccelerateLeftWithoutClampingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKTailsGround_AccelerateLeftWithoutClampingExistingOverspeed:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKTailsGround_StoreLeftAccelerationAndSelectMovementAnimation
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKTailsGround_StoreLeftAccelerationAndSelectMovementAnimation
                move.w  d1,d0

SKTailsGround_StoreLeftAccelerationAndSelectMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_BrakePositiveGroundSpeedForLeftInput:
                sub.w   d4,d0
                bcc.s   SKTailsGround_StoreLeftBrakeAndTestSkidWithOverwrittenLowByte
                move.w  #-$80,d0

SKTailsGround_StoreLeftBrakeAndTestSkidWithOverwrittenLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKTailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                cmpi.w  #$400,d0
                blt.s   SKTailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKTailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKTailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKTailsGround_ReturnAfterLeftBrakeSkidAndOptionalDustRequest:
                rts
; End of function TailsSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

TailsSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKTailsGround_BrakeNegativeGroundSpeedForRightInput
                bclr    #Status_Facing,status(a0)
                beq.s   SKTailsGround_AccelerateRightWithoutClampingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKTailsGround_AccelerateRightWithoutClampingExistingOverspeed:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKTailsGround_StoreRightAccelerationAndSelectMovementAnimation
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKTailsGround_StoreRightAccelerationAndSelectMovementAnimation
                move.w  d6,d0

SKTailsGround_StoreRightAccelerationAndSelectMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_BrakeNegativeGroundSpeedForRightInput:
                add.w   d4,d0
                bcc.s   SKTailsGround_StoreRightBrakeAndTestSkidWithOverwrittenLowByte
                move.w  #$80,d0

SKTailsGround_StoreRightBrakeAndTestSkidWithOverwrittenLowByte:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKTailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                cmpi.w  #-$400,d0
                bgt.s   SKTailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKTailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKTailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKTailsGround_ReturnAfterRightBrakeSkidAndOptionalDustRequest:
                rts
; End of function TailsSKApplyGroundRightInput

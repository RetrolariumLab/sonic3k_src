; Owner: objects/players/sonic/sk
; Responsibility: Sonic ground acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Move:
                move.w  Max_speed-Max_speed(a4),d6      ; set Max_speed
                move.w  Acceleration-Max_speed(a4),d5   ; set Acceleration
                move.w  Deceleration-Max_speed(a4),d4   ; set Deceleration
                tst.b   status_secondary(a0)            ; is bit 7 set? (Infinite inertia)
                bmi.w   SKSonicGroundMove_ProjectGroundSpeedIntoCartesianVelocity  ; if so, branch
                tst.w   move_lock(a0)
                bne.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                btst    #button_left,(Ctrl_1_held_logical).w  ; is left being pressed?
                beq.s   Sonic_NotLeft                   ; if not, branch
                bsr.w   SonicSKApplyGroundLeftInput

Sonic_NotLeft:
                btst    #button_right,(Ctrl_1_held_logical).w  ; is right being pressed?
                beq.s   Sonic_NotRight                  ; if not, branch
                bsr.w   SonicSKApplyGroundRightInput

Sonic_NotRight:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0                         ; is Sonic on a slope?
                bne.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if yes, branch
                tst.w   ground_vel(a0)                  ; is Sonic moving?
                bne.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if yes, branch
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)                     ; use standing animation
                btst    #Status_OnObj,status(a0)
                beq.w   Sonic_Balance
                movea.w interact(a0),a1                 ; load interacting object's RAM space
                tst.b   status(a1)                      ; is status bit 7 set? (unused?)
                bmi.w   SKSonicGroundMove_CheckPrimaryStationaryLookControl  ; if so, branch

; Calculations to determine where on the object Sonic is, and make him balance accordingly
                moveq   #0,d1                           ; Clear d1
                move.b  width_pixels(a1),d1             ; Load interacting object's width into d1
                move.w  d1,d2                           ; Move to d2 for separate calculations
                add.w   d2,d2                           ; Double object width, converting it to X pos' units of measurement
                subq.w  #2,d2                           ; Subtract 2: This is the margin for 'on edge'
                add.w   x_pos(a0),d1                    ; Add Sonic's X position to object width
                sub.w   x_pos(a1),d1                    ; Subtract object's X position from width+Sonic's X pos, giving you Sonic's distance from left edge of object
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   SuperSonic_Balance              ; if so, branch
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.s   Sonic_BalanceOnObjLeft          ; if so, branch
                cmp.w   d2,d1
                bge.s   Sonic_BalanceOnObjRight         ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   SKSonicGroundMove_CheckPrimaryStationaryLookControl  ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------

SuperSonic_Balance:
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.w   SKSonicGroundMove_FaceLeftForPoweredObjectOrTerrainBalance  ; if so, branch
                cmp.w   d2,d1
                bge.w   SKSonicGroundMove_FaceRightForPoweredObjectOrTerrainBalance  ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   SKSonicGroundMove_CheckPrimaryStationaryLookControl  ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------
; balancing checks for when you're on the right edge of an object

Sonic_BalanceOnObjRight:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                bne.s   SKSonicGroundMove_FaceRightAndChooseObjectRightEdgeBalance  ; if so, branch
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery

SKSonicGroundMove_FaceRightAndChooseObjectRightEdgeBalance:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------

Sonic_BalanceOnObjLeft:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                beq.s   SKSonicGroundMove_FaceLeftAndChooseObjectLeftEdgeBalance
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery

SKSonicGroundMove_FaceLeftAndChooseObjectLeftEdgeBalance:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bset    #Status_Facing,status(a0)       ; is Sonic facing right?
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery  ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------
; balancing checks for when you're on the edge of part of the level

Sonic_Balance:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGroundMove_CheckPrimaryStationaryLookControl
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   SKSonicGroundMove_CheckPoweredTerrainRightEdgeSensor  ; if so, branch
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKSonicGroundMove_CheckOtherTerrainSensorBeforeLeftEdgeBalance
                btst    #Status_Facing,status(a0)
                bne.s   SKSonicGroundMove_FaceRightAndReprobeTerrainSixPixelsLeftForBalance
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                move.b  #$C,anim(a0)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; on right edge but facing left:

SKSonicGroundMove_FaceRightAndReprobeTerrainSixPixelsLeftForBalance:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                move.b  #$C,anim(a0)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------

SKSonicGroundMove_CheckOtherTerrainSensorBeforeLeftEdgeBalance:
                cmpi.b  #3,tilt(a0)
                bne.s   SKSonicGroundMove_CheckPrimaryStationaryLookControl
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicGroundMove_FaceLeftAndReprobeTerrainSixPixelsRightForBalance
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                move.b  #$C,anim(a0)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------

SKSonicGroundMove_FaceLeftAndReprobeTerrainSixPixelsRightForBalance:
                bset    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                move.b  #$C,anim(a0)
                bra.w   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------

SKSonicGroundMove_CheckPoweredTerrainRightEdgeSensor:
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKSonicGroundMove_CheckPoweredTerrainLeftEdgeSensor

SKSonicGroundMove_FaceRightForPoweredObjectOrTerrainBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   SKSonicGroundMove_SetPoweredBalanceAnimationAndResetLookDelay
; ---------------------------------------------------------------------------

SKSonicGroundMove_CheckPoweredTerrainLeftEdgeSensor:
                cmpi.b  #3,tilt(a0)
                bne.s   SKSonicGroundMove_CheckPrimaryStationaryLookControl

SKSonicGroundMove_FaceLeftForPoweredObjectOrTerrainBalance:
                bset    #Status_Facing,status(a0)

SKSonicGroundMove_SetPoweredBalanceAnimationAndResetLookDelay:
                move.b  #6,anim(a0)
                bra.s   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
; ---------------------------------------------------------------------------

SKSonicGroundMove_CheckPrimaryStationaryLookControl:
                btst    #button_down,(Ctrl_1_logical).w
                beq.s   SKSonicGroundMove_CheckSecondaryStationaryLookControl
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   SKSonicGroundMove_RecoverCameraDistanceTowardDefaultByTwo
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSonicGroundMove_RaiseCameraDistanceForReverseGravityDuck
                cmpi.w  #8,(a5)
                beq.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
                subq.w  #2,(a5)
                bra.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
; ---------------------------------------------------------------------------

SKSonicGroundMove_RaiseCameraDistanceForReverseGravityDuck:
                cmpi.w  #$D8,(a5)
                beq.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
                addq.w  #2,(a5)
                bra.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
; ---------------------------------------------------------------------------

SKSonicGroundMove_CheckSecondaryStationaryLookControl:
                btst    #button_up,(Ctrl_1_held_logical).w
                beq.s   SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   SKSonicGroundMove_RecoverCameraDistanceTowardDefaultByTwo
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSonicGroundMove_LowerCameraDistanceForReverseGravityLookUp
                cmpi.w  #$C8,(a5)
                beq.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
                addq.w  #2,(a5)
                bra.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
; ---------------------------------------------------------------------------

SKSonicGroundMove_LowerCameraDistanceForReverseGravityLookUp:
                cmpi.w  #$18,(a5)
                beq.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
                subq.w  #2,(a5)
                bra.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
; ---------------------------------------------------------------------------

SKSonicGroundMove_ResetLookDelayBeforeCameraOffsetRecovery:
                move.b  #0,scroll_delay_counter(a0)

SKSonicGroundMove_RecoverCameraDistanceTowardDefaultByTwo:
                cmpi.w  #$60,(a5)
                beq.s   SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep
                bcc.s   SKSonicGroundMove_SubtractCameraRecoveryStep
                addq.w  #4,(a5)

SKSonicGroundMove_SubtractCameraRecoveryStep:
                subq.w  #2,(a5)

SKSonicGroundMove_SelectPoweredNeutralGroundDecayStep:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicGroundMove_ApplyNeutralGroundDecayOnlyWithoutHorizontalInput
                move.w  #$C,d5

SKSonicGroundMove_ApplyNeutralGroundDecayOnlyWithoutHorizontalInput:
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKSonicGroundMove_ProjectGroundSpeedIntoCartesianVelocity
                move.w  ground_vel(a0),d0
                beq.s   SKSonicGroundMove_ProjectGroundSpeedIntoCartesianVelocity
                bmi.s   SKSonicGroundMove_DecayNegativeGroundSpeedAndClampOnCarry
                sub.w   d5,d0
                bcc.s   SKSonicGroundMove_StorePositiveNeutralDecayResult
                move.w  #0,d0

SKSonicGroundMove_StorePositiveNeutralDecayResult:
                move.w  d0,ground_vel(a0)
                bra.s   SKSonicGroundMove_ProjectGroundSpeedIntoCartesianVelocity
; ---------------------------------------------------------------------------

SKSonicGroundMove_DecayNegativeGroundSpeedAndClampOnCarry:
                add.w   d5,d0
                bcc.s   SKSonicGroundMove_StoreNegativeNeutralDecayResult
                move.w  #0,d0

SKSonicGroundMove_StoreNegativeNeutralDecayResult:
                move.w  d0,ground_vel(a0)

SKSonicGroundMove_ProjectGroundSpeedIntoCartesianVelocity:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKSonicGroundMove_GateSharedWalkingAndRollingObstructionProbe:
                btst    #6,object_control(a0)
                bne.w   SKSonicGroundMove_ReturnAfterSkippedProbeOrVerticalResponse
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKSonicGroundMove_SelectTravelSideProbeOffsetAfterCardinalAngleException
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKSonicGroundMove_ReturnAfterSkippedProbeOrVerticalResponse

SKSonicGroundMove_SelectTravelSideProbeOffsetAfterCardinalAngleException:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKSonicGroundMove_ReturnAfterSkippedProbeOrVerticalResponse
                bmi.s   SKSonicGroundMove_ProbeGroundTravelSideAndApplyOnlyNegativeClearance
                neg.w   d1

SKSonicGroundMove_ProbeGroundTravelSideAndApplyOnlyNegativeClearance:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKSonicGroundMove_ReturnAfterSkippedProbeOrVerticalResponse
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKSonicGroundMove_RoundSavedProbeDirectionAndApplyObstructionResponse
                tst.b   d0
                bpl.s   SKSonicGroundMove_RoundSavedProbeDirectionAndApplyObstructionResponse
                subq.b  #1,d0

SKSonicGroundMove_RoundSavedProbeDirectionAndApplyObstructionResponse:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKSonicGroundMove_AddScaledFloorClearanceToYVelocity
                cmpi.b  #$40,d0
                beq.s   SKSonicGroundMove_CorrectLeftWallVelocityAndSetPushOnlyWhenFacingLeft
                cmpi.b  #$80,d0
                beq.s   SKSonicGroundMove_SubtractScaledCeilingClearanceFromYVelocity
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKSonicGroundMove_ReturnAfterHorizontalObstructionResponse
                bset    #Status_Push,status(a0)

SKSonicGroundMove_ReturnAfterHorizontalObstructionResponse:
                rts
; ---------------------------------------------------------------------------

SKSonicGroundMove_SubtractScaledCeilingClearanceFromYVelocity:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGroundMove_CorrectLeftWallVelocityAndSetPushOnlyWhenFacingLeft:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicGroundMove_ReturnAfterHorizontalObstructionResponse
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGroundMove_AddScaledFloorClearanceToYVelocity:
                add.w   d1,y_vel(a0)

SKSonicGroundMove_ReturnAfterSkippedProbeOrVerticalResponse:
                rts
; End of function Sonic_Move

; =============== S U B R O U T I N E =======================================

SonicSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKSonicGroundMove_FaceLeftForNonpositiveGroundAcceleration
                bpl.s   SKSonicGroundMove_BrakePositiveGroundSpeedForLeftInput

SKSonicGroundMove_FaceLeftForNonpositiveGroundAcceleration:
                bset    #Status_Facing,status(a0)
                bne.s   SKSonicGroundMove_AccelerateLeftWithoutIncreasingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKSonicGroundMove_AccelerateLeftWithoutIncreasingExistingOverspeed:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKSonicGroundMove_StoreLeftAccelerationAndRequestMovementAnimation
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKSonicGroundMove_StoreLeftAccelerationAndRequestMovementAnimation
                move.w  d1,d0

SKSonicGroundMove_StoreLeftAccelerationAndRequestMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGroundMove_BrakePositiveGroundSpeedForLeftInput:
                sub.w   d4,d0
                bcc.s   SKSonicGroundMove_StoreLeftBrakeAndGateRightFacingSkidUsingModifiedSpeedWord
                move.w  #-$80,d0

SKSonicGroundMove_StoreLeftBrakeAndGateRightFacingSkidUsingModifiedSpeedWord:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKSonicGroundMove_ReturnAfterLeftBrakingAndOptionalSkidDustRequest
                cmpi.w  #$400,d0
                blt.s   SKSonicGroundMove_ReturnAfterLeftBrakingAndOptionalSkidDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKSonicGroundMove_ReturnAfterLeftBrakingAndOptionalSkidDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicGroundMove_ReturnAfterLeftBrakingAndOptionalSkidDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKSonicGroundMove_ReturnAfterLeftBrakingAndOptionalSkidDustRequest:
                rts
; End of function SonicSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

SonicSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKSonicGroundMove_BrakeNegativeGroundSpeedForRightInput
                bclr    #Status_Facing,status(a0)
                beq.s   SKSonicGroundMove_AccelerateRightWithoutIncreasingExistingOverspeed
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

SKSonicGroundMove_AccelerateRightWithoutIncreasingExistingOverspeed:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKSonicGroundMove_StoreRightAccelerationAndRequestMovementAnimation
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKSonicGroundMove_StoreRightAccelerationAndRequestMovementAnimation
                move.w  d6,d0

SKSonicGroundMove_StoreRightAccelerationAndRequestMovementAnimation:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGroundMove_BrakeNegativeGroundSpeedForRightInput:
                add.w   d4,d0
                bcc.s   SKSonicGroundMove_StoreRightBrakeAndGateLeftFacingSkidUsingModifiedSpeedWord
                move.w  #$80,d0

SKSonicGroundMove_StoreRightBrakeAndGateLeftFacingSkidUsingModifiedSpeedWord:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKSonicGroundMove_ReturnAfterRightBrakingAndOptionalSkidDustRequest
                cmpi.w  #-$400,d0
                bgt.s   SKSonicGroundMove_ReturnAfterRightBrakingAndOptionalSkidDustRequest
                tst.b   flip_type(a0)
                bmi.s   SKSonicGroundMove_ReturnAfterRightBrakingAndOptionalSkidDustRequest
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicGroundMove_ReturnAfterRightBrakingAndOptionalSkidDustRequest
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKSonicGroundMove_ReturnAfterRightBrakingAndOptionalSkidDustRequest:
                rts
; End of function SonicSKApplyGroundRightInput

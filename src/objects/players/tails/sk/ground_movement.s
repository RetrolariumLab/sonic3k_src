; Owner: objects/players/tails/sk
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   SKTailsGround_ProjectGroundSpeed
                tst.w   move_lock(a0)
                bne.w   SKTailsGround_ResetLookDelay
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsGround_CheckRightInput
                bsr.w   TailsSKApplyGroundLeftInput

SKTailsGround_CheckRightInput:
                btst    #button_right,(Ctrl_2_logical).w
                beq.s   SKTailsGround_CheckStationaryBalance
                bsr.w   TailsSKApplyGroundRightInput

SKTailsGround_CheckStationaryBalance:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   SKTailsGround_ResetLookDelay
                tst.w   ground_vel(a0)
                bne.w   SKTailsGround_ResetLookDelay
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsGround_ProbeBalanceAndCheckTilt3
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   SKTailsGround_CheckFirstLookInput
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   SKTailsGround_FaceLeftForBalance
                cmp.w   d2,d1
                bge.s   SKTailsGround_FaceRightForBalance
                bra.s   SKTailsGround_CheckFirstLookInput
; ---------------------------------------------------------------------------

SKTailsGround_ProbeBalanceAndCheckTilt3:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.s   SKTailsGround_CheckFirstLookInput
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKTailsGround_CheckRearTilt3

SKTailsGround_FaceRightForBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   SKTailsGround_SetBalanceAnim
; ---------------------------------------------------------------------------

SKTailsGround_CheckRearTilt3:
                cmpi.b  #3,tilt(a0)
                bne.s   SKTailsGround_CheckFirstLookInput

SKTailsGround_FaceLeftForBalance:
                bset    #Status_Facing,status(a0)

SKTailsGround_SetBalanceAnim:
                move.b  #6,anim(a0)
                bra.s   SKTailsGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKTailsGround_CheckFirstLookInput:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   SKTailsGround_CheckSecondLookInput
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKTailsGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsGround_RaiseCameraForReverseDuck
                cmpi.w  #8,(a5)
                beq.s   SKTailsGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKTailsGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKTailsGround_RaiseCameraForReverseDuck:
                cmpi.w  #$D8,(a5)
                beq.s   SKTailsGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKTailsGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKTailsGround_CheckSecondLookInput:
                btst    #button_up,(Ctrl_2_logical).w
                beq.s   SKTailsGround_ResetLookDelay
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKTailsGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsGround_LowerCameraForReverseLook
                cmpi.w  #$C8,(a5)
                beq.s   SKTailsGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKTailsGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKTailsGround_LowerCameraForReverseLook:
                cmpi.w  #$18,(a5)
                beq.s   SKTailsGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKTailsGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKTailsGround_ResetLookDelay:
                move.b  #0,scroll_delay_counter(a0)

SKTailsGround_EaseLookCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsGround_SelectPoweredFriction
                bcc.s   SKTailsGround_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

SKTailsGround_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

SKTailsGround_SelectPoweredFriction:
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsGround_ApplyNeutralFriction
                move.w  #$C,d5

SKTailsGround_ApplyNeutralFriction:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKTailsGround_ProjectGroundSpeed
                move.w  ground_vel(a0),d0
                beq.s   SKTailsGround_ProjectGroundSpeed
                bmi.s   SKTailsGround_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKTailsGround_StorePositiveFriction
                move.w  #0,d0

SKTailsGround_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKTailsGround_ProjectGroundSpeed
; ---------------------------------------------------------------------------

SKTailsGround_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKTailsGround_StoreNegativeFriction
                move.w  #0,d0

SKTailsGround_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKTailsGround_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKTailsGround_CheckTravelProbe:
                btst    #6,object_control(a0)
                bne.w   SKTailsGround_TravelProbeReturn
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKTailsGround_PickTravelProbeOffset
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKTailsGround_TravelProbeReturn

SKTailsGround_PickTravelProbeOffset:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKTailsGround_TravelProbeReturn
                bmi.s   SKTailsGround_ProbeTravelSide
                neg.w   d1

; Resolve negative clearance only. Convert penetration to velocity units by shifting left eight
SKTailsGround_ProbeTravelSide:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKTailsGround_TravelProbeReturn
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKTailsGround_RoundProbeAndResolve
                tst.b   d0
                bpl.s   SKTailsGround_RoundProbeAndResolve
                subq.b  #1,d0

SKTailsGround_RoundProbeAndResolve:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKTailsGround_ApplyFloorCorrection
                cmpi.b  #$40,d0
                beq.s   SKTailsGround_ApplyLeftWallCorrection
                cmpi.b  #$80,d0
                beq.s   SKTailsGround_ApplyCeilingCorrection
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKTailsGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)

SKTailsGround_HorizontalProbeReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsGround_ApplyCeilingCorrection:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_ApplyLeftWallCorrection:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_ApplyFloorCorrection:
                add.w   d1,y_vel(a0)

SKTailsGround_TravelProbeReturn:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

TailsSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsGround_FaceLeftAndResetTurnState
                bpl.s   SKTailsGround_BrakeRightwardSpeed

SKTailsGround_FaceLeftAndResetTurnState:
                bset    #Status_Facing,status(a0)
                bne.s   SKTailsGround_AccelerateLeft
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when left input would increase existing overspeed
SKTailsGround_AccelerateLeft:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKTailsGround_StoreLeftSpeedAndAnimate
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKTailsGround_StoreLeftSpeedAndAnimate
                move.w  d1,d0

SKTailsGround_StoreLeftSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_BrakeRightwardSpeed:
                sub.w   d4,d0
                bcc.s   SKTailsGround_StoreLeftBrakeAndTestSkid
                move.w  #-$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKTailsGround_StoreLeftBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKTailsGround_LeftBrakeReturn
                cmpi.w  #$400,d0
                blt.s   SKTailsGround_LeftBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKTailsGround_LeftBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKTailsGround_LeftBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKTailsGround_LeftBrakeReturn:
                rts
; End of function TailsSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

TailsSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKTailsGround_BrakeLeftwardSpeed
                bclr    #Status_Facing,status(a0)
                beq.s   SKTailsGround_AccelerateRight
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when right input would increase existing overspeed
SKTailsGround_AccelerateRight:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKTailsGround_StoreRightSpeedAndAnimate
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKTailsGround_StoreRightSpeedAndAnimate
                move.w  d6,d0

SKTailsGround_StoreRightSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsGround_BrakeLeftwardSpeed:
                add.w   d4,d0
                bcc.s   SKTailsGround_StoreRightBrakeAndTestSkid
                move.w  #$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKTailsGround_StoreRightBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKTailsGround_RightBrakeReturn
                cmpi.w  #-$400,d0
                bgt.s   SKTailsGround_RightBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKTailsGround_RightBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKTailsGround_RightBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKTailsGround_RightBrakeReturn:
                rts
; End of function TailsSKApplyGroundRightInput

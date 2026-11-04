; Owner: objects/players/tails/s3
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   S3TailsGround_ProjectGroundSpeed
                tst.w   move_lock(a0)
                bne.w   S3TailsGround_ResetLookDelay
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_CheckRightInput
                bsr.w   TailsS3ApplyGroundLeftInput

S3TailsGround_CheckRightInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_CheckStationaryBalance
                bsr.w   TailsS3ApplyGroundRightInput

S3TailsGround_CheckStationaryBalance:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   S3TailsGround_ResetLookDelay
                tst.w   ground_vel(a0)
                bne.w   S3TailsGround_ResetLookDelay
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   S3TailsGround_ProbeBalanceAndCheckTilt3
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   S3TailsGround_CheckFirstLookInput
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   S3TailsGround_FaceLeftForBalance
                cmp.w   d2,d1
                bge.s   S3TailsGround_FaceRightForBalance
                bra.s   S3TailsGround_CheckFirstLookInput
; ---------------------------------------------------------------------------

S3TailsGround_ProbeBalanceAndCheckTilt3:
                jsr     (ChkFloorEdge).l
                cmpi.w  #$C,d1
                blt.s   S3TailsGround_CheckFirstLookInput
                cmpi.b  #3,next_tilt(a0)
                bne.s   S3TailsGround_CheckRearTilt3

S3TailsGround_FaceRightForBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   S3TailsGround_SetBalanceAnim
; ---------------------------------------------------------------------------

S3TailsGround_CheckRearTilt3:
                cmpi.b  #3,tilt(a0)
                bne.s   S3TailsGround_CheckFirstLookInput

S3TailsGround_FaceLeftForBalance:
                bset    #Status_Facing,status(a0)

S3TailsGround_SetBalanceAnim:
                move.b  #6,anim(a0)
                bra.s   S3TailsGround_ResetLookDelay
; ---------------------------------------------------------------------------

S3TailsGround_CheckFirstLookInput:
                btst    #button_up,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_CheckSecondLookInput
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   S3TailsGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #$C8,(a5)
                beq.s   S3TailsGround_ApplyNeutralFriction
                addq.w  #2,(a5)
                bra.s   S3TailsGround_ApplyNeutralFriction
; ---------------------------------------------------------------------------

S3TailsGround_CheckSecondLookInput:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   S3TailsGround_ResetLookDelay
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   S3TailsGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #8,(a5)
                beq.s   S3TailsGround_ApplyNeutralFriction
                subq.w  #2,(a5)
                bra.s   S3TailsGround_ApplyNeutralFriction
; ---------------------------------------------------------------------------

S3TailsGround_ResetLookDelay:
                move.b  #0,scroll_delay_counter(a0)

S3TailsGround_EaseLookCamera:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsGround_ApplyNeutralFriction
                bcc.s   S3TailsGround_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

S3TailsGround_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

S3TailsGround_ApplyNeutralFriction:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3TailsGround_ProjectGroundSpeed
                move.w  ground_vel(a0),d0
                beq.s   S3TailsGround_ProjectGroundSpeed
                bmi.s   S3TailsGround_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   S3TailsGround_StorePositiveFriction
                move.w  #0,d0

S3TailsGround_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   S3TailsGround_ProjectGroundSpeed
; ---------------------------------------------------------------------------

S3TailsGround_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   S3TailsGround_StoreNegativeFriction
                move.w  #0,d0

S3TailsGround_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

S3TailsGround_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

S3TailsGround_CheckTravelProbe:
                btst    #6,object_control(a0)
                bne.w   S3TailsGround_TravelProbeReturn
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.s   S3TailsGround_TravelProbeReturn
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   S3TailsGround_TravelProbeReturn
                bmi.s   S3TailsGround_ProbeTravelSide
                neg.w   d1

; Resolve negative clearance only. Convert penetration to velocity units by shifting left eight
S3TailsGround_ProbeTravelSide:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   S3TailsGround_TravelProbeReturn
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   S3TailsGround_ApplyFloorCorrection
                cmpi.b  #$40,d0
                beq.s   S3TailsGround_ApplyLeftWallCorrection
                cmpi.b  #$80,d0
                beq.s   S3TailsGround_ApplyCeilingCorrection
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   S3TailsGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)

S3TailsGround_HorizontalProbeReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsGround_ApplyCeilingCorrection:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_ApplyLeftWallCorrection:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_ApplyFloorCorrection:
                add.w   d1,y_vel(a0)

S3TailsGround_TravelProbeReturn:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

TailsS3ApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsGround_FaceLeftAndResetTurnState
                bpl.s   S3TailsGround_BrakeRightwardSpeed

S3TailsGround_FaceLeftAndResetTurnState:
                bset    #Status_Facing,status(a0)
                bne.s   S3TailsGround_AccelerateLeft
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when left input would increase existing overspeed
S3TailsGround_AccelerateLeft:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   S3TailsGround_StoreLeftSpeedAndAnimate
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   S3TailsGround_StoreLeftSpeedAndAnimate
                move.w  d1,d0

S3TailsGround_StoreLeftSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_BrakeRightwardSpeed:
                sub.w   d4,d0
                bcc.s   S3TailsGround_StoreLeftBrakeAndTestSkid
                move.w  #-$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
S3TailsGround_StoreLeftBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   S3TailsGround_LeftBrakeReturn
                cmpi.w  #$400,d0
                blt.s   S3TailsGround_LeftBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   S3TailsGround_LeftBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsGround_LeftBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

S3TailsGround_LeftBrakeReturn:
                rts
; End of function TailsS3ApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

TailsS3ApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   S3TailsGround_BrakeLeftwardSpeed
                bclr    #Status_Facing,status(a0)
                beq.s   S3TailsGround_AccelerateRight
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when right input would increase existing overspeed
S3TailsGround_AccelerateRight:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   S3TailsGround_StoreRightSpeedAndAnimate
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   S3TailsGround_StoreRightSpeedAndAnimate
                move.w  d6,d0

S3TailsGround_StoreRightSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsGround_BrakeLeftwardSpeed:
                add.w   d4,d0
                bcc.s   S3TailsGround_StoreRightBrakeAndTestSkid
                move.w  #$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
S3TailsGround_StoreRightBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   S3TailsGround_RightBrakeReturn
                cmpi.w  #-$400,d0
                bgt.s   S3TailsGround_RightBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   S3TailsGround_RightBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsGround_RightBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

S3TailsGround_RightBrakeReturn:
                rts
; End of function TailsS3ApplyGroundRightInput

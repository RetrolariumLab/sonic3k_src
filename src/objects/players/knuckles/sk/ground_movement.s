; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_InputAcceleration_Path:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                move.w  Deceleration-Max_speed(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   SKKnuxGround_ProjectGroundSpeed
                tst.w   move_lock(a0)
                bne.w   SKKnuxGround_ResetLookDelay
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnuxGround_CheckRightInput
                bsr.w   KnucklesSKApplyGroundLeftInput

SKKnuxGround_CheckRightInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnuxGround_CheckStationaryBalance
                bsr.w   KnucklesSKApplyGroundRightInput

SKKnuxGround_CheckStationaryBalance:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   SKKnuxGround_ResetLookDelay
                tst.w   ground_vel(a0)
                bne.w   SKKnuxGround_ResetLookDelay
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.w   SKKnuxGround_ProbeBalanceAndCheckTilt3
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.w   SKKnuxGround_CheckDuckBeforeLookUp
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #2,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #2,d1
                blt.s   SKKnuxGround_CheckObjectLeftBalance
                cmp.w   d2,d1
                bge.s   SKKnuxGround_CheckObjectRightBalance
                bra.w   SKKnuxGround_CheckDuckBeforeLookUp
; ---------------------------------------------------------------------------

SKKnuxGround_CheckObjectRightBalance:
                btst    #Status_Facing,status(a0)
                bne.s   SKKnuxGround_TurnRightOnObjectAtFrame4
                move.b  #6,anim(a0)
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_TurnRightOnObjectAtFrame4:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_CheckObjectLeftBalance:
                btst    #Status_Facing,status(a0)
                beq.s   SKKnuxGround_TurnLeftOnObjectAtFrame4
                move.b  #6,anim(a0)
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_TurnLeftOnObjectAtFrame4:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_ProbeBalanceAndCheckTilt3:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKKnuxGround_CheckDuckBeforeLookUp
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKKnuxGround_CheckRearTilt3
                btst    #Status_Facing,status(a0)
                bne.s   SKKnuxGround_TurnRightOnTerrainAtFrame4
                move.b  #6,anim(a0)
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_TurnRightOnTerrainAtFrame4:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_CheckRearTilt3:
                cmpi.b  #3,tilt(a0)
                bne.s   SKKnuxGround_CheckDuckBeforeLookUp
                btst    #Status_Facing,status(a0)
                beq.s   SKKnuxGround_TurnLeftOnTerrainAtFrame4
                move.b  #6,anim(a0)
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_TurnLeftOnTerrainAtFrame4:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   SKKnuxGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKKnuxGround_CheckDuckBeforeLookUp:
                btst    #button_down,(Ctrl_1_held_logical).w
                beq.s   SKKnuxGround_CheckLookUp
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKKnuxGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnuxGround_RaiseCameraForReverseDuck
                cmpi.w  #8,(a5)
                beq.s   SKKnuxGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKKnuxGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKKnuxGround_RaiseCameraForReverseDuck:
                cmpi.w  #$D8,(a5)
                beq.s   SKKnuxGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKKnuxGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKKnuxGround_CheckLookUp:
                btst    #button_up,(Ctrl_1_logical).w
                beq.s   SKKnuxGround_ResetLookDelay
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   SKKnuxGround_EaseLookCamera
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnuxGround_LowerCameraForReverseLook
                cmpi.w  #$C8,(a5)
                beq.s   SKKnuxGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKKnuxGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKKnuxGround_LowerCameraForReverseLook:
                cmpi.w  #$18,(a5)
                beq.s   SKKnuxGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKKnuxGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKKnuxGround_ResetLookDelay:
                move.b  #0,scroll_delay_counter(a0)

SKKnuxGround_EaseLookCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKKnuxGround_SelectPoweredFriction
                bcc.s   SKKnuxGround_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

SKKnuxGround_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

SKKnuxGround_SelectPoweredFriction:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnuxGround_ApplyNeutralFriction
                move.w  #$C,d5

SKKnuxGround_ApplyNeutralFriction:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKKnuxGround_ProjectGroundSpeed
                move.w  ground_vel(a0),d0
                beq.s   SKKnuxGround_ProjectGroundSpeed
                bmi.s   SKKnuxGround_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKKnuxGround_StorePositiveFriction
                move.w  #0,d0

SKKnuxGround_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKKnuxGround_ProjectGroundSpeed
; ---------------------------------------------------------------------------

SKKnuxGround_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKKnuxGround_StoreNegativeFriction
                move.w  #0,d0

SKKnuxGround_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKKnuxGround_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKKnuxGround_CheckTravelProbe:
                btst    #6,object_control(a0)
                bne.w   SKKnuxGround_TravelProbeReturn
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKKnuxGround_PickTravelProbeOffset
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKKnuxGround_TravelProbeReturn

SKKnuxGround_PickTravelProbeOffset:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKKnuxGround_TravelProbeReturn
                bmi.s   SKKnuxGround_ProbeTravelSide
                neg.w   d1

; Resolve negative clearance only. Convert penetration to velocity units by shifting left eight
SKKnuxGround_ProbeTravelSide:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKKnuxGround_TravelProbeReturn
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKKnuxGround_RoundProbeAndResolve
                tst.b   d0
                bpl.s   SKKnuxGround_RoundProbeAndResolve
                subq.b  #1,d0

SKKnuxGround_RoundProbeAndResolve:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKKnuxGround_ApplyFloorCorrection
                cmpi.b  #$40,d0
                beq.s   SKKnuxGround_ApplyLeftWallCorrection
                cmpi.b  #$80,d0
                beq.s   SKKnuxGround_ApplyCeilingCorrection
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKKnuxGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)

SKKnuxGround_HorizontalProbeReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGround_ApplyCeilingCorrection:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxGround_ApplyLeftWallCorrection:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKKnuxGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxGround_ApplyFloorCorrection:
                add.w   d1,y_vel(a0)

SKKnuxGround_TravelProbeReturn:
                rts
; End of function Knux_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKKnuxGround_FaceLeftAndResetTurnState
                bpl.s   SKKnuxGround_BrakeRightwardSpeed

SKKnuxGround_FaceLeftAndResetTurnState:
                bset    #Status_Facing,status(a0)
                bne.s   SKKnuxGround_AccelerateLeft
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when left input would increase existing overspeed
SKKnuxGround_AccelerateLeft:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKKnuxGround_StoreLeftSpeedAndAnimate
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKKnuxGround_StoreLeftSpeedAndAnimate
                move.w  d1,d0

SKKnuxGround_StoreLeftSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxGround_BrakeRightwardSpeed:
                sub.w   d4,d0
                bcc.s   SKKnuxGround_StoreLeftBrakeAndTestSkid
                move.w  #-$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKKnuxGround_StoreLeftBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKKnuxGround_LeftBrakeReturn
                cmpi.w  #$400,d0
                blt.s   SKKnuxGround_LeftBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKKnuxGround_LeftBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKKnuxGround_LeftBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKKnuxGround_LeftBrakeReturn:
                rts
; End of function KnucklesSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKKnuxGround_BrakeLeftwardSpeed
                bclr    #Status_Facing,status(a0)
                beq.s   SKKnuxGround_AccelerateRight
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when right input would increase existing overspeed
SKKnuxGround_AccelerateRight:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKKnuxGround_StoreRightSpeedAndAnimate
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKKnuxGround_StoreRightSpeedAndAnimate
                move.w  d6,d0

SKKnuxGround_StoreRightSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxGround_BrakeLeftwardSpeed:
                add.w   d4,d0
                bcc.s   SKKnuxGround_StoreRightBrakeAndTestSkid
                move.w  #$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKKnuxGround_StoreRightBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKKnuxGround_RightBrakeReturn
                cmpi.w  #-$400,d0
                bgt.s   SKKnuxGround_RightBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKKnuxGround_RightBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKKnuxGround_RightBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKKnuxGround_RightBrakeReturn:
                rts
; End of function KnucklesSKApplyGroundRightInput

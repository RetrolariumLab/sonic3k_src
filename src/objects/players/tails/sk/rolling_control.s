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
                beq.s   SKTailsRoll_CheckRollInput
                move.w  #6,d5

SKTailsRoll_CheckRollInput:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   SKTailsRoll_EaseRollCamera
                tst.b   status_secondary(a0)
                bmi.w   SKTailsRoll_EaseRollCamera
                tst.w   move_lock(a0)
                bne.s   SKTailsRoll_ApplySignedFriction
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsRoll_CheckRightInput
                bsr.w   TailsSKApplyRollingLeftInput

SKTailsRoll_CheckRightInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   SKTailsRoll_ApplySignedFriction
                bsr.w   TailsSKApplyRollingRightInput

SKTailsRoll_ApplySignedFriction:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsRoll_GetRollSpeedMagnitude
                bmi.s   SKTailsRoll_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKTailsRoll_StorePositiveFriction
                move.w  #0,d0

SKTailsRoll_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKTailsRoll_GetRollSpeedMagnitude
; ---------------------------------------------------------------------------

SKTailsRoll_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKTailsRoll_StoreNegativeFriction
                move.w  #0,d0

SKTailsRoll_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKTailsRoll_GetRollSpeedMagnitude:
                move.w  ground_vel(a0),d0
                bpl.s   SKTailsRoll_CheckUnrollBelow80
                neg.w   d0

SKTailsRoll_CheckUnrollBelow80:
                cmpi.w  #$80,d0
                bhs.s   SKTailsRoll_EaseRollCamera
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsRoll_ResumeForcedRoll
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsRoll_ApplyUnrollRadiusOffset
                neg.w   d0

SKTailsRoll_ApplyUnrollRadiusOffset:
                add.w   d0,y_pos(a0)
                bra.s   SKTailsRoll_EaseRollCamera
; ---------------------------------------------------------------------------

SKTailsRoll_ResumeForcedRoll:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsRoll_EaseRollCamera
                neg.w   ground_vel(a0)

SKTailsRoll_EaseRollCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsRoll_ProjectGroundSpeed
                bcc.s   SKTailsRoll_ReduceRollCameraDistanceBy2
                addq.w  #4,(a5)

SKTailsRoll_ReduceRollCameraDistanceBy2:
                subq.w  #2,(a5)

SKTailsRoll_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   SKTailsRoll_ClampProjectedMinXSpeed
                move.w  #$1000,d1

SKTailsRoll_ClampProjectedMinXSpeed:
                cmpi.w  #-$1000,d1
                bge.s   SKTailsRoll_StoreXSpeedAndProbe
                move.w  #-$1000,d1

SKTailsRoll_StoreXSpeedAndProbe:
                move.w  d1,x_vel(a0)
                bra.w   SKTailsGround_CheckTravelProbe
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

TailsSKApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKTailsRoll_FaceLeftAndKeepRolling
                bpl.s   SKTailsRoll_BrakeRightwardRoll

SKTailsRoll_FaceLeftAndKeepRolling:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRoll_BrakeRightwardRoll:
                sub.w   d4,d0
                bcc.s   SKTailsRoll_StoreLeftBrakeResult
                move.w  #-$80,d0

SKTailsRoll_StoreLeftBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsSKApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

TailsSKApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKTailsRoll_BrakeLeftwardRoll
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRoll_BrakeLeftwardRoll:
                add.w   d4,d0
                bcc.s   SKTailsRoll_StoreRightBrakeResult
                move.w  #$80,d0

SKTailsRoll_StoreRightBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsSKApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   SKTailsRoll_EaseAirCamera
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   SKTailsRoll_CheckAirRightInput
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKTailsRoll_CheckAirRightInput
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKTailsRoll_CheckAirRightInput
                move.w  d1,d0

; Keep the previous speed when right input would increase existing overspeed
SKTailsRoll_CheckAirRightInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   SKTailsRoll_StoreAirXSpeed
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKTailsRoll_StoreAirXSpeed
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKTailsRoll_StoreAirXSpeed
                move.w  d6,d0

SKTailsRoll_StoreAirXSpeed:
                move.w  d0,x_vel(a0)

SKTailsRoll_EaseAirCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKTailsRoll_CheckAirDragWindow
                bcc.s   SKTailsRoll_ReduceAirCameraDistanceBy2
                addq.w  #4,(a5)

SKTailsRoll_ReduceAirCameraDistanceBy2:
                subq.w  #2,(a5)

; Use an unsigned word comparison against -$400 before applying horizontal drag
SKTailsRoll_CheckAirDragWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   SKTailsRoll_AirDragReturn
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   SKTailsRoll_AirDragReturn
                bmi.s   SKTailsRoll_ApplyLeftAirDrag
                sub.w   d1,d0
                bcc.s   SKTailsRoll_StoreRightAirDrag
                move.w  #0,d0

SKTailsRoll_StoreRightAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsRoll_ApplyLeftAirDrag:
                sub.w   d1,d0
                bcs.s   SKTailsRoll_StoreLeftAirDrag
                move.w  #0,d0

SKTailsRoll_StoreLeftAirDrag:
                move.w  d0,x_vel(a0)

SKTailsRoll_AirDragReturn:
                rts
; End of function Tails_InputAcceleration_Freespace

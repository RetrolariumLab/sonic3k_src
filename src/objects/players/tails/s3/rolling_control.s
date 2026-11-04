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
                bmi.w   S3TailsRoll_EaseRollCamera
                tst.b   status_secondary(a0)
                bmi.w   S3TailsRoll_EaseRollCamera
                tst.w   move_lock(a0)
                bne.s   S3TailsRoll_ApplySignedFriction
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsRoll_CheckRightInput
                bsr.w   TailsS3ApplyRollingLeftInput

S3TailsRoll_CheckRightInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsRoll_ApplySignedFriction
                bsr.w   TailsS3ApplyRollingRightInput

S3TailsRoll_ApplySignedFriction:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsRoll_CheckUnrollAtZeroSpeed
                bmi.s   S3TailsRoll_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   S3TailsRoll_StorePositiveFriction
                move.w  #0,d0

S3TailsRoll_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   S3TailsRoll_CheckUnrollAtZeroSpeed
; ---------------------------------------------------------------------------

S3TailsRoll_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   S3TailsRoll_StoreNegativeFriction
                move.w  #0,d0

S3TailsRoll_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

S3TailsRoll_CheckUnrollAtZeroSpeed:
                tst.w   ground_vel(a0)
                bne.s   S3TailsRoll_EaseRollCamera
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsRoll_ResumeForcedRoll
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                bra.s   S3TailsRoll_EaseRollCamera
; ---------------------------------------------------------------------------

S3TailsRoll_ResumeForcedRoll:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsRoll_EaseRollCamera
                neg.w   ground_vel(a0)

S3TailsRoll_EaseRollCamera:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsRoll_ProjectGroundSpeed
                bcc.s   S3TailsRoll_ReduceRollCameraDistanceBy2
                addq.w  #4,(a5)

S3TailsRoll_ReduceRollCameraDistanceBy2:
                subq.w  #2,(a5)

S3TailsRoll_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   S3TailsRoll_ClampProjectedMinXSpeed
                move.w  #$1000,d1

S3TailsRoll_ClampProjectedMinXSpeed:
                cmpi.w  #-$1000,d1
                bge.s   S3TailsRoll_StoreXSpeedAndProbe
                move.w  #-$1000,d1

S3TailsRoll_StoreXSpeedAndProbe:
                move.w  d1,x_vel(a0)
                bra.w   S3TailsGround_CheckTravelProbe
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   S3TailsRoll_FaceLeftAndKeepRolling
                bpl.s   S3TailsRoll_BrakeRightwardRoll

S3TailsRoll_FaceLeftAndKeepRolling:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRoll_BrakeRightwardRoll:
                sub.w   d4,d0
                bcc.s   S3TailsRoll_StoreLeftBrakeResult
                move.w  #-$80,d0

S3TailsRoll_StoreLeftBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   S3TailsRoll_BrakeLeftwardRoll
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRoll_BrakeLeftwardRoll:
                add.w   d4,d0
                bcc.s   S3TailsRoll_StoreRightBrakeResult
                move.w  #$80,d0

S3TailsRoll_StoreRightBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   S3TailsRoll_EaseAirCamera
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   S3TailsRoll_CheckAirRightInput
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   S3TailsRoll_CheckAirRightInput
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   S3TailsRoll_CheckAirRightInput
                move.w  d1,d0

; Keep the previous speed when right input would increase existing overspeed
S3TailsRoll_CheckAirRightInput:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   S3TailsRoll_StoreAirXSpeed
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   S3TailsRoll_StoreAirXSpeed
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   S3TailsRoll_StoreAirXSpeed
                move.w  d6,d0

S3TailsRoll_StoreAirXSpeed:
                move.w  d0,x_vel(a0)

S3TailsRoll_EaseAirCamera:
                cmpi.w  #$60,(a5)
                beq.s   S3TailsRoll_CheckAirDragWindow
                bcc.s   S3TailsRoll_ReduceAirCameraDistanceBy2
                addq.w  #4,(a5)

S3TailsRoll_ReduceAirCameraDistanceBy2:
                subq.w  #2,(a5)

; Use an unsigned word comparison against -$400 before applying horizontal drag
S3TailsRoll_CheckAirDragWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   S3TailsRoll_AirDragReturn
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   S3TailsRoll_AirDragReturn
                bmi.s   S3TailsRoll_ApplyLeftAirDrag
                sub.w   d1,d0
                bcc.s   S3TailsRoll_StoreRightAirDrag
                move.w  #0,d0

S3TailsRoll_StoreRightAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsRoll_ApplyLeftAirDrag:
                sub.w   d1,d0
                bcs.s   S3TailsRoll_StoreLeftAirDrag
                move.w  #0,d0

S3TailsRoll_StoreLeftAirDrag:
                move.w  d0,x_vel(a0)

S3TailsRoll_AirDragReturn:
                rts
; End of function Tails_InputAcceleration_Freespace

; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles rolling speed, airborne direction input and jump peak deceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_RollSpeed:
                move.w  Max_speed-Max_speed(a4),d6
                asl.w   #1,d6
                move.w  Acceleration-Max_speed(a4),d5
                asr.w   #1,d5
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnuxRoll_CheckRollInput
                move.w  #6,d5

SKKnuxRoll_CheckRollInput:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   SKKnuxRoll_EaseRollCamera
                tst.b   status_secondary(a0)
                bmi.w   SKKnuxRoll_EaseRollCamera
                tst.w   move_lock(a0)
                bne.s   SKKnuxRoll_ApplySignedFriction
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnuxRoll_CheckRightInput
                bsr.w   KnucklesSKApplyRollingLeftInput

SKKnuxRoll_CheckRightInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnuxRoll_ApplySignedFriction
                bsr.w   KnucklesSKApplyRollingRightInput

SKKnuxRoll_ApplySignedFriction:
                move.w  ground_vel(a0),d0
                beq.s   SKKnuxRoll_GetRollSpeedMagnitude
                bmi.s   SKKnuxRoll_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKKnuxRoll_StorePositiveFriction
                move.w  #0,d0

SKKnuxRoll_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKKnuxRoll_GetRollSpeedMagnitude
; ---------------------------------------------------------------------------

SKKnuxRoll_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKKnuxRoll_StoreNegativeFriction
                move.w  #0,d0

SKKnuxRoll_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKKnuxRoll_GetRollSpeedMagnitude:
                move.w  ground_vel(a0),d0
                bpl.s   SKKnuxRoll_CheckUnrollBelow80
                neg.w   d0

SKKnuxRoll_CheckUnrollBelow80:
                cmpi.w  #$80,d0
                bhs.s   SKKnuxRoll_EaseRollCamera
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnuxRoll_ResumeForcedRoll
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxRoll_ApplyUnrollRadiusOffset
                neg.w   d0

SKKnuxRoll_ApplyUnrollRadiusOffset:
                add.w   d0,y_pos(a0)
                bra.s   SKKnuxRoll_EaseRollCamera
; ---------------------------------------------------------------------------

SKKnuxRoll_ResumeForcedRoll:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKKnuxRoll_EaseRollCamera
                neg.w   ground_vel(a0)

SKKnuxRoll_EaseRollCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKKnuxRoll_ProjectGroundSpeed
                bcc.s   SKKnuxRoll_ReduceRollCameraDistanceBy2
                addq.w  #4,(a5)

SKKnuxRoll_ReduceRollCameraDistanceBy2:
                subq.w  #2,(a5)

SKKnuxRoll_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   SKKnuxRoll_ClampProjectedMinXSpeed
                move.w  #$1000,d1

SKKnuxRoll_ClampProjectedMinXSpeed:
                cmpi.w  #-$1000,d1
                bge.s   SKKnuxRoll_StoreXSpeedAndProbe
                move.w  #-$1000,d1

SKKnuxRoll_StoreXSpeedAndProbe:
                move.w  d1,x_vel(a0)
                bra.w   SKKnuxGround_CheckTravelProbe
; End of function Knux_RollSpeed

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKKnuxRoll_FaceLeftAndKeepRolling
                bpl.s   SKKnuxRoll_BrakeRightwardRoll

SKKnuxRoll_FaceLeftAndKeepRolling:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxRoll_BrakeRightwardRoll:
                sub.w   d4,d0
                bcc.s   SKKnuxRoll_StoreLeftBrakeResult
                move.w  #-$80,d0

SKKnuxRoll_StoreLeftBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function KnucklesSKApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKKnuxRoll_BrakeLeftwardRoll
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxRoll_BrakeLeftwardRoll:
                add.w   d4,d0
                bcc.s   SKKnuxRoll_StoreRightBrakeResult
                move.w  #$80,d0

SKKnuxRoll_StoreRightBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function KnucklesSKApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

; sub_17680:
Knux_ChgJumpDir:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   SKKnuxRoll_EaseAirCamera
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKKnuxRoll_CheckAirRightInput
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKKnuxRoll_CheckAirRightInput
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKKnuxRoll_CheckAirRightInput
                move.w  d1,d0

SKKnuxRoll_CheckAirRightInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKKnuxRoll_StoreAirXSpeed
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKKnuxRoll_StoreAirXSpeed
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKKnuxRoll_StoreAirXSpeed
                move.w  d6,d0

SKKnuxRoll_StoreAirXSpeed:
                move.w  d0,x_vel(a0)

SKKnuxRoll_EaseAirCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKKnuxRoll_CheckAirDragWindow
                bcc.s   SKKnuxRoll_ReduceAirCameraDistanceBy2
                addq.w  #4,(a5)

SKKnuxRoll_ReduceAirCameraDistanceBy2:
                subq.w  #2,(a5)

; Use an unsigned word comparison against -$400 before applying horizontal drag
SKKnuxRoll_CheckAirDragWindow:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   SKKnuxRoll_AirDragReturn
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   SKKnuxRoll_AirDragReturn
                bmi.s   SKKnuxRoll_ApplyLeftAirDrag
                sub.w   d1,d0
                bcc.s   SKKnuxRoll_StoreRightAirDrag
                move.w  #0,d0

SKKnuxRoll_StoreRightAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKKnuxRoll_ApplyLeftAirDrag:
                sub.w   d1,d0
                bcs.s   SKKnuxRoll_StoreLeftAirDrag
                move.w  #0,d0

SKKnuxRoll_StoreLeftAirDrag:
                move.w  d0,x_vel(a0)

SKKnuxRoll_AirDragReturn:
                rts
; End of function Knux_ChgJumpDir

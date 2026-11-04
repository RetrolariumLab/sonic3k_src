; Owner: objects/players/sonic/s3
; Responsibility: Sonic rolling speed control, airborne direction changes and jump peak deceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Sonic_RollSpeed:
                move.w  Max_speed-Max_speed(a4),d6
                asl.w   #1,d6
                move.w  Acceleration-Max_speed(a4),d5
                asr.w   #1,d5
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   S3SonicRoll_EaseRollCamera
                tst.b   status_secondary(a0)
                bmi.w   S3SonicRoll_EaseRollCamera
                tst.w   move_lock(a0)
                bne.s   S3SonicRoll_ApplySignedFriction
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   S3SonicRoll_CheckRightInput
                bsr.w   SonicS3ApplyRollingLeftInput

S3SonicRoll_CheckRightInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   S3SonicRoll_ApplySignedFriction
                bsr.w   SonicS3ApplyRollingRightInput

S3SonicRoll_ApplySignedFriction:
                move.w  ground_vel(a0),d0
                beq.s   S3SonicRoll_CheckUnrollAtZeroSpeed
                bmi.s   S3SonicRoll_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   S3SonicRoll_StorePositiveFrictionResult
                move.w  #0,d0

S3SonicRoll_StorePositiveFrictionResult:
                move.w  d0,ground_vel(a0)
                bra.s   S3SonicRoll_CheckUnrollAtZeroSpeed
; ---------------------------------------------------------------------------

S3SonicRoll_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   S3SonicRoll_StoreNegativeFrictionResult
                move.w  #0,d0

S3SonicRoll_StoreNegativeFrictionResult:
                move.w  d0,ground_vel(a0)

S3SonicRoll_CheckUnrollAtZeroSpeed:
                tst.w   ground_vel(a0)
                bne.s   S3SonicRoll_EaseRollCamera
                tst.b   spin_dash_flag(a0)
                bne.s   S3SonicRoll_ResumeChargedRoll
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                bra.s   S3SonicRoll_EaseRollCamera
; ---------------------------------------------------------------------------

S3SonicRoll_ResumeChargedRoll:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   S3SonicRoll_EaseRollCamera
                neg.w   ground_vel(a0)

S3SonicRoll_EaseRollCamera:
                cmpi.w  #$60,(a5)
                beq.s   S3SonicRoll_ProjectGroundSpeed
                bcc.s   S3SonicRoll_ReduceRollCameraDistanceBy2
                addq.w  #4,(a5)

S3SonicRoll_ReduceRollCameraDistanceBy2:
                subq.w  #2,(a5)

S3SonicRoll_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   S3SonicRoll_ClampProjectedMinXSpeed
                move.w  #$1000,d1

S3SonicRoll_ClampProjectedMinXSpeed:
                cmpi.w  #-$1000,d1
                bge.s   S3SonicRoll_StoreXSpeedAndProbe
                move.w  #-$1000,d1

S3SonicRoll_StoreXSpeedAndProbe:
                move.w  d1,x_vel(a0)
                bra.w   S3SonicGround_CheckTravelProbe
; End of function Sonic_RollSpeed

; =============== S U B R O U T I N E =======================================

SonicS3ApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   S3SonicRoll_FaceLeftAndKeepRolling
                bpl.s   S3SonicRoll_BrakeRightwardRoll

S3SonicRoll_FaceLeftAndKeepRolling:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicRoll_BrakeRightwardRoll:
                sub.w   d4,d0
                bcc.s   S3SonicRoll_StoreLeftBrakeResult
                move.w  #-$80,d0

S3SonicRoll_StoreLeftBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function SonicS3ApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

SonicS3ApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   S3SonicRoll_BrakeLeftwardRoll
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicRoll_BrakeLeftwardRoll:
                add.w   d4,d0
                bcc.s   S3SonicRoll_StoreRightBrakeResult
                move.w  #$80,d0

S3SonicRoll_StoreRightBrakeResult:
                move.w  d0,ground_vel(a0)
                rts
; End of function SonicS3ApplyRollingRightInput

; ---------------------------------------------------------------------------
; Subroutine for moving Sonic left or right when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_ChgJumpDir:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)     ; did Sonic jump from rolling?
                bne.s   Sonic_Jump_ResetScr             ; if yes, branch to skip midair control
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   S3SonicRoll_CheckAirRightInput  ; if not holding left, branch

                bset    #Status_Facing,status(a0)
                sub.w   d5,d0                           ; add acceleration to the left
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0                           ; compare new speed with top speed
                bgt.s   S3SonicRoll_CheckAirRightInput  ; if new speed is less than the maximum, branch
                add.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d1,d0                           ; compare speed with top speed
                ble.s   S3SonicRoll_CheckAirRightInput  ; if speed was already greater than the maximum, branch
                move.w  d1,d0

; Preserve existing overspeed when right input would increase it further
S3SonicRoll_CheckAirRightInput:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   S3SonicRoll_StoreAirXSpeed      ; if not holding right, branch

                bclr    #Status_Facing,status(a0)
                add.w   d5,d0                           ; accelerate right in the air
                cmp.w   d6,d0                           ; compare new speed with top speed
                blt.s   S3SonicRoll_StoreAirXSpeed      ; if new speed is less than the maximum, branch
                sub.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d6,d0                           ; compare speed with top speed
                bge.s   S3SonicRoll_StoreAirXSpeed      ; if speed was already greater than the maximum, branch
                move.w  d6,d0

S3SonicRoll_StoreAirXSpeed:
                move.w  d0,x_vel(a0)

Sonic_Jump_ResetScr:
                cmpi.w  #$60,(a5)                       ; is screen in its default position?
                beq.s   Sonic_JumpPeakDecelerate        ; if yes, branch
                bhs.s   S3SonicRoll_ReduceAirCameraDistanceBy2  ; depending on the sign of the difference,
                addq.w  #4,(a5)                         ; either add 2

S3SonicRoll_ReduceAirCameraDistanceBy2:
                subq.w  #2,(a5)                         ; or subtract 2

Sonic_JumpPeakDecelerate:
                cmpi.w  #-$400,y_vel(a0)                ; is Sonic moving faster than -$400 upwards?
                blo.s   S3SonicRoll_AirDragReturn       ; if yes, return
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1                           ; d1 = x_velocity / 32
                beq.s   S3SonicRoll_AirDragReturn       ; return if d1 is 0
                bmi.s   Sonic_JumpPeakDecelerateLeft    ; branch if moving left

                sub.w   d1,d0                           ; reduce x velocity by d1
                bcc.s   S3SonicRoll_StoreRightAirDrag
                move.w  #0,d0

S3SonicRoll_StoreRightAirDrag:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

Sonic_JumpPeakDecelerateLeft:
                sub.w   d1,d0                           ; reduce x velocity by d1
                bcs.s   S3SonicRoll_StoreLeftAirDrag
                move.w  #0,d0

S3SonicRoll_StoreLeftAirDrag:
                move.w  d0,x_vel(a0)

S3SonicRoll_AirDragReturn:
                rts
; End of function Sonic_ChgJumpDir

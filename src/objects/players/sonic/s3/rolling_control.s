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
                bmi.w   loc_12636
                tst.b   status_secondary(a0)
                bmi.w   loc_12636
                tst.w   move_lock(a0)
                bne.s   loc_125CE
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   loc_125C2
                bsr.w   SonicS3ApplyRollingLeftInput

loc_125C2:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_125CE
                bsr.w   SonicS3ApplyRollingRightInput

loc_125CE:
                move.w  ground_vel(a0),d0
                beq.s   loc_125F0
                bmi.s   loc_125E4
                sub.w   d5,d0
                bcc.s   loc_125DE
                move.w  #0,d0

loc_125DE:
                move.w  d0,ground_vel(a0)
                bra.s   loc_125F0
; ---------------------------------------------------------------------------

loc_125E4:
                add.w   d5,d0
                bcc.s   loc_125EC
                move.w  #0,d0

loc_125EC:
                move.w  d0,ground_vel(a0)

loc_125F0:
                tst.w   ground_vel(a0)
                bne.s   loc_12636
                tst.b   spin_dash_flag(a0)
                bne.s   loc_12624
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                bra.s   loc_12636
; ---------------------------------------------------------------------------

loc_12624:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   loc_12636
                neg.w   ground_vel(a0)

loc_12636:
                cmpi.w  #$60,(a5)
                beq.s   loc_12642
                bcc.s   loc_12640
                addq.w  #4,(a5)

loc_12640:
                subq.w  #2,(a5)

loc_12642:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   loc_12666
                move.w  #$1000,d1

loc_12666:
                cmpi.w  #-$1000,d1
                bge.s   loc_12670
                move.w  #-$1000,d1

loc_12670:
                move.w  d1,x_vel(a0)
                bra.w   loc_123F4
; End of function Sonic_RollSpeed

; =============== S U B R O U T I N E =======================================

SonicS3ApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   loc_12680
                bpl.s   loc_1268E

loc_12680:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_1268E:
                sub.w   d4,d0
                bcc.s   loc_12696
                move.w  #-$80,d0

loc_12696:
                move.w  d0,ground_vel(a0)
                rts
; End of function SonicS3ApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

SonicS3ApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   loc_126B0
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_126B0:
                add.w   d4,d0
                bcc.s   loc_126B8
                move.w  #$80,d0

loc_126B8:
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
                beq.s   loc_126F2                       ; if not holding left, branch

                bset    #Status_Facing,status(a0)
                sub.w   d5,d0                           ; add acceleration to the left
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0                           ; compare new speed with top speed
                bgt.s   loc_126F2                       ; if new speed is less than the maximum, branch
                add.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d1,d0                           ; compare speed with top speed
                ble.s   loc_126F2                       ; if speed was already greater than the maximum, branch
                move.w  d1,d0

loc_126F2:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_1270E                       ; if not holding right, branch

                bclr    #Status_Facing,status(a0)
                add.w   d5,d0                           ; accelerate right in the air
                cmp.w   d6,d0                           ; compare new speed with top speed
                blt.s   loc_1270E                       ; if new speed is less than the maximum, branch
                sub.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d6,d0                           ; compare speed with top speed
                bge.s   loc_1270E                       ; if speed was already greater than the maximum, branch
                move.w  d6,d0

loc_1270E:
                move.w  d0,x_vel(a0)

Sonic_Jump_ResetScr:
                cmpi.w  #$60,(a5)                       ; is screen in its default position?
                beq.s   Sonic_JumpPeakDecelerate        ; if yes, branch
                bhs.s   loc_1271C                       ; depending on the sign of the difference,
                addq.w  #4,(a5)                         ; either add 2

loc_1271C:
                subq.w  #2,(a5)                         ; or subtract 2

Sonic_JumpPeakDecelerate:
                cmpi.w  #-$400,y_vel(a0)                ; is Sonic moving faster than -$400 upwards?
                blo.s   locret_1274C                    ; if yes, return
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1                           ; d1 = x_velocity / 32
                beq.s   locret_1274C                    ; return if d1 is 0
                bmi.s   Sonic_JumpPeakDecelerateLeft    ; branch if moving left

                sub.w   d1,d0                           ; reduce x velocity by d1
                bcc.s   loc_1273A
                move.w  #0,d0

loc_1273A:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

Sonic_JumpPeakDecelerateLeft:
                sub.w   d1,d0                           ; reduce x velocity by d1
                bcs.s   loc_12748
                move.w  #0,d0

loc_12748:
                move.w  d0,x_vel(a0)

locret_1274C:
                rts
; End of function Sonic_ChgJumpDir

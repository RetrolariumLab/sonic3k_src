; Owner: objects/players/sonic/sk
; Responsibility: Sonic rolling speed control, airborne direction changes and jump peak deceleration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Sonic_RollSpeed:
                move.w  Max_speed-Max_speed(a4),d6
                asl.w   #1,d6
                move.w  Acceleration-Max_speed(a4),d5
                asr.w   #1,d5
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_1151C
                move.w  #6,d5

loc_1151C:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   loc_115C6
                tst.b   status_secondary(a0)
                bmi.w   loc_115C6
                tst.w   move_lock(a0)
                bne.s   loc_1154E
                btst    #button_left,(Ctrl_1_logical).w
                beq.s   loc_11542
                bsr.w   sub_11608

loc_11542:
                btst    #button_right,(Ctrl_1_logical).w
                beq.s   loc_1154E
                bsr.w   sub_1162C

loc_1154E:
                move.w  ground_vel(a0),d0
                beq.s   loc_11570
                bmi.s   loc_11564
                sub.w   d5,d0
                bcc.s   loc_1155E
                move.w  #0,d0

loc_1155E:
                move.w  d0,ground_vel(a0)
                bra.s   loc_11570
; ---------------------------------------------------------------------------

loc_11564:
                add.w   d5,d0
                bcc.s   loc_1156C
                move.w  #0,d0

loc_1156C:
                move.w  d0,ground_vel(a0)

loc_11570:
                move.w  ground_vel(a0),d0
                bpl.s   loc_11578
                neg.w   d0

loc_11578:
                cmpi.w  #$80,d0
                bhs.s   loc_115C6
                tst.b   spin_dash_flag(a0)
                bne.s   loc_115B4
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_115AE
                neg.w   d0

loc_115AE:
                add.w   d0,y_pos(a0)
                bra.s   loc_115C6
; ---------------------------------------------------------------------------

loc_115B4:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   loc_115C6
                neg.w   ground_vel(a0)

loc_115C6:
                cmpi.w  #$60,(a5)
                beq.s   loc_115D2
                bcc.s   loc_115D0
                addq.w  #4,(a5)

loc_115D0:
                subq.w  #2,(a5)

loc_115D2:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   loc_115F6
                move.w  #$1000,d1

loc_115F6:
                cmpi.w  #-$1000,d1
                bge.s   loc_11600
                move.w  #-$1000,d1

loc_11600:
                move.w  d1,x_vel(a0)
                bra.w   loc_11350
; End of function Sonic_RollSpeed

; =============== S U B R O U T I N E =======================================

sub_11608:
                move.w  ground_vel(a0),d0
                beq.s   loc_11610
                bpl.s   loc_1161E

loc_11610:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_1161E:
                sub.w   d4,d0
                bcc.s   loc_11626
                move.w  #-$80,d0

loc_11626:
                move.w  d0,ground_vel(a0)
                rts
; End of function sub_11608

; =============== S U B R O U T I N E =======================================

sub_1162C:
                move.w  ground_vel(a0),d0
                bmi.s   loc_11640
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_11640:
                add.w   d4,d0
                bcc.s   loc_11648
                move.w  #$80,d0

loc_11648:
                move.w  d0,ground_vel(a0)
                rts
; End of function sub_1162C

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
                beq.s   loc_11682                       ; if not holding left, branch

                bset    #Status_Facing,status(a0)
                sub.w   d5,d0                           ; add acceleration to the left
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0                           ; compare new speed with top speed
                bgt.s   loc_11682                       ; if new speed is less than the maximum, branch
                add.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d1,d0                           ; compare speed with top speed
                ble.s   loc_11682                       ; if speed was already greater than the maximum, branch
                move.w  d1,d0

loc_11682:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_1169E                       ; if not holding right, branch

                bclr    #Status_Facing,status(a0)
                add.w   d5,d0                           ; accelerate right in the air
                cmp.w   d6,d0                           ; compare new speed with top speed
                blt.s   loc_1169E                       ; if new speed is less than the maximum, branch
                sub.w   d5,d0                           ; remove this frame's acceleration change
                cmp.w   d6,d0                           ; compare speed with top speed
                bge.s   loc_1169E                       ; if speed was already greater than the maximum, branch
                move.w  d6,d0

loc_1169E:
                move.w  d0,x_vel(a0)

Sonic_Jump_ResetScr:
                cmpi.w  #$60,(a5)                       ; is screen in its default position?
                beq.s   Sonic_JumpPeakDecelerate        ; if yes, branch
                bhs.s   loc_116AC                       ; depending on the sign of the difference,
                addq.w  #4,(a5)                         ; either add 2

loc_116AC:
                subq.w  #2,(a5)                         ; or subtract 2

Sonic_JumpPeakDecelerate:
                cmpi.w  #-$400,y_vel(a0)                ; is Sonic moving faster than -$400 upwards?
                blo.s   locret_116DC                    ; if yes, return
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1                           ; d1 = x_velocity / 32
                beq.s   locret_116DC                    ; return if d1 is 0
                bmi.s   Sonic_JumpPeakDecelerateLeft    ; branch if moving left

                sub.w   d1,d0                           ; reduce x velocity by d1
                bcc.s   loc_116CA
                move.w  #0,d0

loc_116CA:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

Sonic_JumpPeakDecelerateLeft:
                sub.w   d1,d0                           ; reduce x velocity by d1
                bcs.s   loc_116D8
                move.w  #0,d0

loc_116D8:
                move.w  d0,x_vel(a0)

locret_116DC:
                rts
; End of function Sonic_ChgJumpDir

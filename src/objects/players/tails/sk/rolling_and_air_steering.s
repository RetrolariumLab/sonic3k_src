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
                beq.s   loc_14D46
                move.w  #6,d5

loc_14D46:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   loc_14DF0
                tst.b   status_secondary(a0)
                bmi.w   loc_14DF0
                tst.w   move_lock(a0)
                bne.s   loc_14D78
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_14D6C
                bsr.w   sub_14E32

loc_14D6C:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   loc_14D78
                bsr.w   sub_14E56

loc_14D78:
                move.w  ground_vel(a0),d0
                beq.s   loc_14D9A
                bmi.s   loc_14D8E
                sub.w   d5,d0
                bcc.s   loc_14D88
                move.w  #0,d0

loc_14D88:
                move.w  d0,ground_vel(a0)
                bra.s   loc_14D9A
; ---------------------------------------------------------------------------

loc_14D8E:
                add.w   d5,d0
                bcc.s   loc_14D96
                move.w  #0,d0

loc_14D96:
                move.w  d0,ground_vel(a0)

loc_14D9A:
                move.w  ground_vel(a0),d0
                bpl.s   loc_14DA2
                neg.w   d0

loc_14DA2:
                cmpi.w  #$80,d0
                bhs.s   loc_14DF0
                tst.b   spin_dash_flag(a0)
                bne.s   loc_14DDE
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_14DD8
                neg.w   d0

loc_14DD8:
                add.w   d0,y_pos(a0)
                bra.s   loc_14DF0
; ---------------------------------------------------------------------------

loc_14DDE:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   loc_14DF0
                neg.w   ground_vel(a0)

loc_14DF0:
                cmpi.w  #$60,(a5)
                beq.s   loc_14DFC
                bcc.s   loc_14DFA
                addq.w  #4,(a5)

loc_14DFA:
                subq.w  #2,(a5)

loc_14DFC:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   loc_14E20
                move.w  #$1000,d1

loc_14E20:
                cmpi.w  #-$1000,d1
                bge.s   loc_14E2A
                move.w  #-$1000,d1

loc_14E2A:
                move.w  d1,x_vel(a0)
                bra.w   loc_14B7A
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

sub_14E32:
                move.w  ground_vel(a0),d0
                beq.s   loc_14E3A
                bpl.s   loc_14E48

loc_14E3A:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14E48:
                sub.w   d4,d0
                bcc.s   loc_14E50
                move.w  #-$80,d0

loc_14E50:
                move.w  d0,ground_vel(a0)
                rts
; End of function sub_14E32

; =============== S U B R O U T I N E =======================================

sub_14E56:
                move.w  ground_vel(a0),d0
                bmi.s   loc_14E6A
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14E6A:
                add.w   d4,d0
                bcc.s   loc_14E72
                move.w  #$80,d0

loc_14E72:
                move.w  d0,ground_vel(a0)
                rts
; End of function sub_14E56

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   loc_14ECC
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_14EAC
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_14EAC
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_14EAC
                move.w  d1,d0

loc_14EAC:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   loc_14EC8
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_14EC8
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_14EC8
                move.w  d6,d0

loc_14EC8:
                move.w  d0,x_vel(a0)

loc_14ECC:
                cmpi.w  #$60,(a5)
                beq.s   loc_14ED8
                bcc.s   loc_14ED6
                addq.w  #4,(a5)

loc_14ED6:
                subq.w  #2,(a5)

loc_14ED8:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   locret_14F06
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   locret_14F06
                bmi.s   loc_14EFA
                sub.w   d1,d0
                bcc.s   loc_14EF4
                move.w  #0,d0

loc_14EF4:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_14EFA:
                sub.w   d1,d0
                bcs.s   loc_14F02
                move.w  #0,d0

loc_14F02:
                move.w  d0,x_vel(a0)

locret_14F06:
                rts
; End of function Tails_InputAcceleration_Freespace

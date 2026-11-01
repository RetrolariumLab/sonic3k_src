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
                bmi.w   loc_1599E
                tst.b   status_secondary(a0)
                bmi.w   loc_1599E
                tst.w   move_lock(a0)
                bne.s   loc_15936
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_1592A
                bsr.w   TailsS3ApplyRollingLeftInput

loc_1592A:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   loc_15936
                bsr.w   TailsS3ApplyRollingRightInput

loc_15936:
                move.w  ground_vel(a0),d0
                beq.s   loc_15958
                bmi.s   loc_1594C
                sub.w   d5,d0
                bcc.s   loc_15946
                move.w  #0,d0

loc_15946:
                move.w  d0,ground_vel(a0)
                bra.s   loc_15958
; ---------------------------------------------------------------------------

loc_1594C:
                add.w   d5,d0
                bcc.s   loc_15954
                move.w  #0,d0

loc_15954:
                move.w  d0,ground_vel(a0)

loc_15958:
                tst.w   ground_vel(a0)
                bne.s   loc_1599E
                tst.b   spin_dash_flag(a0)
                bne.s   loc_1598C
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                bra.s   loc_1599E
; ---------------------------------------------------------------------------

loc_1598C:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   loc_1599E
                neg.w   ground_vel(a0)

loc_1599E:
                cmpi.w  #$60,(a5)
                beq.s   loc_159AA
                bcc.s   loc_159A8
                addq.w  #4,(a5)

loc_159A8:
                subq.w  #2,(a5)

loc_159AA:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   loc_159CE
                move.w  #$1000,d1

loc_159CE:
                cmpi.w  #-$1000,d1
                bge.s   loc_159D8
                move.w  #-$1000,d1

loc_159D8:
                move.w  d1,x_vel(a0)
                bra.w   loc_1575A
; End of function Tails_RollSpeed

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   loc_159E8
                bpl.s   loc_159F6

loc_159E8:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_159F6:
                sub.w   d4,d0
                bcc.s   loc_159FE
                move.w  #-$80,d0

loc_159FE:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

TailsS3ApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   loc_15A18
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_15A18:
                add.w   d4,d0
                bcc.s   loc_15A20
                move.w  #$80,d0

loc_15A20:
                move.w  d0,ground_vel(a0)
                rts
; End of function TailsS3ApplyRollingRightInput

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Freespace:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                asl.w   #1,d5
                btst    #Status_RollJump,status(a0)
                bne.s   loc_15A7A
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_15A5A
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_15A5A
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_15A5A
                move.w  d1,d0

loc_15A5A:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   loc_15A76
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_15A76
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_15A76
                move.w  d6,d0

loc_15A76:
                move.w  d0,x_vel(a0)

loc_15A7A:
                cmpi.w  #$60,(a5)
                beq.s   loc_15A86
                bcc.s   loc_15A84
                addq.w  #4,(a5)

loc_15A84:
                subq.w  #2,(a5)

loc_15A86:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   locret_15AB4
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   locret_15AB4
                bmi.s   loc_15AA8
                sub.w   d1,d0
                bcc.s   loc_15AA2
                move.w  #0,d0

loc_15AA2:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_15AA8:
                sub.w   d1,d0
                bcs.s   loc_15AB0
                move.w  #0,d0

loc_15AB0:
                move.w  d0,x_vel(a0)

locret_15AB4:
                rts
; End of function Tails_InputAcceleration_Freespace

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
                beq.s   loc_1754E
                move.w  #6,d5

loc_1754E:
                move.w  #$20,d4
                tst.b   spin_dash_flag(a0)
                bmi.w   loc_175F8
                tst.b   status_secondary(a0)
                bmi.w   loc_175F8
                tst.w   move_lock(a0)
                bne.s   loc_17580
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   loc_17574
                bsr.w   KnucklesSKApplyRollingLeftInput

loc_17574:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_17580
                bsr.w   KnucklesSKApplyRollingRightInput

loc_17580:
                move.w  ground_vel(a0),d0
                beq.s   loc_175A2
                bmi.s   loc_17596
                sub.w   d5,d0
                bcc.s   loc_17590
                move.w  #0,d0

loc_17590:
                move.w  d0,ground_vel(a0)
                bra.s   loc_175A2
; ---------------------------------------------------------------------------

loc_17596:
                add.w   d5,d0
                bcc.s   loc_1759E
                move.w  #0,d0

loc_1759E:
                move.w  d0,ground_vel(a0)

loc_175A2:
                move.w  ground_vel(a0),d0
                bpl.s   loc_175AA
                neg.w   d0

loc_175AA:
                cmpi.w  #$80,d0
                bhs.s   loc_175F8
                tst.b   spin_dash_flag(a0)
                bne.s   loc_175E6
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                move.b  #5,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_175E0
                neg.w   d0

loc_175E0:
                add.w   d0,y_pos(a0)
                bra.s   loc_175F8
; ---------------------------------------------------------------------------

loc_175E6:
                move.w  #$400,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   loc_175F8
                neg.w   ground_vel(a0)

loc_175F8:
                cmpi.w  #$60,(a5)
                beq.s   loc_17604
                bcc.s   loc_17602
                addq.w  #4,(a5)

loc_17602:
                subq.w  #2,(a5)

loc_17604:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                cmpi.w  #$1000,d1
                ble.s   loc_17628
                move.w  #$1000,d1

loc_17628:
                cmpi.w  #-$1000,d1
                bge.s   loc_17632
                move.w  #-$1000,d1

loc_17632:
                move.w  d1,x_vel(a0)
                bra.w   loc_17382
; End of function Knux_RollSpeed

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   loc_17642
                bpl.s   loc_17650

loc_17642:
                bset    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_17650:
                sub.w   d4,d0
                bcc.s   loc_17658
                move.w  #-$80,d0

loc_17658:
                move.w  d0,ground_vel(a0)
                rts
; End of function KnucklesSKApplyRollingLeftInput

; =============== S U B R O U T I N E =======================================

KnucklesSKApplyRollingRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   loc_17672
                bclr    #Status_Facing,status(a0)
                move.b  #2,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_17672:
                add.w   d4,d0
                bcc.s   loc_1767A
                move.w  #$80,d0

loc_1767A:
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
                bne.s   loc_176D4
                move.w  x_vel(a0),d0
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   loc_176B4
                bset    #Status_Facing,status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_176B4
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_176B4
                move.w  d1,d0

loc_176B4:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_176D0
                bclr    #Status_Facing,status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_176D0
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_176D0
                move.w  d6,d0

loc_176D0:
                move.w  d0,x_vel(a0)

loc_176D4:
                cmpi.w  #$60,(a5)
                beq.s   loc_176E0
                bcc.s   loc_176DE
                addq.w  #4,(a5)

loc_176DE:
                subq.w  #2,(a5)

loc_176E0:
                cmpi.w  #-$400,y_vel(a0)
                blo.s   locret_1770E
                move.w  x_vel(a0),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   locret_1770E
                bmi.s   loc_17702
                sub.w   d1,d0
                bcc.s   loc_176FC
                move.w  #0,d0

loc_176FC:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_17702:
                sub.w   d1,d0
                bcs.s   loc_1770A
                move.w  #0,d0

loc_1770A:
                move.w  d0,x_vel(a0)

locret_1770E:
                rts
; End of function Knux_ChgJumpDir

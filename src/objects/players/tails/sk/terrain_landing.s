; Owner: objects/players/tails/sk
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_153D6
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_153D6:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   loc_154AC
                cmpi.b  #$80,d0
                beq.w   loc_15538
                cmpi.b  #$C0,d0
                beq.w   loc_1559C
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_1541A
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_1541A:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_1542C
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_1542C:
                bsr.w   sub_11FD6
                tst.w   d1
                bpl.s   locret_154AA
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_15444
                cmp.b   d2,d0
                blt.s   locret_154AA

loc_15444:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_15450
                neg.w   d1

loc_15450:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_15484
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_15472
                asr     y_vel(a0)
                bra.s   loc_15498
; ---------------------------------------------------------------------------

loc_15472:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

loc_15484:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_15498
                move.w  #$FC0,y_vel(a0)

loc_15498:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_154AA
                neg.w   ground_vel(a0)

locret_154AA:
                rts
; ---------------------------------------------------------------------------

loc_154AC:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_154C4
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_154C4:
                bsr.w   sub_11FEE
                tst.w   d1
                bpl.s   loc_15502
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   loc_154EE
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_154DC
                neg.w   d1

loc_154DC:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_154EC
                move.w  #0,y_vel(a0)

locret_154EC:
                rts
; ---------------------------------------------------------------------------

loc_154EE:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   locret_15500
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

locret_15500:
                rts
; ---------------------------------------------------------------------------

loc_15502:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   loc_1550E
                tst.w   y_vel(a0)
                bmi.s   locret_15536

loc_1550E:
                bsr.w   sub_11FD6
                tst.w   d1
                bpl.s   locret_15536
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1551E
                neg.w   d1

loc_1551E:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

locret_15536:
                rts
; ---------------------------------------------------------------------------

loc_15538:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_1554A
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_1554A:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_1555C
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_1555C:
                bsr.w   sub_11FEE
                tst.w   d1
                bpl.s   locret_1559A
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1556C
                neg.w   d1

loc_1556C:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_15584
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_15584:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_1559A
                neg.w   ground_vel(a0)

locret_1559A:
                rts
; ---------------------------------------------------------------------------

loc_1559C:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_155B4
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_155B4:
                bsr.w   sub_11FEE
                tst.w   d1
                bpl.s   loc_155D6
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_155C4
                neg.w   d1

loc_155C4:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_155D4
                move.w  #0,y_vel(a0)

locret_155D4:
                rts
; ---------------------------------------------------------------------------

loc_155D6:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   loc_155E2
                tst.w   y_vel(a0)
                bmi.s   locret_1560A

loc_155E2:
                bsr.w   sub_11FD6
                tst.w   d1
                bpl.s   locret_1560A
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_155F2
                neg.w   d1

loc_155F2:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

locret_1560A:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_1565E
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   loc_1565E
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1564A
                neg.w   d0

loc_1564A:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   loc_15658
                neg.w   (sp)

loc_15658:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

loc_1565E:
                bclr    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                bclr    #Status_RollJump,status(a0)
                move.b  #0,jumping(a0)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,flip_angle(a0)
                move.b  #0,flip_type(a0)
                move.b  #0,flips_remaining(a0)
                move.b  #0,scroll_delay_counter(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function Tails_TouchFloor

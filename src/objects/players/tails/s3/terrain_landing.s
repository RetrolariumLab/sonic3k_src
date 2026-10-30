; Owner: objects/players/tails/s3
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_15F8C
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_15F8C:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   loc_1605A
                cmpi.b  #$80,d0
                beq.w   loc_160D6
                cmpi.b  #$C0,d0
                beq.w   loc_16132
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_15FD0
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_15FD0:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_15FE2
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_15FE2:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_16058
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_15FFA
                cmp.b   d2,d0
                blt.s   locret_16058

loc_15FFA:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_16032
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_16020
                asr     y_vel(a0)
                bra.s   loc_16046
; ---------------------------------------------------------------------------

loc_16020:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

loc_16032:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_16046
                move.w  #$FC0,y_vel(a0)

loc_16046:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_16058
                neg.w   ground_vel(a0)

locret_16058:
                rts
; ---------------------------------------------------------------------------

loc_1605A:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_16072
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_16072:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   loc_160A8
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   loc_16094
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_16092
                move.w  #0,y_vel(a0)

locret_16092:
                rts
; ---------------------------------------------------------------------------

loc_16094:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   locret_160A6
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

locret_160A6:
                rts
; ---------------------------------------------------------------------------

loc_160A8:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   loc_160B4
                tst.w   y_vel(a0)
                bmi.s   locret_160D4

loc_160B4:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_160D4
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

locret_160D4:
                rts
; ---------------------------------------------------------------------------

loc_160D6:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_160E8
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_160E8:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_160FA
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_160FA:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   locret_16130
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_1611A
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_1611A:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_16130
                neg.w   ground_vel(a0)

locret_16130:
                rts
; ---------------------------------------------------------------------------

loc_16132:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_1614A
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_1614A:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   loc_16164
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_16162
                move.w  #0,y_vel(a0)

locret_16162:
                rts
; ---------------------------------------------------------------------------

loc_16164:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   loc_16170
                tst.w   y_vel(a0)
                bmi.s   locret_16190

loc_16170:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_16190
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

locret_16190:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_161CC
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   loc_161CC
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)

loc_161CC:
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

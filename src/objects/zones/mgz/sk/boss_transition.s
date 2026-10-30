; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden boss transition controller, partner recovery and player carrying setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_MGZ2_BossTransition:
                cmpi.w  #2,(Player_mode).w
                beq.w   loc_163D0
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bmi.s   loc_16328
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,y_pos(a1)
                move.l  #Obj_Tails,(Player_2).w
                move.w  #$12,(Tails_CPU_routine).w
                move.w  #0,(Flying_carrying_Sonic_flag).w

loc_16328:
                move.w  #$168,$30(a0)
                move.l  #loc_16334,(a0)

loc_16334:
                subq.w  #1,$30(a0)
                bne.s   loc_16340
                move.l  #loc_16340,(a0)

loc_16340:
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_16384
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_16384
                move.w  d0,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #0,spin_dash_flag(a1)
                cmpi.w  #$14,(Tails_CPU_routine).w
                blo.s   loc_1637E
                move.w  x_pos(a1),x_pos(a0)

loc_1637E:
                move.b  #2,routine(a1)

loc_16384:
                tst.b   (Player_1+render_flags).w
                bmi.s   locret_163CE
                cmpi.b  #2,(Player_1+routine).w
                bne.s   locret_163CE
                lea     (Player_2).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_163CE
                move.w  #$12,(Tails_CPU_routine).w
                tst.w   $30(a0)
                bne.s   locret_163CE
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$14,(Tails_CPU_routine).w

locret_163CE:
                rts
; ---------------------------------------------------------------------------

loc_163D0:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                move.w  #$168,$30(a0)
                move.l  #loc_163F4,(a0)

loc_163F4:
                subq.w  #1,$30(a0)
                bne.s   loc_1640A
                move.l  #loc_1640A,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)

loc_1640A:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_16442
                move.w  d0,y_pos(a1)
                addq.w  #8,y_pos(a1)
                tst.w   $30(a0)
                bne.s   locret_16442
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  #$1A,(Tails_CPU_routine).w

locret_16442:
                rts

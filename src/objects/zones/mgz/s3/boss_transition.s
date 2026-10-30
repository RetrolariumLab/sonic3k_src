; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden boss transition controller, partner recovery and player carrying setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_MGZ2_BossTransition:
                cmpi.w  #2,(Player_mode).w
                beq.w   loc_16E88
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bmi.s   loc_16DE0
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,y_pos(a1)
                move.l  #Obj_Tails,(Player_2).w
                move.w  #$12,(Tails_CPU_routine).w
                move.w  #0,(Flying_carrying_Sonic_flag).w

loc_16DE0:
                move.w  #$168,$30(a0)
                move.l  #loc_16DEC,(a0)

loc_16DEC:
                subq.w  #1,$30(a0)
                bne.s   loc_16DF8
                move.l  #loc_16DF8,(a0)

loc_16DF8:
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_16E3C
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_16E3C
                move.w  d0,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #0,spin_dash_flag(a1)
                cmpi.w  #$14,(Tails_CPU_routine).w
                blo.s   loc_16E36
                move.w  x_pos(a1),x_pos(a0)

loc_16E36:
                move.b  #2,routine(a1)

loc_16E3C:
                tst.b   (Player_1+render_flags).w
                bmi.s   locret_16E86
                cmpi.b  #2,(Player_1+routine).w
                bne.s   locret_16E86
                lea     (Player_2).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_16E86
                move.w  #$12,(Tails_CPU_routine).w
                tst.w   $30(a0)
                bne.s   locret_16E86
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$14,(Tails_CPU_routine).w

locret_16E86:
                rts
; ---------------------------------------------------------------------------

loc_16E88:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                move.w  #$168,$30(a0)
                move.l  #loc_16EAC,(a0)

loc_16EAC:
                subq.w  #1,$30(a0)
                bne.s   loc_16EC2
                move.l  #loc_16EC2,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)

loc_16EC2:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_16EFA
                move.w  d0,y_pos(a1)
                addq.w  #8,y_pos(a1)
                tst.w   $30(a0)
                bne.s   locret_16EFA
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  #$1A,(Tails_CPU_routine).w

locret_16EFA:
                rts

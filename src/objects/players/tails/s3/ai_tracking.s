; Owner: objects/players/tails/s3
; Responsibility: Follower control dispatch, stage-specific initialization, flying catch-up and normal companion navigation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_CPU_Control:
                move.b  (Ctrl_2_held).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
                beq.s   loc_146EE
                move.w  #10*60,(Tails_CPU_idle_timer).w

loc_146EE:
                lea     (Player_1).w,a1
                move.w  (Tails_CPU_routine).w,d0
                move.w  Tails_CPU_Control_Index(pc,d0.w),d0
                jmp     Tails_CPU_Control_Index(pc,d0.w)
; End of function Tails_CPU_Control

; ---------------------------------------------------------------------------
Tails_CPU_Control_Index:
                dc.w    loc_14722-Tails_CPU_Control_Index
                dc.w    Tails_Catch_Up_Flying-Tails_CPU_Control_Index
                dc.w    Tails_FlySwim_Unknown-Tails_CPU_Control_Index
                dc.w    loc_149E8-Tails_CPU_Control_Index
                dc.w    loc_14BC6-Tails_CPU_Control_Index
                dc.w    locret_14C46-Tails_CPU_Control_Index
                dc.w    loc_14C48-Tails_CPU_Control_Index
                dc.w    loc_14C80-Tails_CPU_Control_Index
                dc.w    loc_14D10-Tails_CPU_Control_Index
                dc.w    loc_14D4C-Tails_CPU_Control_Index
                dc.w    loc_14D54-Tails_CPU_Control_Index
                dc.w    loc_14D8C-Tails_CPU_Control_Index
                dc.w    loc_14DD2-Tails_CPU_Control_Index
                dc.w    loc_14E78-Tails_CPU_Control_Index
                dc.w    loc_14EA2-Tails_CPU_Control_Index
                dc.w    loc_14EDA-Tails_CPU_Control_Index
                dc.w    loc_14EE2-Tails_CPU_Control_Index
                dc.w    loc_14F0C-Tails_CPU_Control_Index
; ---------------------------------------------------------------------------

loc_14722:
                tst.b   (Tails_CPU_star_post_flag).w
                bne.w   loc_147A8
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_14744
                bsr.w   sub_14B58
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_14744:
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.w   loc_147C6
                cmpi.w  #$200,(Current_zone_and_act).w
                beq.w   loc_147C6
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   loc_14786
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.b  #2,status(a0)
                move.w  #$18,x_pos(a0)
                move.w  #$600,y_pos(a0)
                move.w  #$C,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_14786:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   loc_147A0
                bsr.w   sub_14B58
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_147A0:
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.s   loc_147C6

loc_147A8:
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #0,status(a0)

loc_147C6:
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.w  #0,(Tails_CPU_flight_timer).w
                rts
; ---------------------------------------------------------------------------

Tails_Catch_Up_Flying:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   loc_14804
                move.w  (Level_frame_counter).w,d0
                andi.w  #$3F,d0
                bne.w   locret_148A0
                tst.b   object_control(a1)
                bne.w   locret_148A0
                move.b  status(a1),d0
                andi.b  #$92,d0
                bne.w   locret_148A0

loc_14804:
                move.w  #4,(Tails_CPU_routine).w
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  d0,(Tails_CPU_target_X).w
                move.w  y_pos(a1),d0
                move.w  d0,(Tails_CPU_target_Y).w
                subi.w  #$C0,d0
                move.w  d0,y_pos(a0)
                ori.w   #high_priority,art_tile(a0)
                move.w  #$100,priority(a0)
                moveq   #0,d0
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,flip_type(a0)
                move.b  d0,double_jump_flag(a0)
                move.b  #2,status(a0)
                move.b  #30,air_left(a0)
                move.b  #$81,object_control(a0)
                move.b  d0,flips_remaining(a0)
                move.b  d0,flip_speed(a0)
                move.w  d0,move_lock(a0)
                move.b  d0,invulnerability_timer(a0)
                move.b  d0,invincibility_timer(a0)
                move.b  d0,speed_shoes_timer(a0)
                move.b  d0,status_tertiary(a0)
                move.b  d0,scroll_delay_counter(a0)
                move.w  d0,next_tilt(a0)                ; and tilt
                move.b  d0,stick_to_convex(a0)
                move.b  d0,spin_dash_flag(a0)
                move.b  d0,spin_dash_flag(a0)
                move.w  d0,spin_dash_counter(a0)
                move.b  d0,jumping(a0)
                move.b  d0,$41(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

locret_148A0:
                rts
; ---------------------------------------------------------------------------

Tails_FlySwim_Unknown:
                tst.b   render_flags(a0)
                bmi.s   loc_148E4
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   loc_148FA
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation
                rts
; ---------------------------------------------------------------------------

loc_148E4:
                move.b  #(8*60)/2,double_jump_property(a0)
                ori.b   #1<<Status_InAir,status(a0)
                bsr.w   Tails_Set_Flying_Animation
                move.w  #0,(Tails_CPU_flight_timer).w

loc_148FA:
                lea     (Pos_table).w,a2
                move.w  #$10,d2
                lsl.b   #2,d2
                addq.b  #4,d2
                move.w  (Pos_table_index).w,d3
                sub.b   d2,d3
                move.w  (a2,d3.w),(Tails_CPU_target_X).w
                move.w  2(a2,d3.w),(Tails_CPU_target_Y).w
                bsr.w   Tails_Set_Flying_Animation
                move.w  x_pos(a0),d0
                sub.w   (Tails_CPU_target_X).w,d0
                beq.s   loc_1496C
                move.w  d0,d2
                bpl.s   loc_1492C
                neg.w   d2

loc_1492C:
                lsr.w   #4,d2
                cmpi.w  #$C,d2
                blo.s   loc_14936
                moveq   #$C,d2

loc_14936:
                move.b  x_vel(a1),d1
                bpl.s   loc_1493E
                neg.b   d1

loc_1493E:
                add.b   d1,d2
                addq.w  #1,d2
                tst.w   d0
                bmi.s   loc_14958
                bset    #Status_Facing,status(a0)
                cmp.w   d0,d2
                blo.s   loc_14954
                move.w  d0,d2
                moveq   #0,d0

loc_14954:
                neg.w   d2
                bra.s   loc_14968
; ---------------------------------------------------------------------------

loc_14958:
                bclr    #Status_Facing,status(a0)
                neg.w   d0
                cmp.w   d0,d2
                blo.s   loc_14968
                move.b  d0,d2
                moveq   #0,d0

loc_14968:
                add.w   d2,x_pos(a0)

loc_1496C:
                moveq   #1,d2
                move.w  y_pos(a0),d1
                sub.w   (Tails_CPU_target_Y).w,d1
                beq.s   loc_14980
                bmi.s   loc_1497C
                neg.w   d2

loc_1497C:
                add.w   d2,y_pos(a0)

loc_14980:
                lea     (Stat_table).w,a2
                move.b  2(a2,d3.w),d2
                andi.b  #$92,d2
                bne.s   locret_149E6
                or.w    d0,d1
                bne.s   locret_149E6
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                andi.b  #1<<Status_Underwater,status(a0)
                ori.b   #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   art_tile(a1)
                bpl.s   loc_149DA
                ori.w   #high_priority,art_tile(a0)

loc_149DA:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)

locret_149E6:
                rts
; ---------------------------------------------------------------------------

loc_149E8:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   loc_14A16
                move.w  #4,(Tails_CPU_routine).w
                move.b  #0,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.b  #$20,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14A16:
                bsr.w   sub_14B8A
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   loc_14B4C
                tst.b   object_control(a0)
                bmi.w   loc_14B4C
                tst.b   status_tertiary(a1)
                bmi.w   loc_14B4C
                tst.w   move_lock(a0)
                beq.s   loc_14A44
                tst.w   ground_vel(a0)
                bne.s   loc_14A44
                move.w  #8,(Tails_CPU_routine).w

loc_14A44:
                lea     (Pos_table).w,a2
                move.w  #$10,d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.w  (a2,d0.w),d2
                btst    #Status_OnObj,status(a1)
                bne.s   loc_14A6E
                cmpi.w  #$400,ground_vel(a1)
                bge.s   loc_14A6E
                subi.w  #$20,d2

loc_14A6E:
                move.w  2(a2,d0.w),d3
                lea     (Stat_table).w,a2
                move.w  (a2,d0.w),d1
                move.b  2(a2,d0.w),d4
                move.w  d1,d0
                btst    #Status_Push,status(a0)
                beq.s   loc_14A90
                btst    #5,d4
                beq.w   loc_14B2A

loc_14A90:
                sub.w   x_pos(a0),d2
                beq.s   loc_14ADE
                bpl.s   loc_14ABC
                neg.w   d2
                cmpi.w  #$30,d2
                bcs.s   loc_14AA8
                andi.w  #$F3F3,d1
                ori.w   #$404,d1

loc_14AA8:
                tst.w   ground_vel(a0)
                beq.s   loc_14AF2
                btst    #Status_Facing,status(a0)
                beq.s   loc_14AF2
                subq.w  #1,x_pos(a0)
                bra.s   loc_14AF2
; ---------------------------------------------------------------------------

loc_14ABC:
                cmpi.w  #$30,d2
                blo.s   loc_14ACA
                andi.w  #$F3F3,d1
                ori.w   #$808,d1

loc_14ACA:
                tst.w   ground_vel(a0)
                beq.s   loc_14AF2
                btst    #Status_Facing,status(a0)
                bne.s   loc_14AF2
                addq.w  #1,x_pos(a0)
                bra.s   loc_14AF2
; ---------------------------------------------------------------------------

loc_14ADE:
                bclr    #Status_Facing,status(a0)
                move.b  d4,d0
                andi.b  #1,d0
                beq.s   loc_14AF2
                bset    #Status_Facing,status(a0)

loc_14AF2:
                tst.b   (Tails_CPU_auto_jump_flag).w
                beq.s   loc_14B0A
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|0,d1
                btst    #Status_InAir,status(a0)
                bne.s   loc_14B46
                move.b  #0,(Tails_CPU_auto_jump_flag).w

loc_14B0A:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$FF,d0
                beq.s   loc_14B1A
                cmpi.w  #$40,d2
                bhs.s   loc_14B46

loc_14B1A:
                sub.w   y_pos(a0),d3
                beq.s   loc_14B46
                bpl.s   loc_14B46
                neg.w   d3
                cmpi.w  #$20,d3
                blo.s   loc_14B46

loc_14B2A:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   loc_14B46
                cmpi.b  #8,anim(a0)
                beq.s   loc_14B46
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),d1
                move.b  #1,(Tails_CPU_auto_jump_flag).w

loc_14B46:
                move.w  d1,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_14B4C:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   locret_14B56
                subq.w  #1,(Tails_CPU_idle_timer).w

locret_14B56:
                rts

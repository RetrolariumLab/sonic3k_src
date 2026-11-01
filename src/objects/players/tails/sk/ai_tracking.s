; Owner: objects/players/tails/sk
; Responsibility: Follower control dispatch, stage-specific initialization, flying catch-up and normal companion navigation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_CPU_Control:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
                beq.s   loc_139DC
                move.w  #10*60,(Tails_CPU_idle_timer).w

loc_139DC:
                lea     (Player_1).w,a1
                move.w  (Tails_CPU_routine).w,d0
                move.w  Tails_CPU_Control_Index(pc,d0.w),d0
                jmp     Tails_CPU_Control_Index(pc,d0.w)
; End of function Tails_CPU_Control

; ---------------------------------------------------------------------------
Tails_CPU_Control_Index:
                dc.w    loc_13A10-Tails_CPU_Control_Index
                dc.w    Tails_Catch_Up_Flying-Tails_CPU_Control_Index
                dc.w    Tails_FlySwim_Unknown-Tails_CPU_Control_Index
                dc.w    loc_13D4A-Tails_CPU_Control_Index
                dc.w    loc_13F40-Tails_CPU_Control_Index
                dc.w    locret_13FC0-Tails_CPU_Control_Index
                dc.w    loc_13FC2-Tails_CPU_Control_Index
                dc.w    loc_13FFA-Tails_CPU_Control_Index
                dc.w    loc_1408A-Tails_CPU_Control_Index
                dc.w    loc_140C6-Tails_CPU_Control_Index
                dc.w    loc_140CE-Tails_CPU_Control_Index
                dc.w    loc_14106-Tails_CPU_Control_Index
                dc.w    loc_1414C-Tails_CPU_Control_Index
                dc.w    loc_141F2-Tails_CPU_Control_Index
                dc.w    loc_1421C-Tails_CPU_Control_Index
                dc.w    loc_14254-Tails_CPU_Control_Index
                dc.w    loc_1425C-Tails_CPU_Control_Index
                dc.w    loc_14286-Tails_CPU_Control_Index
; ---------------------------------------------------------------------------

loc_13A10:
                tst.b   (Tails_CPU_star_post_flag).w
                bne.w   loc_13AF4
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_13A32
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_13A32:
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.w   loc_13B12
                cmpi.w  #$200,(Current_zone_and_act).w
                beq.w   loc_13B12
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   loc_13A74
                move.w  #$18,x_pos(a0)
                move.w  #$600,y_pos(a0)

loc_13A5A:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.b  #2,status(a0)
                move.w  #$C,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_13A74:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   loc_13A8E
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_13A8E:
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.w   loc_13B12
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   loc_13AB4
                tst.w   (SK_alone_flag).w
                bne.s   loc_13AB4
                move.w  #$D8,x_pos(a0)
                move.w  #$500,y_pos(a0)
                bra.s   loc_13A5A
; ---------------------------------------------------------------------------

loc_13AB4:
                cmpi.w  #$800,(Current_zone_and_act).w
                beq.w   loc_13B18
                cmpi.w  #$900,(Current_zone_and_act).w
                beq.w   loc_13B12
                cmpi.w  #$A00,(Current_zone_and_act).w
                bne.s   loc_13AE2
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_13AE2:
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.w   loc_13B12
                cmpi.b  #$17,(Current_zone).w
                beq.s   loc_13B18

loc_13AF4:
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #0,status(a0)

loc_13B12:
                move.b  #0,object_control(a0)

loc_13B18:
                move.w  #6,(Tails_CPU_routine).w
                move.w  #0,(Tails_CPU_flight_timer).w
                rts
; ---------------------------------------------------------------------------

Tails_Catch_Up_Flying:
                move.b  (Ctrl_2_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   loc_13B50
                move.w  (Level_frame_counter).w,d0
                andi.w  #$3F,d0
                bne.w   locret_13BF6
                tst.b   object_control(a1)
                bmi.w   locret_13BF6
                move.b  status(a1),d0
                andi.b  #$80,d0
                bne.w   locret_13BF6

loc_13B50:
                move.w  #4,(Tails_CPU_routine).w
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  d0,(Tails_CPU_target_X).w
                move.w  y_pos(a1),d0
                move.w  d0,(Tails_CPU_target_Y).w
                subi.w  #$C0,d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_13B78
                addi.w  #2*$C0,d0

loc_13B78:
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

locret_13BF6:
                rts
; ---------------------------------------------------------------------------

Tails_FlySwim_Unknown:
                tst.b   render_flags(a0)
                bmi.s   loc_13C3A
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   loc_13C50
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

loc_13C3A:
                move.b  #(8*60)/2,double_jump_property(a0)
                ori.b   #1<<Status_InAir,status(a0)
                bsr.w   Tails_Set_Flying_Animation
                move.w  #0,(Tails_CPU_flight_timer).w

loc_13C50:
                lea     (Pos_table).w,a2
                move.w  #$10,d2
                lsl.b   #2,d2
                addq.b  #4,d2
                move.w  (Pos_table_index).w,d3
                sub.b   d2,d3
                move.w  (a2,d3.w),(Tails_CPU_target_X).w
                move.w  2(a2,d3.w),(Tails_CPU_target_Y).w
                move.w  x_pos(a0),d0
                sub.w   (Tails_CPU_target_X).w,d0
                beq.s   loc_13CBE
                move.w  d0,d2
                bpl.s   loc_13C7E
                neg.w   d2

loc_13C7E:
                lsr.w   #4,d2
                cmpi.w  #$C,d2
                blo.s   loc_13C88
                moveq   #$C,d2

loc_13C88:
                move.b  x_vel(a1),d1
                bpl.s   loc_13C90
                neg.b   d1

loc_13C90:
                add.b   d1,d2
                addq.w  #1,d2
                tst.w   d0
                bmi.s   loc_13CAA
                bset    #Status_Facing,status(a0)
                cmp.w   d0,d2
                blo.s   loc_13CA6
                move.w  d0,d2
                moveq   #0,d0

loc_13CA6:
                neg.w   d2
                bra.s   loc_13CBA
; ---------------------------------------------------------------------------

loc_13CAA:
                bclr    #Status_Facing,status(a0)
                neg.w   d0
                cmp.w   d0,d2
                blo.s   loc_13CBA
                move.b  d0,d2
                moveq   #0,d0

loc_13CBA:
                add.w   d2,x_pos(a0)

loc_13CBE:
                moveq   #1,d2
                move.w  y_pos(a0),d1
                sub.w   (Tails_CPU_target_Y).w,d1
                beq.s   loc_13CD2
                bmi.s   loc_13CCE
                neg.w   d2

loc_13CCE:
                add.w   d2,y_pos(a0)

loc_13CD2:
                lea     (Stat_table).w,a2
                move.b  2(a2,d3.w),d2
                andi.b  #$80,d2
                bne.s   loc_13D42
                or.w    d0,d1
                bne.s   loc_13D42
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_13D42
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
                bpl.s   loc_13D34
                ori.w   #high_priority,art_tile(a0)

loc_13D34:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                rts
; ---------------------------------------------------------------------------

loc_13D42:
                move.b  #$81,object_control(a0)
                rts
; ---------------------------------------------------------------------------

loc_13D4A:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   loc_13D78
                move.w  #4,(Tails_CPU_routine).w
                move.b  #0,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.b  #$20,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_13D78:
                bsr.w   TailsSKWatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   loc_13EBE
                tst.b   object_control(a0)
                bmi.w   loc_13EBE
                tst.b   status_tertiary(a1)
                bmi.w   loc_13EBE
                tst.w   move_lock(a0)
                beq.s   loc_13DA6
                tst.w   ground_vel(a0)
                bne.s   loc_13DA6
                move.w  #8,(Tails_CPU_routine).w

loc_13DA6:
                lea     (Pos_table).w,a2
                move.w  #$10,d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.w  (a2,d0.w),d2
                btst    #Status_OnObj,status(a1)
                bne.s   loc_13DD0
                cmpi.w  #$400,ground_vel(a1)
                bge.s   loc_13DD0
                subi.w  #$20,d2

loc_13DD0:
                move.w  2(a2,d0.w),d3
                lea     (Stat_table).w,a2
                move.w  (a2,d0.w),d1
                move.b  2(a2,d0.w),d4
                move.w  d1,d0
                btst    #Status_Push,status(a0)
                beq.s   loc_13DF2
                btst    #5,d4
                beq.w   loc_13E9C

loc_13DF2:
                sub.w   x_pos(a0),d2
                beq.s   loc_13E50
                bpl.s   loc_13E26
                neg.w   d2
                cmpi.w  #$30,d2
                blo.s   loc_13E0A
                andi.w  #$F3F3,d1
                ori.w   #$404,d1

loc_13E0A:
                tst.w   ground_vel(a0)
                beq.s   loc_13E64
                btst    #Status_Facing,status(a0)
                beq.s   loc_13E64
                btst    #0,object_control(a0)
                bne.s   loc_13E64
                subq.w  #1,x_pos(a0)
                bra.s   loc_13E64
; ---------------------------------------------------------------------------

loc_13E26:
                cmpi.w  #$30,d2
                blo.s   loc_13E34
                andi.w  #$F3F3,d1
                ori.w   #$808,d1

loc_13E34:
                tst.w   ground_vel(a0)
                beq.s   loc_13E64
                btst    #Status_Facing,status(a0)
                bne.s   loc_13E64
                btst    #0,object_control(a0)
                bne.s   loc_13E64
                addq.w  #1,x_pos(a0)
                bra.s   loc_13E64
; ---------------------------------------------------------------------------

loc_13E50:
                bclr    #Status_Facing,status(a0)
                move.b  d4,d0
                andi.b  #1,d0
                beq.s   loc_13E64
                bset    #Status_Facing,status(a0)

loc_13E64:
                tst.b   (Tails_CPU_auto_jump_flag).w
                beq.s   loc_13E7C
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|0,d1
                btst    #Status_InAir,status(a0)
                bne.s   loc_13EB8
                move.b  #0,(Tails_CPU_auto_jump_flag).w

loc_13E7C:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$FF,d0
                beq.s   loc_13E8C
                cmpi.w  #$40,d2
                bhs.s   loc_13EB8

loc_13E8C:
                sub.w   y_pos(a0),d3
                beq.s   loc_13EB8
                bpl.s   loc_13EB8
                neg.w   d3
                cmpi.w  #$20,d3
                blo.s   loc_13EB8

loc_13E9C:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   loc_13EB8
                cmpi.b  #8,anim(a0)
                beq.s   loc_13EB8
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),d1
                move.b  #1,(Tails_CPU_auto_jump_flag).w

loc_13EB8:
                move.w  d1,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_13EBE:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   locret_13EC8
                subq.w  #1,(Tails_CPU_idle_timer).w

locret_13EC8:
                rts

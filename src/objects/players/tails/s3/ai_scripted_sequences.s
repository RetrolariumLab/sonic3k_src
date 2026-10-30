; Owner: objects/players/tails/s3
; Responsibility: Follower reset and interaction helpers, idle spindash and level-scripted flight or carrying sequences
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_14B58:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function sub_14B58

; =============== S U B R O U T I N E =======================================

sub_14B8A:
                tst.b   render_flags(a0)
                bmi.s   loc_14BB6
                btst    #Status_OnObj,status(a0)
                beq.s   loc_14BA6
                moveq   #0,d0
                movea.w interact(a0),a3
                move.w  (Tails_CPU_interact).w,d0
                cmp.w   (a3),d0
                bne.s   loc_14BB2

loc_14BA6:
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   loc_14BBC

loc_14BB2:
                bra.w   sub_14B58
; ---------------------------------------------------------------------------

loc_14BB6:
                move.w  #0,(Tails_CPU_flight_timer).w

loc_14BBC:
                movea.w interact(a0),a3
                move.w  (a3),(Tails_CPU_interact).w
                rts
; End of function sub_14B8A

; ---------------------------------------------------------------------------

loc_14BC6:
                bsr.w   sub_14B8A
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   locret_14C44
                tst.w   move_lock(a0)
                bne.s   locret_14C44
                tst.b   spin_dash_flag(a0)
                bne.s   loc_14C1A
                tst.w   ground_vel(a0)
                bne.s   locret_14C44
                bclr    #Status_Facing,status(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_14BFA
                bset    #Status_Facing,status(a0)

loc_14BFA:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                beq.s   loc_14C2A
                cmpi.b  #8,anim(a0)
                bne.s   locret_14C44
                move.w  #((button_A_mask|button_B_mask|button_C_mask|button_down_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_down_mask),(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_14C1A:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                bne.s   loc_14C38

loc_14C2A:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.w  #6,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_14C38:
                andi.b  #$1F,d0
                bne.s   locret_14C44
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

locret_14C44:
                rts
; ---------------------------------------------------------------------------

locret_14C46:
                rts
; ---------------------------------------------------------------------------

loc_14C48:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_15202
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$E,(Tails_CPU_routine).w

loc_14C80:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_14C9C
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

loc_14C9C:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   loc_14D08
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   art_tile(a1)
                bpl.s   loc_14CEE
                ori.w   #high_priority,art_tile(a0)

loc_14CEE:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                cmpi.w  #1,(Player_mode).w
                bne.s   loc_14D08
                move.w  #$10,(Tails_CPU_routine).w

loc_14D08:
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_14D10:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_14D32
                ori.w   #((button_A_mask|button_B_mask|button_C_mask|button_right_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_right_mask),(Ctrl_2_logical).w

loc_14D32:
                tst.b   render_flags(a0)
                bmi.s   locret_14D4A
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.w  #$A,(Tails_CPU_routine).w

locret_14D4A:
                rts
; ---------------------------------------------------------------------------

loc_14D4C:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_14D54:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_15202
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$16,(Tails_CPU_routine).w

loc_14D8C:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_14DAE
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_14DAE:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_14DC2
                move.w  #$18,(Tails_CPU_routine).w

loc_14DC2:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_14DD2:
                move.b  #(8*60)/2,double_jump_property(a0)
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   loc_14DEA
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.w   loc_14E68
                bra.w   loc_14F68
; ---------------------------------------------------------------------------

loc_14DEA:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.w   loc_14F68
                clr.b   (_unkFAAC).w
                btst    #button_down,(Ctrl_1_held).w
                beq.s   loc_14E1E
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$C0,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_14E58
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   loc_14E58
; ---------------------------------------------------------------------------

loc_14E1E:
                btst    #button_up,(Ctrl_1_held).w
                beq.s   loc_14E40
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$20,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_14E58
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   loc_14E58
; ---------------------------------------------------------------------------

loc_14E40:
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                bcs.s   loc_14E58
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_14E58:
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                or.b    (Ctrl_2_held_logical).w,d0
                move.b  d0,(Ctrl_2_logical).w

loc_14E68:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_14E78:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$1C,(Tails_CPU_routine).w

loc_14EA2:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_14EC4
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_14EC4:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   locret_14ED8
                move.w  #$1E,(Tails_CPU_routine).w

locret_14ED8:
                rts
; ---------------------------------------------------------------------------

loc_14EDA:
                move.b  #(8*60)/2,double_jump_property(a0)
                rts
; ---------------------------------------------------------------------------

loc_14EE2:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #2,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$22,(Tails_CPU_routine).w

loc_14F0C:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_14F28
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

loc_14F28:
                btst    #Status_InAir,status(a0)
                bne.s   locret_14F66
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)

locret_14F66:
                rts
; ---------------------------------------------------------------------------

loc_14F68:
                tst.b   (_unkFAAC).w
                bne.s   loc_14FE8
                lea     (Player_1).w,a1
                tst.b   render_flags(a1)
                bpl.s   loc_14FB6
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   loc_15030
                cmpi.w  #$300,y_vel(a1)
                bge.s   loc_14FB6
                move.w  #0,x_vel(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                cmpi.w  #$200,y_vel(a0)
                bge.s   loc_14FAE
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_14FB4
                move.b  #0,(Tails_CPU_auto_fly_timer).w

loc_14FAE:
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_14FB4:
                bra.s   loc_15030
; ---------------------------------------------------------------------------

loc_14FB6:
                st      (_unkFAAC).w
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   loc_14FC6
                neg.w   d1

loc_14FC6:
                lsr.w   #2,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                move.w  d1,(Camera_stored_min_X_pos).w
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bpl.s   loc_14FDE
                neg.w   d1

loc_14FDE:
                lsr.w   #2,d1
                move.w  d1,(Camera_stored_max_X_pos).w
                bra.w   loc_15030
; ---------------------------------------------------------------------------

loc_14FE8:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subi.w  #$10,d1
                move.w  (Camera_stored_max_X_pos).w,d2
                bclr    #Status_Facing,status(a0)
                cmp.w   x_pos(a1),d0
                blo.s   loc_15016
                bset    #Status_Facing,status(a0)
                neg.w   d2

loc_15016:
                add.w   d2,x_vel(a0)
                cmp.w   y_pos(a1),d1
                bhs.s   loc_15030
                move.w  (Camera_stored_min_X_pos).w,d2
                cmp.w   y_pos(a1),d1
                blo.s   loc_1502C
                neg.w   d2

loc_1502C:
                add.w   d2,y_vel(a0)

loc_15030:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================

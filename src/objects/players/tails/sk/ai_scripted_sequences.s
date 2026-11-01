; Owner: objects/players/tails/sk
; Responsibility: Follower reset and interaction helpers, idle spindash and level-scripted flight or carrying sequences
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TailsSKResetCPUFollowerToOffscreenCatchUp:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function TailsSKResetCPUFollowerToOffscreenCatchUp

; =============== S U B R O U T I N E =======================================

TailsSKWatchCPUOffscreenTimeoutAndInteractionCode:
                tst.b   render_flags(a0)
                bmi.s   loc_13F28
                btst    #Status_OnObj,status(a0)
                beq.s   loc_13F18
                moveq   #0,d0
                movea.w interact(a0),a3
                move.w  (Tails_CPU_interact).w,d0
                cmp.w   (a3),d0
                bne.s   loc_13F24

loc_13F18:
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   loc_13F2E

loc_13F24:
                bra.w   TailsSKResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

loc_13F28:
                move.w  #0,(Tails_CPU_flight_timer).w

loc_13F2E:
                btst    #Status_OnObj,status(a0)
                beq.s   locret_13F3E
                movea.w interact(a0),a3
                move.w  (a3),(Tails_CPU_interact).w

locret_13F3E:
                rts
; End of function TailsSKWatchCPUOffscreenTimeoutAndInteractionCode

; ---------------------------------------------------------------------------

loc_13F40:
                bsr.w   TailsSKWatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   locret_13FBE
                tst.w   move_lock(a0)
                bne.s   locret_13FBE
                tst.b   spin_dash_flag(a0)
                bne.s   loc_13F94
                tst.w   ground_vel(a0)
                bne.s   locret_13FBE
                bclr    #Status_Facing,status(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_13F74
                bset    #Status_Facing,status(a0)

loc_13F74:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                beq.s   loc_13FA4
                cmpi.b  #8,anim(a0)
                bne.s   locret_13FBE
                move.w  #((button_A_mask|button_B_mask|button_C_mask|button_down_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_down_mask),(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_13F94:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                bne.s   loc_13FB2

loc_13FA4:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.w  #6,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_13FB2:
                andi.b  #$1F,d0
                bne.s   locret_13FBE
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

locret_13FBE:
                rts
; ---------------------------------------------------------------------------

locret_13FC0:
                rts
; ---------------------------------------------------------------------------

loc_13FC2:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$E,(Tails_CPU_routine).w

loc_13FFA:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_14016
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

loc_14016:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   loc_14082
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
                bpl.s   loc_14068
                ori.w   #high_priority,art_tile(a0)

loc_14068:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                cmpi.w  #1,(Player_mode).w
                bne.s   loc_14082
                move.w  #$10,(Tails_CPU_routine).w

loc_14082:
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1408A:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_140AC
                ori.w   #((button_A_mask|button_B_mask|button_C_mask|button_right_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_right_mask),(Ctrl_2_logical).w

loc_140AC:
                tst.b   render_flags(a0)
                bmi.s   locret_140C4
                moveq   #0,d0
                move.l  d0,(a0)
                move.w  d0,x_pos(a0)
                move.w  d0,y_pos(a0)
                move.w  #$A,(Tails_CPU_routine).w

locret_140C4:
                rts
; ---------------------------------------------------------------------------

loc_140C6:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_140CE:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$16,(Tails_CPU_routine).w

loc_14106:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_14128
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_14128:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_1413C
                move.w  #$18,(Tails_CPU_routine).w

loc_1413C:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1414C:
                move.b  #(8*60)/2,double_jump_property(a0)
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   loc_14164
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.w   loc_141E2
                bra.w   loc_142E2
; ---------------------------------------------------------------------------

loc_14164:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.w   loc_142E2
                clr.b   (_unkFAAC).w
                btst    #button_down,(Ctrl_1_held).w
                beq.s   loc_14198
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$C0,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_141D2
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   loc_141D2
; ---------------------------------------------------------------------------

loc_14198:
                btst    #button_up,(Ctrl_1_held).w
                beq.s   loc_141BA
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$20,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_141D2
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   loc_141D2
; ---------------------------------------------------------------------------

loc_141BA:
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_141D2
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_141D2:
                move.b  (Ctrl_1).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                or.b    (Ctrl_2_logical).w,d0
                move.b  d0,(Ctrl_2_logical).w

loc_141E2:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_141F2:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$1C,(Tails_CPU_routine).w

loc_1421C:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_1423E
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_1423E:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   locret_14252
                move.w  #$1E,(Tails_CPU_routine).w

locret_14252:
                rts
; ---------------------------------------------------------------------------

loc_14254:
                move.b  #(8*60)/2,double_jump_property(a0)
                rts
; ---------------------------------------------------------------------------

loc_1425C:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #2,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$22,(Tails_CPU_routine).w

loc_14286:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_142A2
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

loc_142A2:
                btst    #Status_InAir,status(a0)
                bne.s   locret_142E0
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)

locret_142E0:
                rts
; ---------------------------------------------------------------------------

loc_142E2:
                tst.b   (_unkFAAC).w
                bne.s   loc_14362
                lea     (Player_1).w,a1
                tst.b   render_flags(a1)
                bpl.s   loc_14330
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   loc_143AA
                cmpi.w  #$300,y_vel(a1)
                bge.s   loc_14330
                move.w  #0,x_vel(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                cmpi.w  #$200,y_vel(a0)
                bge.s   loc_14328
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   loc_1432E
                move.b  #0,(Tails_CPU_auto_fly_timer).w

loc_14328:
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

loc_1432E:
                bra.s   loc_143AA
; ---------------------------------------------------------------------------

loc_14330:
                st      (_unkFAAC).w
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   loc_14340
                neg.w   d1

loc_14340:
                lsr.w   #2,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                move.w  d1,(Camera_stored_min_X_pos).w
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bpl.s   loc_14358
                neg.w   d1

loc_14358:
                lsr.w   #2,d1
                move.w  d1,(Camera_stored_max_X_pos).w
                bra.w   loc_143AA
; ---------------------------------------------------------------------------

loc_14362:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subi.w  #$10,d1
                move.w  (Camera_stored_max_X_pos).w,d2
                bclr    #Status_Facing,status(a0)
                cmp.w   x_pos(a1),d0
                blo.s   loc_14390
                bset    #Status_Facing,status(a0)
                neg.w   d2

loc_14390:
                add.w   d2,x_vel(a0)
                cmp.w   y_pos(a1),d1
                bhs.s   loc_143AA
                move.w  (Camera_stored_min_X_pos).w,d2
                cmp.w   y_pos(a1),d1
                blo.s   loc_143A6
                neg.w   d2

loc_143A6:
                add.w   d2,y_vel(a0)

loc_143AA:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================

; Owner: objects/players/tails/sk
; Responsibility: Tails screen bounds, rolling initiation, jump launch and jump height control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Check_Screen_Boundaries:
                move.l  x_pos(a0),d1
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d1
                swap    d1
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   d1,d0
                bhi.s   loc_14F5C
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                blo.s   loc_14F5C

loc_14F30:
                tst.b   (Disable_death_plane).w
                bne.s   locret_14F4A
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_14F4C
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_14F56

locret_14F4A:
                rts
; ---------------------------------------------------------------------------

loc_14F4C:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   locret_14F4A

loc_14F56:
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

loc_14F5C:
                move.w  d0,x_pos(a0)
                move.w  #0,2+x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                bra.s   loc_14F30
; End of function Tails_Check_Screen_Boundaries

; =============== S U B R O U T I N E =======================================

Tails_Roll:
                tst.b   status_secondary(a0)
                bmi.s   locret_14FA8
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   locret_14FA8
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   loc_14FAA
                move.w  ground_vel(a0),d0
                bpl.s   loc_14F94
                neg.w   d0

loc_14F94:
                cmpi.w  #$100,d0
                bhs.s   loc_14FBA
                btst    #Status_OnObj,status(a0)
                bne.s   locret_14FA8
                move.b  #8,anim(a0)

locret_14FA8:
                rts
; ---------------------------------------------------------------------------

loc_14FAA:
                cmpi.b  #8,anim(a0)
                bne.s   locret_14FA8
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14FBA:
                btst    #Status_Roll,status(a0)
                beq.s   loc_14FC4
                rts
; ---------------------------------------------------------------------------

loc_14FC4:
                bset    #Status_Roll,status(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_14FEA
                subq.w  #2,y_pos(a0)

loc_14FEA:
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   locret_15000
                move.w  #$200,ground_vel(a0)

locret_15000:
                rts
; End of function Tails_Roll

; =============== S U B R O U T I N E =======================================

Tails_Jump:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_150D0
                moveq   #0,d0
                move.b  angle(a0),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_15024
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0

loc_15024:
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1
                blt.w   locret_150D0
                move.w  #$680,d2
                btst    #Status_Underwater,status(a0)
                beq.s   loc_1504C
                move.w  #$380,d2

loc_1504C:
                moveq   #0,d0
                move.b  angle(a0),d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d1
                asr.l   #8,d1
                add.w   d1,x_vel(a0)
                muls.w  d2,d0
                asr.l   #8,d0
                add.w   d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                addq.l  #4,sp
                move.b  #1,jumping(a0)
                clr.b   stick_to_convex(a0)
                move.w  #sfx_Jump,d0
                jsr     (Play_SFX).l
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                bne.s   loc_150D2
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_150CC
                neg.w   d0

loc_150CC:
                sub.w   d0,y_pos(a0)

locret_150D0:
                rts
; ---------------------------------------------------------------------------

loc_150D2:
                bset    #Status_RollJump,status(a0)
                rts
; End of function Tails_Jump

; =============== S U B R O U T I N E =======================================

Tails_JumpHeight:
                tst.b   jumping(a0)
                beq.s   loc_15106
                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)
                beq.s   loc_150F0
                move.w  #-$200,d1

loc_150F0:
                cmp.w   y_vel(a0),d1
                ble.s   Tails_Test_For_Flight
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   locret_15104
                move.w  d1,y_vel(a0)

locret_15104:
                rts
; ---------------------------------------------------------------------------

loc_15106:
                tst.b   spin_dash_flag(a0)
                bne.s   locret_1511A
                cmpi.w  #-$FC0,y_vel(a0)
                bge.s   locret_1511A
                move.w  #-$FC0,y_vel(a0)

locret_1511A:
                rts
; ---------------------------------------------------------------------------

Tails_Test_For_Flight:
                tst.b   double_jump_flag(a0)
                bne.w   locret_151A2
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_151A2
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_15156
                tst.b   (Super_Tails_flag).w
                bne.s   loc_1515C
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_1515C
                cmpi.w  #50,(Ring_count).w
                blo.s   loc_1515C
                tst.b   (Update_HUD_timer).w
                bne.s   Tails_Transform
                bra.s   loc_1515C
; ---------------------------------------------------------------------------

loc_15156:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   locret_151A2

loc_1515C:
                btst    #Status_Roll,status(a0)
                beq.s   loc_1518C
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d1
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                sub.b   default_y_radius(a0),d1
                ext.w   d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_15188
                neg.w   d0

loc_15188:
                add.w   d1,y_pos(a0)

loc_1518C:
                bclr    #Status_RollJump,status(a0)
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

locret_151A2:
                rts
; ---------------------------------------------------------------------------

Tails_Transform:
                move.b  #1,(Super_palette_status).w     ; set Super/Hyper palette status to 'fading'
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Tails_flag).w         ; set flag to Super Tails
                move.w  #60,(Super_frame_count).w
                move.b  #$81,object_control(a0)
                move.b  #$29,anim(a0)                   ; enter 'transformation' animation
                move.l  #Obj_SuperTailsBirds,(Invincibility_stars).w  ; load Super Flickies object
                move.w  #$800,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$18,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$C0,Deceleration_P2-Max_speed_P2(a4)
                move.b  #0,invincibility_timer(a0)
                bset    #Status_Invincible,status_secondary(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; End of function Tails_JumpHeight

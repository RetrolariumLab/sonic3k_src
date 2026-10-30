; Owner: objects/players/tails/sk
; Responsibility: Competition Tails object dispatch, active control, flying and two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Tails2P:
                cmpa.w  #Player_1,a0
                bne.s   loc_13130
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_13124
                bchg    #3,render_flags(a0)

loc_13124:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_1314C
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

loc_13130:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_1314C
                bchg    #4,render_flags(a0)

loc_1314C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tails2P_Index(pc,d0.w),d1
                jmp     Tails2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Tails2P_Index:
                dc.w    loc_13166-Tails2P_Index
                dc.w    loc_13274-Tails2P_Index
                dc.w    loc_1569C-Tails2P_Index
                dc.w    loc_1578E-Tails2P_Index
                dc.w    loc_157E0-Tails2P_Index
                dc.w    loc_157F4-Tails2P_Index
; ---------------------------------------------------------------------------

loc_13166:
                addq.b  #2,routine(a0)
                move.b  #$B,y_radius(a0)
                move.b  #5,x_radius(a0)
                move.b  #$B,default_y_radius(a0)
                move.b  #5,default_x_radius(a0)
                move.l  #Map_Tails2P,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$84,render_flags(a0)
                move.b  #1,character_id(a0)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed_P2-Max_speed_P2(a4)
                move.w  (a1)+,Acceleration_P2-Max_speed_P2(a4)
                move.w  (a1)+,Deceleration_P2-Max_speed_P2(a4)
                tst.b   (Last_star_post_hit).w
                bne.w   loc_13250
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_13218
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_131F2
                ori.w   #high_priority,art_tile(a0)

loc_131F2:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails_2P).w
                move.w  a0,(Tails_tails_2P+$30).w
                bra.s   loc_13250
; ---------------------------------------------------------------------------

loc_13218:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_1322C
                ori.w   #high_priority,art_tile(a0)

loc_1322C:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w

loc_13250:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #30,air_left(a0)
                move.w  #0,(Tails_CPU_routine).w
                move.w  #10*60,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w

loc_13274:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_13294
                cmpa.w  #Player_1,a0
                bne.s   loc_13294
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_13294
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_13294:
                cmpa.w  #Player_1,a0
                bne.s   loc_132B4
                move.w  (Ctrl_1_logical).w,(Ctrl_2_logical).w
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_132C0
                move.w  (Ctrl_1).w,(Ctrl_2_logical).w
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   loc_132C0
; ---------------------------------------------------------------------------

loc_132B4:
                tst.b   (Ctrl_2_locked).w
                bne.s   loc_132C0
                move.w  (Ctrl_2).w,(Ctrl_2_logical).w

loc_132C0:
                bsr.w   Tails_Display
                btst    #0,object_control(a0)
                bne.s   loc_132DE
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  off_1332E(pc,d0.w),d1
                jsr     off_1332E(pc,d1.w)

loc_132DE:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_132EE
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_132EE:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   loc_1331C
                bsr.w   Animate_Tails2P
                bsr.w   Tails2P_Load_PLC

loc_1331C:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_1332C
                jsr     (TouchResponse_CompetitionMode).l

locret_1332C:
                rts
; ---------------------------------------------------------------------------
off_1332E:
                dc.w    loc_13336-off_1332E
                dc.w    loc_1335A-off_1332E
                dc.w    loc_1346A-off_1332E
                dc.w    loc_1348C-off_1332E
; ---------------------------------------------------------------------------

loc_13336:
                bsr.w   sub_13520
                bsr.w   Tails_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Tails_InputAcceleration_Path
                bsr.w   sub_134BA
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_1335A:
                tst.b   double_jump_flag(a0)
                bne.s   loc_1338E
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_1337C
                subi.w  #$28,y_vel(a0)

loc_1337C:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

loc_1338E:
                bsr.w   sub_133AE
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite2).l
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

sub_133AE:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   loc_133C2
                tst.b   double_jump_property(a0)
                beq.s   loc_133C2
                subq.b  #1,double_jump_property(a0)

loc_133C2:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   loc_133EC
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_133E4
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   loc_133EA

loc_133E4:
                move.b  #1,double_jump_flag(a0)

loc_133EA:
                bra.s   loc_1341E
; ---------------------------------------------------------------------------

loc_133EC:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_13418
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_13418
                tst.b   double_jump_property(a0)
                beq.s   loc_13418
                btst    #Status_Underwater,status(a0)
                beq.s   loc_13412
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_13418

loc_13412:
                move.b  #2,double_jump_flag(a0)

loc_13418:
                addi.w  #8,y_vel(a0)

loc_1341E:
                move.w  (Camera_min_Y_pos).w,d0
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_13438
                tst.w   y_vel(a0)
                bpl.s   loc_13438
                move.w  #0,y_vel(a0)

loc_13438:
                tst.b   double_jump_property(a0)
                bne.s   loc_13454
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_13452
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

locret_13452:
                rts
; ---------------------------------------------------------------------------

loc_13454:
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_13468
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

locret_13468:
                rts
; End of function sub_133AE

; ---------------------------------------------------------------------------

loc_1346A:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_13474
                bsr.w   Tails_Jump

loc_13474:
                bsr.w   Player_RollRepel
                bsr.w   Tails_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_1348C:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_134A8
                subi.w  #$28,y_vel(a0)

loc_134A8:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

sub_134BA:
                tst.b   status_secondary(a0)
                bmi.s   locret_134E0
                move.w  ground_vel(a0),d0
                bpl.s   loc_134C8
                neg.w   d0

loc_134C8:
                cmpi.w  #$80,d0
                blo.s   locret_134E0
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   locret_134E0
                btst    #button_down,(Ctrl_2_held_logical).w
                bne.s   loc_134E2

locret_134E0:
                rts
; ---------------------------------------------------------------------------

loc_134E2:
                btst    #Status_Roll,status(a0)
                beq.s   loc_134EC
                rts
; ---------------------------------------------------------------------------

loc_134EC:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   locret_1351E
                move.w  #$200,ground_vel(a0)

locret_1351E:
                rts
; End of function sub_134BA

; =============== S U B R O U T I N E =======================================

sub_13520:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_13570
                cmpi.b  #8,anim(a0)
                bne.s   locret_1356E
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_1356E
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_13566
                move.b  #2,anim(a6)

loc_13566:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos

locret_1356E:
                rts
; ---------------------------------------------------------------------------

loc_13570:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_13600
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_135EE(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_135C8
                lea     (H_scroll_frame_offset_P2).w,a1

loc_135C8:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_135D6
                neg.w   ground_vel(a0)

loc_135D6:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_13648
; ---------------------------------------------------------------------------
word_135EE:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
; ---------------------------------------------------------------------------

loc_13600:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_13618
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_13618
                move.w  #0,spin_dash_counter(a0)

loc_13618:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_13648
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_13648
                move.w  #$800,spin_dash_counter(a0)

loc_13648:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_13656
                bcc.s   loc_13654
                addq.w  #4,(a5)

loc_13654:
                subq.w  #2,(a5)

loc_13656:
                bsr.w   Player_AnglePos
                rts
; End of function sub_13520

; ---------------------------------------------------------------------------

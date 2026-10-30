; Owner: objects/players/tails/s3
; Responsibility: Competition Tails object dispatch, active control, flying and two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Tails2P:
                cmpa.w  #Player_1,a0
                bne.s   loc_13E86
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_13E7A
                bchg    #3,render_flags(a0)

loc_13E7A:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_13EA2
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

loc_13E86:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_13EA2
                bchg    #4,render_flags(a0)

loc_13EA2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tails2P_Index(pc,d0.w),d1
                jmp     Tails2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Tails2P_Index:
                dc.w    loc_13EBC-Tails2P_Index
                dc.w    loc_13FCA-Tails2P_Index
                dc.w    loc_1620A-Tails2P_Index
                dc.w    loc_162C4-Tails2P_Index
                dc.w    loc_162F4-Tails2P_Index
                dc.w    loc_16308-Tails2P_Index
; ---------------------------------------------------------------------------

loc_13EBC:
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
                bne.w   loc_13FA6
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_13F6E
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_13F48
                ori.w   #high_priority,art_tile(a0)

loc_13F48:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails_2P).w
                move.w  a0,(Tails_tails_2P+$30).w
                bra.s   loc_13FA6
; ---------------------------------------------------------------------------

loc_13F6E:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_13F82
                ori.w   #high_priority,art_tile(a0)

loc_13F82:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w

loc_13FA6:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #30,air_left(a0)
                move.w  #0,(Tails_CPU_routine).w
                move.w  #10*60,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w

loc_13FCA:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_13FEA
                cmpa.w  #Player_1,a0
                bne.s   loc_13FEA
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_13FEA
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_13FEA:
                cmpa.w  #Player_1,a0
                bne.s   loc_1400A
                move.w  (Ctrl_1_logical).w,(Ctrl_2_logical).w
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_14016
                move.w  (Ctrl_1).w,(Ctrl_2_logical).w
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   loc_14016
; ---------------------------------------------------------------------------

loc_1400A:
                tst.b   (Ctrl_2_locked).w
                bne.s   loc_14016
                move.w  (Ctrl_2).w,(Ctrl_2_logical).w

loc_14016:
                bsr.w   Tails_Display
                btst    #0,object_control(a0)
                bne.s   loc_14034
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  off_14084(pc,d0.w),d1
                jsr     off_14084(pc,d1.w)

loc_14034:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_14044
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_14044:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   loc_14072
                bsr.w   Animate_Tails2P
                bsr.w   Tails2P_Load_PLC

loc_14072:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_14082
                jsr     (TouchResponse_CompetitionMode).l

locret_14082:
                rts
; ---------------------------------------------------------------------------
off_14084:
                dc.w    loc_1408C-off_14084
                dc.w    loc_140B0-off_14084
                dc.w    loc_141C0-off_14084
                dc.w    loc_141E2-off_14084
; ---------------------------------------------------------------------------

loc_1408C:
                bsr.w   sub_14276
                bsr.w   Tails_Jump
                bsr.w   Tails_SlopeResist
                bsr.w   Tails_InputAcceleration_Path
                bsr.w   sub_14210
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_140B0:
                tst.b   double_jump_flag(a0)
                bne.s   loc_140E4
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_140D2
                subi.w  #$28,y_vel(a0)

loc_140D2:
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

loc_140E4:
                bsr.w   sub_14104
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite2).l
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

sub_14104:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   loc_14118
                tst.b   double_jump_property(a0)
                beq.s   loc_14118
                subq.b  #1,double_jump_property(a0)

loc_14118:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   loc_14142
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_1413A
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   loc_14140

loc_1413A:
                move.b  #1,double_jump_flag(a0)

loc_14140:
                bra.s   loc_14174
; ---------------------------------------------------------------------------

loc_14142:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_1416E
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_1416E
                tst.b   double_jump_property(a0)
                beq.s   loc_1416E
                btst    #Status_Underwater,status(a0)
                beq.s   loc_14168
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_1416E

loc_14168:
                move.b  #2,double_jump_flag(a0)

loc_1416E:
                addi.w  #8,y_vel(a0)

loc_14174:
                move.w  (Camera_min_Y_pos).w,d0
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_1418E
                tst.w   y_vel(a0)
                bpl.s   loc_1418E
                move.w  #0,y_vel(a0)

loc_1418E:
                tst.b   double_jump_property(a0)
                bne.s   loc_141AA
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_141A8
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

locret_141A8:
                rts
; ---------------------------------------------------------------------------

loc_141AA:
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_141BE
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

locret_141BE:
                rts
; End of function sub_14104

; ---------------------------------------------------------------------------

loc_141C0:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_141CA
                bsr.w   Tails_Jump

loc_141CA:
                bsr.w   Tails_RollRepel
                bsr.w   Tails_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_141E2:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_141FE
                subi.w  #$28,y_vel(a0)

loc_141FE:
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

sub_14210:
                tst.b   status_secondary(a0)
                bmi.s   locret_14236
                move.w  ground_vel(a0),d0
                bpl.s   loc_1421E
                neg.w   d0

loc_1421E:
                cmpi.w  #$80,d0
                bcs.s   locret_14236
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   locret_14236
                btst    #button_down,(Ctrl_2_held_logical).w
                bne.s   loc_14238

locret_14236:
                rts
; ---------------------------------------------------------------------------

loc_14238:
                btst    #Status_Roll,status(a0)
                beq.s   loc_14242
                rts
; ---------------------------------------------------------------------------

loc_14242:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   locret_14274
                move.w  #$200,ground_vel(a0)

locret_14274:
                rts
; End of function sub_14210

; =============== S U B R O U T I N E =======================================

sub_14276:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_142C6
                cmpi.b  #8,anim(a0)
                bne.s   locret_142C4
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_142C4
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_142BC
                move.b  #2,anim(a6)

loc_142BC:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos

locret_142C4:
                rts
; ---------------------------------------------------------------------------

loc_142C6:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_14356
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_14344(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_1431E
                lea     (H_scroll_frame_offset_P2).w,a1

loc_1431E:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_1432C
                neg.w   ground_vel(a0)

loc_1432C:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_1439E
; ---------------------------------------------------------------------------
word_14344:
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

loc_14356:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_1436E
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_1436E
                move.w  #0,spin_dash_counter(a0)

loc_1436E:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_1439E
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_1439E
                move.w  #$800,spin_dash_counter(a0)

loc_1439E:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_143AC
                bcc.s   loc_143AA
                addq.w  #4,(a5)

loc_143AA:
                subq.w  #2,(a5)

loc_143AC:
                bsr.w   Player_AnglePos
                rts
; End of function sub_14276

; ---------------------------------------------------------------------------

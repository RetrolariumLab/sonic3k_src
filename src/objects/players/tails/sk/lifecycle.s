; Owner: objects/players/tails/sk
; Responsibility: Tails object dispatch, initialization, active player control, timed powers and normal display state
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Tails:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                cmpi.w  #2,(Player_mode).w
                bne.s   Tails_Normal
                tst.w   (Debug_placement_mode).w
                beq.s   Tails_Normal
                cmpi.b  #1,(Debug_placement_type).w
                beq.s   loc_136A8
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_1368C
                move.w  #0,(Debug_placement_mode).w

loc_1368C:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #$FB,mapping_frame(a0)
                blo.s   loc_1369E
                move.b  #0,mapping_frame(a0)

loc_1369E:
                bsr.w   Tails_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_136A8:
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

Tails_Normal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tails_Index(pc,d0.w),d1
                jmp     Tails_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Tails_Index:
                dc.w    Tails_Init-Tails_Index
                dc.w    Tails_Control-Tails_Index
                dc.w    loc_1569C-Tails_Index
                dc.w    loc_1578E-Tails_Index
                dc.w    loc_157E0-Tails_Index
                dc.w    loc_157F4-Tails_Index
                dc.w    loc_15810-Tails_Index
; ---------------------------------------------------------------------------

Tails_Init:
                addq.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #$F,default_y_radius(a0)
                move.b  #9,default_x_radius(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$84,render_flags(a0)
                move.b  #1,character_id(a0)
                move.w  #$600,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$C,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$80,Deceleration_P2-Max_speed_P2(a4)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_1375E
                tst.b   (Last_star_post_hit).w
                bne.s   Tails_Init_Continued
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpi.b  #2,(Special_bonus_entry_flag).w
                beq.s   Tails_Init_Continued
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   Tails_Init_Continued
; ---------------------------------------------------------------------------

loc_1375E:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  (Player_1+top_solid_bit).w,top_solid_bit(a0)
                tst.w   (Player_1+art_tile).w
                bpl.s   Tails_Init_Continued
                ori.w   #high_priority,art_tile(a0)

Tails_Init_Continued:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Tails_flag).w
                move.b  #30,air_left(a0)
                cmpi.w  #$20,(Tails_CPU_routine).w
                beq.s   loc_137A4
                cmpi.w  #$12,(Tails_CPU_routine).w
                beq.s   loc_137A4
                move.w  #0,(Tails_CPU_routine).w

loc_137A4:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.l  #Obj_Tails_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w
                move.b  (Last_star_post_hit).w,(Tails_CPU_star_post_flag).w
                rts
; ---------------------------------------------------------------------------

Tails_Control:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_13808
                tst.w   (Debug_mode_flag).w
                beq.s   loc_13808
                bclr    #button_A,(Ctrl_1_pressed).w
                beq.s   loc_137E0
                eori.b  #1,(Reverse_gravity_flag).w

loc_137E0:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_13808
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                btst    #button_C,(Ctrl_1_held).w
                beq.s   locret_13806
                move.w  #2,(Debug_placement_mode).w
                move.b  #0,anim(a0)

locret_13806:
                rts
; ---------------------------------------------------------------------------

loc_13808:
                cmpa.w  #Player_1,a0
                bne.s   loc_13830
                move.w  (Ctrl_1_logical).w,(Ctrl_2_logical).w
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_1384A
                move.w  (Ctrl_1).w,(Ctrl_2_logical).w
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                cmpi.w  #$1A,(Tails_CPU_routine).w
                bhs.s   loc_13840
                bra.s   loc_1384A
; ---------------------------------------------------------------------------

loc_13830:
                tst.b   (Ctrl_2_locked).w
                beq.s   loc_1383A
                bpl.s   loc_13840
                bra.s   loc_1384A
; ---------------------------------------------------------------------------

loc_1383A:
                move.w  (Ctrl_2).w,(Ctrl_2_logical).w

loc_13840:
                tst.w   (Competition_mode).w
                bne.s   loc_1384A
                bsr.w   Tails_CPU_Control

loc_1384A:
                btst    #0,object_control(a0)
                beq.s   loc_13872
                move.b  #0,double_jump_flag(a0)
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_1388C
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w
                bra.s   loc_1388C
; ---------------------------------------------------------------------------

loc_13872:
                movem.l a4-a6,-(sp)
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  Tails_Modes(pc,d0.w),d1
                jsr     Tails_Modes(pc,d1.w)
                movem.l (sp)+,a4-a6

loc_1388C:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_1389C
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_1389C:
                bsr.s   Tails_Display
                bsr.w   Tails_Super
                bsr.w   Sonic_RecordPos
                bsr.w   Tails_Water
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                tst.b   (WindTunnel_flag_P2).w
                beq.s   loc_138C8
                tst.b   anim(a0)
                bne.s   loc_138C8
                move.b  prev_anim(a0),anim(a0)

loc_138C8:
                btst    #1,object_control(a0)
                bne.s   loc_138E4
                bsr.w   Animate_Tails
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_138E0
                eori.b  #2,render_flags(a0)

loc_138E0:
                bsr.w   Tails_Load_PLC

loc_138E4:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_138F4
                jsr     (TouchResponse).l

locret_138F4:
                rts
; ---------------------------------------------------------------------------
Tails_Modes:
                dc.w    Tails_Stand_Path-Tails_Modes
                dc.w    Tails_Stand_Freespace-Tails_Modes
                dc.w    Tails_Spin_Path-Tails_Modes
                dc.w    Tails_Spin_Freespace-Tails_Modes
; ---------------------------------------------------------------------------

Tails_Display:
                move.b  invulnerability_timer(a0),d0
                beq.s   loc_1390C
                subq.b  #1,invulnerability_timer(a0)
                lsr.b   #3,d0
                bcc.s   loc_13912

loc_1390C:
                jsr     (Draw_Sprite).l

loc_13912:
                btst    #Status_Invincible,status_secondary(a0)
                beq.s   loc_1394E
                tst.b   invincibility_timer(a0)
                beq.s   loc_1394E
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_1394E
                subq.b  #1,invincibility_timer(a0)
                bne.s   loc_1394E
                tst.b   (Boss_flag).w
                bne.s   loc_13948
                cmpi.b  #12,air_left(a0)
                blo.s   loc_13948
                move.w  (Current_music).w,d0
                jsr     (Play_Music).l

loc_13948:
                bclr    #Status_Invincible,status_secondary(a0)

loc_1394E:
                btst    #Status_SpeedShoes,status_secondary(a0)
                beq.s   locret_139A6
                tst.b   speed_shoes_timer(a0)
                beq.s   locret_139A6
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   locret_139A6
                subq.b  #1,speed_shoes_timer(a0)
                bne.s   locret_139A6
                tst.w   (Competition_mode).w
                bne.s   loc_139A8
                move.w  #$600,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$C,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$80,Deceleration_P2-Max_speed_P2(a4)
                tst.b   (Super_Tails_flag).w
                beq.s   loc_13998
                move.w  #$800,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$18,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$C0,Deceleration_P2-Max_speed_P2(a4)

loc_13998:
                bclr    #Status_SpeedShoes,status_secondary(a0)
                moveq   #0,d0
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

locret_139A6:
                rts
; ---------------------------------------------------------------------------

loc_139A8:
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed_P2-Max_speed_P2(a4)
                move.w  (a1)+,Acceleration_P2-Max_speed_P2(a4)
                move.w  (a1)+,Deceleration_P2-Max_speed_P2(a4)
                bclr    #Status_SpeedShoes,status_secondary(a0)
                rts

; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles object dispatch, initialization, active control, timed powers and display state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Knuckles:
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                tst.w   (Debug_placement_mode).w
                beq.s   Knuckles_Normal
                cmpi.b  #1,(Debug_placement_type).w
                beq.s   loc_16488
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_1646C
                move.w  #0,(Debug_placement_mode).w

loc_1646C:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #$FB,mapping_frame(a0)
                blo.s   loc_1647E
                move.b  #0,mapping_frame(a0)

loc_1647E:
                bsr.w   Knuckles_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_16488:
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

Knuckles_Normal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Knuckles_Index(pc,d0.w),d1
                jmp     Knuckles_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Knuckles_Index:
                dc.w    Knuckles_Init-Knuckles_Index
                dc.w    Knuckles_Control-Knuckles_Index
                dc.w    loc_17BB6-Knuckles_Index
                dc.w    loc_17C88-Knuckles_Index
                dc.w    loc_17CBA-Knuckles_Index
                dc.w    loc_17CCE-Knuckles_Index
                dc.w    loc_17CEA-Knuckles_Index
; ---------------------------------------------------------------------------

Knuckles_Init:
                addq.b  #2,routine(a0)
                move.b  #$13,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #$13,default_y_radius(a0)
                move.b  #9,default_x_radius(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #2,character_id(a0)
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Last_star_post_hit).w
                bne.s   Knuckles_Init_Continued
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpi.b  #2,(Special_bonus_entry_flag).w
                beq.s   Knuckles_Init_Continued
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w

Knuckles_Init_Continued:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                subi.w  #$20,x_pos(a0)
                addi.w  #4,y_pos(a0)
                jsr     (Reset_Player_Position_Array).l
                addi.w  #$20,x_pos(a0)
                subi.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Knuckles_Control:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_165A2
                bclr    #button_A,(Ctrl_1_pressed).w
                beq.s   loc_16580
                eori.b  #1,(Reverse_gravity_flag).w

loc_16580:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_165A2
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                btst    #button_C,(Ctrl_1_held).w
                beq.s   locret_165A0
                move.w  #2,(Debug_placement_mode).w

locret_165A0:
                rts
; ---------------------------------------------------------------------------

loc_165A2:
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_165AE
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w

loc_165AE:
                btst    #0,object_control(a0)
                beq.s   loc_165BE
                move.b  #0,double_jump_flag(a0)
                bra.s   loc_165D8
; ---------------------------------------------------------------------------

loc_165BE:
                movem.l a4-a6,-(sp)
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  Knux_Modes(pc,d0.w),d1
                jsr     Knux_Modes(pc,d1.w)
                movem.l (sp)+,a4-a6

loc_165D8:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_165E8
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_165E8:
                bsr.s   Knuckles_Display
                bsr.w   SonicKnux_SuperHyper
                bsr.w   Sonic_RecordPos
                bsr.w   Knuckles_Water
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                tst.b   (WindTunnel_flag).w
                beq.s   loc_16614
                tst.b   anim(a0)
                bne.s   loc_16614
                move.b  prev_anim(a0),anim(a0)

loc_16614:
                btst    #1,object_control(a0)
                bne.s   loc_16630
                bsr.w   Animate_Knuckles
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1662C
                eori.b  #2,render_flags(a0)

loc_1662C:
                bsr.w   Knuckles_Load_PLC

loc_16630:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_16640
                jsr     (TouchResponse).l

locret_16640:
                rts
; ---------------------------------------------------------------------------
Knux_Modes:
                dc.w    Knux_Stand_Path-Knux_Modes
                dc.w    Knux_Stand_Freespace-Knux_Modes
                dc.w    Knux_Spin_Path-Knux_Modes
                dc.w    Knux_Spin_Freespace-Knux_Modes

; =============== S U B R O U T I N E =======================================

Knuckles_Display:
                move.b  invulnerability_timer(a0),d0
                beq.s   loc_16658
                subq.b  #1,invulnerability_timer(a0)
                lsr.b   #3,d0
                bcc.s   loc_1665E

loc_16658:
                jsr     (Draw_Sprite).l

loc_1665E:
                btst    #Status_Invincible,status_secondary(a0)
                beq.s   loc_1669A
                tst.b   invincibility_timer(a0)
                beq.s   loc_1669A
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_1669A
                subq.b  #1,invincibility_timer(a0)
                bne.s   loc_1669A
                tst.b   (Boss_flag).w
                bne.s   loc_16694
                cmpi.b  #12,air_left(a0)
                blo.s   loc_16694
                move.w  (Current_music).w,d0
                jsr     (Play_Music).l

loc_16694:
                bclr    #Status_Invincible,status_secondary(a0)

loc_1669A:
                btst    #Status_SpeedShoes,status_secondary(a0)
                beq.s   locret_166EC
                tst.b   speed_shoes_timer(a0)
                beq.s   locret_166EC
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   locret_166EC
                subq.b  #1,speed_shoes_timer(a0)
                bne.s   locret_166EC
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_166DE
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

loc_166DE:
                bclr    #Status_SpeedShoes,status_secondary(a0)
                moveq   #0,d0
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

locret_166EC:
                rts
; End of function Knuckles_Display

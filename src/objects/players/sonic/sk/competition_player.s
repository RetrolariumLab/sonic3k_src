; Owner: objects/players/sonic/sk
; Responsibility: Competition Sonic object dispatch, player initialization and shared two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic2P:
                cmpa.w  #Player_1,a0
                bne.s   loc_105F2
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_105E6
                bchg    #3,render_flags(a0)

loc_105E6:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_1060E
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

loc_105F2:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_1060E
                bchg    #4,render_flags(a0)

loc_1060E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic2P_Index(pc,d0.w),d1
                jmp     Sonic2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic2P_Index:
                dc.w    loc_10628-Sonic2P_Index
                dc.w    loc_10740-Sonic2P_Index
                dc.w    loc_122BE-Sonic2P_Index
                dc.w    loc_12390-Sonic2P_Index
                dc.w    loc_1257C-Sonic2P_Index
                dc.w    loc_12590-Sonic2P_Index
; ---------------------------------------------------------------------------

loc_10628:
                addq.b  #2,routine(a0)
                move.b  #$B,y_radius(a0)
                move.b  #5,x_radius(a0)
                move.b  #$B,default_y_radius(a0)
                move.b  #5,default_x_radius(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #4,render_flags(a0)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed-Max_speed(a4)
                move.w  (a1)+,Acceleration-Max_speed(a4)
                move.w  (a1)+,Deceleration-Max_speed(a4)
                tst.b   (Last_star_post_hit).w
                bne.w   loc_10724
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_106DC
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   loc_106B4
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

loc_106B4:
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_106C2
                ori.w   #high_priority,art_tile(a0)

loc_106C2:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   loc_10724
; ---------------------------------------------------------------------------

loc_106DC:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   loc_106FE
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

loc_106FE:
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_1070C
                ori.w   #high_priority,art_tile(a0)

loc_1070C:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w

loc_10724:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                bsr.w   Reset_Player_Position_Array

loc_10740:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_10760
                cmpa.w  #Player_1,a0
                bne.s   loc_10760
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_10760
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_10760:
                cmpa.w  #Player_1,a0
                bne.s   loc_10774
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_10780
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   loc_10780
; ---------------------------------------------------------------------------

loc_10774:
                tst.b   (Ctrl_2_locked).w
                bne.s   loc_10780
                move.w  (Ctrl_2).w,(Ctrl_1_logical).w

loc_10780:
                bsr.w   Sonic_Display
                btst    #0,object_control(a0)
                bne.s   loc_1079E
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  off_107EE(pc,d0.w),d1
                jsr     off_107EE(pc,d1.w)

loc_1079E:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_107AE
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_107AE:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   loc_107DC
                bsr.w   Animate_SonicKnuckles_2P
                bsr.w   SonicKnuckles2P_Load_PLC

loc_107DC:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_107EC
                jsr     (TouchResponse_CompetitionMode).l

locret_107EC:
                rts
; ---------------------------------------------------------------------------
off_107EE:
                dc.w    loc_107F6-off_107EE
                dc.w    loc_10868-off_107EE
                dc.w    loc_10896-off_107EE
                dc.w    loc_108B8-off_107EE
; ---------------------------------------------------------------------------

loc_107F6:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   loc_10844
                cmpi.b  #$A,anim(a0)
                beq.s   locret_10866
                cmpi.b  #$B,anim(a0)
                beq.s   locret_10866
                cmpi.b  #5,anim(a0)
                bne.s   loc_10844
                cmpi.b  #$1E,anim_frame(a0)
                blo.s   loc_10844
                bsr.w   Player_SlopeResist
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_1085E
                move.b  #$A,anim(a0)
                cmpi.b  #$AC,anim_frame(a0)
                blo.s   loc_1085E
                move.b  #$B,anim(a0)
                bra.s   loc_1085E
; ---------------------------------------------------------------------------

loc_10844:
                bsr.w   SonicSKHandleCompetitionSpindashAndAbortGroundStep
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicSKTryCompetitionRollFromDown
                jsr     (MoveSprite2).l

loc_1085E:
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel

locret_10866:
                rts
; ---------------------------------------------------------------------------

loc_10868:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_10884
                subi.w  #$28,y_vel(a0)

loc_10884:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

loc_10896:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_108A0
                bsr.w   Sonic_Jump

loc_108A0:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_108B8:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_108D4
                subi.w  #$28,y_vel(a0)

loc_108D4:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

SonicSKTryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   locret_1090C
                move.w  ground_vel(a0),d0
                bpl.s   loc_108F4
                neg.w   d0

loc_108F4:
                cmpi.w  #$80,d0
                blo.s   locret_1090C
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   locret_1090C
                btst    #button_down,(Ctrl_1_held_logical).w
                bne.s   loc_1090E

locret_1090C:
                rts
; ---------------------------------------------------------------------------

loc_1090E:
                btst    #Status_Roll,status(a0)
                beq.s   loc_10918
                rts
; ---------------------------------------------------------------------------

loc_10918:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   locret_1094A
                move.w  #$200,ground_vel(a0)

locret_1094A:
                rts
; End of function SonicSKTryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

SonicSKHandleCompetitionSpindashAndAbortGroundStep:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_10998
                cmpi.b  #8,anim(a0)
                bne.s   locret_10996
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_10996
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_10992
                move.b  #2,anim(a6)

loc_10992:
                bsr.w   Player_AnglePos

locret_10996:
                rts
; ---------------------------------------------------------------------------

loc_10998:
                move.b  (Ctrl_1_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_10A38
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_10A14(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_109F0
                lea     (H_scroll_frame_offset_P2).w,a1

loc_109F0:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_109FE
                neg.w   ground_vel(a0)

loc_109FE:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_10A80
; ---------------------------------------------------------------------------
word_10A14:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
word_10A26:
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
                dc.w    $C80
                dc.w    $D00
                dc.w    $D80
                dc.w    $E00
                dc.w    $E80
                dc.w    $F00
; ---------------------------------------------------------------------------

loc_10A38:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_10A50
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_10A50
                move.w  #0,spin_dash_counter(a0)

loc_10A50:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_10A80
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_10A80
                move.w  #$800,spin_dash_counter(a0)

loc_10A80:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_10A8E
                bcc.s   loc_10A8C
                addq.w  #4,(a5)

loc_10A8C:
                subq.w  #2,(a5)

loc_10A8E:
                bsr.w   Player_AnglePos
                rts
; End of function SonicSKHandleCompetitionSpindashAndAbortGroundStep

; ---------------------------------------------------------------------------

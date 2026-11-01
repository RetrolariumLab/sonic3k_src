; Owner: objects/players/sonic/s3
; Responsibility: Competition Sonic object dispatch, player initialization and shared two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic2P:
                cmpa.w  #Player_1,a0
                bne.s   loc_1170A
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_116FE
                bchg    #3,render_flags(a0)

loc_116FE:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_11726
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

loc_1170A:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   loc_11726
                bchg    #4,render_flags(a0)

loc_11726:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic2P_Index(pc,d0.w),d1
                jmp     Sonic2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic2P_Index:
                dc.w    loc_11740-Sonic2P_Index
                dc.w    loc_11858-Sonic2P_Index
                dc.w    loc_13142-Sonic2P_Index
                dc.w    loc_131FE-Sonic2P_Index
                dc.w    loc_133D4-Sonic2P_Index
                dc.w    loc_133E8-Sonic2P_Index
; ---------------------------------------------------------------------------

loc_11740:
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
                bne.w   loc_1183C
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_117F4
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   loc_117CC
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

loc_117CC:
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_117DA
                ori.w   #high_priority,art_tile(a0)

loc_117DA:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   loc_1183C
; ---------------------------------------------------------------------------

loc_117F4:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   loc_11816
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

loc_11816:
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_11824
                ori.w   #high_priority,art_tile(a0)

loc_11824:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w

loc_1183C:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                bsr.w   Reset_Player_Position_Array

loc_11858:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_11878
                cmpa.w  #Player_1,a0
                bne.s   loc_11878
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_11878
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_11878:
                cmpa.w  #Player_1,a0
                bne.s   loc_1188C
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_11898
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   loc_11898
; ---------------------------------------------------------------------------

loc_1188C:
                tst.b   (Ctrl_2_locked).w
                bne.s   loc_11898
                move.w  (Ctrl_2).w,(Ctrl_1_logical).w

loc_11898:
                bsr.w   Sonic_Display
                btst    #0,object_control(a0)
                bne.s   loc_118B6
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  off_11906(pc,d0.w),d1
                jsr     off_11906(pc,d1.w)

loc_118B6:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_118C6
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_118C6:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   loc_118F4
                bsr.w   Animate_SonicKnuckles_2P
                bsr.w   SonicKnuckles2P_Load_PLC

loc_118F4:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_11904
                jsr     (TouchResponse_CompetitionMode).l

locret_11904:
                rts
; ---------------------------------------------------------------------------
off_11906:
                dc.w    loc_1190E-off_11906
                dc.w    loc_11980-off_11906
                dc.w    loc_119AE-off_11906
                dc.w    loc_119D0-off_11906
; ---------------------------------------------------------------------------

loc_1190E:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   loc_1195C
                cmpi.b  #$A,anim(a0)
                beq.s   locret_1197E
                cmpi.b  #$B,anim(a0)
                beq.s   locret_1197E
                cmpi.b  #5,anim(a0)
                bne.s   loc_1195C
                cmpi.b  #$1E,anim_frame(a0)
                blo.s   loc_1195C
                bsr.w   Player_SlopeResist
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_11976
                move.b  #$A,anim(a0)
                cmpi.b  #$AC,anim_frame(a0)
                blo.s   loc_11976
                move.b  #$B,anim(a0)
                bra.s   loc_11976
; ---------------------------------------------------------------------------

loc_1195C:
                bsr.w   SonicS3HandleCompetitionSpindashAndAbortGroundStep
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicS3TryCompetitionRollFromDown
                jsr     (MoveSprite2).l

loc_11976:
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel

locret_1197E:
                rts
; ---------------------------------------------------------------------------

loc_11980:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_1199C
                subi.w  #$28,y_vel(a0)

loc_1199C:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

loc_119AE:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_119B8
                bsr.w   Sonic_Jump

loc_119B8:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

loc_119D0:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_119EC
                subi.w  #$28,y_vel(a0)

loc_119EC:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

SonicS3TryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   locret_11A24
                move.w  ground_vel(a0),d0
                bpl.s   loc_11A0C
                neg.w   d0

loc_11A0C:
                cmpi.w  #$80,d0
                blo.s   locret_11A24
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   locret_11A24
                btst    #button_down,(Ctrl_1_held_logical).w
                bne.s   loc_11A26

locret_11A24:
                rts
; ---------------------------------------------------------------------------

loc_11A26:
                btst    #2,status(a0)
                beq.s   loc_11A30
                rts
; ---------------------------------------------------------------------------

loc_11A30:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   locret_11A62
                move.w  #$200,ground_vel(a0)

locret_11A62:
                rts
; End of function SonicS3TryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

SonicS3HandleCompetitionSpindashAndAbortGroundStep:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_11AB0
                cmpi.b  #8,anim(a0)
                bne.s   locret_11AAE
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_11AAE
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_11AAA
                move.b  #2,anim(a6)

loc_11AAA:
                bsr.w   Player_AnglePos

locret_11AAE:
                rts
; ---------------------------------------------------------------------------

loc_11AB0:
                move.b  (Ctrl_1_held_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_11B5C
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_11B38(pc,d0.w),ground_vel(a0)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_11AF2
                move.w  word_11B4A(pc,d0.w),ground_vel(a0)

loc_11AF2:
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_11B14
                lea     (H_scroll_frame_offset_P2).w,a1

loc_11B14:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_11B22
                neg.w   ground_vel(a0)

loc_11B22:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_11BA4
; ---------------------------------------------------------------------------
word_11B38:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
word_11B4A:
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

loc_11B5C:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_11B74
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_11B74
                move.w  #0,spin_dash_counter(a0)

loc_11B74:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_11BA4
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_11BA4
                move.w  #$800,spin_dash_counter(a0)

loc_11BA4:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_11BB2
                bcc.s   loc_11BB0
                addq.w  #4,(a5)

loc_11BB0:
                subq.w  #2,(a5)

loc_11BB2:
                bsr.w   Player_AnglePos
                rts
; End of function SonicS3HandleCompetitionSpindashAndAbortGroundStep

; ---------------------------------------------------------------------------

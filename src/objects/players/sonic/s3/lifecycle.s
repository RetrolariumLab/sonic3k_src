; Owner: objects/players/sonic/s3
; Responsibility: Sonic object dispatch, initialization, active control, timed powers and player position history
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic:
; Load some addresses into registers
; This is done to allow some subroutines to be
; shared with Tails/Knuckles
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6

                tst.w   (Debug_placement_mode).w
                beq.s   Sonic_Normal

; Debug only code
                cmpi.b  #1,(Debug_placement_type).w     ; Is Sonic in debug object placement mode?
                beq.s   JmpTo_DebugMode                 ; If so, skip to debug mode routine
; By this point, we're assuming you're in frame cycling mode
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_11BE0
                move.w  #0,(Debug_placement_mode).w     ; Leave debug mode

loc_11BE0:
                addq.b  #1,mapping_frame(a0)            ; Next frame
                cmpi.b  #$D9,mapping_frame(a0)          ; Have we reached the end of Sonic's frames?
                bcs.s   loc_11BF2
                move.b  #0,mapping_frame(a0)            ; If so, reset to Sonic's first frame

loc_11BF2:
                bsr.w   Sonic_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

JmpTo_DebugMode:
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

Sonic_Normal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic_Index(pc,d0.w),d1
                jmp     Sonic_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic_Index:
                dc.w    Sonic_Init-Sonic_Index          ; 0
                dc.w    Sonic_Control-Sonic_Index       ; 2
                dc.w    S3PlayerRecovery_HurtStateFourWithDebugPlacementEscape-Sonic_Index  ; 4
                dc.w    S3PlayerRecovery_DeathStateSixWithDebugPlacementEscape-Sonic_Index  ; 6
                dc.w    S3PlayerRecovery_RestartStateEightCountsNonzeroWordTimerToExactZero-Sonic_Index  ; 8
                dc.w    S3PlayerRecovery_ScrollWaitStateAResumesControlWhenBothGlobalDeltasZero-Sonic_Index  ; $A
                dc.w    S3PlayerRecovery_DrowningStateCWithDebugPlacementEscape-Sonic_Index  ; $C
; ---------------------------------------------------------------------------

Sonic_Init:                                             ; Routine 0
                addq.b  #2,routine(a0)                  ; => Sonic_Control
                move.b  #$13,y_radius(a0)               ; this sets Sonic's collision height (2*pixels)
                move.b  #9,x_radius(a0)
                move.b  #$13,default_y_radius(a0)
                move.b  #9,default_x_radius(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #0,character_id(a0)
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Last_star_post_hit).w
                bne.s   Sonic_Init_Continued
; only happens when not starting at a checkpoint:
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpi.b  #2,(Special_bonus_entry_flag).w
                beq.s   Sonic_Init_Continued
; only happens when not starting at a Special Stage ring:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w

Sonic_Init_Continued:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                subi.w  #$20,x_pos(a0)
                addi.w  #4,y_pos(a0)
                bsr.w   Reset_Player_Position_Array
                addi.w  #$20,x_pos(a0)
                subi.w  #4,y_pos(a0)
                rts

; ---------------------------------------------------------------------------
; Normal state for Sonic
; ---------------------------------------------------------------------------

Sonic_Control:                                          ; Routine 2
                tst.w   (Debug_mode_flag).w             ; is debug cheat enabled?
                beq.s   loc_11D06                       ; if not, branch
                btst    #button_B,(Ctrl_1_pressed).w    ; is button B pressed?
                beq.s   loc_11D06                       ; if not, branch
                move.w  #1,(Debug_placement_mode).w     ; change Sonic into a ring/item
                clr.b   (Ctrl_1_locked).w               ; unlock control
                btst    #button_C,(Ctrl_1_held).w       ; was button C held before pressing B?
                beq.s   locret_11D04                    ; if not, branch
                move.w  #2,(Debug_placement_mode).w     ; enter animation cycle mode

locret_11D04:
                rts
; ---------------------------------------------------------------------------

loc_11D06:
                tst.b   (Ctrl_1_locked).w               ; are controls locked?
                bne.s   loc_11D12                       ; if yes, branch
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w   ; copy new held buttons, to enable joypad control

loc_11D12:
                btst    #0,object_control(a0)           ; is Sonic interacting with another object that holds him in place or controls his movement somehow?
                beq.s   loc_11D22                       ; if yes, branch to skip Sonic's control
                move.b  #0,double_jump_flag(a0)         ; enable double jump
                bra.s   loc_11D3C
; ---------------------------------------------------------------------------

loc_11D22:
                movem.l a4-a6,-(sp)
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  Sonic_Modes(pc,d0.w),d1
                jsr     Sonic_Modes(pc,d1.w)            ; run Sonic's movement control code
                movem.l (sp)+,a4-a6

loc_11D3C:
                cmpi.w  #-$100,(Camera_min_Y_pos).w     ; is vertical wrapping enabled?
                bne.s   loc_11D4C
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)                    ; perform wrapping of Sonic's y position

loc_11D4C:
                bsr.s   Sonic_Display
                bsr.w   Sonic_Super
                bsr.w   Sonic_RecordPos
                bsr.w   Sonic_Water
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                tst.b   (WindTunnel_flag).w
                beq.s   loc_11D78
                tst.b   anim(a0)
                bne.s   loc_11D78
                move.b  prev_anim(a0),anim(a0)

loc_11D78:
                btst    #1,object_control(a0)
                bne.s   loc_11D88
                bsr.w   Animate_Sonic
                bsr.w   Sonic_Load_PLC

loc_11D88:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   locret_11D98
                jsr     (TouchResponse).l

locret_11D98:
                rts
; ---------------------------------------------------------------------------
; secondary states under state Sonic_Control
Sonic_Modes:
                dc.w    Sonic_MdNormal-Sonic_Modes
                dc.w    Sonic_MdAir-Sonic_Modes
                dc.w    Sonic_MdRoll-Sonic_Modes
                dc.w    Sonic_MdJump-Sonic_Modes

; =============== S U B R O U T I N E =======================================

Sonic_Display:
                move.b  invulnerability_timer(a0),d0
                beq.s   loc_11DB0
                subq.b  #1,invulnerability_timer(a0)
                lsr.b   #3,d0
                bcc.s   Sonic_ChkInvin

loc_11DB0:
                jsr     (Draw_Sprite).l

Sonic_ChkInvin:                                         ; Checks if invincibility has expired and disables it if it has
                btst    #Status_Invincible,status_secondary(a0)
                beq.s   Sonic_ChkShoes
                tst.b   invincibility_timer(a0)
                beq.s   Sonic_ChkShoes                  ; If there wasn't any time left, that means we're in Super mode
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   Sonic_ChkShoes
                subq.b  #1,invincibility_timer(a0)      ; reduce invincibility_timer only on every 8th frame
                bne.s   Sonic_ChkShoes                  ; if time is still left, branch
                tst.b   (Boss_flag).w                   ; Don't change music if in a boss fight
                bne.s   Sonic_RmvInvin
                cmpi.b  #12,air_left(a0)                ; Don't change music if drowning
                blo.s   Sonic_RmvInvin
                move.w  (Current_music).w,d0
                jsr     (Play_Music).l                  ; stop playing invincibility theme and resume normal level music

Sonic_RmvInvin:
                bclr    #Status_Invincible,status_secondary(a0)

Sonic_ChkShoes:                                         ; Checks if Speed Shoes have expired and disables them if they have
                btst    #Status_SpeedShoes,status_secondary(a0)  ; does Sonic have speed shoes?
                beq.s   Sonic_ExitChk                   ; if so, branch
                tst.b   speed_shoes_timer(a0)
                beq.s   Sonic_ExitChk
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   Sonic_ExitChk
                subq.b  #1,speed_shoes_timer(a0)        ; reduce speed_shoes_timer only on every 8th frame
                bne.s   Sonic_ExitChk
                tst.w   (Competition_mode).w            ; is this Competition mode?
                bne.s   Sonic_ChkShoesCompetition       ; if so, branch
                move.w  #$600,Max_speed-Max_speed(a4)   ; set Max_speed
                move.w  #$C,Acceleration-Max_speed(a4)  ; set Acceleration
                move.w  #$80,Deceleration-Max_speed(a4)  ; set Deceleration
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_11E3C                       ; if Super, set different values
                move.w  #$A00,Max_speed-Max_speed(a4)   ; set Max_speed
                move.w  #$30,Acceleration-Max_speed(a4)  ; set Acceleration
                move.w  #$100,Deceleration-Max_speed(a4)  ; set Deceleration

loc_11E3C:
                bclr    #Status_SpeedShoes,status_secondary(a0)
                moveq   #0,d0                           ; Slow down tempo
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

Sonic_ExitChk:
                rts
; ---------------------------------------------------------------------------

Sonic_ChkShoesCompetition:
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed-Max_speed(a4)
                move.w  (a1)+,Acceleration-Max_speed(a4)
                move.w  (a1)+,Deceleration-Max_speed(a4)
                bclr    #Status_SpeedShoes,status_secondary(a0)
                rts
; End of function Sonic_Display

; ---------------------------------------------------------------------------
; Subroutine to record Sonic's previous positions for invincibility stars
; and input/status flags for Tails' AI to follow
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_RecordPos:
                tst.w   (Competition_mode).w            ; are we in Competition mode?
                bne.s   Sonic_RecordPosCompetition      ; if so, branch
                cmpa.w  #Player_1,a0                    ; is Sonic the sidekick?
                bne.s   locret_11EA4                    ; if so, branch
                move.w  (Pos_table_index).w,d0
                lea     (Pos_table).w,a1
                lea     (a1,d0.w),a1
                move.w  x_pos(a0),(a1)+                 ; write location to pos_table
                move.w  y_pos(a0),(a1)+
                addq.b  #4,(Pos_table_index+1).w        ; increment index as the post-increments did a1
                lea     (Stat_table).w,a1
                lea     (a1,d0.w),a1
                move.w  (Ctrl_1_logical).w,(a1)+
                move.w  status(a0),(a1)+

locret_11EA4:
                rts
; ---------------------------------------------------------------------------

Sonic_RecordPosCompetition:
                cmpa.w  #Player_1,a0                    ; is object player 1?
                bne.s   Sonic_RecordPosCompetitionP2    ; if not, branch
                move.w  (Pos_table_index).w,d0
                lea     (Pos_table).w,a1
                lea     (a1,d0.w),a1
                move.w  x_pos(a0),(a1)+                 ; write location to pos_table
                move.w  y_pos(a0),(a1)+
                addq.b  #4,(Pos_table_index+1).w        ; increment index as the post-increments did a1
                rts
; ---------------------------------------------------------------------------

Sonic_RecordPosCompetitionP2:
                move.w  (Pos_table_index_P2).w,d0
                lea     (Pos_table_P2).w,a1
                lea     (a1,d0.w),a1
                move.w  x_pos(a0),(a1)+                 ; write location to pos_table
                move.w  y_pos(a0),(a1)+
                addq.b  #4,(Pos_table_index_P2+1).w
                rts                                     ; increment index as the post-increments did a1
; End of function Sonic_RecordPos

; =============== S U B R O U T I N E =======================================

Reset_Player_Position_Array:
                cmpa.w  #Player_1,a0                    ; is object player 1?
                bne.s   Reset_Player_Position_ArrayP2   ; if not, branch
                lea     (Pos_table).w,a1
                lea     (Pos_table_P2).w,a2
                move.w  #bytesToLcnt(Pos_table_end-Pos_table),d0

                .loop:
                move.w  x_pos(a0),(a1)+                 ; write location to pos_table
                move.w  y_pos(a0),(a1)+
                move.l  #0,(a2)+
                dbf     d0,.loop
                move.w  #0,(Pos_table_index).w

Reset_Player_Position_ArrayP2:
                tst.w   (Competition_mode).w            ; are we in Competition mode?
                beq.s   .return                         ; if not, branch
                lea     (Pos_table_P2).w,a1
                move.w  #bytesToLcnt(Pos_table_P2_end-Pos_table_P2),d0

                .loop:
                move.w  x_pos(a0),(a1)+
                move.w  y_pos(a0),(a1)+
                dbf     d0,.loop
                move.w  #0,(Pos_table_index_P2).w

                .return:
                rts
; End of function Reset_Player_Position_Array

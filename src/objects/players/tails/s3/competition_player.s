; Owner: objects/players/tails/s3
; Responsibility: Competition Tails object dispatch, active control, flying and two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Tails2P:
                cmpa.w  #Player_1,a0
                bne.s   S3TailsComp_SelectP2BasesAndViewport
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   S3TailsComp_CheckP1DebugPlacement
                bchg    #3,render_flags(a0)

S3TailsComp_CheckP1DebugPlacement:
                tst.w   (Debug_placement_mode).w
                beq.s   S3TailsComp_DispatchRoutine
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

; Toggle render bit 4 when both players use the same character
S3TailsComp_SelectP2BasesAndViewport:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   S3TailsComp_DispatchRoutine
                bchg    #4,render_flags(a0)

S3TailsComp_DispatchRoutine:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tails2P_Index(pc,d0.w),d1
                jmp     Tails2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Tails2P_Index:
                dc.w    S3TailsComp_InitCompactPlayer-Tails2P_Index
                dc.w    S3TailsComp_CheckP1DebugBPress-Tails2P_Index
                dc.w    S3TailsRecovery_ReleaseRiderOnHurt-Tails2P_Index
                dc.w    S3TailsRecovery_ReleaseRiderOnDeath-Tails2P_Index
                dc.w    S3TailsRecovery_TickRestartTimer-Tails2P_Index
                dc.w    S3TailsRecovery_CheckP2ScrollSettled-Tails2P_Index
; ---------------------------------------------------------------------------

S3TailsComp_InitCompactPlayer:
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
                bne.w   S3TailsComp_ResetAITimersAndRunFrame
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   S3TailsComp_SelectP2ArtAndPriority
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   S3TailsComp_SaveP1RespawnAndBindTail
                ori.w   #high_priority,art_tile(a0)

S3TailsComp_SaveP1RespawnAndBindTail:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails_2P).w
                move.w  a0,(Tails_tails_2P+$30).w
                bra.s   S3TailsComp_ResetAITimersAndRunFrame
; ---------------------------------------------------------------------------

S3TailsComp_SelectP2ArtAndPriority:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   S3TailsComp_SaveP2RespawnAndBindTail
                ori.w   #high_priority,art_tile(a0)

S3TailsComp_SaveP2RespawnAndBindTail:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w
                move.l  #Obj_Tails2P_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w

S3TailsComp_ResetAITimersAndRunFrame:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #30,air_left(a0)
                move.w  #0,(Tails_CPU_routine).w
                move.w  #10*60,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w

S3TailsComp_CheckP1DebugBPress:
                tst.w   (Debug_mode_flag).w
                beq.s   S3TailsComp_CopyP1InputToBothWords
                cmpa.w  #Player_1,a0
                bne.s   S3TailsComp_CopyP1InputToBothWords
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3TailsComp_CopyP1InputToBothWords
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

; When P1 is locked, mirror its current logical word into the Tails input word
S3TailsComp_CopyP1InputToBothWords:
                cmpa.w  #Player_1,a0
                bne.s   S3TailsComp_CopyUnlockedP2Input
                move.w  (Ctrl_1_logical).w,(Ctrl_2_logical).w
                tst.b   (Ctrl_1_locked).w
                bne.s   S3TailsComp_DrawAndCheckMovement
                move.w  (Ctrl_1).w,(Ctrl_2_logical).w
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   S3TailsComp_DrawAndCheckMovement
; ---------------------------------------------------------------------------

S3TailsComp_CopyUnlockedP2Input:
                tst.b   (Ctrl_2_locked).w
                bne.s   S3TailsComp_DrawAndCheckMovement
                move.w  (Ctrl_2).w,(Ctrl_2_logical).w

S3TailsComp_DrawAndCheckMovement:
                bsr.w   Tails_Display
                btst    #0,object_control(a0)
                bne.s   S3TailsComp_WrapPlayerYIfEnabled
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  S3TailsComp_MovementModeOffsets(pc,d0.w),d1
                jsr     S3TailsComp_MovementModeOffsets(pc,d1.w)

S3TailsComp_WrapPlayerYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3TailsComp_WrapXAndUpdateFrame
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

; Add $400 to integer X after masking. Object control bit 1 suppresses animation and pattern loading
S3TailsComp_WrapXAndUpdateFrame:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   S3TailsComp_CheckTouchResponse
                bsr.w   Animate_Tails2P
                bsr.w   Tails2P_Load_PLC

S3TailsComp_CheckTouchResponse:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   S3TailsComp_FrameReturn
                jsr     (TouchResponse_CompetitionMode).l

S3TailsComp_FrameReturn:
                rts
; ---------------------------------------------------------------------------
S3TailsComp_MovementModeOffsets:
                dc.w    S3TailsComp_RunGroundMovement-S3TailsComp_MovementModeOffsets
                dc.w    S3TailsComp_RunAirOrFlightMovement-S3TailsComp_MovementModeOffsets
                dc.w    S3TailsComp_TryGroundRollJump-S3TailsComp_MovementModeOffsets
                dc.w    S3TailsComp_RunAirRollMovement-S3TailsComp_MovementModeOffsets
; ---------------------------------------------------------------------------

S3TailsComp_RunGroundMovement:
                bsr.w   S3TailsComp_RunSpinDash
                bsr.w   Tails_Jump
                bsr.w   Tails_SlopeResist
                bsr.w   Tails_InputAcceleration_Path
                bsr.w   TailsS3TryCompetitionRollFromDown
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                rts
; ---------------------------------------------------------------------------

S3TailsComp_RunAirOrFlightMovement:
                tst.b   double_jump_flag(a0)
                bne.s   S3TailsComp_RunFlightMovement
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsComp_ResolveAirTerrain
                subi.w  #$28,y_vel(a0)

S3TailsComp_ResolveAirTerrain:
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

S3TailsComp_RunFlightMovement:
                bsr.w   S3TailsComp_UpdateFlight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite2).l
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

; Update stamina, flap state and Y speed, cap ascent at the camera margin and play the normal or tired sound
S3TailsComp_UpdateFlight:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   S3TailsComp_TickFlap
                tst.b   double_jump_property(a0)
                beq.s   S3TailsComp_TickFlap
                subq.b  #1,double_jump_property(a0)

S3TailsComp_TickFlap:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   S3TailsComp_CheckNewFlap
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsComp_ResetFlapToWaiting
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   S3TailsComp_AfterActiveFlap

S3TailsComp_ResetFlapToWaiting:
                move.b  #1,double_jump_flag(a0)

S3TailsComp_AfterActiveFlap:
                bra.s   S3TailsComp_ClampAscentAtCameraTop
; ---------------------------------------------------------------------------

; A new flap needs a fresh press, enough flight budget and Y speed of at least -$100. Underwater carry also blocks it
S3TailsComp_CheckNewFlap:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   S3TailsComp_ApplyWaitingGravity
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsComp_ApplyWaitingGravity
                tst.b   double_jump_property(a0)
                beq.s   S3TailsComp_ApplyWaitingGravity
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsComp_StartFlapCounter
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   S3TailsComp_ApplyWaitingGravity

S3TailsComp_StartFlapCounter:
                move.b  #2,double_jump_flag(a0)

S3TailsComp_ApplyWaitingGravity:
                addi.w  #8,y_vel(a0)

S3TailsComp_ClampAscentAtCameraTop:
                move.w  (Camera_min_Y_pos).w,d0
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                blt.s   S3TailsComp_ChooseFlightSound
                tst.w   y_vel(a0)
                bpl.s   S3TailsComp_ChooseFlightSound
                move.w  #0,y_vel(a0)

S3TailsComp_ChooseFlightSound:
                tst.b   double_jump_property(a0)
                bne.s   S3TailsComp_TryFlightSoundEvery16
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsComp_TiredFlightReturn
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

S3TailsComp_TiredFlightReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsComp_TryFlightSoundEvery16:
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsComp_FlightSoundReturn
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

S3TailsComp_FlightSoundReturn:
                rts
; End of function S3TailsComp_UpdateFlight

; ---------------------------------------------------------------------------

S3TailsComp_TryGroundRollJump:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsComp_RunGroundRoll
                bsr.w   Tails_Jump

S3TailsComp_RunGroundRoll:
                bsr.w   Tails_RollRepel
                bsr.w   Tails_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                rts
; ---------------------------------------------------------------------------

S3TailsComp_RunAirRollMovement:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsComp_ResolveAirRollTerrain
                subi.w  #$28,y_vel(a0)

S3TailsComp_ResolveAirRollTerrain:
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

TailsS3TryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   S3TailsComp_RollEntryReturn
                move.w  ground_vel(a0),d0
                bpl.s   S3TailsComp_CheckRollEntry
                neg.w   d0

S3TailsComp_CheckRollEntry:
                cmpi.w  #$80,d0
                bcs.s   S3TailsComp_RollEntryReturn
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3TailsComp_RollEntryReturn
                btst    #button_down,(Ctrl_2_held_logical).w
                bne.s   S3TailsComp_CheckAlreadyRolling

S3TailsComp_RollEntryReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsComp_CheckAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsComp_InitCompactRoll
                rts
; ---------------------------------------------------------------------------

S3TailsComp_InitCompactRoll:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   S3TailsComp_InitRollReturn
                move.w  #$200,ground_vel(a0)

S3TailsComp_InitRollReturn:
                rts
; End of function TailsS3TryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

; Charging or release can skip the rest of the ground update. Launch uses the camera delay for this player slot
S3TailsComp_RunSpinDash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsComp_ReleaseOrKeepCharging
                cmpi.b  #8,anim(a0)
                bne.s   S3TailsComp_SpinDashEntryReturn
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsComp_SpinDashEntryReturn
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsComp_CheckBoundsAndAttachAtStart
                move.b  #2,anim(a6)

S3TailsComp_CheckBoundsAndAttachAtStart:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos

S3TailsComp_SpinDashEntryReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsComp_ReleaseOrKeepCharging:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   S3TailsComp_DecayHeldCharge
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  S3TailsComp_NormalLaunchSpeeds(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   S3TailsComp_StoreLagAndApplyFacing
                lea     (H_scroll_frame_offset_P2).w,a1

S3TailsComp_StoreLagAndApplyFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsComp_BeginRollAndStopDust
                neg.w   ground_vel(a0)

S3TailsComp_BeginRollAndStopDust:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   S3TailsComp_SkipGroundAndEaseCamera
; ---------------------------------------------------------------------------
S3TailsComp_NormalLaunchSpeeds:
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

S3TailsComp_DecayHeldCharge:
                tst.w   spin_dash_counter(a0)
                beq.s   S3TailsComp_ChargeOnNewPress
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   S3TailsComp_ChargeOnNewPress
                move.w  #0,spin_dash_counter(a0)

S3TailsComp_ChargeOnNewPress:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsComp_SkipGroundAndEaseCamera
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   S3TailsComp_SkipGroundAndEaseCamera
                move.w  #$800,spin_dash_counter(a0)

; Discard the ground movement return address before adjusting the camera
S3TailsComp_SkipGroundAndEaseCamera:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   S3TailsComp_AttachAfterSpinDash
                bcc.s   S3TailsComp_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

S3TailsComp_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

S3TailsComp_AttachAfterSpinDash:
                bsr.w   Player_AnglePos
                rts
; End of function S3TailsComp_RunSpinDash

; ---------------------------------------------------------------------------

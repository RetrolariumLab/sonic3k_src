; Owner: objects/players/sonic/sk
; Responsibility: Competition Sonic object dispatch, player initialization and shared two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic2P:
                cmpa.w  #Player_1,a0
                bne.s   SKSonicComp_SelectP2BasesAndViewport
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   SKSonicComp_CheckP1DebugPlacement
                bchg    #3,render_flags(a0)

SKSonicComp_CheckP1DebugPlacement:
                tst.w   (Debug_placement_mode).w
                beq.s   SKSonicComp_DispatchRoutine
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

; Toggle render bit 4 when both players use the same character
SKSonicComp_SelectP2BasesAndViewport:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   SKSonicComp_DispatchRoutine
                bchg    #4,render_flags(a0)

SKSonicComp_DispatchRoutine:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic2P_Index(pc,d0.w),d1
                jmp     Sonic2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic2P_Index:
                dc.w    SKSonicComp_InitCompactPlayer-Sonic2P_Index
                dc.w    SKSonicComp_CheckP1DebugBPress-Sonic2P_Index
                dc.w    SKRecovery_HurtState4-Sonic2P_Index
                dc.w    SKRecovery_DeathState6-Sonic2P_Index
                dc.w    SKRecovery_RestartState8-Sonic2P_Index
                dc.w    SKRecovery_ScrollWaitStateA-Sonic2P_Index
; ---------------------------------------------------------------------------

SKSonicComp_InitCompactPlayer:
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
                bne.w   SKSonicComp_FinishInitAndSeedHistory
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   SKSonicComp_SelectP2ArtAndMappings
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   SKSonicComp_CheckP1ZonePriority
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

SKSonicComp_CheckP1ZonePriority:
                cmpi.b  #$12,(Current_zone).w
                bne.s   SKSonicComp_SaveP1RespawnState
                ori.w   #high_priority,art_tile(a0)

SKSonicComp_SaveP1RespawnState:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   SKSonicComp_FinishInitAndSeedHistory
; ---------------------------------------------------------------------------

SKSonicComp_SelectP2ArtAndMappings:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   SKSonicComp_CheckP2ZonePriority
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

SKSonicComp_CheckP2ZonePriority:
                cmpi.b  #$12,(Current_zone).w
                bne.s   SKSonicComp_SaveP2RespawnState
                ori.w   #high_priority,art_tile(a0)

SKSonicComp_SaveP2RespawnState:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w

SKSonicComp_FinishInitAndSeedHistory:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                bsr.w   Reset_Player_Position_Array

SKSonicComp_CheckP1DebugBPress:
                tst.w   (Debug_mode_flag).w
                beq.s   SKSonicComp_CopyUnlockedP1Input
                cmpa.w  #Player_1,a0
                bne.s   SKSonicComp_CopyUnlockedP1Input
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKSonicComp_CopyUnlockedP1Input
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKSonicComp_CopyUnlockedP1Input:
                cmpa.w  #Player_1,a0
                bne.s   SKSonicComp_CopyUnlockedP2Input
                tst.b   (Ctrl_1_locked).w
                bne.s   SKSonicComp_DrawAndCheckMovement
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   SKSonicComp_DrawAndCheckMovement
; ---------------------------------------------------------------------------

SKSonicComp_CopyUnlockedP2Input:
                tst.b   (Ctrl_2_locked).w
                bne.s   SKSonicComp_DrawAndCheckMovement
                move.w  (Ctrl_2).w,(Ctrl_1_logical).w

SKSonicComp_DrawAndCheckMovement:
                bsr.w   Sonic_Display
                btst    #0,object_control(a0)
                bne.s   SKSonicComp_WrapPlayerYIfEnabled
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  SKSonicComp_MovementModeOffsets(pc,d0.w),d1
                jsr     SKSonicComp_MovementModeOffsets(pc,d1.w)

; Mask integer Y only when the camera minimum equals -$100
SKSonicComp_WrapPlayerYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKSonicComp_WrapXAndUpdateFrame
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

; Add $400 to integer X after masking. Object control bit 1 suppresses animation and pattern loading
SKSonicComp_WrapXAndUpdateFrame:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   SKSonicComp_CheckTouchResponse
                bsr.w   Animate_SonicKnuckles_2P
                bsr.w   SonicKnuckles2P_Load_PLC

SKSonicComp_CheckTouchResponse:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   SKSonicComp_FrameReturn
                jsr     (TouchResponse_CompetitionMode).l

SKSonicComp_FrameReturn:
                rts
; ---------------------------------------------------------------------------
SKSonicComp_MovementModeOffsets:
                dc.w    SKSonicComp_CheckExtendedIdle-SKSonicComp_MovementModeOffsets
                dc.w    SKSonicComp_RunAirMovement-SKSonicComp_MovementModeOffsets
                dc.w    SKSonicComp_TryGroundRollJump-SKSonicComp_MovementModeOffsets
                dc.w    SKSonicComp_RunAirRollMovement-SKSonicComp_MovementModeOffsets
; ---------------------------------------------------------------------------

; Without a new jump press, animations $A and $B bypass ground movement. Animation 5 checks for frame $1E or later
SKSonicComp_CheckExtendedIdle:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   SKSonicComp_RunGroundMovement
                cmpi.b  #$A,anim(a0)
                beq.s   SKSonicComp_GroundModeReturn
                cmpi.b  #$B,anim(a0)
                beq.s   SKSonicComp_GroundModeReturn
                cmpi.b  #5,anim(a0)
                bne.s   SKSonicComp_RunGroundMovement
                cmpi.b  #$1E,anim_frame(a0)
                blo.s   SKSonicComp_RunGroundMovement
                bsr.w   Player_SlopeResist
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSonicComp_AttachAndApplySlopeRepel
                move.b  #$A,anim(a0)
                cmpi.b  #$AC,anim_frame(a0)
                blo.s   SKSonicComp_AttachAndApplySlopeRepel
                move.b  #$B,anim(a0)
                bra.s   SKSonicComp_AttachAndApplySlopeRepel
; ---------------------------------------------------------------------------

SKSonicComp_RunGroundMovement:
                bsr.w   SonicSKHandleCompetitionSpindashAndAbortGroundStep
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicSKTryCompetitionRollFromDown
                jsr     (MoveSprite2).l

SKSonicComp_AttachAndApplySlopeRepel:
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel

SKSonicComp_GroundModeReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicComp_RunAirMovement:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicComp_ResolveAirTerrain
                subi.w  #$28,y_vel(a0)

SKSonicComp_ResolveAirTerrain:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

SKSonicComp_TryGroundRollJump:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicComp_RunGroundRoll
                bsr.w   Sonic_Jump

SKSonicComp_RunGroundRoll:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

SKSonicComp_RunAirRollMovement:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicComp_ResolveAirRollTerrain
                subi.w  #$28,y_vel(a0)

SKSonicComp_ResolveAirRollTerrain:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

SonicSKTryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   SKSonicComp_RollEntryReturn
                move.w  ground_vel(a0),d0
                bpl.s   SKSonicComp_CheckRollEntry
                neg.w   d0

SKSonicComp_CheckRollEntry:
                cmpi.w  #$80,d0
                blo.s   SKSonicComp_RollEntryReturn
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKSonicComp_RollEntryReturn
                btst    #button_down,(Ctrl_1_held_logical).w
                bne.s   SKSonicComp_CheckAlreadyRolling

SKSonicComp_RollEntryReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicComp_CheckAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   SKSonicComp_InitCompactRoll
                rts
; ---------------------------------------------------------------------------

; Add four pixels to Y on roll entry in both gravity modes
SKSonicComp_InitCompactRoll:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   SKSonicComp_InitRollReturn
                move.w  #$200,ground_vel(a0)

SKSonicComp_InitRollReturn:
                rts
; End of function SonicSKTryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

SonicSKHandleCompetitionSpindashAndAbortGroundStep:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicComp_ReleaseOrKeepCharging
                cmpi.b  #8,anim(a0)
                bne.s   SKSonicComp_SpinDashEntryReturn
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSonicComp_SpinDashEntryReturn
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicComp_AttachAtSpinDashStart
                move.b  #2,anim(a6)

SKSonicComp_AttachAtSpinDashStart:
                bsr.w   Player_AnglePos

SKSonicComp_SpinDashEntryReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicComp_ReleaseOrKeepCharging:
                move.b  (Ctrl_1_logical).w,d0
                btst    #button_down,d0
                bne.w   SKSonicComp_DecayHeldCharge
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  SKSonicComp_NormalLaunchSpeeds(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   SKSonicComp_StoreLagAndApplyFacing
                lea     (H_scroll_frame_offset_P2).w,a1

SKSonicComp_StoreLagAndApplyFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicComp_BeginRollAndStopDust
                neg.w   ground_vel(a0)

SKSonicComp_BeginRollAndStopDust:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   SKSonicComp_SkipGroundAndEaseCamera
; ---------------------------------------------------------------------------
SKSonicComp_NormalLaunchSpeeds:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
SKSonicComp_PoweredLaunchSpeeds:
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

SKSonicComp_DecayHeldCharge:
                tst.w   spin_dash_counter(a0)
                beq.s   SKSonicComp_ChargeOnNewPress
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   SKSonicComp_ChargeOnNewPress
                move.w  #0,spin_dash_counter(a0)

SKSonicComp_ChargeOnNewPress:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSonicComp_SkipGroundAndEaseCamera
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   SKSonicComp_SkipGroundAndEaseCamera
                move.w  #$800,spin_dash_counter(a0)

; Discard the ground movement return address before adjusting the camera
SKSonicComp_SkipGroundAndEaseCamera:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   SKSonicComp_AttachAfterSpinDash
                bcc.s   SKSonicComp_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

SKSonicComp_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

SKSonicComp_AttachAfterSpinDash:
                bsr.w   Player_AnglePos
                rts
; End of function SonicSKHandleCompetitionSpindashAndAbortGroundStep

; ---------------------------------------------------------------------------

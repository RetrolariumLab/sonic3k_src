; Owner: objects/players/tails/sk
; Responsibility: Follower control dispatch, stage-specific initialization, flying catch-up and normal companion navigation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_CPU_Control:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
                beq.s   SKTailsAI_DispatchFollowState
                move.w  #10*60,(Tails_CPU_idle_timer).w

SKTailsAI_DispatchFollowState:
                lea     (Player_1).w,a1
                move.w  (Tails_CPU_routine).w,d0
                move.w  Tails_CPU_Control_Index(pc,d0.w),d0
                jmp     Tails_CPU_Control_Index(pc,d0.w)
; End of function Tails_CPU_Control

; ---------------------------------------------------------------------------
Tails_CPU_Control_Index:
                dc.w    SKTailsAI_InitFromCheckpointOrStage-Tails_CPU_Control_Index
                dc.w    Tails_Catch_Up_Flying-Tails_CPU_Control_Index
                dc.w    Tails_FlySwim_Unknown-Tails_CPU_Control_Index
                dc.w    SKTailsAI_CheckLeaderRoutineForFlight-Tails_CPU_Control_Index
                dc.w    SKTailsScript_CheckIdleSpinDash-Tails_CPU_Control_Index
                dc.w    SKTailsScript_InactiveStateReturn-Tails_CPU_Control_Index
                dc.w    SKTailsScript_StartIntroCarryRight-Tails_CPU_Control_Index
                dc.w    SKTailsScript_PulseIntroCarryRight-Tails_CPU_Control_Index
                dc.w    SKTailsScript_PulsePartnerExitInput-Tails_CPU_Control_Index
                dc.w    SKTailsScript_ClearInputBeforeBossCarry-Tails_CPU_Control_Index
                dc.w    SKTailsScript_StartBossCarry-Tails_CPU_Control_Index
                dc.w    SKTailsScript_PulseBossCarryFlap-Tails_CPU_Control_Index
                dc.w    SKTailsScript_ChooseAutoCarryOrReacquire-Tails_CPU_Control_Index
                dc.w    SKTailsScript_StartSoloBossFlight-Tails_CPU_Control_Index
                dc.w    SKTailsScript_PulseSoloClimbFlap-Tails_CPU_Control_Index
                dc.w    SKTailsScript_RefreshSoloFlightBudget-Tails_CPU_Control_Index
                dc.w    SKTailsScript_StartPrimaryFlyInRight-Tails_CPU_Control_Index
                dc.w    SKTailsScript_PulsePrimaryFlyInRight-Tails_CPU_Control_Index
; ---------------------------------------------------------------------------

SKTailsAI_InitFromCheckpointOrStage:
                tst.b   (Tails_CPU_star_post_flag).w
                bne.w   SKTailsAI_ResetMotionBeforeFollow
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectEarlyStageStart
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_SelectEarlyStageStart:
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowWithOwnControl
                cmpi.w  #$200,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowWithOwnControl
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   SKTailsAI_TryOffscreenStageStart
                move.w  #$18,x_pos(a0)
                move.w  #$600,y_pos(a0)

SKTailsAI_StartStageCarry:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.b  #2,status(a0)
                move.w  #$C,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKTailsAI_TryOffscreenStageStart:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectLaterStageStart
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_SelectLaterStageStart:
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowWithOwnControl
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectLateStageStart
                tst.w   (SK_alone_flag).w
                bne.s   SKTailsAI_SelectLateStageStart
                move.w  #$D8,x_pos(a0)
                move.w  #$500,y_pos(a0)
                bra.s   SKTailsAI_StartStageCarry
; ---------------------------------------------------------------------------

SKTailsAI_SelectLateStageStart:
                cmpi.w  #$800,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowKeepControl
                cmpi.w  #$900,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowWithOwnControl
                cmpi.w  #$A00,(Current_zone_and_act).w
                bne.s   SKTailsAI_ChooseLateStageControl
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_ChooseLateStageControl:
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartFollowWithOwnControl
                cmpi.b  #$17,(Current_zone).w
                beq.s   SKTailsAI_StartFollowKeepControl

SKTailsAI_ResetMotionBeforeFollow:
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #0,status(a0)

SKTailsAI_StartFollowWithOwnControl:
                move.b  #0,object_control(a0)

SKTailsAI_StartFollowKeepControl:
                move.w  #6,(Tails_CPU_routine).w
                move.w  #0,(Tails_CPU_flight_timer).w
                rts
; ---------------------------------------------------------------------------

Tails_Catch_Up_Flying:
                move.b  (Ctrl_2_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   SKTailsAI_SpawnFlightAtLeader
                move.w  (Level_frame_counter).w,d0
                andi.w  #$3F,d0
                bne.w   SKTailsAI_FlightSpawnReturn
                tst.b   object_control(a1)
                bmi.w   SKTailsAI_FlightSpawnReturn
                move.b  status(a1),d0
                andi.b  #$80,d0
                bne.w   SKTailsAI_FlightSpawnReturn

SKTailsAI_SpawnFlightAtLeader:
                move.w  #4,(Tails_CPU_routine).w
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  d0,(Tails_CPU_target_X).w
                move.w  y_pos(a1),d0
                move.w  d0,(Tails_CPU_target_Y).w
                subi.w  #$C0,d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsAI_ApplySpawnYAndResetFlight
                addi.w  #2*$C0,d0

SKTailsAI_ApplySpawnYAndResetFlight:
                move.w  d0,y_pos(a0)
                ori.w   #high_priority,art_tile(a0)
                move.w  #$100,priority(a0)
                moveq   #0,d0
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,flip_type(a0)
                move.b  d0,double_jump_flag(a0)
                move.b  #2,status(a0)
                move.b  #30,air_left(a0)
                move.b  #$81,object_control(a0)
                move.b  d0,flips_remaining(a0)
                move.b  d0,flip_speed(a0)
                move.w  d0,move_lock(a0)
                move.b  d0,invulnerability_timer(a0)
                move.b  d0,invincibility_timer(a0)
                move.b  d0,speed_shoes_timer(a0)
                move.b  d0,status_tertiary(a0)
                move.b  d0,scroll_delay_counter(a0)
                move.w  d0,next_tilt(a0)                ; and tilt
                move.b  d0,stick_to_convex(a0)
                move.b  d0,spin_dash_flag(a0)
                move.b  d0,spin_dash_flag(a0)
                move.w  d0,spin_dash_counter(a0)
                move.b  d0,jumping(a0)
                move.b  d0,$41(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

SKTailsAI_FlightSpawnReturn:
                rts
; ---------------------------------------------------------------------------

Tails_FlySwim_Unknown:
                tst.b   render_flags(a0)
                bmi.s   SKTailsAI_RefreshVisibleFlight
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   SKTailsAI_ReadFlightTargetFromHistory
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation
                rts
; ---------------------------------------------------------------------------

SKTailsAI_RefreshVisibleFlight:
                move.b  #(8*60)/2,double_jump_property(a0)
                ori.b   #1<<Status_InAir,status(a0)
                bsr.w   Tails_Set_Flying_Animation
                move.w  #0,(Tails_CPU_flight_timer).w

SKTailsAI_ReadFlightTargetFromHistory:
                lea     (Pos_table).w,a2
                move.w  #$10,d2
                lsl.b   #2,d2
                addq.b  #4,d2
                move.w  (Pos_table_index).w,d3
                sub.b   d2,d3
                move.w  (a2,d3.w),(Tails_CPU_target_X).w
                move.w  2(a2,d3.w),(Tails_CPU_target_Y).w
                move.w  x_pos(a0),d0
                sub.w   (Tails_CPU_target_X).w,d0
                beq.s   SKTailsAI_ChooseFlightYStep1px
                move.w  d0,d2
                bpl.s   SKTailsAI_ScaleAndCapFlightXStep
                neg.w   d2

; Take one sixteenth of the X distance and cap it at 12 before adding the leader's speed
SKTailsAI_ScaleAndCapFlightXStep:
                lsr.w   #4,d2
                cmpi.w  #$C,d2
                blo.s   SKTailsAI_GetLeaderXSpeedHighByte
                moveq   #$C,d2

SKTailsAI_GetLeaderXSpeedHighByte:
                move.b  x_vel(a1),d1
                bpl.s   SKTailsAI_AddLeaderSpeedAndChooseXStep
                neg.b   d1

SKTailsAI_AddLeaderSpeedAndChooseXStep:
                add.b   d1,d2
                addq.w  #1,d2
                tst.w   d0
                bmi.s   SKTailsAI_ApproachFlightTargetToTheRight
                bset    #Status_Facing,status(a0)
                cmp.w   d0,d2
                blo.s   SKTailsAI_NegateFlightXStep
                move.w  d0,d2
                moveq   #0,d0

SKTailsAI_NegateFlightXStep:
                neg.w   d2
                bra.s   SKTailsAI_ApplyFlightXStep
; ---------------------------------------------------------------------------

SKTailsAI_ApproachFlightTargetToTheRight:
                bclr    #Status_Facing,status(a0)
                neg.w   d0
                cmp.w   d0,d2
                blo.s   SKTailsAI_ApplyFlightXStep
                move.b  d0,d2
                moveq   #0,d0

SKTailsAI_ApplyFlightXStep:
                add.w   d2,x_pos(a0)

SKTailsAI_ChooseFlightYStep1px:
                moveq   #1,d2
                move.w  y_pos(a0),d1
                sub.w   (Tails_CPU_target_Y).w,d1
                beq.s   SKTailsAI_CheckFlightHandoff
                bmi.s   SKTailsAI_ApplyFlightVerticalStep
                neg.w   d2

SKTailsAI_ApplyFlightVerticalStep:
                add.w   d2,y_pos(a0)

; Check delayed status bit 7 and require the leader's current routine to be below 6
SKTailsAI_CheckFlightHandoff:
                lea     (Stat_table).w,a2
                move.b  2(a2,d3.w),d2
                andi.b  #$80,d2
                bne.s   SKTailsAI_KeepCatchUpControl
                or.w    d0,d1
                bne.s   SKTailsAI_KeepCatchUpControl
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   SKTailsAI_KeepCatchUpControl
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                andi.b  #1<<Status_Underwater,status(a0)
                ori.b   #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   art_tile(a1)
                bpl.s   SKTailsAI_CopyLeaderSolidityBits
                ori.w   #high_priority,art_tile(a0)

SKTailsAI_CopyLeaderSolidityBits:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_KeepCatchUpControl:
                move.b  #$81,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_CheckLeaderRoutineForFlight:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   SKTailsAI_CheckFollowInputEligibility
                move.w  #4,(Tails_CPU_routine).w
                move.b  #0,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.b  #$20,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_CheckFollowInputEligibility:
                bsr.w   TailsSKWatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsAI_TickManualOverride
                tst.b   object_control(a0)
                bmi.w   SKTailsAI_TickManualOverride
                tst.b   status_tertiary(a1)
                bmi.w   SKTailsAI_TickManualOverride
                tst.w   move_lock(a0)
                beq.s   SKTailsAI_ReadFollowTargetX
                tst.w   ground_vel(a0)
                bne.s   SKTailsAI_ReadFollowTargetX
                move.w  #8,(Tails_CPU_routine).w

SKTailsAI_ReadFollowTargetX:
                lea     (Pos_table).w,a2
                move.w  #$10,d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.w  (a2,d0.w),d2
                btst    #Status_OnObj,status(a1)
                bne.s   SKTailsAI_ReadLeaderInputAndCheckPush
                cmpi.w  #$400,ground_vel(a1)
                bge.s   SKTailsAI_ReadLeaderInputAndCheckPush
                subi.w  #$20,d2

SKTailsAI_ReadLeaderInputAndCheckPush:
                move.w  2(a2,d0.w),d3
                lea     (Stat_table).w,a2
                move.w  (a2,d0.w),d1
                move.b  2(a2,d0.w),d4
                move.w  d1,d0
                btst    #Status_Push,status(a0)
                beq.s   SKTailsAI_ChooseFollowXInput
                btst    #5,d4
                beq.w   SKTailsAI_TryAutoJumpOn64FramePhase

SKTailsAI_ChooseFollowXInput:
                sub.w   x_pos(a0),d2
                beq.s   SKTailsAI_MatchLeaderFacingAtEqualX
                bpl.s   SKTailsAI_SetRightInputIfFar
                neg.w   d2
                cmpi.w  #$30,d2
                blo.s   SKTailsAI_NudgeMovingLeft
                andi.w  #$F3F3,d1
                ori.w   #$404,d1

SKTailsAI_NudgeMovingLeft:
                tst.w   ground_vel(a0)
                beq.s   SKTailsAI_HoldAutoJumpUntilLanding
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsAI_HoldAutoJumpUntilLanding
                btst    #0,object_control(a0)
                bne.s   SKTailsAI_HoldAutoJumpUntilLanding
                subq.w  #1,x_pos(a0)
                bra.s   SKTailsAI_HoldAutoJumpUntilLanding
; ---------------------------------------------------------------------------

SKTailsAI_SetRightInputIfFar:
                cmpi.w  #$30,d2
                blo.s   SKTailsAI_NudgeMovingRight
                andi.w  #$F3F3,d1
                ori.w   #$808,d1

SKTailsAI_NudgeMovingRight:
                tst.w   ground_vel(a0)
                beq.s   SKTailsAI_HoldAutoJumpUntilLanding
                btst    #Status_Facing,status(a0)
                bne.s   SKTailsAI_HoldAutoJumpUntilLanding
                btst    #0,object_control(a0)
                bne.s   SKTailsAI_HoldAutoJumpUntilLanding
                addq.w  #1,x_pos(a0)
                bra.s   SKTailsAI_HoldAutoJumpUntilLanding
; ---------------------------------------------------------------------------

SKTailsAI_MatchLeaderFacingAtEqualX:
                bclr    #Status_Facing,status(a0)
                move.b  d4,d0
                andi.b  #1,d0
                beq.s   SKTailsAI_HoldAutoJumpUntilLanding
                bset    #Status_Facing,status(a0)

SKTailsAI_HoldAutoJumpUntilLanding:
                tst.b   (Tails_CPU_auto_jump_flag).w
                beq.s   SKTailsAI_CheckAutoJumpXOrPhase
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|0,d1
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsAI_WriteFollowInput
                move.b  #0,(Tails_CPU_auto_jump_flag).w

SKTailsAI_CheckAutoJumpXOrPhase:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$FF,d0
                beq.s   SKTailsAI_CheckTarget32pxAbove
                cmpi.w  #$40,d2
                bhs.s   SKTailsAI_WriteFollowInput

SKTailsAI_CheckTarget32pxAbove:
                sub.w   y_pos(a0),d3
                beq.s   SKTailsAI_WriteFollowInput
                bpl.s   SKTailsAI_WriteFollowInput
                neg.w   d3
                cmpi.w  #$20,d3
                blo.s   SKTailsAI_WriteFollowInput

SKTailsAI_TryAutoJumpOn64FramePhase:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   SKTailsAI_WriteFollowInput
                cmpi.b  #8,anim(a0)
                beq.s   SKTailsAI_WriteFollowInput
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),d1
                move.b  #1,(Tails_CPU_auto_jump_flag).w

SKTailsAI_WriteFollowInput:
                move.w  d1,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKTailsAI_TickManualOverride:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKTailsAI_KeepExistingInputReturn
                subq.w  #1,(Tails_CPU_idle_timer).w

SKTailsAI_KeepExistingInputReturn:
                rts

; Owner: objects/players/tails/sk
; Responsibility: Follower control dispatch, stage-specific initialization, flying catch-up and normal companion navigation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_CPU_Control:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
                beq.s   SKTailsAI_DispatchFollowerStateAfterManualInputRefresh
                move.w  #10*60,(Tails_CPU_idle_timer).w

SKTailsAI_DispatchFollowerStateAfterManualInputRefresh:
                lea     (Player_1).w,a1
                move.w  (Tails_CPU_routine).w,d0
                move.w  Tails_CPU_Control_Index(pc,d0.w),d0
                jmp     Tails_CPU_Control_Index(pc,d0.w)
; End of function Tails_CPU_Control

; ---------------------------------------------------------------------------
Tails_CPU_Control_Index:
                dc.w    SKTailsAI_InitializeFollowerByCheckpointAndStage-Tails_CPU_Control_Index
                dc.w    Tails_Catch_Up_Flying-Tails_CPU_Control_Index
                dc.w    Tails_FlySwim_Unknown-Tails_CPU_Control_Index
                dc.w    SKTailsAI_SwitchNormalFollowToFlightWhenLeaderRoutineRequires-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_GateIdleCpuSpindashAfterOffscreenWatch-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_ReturnWithoutInputChangesInInactiveCpuState-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_InitializeIntroCarryFlightWithRightwardVelocity-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_ClearIdleAndPulseRightDuringIntroCarry-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_PulseRightAndFlapWhilePartnerLeavesIntro-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_ClearCpuInputWhileWaitingForBossCarrySetup-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_InitializeBossCarryFlightAndAttachPrimary-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_PulseFlapDuringBossCarryClimb-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_ChooseAutomaticAltitudeOrReacquisitionByIdleAndCarry-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_InitializeSoloBossFlightWithoutPrimaryAttachment-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_PulseSoloBossClimbAndRefreshFlightBudget-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_RefreshSoloFlightBudgetWithoutChangingInput-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_InitializeScriptedPrimaryFlyInWithRightwardVelocity-Tails_CPU_Control_Index
                dc.w    SKTailsCpuScript_PulseRightDuringScriptedPrimaryFlyIn-Tails_CPU_Control_Index
; ---------------------------------------------------------------------------

SKTailsAI_InitializeFollowerByCheckpointAndStage:
                tst.b   (Tails_CPU_star_post_flag).w
                bne.w   SKTailsAI_ClearFollowerMotionBeforeStartingFollow
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectEarlyStagePlacementOrDirectFollow
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_SelectEarlyStagePlacementOrDirectFollow:
                cmpi.w  #$100,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWithOwnControlEnabled
                cmpi.w  #$200,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWithOwnControlEnabled
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   SKTailsAI_HoldFollowerOffscreenForSelectedStageStart
                move.w  #$18,x_pos(a0)
                move.w  #$600,y_pos(a0)

SKTailsAI_StartStageSpecificCarryingInitializationAtChosenPosition:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.b  #2,status(a0)
                move.w  #$C,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKTailsAI_HoldFollowerOffscreenForSelectedStageStart:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectDirectFollowOrExtendedStageStart
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_SelectDirectFollowOrExtendedStageStart:
                cmpi.w  #$600,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWithOwnControlEnabled
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   SKTailsAI_SelectAdditionalLateStageFollowerStartup
                tst.w   (SK_alone_flag).w
                bne.s   SKTailsAI_SelectAdditionalLateStageFollowerStartup
                move.w  #$D8,x_pos(a0)
                move.w  #$500,y_pos(a0)
                bra.s   SKTailsAI_StartStageSpecificCarryingInitializationAtChosenPosition
; ---------------------------------------------------------------------------

SKTailsAI_SelectAdditionalLateStageFollowerStartup:
                cmpi.w  #$800,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWhilePreservingExistingControlByte
                cmpi.w  #$900,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWithOwnControlEnabled
                cmpi.w  #$A00,(Current_zone_and_act).w
                bne.s   SKTailsAI_ChooseLateStageDirectFollowWithOrWithoutControlClear
                bsr.w   TailsSKResetCPUFollowerToOffscreenCatchUp
                move.w  #$A,(Tails_CPU_routine).w
                move.b  #$83,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_ChooseLateStageDirectFollowWithOrWithoutControlClear:
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.w   SKTailsAI_StartNormalFollowWithOwnControlEnabled
                cmpi.b  #$17,(Current_zone).w
                beq.s   SKTailsAI_StartNormalFollowWhilePreservingExistingControlByte

SKTailsAI_ClearFollowerMotionBeforeStartingFollow:
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #0,status(a0)

SKTailsAI_StartNormalFollowWithOwnControlEnabled:
                move.b  #0,object_control(a0)

SKTailsAI_StartNormalFollowWhilePreservingExistingControlByte:
                move.w  #6,(Tails_CPU_routine).w
                move.w  #0,(Tails_CPU_flight_timer).w
                rts
; ---------------------------------------------------------------------------

Tails_Catch_Up_Flying:
                move.b  (Ctrl_2_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   SKTailsAI_BeginFlightCatchUpAtLeaderPosition
                move.w  (Level_frame_counter).w,d0
                andi.w  #$3F,d0
                bne.w   SKTailsAI_ReturnFromCatchUpSpawnGateOrSetup
                tst.b   object_control(a1)
                bmi.w   SKTailsAI_ReturnFromCatchUpSpawnGateOrSetup
                move.b  status(a1),d0
                andi.b  #$80,d0
                bne.w   SKTailsAI_ReturnFromCatchUpSpawnGateOrSetup

SKTailsAI_BeginFlightCatchUpAtLeaderPosition:
                move.w  #4,(Tails_CPU_routine).w
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  d0,(Tails_CPU_target_X).w
                move.w  y_pos(a1),d0
                move.w  d0,(Tails_CPU_target_Y).w
                subi.w  #$C0,d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsAI_ApplyGravityAdjustedFlightSpawnYAndResetCatchUpFields
                addi.w  #2*$C0,d0

SKTailsAI_ApplyGravityAdjustedFlightSpawnYAndResetCatchUpFields:
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

SKTailsAI_ReturnFromCatchUpSpawnGateOrSetup:
                rts
; ---------------------------------------------------------------------------

Tails_FlySwim_Unknown:
                tst.b   render_flags(a0)
                bmi.s   SKTailsAI_RefreshVisibleFlightAnimationAndClearTimeout
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   SKTailsAI_ReadDelayedLeaderPositionAndApproachInFlight
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

SKTailsAI_RefreshVisibleFlightAnimationAndClearTimeout:
                move.b  #(8*60)/2,double_jump_property(a0)
                ori.b   #1<<Status_InAir,status(a0)
                bsr.w   Tails_Set_Flying_Animation
                move.w  #0,(Tails_CPU_flight_timer).w

SKTailsAI_ReadDelayedLeaderPositionAndApproachInFlight:
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
                beq.s   SKTailsAI_ChooseSinglePixelFlightVerticalStep
                move.w  d0,d2
                bpl.s   SKTailsAI_ScaleAndCapFlightHorizontalDistanceStep
                neg.w   d2

SKTailsAI_ScaleAndCapFlightHorizontalDistanceStep:
                lsr.w   #4,d2
                cmpi.w  #$C,d2
                blo.s   SKTailsAI_ReadLeaderHorizontalVelocityHighByte
                moveq   #$C,d2

SKTailsAI_ReadLeaderHorizontalVelocityHighByte:
                move.b  x_vel(a1),d1
                bpl.s   SKTailsAI_AddLeaderVelocityByteAndChooseFlightDirection
                neg.b   d1

SKTailsAI_AddLeaderVelocityByteAndChooseFlightDirection:
                add.b   d1,d2
                addq.w  #1,d2
                tst.w   d0
                bmi.s   SKTailsAI_ApproachFlightTargetToTheRight
                bset    #Status_Facing,status(a0)
                cmp.w   d0,d2
                blo.s   SKTailsAI_NegateFlightStepWhenFollowerIsRightOfTarget
                move.w  d0,d2
                moveq   #0,d0

SKTailsAI_NegateFlightStepWhenFollowerIsRightOfTarget:
                neg.w   d2
                bra.s   SKTailsAI_AddFlightHorizontalStepToIntegerPosition
; ---------------------------------------------------------------------------

SKTailsAI_ApproachFlightTargetToTheRight:
                bclr    #Status_Facing,status(a0)
                neg.w   d0
                cmp.w   d0,d2
                blo.s   SKTailsAI_AddFlightHorizontalStepToIntegerPosition
                move.b  d0,d2
                moveq   #0,d0

SKTailsAI_AddFlightHorizontalStepToIntegerPosition:
                add.w   d2,x_pos(a0)

SKTailsAI_ChooseSinglePixelFlightVerticalStep:
                moveq   #1,d2
                move.w  y_pos(a0),d1
                sub.w   (Tails_CPU_target_Y).w,d1
                beq.s   SKTailsAI_GateFlightHandoffFromDelayedLeaderState
                bmi.s   SKTailsAI_ApplyFlightVerticalStep
                neg.w   d2

SKTailsAI_ApplyFlightVerticalStep:
                add.w   d2,y_pos(a0)

SKTailsAI_GateFlightHandoffFromDelayedLeaderState:
                lea     (Stat_table).w,a2
                move.b  2(a2,d3.w),d2
                andi.b  #$80,d2
                bne.s   SKTailsAI_RetainOwnMovementSuppressionWhenFlightHandoffIsUnready
                or.w    d0,d1
                bne.s   SKTailsAI_RetainOwnMovementSuppressionWhenFlightHandoffIsUnready
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   SKTailsAI_RetainOwnMovementSuppressionWhenFlightHandoffIsUnready
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
                bpl.s   SKTailsAI_CopyLeaderCollisionPlanesOnFlightHandoff
                ori.w   #high_priority,art_tile(a0)

SKTailsAI_CopyLeaderCollisionPlanesOnFlightHandoff:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_RetainOwnMovementSuppressionWhenFlightHandoffIsUnready:
                move.b  #$81,object_control(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_SwitchNormalFollowToFlightWhenLeaderRoutineRequires:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   SKTailsAI_GateNormalAIByTimeoutManualControlAndPlayerState
                move.w  #4,(Tails_CPU_routine).w
                move.b  #0,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.b  #$20,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsAI_GateNormalAIByTimeoutManualControlAndPlayerState:
                bsr.w   TailsSKWatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsAI_DecrementManualOverrideTimerWithoutReplacingInput
                tst.b   object_control(a0)
                bmi.w   SKTailsAI_DecrementManualOverrideTimerWithoutReplacingInput
                tst.b   status_tertiary(a1)
                bmi.w   SKTailsAI_DecrementManualOverrideTimerWithoutReplacingInput
                tst.w   move_lock(a0)
                beq.s   SKTailsAI_ReadDelayedLeaderXAndApplyTrailingOffset
                tst.w   ground_vel(a0)
                bne.s   SKTailsAI_ReadDelayedLeaderXAndApplyTrailingOffset
                move.w  #8,(Tails_CPU_routine).w

SKTailsAI_ReadDelayedLeaderXAndApplyTrailingOffset:
                lea     (Pos_table).w,a2
                move.w  #$10,d1
                lsl.b   #2,d1
                addq.b  #4,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.w  (a2,d0.w),d2
                btst    #Status_OnObj,status(a1)
                bne.s   SKTailsAI_ReadDelayedInputStatusAndCheckPushMismatch
                cmpi.w  #$400,ground_vel(a1)
                bge.s   SKTailsAI_ReadDelayedInputStatusAndCheckPushMismatch
                subi.w  #$20,d2

SKTailsAI_ReadDelayedInputStatusAndCheckPushMismatch:
                move.w  2(a2,d0.w),d3
                lea     (Stat_table).w,a2
                move.w  (a2,d0.w),d1
                move.b  2(a2,d0.w),d4
                move.w  d1,d0
                btst    #Status_Push,status(a0)
                beq.s   SKTailsAI_ChooseFollowerHorizontalInputFromTargetError
                btst    #5,d4
                beq.w   SKTailsAI_IssueAutomaticJumpOnSixtyFourFramePhase

SKTailsAI_ChooseFollowerHorizontalInputFromTargetError:
                sub.w   x_pos(a0),d2
                beq.s   SKTailsAI_MatchDelayedLeaderFacingAtEqualX
                bpl.s   SKTailsAI_OverrideInputRightWhenTargetFarEnough
                neg.w   d2
                cmpi.w  #$30,d2
                blo.s   SKTailsAI_NudgeFollowerLeftWhenAlreadyMovingAndFacingLeft
                andi.w  #$F3F3,d1
                ori.w   #$404,d1

SKTailsAI_NudgeFollowerLeftWhenAlreadyMovingAndFacingLeft:
                tst.w   ground_vel(a0)
                beq.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                btst    #0,object_control(a0)
                bne.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                subq.w  #1,x_pos(a0)
                bra.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
; ---------------------------------------------------------------------------

SKTailsAI_OverrideInputRightWhenTargetFarEnough:
                cmpi.w  #$30,d2
                blo.s   SKTailsAI_NudgeFollowerRightWhenAlreadyMovingAndFacingRight
                andi.w  #$F3F3,d1
                ori.w   #$808,d1

SKTailsAI_NudgeFollowerRightWhenAlreadyMovingAndFacingRight:
                tst.w   ground_vel(a0)
                beq.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                btst    #Status_Facing,status(a0)
                bne.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                btst    #0,object_control(a0)
                bne.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                addq.w  #1,x_pos(a0)
                bra.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
; ---------------------------------------------------------------------------

SKTailsAI_MatchDelayedLeaderFacingAtEqualX:
                bclr    #Status_Facing,status(a0)
                move.b  d4,d0
                andi.b  #1,d0
                beq.s   SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears
                bset    #Status_Facing,status(a0)

SKTailsAI_ContinueAutomaticJumpHoldUntilAirborneClears:
                tst.b   (Tails_CPU_auto_jump_flag).w
                beq.s   SKTailsAI_GateVerticalJumpCheckByHorizontalDistanceAndFramePhase
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|0,d1
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsAI_WriteFollowerLogicalControllerWord
                move.b  #0,(Tails_CPU_auto_jump_flag).w

SKTailsAI_GateVerticalJumpCheckByHorizontalDistanceAndFramePhase:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$FF,d0
                beq.s   SKTailsAI_RequireTargetAboveByAtLeastThirtyTwoPixels
                cmpi.w  #$40,d2
                bhs.s   SKTailsAI_WriteFollowerLogicalControllerWord

SKTailsAI_RequireTargetAboveByAtLeastThirtyTwoPixels:
                sub.w   y_pos(a0),d3
                beq.s   SKTailsAI_WriteFollowerLogicalControllerWord
                bpl.s   SKTailsAI_WriteFollowerLogicalControllerWord
                neg.w   d3
                cmpi.w  #$20,d3
                blo.s   SKTailsAI_WriteFollowerLogicalControllerWord

SKTailsAI_IssueAutomaticJumpOnSixtyFourFramePhase:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   SKTailsAI_WriteFollowerLogicalControllerWord
                cmpi.b  #8,anim(a0)
                beq.s   SKTailsAI_WriteFollowerLogicalControllerWord
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),d1
                move.b  #1,(Tails_CPU_auto_jump_flag).w

SKTailsAI_WriteFollowerLogicalControllerWord:
                move.w  d1,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKTailsAI_DecrementManualOverrideTimerWithoutReplacingInput:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKTailsAI_ReturnWithExistingFollowerInput
                subq.w  #1,(Tails_CPU_idle_timer).w

SKTailsAI_ReturnWithExistingFollowerInput:
                rts

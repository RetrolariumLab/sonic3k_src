; Owner: objects/players/tails/sk
; Responsibility: Follower reset and interaction helpers, idle spindash and level-scripted flight or carrying sequences
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TailsSKResetCPUFollowerToOffscreenCatchUp:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function TailsSKResetCPUFollowerToOffscreenCatchUp

; =============== S U B R O U T I N E =======================================

TailsSKWatchCPUOffscreenTimeoutAndInteractionCode:
                tst.b   render_flags(a0)
                bmi.s   SKTailsCpuScript_ClearOffscreenTimerWhenRenderSignMarksVisible
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsCpuScript_AdvanceOffscreenFollowerTimeoutUnlessInteractionChanged
                moveq   #0,d0
                movea.w interact(a0),a3
                move.w  (Tails_CPU_interact).w,d0
                cmp.w   (a3),d0
                bne.s   SKTailsCpuScript_ResetFollowerAfterOffscreenTimeoutOrChangedCodeWord

SKTailsCpuScript_AdvanceOffscreenFollowerTimeoutUnlessInteractionChanged:
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   SKTailsCpuScript_SampleInteractingObjectCodeWordForProfile

SKTailsCpuScript_ResetFollowerAfterOffscreenTimeoutOrChangedCodeWord:
                bra.w   TailsSKResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

SKTailsCpuScript_ClearOffscreenTimerWhenRenderSignMarksVisible:
                move.w  #0,(Tails_CPU_flight_timer).w

SKTailsCpuScript_SampleInteractingObjectCodeWordForProfile:
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsCpuScript_ReturnWithoutInteractionSampleWhenNotOnObject
                movea.w interact(a0),a3
                move.w  (a3),(Tails_CPU_interact).w

SKTailsCpuScript_ReturnWithoutInteractionSampleWhenNotOnObject:
                rts
; End of function TailsSKWatchCPUOffscreenTimeoutAndInteractionCode

; ---------------------------------------------------------------------------

SKTailsCpuScript_GateIdleCpuSpindashAfterOffscreenWatch:
                bsr.w   TailsSKWatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis
                tst.w   move_lock(a0)
                bne.s   SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsCpuScript_MaintainCpuSpindashDownUntilGlobalReleasePhase
                tst.w   ground_vel(a0)
                bne.s   SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis
                bclr    #Status_Facing,status(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SKTailsCpuScript_SynthesizeDownAndInitialSpindashButtonsByGlobalPhase
                bset    #Status_Facing,status(a0)

SKTailsCpuScript_SynthesizeDownAndInitialSpindashButtonsByGlobalPhase:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                beq.s   SKTailsCpuScript_ReleaseCpuSpindashInputAndResumeTracking
                cmpi.b  #8,anim(a0)
                bne.s   SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis
                move.w  #((button_A_mask|button_B_mask|button_C_mask|button_down_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_down_mask),(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_MaintainCpuSpindashDownUntilGlobalReleasePhase:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                bne.s   SKTailsCpuScript_PulseCpuSpindashChargeEveryThirtyTwoGlobalFrames

SKTailsCpuScript_ReleaseCpuSpindashInputAndResumeTracking:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.w  #6,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_PulseCpuSpindashChargeEveryThirtyTwoGlobalFrames:
                andi.b  #$1F,d0
                bne.s   SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsCpuScript_ReturnAfterIdleSpindashGateOrButtonSynthesis:
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_ReturnWithoutInputChangesInInactiveCpuState:
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_InitializeIntroCarryFlightWithRightwardVelocity:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$E,(Tails_CPU_routine).w

SKTailsCpuScript_ClearIdleAndPulseRightDuringIntroCarry:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKTailsCpuScript_FinishIntroCarryWhenPrimaryPlayerGrounded
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

SKTailsCpuScript_FinishIntroCarryWhenPrimaryPlayerGrounded:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKTailsCpuScript_RunPrimaryCarryLogicAfterIntroPhase
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   art_tile(a1)
                bpl.s   SKTailsCpuScript_CopyPrimarySolidityAndSelectPartnerExitFlight
                ori.w   #high_priority,art_tile(a0)

SKTailsCpuScript_CopyPrimarySolidityAndSelectPartnerExitFlight:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                cmpi.w  #1,(Player_mode).w
                bne.s   SKTailsCpuScript_RunPrimaryCarryLogicAfterIntroPhase
                move.w  #$10,(Tails_CPU_routine).w

SKTailsCpuScript_RunPrimaryCarryLogicAfterIntroPhase:
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsCpuScript_PulseRightAndFlapWhilePartnerLeavesIntro:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKTailsCpuScript_HandleOffscreenPartnerExitByProfile
                ori.w   #((button_A_mask|button_B_mask|button_C_mask|button_right_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_right_mask),(Ctrl_2_logical).w

SKTailsCpuScript_HandleOffscreenPartnerExitByProfile:
                tst.b   render_flags(a0)
                bmi.s   SKTailsCpuScript_ReturnAfterPartnerExitVisibilityDecision
                moveq   #0,d0
                move.l  d0,(a0)
                move.w  d0,x_pos(a0)
                move.w  d0,y_pos(a0)
                move.w  #$A,(Tails_CPU_routine).w

SKTailsCpuScript_ReturnAfterPartnerExitVisibilityDecision:
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_ClearCpuInputWhileWaitingForBossCarrySetup:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_InitializeBossCarryFlightAndAttachPrimary:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$16,(Tails_CPU_routine).w

SKTailsCpuScript_PulseFlapDuringBossCarryClimb:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKTailsCpuScript_SwitchBossCarryToAltitudeControlAtCameraThreshold
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsCpuScript_SwitchBossCarryToAltitudeControlAtCameraThreshold:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKTailsCpuScript_InvokeCarryAfterBossClimbThreshold
                move.w  #$18,(Tails_CPU_routine).w

SKTailsCpuScript_InvokeCarryAfterBossClimbThreshold:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsCpuScript_ChooseAutomaticAltitudeOrReacquisitionByIdleAndCarry:
                move.b  #(8*60)/2,double_jump_property(a0)
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKTailsCpuScript_SynthesizeAutomaticCarryFlapsWithDownPriority
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.w   SKTailsCpuScript_TailCarryWithPhysicalPrimaryControllerWord
                bra.w   SKTailsCpuScript_ChooseHoverOrLatchedPrimaryReacquisition
; ---------------------------------------------------------------------------

SKTailsCpuScript_SynthesizeAutomaticCarryFlapsWithDownPriority:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.w   SKTailsCpuScript_ChooseHoverOrLatchedPrimaryReacquisition
                clr.b   (_unkFAAC).w
                btst    #button_down,(Ctrl_1_held).w
                beq.s   SKTailsCpuScript_UseFasterFlapCadenceWhenPhysicalUpHeld
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$C0,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte
; ---------------------------------------------------------------------------

SKTailsCpuScript_UseFasterFlapCadenceWhenPhysicalUpHeld:
                btst    #button_up,(Ctrl_1_held).w
                beq.s   SKTailsCpuScript_PulseNeutralAltitudeFlapAtTimerEightyEight
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$20,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte
; ---------------------------------------------------------------------------

SKTailsCpuScript_PulseNeutralAltitudeFlapAtTimerEightyEight:
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsCpuScript_MergePrimaryHorizontalHeldInputIntoFollowerHeldByte:
                move.b  (Ctrl_1).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                or.b    (Ctrl_2_logical).w,d0
                move.b  d0,(Ctrl_2_logical).w

SKTailsCpuScript_TailCarryWithPhysicalPrimaryControllerWord:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsCpuScript_InitializeSoloBossFlightWithoutPrimaryAttachment:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$1C,(Tails_CPU_routine).w

SKTailsCpuScript_PulseSoloBossClimbAndRefreshFlightBudget:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKTailsCpuScript_ReleaseSoloScriptClimbAtCameraAltitude
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsCpuScript_ReleaseSoloScriptClimbAtCameraAltitude:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKTailsCpuScript_ReturnAfterSoloClimbAltitudeDecision
                move.w  #$1E,(Tails_CPU_routine).w

SKTailsCpuScript_ReturnAfterSoloClimbAltitudeDecision:
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_RefreshSoloFlightBudgetWithoutChangingInput:
                move.b  #(8*60)/2,double_jump_property(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_InitializeScriptedPrimaryFlyInWithRightwardVelocity:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #2,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$22,(Tails_CPU_routine).w

SKTailsCpuScript_PulseRightDuringScriptedPrimaryFlyIn:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKTailsCpuScript_FinishPrimaryFlyInOnGroundContact
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

SKTailsCpuScript_FinishPrimaryFlyInOnGroundContact:
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsCpuScript_ReturnAfterPrimaryFlyInAirOrCompletionGate
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)

SKTailsCpuScript_ReturnAfterPrimaryFlyInAirOrCompletionGate:
                rts
; ---------------------------------------------------------------------------

SKTailsCpuScript_ChooseHoverOrLatchedPrimaryReacquisition:
                tst.b   (_unkFAAC).w
                bne.s   SKTailsCpuScript_ChasePrimaryUsingLatchedAccelerationAndFacing
                lea     (Player_1).w,a1
                tst.b   render_flags(a1)
                bpl.s   SKTailsCpuScript_LatchReacquisitionAndTakePrimaryVerticalDistance
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsCpuScript_TailPrimaryCarryAfterHoverOrReacquisition
                cmpi.w  #$300,y_vel(a1)
                bge.s   SKTailsCpuScript_LatchReacquisitionAndTakePrimaryVerticalDistance
                move.w  #0,x_vel(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                cmpi.w  #$200,y_vel(a0)
                bge.s   SKTailsCpuScript_EmitFallbackHoverFlapWithoutResettingTimerOnSpeedGate
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsCpuScript_JoinCarryAfterHoverPulseOrTimerHold
                move.b  #0,(Tails_CPU_auto_fly_timer).w

SKTailsCpuScript_EmitFallbackHoverFlapWithoutResettingTimerOnSpeedGate:
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsCpuScript_JoinCarryAfterHoverPulseOrTimerHold:
                bra.s   SKTailsCpuScript_TailPrimaryCarryAfterHoverOrReacquisition
; ---------------------------------------------------------------------------

SKTailsCpuScript_LatchReacquisitionAndTakePrimaryVerticalDistance:
                st      (_unkFAAC).w
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   SKTailsCpuScript_StoreVerticalCatchUpAccelerationInSharedCameraWord
                neg.w   d1

SKTailsCpuScript_StoreVerticalCatchUpAccelerationInSharedCameraWord:
                lsr.w   #2,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                move.w  d1,(Camera_stored_min_X_pos).w
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bpl.s   SKTailsCpuScript_StoreHorizontalCatchUpAccelerationAndDeferChase
                neg.w   d1

SKTailsCpuScript_StoreHorizontalCatchUpAccelerationAndDeferChase:
                lsr.w   #2,d1
                move.w  d1,(Camera_stored_max_X_pos).w
                bra.w   SKTailsCpuScript_TailPrimaryCarryAfterHoverOrReacquisition
; ---------------------------------------------------------------------------

SKTailsCpuScript_ChasePrimaryUsingLatchedAccelerationAndFacing:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subi.w  #$10,d1
                move.w  (Camera_stored_max_X_pos).w,d2
                bclr    #Status_Facing,status(a0)
                cmp.w   x_pos(a1),d0
                blo.s   SKTailsCpuScript_ApplyHorizontalCatchUpAndGateVerticalAddition
                bset    #Status_Facing,status(a0)
                neg.w   d2

SKTailsCpuScript_ApplyHorizontalCatchUpAndGateVerticalAddition:
                add.w   d2,x_vel(a0)
                cmp.w   y_pos(a1),d1
                bhs.s   SKTailsCpuScript_TailPrimaryCarryAfterHoverOrReacquisition
                move.w  (Camera_stored_min_X_pos).w,d2
                cmp.w   y_pos(a1),d1
                blo.s   SKTailsCpuScript_AddGuardedVerticalCatchUpAcceleration
                neg.w   d2

SKTailsCpuScript_AddGuardedVerticalCatchUpAcceleration:
                add.w   d2,y_vel(a0)

SKTailsCpuScript_TailPrimaryCarryAfterHoverOrReacquisition:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================

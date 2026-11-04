; Owner: objects/players/tails/sk
; Responsibility: Tails screen bounds, rolling initiation, jump launch and jump height control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Check_Screen_Boundaries:
                move.l  x_pos(a0),d1
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d1
                swap    d1
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   d1,d0
                bhi.s   SKTailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                blo.s   SKTailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion

SKTailsJump_CheckEnabledVerticalDeathPlaneAfterHorizontalBounds:
                tst.b   (Disable_death_plane).w
                bne.s   SKTailsJump_ReturnInsideVerticalBoundsOrWithDeathPlaneDisabled
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsJump_CheckReverseScreenDeathPlaneIncludingMinimumEquality
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKTailsJump_TailKillCharacterFromScreenDeathPlane

SKTailsJump_ReturnInsideVerticalBoundsOrWithDeathPlaneDisabled:
                rts
; ---------------------------------------------------------------------------

SKTailsJump_CheckReverseScreenDeathPlaneIncludingMinimumEquality:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKTailsJump_ReturnInsideVerticalBoundsOrWithDeathPlaneDisabled

SKTailsJump_TailKillCharacterFromScreenDeathPlane:
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

SKTailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion:
                move.w  d0,x_pos(a0)
                move.w  #0,2+x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                bra.s   SKTailsJump_CheckEnabledVerticalDeathPlaneAfterHorizontalBounds
; End of function Tails_Check_Screen_Boundaries

; =============== S U B R O U T I N E =======================================

Tails_Roll:
                tst.b   status_secondary(a0)
                bmi.s   SKTailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKTailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   SKTailsJump_ClearDuckAnimationWhenDownReleased
                move.w  ground_vel(a0),d0
                bpl.s   SKTailsJump_ApplyProfileRollSpeedThresholdAndInputPolicy
                neg.w   d0

SKTailsJump_ApplyProfileRollSpeedThresholdAndInputPolicy:
                cmpi.w  #$100,d0
                bhs.s   SKTailsJump_SkipRollInitializationIfAlreadyRolling
                btst    #Status_OnObj,status(a0)
                bne.s   SKTailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                move.b  #8,anim(a0)

SKTailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice:
                rts
; ---------------------------------------------------------------------------

SKTailsJump_ClearDuckAnimationWhenDownReleased:
                cmpi.b  #8,anim(a0)
                bne.s   SKTailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsJump_SkipRollInitializationIfAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   SKTailsJump_InitializeRollGeometryAndDefaultPositiveGroundSpeed
                rts
; ---------------------------------------------------------------------------

SKTailsJump_InitializeRollGeometryAndDefaultPositiveGroundSpeed:
                bset    #Status_Roll,status(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsJump_PlayRollSoundAndSupplyPositiveSpeedOnlyAtZero
                subq.w  #2,y_pos(a0)

SKTailsJump_PlayRollSoundAndSupplyPositiveSpeedOnlyAtZero:
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   SKTailsJump_ReturnAfterRollSoundAndGroundSpeedFallback
                move.w  #$200,ground_vel(a0)

SKTailsJump_ReturnAfterRollSoundAndGroundSpeedFallback:
                rts
; End of function Tails_Roll

; =============== S U B R O U T I N E =======================================

Tails_Jump:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKTailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved
                moveq   #0,d0
                move.b  angle(a0),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsJump_ProbeOverheadAfterGravityAngleNormalization
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0

SKTailsJump_ProbeOverheadAfterGravityAngleNormalization:
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1
                blt.w   SKTailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved
                move.w  #$680,d2
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsJump_AddAngleDirectedJumpImpulseAndDiscardGroundCallerReturn
                move.w  #$380,d2

SKTailsJump_AddAngleDirectedJumpImpulseAndDiscardGroundCallerReturn:
                moveq   #0,d0
                move.b  angle(a0),d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d1
                asr.l   #8,d1
                add.w   d1,x_vel(a0)
                muls.w  d2,d0
                asr.l   #8,d0
                add.w   d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                addq.l  #4,sp
                move.b  #1,jumping(a0)
                clr.b   stick_to_convex(a0)
                move.w  #sfx_Jump,d0
                jsr     (Play_SFX).l
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                bne.s   SKTailsJump_MarkJumpStartedWhileAlreadyRolling
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsJump_ApplySignedNewJumpRadiusDisplacement
                neg.w   d0

SKTailsJump_ApplySignedNewJumpRadiusDisplacement:
                sub.w   d0,y_pos(a0)

SKTailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved:
                rts
; ---------------------------------------------------------------------------

SKTailsJump_MarkJumpStartedWhileAlreadyRolling:
                bset    #Status_RollJump,status(a0)
                rts
; End of function Tails_Jump

; =============== S U B R O U T I N E =======================================

Tails_JumpHeight:
                tst.b   jumping(a0)
                beq.s   SKTailsJump_CapNonJumpUpwardVelocityUnlessSpindashFlagSet
                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsJump_GateFlightOrShortenReleasedJumpAtSignedVerticalThreshold
                move.w  #-$200,d1

SKTailsJump_GateFlightOrShortenReleasedJumpAtSignedVerticalThreshold:
                cmp.w   y_vel(a0),d1
                ble.s   Tails_Test_For_Flight
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   SKTailsJump_ReturnAfterHeldOrReleasedJumpHeightDecision
                move.w  d1,y_vel(a0)

SKTailsJump_ReturnAfterHeldOrReleasedJumpHeightDecision:
                rts
; ---------------------------------------------------------------------------

SKTailsJump_CapNonJumpUpwardVelocityUnlessSpindashFlagSet:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption
                cmpi.w  #-$FC0,y_vel(a0)
                bge.s   SKTailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption
                move.w  #-$FC0,y_vel(a0)

SKTailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption:
                rts
; ---------------------------------------------------------------------------

Tails_Test_For_Flight:
                tst.b   double_jump_flag(a0)
                bne.w   SKTailsJump_ReturnAfterFlightGateOrActivation
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKTailsJump_ReturnAfterFlightGateOrActivation
                cmpi.w  #2,(Player_mode).w
                bne.s   SKTailsJump_RequireCpuIdleTimerForNonSoloFlightStart
                tst.b   (Super_Tails_flag).w
                bne.s   SKTailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   SKTailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight
                cmpi.w  #50,(Ring_count).w
                blo.s   SKTailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight
                tst.b   (Update_HUD_timer).w
                bne.s   Tails_Transform
                bra.s   SKTailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight
; ---------------------------------------------------------------------------

SKTailsJump_RequireCpuIdleTimerForNonSoloFlightStart:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKTailsJump_ReturnAfterFlightGateOrActivation

SKTailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight:
                btst    #Status_Roll,status(a0)
                beq.s   SKTailsJump_ActivateFlightBudgetAndSelectFlyingAnimation
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d1
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                sub.b   default_y_radius(a0),d1
                ext.w   d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsJump_AddFlightUnrollDeltaDespiteWrongRegisterGravityNegate
                neg.w   d0

SKTailsJump_AddFlightUnrollDeltaDespiteWrongRegisterGravityNegate:
                add.w   d1,y_pos(a0)

SKTailsJump_ActivateFlightBudgetAndSelectFlyingAnimation:
                bclr    #Status_RollJump,status(a0)
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

SKTailsJump_ReturnAfterFlightGateOrActivation:
                rts
; ---------------------------------------------------------------------------

Tails_Transform:
                move.b  #1,(Super_palette_status).w     ; set Super/Hyper palette status to 'fading'
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Tails_flag).w         ; set flag to Super Tails
                move.w  #60,(Super_frame_count).w
                move.b  #$81,object_control(a0)
                move.b  #$29,anim(a0)                   ; enter 'transformation' animation
                move.l  #Obj_SuperTailsBirds,(Invincibility_stars).w  ; load Super Flickies object
                move.w  #$800,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$18,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$C0,Deceleration_P2-Max_speed_P2(a4)
                move.b  #0,invincibility_timer(a0)
                bset    #Status_Invincible,status_secondary(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; End of function Tails_JumpHeight

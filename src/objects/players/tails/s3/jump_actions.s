; Owner: objects/players/tails/s3
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
                bhi.s   S3TailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                bls.s   S3TailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion

S3TailsJump_CheckEnabledVerticalDeathPlaneAfterHorizontalBounds:
                tst.b   (Disable_death_plane).w
                bne.s   S3TailsJump_ReturnInsideVerticalBoundsOrWithDeathPlaneDisabled
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.s   S3TailsJump_TailKillCharacterFromScreenDeathPlane

S3TailsJump_ReturnInsideVerticalBoundsOrWithDeathPlaneDisabled:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_TailKillCharacterFromScreenDeathPlane:
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

S3TailsJump_ClampPredictedHorizontalPositionAndStopHorizontalMotion:
                move.w  d0,x_pos(a0)
                move.w  #0,2+x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                bra.s   S3TailsJump_CheckEnabledVerticalDeathPlaneAfterHorizontalBounds
; End of function Tails_Check_Screen_Boundaries

; =============== S U B R O U T I N E =======================================

Tails_Roll:
                tst.b   status_secondary(a0)
                bmi.s   S3TailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                move.w  ground_vel(a0),d0
                bpl.s   S3TailsJump_ApplyProfileRollSpeedThresholdAndInputPolicy
                neg.w   d0

S3TailsJump_ApplyProfileRollSpeedThresholdAndInputPolicy:
                cmpi.w  #$80,d0
                bcs.s   S3TailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3TailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice
                btst    #button_down,(Ctrl_2_held_logical).w
                bne.s   S3TailsJump_SkipRollInitializationIfAlreadyRolling

S3TailsJump_ReturnAfterRollEntryGateOrSlowDuckChoice:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_SkipRollInitializationIfAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsJump_InitializeRollGeometryAndDefaultPositiveGroundSpeed
                rts
; ---------------------------------------------------------------------------

S3TailsJump_InitializeRollGeometryAndDefaultPositiveGroundSpeed:
                bset    #Status_Roll,status(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   S3TailsJump_ReturnAfterRollSoundAndGroundSpeedFallback
                move.w  #$200,ground_vel(a0)

S3TailsJump_ReturnAfterRollSoundAndGroundSpeedFallback:
                rts
; End of function Tails_Roll

; =============== S U B R O U T I N E =======================================

Tails_Jump:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved
                moveq   #0,d0
                move.b  angle(a0),d0
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1
                blt.w   S3TailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved
                move.w  #$680,d2
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsJump_AddAngleDirectedJumpImpulseAndDiscardGroundCallerReturn
                move.w  #$380,d2

S3TailsJump_AddAngleDirectedJumpImpulseAndDiscardGroundCallerReturn:
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
                bne.s   S3TailsJump_MarkJumpStartedWhileAlreadyRolling
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                sub.w   d0,y_pos(a0)

S3TailsJump_ReturnFromRejectedOrCompletedJumpWithStackSemanticsPreserved:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_MarkJumpStartedWhileAlreadyRolling:
                bset    #Status_RollJump,status(a0)
                rts
; End of function Tails_Jump

; =============== S U B R O U T I N E =======================================

Tails_JumpHeight:
                tst.b   jumping(a0)
                beq.s   S3TailsJump_CapNonJumpUpwardVelocityUnlessSpindashFlagSet
                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsJump_GateFlightOrShortenReleasedJumpAtSignedVerticalThreshold
                move.w  #-$200,d1

S3TailsJump_GateFlightOrShortenReleasedJumpAtSignedVerticalThreshold:
                cmp.w   y_vel(a0),d1
                ble.s   Tails_Test_For_Flight
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   S3TailsJump_ReturnAfterHeldOrReleasedJumpHeightDecision
                move.w  d1,y_vel(a0)

S3TailsJump_ReturnAfterHeldOrReleasedJumpHeightDecision:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_CapNonJumpUpwardVelocityUnlessSpindashFlagSet:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption
                cmpi.w  #-$FC0,y_vel(a0)
                bge.s   S3TailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption
                move.w  #-$FC0,y_vel(a0)

S3TailsJump_ReturnAfterNonJumpVelocityCapOrSpindashExemption:
                rts
; ---------------------------------------------------------------------------

Tails_Test_For_Flight:
                tst.b   double_jump_flag(a0)
                bne.w   S3TailsJump_ReturnAfterFlightGateOrActivation
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsJump_ReturnAfterFlightGateOrActivation
                cmpi.w  #2,(Player_mode).w
                beq.s   S3TailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   S3TailsJump_ReturnAfterFlightGateOrActivation

S3TailsJump_UnrollAndRestoreDefaultsBeforeStartingFlight:
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsJump_ActivateFlightBudgetAndSelectFlyingAnimation
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d1
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                sub.b   default_y_radius(a0),d1
                ext.w   d1
                add.w   d1,y_pos(a0)

S3TailsJump_ActivateFlightBudgetAndSelectFlyingAnimation:
                bclr    #Status_RollJump,status(a0)
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

S3TailsJump_ReturnAfterFlightGateOrActivation:
                rts
; End of function Tails_JumpHeight

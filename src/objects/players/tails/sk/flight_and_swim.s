; Owner: objects/players/tails/sk
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   SKTailsFlight_AdvanceActiveFlapOrTestNewFlapRequest
                tst.b   double_jump_property(a0)
                beq.s   SKTailsFlight_AdvanceActiveFlapOrTestNewFlapRequest
                subq.b  #1,double_jump_property(a0)

SKTailsFlight_AdvanceActiveFlapOrTestNewFlapRequest:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   SKTailsFlight_GateNewFlapByPressedInputBudgetAndCarryState
                cmpi.w  #-$100,y_vel(a0)
                blt.s   SKTailsFlight_ResetFlapCounterToWaitingState
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   SKTailsFlight_JoinCeilingAndAnimationAfterActiveFlap

SKTailsFlight_ResetFlapCounterToWaitingState:
                move.b  #1,double_jump_flag(a0)

SKTailsFlight_JoinCeilingAndAnimationAfterActiveFlap:
                bra.s   SKTailsFlight_ClampUpwardVelocityAtSignedCameraCeiling
; ---------------------------------------------------------------------------

SKTailsFlight_GateNewFlapByPressedInputBudgetAndCarryState:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKTailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                cmpi.w  #-$100,y_vel(a0)
                blt.s   SKTailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                tst.b   double_jump_property(a0)
                beq.s   SKTailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsFlight_BeginNewFlapCounterBeforeWaitingGravity
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   SKTailsFlight_AddWaitingFlightGravityBeforeCeilingCheck

SKTailsFlight_BeginNewFlapCounterBeforeWaitingGravity:
                move.b  #2,double_jump_flag(a0)

SKTailsFlight_AddWaitingFlightGravityBeforeCeilingCheck:
                addi.w  #8,y_vel(a0)

SKTailsFlight_ClampUpwardVelocityAtSignedCameraCeiling:
                move.w  (Camera_min_Y_pos).w,d0
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                blt.s   Tails_Set_Flying_Animation
                tst.w   y_vel(a0)
                bpl.s   Tails_Set_Flying_Animation
                move.w  #0,y_vel(a0)
; End of function Tails_Move_FlySwim

; =============== S U B R O U T I N E =======================================

Tails_Set_Flying_Animation:
                btst    #Status_Underwater,status(a0)
                bne.s   SKTailsFlight_SelectSwimAnimationFromStoredVerticalVelocity
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   SKTailsFlight_StoreDryFlightAnimationAndGateFlyingSound
                tst.w   y_vel(a0)
                bpl.s   SKTailsFlight_OffsetDryFlightAnimationWhenCarrying
                moveq   #$21,d0

SKTailsFlight_OffsetDryFlightAnimationWhenCarrying:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFlight_SelectExhaustedDryFlightAndGateTiredSound
                addq.b  #2,d0

SKTailsFlight_SelectExhaustedDryFlightAndGateTiredSound:
                tst.b   double_jump_property(a0)
                bne.s   SKTailsFlight_StoreDryFlightAnimationAndGateFlyingSound
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   SKTailsFlight_ReturnAfterExhaustedDryFlightSelection
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   SKTailsFlight_ReturnAfterExhaustedDryFlightSelection
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

SKTailsFlight_ReturnAfterExhaustedDryFlightSelection:
                rts
; ---------------------------------------------------------------------------

SKTailsFlight_StoreDryFlightAnimationAndGateFlyingSound:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   SKTailsFlight_ReturnAfterDryFlightAnimationAndSoundGate
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   SKTailsFlight_ReturnAfterDryFlightAnimationAndSoundGate
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

SKTailsFlight_ReturnAfterDryFlightAnimationAndSoundGate:
                rts
; ---------------------------------------------------------------------------

SKTailsFlight_SelectSwimAnimationFromStoredVerticalVelocity:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   SKTailsFlight_OverrideSwimAnimationWhenCarrying
                moveq   #$26,d0

SKTailsFlight_OverrideSwimAnimationWhenCarrying:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFlight_OverrideSwimAnimationWhenBudgetExhausted
                moveq   #$27,d0

SKTailsFlight_OverrideSwimAnimationWhenBudgetExhausted:
                tst.b   double_jump_property(a0)
                bne.s   SKTailsFlight_CommitSelectedSwimAnimation
                moveq   #$28,d0

SKTailsFlight_CommitSelectedSwimAnimation:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFlight_AttemptRollingGroundJumpAfterCarryRelease
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsFlight_AttemptRollingGroundJumpAfterCarryRelease:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsFlight_RunRollingGroundPhysicsAndBackgroundProbe
                bsr.w   Tails_Jump

SKTailsFlight_RunRollingGroundPhysicsAndBackgroundProbe:
                bsr.w   Player_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKTailsFlight_ReturnAfterRollingGroundStepAndBackgroundChecks
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsFlight_ProbeRightBackgroundWallAfterLeftCorrection
                sub.w   d1,x_pos(a0)

SKTailsFlight_ProbeRightBackgroundWallAfterLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsFlight_RestoreSavedCollisionRegistersAfterBothSideProbes
                add.w   d1,x_pos(a0)

SKTailsFlight_RestoreSavedCollisionRegistersAfterBothSideProbes:
                movem.l (sp)+,a4-a6

SKTailsFlight_ReturnAfterRollingGroundStepAndBackgroundChecks:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFlight_RunRollingAirMotionAfterCarryRelease
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsFlight_RunRollingAirMotionAfterCarryRelease:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsFlight_ResolveRollingAirAngleAndTerrainAfterMotion
                subi.w  #$28,y_vel(a0)

SKTailsFlight_ResolveRollingAirAngleAndTerrainAfterMotion:
                bsr.w   Player_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

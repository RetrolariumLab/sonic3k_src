; Owner: objects/players/tails/s3
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   S3TailsFlight_AdvanceActiveFlapOrTestNewFlapRequest
                tst.b   double_jump_property(a0)
                beq.s   S3TailsFlight_AdvanceActiveFlapOrTestNewFlapRequest
                subq.b  #1,double_jump_property(a0)

S3TailsFlight_AdvanceActiveFlapOrTestNewFlapRequest:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   S3TailsFlight_GateNewFlapByPressedInputBudgetAndCarryState
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsFlight_ResetFlapCounterToWaitingState
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   S3TailsFlight_JoinCeilingAndAnimationAfterActiveFlap

S3TailsFlight_ResetFlapCounterToWaitingState:
                move.b  #1,double_jump_flag(a0)

S3TailsFlight_JoinCeilingAndAnimationAfterActiveFlap:
                bra.s   S3TailsFlight_ClampUpwardVelocityAtSignedCameraCeiling
; ---------------------------------------------------------------------------

S3TailsFlight_GateNewFlapByPressedInputBudgetAndCarryState:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   S3TailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                tst.b   double_jump_property(a0)
                beq.s   S3TailsFlight_AddWaitingFlightGravityBeforeCeilingCheck
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsFlight_BeginNewFlapCounterBeforeWaitingGravity
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   S3TailsFlight_AddWaitingFlightGravityBeforeCeilingCheck

S3TailsFlight_BeginNewFlapCounterBeforeWaitingGravity:
                move.b  #2,double_jump_flag(a0)

S3TailsFlight_AddWaitingFlightGravityBeforeCeilingCheck:
                addi.w  #8,y_vel(a0)

S3TailsFlight_ClampUpwardVelocityAtSignedCameraCeiling:
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
                bne.s   S3TailsFlight_SelectSwimAnimationFromStoredVerticalVelocity
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   S3TailsFlight_StoreDryFlightAnimationAndGateFlyingSound
                tst.w   y_vel(a0)
                bpl.s   S3TailsFlight_OffsetDryFlightAnimationWhenCarrying
                moveq   #$21,d0

S3TailsFlight_OffsetDryFlightAnimationWhenCarrying:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFlight_SelectExhaustedDryFlightAndGateTiredSound
                addq.b  #2,d0

S3TailsFlight_SelectExhaustedDryFlightAndGateTiredSound:
                tst.b   double_jump_property(a0)
                bne.s   S3TailsFlight_StoreDryFlightAnimationAndGateFlyingSound
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   S3TailsFlight_ReturnAfterExhaustedDryFlightSelection
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsFlight_ReturnAfterExhaustedDryFlightSelection
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

S3TailsFlight_ReturnAfterExhaustedDryFlightSelection:
                rts
; ---------------------------------------------------------------------------

S3TailsFlight_StoreDryFlightAnimationAndGateFlyingSound:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   S3TailsFlight_ReturnAfterDryFlightAnimationAndSoundGate
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsFlight_ReturnAfterDryFlightAnimationAndSoundGate
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

S3TailsFlight_ReturnAfterDryFlightAnimationAndSoundGate:
                rts
; ---------------------------------------------------------------------------

S3TailsFlight_SelectSwimAnimationFromStoredVerticalVelocity:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   S3TailsFlight_OverrideSwimAnimationWhenCarrying
                moveq   #$26,d0

S3TailsFlight_OverrideSwimAnimationWhenCarrying:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFlight_OverrideSwimAnimationWhenBudgetExhausted
                moveq   #$27,d0

S3TailsFlight_OverrideSwimAnimationWhenBudgetExhausted:
                tst.b   double_jump_property(a0)
                bne.s   S3TailsFlight_CommitSelectedSwimAnimation
                moveq   #$28,d0

S3TailsFlight_CommitSelectedSwimAnimation:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFlight_AttemptRollingGroundJumpAfterCarryRelease
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsFlight_AttemptRollingGroundJumpAfterCarryRelease:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsFlight_RunRollingGroundPhysicsAndBackgroundProbe
                bsr.w   Tails_Jump

S3TailsFlight_RunRollingGroundPhysicsAndBackgroundProbe:
                bsr.w   Tails_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsFlight_ReturnAfterRollingGroundStepAndBackgroundChecks
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsFlight_ReturnAfterRollingGroundStepAndBackgroundChecks
                sub.w   d1,x_pos(a0)

S3TailsFlight_ReturnAfterRollingGroundStepAndBackgroundChecks:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFlight_RunRollingAirMotionAfterCarryRelease
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsFlight_RunRollingAirMotionAfterCarryRelease:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsFlight_ResolveRollingAirAngleAndTerrainAfterMotion
                subi.w  #$28,y_vel(a0)

S3TailsFlight_ResolveRollingAirAngleAndTerrainAfterMotion:
                bsr.w   Tails_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

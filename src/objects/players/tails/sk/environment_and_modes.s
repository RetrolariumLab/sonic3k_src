; Owner: objects/players/tails/sk
; Responsibility: Tails water transitions and ground, air, rolling, jumping, flying and swimming mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Water:
                tst.b   (Water_flag).w
                bne.s   SKTailsEnvironment_ClassifyWaterCrossingAndInitializeUnderwaterAirAndSpeeds

SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition:
                rts
; ---------------------------------------------------------------------------

SKTailsEnvironment_ClassifyWaterCrossingAndInitializeUnderwaterAirAndSpeeds:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   SKTailsEnvironment_LeaveWaterRestoreAirSpeedsAndGateExitBoost
                bset    #Status_Underwater,status(a0)
                bne.s   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.l  #Obj_AirCountdown,(Breathing_bubbles_P2).w
                move.b  #$81,(Breathing_bubbles_P2+subtype).w
                move.l  a0,(Breathing_bubbles_P2+$40).w
                move.w  #$300,Max_speed-Max_speed(a4)
                move.w  #6,Acceleration-Max_speed(a4)
                move.w  #$40,Deceleration-Max_speed(a4)
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsEnvironment_GateWaterEntryVelocityReductionAfterSuperSpeedChoice
                move.w  #$400,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$60,Deceleration-Max_speed(a4)

SKTailsEnvironment_GateWaterEntryVelocityReductionAfterSuperSpeedChoice:
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   SKTailsEnvironment_ReduceEntryVelocityAndRequestSplashOnlyForNonzeroQuarterY
                tst.b   object_control(a0)
                bne.s   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition

SKTailsEnvironment_ReduceEntryVelocityAndRequestSplashOnlyForNonzeroQuarterY:
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKTailsEnvironment_LeaveWaterRestoreAirSpeedsAndGateExitBoost:
                bclr    #Status_Underwater,status(a0)
                beq.w   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsEnvironment_GateWaterExitBoostAfterSuperSpeedRestoration
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

SKTailsEnvironment_GateWaterExitBoostAfterSuperSpeedRestoration:
                cmpi.b  #4,routine(a0)
                beq.s   SKTailsEnvironment_GateWaterExitSplashAndLimitFastUpwardVelocity
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   SKTailsEnvironment_DoubleExitYVelocityUnlessAlreadyFasterThanMinusFourHundred
                tst.b   object_control(a0)
                bne.s   SKTailsEnvironment_GateWaterExitSplashAndLimitFastUpwardVelocity

SKTailsEnvironment_DoubleExitYVelocityUnlessAlreadyFasterThanMinusFourHundred:
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   SKTailsEnvironment_GateWaterExitSplashAndLimitFastUpwardVelocity
                asl     y_vel(a0)

SKTailsEnvironment_GateWaterExitSplashAndLimitFastUpwardVelocity:
                cmpi.b  #$1C,anim(a0)
                beq.w   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition
                tst.w   y_vel(a0)
                beq.w   SKTailsEnvironment_ReturnAfterDisabledWaterOrHandledTransition
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   SKTailsEnvironment_TailPlayWaterExitSplashSound
                move.w  #-$1000,y_vel(a0)

SKTailsEnvironment_TailPlayWaterExitSplashSound:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Tails_Water

; ---------------------------------------------------------------------------

Tails_Stand_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsEnvironment_AdvanceGroundTailsAfterReleasingCarriedSonic
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsEnvironment_AdvanceGroundTailsAfterReleasingCarriedSonic:
                bsr.w   Tails_Spindash
                bsr.w   Tails_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Tails_InputAcceleration_Path
                bsr.w   Tails_Roll
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKTailsEnvironment_ReturnAfterGroundBackgroundChecksOrDisabledGate
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsEnvironment_CheckRightBackgroundWallAfterOptionalLeftCorrection
                sub.w   d1,x_pos(a0)

SKTailsEnvironment_CheckRightBackgroundWallAfterOptionalLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsEnvironment_RestoreGroundBackgroundProbeBasesAndReturn
                add.w   d1,x_pos(a0)

SKTailsEnvironment_RestoreGroundBackgroundProbeBasesAndReturn:
                movem.l (sp)+,a4-a6

SKTailsEnvironment_ReturnAfterGroundBackgroundChecksOrDisabledGate:
                rts
; ---------------------------------------------------------------------------

Tails_Stand_Freespace:
                tst.b   double_jump_flag(a0)
                bne.s   Tails_FlyingSwimming
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsEnvironment_ResolveOrdinaryAirAngleAndTerrainAfterGravityStep
                subi.w  #$28,y_vel(a0)

SKTailsEnvironment_ResolveOrdinaryAirAngleAndTerrainAfterGravityStep:
                bsr.w   Player_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts
; ---------------------------------------------------------------------------

Tails_FlyingSwimming:
                bsr.w   Tails_Move_FlySwim
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                tst.w   (Player_mode).w
                bne.s   SKTailsEnvironment_ReturnAfterNormalFlightTerrainAndOptionalCarry
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.w   Tails_Carry_Sonic

SKTailsEnvironment_ReturnAfterNormalFlightTerrainAndOptionalCarry:
                rts

; Owner: objects/players/sonic/sk
; Responsibility: Sonic water transitions and ground, air, rolling and jumping mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Water:
                tst.b   (Water_flag).w                  ; does level have water?
                bne.s   Sonic_InWater                   ; if yes, branch

SKSonicEnvironment_ReturnFromWaterTransitionCheck:
                rts
; ---------------------------------------------------------------------------

Sonic_InWater:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0                    ; is Sonic above the water?
                bge.s   Sonic_OutWater                  ; if yes, branch

                bset    #Status_Underwater,status(a0)   ; set underwater flag
                bne.s   SKSonicEnvironment_ReturnFromWaterTransitionCheck  ; if already underwater, branch

                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.l  #Obj_AirCountdown,(Breathing_bubbles).w  ; load Sonic's breathing bubbles
                move.b  #$81,(Breathing_bubbles+subtype).w
                move.l  a0,(Breathing_bubbles+objoff_40).w
                move.w  #$300,Max_speed-Max_speed(a4)
                move.w  #6,Acceleration-Max_speed(a4)
                move.w  #$40,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicEnvironment_DampenWaterEntryVelocityUnlessObjectControlled  ; if Super/Hyper, set different values
                move.w  #$500,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)

SKSonicEnvironment_DampenWaterEntryVelocityUnlessObjectControlled:
                tst.b   object_control(a0)
                bne.s   SKSonicEnvironment_ReturnFromWaterTransitionCheck
                asr     x_vel(a0)
                asr     y_vel(a0)                       ; memory operands can only be shifted one bit at a time
                asr     y_vel(a0)
                beq.s   SKSonicEnvironment_ReturnFromWaterTransitionCheck
                move.w  #1<<8,anim(a6)                  ; splash animation, write 1 to anim and clear prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

Sonic_OutWater:
                bclr    #Status_Underwater,status(a0)   ; unset underwater flag
                beq.w   SKSonicEnvironment_ReturnFromWaterTransitionCheck  ; if already above water, branch
                addq.b  #1,(Water_entered_counter).w

                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicEnvironment_DoubleWaterExitYVelocityWhenEligible  ; if Super/Hyper, set different values
                move.w  #$A00,Max_speed-Max_speed(a4)
                move.w  #$30,Acceleration-Max_speed(a4)
                move.w  #$100,Deceleration-Max_speed(a4)

SKSonicEnvironment_DoubleWaterExitYVelocityWhenEligible:
                cmpi.b  #4,routine(a0)                  ; is Sonic falling back from getting hurt?
                beq.s   SKSonicEnvironment_GateWaterExitSplashAndClampNegativeYVelocity  ; if yes, branch
                tst.b   object_control(a0)
                bne.s   SKSonicEnvironment_GateWaterExitSplashAndClampNegativeYVelocity
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   SKSonicEnvironment_GateWaterExitSplashAndClampNegativeYVelocity
                asl     y_vel(a0)

SKSonicEnvironment_GateWaterExitSplashAndClampNegativeYVelocity:
                cmpi.b  #$1C,anim(a0)                   ; is Sonic in his 'blank' animation?
                beq.w   SKSonicEnvironment_ReturnFromWaterTransitionCheck  ; if so, branch
                tst.w   y_vel(a0)
                beq.w   SKSonicEnvironment_ReturnFromWaterTransitionCheck
                move.w  #1<<8,anim(a6)                  ; splash animation, write 1 to anim and clear prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   SKSonicEnvironment_PlayWaterExitSplashSound
                move.w  #-$1000,y_vel(a0)               ; limit upward y velocity exiting the water

SKSonicEnvironment_PlayWaterExitSplashSound:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Sonic_Water

; ---------------------------------------------------------------------------
; Start of subroutine Obj01_MdNormal
; Called if Sonic is neither airborne nor rolling this frame
; ---------------------------------------------------------------------------

Sonic_MdNormal:
                bsr.w   SonicKnux_Spindash
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicKnux_Roll
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKSonicEnvironment_ReturnAfterNormalGroundBackgroundChecks
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicEnvironment_CheckNormalGroundRightWallAfterLeftCorrection
                sub.w   d1,x_pos(a0)

SKSonicEnvironment_CheckNormalGroundRightWallAfterLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicEnvironment_RestoreNormalGroundRegistersAfterBothWallChecks
                add.w   d1,x_pos(a0)

SKSonicEnvironment_RestoreNormalGroundRegistersAfterBothWallChecks:
                movem.l (sp)+,a4-a6

SKSonicEnvironment_ReturnAfterNormalGroundBackgroundChecks:
                rts

; =============== S U B R O U T I N E =======================================

Call_Player_AnglePos:
                tst.b   (Reverse_gravity_flag).w
                beq.w   Player_AnglePos
                move.b  angle(a0),d0
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0
                move.b  d0,angle(a0)
                bsr.w   Player_AnglePos
                move.b  angle(a0),d0
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0
                move.b  d0,angle(a0)
                rts
; End of function Call_Player_AnglePos

; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdAir
; Called if Sonic is airborne, but not in a ball (thus, probably not jumping)

Sonic_MdAir:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)   ; is Sonic underwater?
                beq.s   SKSonicEnvironment_FinishAirModeWithAngleAndTerrainCollision  ; if not, branch
                subi.w  #$28,y_vel(a0)                  ; reduce gravity by $28 ($38-$28=$10)

SKSonicEnvironment_FinishAirModeWithAngleAndTerrainCollision:
                bsr.w   Player_JumpAngle
                bsr.w   SonicKnux_DoLevelCollision
                rts
; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdRoll
; Called if Sonic is in a ball, but not airborne (thus, probably rolling)

Sonic_MdRoll:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicEnvironment_ContinueGroundRollAfterOptionalJump
                bsr.w   Sonic_Jump

SKSonicEnvironment_ContinueGroundRollAfterOptionalJump:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKSonicEnvironment_ReturnAfterGroundRollBackgroundChecks
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicEnvironment_CheckGroundRollRightWallAfterLeftCorrection
                sub.w   d1,x_pos(a0)

SKSonicEnvironment_CheckGroundRollRightWallAfterLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicEnvironment_RestoreGroundRollRegistersAfterBothWallChecks
                add.w   d1,x_pos(a0)

SKSonicEnvironment_RestoreGroundRollRegistersAfterBothWallChecks:
                movem.l (sp)+,a4-a6

SKSonicEnvironment_ReturnAfterGroundRollBackgroundChecks:
                rts
; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdJump
; Called if Sonic is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Sonic_MdAir, at least at this outer level
; Why they gave it a separate copy of the code, I don't know

Sonic_MdJump:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)   ; is Sonic underwater?
                beq.s   SKSonicEnvironment_FinishBallAirModeWithAngleAndTerrainCollision  ; if not, branch
                subi.w  #$28,y_vel(a0)                  ; reduce gravity by $28 ($38-$28=$10)

SKSonicEnvironment_FinishBallAirModeWithAngleAndTerrainCollision:
                bsr.w   Player_JumpAngle
                bsr.w   SonicKnux_DoLevelCollision
                rts

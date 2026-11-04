; Owner: objects/players/tails/sk
; Responsibility: Tails water transitions and ground, air, rolling, jumping, flying and swimming mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Water:
                tst.b   (Water_flag).w
                bne.s   SKTailsEnv_CheckWaterAndInitEntry

SKTailsEnv_WaterTransitionReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsEnv_CheckWaterAndInitEntry:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   SKTailsEnv_RestoreAirAndSpeedsOnExit
                bset    #Status_Underwater,status(a0)
                bne.s   SKTailsEnv_WaterTransitionReturn
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
                beq.s   SKTailsEnv_CheckEntryDamping
                move.w  #$400,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$60,Deceleration-Max_speed(a4)

SKTailsEnv_CheckEntryDamping:
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   SKTailsEnv_DampenEntryAndCheckSplash
                tst.b   object_control(a0)
                bne.s   SKTailsEnv_WaterTransitionReturn

; Halve X speed and quarter Y speed. The splash requires a nonzero reduced Y speed
SKTailsEnv_DampenEntryAndCheckSplash:
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   SKTailsEnv_WaterTransitionReturn
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKTailsEnv_RestoreAirAndSpeedsOnExit:
                bclr    #Status_Underwater,status(a0)
                beq.w   SKTailsEnv_WaterTransitionReturn
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsEnv_CheckExitBoost
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

SKTailsEnv_CheckExitBoost:
                cmpi.b  #4,routine(a0)
                beq.s   SKTailsEnv_CheckExitSplashAndClampY
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   SKTailsEnv_TryDoubleExitYSpeed
                tst.b   object_control(a0)
                bne.s   SKTailsEnv_CheckExitSplashAndClampY

; Double Y speed only when it is at least -$400
SKTailsEnv_TryDoubleExitYSpeed:
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   SKTailsEnv_CheckExitSplashAndClampY
                asl     y_vel(a0)

SKTailsEnv_CheckExitSplashAndClampY:
                cmpi.b  #$1C,anim(a0)
                beq.w   SKTailsEnv_WaterTransitionReturn
                tst.w   y_vel(a0)
                beq.w   SKTailsEnv_WaterTransitionReturn
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   SKTailsEnv_PlayExitSplash
                move.w  #-$1000,y_vel(a0)

SKTailsEnv_PlayExitSplash:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Tails_Water

; ---------------------------------------------------------------------------

Tails_Stand_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsEnv_RunGroundMovement
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsEnv_RunGroundMovement:
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
                beq.s   SKTailsEnv_GroundModeReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsEnv_CheckGroundRightWall
                sub.w   d1,x_pos(a0)

SKTailsEnv_CheckGroundRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsEnv_RestoreGroundWallRegisters
                add.w   d1,x_pos(a0)

SKTailsEnv_RestoreGroundWallRegisters:
                movem.l (sp)+,a4-a6

SKTailsEnv_GroundModeReturn:
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
                beq.s   SKTailsEnv_AirAngleAndCollision
                subi.w  #$28,y_vel(a0)

SKTailsEnv_AirAngleAndCollision:
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
                bne.s   SKTailsEnv_FlightModeReturn
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.w   Tails_Carry_Sonic

SKTailsEnv_FlightModeReturn:
                rts

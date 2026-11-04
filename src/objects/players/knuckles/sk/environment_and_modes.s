; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles water transitions and standing, rolling and general movement mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knuckles_Water:
                tst.b   (Water_flag).w
                bne.s   SKKnuxEnv_CheckWaterAndInitEntry

SKKnuxEnv_WaterTransitionReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxEnv_CheckWaterAndInitEntry:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   SKKnuxEnv_RestoreAirAndSpeedsOnExit
                bset    #Status_Underwater,status(a0)
                bne.s   SKKnuxEnv_WaterTransitionReturn
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.l  #Obj_AirCountdown,(Breathing_bubbles).w
                move.b  #$81,(Breathing_bubbles+subtype).w
                move.l  a0,(Breathing_bubbles+$40).w
                move.w  #$300,Max_speed-Max_speed(a4)
                move.w  #6,Acceleration-Max_speed(a4)
                move.w  #$40,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnuxEnv_DampenWaterEntry
                move.w  #$400,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$60,Deceleration-Max_speed(a4)

SKKnuxEnv_DampenWaterEntry:
                tst.b   object_control(a0)
                bne.s   SKKnuxEnv_WaterTransitionReturn
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   SKKnuxEnv_WaterTransitionReturn
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKKnuxEnv_RestoreAirAndSpeedsOnExit:
                bclr    #Status_Underwater,status(a0)
                beq.w   SKKnuxEnv_WaterTransitionReturn
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnuxEnv_TryDoubleExitYSpeed
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

SKKnuxEnv_TryDoubleExitYSpeed:
                cmpi.b  #4,routine(a0)
                beq.s   SKKnuxEnv_CheckExitSplashAndClampY
                tst.b   object_control(a0)
                bne.s   SKKnuxEnv_CheckExitSplashAndClampY
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   SKKnuxEnv_CheckExitSplashAndClampY
                asl     y_vel(a0)

SKKnuxEnv_CheckExitSplashAndClampY:
                cmpi.b  #$1C,anim(a0)
                beq.w   SKKnuxEnv_WaterTransitionReturn
                tst.w   y_vel(a0)
                beq.w   SKKnuxEnv_WaterTransitionReturn
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   SKKnuxEnv_PlayExitSplash
                move.w  #-$1000,y_vel(a0)

SKKnuxEnv_PlayExitSplash:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Knuckles_Water

; ---------------------------------------------------------------------------

Knux_Stand_Path:
                bsr.w   SonicKnux_Spindash
                bsr.w   Knux_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Knux_InputAcceleration_Path
                bsr.w   SonicKnux_Roll
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKKnuxEnv_GroundModeReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnuxEnv_CheckGroundRightWall
                sub.w   d1,x_pos(a0)

SKKnuxEnv_CheckGroundRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnuxEnv_RestoreGroundWallRegisters
                add.w   d1,x_pos(a0)

SKKnuxEnv_RestoreGroundWallRegisters:
                movem.l (sp)+,a4-a6

SKKnuxEnv_GroundModeReturn:
                rts

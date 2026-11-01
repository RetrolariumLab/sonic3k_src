; Owner: objects/players/tails/s3
; Responsibility: Tails water transitions and ground, air, rolling, jumping, flying and swimming mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Water:
                tst.b   (Water_flag).w
                bne.s   loc_1528C

locret_1528A:
                rts
; ---------------------------------------------------------------------------

loc_1528C:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_152F6
                bset    #Status_Underwater,status(a0)
                bne.s   locret_1528A
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.l  #Obj_AirCountdown,(Breathing_bubbles_P2).w
                move.b  #$81,(Breathing_bubbles_P2+subtype).w
                move.l  a0,(Breathing_bubbles_P2+$40).w
                move.w  #$300,Max_speed-Max_speed(a4)
                move.w  #6,Acceleration-Max_speed(a4)
                move.w  #$40,Deceleration-Max_speed(a4)
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   loc_152D8
                tst.b   object_control(a0)
                bne.s   locret_1528A

loc_152D8:
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   locret_1528A
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_152F6:
                bclr    #Status_Underwater,status(a0)
                beq.s   locret_1528A
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                cmpi.b  #4,routine(a0)
                beq.s   loc_1533C
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   loc_1532E
                tst.b   object_control(a0)
                bne.s   loc_1533C

loc_1532E:
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   loc_1533C
                asl     y_vel(a0)

loc_1533C:
                cmpi.b  #$1C,anim(a0)
                beq.w   locret_1528A
                tst.w   y_vel(a0)
                beq.w   locret_1528A
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   loc_15362
                move.w  #-$1000,y_vel(a0)

loc_15362:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Tails_Water

; ---------------------------------------------------------------------------

Tails_Stand_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_15384
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_15384:
                bsr.w   Tails_Spindash
                bsr.w   Tails_Jump
                bsr.w   Tails_SlopeResist
                bsr.w   Tails_InputAcceleration_Path
                bsr.w   Tails_Roll
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   locret_153CE
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_153CE
                sub.w   d1,x_pos(a0)

locret_153CE:
                rts
; ---------------------------------------------------------------------------

Tails_Stand_Freespace:
                tst.b   double_jump_flag(a0)
                bne.s   Tails_FlyingSwimming
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_153F6
                subi.w  #$28,y_vel(a0)

loc_153F6:
                bsr.w   Tails_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts
; ---------------------------------------------------------------------------

Tails_FlyingSwimming:
                bsr.w   Tails_Move_FlySwim
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite2).l
                bsr.w   Tails_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                tst.w   (Player_mode).w
                bne.s   locret_15438
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.w   Tails_Carry_Sonic

locret_15438:
                rts

; Owner: objects/players/tails/sk
; Responsibility: Tails water transitions and ground, air, rolling, jumping, flying and swimming mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Water:
                tst.b   (Water_flag).w
                bne.s   loc_1463A

locret_14638:
                rts
; ---------------------------------------------------------------------------

loc_1463A:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_146BA
                bset    #Status_Underwater,status(a0)
                bne.s   locret_14638
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
                beq.s   loc_1468E
                move.w  #$400,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$60,Deceleration-Max_speed(a4)

loc_1468E:
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   loc_1469C
                tst.b   object_control(a0)
                bne.s   locret_14638

loc_1469C:
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   locret_14638
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_146BA:
                bclr    #Status_Underwater,status(a0)
                beq.w   locret_14638
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Tails_flag).w
                beq.s   loc_146F4
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

loc_146F4:
                cmpi.b  #4,routine(a0)
                beq.s   loc_14718
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   loc_1470A
                tst.b   object_control(a0)
                bne.s   loc_14718

loc_1470A:
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   loc_14718
                asl     y_vel(a0)

loc_14718:
                cmpi.b  #$1C,anim(a0)
                beq.w   locret_14638
                tst.w   y_vel(a0)
                beq.w   locret_14638
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   loc_1473E
                move.w  #-$1000,y_vel(a0)

loc_1473E:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Tails_Water

; ---------------------------------------------------------------------------

Tails_Stand_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_14760
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_14760:
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
                beq.s   locret_147B6
                bsr.w   sub_F846
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_147A6
                sub.w   d1,x_pos(a0)

loc_147A6:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_147B2
                add.w   d1,x_pos(a0)

loc_147B2:
                movem.l (sp)+,a4-a6

locret_147B6:
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
                beq.s   loc_147DE
                subi.w  #$28,y_vel(a0)

loc_147DE:
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
                bne.s   locret_14820
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.w   Tails_Carry_Sonic

locret_14820:
                rts

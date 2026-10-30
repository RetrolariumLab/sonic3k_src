; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles water transitions and standing, rolling and general movement mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knuckles_Water:
                tst.b   (Water_flag).w
                bne.s   loc_166F6

locret_166F4:
                rts
; ---------------------------------------------------------------------------

loc_166F6:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_1676E
                bset    #Status_Underwater,status(a0)
                bne.s   locret_166F4
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
                beq.s   loc_1674A
                move.w  #$400,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$60,Deceleration-Max_speed(a4)

loc_1674A:
                tst.b   object_control(a0)
                bne.s   locret_166F4
                asr     x_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                beq.s   locret_166F4
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_1676E:
                bclr    #Status_Underwater,status(a0)
                beq.w   locret_166F4
                addq.b  #1,(Water_entered_counter).w
                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_167A8
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

loc_167A8:
                cmpi.b  #4,routine(a0)
                beq.s   loc_167C4
                tst.b   object_control(a0)
                bne.s   loc_167C4
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   loc_167C4
                asl     y_vel(a0)

loc_167C4:
                cmpi.b  #$1C,anim(a0)
                beq.w   locret_166F4
                tst.w   y_vel(a0)
                beq.w   locret_166F4
                move.w  #1<<8,anim(a6)                  ; and prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   loc_167EA
                move.w  #-$1000,y_vel(a0)

loc_167EA:
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
                beq.s   locret_1684A
                bsr.w   sub_F846
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_1683A
                sub.w   d1,x_pos(a0)

loc_1683A:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_16846
                add.w   d1,x_pos(a0)

loc_16846:
                movem.l (sp)+,a4-a6

locret_1684A:
                rts

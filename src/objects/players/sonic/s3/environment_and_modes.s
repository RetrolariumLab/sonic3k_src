; Owner: objects/players/sonic/s3
; Responsibility: Sonic water transitions and ground, air, rolling and jumping mode dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Water:
                tst.b   (Water_flag).w                  ; does level have water?
                bne.s   Sonic_InWater                   ; if yes, branch

locret_11F32:
                rts
; ---------------------------------------------------------------------------

Sonic_InWater:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0                    ; is Sonic above the water?
                bge.s   Sonic_OutWater                  ; if yes, branch

                bset    #Status_Underwater,status(a0)   ; set underwater flag
                bne.s   locret_11F32                    ; if already underwater, branch

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
                beq.s   loc_11F88
                move.w  #$500,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)

loc_11F88:
                tst.b   object_control(a0)
                bne.s   locret_11F32
                asr     x_vel(a0)
                asr     y_vel(a0)                       ; memory operands can only be shifted one bit at a time
                asr     y_vel(a0)
                beq.s   locret_11F32
                move.w  #1<<8,anim(a6)                  ; splash animation, write 1 to anim and clear prev_anim
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

Sonic_OutWater:
                bclr    #Status_Underwater,status(a0)   ; unset underwater flag
                beq.w   locret_11F32                    ; if already above water, branch
                addq.b  #1,(Water_entered_counter).w

                movea.l a0,a1
                bsr.w   Player_ResetAirTimer
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_11FE6                       ; if Super, set different values
                move.w  #$A00,Max_speed-Max_speed(a4)
                move.w  #$30,Acceleration-Max_speed(a4)
                move.w  #$100,Deceleration-Max_speed(a4)

loc_11FE6:
                cmpi.b  #4,routine(a0)                  ; is Sonic falling back from getting hurt?
                beq.s   loc_12002                       ; if yes, branch
                tst.b   object_control(a0)
                bne.s   loc_12002
                move.w  y_vel(a0),d0
                cmpi.w  #-$400,d0
                blt.s   loc_12002
                asl     y_vel(a0)

loc_12002:
                cmpi.b  #$1C,anim(a0)                   ; is Sonic in his 'blank' animation?
                beq.w   locret_11F32                    ; if so, branch
                tst.w   y_vel(a0)
                beq.w   locret_11F32
                move.w  #1<<8,anim(a6)                  ; splash animation, write 1 to anim and clear prev_anim
                cmpi.w  #-$1000,y_vel(a0)
                bgt.s   loc_12028
                move.w  #-$1000,y_vel(a0)               ; limit upward y velocity exiting the water

loc_12028:
                move.w  #sfx_Splash,d0
                jmp     (Play_SFX).l
; End of function Sonic_Water

; ---------------------------------------------------------------------------
; Start of subroutine Obj01_MdNormal
; Called if Sonic is neither airborne nor rolling this frame
; ---------------------------------------------------------------------------

Sonic_MdNormal:
                bsr.w   Sonic_Spindash
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   Sonic_Roll
                bsr.w   Player_LevelBound
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   locret_1207C
                bsr.w   sub_10BA2
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_1207C
                sub.w   d1,x_pos(a0)

locret_1207C:
                rts
; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdAir
; Called if Sonic is airborne, but not in a ball (thus, probably not jumping)

Sonic_MdAir:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                bsr.w   Player_LevelBound
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)   ; is Sonic underwater?
                beq.s   loc_1209E                       ; if not, branch
                subi.w  #$28,y_vel(a0)                  ; reduce gravity by $28 ($38-$28=$10)

loc_1209E:
                bsr.w   Player_JumpAngle
                bsr.w   Sonic_DoLevelCollision
                rts
; ---------------------------------------------------------------------------
; Start of subroutine Sonic_MdRoll
; Called if Sonic is in a ball, but not airborne (thus, probably rolling)

Sonic_MdRoll:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_120B2
                bsr.w   Sonic_Jump

loc_120B2:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                bsr.w   Player_LevelBound
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   locret_120F0
                bsr.w   sub_10BA2
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_120F0
                sub.w   d1,x_pos(a0)

locret_120F0:
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
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)   ; is Sonic underwater?
                beq.s   loc_12112                       ; if not, branch
                subi.w  #$28,y_vel(a0)                  ; reduce gravity by $28 ($38-$28=$10)

loc_12112:
                bsr.w   Player_JumpAngle
                bsr.w   Sonic_DoLevelCollision
                rts

; Owner: objects/players/tails/s3
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   S3TailsFly_TickFlap
                tst.b   double_jump_property(a0)
                beq.s   S3TailsFly_TickFlap
                subq.b  #1,double_jump_property(a0)

S3TailsFly_TickFlap:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   S3TailsFly_CheckNewFlap
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsFly_ResetFlapToWaiting
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   S3TailsFly_AfterActiveFlap

S3TailsFly_ResetFlapToWaiting:
                move.b  #1,double_jump_flag(a0)

S3TailsFly_AfterActiveFlap:
                bra.s   S3TailsFly_ClampAscentAtCameraCeiling
; ---------------------------------------------------------------------------

; A new flap needs a fresh button press and remaining flight budget. Underwater, carrying a rider also blocks it
S3TailsFly_CheckNewFlap:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   S3TailsFly_ApplyWaitingGravity
                cmpi.w  #-$100,y_vel(a0)
                blt.s   S3TailsFly_ApplyWaitingGravity
                tst.b   double_jump_property(a0)
                beq.s   S3TailsFly_ApplyWaitingGravity
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsFly_StartFlapCounter
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   S3TailsFly_ApplyWaitingGravity

S3TailsFly_StartFlapCounter:
                move.b  #2,double_jump_flag(a0)

S3TailsFly_ApplyWaitingGravity:
                addi.w  #8,y_vel(a0)

S3TailsFly_ClampAscentAtCameraCeiling:
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
                bne.s   S3TailsFly_PickSwimAnimFromYSpeed
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   S3TailsFly_StoreFlightAnimAndCheckSound
                tst.w   y_vel(a0)
                bpl.s   S3TailsFly_ChooseDryCarryAnim
                moveq   #$21,d0

S3TailsFly_ChooseDryCarryAnim:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFly_CheckTiredFlight
                addq.b  #2,d0

S3TailsFly_CheckTiredFlight:
                tst.b   double_jump_property(a0)
                bne.s   S3TailsFly_StoreFlightAnimAndCheckSound
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   S3TailsFly_TiredFlightReturn
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsFly_TiredFlightReturn
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

S3TailsFly_TiredFlightReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsFly_StoreFlightAnimAndCheckSound:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   S3TailsFly_DryFlightReturn
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   S3TailsFly_DryFlightReturn
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

S3TailsFly_DryFlightReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsFly_PickSwimAnimFromYSpeed:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   S3TailsFly_PickCarrySwimAnim
                moveq   #$26,d0

S3TailsFly_PickCarrySwimAnim:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFly_PickTiredSwimAnim
                moveq   #$27,d0

S3TailsFly_PickTiredSwimAnim:
                tst.b   double_jump_property(a0)
                bne.s   S3TailsFly_StoreSwimAnim
                moveq   #$28,d0

S3TailsFly_StoreSwimAnim:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFly_TryGroundRollJump
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsFly_TryGroundRollJump:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsFly_RunGroundRollAndProbe
                bsr.w   Tails_Jump

S3TailsFly_RunGroundRollAndProbe:
                bsr.w   Tails_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsFly_GroundRollReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsFly_GroundRollReturn
                sub.w   d1,x_pos(a0)

S3TailsFly_GroundRollReturn:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsFly_RunAirRollMotion
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsFly_RunAirRollMotion:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsFly_ResolveAirRollTerrain
                subi.w  #$28,y_vel(a0)

S3TailsFly_ResolveAirRollTerrain:
                bsr.w   Tails_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

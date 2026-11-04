; Owner: objects/players/tails/sk
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   SKTailsFly_TickFlap
                tst.b   double_jump_property(a0)
                beq.s   SKTailsFly_TickFlap
                subq.b  #1,double_jump_property(a0)

SKTailsFly_TickFlap:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   SKTailsFly_CheckNewFlap
                cmpi.w  #-$100,y_vel(a0)
                blt.s   SKTailsFly_ResetFlapToWaiting
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   SKTailsFly_AfterActiveFlap

SKTailsFly_ResetFlapToWaiting:
                move.b  #1,double_jump_flag(a0)

SKTailsFly_AfterActiveFlap:
                bra.s   SKTailsFly_ClampAscentAtCameraCeiling
; ---------------------------------------------------------------------------

; A new flap needs a fresh button press and remaining flight budget. Underwater, carrying a rider also blocks it
SKTailsFly_CheckNewFlap:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKTailsFly_ApplyWaitingGravity
                cmpi.w  #-$100,y_vel(a0)
                blt.s   SKTailsFly_ApplyWaitingGravity
                tst.b   double_jump_property(a0)
                beq.s   SKTailsFly_ApplyWaitingGravity
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsFly_StartFlapCounter
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   SKTailsFly_ApplyWaitingGravity

SKTailsFly_StartFlapCounter:
                move.b  #2,double_jump_flag(a0)

SKTailsFly_ApplyWaitingGravity:
                addi.w  #8,y_vel(a0)

SKTailsFly_ClampAscentAtCameraCeiling:
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
                bne.s   SKTailsFly_PickSwimAnimFromYSpeed
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   SKTailsFly_StoreFlightAnimAndCheckSound
                tst.w   y_vel(a0)
                bpl.s   SKTailsFly_ChooseDryCarryAnim
                moveq   #$21,d0

SKTailsFly_ChooseDryCarryAnim:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFly_CheckTiredFlight
                addq.b  #2,d0

SKTailsFly_CheckTiredFlight:
                tst.b   double_jump_property(a0)
                bne.s   SKTailsFly_StoreFlightAnimAndCheckSound
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   SKTailsFly_TiredFlightReturn
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   SKTailsFly_TiredFlightReturn
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

SKTailsFly_TiredFlightReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsFly_StoreFlightAnimAndCheckSound:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   SKTailsFly_DryFlightReturn
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   SKTailsFly_DryFlightReturn
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

SKTailsFly_DryFlightReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsFly_PickSwimAnimFromYSpeed:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   SKTailsFly_PickCarrySwimAnim
                moveq   #$26,d0

SKTailsFly_PickCarrySwimAnim:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFly_PickTiredSwimAnim
                moveq   #$27,d0

SKTailsFly_PickTiredSwimAnim:
                tst.b   double_jump_property(a0)
                bne.s   SKTailsFly_StoreSwimAnim
                moveq   #$28,d0

SKTailsFly_StoreSwimAnim:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFly_TryGroundRollJump
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsFly_TryGroundRollJump:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsFly_RunGroundRollAndProbe
                bsr.w   Tails_Jump

SKTailsFly_RunGroundRollAndProbe:
                bsr.w   Player_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKTailsFly_GroundRollReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsFly_ProbeRightBackgroundWall
                sub.w   d1,x_pos(a0)

SKTailsFly_ProbeRightBackgroundWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsFly_RestoreWallProbeRegisters
                add.w   d1,x_pos(a0)

SKTailsFly_RestoreWallProbeRegisters:
                movem.l (sp)+,a4-a6

SKTailsFly_GroundRollReturn:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsFly_RunAirRollMotion
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsFly_RunAirRollMotion:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsFly_ResolveAirRollTerrain
                subi.w  #$28,y_vel(a0)

SKTailsFly_ResolveAirRollTerrain:
                bsr.w   Player_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

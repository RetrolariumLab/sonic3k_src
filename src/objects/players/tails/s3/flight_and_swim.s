; Owner: objects/players/tails/s3
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   loc_1544E
                tst.b   double_jump_property(a0)
                beq.s   loc_1544E
                subq.b  #1,double_jump_property(a0)

loc_1544E:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   loc_15478
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_15470
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   loc_15476

loc_15470:
                move.b  #1,double_jump_flag(a0)

loc_15476:
                bra.s   loc_154AA
; ---------------------------------------------------------------------------

loc_15478:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_154A4
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_154A4
                tst.b   double_jump_property(a0)
                beq.s   loc_154A4
                btst    #Status_Underwater,status(a0)
                beq.s   loc_1549E
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_154A4

loc_1549E:
                move.b  #2,double_jump_flag(a0)

loc_154A4:
                addi.w  #8,y_vel(a0)

loc_154AA:
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
                bne.s   loc_1552C
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   loc_1550C
                tst.w   y_vel(a0)
                bpl.s   loc_154DC
                moveq   #$21,d0

loc_154DC:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_154E4
                addq.b  #2,d0

loc_154E4:
                tst.b   double_jump_property(a0)
                bne.s   loc_1550C
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   locret_1550A
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_1550A
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

locret_1550A:
                rts
; ---------------------------------------------------------------------------

loc_1550C:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   locret_1552A
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_1552A
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

locret_1552A:
                rts
; ---------------------------------------------------------------------------

loc_1552C:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   loc_15536
                moveq   #$26,d0

loc_15536:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_1553E
                moveq   #$27,d0

loc_1553E:
                tst.b   double_jump_property(a0)
                bne.s   loc_15546
                moveq   #$28,d0

loc_15546:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_15564
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_15564:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_1556E
                bsr.w   Tails_Jump

loc_1556E:
                bsr.w   Tails_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Tails_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   locret_155AC
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_155AC
                sub.w   d1,x_pos(a0)

locret_155AC:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_155C6
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_155C6:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_155E6
                subi.w  #$28,y_vel(a0)

loc_155E6:
                bsr.w   Tails_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

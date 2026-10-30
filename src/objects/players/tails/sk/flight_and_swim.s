; Owner: objects/players/tails/sk
; Responsibility: Tails flight and swimming motion, exhaustion state and flight animation selection
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Move_FlySwim:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   loc_14836
                tst.b   double_jump_property(a0)
                beq.s   loc_14836
                subq.b  #1,double_jump_property(a0)

loc_14836:
                cmpi.b  #1,double_jump_flag(a0)
                beq.s   loc_14860
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_14858
                subi.w  #$20,y_vel(a0)
                addq.b  #1,double_jump_flag(a0)
                cmpi.b  #$20,double_jump_flag(a0)
                bne.s   loc_1485E

loc_14858:
                move.b  #1,double_jump_flag(a0)

loc_1485E:
                bra.s   loc_14892
; ---------------------------------------------------------------------------

loc_14860:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_1488C
                cmpi.w  #-$100,y_vel(a0)
                blt.s   loc_1488C
                tst.b   double_jump_property(a0)
                beq.s   loc_1488C
                btst    #Status_Underwater,status(a0)
                beq.s   loc_14886
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   loc_1488C

loc_14886:
                move.b  #2,double_jump_flag(a0)

loc_1488C:
                addi.w  #8,y_vel(a0)

loc_14892:
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
                bne.s   loc_14914
                moveq   #$20,d0
                tst.w   (Competition_mode).w
                bne.s   loc_148F4
                tst.w   y_vel(a0)
                bpl.s   loc_148C4
                moveq   #$21,d0

loc_148C4:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_148CC
                addq.b  #2,d0

loc_148CC:
                tst.b   double_jump_property(a0)
                bne.s   loc_148F4
                moveq   #$24,d0
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   locret_148F2
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_148F2
                moveq   #signextendB(sfx_FlyTired),d0
                jsr     (Play_SFX).l

locret_148F2:
                rts
; ---------------------------------------------------------------------------

loc_148F4:
                move.b  d0,anim(a0)
                tst.b   render_flags(a0)
                bpl.s   locret_14912
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #8,d0
                andi.b  #$F,d0
                bne.s   locret_14912
                moveq   #signextendB(sfx_Flying),d0
                jsr     (Play_SFX).l

locret_14912:
                rts
; ---------------------------------------------------------------------------

loc_14914:
                moveq   #$25,d0
                tst.w   y_vel(a0)
                bpl.s   loc_1491E
                moveq   #$26,d0

loc_1491E:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_14926
                moveq   #$27,d0

loc_14926:
                tst.b   double_jump_property(a0)
                bne.s   loc_1492E
                moveq   #$28,d0

loc_1492E:
                move.b  d0,anim(a0)
                rts
; End of function Tails_Set_Flying_Animation

; ---------------------------------------------------------------------------

Tails_Spin_Path:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_1494C
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_1494C:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_14956
                bsr.w   Tails_Jump

loc_14956:
                bsr.w   Player_RollRepel
                bsr.w   Tails_RollSpeed
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   locret_149A0
                bsr.w   sub_F846
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_14990
                sub.w   d1,x_pos(a0)

loc_14990:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_1499C
                add.w   d1,x_pos(a0)

loc_1499C:
                movem.l (sp)+,a4-a6

locret_149A0:
                rts
; ---------------------------------------------------------------------------

Tails_Spin_Freespace:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_149BA
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_149BA:
                bsr.w   Tails_JumpHeight
                bsr.w   Tails_InputAcceleration_Freespace
                bsr.w   Tails_Check_Screen_Boundaries
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   loc_149DA
                subi.w  #$28,y_vel(a0)

loc_149DA:
                bsr.w   Player_JumpAngle
                bsr.w   Tails_DoLevelCollision
                rts

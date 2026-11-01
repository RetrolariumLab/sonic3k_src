; Owner: objects/zones/dez/sk
; Responsibility: Gravity room player control, transition and movement response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravityRoom:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d4
                bsr.s   UpdatePlayerInDezGravityRoom
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d4
                bsr.s   UpdatePlayerInDezGravityRoom
                move.w  x_pos(a0),d0
                addi.w  #$400,d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$680,d0
                bhi.w   loc_49638
                rts
; ---------------------------------------------------------------------------

loc_49638:
                move.w  respawn_addr(a0),d0
                beq.s   loc_49644
                movea.w d0,a2
                bclr    #7,(a2)

loc_49644:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezGravityRoom:
                tst.b   (a2)
                bne.s   loc_496A8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$500,d0
                bhs.s   locret_496A6
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$140,d0
                cmpi.w  #$280,d0
                bhs.s   locret_496A6
                tst.w   (Debug_placement_mode).w
                bne.s   locret_496A6
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #-1,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bclr    #Status_RollJump,status(a1)
                clr.b   jumping(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)

locret_496A6:
                rts
; ---------------------------------------------------------------------------

loc_496A8:
                tst.w   (Debug_placement_mode).w
                bne.s   loc_496BC
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$500,d0
                blo.s   loc_496C8

loc_496BC:
                move.b  #0,object_control(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

loc_496C8:
                addi.w  #$38,x_vel(a1)
                move.w  #$600,d6
                move.w  #$18,d5
                move.w  y_vel(a1),d0
                btst    #button_up+8,d4
                beq.s   loc_496F2
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_496F2
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_496F2
                move.w  d1,d0

loc_496F2:
                btst    #button_down+8,d4
                beq.s   loc_49706
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_49706
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_49706
                move.w  d6,d0

loc_49706:
                move.w  d0,y_vel(a1)
                move.w  y_vel(a1),d0
                move.w  d0,d1
                asr.w   #5,d1
                beq.s   loc_49730
                bmi.s   loc_49724
                sub.w   d1,d0
                bcc.s   loc_4971E
                move.w  #0,d0

loc_4971E:
                move.w  d0,y_vel(a1)
                bra.s   loc_49730
; ---------------------------------------------------------------------------

loc_49724:
                sub.w   d1,d0
                bcs.s   loc_4972C
                move.w  #0,d0

loc_4972C:
                move.w  d0,y_vel(a1)

loc_49730:
                movem.l d0-a6,-(sp)
                movea.l a1,a0
                jsr     (MoveSprite2).l
                jsr     (Player_JumpAngle).l
                jsr     (SonicKnux_DoLevelCollision).l
                movem.l (sp)+,d0-a6
                bset    #Status_InAir,status(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   locret_49764
                moveq   #signextendB(sfx_TurbineHum),d0
                jsr     (Play_SFX).l

locret_49764:
                rts
; End of function UpdatePlayerInDezGravityRoom

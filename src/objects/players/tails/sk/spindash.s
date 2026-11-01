; Owner: objects/players/tails/sk
; Responsibility: Tails spindash charging, release and sound command sequencing
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_1527C
                cmpi.b  #8,anim(a0)
                bne.s   locret_1527A
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_1527A
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_15242
                move.b  #2,anim(a6)

loc_15242:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   locret_1527A
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_1526A
                sub.w   d1,x_pos(a0)

loc_1526A:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_15276
                add.w   d1,x_pos(a0)

loc_15276:
                movem.l (sp)+,a4-a6

locret_1527A:
                rts
; ---------------------------------------------------------------------------

loc_1527C:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_15332
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_152A8
                subq.w  #2,y_pos(a0)

loc_152A8:
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_1530E(pc,d0.w),ground_vel(a0)
                tst.b   (Super_Tails_flag).w
                beq.s   loc_152C8
                move.w  word_15320(pc,d0.w),ground_vel(a0)

loc_152C8:
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_152EA
                lea     (H_scroll_frame_offset_P2).w,a1

loc_152EA:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_152F8
                neg.w   ground_vel(a0)

loc_152F8:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_1537A
; ---------------------------------------------------------------------------
word_1530E:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
word_15320:
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
                dc.w    $C80
                dc.w    $D00
                dc.w    $D80
                dc.w    $E00
; ---------------------------------------------------------------------------

loc_15332:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_1534A
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_1534A
                move.w  #0,spin_dash_counter(a0)

loc_1534A:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_1537A
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_1537A
                move.w  #$800,spin_dash_counter(a0)

loc_1537A:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_15388
                bcc.s   loc_15386
                addq.w  #4,(a5)

loc_15386:
                subq.w  #2,(a5)

loc_15388:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   locret_153C0
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_153B0
                sub.w   d1,x_pos(a0)

loc_153B0:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_153BC
                add.w   d1,x_pos(a0)

loc_153BC:
                movem.l (sp)+,a4-a6

locret_153C0:
                rts
; End of function Tails_Spindash

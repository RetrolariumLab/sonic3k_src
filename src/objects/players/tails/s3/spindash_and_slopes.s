; Owner: objects/players/tails/s3
; Responsibility: Tails spindash charge, slope resistance, rolling repulsion, slope detachment and airborne angle control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_15D50
                cmpi.b  #8,anim(a0)
                bne.s   locret_15D4E
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   locret_15D4E
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   loc_15D22
                move.b  #2,anim(a6)

loc_15D22:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   locret_15D4E
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_15D4E
                sub.w   d1,x_pos(a0)

locret_15D4E:
                rts
; ---------------------------------------------------------------------------

loc_15D50:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   loc_15DE0
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  word_15DCE(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   loc_15DA8
                lea     (H_scroll_frame_offset_P2).w,a1

loc_15DA8:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   loc_15DB6
                neg.w   ground_vel(a0)

loc_15DB6:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_15E28
; ---------------------------------------------------------------------------
word_15DCE:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
; ---------------------------------------------------------------------------

loc_15DE0:
                tst.w   spin_dash_counter(a0)
                beq.s   loc_15DF8
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   loc_15DF8
                move.w  #0,spin_dash_counter(a0)

loc_15DF8:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_15E28
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   loc_15E28
                move.w  #$800,spin_dash_counter(a0)

loc_15E28:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   loc_15E36
                bcc.s   loc_15E34
                addq.w  #4,(a5)

loc_15E34:
                subq.w  #2,(a5)

loc_15E36:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   locret_15E62
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   locret_15E62
                sub.w   d1,x_pos(a0)

locret_15E62:
                rts
; End of function Tails_Spindash

; =============== S U B R O U T I N E =======================================

Tails_SlopeResist:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   locret_15E98
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   locret_15E98
                bmi.s   loc_15E94
                tst.w   d0
                beq.s   locret_15E92
                add.w   d0,ground_vel(a0)

locret_15E92:
                rts
; ---------------------------------------------------------------------------

loc_15E94:
                add.w   d0,ground_vel(a0)

locret_15E98:
                rts
; End of function Tails_SlopeResist

; =============== S U B R O U T I N E =======================================

Tails_RollRepel:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   locret_15ED4
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   loc_15ECA
                tst.w   d0
                bpl.s   loc_15EC4
                asr.l   #2,d0

loc_15EC4:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_15ECA:
                tst.w   d0
                bmi.s   loc_15ED0
                asr.l   #2,d0

loc_15ED0:
                add.w   d0,ground_vel(a0)

locret_15ED4:
                rts
; End of function Tails_RollRepel

; =============== S U B R O U T I N E =======================================

Tails_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   locret_15F10
                tst.w   move_lock(a0)
                bne.s   loc_15F12
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   locret_15F10
                move.w  ground_vel(a0),d0
                bpl.s   loc_15EFA
                neg.w   d0

loc_15EFA:
                cmpi.w  #$280,d0
                bcc.s   locret_15F10
                clr.w   ground_vel(a0)
                bset    #Status_InAir,status(a0)
                move.w  #30,move_lock(a0)

locret_15F10:
                rts
; ---------------------------------------------------------------------------

loc_15F12:
                subq.w  #1,move_lock(a0)
                rts
; End of function Tails_SlopeRepel

; =============== S U B R O U T I N E =======================================

Tails_JumpAngle:
                move.b  angle(a0),d0
                beq.s   loc_15F32
                bpl.s   loc_15F28
                addq.b  #2,d0
                bcc.s   loc_15F26
                moveq   #0,d0

loc_15F26:
                bra.s   loc_15F2E
; ---------------------------------------------------------------------------

loc_15F28:
                subq.b  #2,d0
                bcc.s   loc_15F2E
                moveq   #0,d0

loc_15F2E:
                move.b  d0,angle(a0)

loc_15F32:
                move.b  flip_angle(a0),d0
                beq.s   locret_15F76
                tst.w   ground_vel(a0)
                bmi.s   loc_15F56

loc_15F3E:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   loc_15F54
                subq.b  #1,flips_remaining(a0)
                bcc.s   loc_15F54
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

loc_15F54:
                bra.s   loc_15F72
; ---------------------------------------------------------------------------

loc_15F56:
                tst.b   flip_type(a0)
                bmi.s   loc_15F3E
                move.b  flip_speed(a0),d1
                sub.b   d1,d0
                bcc.s   loc_15F72
                subq.b  #1,flips_remaining(a0)
                bcc.s   loc_15F72
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

loc_15F72:
                move.b  d0,flip_angle(a0)

locret_15F76:
                rts
; End of function Tails_JumpAngle

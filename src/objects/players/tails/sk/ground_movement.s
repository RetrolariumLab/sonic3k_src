; Owner: objects/players/tails/sk
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   loc_14B5C
                tst.w   move_lock(a0)
                bne.w   loc_14B14
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_14A0A
                bsr.w   sub_14C20

loc_14A0A:
                btst    #button_right,(Ctrl_2_logical).w
                beq.s   loc_14A16
                bsr.w   sub_14CAC

loc_14A16:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   loc_14B14
                tst.w   ground_vel(a0)
                bne.w   loc_14B14
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   loc_14A6C
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   loc_14AA0
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   loc_14A92
                cmp.w   d2,d1
                bge.s   loc_14A82
                bra.s   loc_14AA0
; ---------------------------------------------------------------------------

loc_14A6C:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.s   loc_14AA0
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_14A8A

loc_14A82:
                bclr    #Status_Facing,status(a0)
                bra.s   loc_14A98
; ---------------------------------------------------------------------------

loc_14A8A:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_14AA0

loc_14A92:
                bset    #Status_Facing,status(a0)

loc_14A98:
                move.b  #6,anim(a0)
                bra.s   loc_14B14
; ---------------------------------------------------------------------------

loc_14AA0:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   loc_14ADA
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_14B1A
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_14AD0
                cmpi.w  #8,(a5)
                beq.s   loc_14B26
                subq.w  #2,(a5)
                bra.s   loc_14B26
; ---------------------------------------------------------------------------

loc_14AD0:
                cmpi.w  #$D8,(a5)
                beq.s   loc_14B26
                addq.w  #2,(a5)
                bra.s   loc_14B26
; ---------------------------------------------------------------------------

loc_14ADA:
                btst    #button_up,(Ctrl_2_logical).w
                beq.s   loc_14B14
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_14B1A
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_14B0A
                cmpi.w  #$C8,(a5)
                beq.s   loc_14B26
                addq.w  #2,(a5)
                bra.s   loc_14B26
; ---------------------------------------------------------------------------

loc_14B0A:
                cmpi.w  #$18,(a5)
                beq.s   loc_14B26
                subq.w  #2,(a5)
                bra.s   loc_14B26
; ---------------------------------------------------------------------------

loc_14B14:
                move.b  #0,scroll_delay_counter(a0)

loc_14B1A:
                cmpi.w  #$60,(a5)
                beq.s   loc_14B26
                bcc.s   loc_14B24
                addq.w  #4,(a5)

loc_14B24:
                subq.w  #2,(a5)

loc_14B26:
                tst.b   (Super_Tails_flag).w
                beq.s   loc_14B30
                move.w  #$C,d5

loc_14B30:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_14B5C
                move.w  ground_vel(a0),d0
                beq.s   loc_14B5C
                bmi.s   loc_14B50
                sub.w   d5,d0
                bcc.s   loc_14B4A
                move.w  #0,d0

loc_14B4A:
                move.w  d0,ground_vel(a0)
                bra.s   loc_14B5C
; ---------------------------------------------------------------------------

loc_14B50:
                add.w   d5,d0
                bcc.s   loc_14B58
                move.w  #0,d0

loc_14B58:
                move.w  d0,ground_vel(a0)

loc_14B5C:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

loc_14B7A:
                btst    #6,object_control(a0)
                bne.w   locret_14C1E
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   loc_14B9A
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   locret_14C1E

loc_14B9A:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_14C1E
                bmi.s   loc_14BA8
                neg.w   d1

loc_14BA8:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   sub_F61C
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_14C1E
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   loc_14BCA
                tst.b   d0
                bpl.s   loc_14BCA
                subq.b  #1,d0

loc_14BCA:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_14C1A
                cmpi.b  #$40,d0
                beq.s   loc_14C00
                cmpi.b  #$80,d0
                beq.s   loc_14BFA
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   locret_14BF8
                bset    #Status_Push,status(a0)

locret_14BF8:
                rts
; ---------------------------------------------------------------------------

loc_14BFA:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_14C00:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   locret_14BF8
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_14C1A:
                add.w   d1,y_vel(a0)

locret_14C1E:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

sub_14C20:
                move.w  ground_vel(a0),d0
                beq.s   loc_14C28
                bpl.s   loc_14C5A

loc_14C28:
                bset    #Status_Facing,status(a0)
                bne.s   loc_14C3C
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_14C3C:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_14C4E
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_14C4E
                move.w  d1,d0

loc_14C4E:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14C5A:
                sub.w   d4,d0
                bcc.s   loc_14C62
                move.w  #-$80,d0

loc_14C62:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_14CAA
                cmpi.w  #$400,d0
                blt.s   locret_14CAA
                tst.b   flip_type(a0)
                bmi.s   locret_14CAA
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_14CAA
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_14CAA:
                rts
; End of function sub_14C20

; =============== S U B R O U T I N E =======================================

sub_14CAC:
                move.w  ground_vel(a0),d0
                bmi.s   loc_14CE0
                bclr    #Status_Facing,status(a0)
                beq.s   loc_14CC6
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_14CC6:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_14CD4
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_14CD4
                move.w  d6,d0

loc_14CD4:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_14CE0:
                add.w   d4,d0
                bcc.s   loc_14CE8
                move.w  #$80,d0

loc_14CE8:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_14D30
                cmpi.w  #-$400,d0
                bgt.s   locret_14D30
                tst.b   flip_type(a0)
                bmi.s   locret_14D30
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_14D30
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_14D30:
                rts
; End of function sub_14CAC

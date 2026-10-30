; Owner: objects/players/tails/s3
; Responsibility: Tails ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_InputAcceleration_Path:
                move.w  Max_speed_P2-Max_speed_P2(a4),d6
                move.w  Acceleration_P2-Max_speed_P2(a4),d5
                move.w  Deceleration_P2-Max_speed_P2(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   loc_1573C
                tst.w   move_lock(a0)
                bne.w   loc_156FE
                btst    #button_left,(Ctrl_2_held_logical).w
                beq.s   loc_15616
                bsr.w   sub_157E6

loc_15616:
                btst    #button_right,(Ctrl_2_held_logical).w
                beq.s   loc_15622
                bsr.w   sub_15872

loc_15622:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   loc_156FE
                tst.w   ground_vel(a0)
                bne.w   loc_156FE
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.s   loc_15678
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.s   loc_156AA
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #4,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #4,d1
                blt.s   loc_1569C
                cmp.w   d2,d1
                bge.s   loc_1568C
                bra.s   loc_156AA
; ---------------------------------------------------------------------------

loc_15678:
                jsr     (ChkFloorEdge).l
                cmpi.w  #$C,d1
                blt.s   loc_156AA
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_15694

loc_1568C:
                bclr    #Status_Facing,status(a0)
                bra.s   loc_156A2
; ---------------------------------------------------------------------------

loc_15694:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_156AA

loc_1569C:
                bset    #Status_Facing,status(a0)

loc_156A2:
                move.b  #6,anim(a0)
                bra.s   loc_156FE
; ---------------------------------------------------------------------------

loc_156AA:
                btst    #button_up,(Ctrl_2_held_logical).w
                beq.s   loc_156D4
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_15704
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #$C8,(a5)
                beq.s   loc_15710
                addq.w  #2,(a5)
                bra.s   loc_15710
; ---------------------------------------------------------------------------

loc_156D4:
                btst    #button_down,(Ctrl_2_held_logical).w
                beq.s   loc_156FE
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_15704
                move.b  #2*60,scroll_delay_counter(a0)
                cmpi.w  #8,(a5)
                beq.s   loc_15710
                subq.w  #2,(a5)
                bra.s   loc_15710
; ---------------------------------------------------------------------------

loc_156FE:
                move.b  #0,scroll_delay_counter(a0)

loc_15704:
                cmpi.w  #$60,(a5)
                beq.s   loc_15710
                bcc.s   loc_1570E
                addq.w  #4,(a5)

loc_1570E:
                subq.w  #2,(a5)

loc_15710:
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_1573C
                move.w  ground_vel(a0),d0
                beq.s   loc_1573C
                bmi.s   loc_15730
                sub.w   d5,d0
                bcc.s   loc_1572A
                move.w  #0,d0

loc_1572A:
                move.w  d0,ground_vel(a0)
                bra.s   loc_1573C
; ---------------------------------------------------------------------------

loc_15730:
                add.w   d5,d0
                bcc.s   loc_15738
                move.w  #0,d0

loc_15738:
                move.w  d0,ground_vel(a0)

loc_1573C:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

loc_1575A:
                btst    #6,object_control(a0)
                bne.w   locret_157E4
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.s   locret_157E4
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_157E4
                bmi.s   loc_1577C
                neg.w   d1

loc_1577C:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   sub_10980
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_157E4
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_157E0
                cmpi.b  #$40,d0
                beq.s   loc_157C6
                cmpi.b  #$80,d0
                beq.s   loc_157C0
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   locret_157BE
                bset    #Status_Push,status(a0)

locret_157BE:
                rts
; ---------------------------------------------------------------------------

loc_157C0:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_157C6:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   locret_157BE
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_157E0:
                add.w   d1,y_vel(a0)

locret_157E4:
                rts
; End of function Tails_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

sub_157E6:
                move.w  ground_vel(a0),d0
                beq.s   loc_157EE
                bpl.s   loc_15820

loc_157EE:
                bset    #Status_Facing,status(a0)
                bne.s   loc_15802
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_15802:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_15814
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_15814
                move.w  d1,d0

loc_15814:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_15820:
                sub.w   d4,d0
                bcc.s   loc_15828
                move.w  #-$80,d0

loc_15828:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_15870
                cmpi.w  #$400,d0
                blt.s   locret_15870
                tst.b   flip_type(a0)
                bmi.s   locret_15870
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_15870
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_15870:
                rts
; End of function sub_157E6

; =============== S U B R O U T I N E =======================================

sub_15872:
                move.w  ground_vel(a0),d0
                bmi.s   loc_158A6
                bclr    #Status_Facing,status(a0)
                beq.s   loc_1588C
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_1588C:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_1589A
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_1589A
                move.w  d6,d0

loc_1589A:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_158A6:
                add.w   d4,d0
                bcc.s   loc_158AE
                move.w  #$80,d0

loc_158AE:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_158F6
                cmpi.w  #-$400,d0
                bgt.s   locret_158F6
                tst.b   flip_type(a0)
                bmi.s   locret_158F6
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_158F6
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_158F6:
                rts
; End of function sub_15872

; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles ground input acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_InputAcceleration_Path:
                move.w  Max_speed-Max_speed(a4),d6
                move.w  Acceleration-Max_speed(a4),d5
                move.w  Deceleration-Max_speed(a4),d4
                tst.b   status_secondary(a0)
                bmi.w   loc_17364
                tst.w   move_lock(a0)
                bne.w   loc_1731C
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   loc_17168
                bsr.w   sub_17428

loc_17168:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_17174
                bsr.w   sub_174B4

loc_17174:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.w   loc_1731C
                tst.w   ground_vel(a0)
                bne.w   loc_1731C
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)
                btst    #Status_OnObj,status(a0)
                beq.w   loc_1722C
                movea.w interact(a0),a1
                tst.b   status(a1)
                bmi.w   loc_172A8
                moveq   #0,d1
                move.b  width_pixels(a1),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #2,d2
                add.w   x_pos(a0),d1
                sub.w   x_pos(a1),d1
                cmpi.w  #2,d1
                blt.s   loc_171FE
                cmp.w   d2,d1
                bge.s   loc_171D0
                bra.w   loc_172A8
; ---------------------------------------------------------------------------

loc_171D0:
                btst    #Status_Facing,status(a0)
                bne.s   loc_171E2
                move.b  #6,anim(a0)
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_171E2:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_171FE:
                btst    #Status_Facing,status(a0)
                beq.s   loc_17210
                move.b  #6,anim(a0)
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_17210:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_1722C:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_172A8
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_17272
                btst    #Status_Facing,status(a0)
                bne.s   loc_17256
                move.b  #6,anim(a0)
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_17256:
                bclr    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_17272:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_172A8
                btst    #Status_Facing,status(a0)
                beq.s   loc_1728C
                move.b  #6,anim(a0)
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_1728C:
                bset    #Status_Facing,status(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #4,anim_frame(a0)
                move.w  #(6<<8)|6,anim(a0)              ; and prev_anim
                bra.w   loc_1731C
; ---------------------------------------------------------------------------

loc_172A8:
                btst    #button_down,(Ctrl_1_held_logical).w
                beq.s   loc_172E2
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_17322
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_172D8
                cmpi.w  #8,(a5)
                beq.s   loc_1732E
                subq.w  #2,(a5)
                bra.s   loc_1732E
; ---------------------------------------------------------------------------

loc_172D8:
                cmpi.w  #$D8,(a5)
                beq.s   loc_1732E
                addq.w  #2,(a5)
                bra.s   loc_1732E
; ---------------------------------------------------------------------------

loc_172E2:
                btst    #button_up,(Ctrl_1_logical).w
                beq.s   loc_1731C
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #2*60,scroll_delay_counter(a0)
                blo.s   loc_17322
                move.b  #2*60,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_17312
                cmpi.w  #$C8,(a5)
                beq.s   loc_1732E
                addq.w  #2,(a5)
                bra.s   loc_1732E
; ---------------------------------------------------------------------------

loc_17312:
                cmpi.w  #$18,(a5)
                beq.s   loc_1732E
                subq.w  #2,(a5)
                bra.s   loc_1732E
; ---------------------------------------------------------------------------

loc_1731C:
                move.b  #0,scroll_delay_counter(a0)

loc_17322:
                cmpi.w  #$60,(a5)
                beq.s   loc_1732E
                bcc.s   loc_1732C
                addq.w  #4,(a5)

loc_1732C:
                subq.w  #2,(a5)

loc_1732E:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_17338
                move.w  #$C,d5

loc_17338:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_17364
                move.w  ground_vel(a0),d0
                beq.s   loc_17364
                bmi.s   loc_17358
                sub.w   d5,d0
                bcc.s   loc_17352
                move.w  #0,d0

loc_17352:
                move.w  d0,ground_vel(a0)
                bra.s   loc_17364
; ---------------------------------------------------------------------------

loc_17358:
                add.w   d5,d0
                bcc.s   loc_17360
                move.w  #0,d0

loc_17360:
                move.w  d0,ground_vel(a0)

loc_17364:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

loc_17382:
                btst    #6,object_control(a0)
                bne.w   locret_17426
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   loc_173A2
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   locret_17426

loc_173A2:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_17426
                bmi.s   loc_173B0
                neg.w   d1

loc_173B0:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   sub_F61C
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_17426
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   loc_173D2
                tst.b   d0
                bpl.s   loc_173D2
                subq.b  #1,d0

loc_173D2:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_17422
                cmpi.b  #$40,d0
                beq.s   loc_17408
                cmpi.b  #$80,d0
                beq.s   loc_17402
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   locret_17400
                bset    #Status_Push,status(a0)

locret_17400:
                rts
; ---------------------------------------------------------------------------

loc_17402:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_17408:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   locret_17400
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_17422:
                add.w   d1,y_vel(a0)

locret_17426:
                rts
; End of function Knux_InputAcceleration_Path

; =============== S U B R O U T I N E =======================================

sub_17428:
                move.w  ground_vel(a0),d0
                beq.s   loc_17430
                bpl.s   loc_17462

loc_17430:
                bset    #Status_Facing,status(a0)
                bne.s   loc_17444
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_17444:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_17456
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_17456
                move.w  d1,d0

loc_17456:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_17462:
                sub.w   d4,d0
                bcc.s   loc_1746A
                move.w  #-$80,d0

loc_1746A:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_174B2
                cmpi.w  #$400,d0
                blt.s   locret_174B2
                tst.b   flip_type(a0)
                bmi.s   locret_174B2
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_174B2
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_174B2:
                rts
; End of function sub_17428

; =============== S U B R O U T I N E =======================================

sub_174B4:
                move.w  ground_vel(a0),d0
                bmi.s   loc_174E8
                bclr    #Status_Facing,status(a0)
                beq.s   loc_174CE
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_174CE:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_174DC
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_174DC
                move.w  d6,d0

loc_174DC:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_174E8:
                add.w   d4,d0
                bcc.s   loc_174F0
                move.w  #$80,d0

loc_174F0:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_17538
                cmpi.w  #-$400,d0
                bgt.s   locret_17538
                tst.b   flip_type(a0)
                bmi.s   locret_17538
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_17538
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_17538:
                rts
; End of function sub_174B4

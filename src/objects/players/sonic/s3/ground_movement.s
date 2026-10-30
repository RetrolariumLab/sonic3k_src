; Owner: objects/players/sonic/s3
; Responsibility: Sonic ground acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Move:
                move.w  Max_speed-Max_speed(a4),d6      ; set Max_speed
                move.w  Acceleration-Max_speed(a4),d5   ; set Acceleration
                move.w  Deceleration-Max_speed(a4),d4   ; set Deceleration
                tst.b   status_secondary(a0)            ; is bit 7 set? (Infinite inertia)
                bmi.w   loc_123D6                       ; if so, branch
                tst.w   move_lock(a0)
                bne.w   loc_1238C
                btst    #button_left,(Ctrl_1_held_logical).w  ; is left being pressed?
                beq.s   Sonic_NotLeft                   ; if not, branch
                bsr.w   sub_12480

Sonic_NotLeft:
                btst    #button_right,(Ctrl_1_held_logical).w  ; is right being pressed?
                beq.s   Sonic_NotRight                  ; if not, branch
                bsr.w   sub_1250C

Sonic_NotRight:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0                         ; is Sonic on a slope?
                bne.w   loc_1238C                       ; if yes, branch
                tst.w   ground_vel(a0)                  ; is Sonic moving?
                bne.w   loc_1238C                       ; if yes, branch
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)                     ; use standing animation
                btst    #Status_OnObj,status(a0)
                beq.w   Sonic_Balance
                movea.w interact(a0),a1                 ; load interacting object's RAM space
                tst.b   status(a1)                      ; is status bit 7 set? (unused?)
                bmi.w   loc_12338                       ; if so, branch

; Calculations to determine where on the object Sonic is, and make him balance accordingly
                moveq   #0,d1                           ; Clear d1
                move.b  width_pixels(a1),d1             ; Load interacting object's width into d1
                move.w  d1,d2                           ; Move to d2 for separate calculations
                add.w   d2,d2                           ; Double object width, converting it to X pos' units of measurement
                subq.w  #2,d2                           ; Subtract 2: This is the margin for 'on edge'
                add.w   x_pos(a0),d1                    ; Add Sonic's X position to object width
                sub.w   x_pos(a1),d1                    ; Subtract object's X position from width+Sonic's X pos, giving you Sonic's distance from left edge of object
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super?
                bne.w   SuperSonic_Balance
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.s   Sonic_BalanceOnObjLeft          ; if so, branch
                cmp.w   d2,d1
                bge.s   Sonic_BalanceOnObjRight         ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   loc_12338                       ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------

SuperSonic_Balance:
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.w   loc_1232A                       ; if so, branch
                cmp.w   d2,d1
                bge.w   loc_1231A                       ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   loc_12338                       ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------
; balancing checks for when you're on the right edge of an object

Sonic_BalanceOnObjRight:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                bne.s   loc_121E4                       ; if so, branch
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   loc_1238C                       ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_1238C

loc_121E4:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   loc_1238C                       ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_1238C
; ---------------------------------------------------------------------------

Sonic_BalanceOnObjLeft:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                beq.s   loc_12222
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   loc_1238C                       ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_1238C

loc_12222:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bset    #Status_Facing,status(a0)       ; is Sonic facing right?
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   loc_1238C                       ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_1238C
; ---------------------------------------------------------------------------
; balancing checks for when you're on the edge of part of the level

Sonic_Balance:
                jsr     (ChkFloorEdge).l
                cmpi.w  #$C,d1
                blt.w   loc_12338
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super?
                bne.w   loc_12312                       ; if so, branch
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_122B4
                btst    #Status_Facing,status(a0)
                bne.s   loc_1228A
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                jsr     (ChkFloorEdge_Part2).l
                cmpi.w  #$C,d1
                blt.w   loc_1238C
                move.b  #$C,anim(a0)
                bra.w   loc_1238C
; on right edge but facing left:

loc_1228A:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                jsr     (ChkFloorEdge_Part2).l
                cmpi.w  #$C,d1
                blt.w   loc_1238C
                move.b  #$C,anim(a0)
                bra.w   loc_1238C
; ---------------------------------------------------------------------------

loc_122B4:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_12338
                btst    #Status_Facing,status(a0)
                beq.s   loc_122E8
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                jsr     (ChkFloorEdge_Part2).l
                cmpi.w  #$C,d1
                blt.w   loc_1238C
                move.b  #$C,anim(a0)
                bra.w   loc_1238C
; ---------------------------------------------------------------------------

loc_122E8:
                bset    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                jsr     (ChkFloorEdge_Part2).l
                cmpi.w  #$C,d1
                blt.w   loc_1238C
                move.b  #$C,anim(a0)
                bra.w   loc_1238C
; ---------------------------------------------------------------------------

loc_12312:
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_12322

loc_1231A:
                bclr    #Status_Facing,status(a0)
                bra.s   loc_12330
; ---------------------------------------------------------------------------

loc_12322:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_12338

loc_1232A:
                bset    #Status_Facing,status(a0)

loc_12330:
                move.b  #6,anim(a0)
                bra.s   loc_1238C
; ---------------------------------------------------------------------------

loc_12338:
                btst    #button_up,(Ctrl_1_held_logical).w
                beq.s   loc_12362
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   loc_12392
                move.b  #120,scroll_delay_counter(a0)
                cmpi.w  #$C8,(a5)
                beq.s   loc_1239E
                addq.w  #2,(a5)
                bra.s   loc_1239E
; ---------------------------------------------------------------------------

loc_12362:
                btst    #button_down,(Ctrl_1_held_logical).w
                beq.s   loc_1238C
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                bcs.s   loc_12392
                move.b  #120,scroll_delay_counter(a0)
                cmpi.w  #8,(a5)
                beq.s   loc_1239E
                subq.w  #2,(a5)
                bra.s   loc_1239E
; ---------------------------------------------------------------------------

loc_1238C:
                move.b  #0,scroll_delay_counter(a0)

loc_12392:
                cmpi.w  #$60,(a5)
                beq.s   loc_1239E
                bcc.s   loc_1239C
                addq.w  #4,(a5)

loc_1239C:
                subq.w  #2,(a5)

loc_1239E:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   loc_123AA
                move.w  #$C,d5

loc_123AA:
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_123D6
                move.w  ground_vel(a0),d0
                beq.s   loc_123D6
                bmi.s   loc_123CA
                sub.w   d5,d0
                bcc.s   loc_123C4
                move.w  #0,d0

loc_123C4:
                move.w  d0,ground_vel(a0)
                bra.s   loc_123D6
; ---------------------------------------------------------------------------

loc_123CA:
                add.w   d5,d0
                bcc.s   loc_123D2
                move.w  #0,d0

loc_123D2:
                move.w  d0,ground_vel(a0)

loc_123D6:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

loc_123F4:
                btst    #6,object_control(a0)
                bne.w   locret_1247E
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.s   locret_1247E
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_1247E
                bmi.s   loc_12416
                neg.w   d1

loc_12416:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   sub_10980
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_1247E
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_1247A
                cmpi.b  #$40,d0
                beq.s   loc_12460
                cmpi.b  #$80,d0
                beq.s   loc_1245A
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   locret_12458
                bset    #Status_Push,status(a0)

locret_12458:
                rts
; ---------------------------------------------------------------------------

loc_1245A:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_12460:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   locret_12458
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_1247A:
                add.w   d1,y_vel(a0)

locret_1247E:
                rts
; End of function Sonic_Move

; =============== S U B R O U T I N E =======================================

sub_12480:
                move.w  ground_vel(a0),d0
                beq.s   loc_12488
                bpl.s   loc_124BA

loc_12488:
                bset    #Status_Facing,status(a0)
                bne.s   loc_1249C
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_1249C:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_124AE
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_124AE
                move.w  d1,d0

loc_124AE:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_124BA:
                sub.w   d4,d0
                bcc.s   loc_124C2
                move.w  #-$80,d0

loc_124C2:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_1250A
                cmpi.w  #$400,d0
                blt.s   locret_1250A
                tst.b   flip_type(a0)
                bmi.s   locret_1250A
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_1250A
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_1250A:
                rts
; End of function sub_12480

; =============== S U B R O U T I N E =======================================

sub_1250C:
                move.w  ground_vel(a0),d0
                bmi.s   loc_12540
                bclr    #Status_Facing,status(a0)
                beq.s   loc_12526
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_12526:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_12534
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_12534
                move.w  d6,d0

loc_12534:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_12540:
                add.w   d4,d0
                bcc.s   loc_12548
                move.w  #$80,d0

loc_12548:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_12590
                cmpi.w  #-$400,d0
                bgt.s   locret_12590
                tst.b   flip_type(a0)
                bmi.s   locret_12590
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_12590
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_12590:
                rts
; End of function sub_1250C

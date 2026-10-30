; Owner: objects/players/sonic/sk
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
                bmi.w   loc_11332                       ; if so, branch
                tst.w   move_lock(a0)
                bne.w   loc_112EA
                btst    #button_left,(Ctrl_1_held_logical).w  ; is left being pressed?
                beq.s   Sonic_NotLeft                   ; if not, branch
                bsr.w   sub_113F6

Sonic_NotLeft:
                btst    #button_right,(Ctrl_1_held_logical).w  ; is right being pressed?
                beq.s   Sonic_NotRight                  ; if not, branch
                bsr.w   sub_11482

Sonic_NotRight:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0                         ; is Sonic on a slope?
                bne.w   loc_112EA                       ; if yes, branch
                tst.w   ground_vel(a0)                  ; is Sonic moving?
                bne.w   loc_112EA                       ; if yes, branch
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)                     ; use standing animation
                btst    #Status_OnObj,status(a0)
                beq.w   Sonic_Balance
                movea.w interact(a0),a1                 ; load interacting object's RAM space
                tst.b   status(a1)                      ; is status bit 7 set? (unused?)
                bmi.w   loc_11276                       ; if so, branch

; Calculations to determine where on the object Sonic is, and make him balance accordingly
                moveq   #0,d1                           ; Clear d1
                move.b  width_pixels(a1),d1             ; Load interacting object's width into d1
                move.w  d1,d2                           ; Move to d2 for separate calculations
                add.w   d2,d2                           ; Double object width, converting it to X pos' units of measurement
                subq.w  #2,d2                           ; Subtract 2: This is the margin for 'on edge'
                add.w   x_pos(a0),d1                    ; Add Sonic's X position to object width
                sub.w   x_pos(a1),d1                    ; Subtract object's X position from width+Sonic's X pos, giving you Sonic's distance from left edge of object
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   SuperSonic_Balance              ; if so, branch
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.s   Sonic_BalanceOnObjLeft          ; if so, branch
                cmp.w   d2,d1
                bge.s   Sonic_BalanceOnObjRight         ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   loc_11276                       ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------

SuperSonic_Balance:
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.w   loc_11268                       ; if so, branch
                cmp.w   d2,d1
                bge.w   loc_11258                       ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   loc_11276                       ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------
; balancing checks for when you're on the right edge of an object

Sonic_BalanceOnObjRight:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                bne.s   loc_11128                       ; if so, branch
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   loc_112EA                       ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_112EA

loc_11128:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   loc_112EA                       ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_112EA
; ---------------------------------------------------------------------------

Sonic_BalanceOnObjLeft:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                beq.s   loc_11166
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   loc_112EA                       ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_112EA

loc_11166:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bset    #Status_Facing,status(a0)       ; is Sonic facing right?
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   loc_112EA                       ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   loc_112EA
; ---------------------------------------------------------------------------
; balancing checks for when you're on the edge of part of the level

Sonic_Balance:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_11276
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   loc_11250                       ; if so, branch
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_111F6
                btst    #Status_Facing,status(a0)
                bne.s   loc_111CE
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_112EA
                move.b  #$C,anim(a0)
                bra.w   loc_112EA
; on right edge but facing left:

loc_111CE:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_112EA
                move.b  #$C,anim(a0)
                bra.w   loc_112EA
; ---------------------------------------------------------------------------

loc_111F6:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_11276
                btst    #Status_Facing,status(a0)
                beq.s   loc_11228
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_112EA
                move.b  #$C,anim(a0)
                bra.w   loc_112EA
; ---------------------------------------------------------------------------

loc_11228:
                bset    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   loc_112EA
                move.b  #$C,anim(a0)
                bra.w   loc_112EA
; ---------------------------------------------------------------------------

loc_11250:
                cmpi.b  #3,next_tilt(a0)
                bne.s   loc_11260

loc_11258:
                bclr    #Status_Facing,status(a0)
                bra.s   loc_1126E
; ---------------------------------------------------------------------------

loc_11260:
                cmpi.b  #3,tilt(a0)
                bne.s   loc_11276

loc_11268:
                bset    #Status_Facing,status(a0)

loc_1126E:
                move.b  #6,anim(a0)
                bra.s   loc_112EA
; ---------------------------------------------------------------------------

loc_11276:
                btst    #button_down,(Ctrl_1_logical).w
                beq.s   loc_112B0
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   loc_112F0
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_112A6
                cmpi.w  #8,(a5)
                beq.s   loc_112FC
                subq.w  #2,(a5)
                bra.s   loc_112FC
; ---------------------------------------------------------------------------

loc_112A6:
                cmpi.w  #$D8,(a5)
                beq.s   loc_112FC
                addq.w  #2,(a5)
                bra.s   loc_112FC
; ---------------------------------------------------------------------------

loc_112B0:
                btst    #button_up,(Ctrl_1_held_logical).w
                beq.s   loc_112EA
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   loc_112F0
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_112E0
                cmpi.w  #$C8,(a5)
                beq.s   loc_112FC
                addq.w  #2,(a5)
                bra.s   loc_112FC
; ---------------------------------------------------------------------------

loc_112E0:
                cmpi.w  #$18,(a5)
                beq.s   loc_112FC
                subq.w  #2,(a5)
                bra.s   loc_112FC
; ---------------------------------------------------------------------------

loc_112EA:
                move.b  #0,scroll_delay_counter(a0)

loc_112F0:
                cmpi.w  #$60,(a5)
                beq.s   loc_112FC
                bcc.s   loc_112FA
                addq.w  #4,(a5)

loc_112FA:
                subq.w  #2,(a5)

loc_112FC:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_11306
                move.w  #$C,d5

loc_11306:
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_11332
                move.w  ground_vel(a0),d0
                beq.s   loc_11332
                bmi.s   loc_11326
                sub.w   d5,d0
                bcc.s   loc_11320
                move.w  #0,d0

loc_11320:
                move.w  d0,ground_vel(a0)
                bra.s   loc_11332
; ---------------------------------------------------------------------------

loc_11326:
                add.w   d5,d0
                bcc.s   loc_1132E
                move.w  #0,d0

loc_1132E:
                move.w  d0,ground_vel(a0)

loc_11332:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

loc_11350:
                btst    #6,object_control(a0)
                bne.w   locret_113F4
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   loc_11370
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   locret_113F4

loc_11370:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_113F4
                bmi.s   loc_1137E
                neg.w   d1

loc_1137E:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   sub_F61C
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_113F4
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   loc_113A0
                tst.b   d0
                bpl.s   loc_113A0
                subq.b  #1,d0

loc_113A0:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_113F0
                cmpi.b  #$40,d0
                beq.s   loc_113D6
                cmpi.b  #$80,d0
                beq.s   loc_113D0
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   locret_113CE
                bset    #Status_Push,status(a0)

locret_113CE:
                rts
; ---------------------------------------------------------------------------

loc_113D0:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_113D6:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   locret_113CE
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_113F0:
                add.w   d1,y_vel(a0)

locret_113F4:
                rts
; End of function Sonic_Move

; =============== S U B R O U T I N E =======================================

sub_113F6:
                move.w  ground_vel(a0),d0
                beq.s   loc_113FE
                bpl.s   loc_11430

loc_113FE:
                bset    #Status_Facing,status(a0)
                bne.s   loc_11412
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_11412:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_11424
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_11424
                move.w  d1,d0

loc_11424:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_11430:
                sub.w   d4,d0
                bcc.s   loc_11438
                move.w  #-$80,d0

loc_11438:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_11480
                cmpi.w  #$400,d0
                blt.s   locret_11480
                tst.b   flip_type(a0)
                bmi.s   locret_11480
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_11480
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_11480:
                rts
; End of function sub_113F6

; =============== S U B R O U T I N E =======================================

sub_11482:
                move.w  ground_vel(a0),d0
                bmi.s   loc_114B6
                bclr    #Status_Facing,status(a0)
                beq.s   loc_1149C
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

loc_1149C:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_114AA
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_114AA
                move.w  d6,d0

loc_114AA:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_114B6:
                add.w   d4,d0
                bcc.s   loc_114BE
                move.w  #$80,d0

loc_114BE:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_11506
                cmpi.w  #-$400,d0
                bgt.s   locret_11506
                tst.b   flip_type(a0)
                bmi.s   locret_11506
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   locret_11506
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

locret_11506:
                rts
; End of function sub_11482

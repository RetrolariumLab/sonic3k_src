; Owner: objects/players/ddz/sk
; Responsibility: Doomsday player motion, ring or state updates, camera synchronization and controller helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Require the controller's transformed latch before switching to the falling failure state
DDZFlight_TryFailAfterSuperExpires:
                btst    #7,$38(a0)
                beq.s   locret_82750
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_82752

locret_82750:
                rts
; ---------------------------------------------------------------------------

loc_82752:
                move.l  #loc_8179E,(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                rts
; End of function DDZFlight_TryFailAfterSuperExpires

; =============== S U B R O U T I N E =======================================

; Combine held input, new button impulses, drag and hit response. Publish velocity to Player 1 and return it in d2.w and d3.w
DDZFlight_ComputeInputAndHitVel:
                lea     (Player_1).w,a1
                tst.b   invulnerability_timer(a1)
                beq.s   loc_827A0
                addi.b  #$10,angle(a1)
                cmpi.b  #30,invulnerability_timer(a1)
                blo.s   loc_827A8
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  (_unkFA82).w,d2
                lsr.l   #8,d2
                neg.w   d2
                moveq   #0,d3
                bra.w   loc_82828
; ---------------------------------------------------------------------------

loc_827A0:
                clr.b   angle(a1)
                clr.b   status(a1)

loc_827A8:
                moveq   #0,d2
                moveq   #0,d3
                moveq   #$40,d0
                move.w  x_vel(a0),d2
                beq.s   loc_827CA
                bmi.s   loc_827C0
                neg.w   d0
                add.w   d0,d2
                bpl.s   loc_827C6
                bra.w   loc_827C4
; ---------------------------------------------------------------------------

loc_827C0:
                add.w   d0,d2
                bmi.s   loc_827C6

loc_827C4:
                moveq   #0,d2

loc_827C6:
                move.w  d2,x_vel(a0)

loc_827CA:
                moveq   #$40,d0
                move.w  y_vel(a0),d3
                beq.s   loc_827E8
                bmi.s   loc_827DE
                neg.w   d0
                add.w   d0,d3
                bpl.s   loc_827E4
                bra.w   loc_827E2
; ---------------------------------------------------------------------------

loc_827DE:
                add.w   d0,d3
                bmi.s   loc_827E4

loc_827E2:
                moveq   #0,d3

loc_827E4:
                move.w  d3,y_vel(a0)

loc_827E8:
                lea     (Ctrl_1).w,a2
                tst.w   (a2)
                beq.s   loc_82828
                tst.b   (Ctrl_1_locked).w
                bne.s   loc_82828
                move.b  (a2)+,d0
                move.b  (a2)+,d1
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                lsl.w   #2,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.s   loc_8281A
                tst.b   invulnerability_timer(a1)
                bne.s   loc_8281A
                movem.w word_82872(pc,d0.w),d2-d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)

loc_8281A:
                tst.w   d0
                beq.s   loc_82828
                movem.w word_82832(pc,d0.w),d4-d5
                add.w   d4,d2
                add.w   d5,d3

loc_82828:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                rts
; End of function DDZFlight_ComputeInputAndHitVel

; ---------------------------------------------------------------------------
word_82832:                                             ; neither A, B, nor C are pressed
                dc.w    0,     0                        ; no D-pad
                dc.w    0, -$300                        ; up
                dc.w    0,  $300                        ; down
                dc.w    0,     0                        ; up + down (shouldn't happen)
                dc.w    -$300,     0                    ; left
                dc.w    -$21F, -$21F                    ; left + up
                dc.w    -$21F,  $21F                    ; left + down
                dc.w    0,     0                        ; left + up + down (shouldn't happen)
                dc.w    $300,     0                     ; right
                dc.w    $21F, -$21F                     ; right + up
                dc.w    $21F,  $21F                     ; right + down
                dc.w    0,     0                        ; right + up + down (shouldn't happen)
                dc.w    0,     0                        ; left + right(shouldn't happen)
                dc.w    0,     0                        ; left + right + up (shouldn't happen)
                dc.w    0,     0                        ; left + right + down (shouldn't happen)
                dc.w    0,     0                        ; left + right + up + down (shouldn't happen)
word_82872:                                             ; either A, B, or C is pressed
                dc.w    $600,     0                     ; no D-pad
                dc.w    0, -$600                        ; up
                dc.w    0,  $600                        ; down
                dc.w    0,     0                        ; up + down (shouldn't happen)
                dc.w    -$600,     0                    ; left
                dc.w    -$43E, -$43E                    ; left + up
                dc.w    -$43E,  $43E                    ; left + down
                dc.w    0,     0                        ; left + up + down (shouldn't happen)
                dc.w    $600,     0                     ; right
                dc.w    $43E, -$43E                     ; right + up
                dc.w    $43E,  $43E                     ; right + down
                dc.w    0,     0                        ; right + up + down (shouldn't happen)
                dc.w    0,     0                        ; left + right (shouldn't happen)
                dc.w    0,     0                        ; left + right + up (shouldn't happen)
                dc.w    0,     0                        ; left + right + down (shouldn't happen)
                dc.w    0,     0                        ; left + right + up + down (shouldn't happen)

; =============== S U B R O U T I N E =======================================

; Integrate 8.8 velocity into 16.16 position within camera-relative windows. Record pressure at the right edge for scroll boost
DDZFlight_IntegrateWithinView:
                tst.w   d2
                beq.s   loc_828EE
                move.l  x_pos(a0),d0
                move.w  (Camera_X_pos).w,d1
                ext.l   d2
                lsl.l   #8,d2
                add.l   d2,d0
                swap    d0
                move.w  (_unkFAB4).w,d4
                add.w   d4,d1
                cmp.w   d1,d0
                blo.s   loc_828EE
                move.w  (_unkFAB6).w,d5
                sub.w   d4,d5
                add.w   d5,d1
                bset    #1,$38(a0)
                cmp.w   d1,d0
                bhs.s   loc_828EE
                bclr    #1,$38(a0)
                swap    d0
                move.l  d0,x_pos(a0)

loc_828EE:
                tst.w   d3
                beq.s   locret_8291E
                move.l  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                ext.l   d3
                lsl.l   #8,d3
                add.l   d3,d0
                swap    d0
                move.w  (_unkFAB0).w,d4
                add.w   d4,d1
                cmp.w   d1,d0
                blo.s   locret_8291E
                move.w  (_unkFAB2).w,d5
                sub.w   d4,d5
                add.w   d5,d1
                cmp.w   d1,d0
                bhs.s   locret_8291E
                swap    d0
                move.l  d0,y_pos(a0)

locret_8291E:
                rts
; End of function DDZFlight_IntegrateWithinView

; =============== S U B R O U T I N E =======================================

; Apply accumulated scroll speed and right-edge boost, update X limits and carry the controller by the integer camera delta
DDZFlight_AdvanceCameraAndCarry:
                move.l  (_unkFA82).w,d0
                add.l   (_unkFA8A).w,d0
                move.l  #$60000,d2
                move.w  (_unkFA8E).w,d1
                beq.s   loc_82952
                movea.w d1,a1
                btst    #1,$38(a1)
                beq.s   loc_82952
                move.w  x_vel(a1),d1
                bmi.s   loc_82952
                beq.s   loc_82952
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,d0
                move.l  #$80000,d2

loc_82952:
                cmp.l   d2,d0
                ble.s   loc_82958
                move.l  d2,d0

loc_82958:
                cmpi.l  #$10000,d0
                ble.s   loc_82964
                move.l  d0,(_unkFA82).w

loc_82964:
                move.l  (Camera_X_pos).w,d1
                move.l  d1,d2
                add.l   d0,d1
                andi.l  #$7FFFFFFF,d1
                move.l  d1,(Camera_X_pos).w
                swap    d0
                add.w   d0,(Events_bg+$06).w
                swap    d1
                swap    d2
                move.w  d1,(Camera_min_X_pos).w
                move.w  $3C(a0),d3
                add.w   d1,d3
                move.w  d3,(Camera_max_X_pos).w
                sub.w   d2,d1
                move.w  d1,(_unkFA90).w
                move.w  x_pos(a0),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                rts
; End of function DDZFlight_AdvanceCameraAndCarry

; =============== S U B R O U T I N E =======================================

; Keep the actual camera fixed and publish the integer delta from a separate 16.16 world accumulator
DDZBoss_AdvanceVirtualScroll:
                move.l  (_unkFA82).w,d0
                add.l   (_unkFA8A).w,d0
                cmpi.l  #$60000,d0
                bhi.s   loc_829B4
                move.l  d0,(_unkFA82).w

loc_829B4:
                move.l  (_unkFA86).w,d1
                move.l  d1,d2
                add.l   d0,d1
                move.l  d1,(_unkFA86).w
                swap    d0
                add.w   d0,(Events_bg+$06).w
                swap    d1
                swap    d2
                sub.w   d2,d1
                move.w  d1,(_unkFA90).w
                rts
; End of function DDZBoss_AdvanceVirtualScroll

; =============== S U B R O U T I N E =======================================

; Copy controller coordinates to Player 1. When tracking is enabled, apply the camera deadbands within both axis limits
DDZFlight_SyncPlayerAndTrackCamera:
                lea     (Player_1).w,a1
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                move.w  x_pos(a0),d2
                move.w  d2,x_pos(a1)
                btst    #3,$38(a0)
                beq.s   loc_82A2E
                move.w  d2,d3
                addi.w  #$80,d0
                sub.w   d0,d2
                bcc.s   loc_82A10
                add.w   d2,d1
                cmp.w   (Camera_min_X_pos).w,d1
                blt.s   loc_82A06
                move.w  d1,(Camera_X_pos).w
                bra.w   loc_82A2E
; ---------------------------------------------------------------------------

loc_82A06:
                move.w  (Camera_min_X_pos).w,(Camera_X_pos).w
                bra.w   loc_82A2E
; ---------------------------------------------------------------------------

loc_82A10:
                addi.w  #$20,d0
                sub.w   d0,d3
                bls.s   loc_82A2E
                add.w   d3,d1
                cmp.w   (Camera_max_X_pos).w,d1
                bge.s   loc_82A28
                move.w  d1,(Camera_X_pos).w
                bra.w   loc_82A2E
; ---------------------------------------------------------------------------

loc_82A28:
                move.w  (Camera_max_X_pos).w,(Camera_X_pos).w

loc_82A2E:
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,d1
                move.w  y_pos(a0),d2
                move.w  d2,y_pos(a1)
                btst    #2,$38(a0)
                beq.s   locret_82A80
                move.w  d2,d3
                addi.w  #$60,d0
                sub.w   d0,d2
                bcc.s   loc_82A64
                add.w   d2,d1
                cmp.w   (Camera_min_Y_pos).w,d1
                blt.s   loc_82A5C
                move.w  d1,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_82A5C:
                move.w  (Camera_min_Y_pos).w,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_82A64:
                addi.w  #$20,d0
                sub.w   d0,d3
                ble.s   locret_82A80
                add.w   d3,d1
                cmp.w   (Camera_max_Y_pos).w,d1
                bge.s   loc_82A7A
                move.w  d1,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_82A7A:
                move.w  (Camera_max_Y_pos).w,(Camera_Y_pos).w

locret_82A80:
                rts
; End of function DDZFlight_SyncPlayerAndTrackCamera

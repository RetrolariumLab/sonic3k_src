; Owner: objects/players/ddz/sk
; Responsibility: Doomsday player motion, ring or state updates, camera synchronization and controller helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Require the controller's transformed latch before switching to the falling failure state
DDZFlight_TryFailAfterSuperExpires:
                btst    #7,$38(a0)
                beq.s   DDZ_FlightFailureCheckReturn
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_FlightBeginFailureFall

DDZ_FlightFailureCheckReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_FlightBeginFailureFall:
                move.l  #DDZ_FlightFallAndTryPlayerDeath,(a0)
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
                beq.s   DDZ_FlightClearPlayerAngleAndStatus
                addi.b  #$10,angle(a1)
                cmpi.b  #30,invulnerability_timer(a1)
                blo.s   DDZ_FlightApplyHorizontalDrag
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  (_unkFA82).w,d2
                lsr.l   #8,d2
                neg.w   d2
                moveq   #0,d3
                bra.w   DDZ_FlightStorePlayerVelocity
; ---------------------------------------------------------------------------

DDZ_FlightClearPlayerAngleAndStatus:
                clr.b   angle(a1)
                clr.b   status(a1)

DDZ_FlightApplyHorizontalDrag:
                moveq   #0,d2
                moveq   #0,d3
                moveq   #$40,d0
                move.w  x_vel(a0),d2
                beq.s   DDZ_FlightApplyVerticalDrag
                bmi.s   DDZ_FlightDragNegativeXImpulse
                neg.w   d0
                add.w   d0,d2
                bpl.s   DDZ_FlightStoreXImpulse
                bra.w   DDZ_FlightZeroXImpulse
; ---------------------------------------------------------------------------

DDZ_FlightDragNegativeXImpulse:
                add.w   d0,d2
                bmi.s   DDZ_FlightStoreXImpulse

DDZ_FlightZeroXImpulse:
                moveq   #0,d2

DDZ_FlightStoreXImpulse:
                move.w  d2,x_vel(a0)

DDZ_FlightApplyVerticalDrag:
                moveq   #$40,d0
                move.w  y_vel(a0),d3
                beq.s   DDZ_FlightReadControlsAndPressImpulse
                bmi.s   DDZ_FlightDragNegativeYImpulse
                neg.w   d0
                add.w   d0,d3
                bpl.s   DDZ_FlightStoreYImpulse
                bra.w   DDZ_FlightZeroYImpulse
; ---------------------------------------------------------------------------

DDZ_FlightDragNegativeYImpulse:
                add.w   d0,d3
                bmi.s   DDZ_FlightStoreYImpulse

DDZ_FlightZeroYImpulse:
                moveq   #0,d3

DDZ_FlightStoreYImpulse:
                move.w  d3,y_vel(a0)

DDZ_FlightReadControlsAndPressImpulse:
                lea     (Ctrl_1).w,a2
                tst.w   (a2)
                beq.s   DDZ_FlightStorePlayerVelocity
                tst.b   (Ctrl_1_locked).w
                bne.s   DDZ_FlightStorePlayerVelocity
                move.b  (a2)+,d0
                move.b  (a2)+,d1
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                lsl.w   #2,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.s   DDZ_FlightAddHeldDirectionVelocity
                tst.b   invulnerability_timer(a1)
                bne.s   DDZ_FlightAddHeldDirectionVelocity
                movem.w DDZ_FlightNewButtonImpulses(pc,d0.w),d2-d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)

DDZ_FlightAddHeldDirectionVelocity:
                tst.w   d0
                beq.s   DDZ_FlightStorePlayerVelocity
                movem.w DDZ_FlightHeldDirectionVelocities(pc,d0.w),d4-d5
                add.w   d4,d2
                add.w   d5,d3

DDZ_FlightStorePlayerVelocity:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                rts
; End of function DDZFlight_ComputeInputAndHitVel

; ---------------------------------------------------------------------------
DDZ_FlightHeldDirectionVelocities:                      ; neither A, B, nor C are pressed
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
DDZ_FlightNewButtonImpulses:                            ; either A, B, or C is pressed
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
                beq.s   DDZ_FlightIntegrateYWithinWindow
                move.l  x_pos(a0),d0
                move.w  (Camera_X_pos).w,d1
                ext.l   d2
                lsl.l   #8,d2
                add.l   d2,d0
                swap    d0
                move.w  (_unkFAB4).w,d4
                add.w   d4,d1
                cmp.w   d1,d0
                blo.s   DDZ_FlightIntegrateYWithinWindow
                move.w  (_unkFAB6).w,d5
                sub.w   d4,d5
                add.w   d5,d1
                bset    #1,$38(a0)
                cmp.w   d1,d0
                bhs.s   DDZ_FlightIntegrateYWithinWindow
                bclr    #1,$38(a0)
                swap    d0
                move.l  d0,x_pos(a0)

DDZ_FlightIntegrateYWithinWindow:
                tst.w   d3
                beq.s   DDZ_FlightIntegrateWindowReturn
                move.l  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                ext.l   d3
                lsl.l   #8,d3
                add.l   d3,d0
                swap    d0
                move.w  (_unkFAB0).w,d4
                add.w   d4,d1
                cmp.w   d1,d0
                blo.s   DDZ_FlightIntegrateWindowReturn
                move.w  (_unkFAB2).w,d5
                sub.w   d4,d5
                add.w   d5,d1
                cmp.w   d1,d0
                bhs.s   DDZ_FlightIntegrateWindowReturn
                swap    d0
                move.l  d0,y_pos(a0)

DDZ_FlightIntegrateWindowReturn:
                rts
; End of function DDZFlight_IntegrateWithinView

; =============== S U B R O U T I N E =======================================

; Apply accumulated scroll speed and right-edge boost, update X limits and carry the controller by the integer camera delta
DDZFlight_AdvanceCameraAndCarry:
                move.l  (_unkFA82).w,d0
                add.l   (_unkFA8A).w,d0
                move.l  #$60000,d2
                move.w  (_unkFA8E).w,d1
                beq.s   DDZ_FlightClampScrollCandidate
                movea.w d1,a1
                btst    #1,$38(a1)
                beq.s   DDZ_FlightClampScrollCandidate
                move.w  x_vel(a1),d1
                bmi.s   DDZ_FlightClampScrollCandidate
                beq.s   DDZ_FlightClampScrollCandidate
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,d0
                move.l  #$80000,d2

DDZ_FlightClampScrollCandidate:
                cmp.l   d2,d0
                ble.s   DDZ_FlightStoreSpeedAboveOnePixel
                move.l  d2,d0

DDZ_FlightStoreSpeedAboveOnePixel:
                cmpi.l  #$10000,d0
                ble.s   DDZ_FlightAdvanceCameraAndCarryActor
                move.l  d0,(_unkFA82).w

DDZ_FlightAdvanceCameraAndCarryActor:
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
                bhi.s   DDZ_FlightApplyVirtualScrollDelta
                move.l  d0,(_unkFA82).w

; Use the candidate even when it is too small to store as persistent scroll speed
DDZ_FlightApplyVirtualScrollDelta:
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
                beq.s   DDZ_FlightSyncPlayerYAndCheckFollow
                move.w  d2,d3
                addi.w  #$80,d0
                sub.w   d0,d2
                bcc.s   DDZ_FlightCameraFollowRight
                add.w   d2,d1
                cmp.w   (Camera_min_X_pos).w,d1
                blt.s   DDZFlightCamera_ClampLeftwardXToMinimum
                move.w  d1,(Camera_X_pos).w
                bra.w   DDZ_FlightSyncPlayerYAndCheckFollow
; ---------------------------------------------------------------------------

DDZFlightCamera_ClampLeftwardXToMinimum:
                move.w  (Camera_min_X_pos).w,(Camera_X_pos).w
                bra.w   DDZ_FlightSyncPlayerYAndCheckFollow
; ---------------------------------------------------------------------------

DDZ_FlightCameraFollowRight:
                addi.w  #$20,d0
                sub.w   d0,d3
                bls.s   DDZ_FlightSyncPlayerYAndCheckFollow
                add.w   d3,d1
                cmp.w   (Camera_max_X_pos).w,d1
                bge.s   DDZFlightCamera_ClampRightwardXToMaximum
                move.w  d1,(Camera_X_pos).w
                bra.w   DDZ_FlightSyncPlayerYAndCheckFollow
; ---------------------------------------------------------------------------

DDZFlightCamera_ClampRightwardXToMaximum:
                move.w  (Camera_max_X_pos).w,(Camera_X_pos).w

DDZ_FlightSyncPlayerYAndCheckFollow:
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,d1
                move.w  y_pos(a0),d2
                move.w  d2,y_pos(a1)
                btst    #2,$38(a0)
                beq.s   DDZ_FlightCameraFollowReturn
                move.w  d2,d3
                addi.w  #$60,d0
                sub.w   d0,d2
                bcc.s   DDZ_FlightCameraFollowDown
                add.w   d2,d1
                cmp.w   (Camera_min_Y_pos).w,d1
                blt.s   DDZFlightCamera_ClampUpwardYToMinimum
                move.w  d1,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

DDZFlightCamera_ClampUpwardYToMinimum:
                move.w  (Camera_min_Y_pos).w,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

DDZ_FlightCameraFollowDown:
                addi.w  #$20,d0
                sub.w   d0,d3
                ble.s   DDZ_FlightCameraFollowReturn
                add.w   d3,d1
                cmp.w   (Camera_max_Y_pos).w,d1
                bge.s   DDZFlightCamera_ClampDownwardYToMaximum
                move.w  d1,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

DDZFlightCamera_ClampDownwardYToMaximum:
                move.w  (Camera_max_Y_pos).w,(Camera_Y_pos).w

DDZ_FlightCameraFollowReturn:
                rts
; End of function DDZFlight_SyncPlayerAndTrackCamera

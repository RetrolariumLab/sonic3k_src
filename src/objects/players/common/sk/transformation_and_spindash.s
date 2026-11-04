; Owner: objects/players/common/sk
; Responsibility: Existing shared transformation state and Sonic or Knuckles spindash logic, including product-specific Tails super handling
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Super:
                tst.b   (Super_Tails_flag).w
                beq.w   SonicKnux_SuperHyper.return
                bra.s   SonicKnux_SuperHyper.continued

; =============== S U B R O U T I N E =======================================

SonicKnux_SuperHyper:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   .return                         ; If not Super/Hyper, return

                .continued:
                tst.b   (Update_HUD_timer).w            ; Level over?
                beq.s   .revertToNormal
                subq.w  #1,(Super_frame_count).w
; Bug: This should be a 'bhi'; currently counts down 61 frames
                bpl.w   .return
                move.w  #60,(Super_frame_count).w
                tst.w   (Ring_count).w
                beq.s   .revertToNormal                 ; If rings depleted, return to normal
; This checks if the ring counter needs to be blanked
; for example, this ticks '10' down to ' 9' instead of '19' (yes, this does happen)
                ori.b   #1,(Update_HUD_ring_count).w    ; Update ring counter
                cmpi.w  #1,(Ring_count).w
                beq.s   .resetHUD
                cmpi.w  #10,(Ring_count).w
                beq.s   .resetHUD
                cmpi.w  #100,(Ring_count).w
                bne.s   .updateHUD

                .resetHUD:
                ori.b   #$80,(Update_HUD_ring_count).w  ; Re-init ring counter

                .updateHUD:
                subq.w  #1,(Ring_count).w
                bne.s   .return                         ; If rings aren't depleted, we're done here
; If rings depleted, return to normal

                .revertToNormal:
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w
                move.b  #-1,(Player_prev_frame).w
                tst.b   character_id(a0)                ; Is this Sonic?
                bne.s   .notSonic
                move.l  #Map_Sonic,mappings(a0)         ; If so, load Sonic's normal mappings (was using Super/Hyper mappings)

                .notSonic:
                move.b  #1,prev_anim(a0)
                move.b  #1,invincibility_timer(a0)
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                btst    #Status_Underwater,status(a0)
                beq.s   .return
; If underwater, apply corrected speed/acceleration/deceleration
                move.w  #$300,Max_speed-Max_speed(a4)
                move.w  #6,Acceleration-Max_speed(a4)
                move.w  #$40,Deceleration-Max_speed(a4)

                .return:
                rts
; End of function SonicKnux_SuperHyper

; =============== S U B R O U T I N E =======================================

SonicKnux_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKPlayerSpindash_ReleaseOrContinueActiveSpindash
                cmpi.b  #8,anim(a0)
                bne.s   SKPlayerSpindash_ReturnFromSpindashEntryOrRejectedStart
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKPlayerSpindash_ReturnFromSpindashEntryOrRejectedStart
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKPlayerSpindash_RunEntrySpindashBoundsAndBackgroundChecks
                move.b  #2,anim(a6)

SKPlayerSpindash_RunEntrySpindashBoundsAndBackgroundChecks:
                bsr.w   Player_LevelBound
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   SKPlayerSpindash_ReturnFromSpindashEntryOrRejectedStart
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKPlayerSpindash_CheckEntrySpindashRightWallAfterLeftCorrection
                sub.w   d1,x_pos(a0)

SKPlayerSpindash_CheckEntrySpindashRightWallAfterLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKPlayerSpindash_RestoreEntrySpindashRegistersAfterBothWallChecks
                add.w   d1,x_pos(a0)

SKPlayerSpindash_RestoreEntrySpindashRegistersAfterBothWallChecks:
                movem.l (sp)+,a4-a6

SKPlayerSpindash_ReturnFromSpindashEntryOrRejectedStart:
                rts
; ---------------------------------------------------------------------------

SKPlayerSpindash_ReleaseOrContinueActiveSpindash:
                move.b  (Ctrl_1_held_logical).w,d0
                btst    #button_down,d0
                bne.w   SKPlayerSpindash_DecayHeldSpindashChargeWord
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #5,y_pos(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKPlayerSpindash_SelectReleaseSpeedAfterGravityAdjustedShapeShift
                subi.w  #5*2,y_pos(a0)

SKPlayerSpindash_SelectReleaseSpeedAfterGravityAdjustedShapeShift:
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  SKPlayerSpindash_NormalReleaseSpeedsByChargeHighByte(pc,d0.w),ground_vel(a0)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKPlayerSpindash_ComputeReleaseCameraLagFromUnsignedSpeed
                move.w  SKPlayerSpindash_SuperReleaseSpeedsByChargeHighByte(pc,d0.w),ground_vel(a0)

SKPlayerSpindash_ComputeReleaseCameraLagFromUnsignedSpeed:
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   SKPlayerSpindash_StoreReleaseCameraLagAndApplyFacing
                lea     (H_scroll_frame_offset_P2).w,a1

SKPlayerSpindash_StoreReleaseCameraLagAndApplyFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   SKPlayerSpindash_SetReleasedRollAndStopDust
                neg.w   ground_vel(a0)

SKPlayerSpindash_SetReleasedRollAndStopDust:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   SKPlayerSpindash_AbortGroundCallerAndRelaxCameraAfterActiveSpindash
; ---------------------------------------------------------------------------
SKPlayerSpindash_NormalReleaseSpeedsByChargeHighByte:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
SKPlayerSpindash_SuperReleaseSpeedsByChargeHighByte:
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
                dc.w    $C80
                dc.w    $D00
                dc.w    $D80
                dc.w    $E00
                dc.w    $E80
                dc.w    $F00
; ---------------------------------------------------------------------------

SKPlayerSpindash_DecayHeldSpindashChargeWord:
                tst.w   spin_dash_counter(a0)
                beq.s   SKPlayerSpindash_AddNewButtonChargeAndRestartSpindashAnimation
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   SKPlayerSpindash_AddNewButtonChargeAndRestartSpindashAnimation
                move.w  #0,spin_dash_counter(a0)

SKPlayerSpindash_AddNewButtonChargeAndRestartSpindashAnimation:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKPlayerSpindash_AbortGroundCallerAndRelaxCameraAfterActiveSpindash
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   SKPlayerSpindash_AbortGroundCallerAndRelaxCameraAfterActiveSpindash
                move.w  #$800,spin_dash_counter(a0)

SKPlayerSpindash_AbortGroundCallerAndRelaxCameraAfterActiveSpindash:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   SKPlayerSpindash_RunActiveSpindashBoundsAndBackgroundChecks
                bcc.s   SKPlayerSpindash_SubtractTwoFromSpindashCameraDistance
                addq.w  #4,(a5)

SKPlayerSpindash_SubtractTwoFromSpindashCameraDistance:
                subq.w  #2,(a5)

SKPlayerSpindash_RunActiveSpindashBoundsAndBackgroundChecks:
                bsr.w   Player_LevelBound
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   SKPlayerSpindash_ReturnAfterActiveSpindashBackgroundChecks
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKPlayerSpindash_CheckActiveSpindashRightWallAfterLeftCorrection
                sub.w   d1,x_pos(a0)

SKPlayerSpindash_CheckActiveSpindashRightWallAfterLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKPlayerSpindash_RestoreActiveSpindashRegistersAfterBothWallChecks
                add.w   d1,x_pos(a0)

SKPlayerSpindash_RestoreActiveSpindashRegistersAfterBothWallChecks:
                movem.l (sp)+,a4-a6

SKPlayerSpindash_ReturnAfterActiveSpindashBackgroundChecks:
                rts
; End of function SonicKnux_Spindash

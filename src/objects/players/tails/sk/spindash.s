; Owner: objects/players/tails/sk
; Responsibility: Tails spindash charging, release and sound command sequencing
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsSpindash_MaintainHeldChargeOrReleaseNormalTailsGeometry
                cmpi.b  #8,anim(a0)
                bne.s   SKTailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKTailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKTailsSpindash_ApplyBoundsAttachmentAndBackgroundChecksAfterChargeStart
                move.b  #2,anim(a6)

SKTailsSpindash_ApplyBoundsAttachmentAndBackgroundChecksAfterChargeStart:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   SKTailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsSpindash_ProbeRightBackgroundWallAfterChargeStartLeftCorrection
                sub.w   d1,x_pos(a0)

SKTailsSpindash_ProbeRightBackgroundWallAfterChargeStartLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsSpindash_RestoreChargeStartWallProbeBases
                add.w   d1,x_pos(a0)

SKTailsSpindash_RestoreChargeStartWallProbeBases:
                movem.l (sp)+,a4-a6

SKTailsSpindash_ReturnWithRejectedStartOrAbortedGroundStackContext:
                rts
; ---------------------------------------------------------------------------

SKTailsSpindash_MaintainHeldChargeOrReleaseNormalTailsGeometry:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   SKTailsSpindash_DecayHeldSpindashChargeUsingLogicalWordShift
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsSpindash_ClearReleasedChargeAndChooseNormalOrSuperTailsSpeed
                subq.w  #2,y_pos(a0)

SKTailsSpindash_ClearReleasedChargeAndChooseNormalOrSuperTailsSpeed:
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  SKTailsSpindash_NormalTailsSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)
                tst.b   (Super_Tails_flag).w
                beq.s   SKTailsSpindash_EncodeDashHistoryLagFromPositiveSelectedLaunchSpeed
                move.w  SKTailsSpindash_SuperTailsSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)

SKTailsSpindash_EncodeDashHistoryLagFromPositiveSelectedLaunchSpeed:
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   SKTailsSpindash_StorePreFacingDashHistoryLagThenSignLaunchSpeed
                lea     (H_scroll_frame_offset_P2).w,a1

SKTailsSpindash_StorePreFacingDashHistoryLagThenSignLaunchSpeed:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   SKTailsSpindash_CommitReleasedRollStopDustAndPlayDashSound
                neg.w   ground_vel(a0)

SKTailsSpindash_CommitReleasedRollStopDustAndPlayDashSound:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   SKTailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
; ---------------------------------------------------------------------------
SKTailsSpindash_NormalTailsSpindashLaunchSpeedWords:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
SKTailsSpindash_SuperTailsSpindashLaunchSpeedWords:
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

SKTailsSpindash_DecayHeldSpindashChargeUsingLogicalWordShift:
                tst.w   spin_dash_counter(a0)
                beq.s   SKTailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   SKTailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation
                move.w  #0,spin_dash_counter(a0)

SKTailsSpindash_BoostChargeOnNewAbcAndRestartChargeAnimation:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKTailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   SKTailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease
                move.w  #$800,spin_dash_counter(a0)

SKTailsSpindash_DiscardGroundReturnAndRecoverCameraDuringChargeOrRelease:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   SKTailsSpindash_AttachAndCheckBackgroundAfterActiveChargeOrRelease
                bcc.s   SKTailsSpindash_SubtractSpindashCameraRecoveryStep
                addq.w  #4,(a5)

SKTailsSpindash_SubtractSpindashCameraRecoveryStep:
                subq.w  #2,(a5)

SKTailsSpindash_AttachAndCheckBackgroundAfterActiveChargeOrRelease:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Call_Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   SKTailsSpindash_ReturnToOuterModeAfterChargeReleaseTail
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsSpindash_ProbeRightBackgroundWallAfterActiveDashLeftCorrection
                sub.w   d1,x_pos(a0)

SKTailsSpindash_ProbeRightBackgroundWallAfterActiveDashLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsSpindash_RestoreActiveDashWallProbeBasesBeforeOuterReturn
                add.w   d1,x_pos(a0)

SKTailsSpindash_RestoreActiveDashWallProbeBasesBeforeOuterReturn:
                movem.l (sp)+,a4-a6

SKTailsSpindash_ReturnToOuterModeAfterChargeReleaseTail:
                rts
; End of function Tails_Spindash

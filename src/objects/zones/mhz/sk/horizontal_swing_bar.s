; Owner: objects/zones/mhz/sk
; Responsibility: Horizontal swing-bar contact, character rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZSwingBarHorizontal:
                move.l  #Map_MHZSwingBarHorizontal,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$AC,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.l  #SKMHZHorizBar_UpdateBarRiders,(a0)

SKMHZHorizBar_UpdateBarRiders:
                lea     $30(a0),a2
                lea     $3A(a0),a3
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   UpdatePlayerOnMhzHorizontalSwingBar
                addq.w  #1,a2
                lea     $3C(a0),a3
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   UpdatePlayerOnMhzHorizontalSwingBar
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzHorizontalSwingBar:
                tst.b   (a2)
                beq.w   SKMHZHorizBar_TickCaptureCooldown
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZHorizBar_StartManualCooldown
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZHorizBar_StartManualCooldown
                btst    #button_left+8,d1
                beq.s   SKMHZHorizBar_TryMoveRiderRight
                move.w  x_pos(a0),d0
                subi.w  #$16,d0
                cmp.w   x_pos(a1),d0
                bge.s   SKMHZHorizBar_TryMoveRiderRight
                subq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   SKMHZHorizBar_TryMoveRiderRight
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

SKMHZHorizBar_TryMoveRiderRight:
                btst    #button_right+8,d1
                beq.s   SKMHZHorizBar_TryReleaseByInputOrPhase
                move.w  x_pos(a0),d0
                addi.w  #$15,d0
                cmp.w   x_pos(a1),d0
                ble.s   SKMHZHorizBar_TryReleaseByInputOrPhase
                addq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   SKMHZHorizBar_TryReleaseByInputOrPhase
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

SKMHZHorizBar_TryReleaseByInputOrPhase:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   SKMHZHorizBar_SetManualJumpYSpeed
                cmpi.b  #$28,4(a2)
                beq.w   SKMHZHorizBar_ReleaseWithBoostedYSpeed
                cmpi.b  #5,4(a2)
                beq.w   SKMHZHorizBar_ReleaseWithSavedYSpeed
                bsr.w   UpdateMhzHorizontalBarPlayerPose
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

SKMHZHorizBar_SetManualJumpYSpeed:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   SKMHZHorizBar_StartManualCooldown
                move.w  #-$200,y_vel(a1)

SKMHZHorizBar_StartManualCooldown:
                clr.b   (a2)
                move.b  #30,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   SKMHZHorizBar_SetReleasedRollPose
                move.b  #60,2(a2)

SKMHZHorizBar_SetReleasedRollPose:
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZHorizBar_ReleaseWithBoostedYSpeed:
                move.w  #$10<<8,anim(a1)                ; and prev_anim
                move.w  (a3),d0
                move.w  d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,y_vel(a1)

SKMHZHorizBar_StartAutomaticCooldown:
                clr.b   (a2)
                move.b  #8,2(a2)
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZHorizBar_ReleaseWithSavedYSpeed:
                move.w  #0,anim(a1)
                move.w  (a3),y_vel(a1)
                bra.s   SKMHZHorizBar_StartAutomaticCooldown
; ---------------------------------------------------------------------------

SKMHZHorizBar_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKMHZHorizBar_TryCaptureAndSaveYSpeed
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

SKMHZHorizBar_TryCaptureAndSaveYSpeed:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$16,d0
                cmpi.w  #$2C,d0
                bhs.w   SKMHZHorizBar_CaptureReturn
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.w   SKMHZHorizBar_CaptureReturn
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                bcs.w   SKMHZHorizBar_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZHorizBar_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZHorizBar_CaptureReturn
                tst.b   object_control(a1)
                bne.w   SKMHZHorizBar_CaptureReturn
                move.w  y_vel(a1),(a3)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$94,mapping_frame(a1)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                cmpi.w  #-$400,(a3)
                bgt.s   SKMHZHorizBar_TryFastEntryPose
                move.b  #$95,mapping_frame(a1)
                move.b  #$20,4(a2)
                move.b  #$10,8(a2)
                bra.s   SKMHZHorizBar_LatchRiderAndUploadPose
; ---------------------------------------------------------------------------

SKMHZHorizBar_TryFastEntryPose:
                cmpi.w  #$400,(a3)
                blt.s   SKMHZHorizBar_LatchRiderAndUploadPose
                move.b  #$95,mapping_frame(a1)
                move.b  #$21,4(a2)
                move.b  #$10,8(a2)

SKMHZHorizBar_LatchRiderAndUploadPose:
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKMHZHorizBar_CaptureReturn:
                rts
; End of function UpdatePlayerOnMhzHorizontalSwingBar

; =============== S U B R O U T I N E =======================================

UpdateMhzHorizontalBarPlayerPose:
                cmpi.w  #-$400,(a3)
                ble.s   SKMHZHorizBar_StepFastPhase
                cmpi.w  #$400,(a3)
                bge.s   SKMHZHorizBar_StepFastPhase
                move.b  4(a2),d0
                beq.s   SKMHZHorizBar_ApplyNeutralPose
                bpl.s   SKMHZHorizBar_DampPositivePhase
                addi.b  #6,d0
                bcc.s   SKMHZHorizBar_FinishNegativeDamping
                moveq   #0,d0

SKMHZHorizBar_FinishNegativeDamping:
                bra.s   SKMHZHorizBar_SetDampedPhase
; ---------------------------------------------------------------------------

SKMHZHorizBar_DampPositivePhase:
                subi.b  #6,d0
                bcc.s   SKMHZHorizBar_SetDampedPhase
                moveq   #0,d0

SKMHZHorizBar_SetDampedPhase:
                move.b  d0,4(a2)

SKMHZHorizBar_ApplyNeutralPose:
                bra.s   SKMHZHorizBar_ApplyFrameAndYOffset
; ---------------------------------------------------------------------------

SKMHZHorizBar_StepFastPhase:
                move.b  4(a2),d0
                addi.b  #$C,d0
                move.b  d0,4(a2)

SKMHZHorizBar_ApplyFrameAndYOffset:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                add.b   8(a2),d0
                move.b  SKMHZHorizBar_RiderPoseFrames(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$F,d0
                move.b  SKMHZHorizBar_RiderPoseYOffsets(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                rts
; End of function UpdateMhzHorizontalBarPlayerPose

; ---------------------------------------------------------------------------
SKMHZHorizBar_RiderPoseFrames:
                dc.b    $94, $63, $64, $64, $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68, $95, $63, $64, $64
                dc.b    $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68
SKMHZHorizBar_RiderPoseYOffsets:
                dc.b    $14, $14,  $B,  $B, -$F, -$F, -$F,-$14,-$14,-$14,-$14, -$C, -$C, -$C,  -2,  -2
                even

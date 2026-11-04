; Owner: game/special_stage/sk
; Responsibility: Tails special-stage follower animation, delayed position history and history reset
; Source provenance and ranges: config/reconstruction/source_layout.json
SStageTails_InitializeFollower:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$180,priority(a0)
                move.l  #Map_SStageTails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2,1,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.w  #0,$34(a0)
                move.w  #-$800,$36(a0)
                move.w  #-$20,$38(a0)
                move.b  #$FF,$3A(a0)
                bsr.w   SStage_ClearTailsInputHistory
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   SStageTails_InstallFollowerUpdate
                move.l  #SStageTailsTail_InitializeAttachment,(a1)
                move.w  a0,$3E(a1)

SStageTails_InstallFollowerUpdate:
                move.l  #SStageTails_UpdateVelocityBasedRunCycle,(a0)

SStageTails_UpdateVelocityBasedRunCycle:
                moveq   #$C,d0
                move.w  (Special_stage_velocity).w,d1
                beq.s   SStageTails_SelectRunOrJumpFrames
                asr.w   #5,d1
                add.w   d1,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame_timer(a0),d0
                bpl.s   SStageTails_WrapNonnegativeRunCycle
                addi.b  #$C,d0
                bra.s   SStageTails_SelectRunOrJumpFrames
; ---------------------------------------------------------------------------

SStageTails_WrapNonnegativeRunCycle:
                cmpi.b  #$C,d0
                blo.s   SStageTails_SelectRunOrJumpFrames
                subi.b  #$C,d0

SStageTails_SelectRunOrJumpFrames:
                move.b  d0,anim_frame_timer(a0)
                lea     (SStagePlayer_RunAndIdleMappingFrames).l,a1
                tst.b   (Special_stage_jumping_P2).w
                beq.s   SKSSTails_ApplyFrameAndCheckSpring
                lea     (SStageTails_JumpMappingFrames).l,a1
                move.w  (Special_stage_velocity).w,d1
                bne.s   SKSSTails_ApplyFrameAndCheckSpring
                move.b  (Level_frame_counter+1).w,d0
                andi.w  #3,d0

SKSSTails_ApplyFrameAndCheckSpring:
                move.b  (a1,d0.w),mapping_frame(a0)
                bsr.w   SStage_RecordTailsTileHistory
                cmpi.b  #5,$44(a0)
                bne.s   SKSSTails_CheckManualOrDelayedJump
                tst.b   (Special_stage_clear_routine).w
                bne.s   SKSSTails_CheckManualOrDelayedJump
                tst.b   (Special_stage_jumping_P2).w
                bmi.s   SKSSTails_CheckManualOrDelayedJump
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   SKSSTails_CheckManualOrDelayedJump
                move.l  #$FFE80000,$40(a0)
                move.b  #$81,(Special_stage_jumping_P2).w
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l

SKSSTails_CheckManualOrDelayedJump:
                bsr.w   SStage_GetTailsJumpInput
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SStageTails_IntegrateActiveJumpHeight
                tst.b   (Special_stage_jumping_P2).w
                bne.s   SStageTails_IntegrateActiveJumpHeight
                move.l  #$FFF00000,$40(a0)
                move.b  #$80,(Special_stage_jumping_P2).w
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SStageTails_IntegrateActiveJumpHeight:
                tst.b   (Special_stage_jumping_P2).w
                bpl.s   SStageTails_ProjectDrawAndUploadFrame
                move.l  $3C(a0),d0
                add.l   $40(a0),d0
                bmi.s   SStageTails_ApplyGravityAndProjectHeight
                moveq   #0,d0
                move.l  d0,$40(a0)
                move.b  d0,(Special_stage_jumping_P2).w

SStageTails_ApplyGravityAndProjectHeight:
                move.w  (Special_stage_rate).w,d1
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,$40(a0)
                move.l  d0,$3C(a0)
                swap    d0
                addi.w  #-$800,d0
                move.w  d0,$36(a0)

SStageTails_ProjectDrawAndUploadFrame:
                bsr.w   SStage_ProjectCharacterCoordinates
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageTails).l,a2
                move.l  #ArtUnc_SStageTails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2),d4
                bra.w   SStagePlayer_QueueArtForChangedFrame

; =============== S U B R O U T I N E =======================================

SStage_GetTailsJumpInput:
                move.w  (Pos_table_index).w,d0
                lea     (Pos_table).w,a1
                lea     (a1,d0.w),a1
                move.w  (Ctrl_1).w,(a1)
                move.b  (Special_stage_jumping).w,2(a1)
                addq.b  #4,(Pos_table_index+1).w
                move.b  (Ctrl_2_held).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSSTails_ReadManualInputDuringOverride
                move.w  #600,(Tails_CPU_idle_timer).w

SKSSTails_ReadManualInputDuringOverride:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKSSTails_ReadDelayedNormalJumpButtons
                subq.w  #1,(Tails_CPU_idle_timer).w
                move.w  (Ctrl_2).w,d0
                rts
; ---------------------------------------------------------------------------

SKSSTails_ReadDelayedNormalJumpButtons:
                lea     (Pos_table).w,a1
                move.w  #4,d1
                lsl.b   #2,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.b  2(a1,d0.w),d2
                subq.b  #4,d0
                move.b  2(a1,d0.w),d1
                moveq   #0,d0
                cmpi.b  #-$7F,d2
                beq.s   SStageTails_ReturnHistoryJumpButtons
                tst.b   d1
                bpl.s   SStageTails_ReturnHistoryJumpButtons
                move.w  #$70,d0

SStageTails_ReturnHistoryJumpButtons:
                rts
; End of function SStage_GetTailsJumpInput

; =============== S U B R O U T I N E =======================================

SStage_ClearTailsInputHistory:
                lea     (Pos_table).w,a2
                move.w  #bytesToLcnt($100),d0

SStageTails_ClearInputHistoryLongLoop:
                move.l  #0,(a2)+
                dbf     d0,SStageTails_ClearInputHistoryLongLoop
                move.w  #0,(Pos_table_index).w
                move.w  #0,(Tails_CPU_idle_timer).w
                rts
; End of function SStage_ClearTailsInputHistory

; =============== S U B R O U T I N E =======================================

SStage_RecordTailsTileHistory:
                lea     (SStage_layout_buffer+$100).w,a1
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  (Special_stage_Y_pos).w,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                lea     (a1,d1.w),a1
                lea     $44(a0),a2
                move.b  1(a2),(a2)
                move.b  2(a2),1(a2)
                move.b  3(a2),2(a2)
                move.b  (a1),3(a2)
                rts
; End of function SStage_RecordTailsTileHistory

; Owner: game/special_stage/s3
; Responsibility: Projected tail and shadow rendering, scalar setup, stage motion and layout-space response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SStageTailsTail_InitializeAttachment:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$100,priority(a0)
                move.l  #Map_SStageTailstails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2_Tail,1,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.b  #-1,$3A(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #S3SS_TailFollowAndSelectRate,(a0)

S3SS_TailFollowAndSelectRate:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #$2AAA,d0
                move.w  (Special_stage_velocity).w,d1
                bmi.s   S3SS_TailAdvanceFrameOnCarry
                add.w   d1,d0

S3SS_TailAdvanceFrameOnCarry:
                add.w   d0,anim_frame_timer(a0)
                bcc.s   SStageTailsTail_DrawAndQueueChangedArt
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #$F,d0
                blo.s   SStageTailsTail_StoreAdvancedFrame
                moveq   #1,d0

SStageTailsTail_StoreAdvancedFrame:
                move.b  d0,mapping_frame(a0)

SStageTailsTail_DrawAndQueueChangedArt:
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageTailstails).l,a2
                move.l  #ArtUnc_SStageTailstails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2_Tail),d4
                bra.w   SStagePlayer_QueueArtForChangedFrame
; ---------------------------------------------------------------------------

S3SS_InitPrimaryShadowPosition:
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #0,$38(a0)

S3SS_InitShadowAttrsAndProject:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$380,priority(a0)
                move.l  #Map_SStageShadow,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Shadow,3,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.b  #-1,$3A(a0)
                bsr.w   SStage_ProjectCharacterCoordinates
                move.l  #SStageShadow_DrawOnlyWhenNotFading,(a0)
                rts
; ---------------------------------------------------------------------------

SStageShadow_DrawOnlyWhenNotFading:
                tst.b   (Special_stage_fade_timer).w
                beq.s   SStageShadow_Draw
                rts
; ---------------------------------------------------------------------------

SStageShadow_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SS_InitFollowerShadowPosition:
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #$FFE0,$38(a0)
                bra.s   S3SS_InitShadowAttrsAndProject
; ---------------------------------------------------------------------------
Map_SStageShadow:
                include "src/game/special_stage/shared/mappings/shadow.s"

; =============== S U B R O U T I N E =======================================

; Refresh the four Q14 sine and cosine pairs used for character projection
SStage_UpdateProjectionScalars:
                move.w  (SStage_scalar_index_2).w,d0
                lea     (SStage_scalar_result_2).w,a1
                bsr.w   GetScalars2
                move.w  (SStage_scalar_index_1).w,d0
                lea     (SStage_scalar_result_1).w,a1
                bsr.w   GetScalars2
                move.w  (SStage_scalar_index_0).w,d0
                lea     (SStage_scalar_result_0).w,a1
                bsr.w   GetScalars2
                move.w  #$E0,d0
                lea     (SStage_scalar_result_3).w,a1
                bsr.w   GetScalars2
                rts
; End of function SStage_UpdateProjectionScalars

; =============== S U B R O U T I N E =======================================

SStage_ProjectCharacterCoordinates:
                move.w  $34(a0),d1
                move.w  $36(a0),d2
                move.w  $38(a0),d0
                bsr.w   SStage_RotateDepthHeight
                bsr.w   SStage_RotateDepthHorizontal
                bsr.w   SStage_RotateHorizontalVertical
                addi.w  #$100,d0
                addi.w  #$980,d2
                bsr.w   SStage_ApplyProjectionViewTilt
                ext.l   d1
                lsl.l   #8,d1
                divs.w  d0,d1
                ext.l   d2
                lsl.l   #8,d2
                divs.w  d0,d2
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $32(a0),d2
                move.w  d2,y_pos(a0)
                rts
; End of function SStage_ProjectCharacterCoordinates

; =============== S U B R O U T I N E =======================================

SStage_UpdatePlayerGridMotion:
                tst.b   (Special_stage_fade_timer).w
                beq.s   S3SS_SelectTurnAlignmentAxis
                cmpi.b  #$61,(Special_stage_fade_timer).w
                bhs.s   S3SS_CheckAlignmentAfterFade
                moveq   #8,d1
                add.b   d1,(Special_stage_angle).w
                addq.b  #1,(Special_stage_fade_timer).w
                rts
; ---------------------------------------------------------------------------

S3SS_CheckAlignmentAfterFade:
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                beq.s   S3SS_SelectTurnAlignmentAxis
                move.b  #0,(Special_stage_fade_timer).w

S3SS_SelectTurnAlignmentAxis:
                move.w  (Special_stage_X_pos).w,d3
                btst    #6,(Special_stage_angle).w
                bne.s   S3SS_TurnAtAlignedGroundCell
                move.w  (Special_stage_Y_pos).w,d3

S3SS_TurnAtAlignedGroundCell:
                moveq   #0,d2
                move.b  (Special_stage_turning).w,d1
                beq.s   S3SS_UnlockTurnOutsideCellCenter
                andi.w  #$E0,d3
                bne.s   S3SS_UnlockTurnOutsideCellCenter
                tst.b   (Special_stage_jumping).w
                bmi.s   S3SS_LoadControlsAndVelocity
                add.b   d1,(Special_stage_angle).w
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   S3SS_GridMovementReturn
                move.b  #0,(Special_stage_turning).w
                move.b  #0,(Special_stage_bumper_lock).w
                tst.w   (Special_stage_velocity).w
                beq.s   S3SS_UnlockTurnOutsideCellCenter
                move.b  #1,(Special_stage_turn_lock).w

S3SS_UnlockTurnOutsideCellCenter:
                andi.w  #$E0,d3
                beq.s   S3SS_LoadControlsAndVelocity
                move.b  #0,(Special_stage_turn_lock).w

S3SS_LoadControlsAndVelocity:
                move.b  (Ctrl_1_held).w,d1
                move.w  (Special_stage_velocity).w,d2
                tst.b   (Special_stage_clear_routine).w
                bne.w   S3SS_IntegrateGridAndHandleCell
                tst.b   (Special_stage_bumper_lock).w
                bne.s   S3SS_RequestLeftIfUnlocked
                btst    #button_up,d1
                beq.s   S3SS_AccelerateTowardMoveRate
                move.b  #1,(Special_stage_advancing).w

S3SS_AccelerateTowardMoveRate:
                tst.b   (Special_stage_advancing).w
                beq.s   S3SS_RequestLeftIfUnlocked
                move.w  (Special_stage_rate).w,d3
                addi.w  #$200,d2
                cmp.w   d3,d2
                blt.s   S3SS_RequestLeftIfUnlocked
                move.w  d3,d2

S3SS_RequestLeftIfUnlocked:
                tst.b   (Special_stage_turn_lock).w
                bne.s   S3SS_StoreVelocityAndCheckBumper
                btst    #button_left,d1
                beq.s   S3SS_GiveRightTurnPriority
                move.b  #4,(Special_stage_turning).w

S3SS_GiveRightTurnPriority:
                btst    #button_right,d1
                beq.s   S3SS_StoreVelocityAndCheckBumper
                move.b  #-4,(Special_stage_turning).w

S3SS_StoreVelocityAndCheckBumper:
                move.w  d2,(Special_stage_velocity).w
                tst.b   (Special_stage_bumper_lock).w
                beq.s   S3SS_IntegrateGridAndHandleCell
                move.w  (Special_stage_X_pos).w,d0
                btst    #6,(Special_stage_angle).w
                bne.s   S3SS_UnlockBumperAtNewCell
                move.w  (Special_stage_Y_pos).w,d0

S3SS_UnlockBumperAtNewCell:
                andi.w  #$E0,d0
                bne.s   S3SS_UpdateLockedBumperMotion
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
                cmp.w   (Special_stage_interact).w,d1
                beq.s   S3SS_UpdateLockedBumperMotion
                move.b  #0,(Special_stage_bumper_lock).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   S3SS_SetBumperExitRateAndReturn
                neg.w   d2

S3SS_SetBumperExitRateAndReturn:
                move.w  d2,(Special_stage_velocity).w
                rts
; ---------------------------------------------------------------------------

S3SS_UpdateLockedBumperMotion:
                move.w  (Special_stage_velocity).w,d2
                bne.s   S3SS_NegateBumperStepVelocity
                move.b  #0,(Special_stage_bumper_lock).w
                move.b  #1,(Special_stage_advancing).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   S3SS_RestartStationaryBumper
                neg.w   d2

S3SS_RestartStationaryBumper:
                move.w  d2,(Special_stage_velocity).w
                bra.s   S3SS_IntegrateGridAndHandleCell
; ---------------------------------------------------------------------------

; Reverse the local integration velocity while keeping the stored rate
S3SS_NegateBumperStepVelocity:
                neg.w   d2

S3SS_IntegrateGridAndHandleCell:
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                swap    d0
                sub.w   d0,(Special_stage_X_pos).w
                swap    d1
                sub.w   d1,(Special_stage_Y_pos).w
                tst.b   (Special_stage_jumping).w
                bmi.s   S3SS_GridMovementReturn
                tst.b   (Special_stage_clear_routine).w
                bne.s   S3SS_GridMovementReturn
                bsr.s   SStage_HandlePlayerGridCell

S3SS_GridMovementReturn:
                rts
; End of function SStage_UpdatePlayerGridMotion

; =============== S U B R O U T I N E =======================================

SStage_HandlePlayerGridCell:
                lea     (Level_layout_header).w,a1
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
                move.b  (a1),d2
                beq.w   S3SS_GridContactReturn
                cmpi.b  #1,d2
                bne.s   S3SS_TryQueueBlueSphereContact
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   S3SS_RedSphereContactReturn
                tst.b   (Special_stage_fade_timer).w
                bne.s   S3SS_RedSphereContactReturn
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Special_bonus_entry_flag).w
                beq.s   S3SS_PlayRedSphereExitSound
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

S3SS_PlayRedSphereExitSound:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

S3SS_RedSphereContactReturn:
                rts
; ---------------------------------------------------------------------------

S3SS_TryQueueBlueSphereContact:
                cmpi.b  #2,d2
                bne.s   S3SS_LatchBumperCellIfUnlocked
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   S3SS_PlayBlueSphereSound
                move.b  #2,(a2)
                move.l  a1,4(a2)

; The sound still plays if the contact queue is full
S3SS_PlayBlueSphereSound:
                moveq   #signextendB(sfx_BlueSphere),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

S3SS_LatchBumperCellIfUnlocked:
                cmpi.b  #3,d2
                bne.s   S3SS_TryQueueRingResponse
                tst.b   (Special_stage_bumper_lock).w
                bne.s   S3SS_TryQueueRingResponse
                move.w  d1,(Special_stage_interact).w
                move.b  #1,(Special_stage_bumper_lock).w
                move.b  #0,(Special_stage_advancing).w
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

S3SS_TryQueueRingResponse:
                cmpi.b  #4,d2
                bne.s   S3SS_GridContactReturn
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   S3SS_TickRemainingRings
                move.b  #1,(a2)
                move.l  a1,4(a2)

; Decrement the perfect counter even when no response slot was available
S3SS_TickRemainingRings:
                subq.w  #1,(Special_stage_rings_left).w
                bne.s   S3SS_AddRingAndCheck50RingContinue
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_Music).l

S3SS_AddRingAndCheck50RingContinue:
                addi.w  #1,(Special_stage_ring_count).w
                bset    #7,(Special_stage_extra_life_flags).w
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   S3SS_Check100And200RingLifeLatches
                bset    #0,(Special_stage_extra_life_flags).w
                bne.s   S3SS_Check100And200RingLifeLatches
                addq.b  #1,(Continue_count).w
                move.w  #signextendB(sfx_Continue),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3SS_Check100And200RingLifeLatches:
                moveq   #signextendB(sfx_RingRight),d0
                cmpi.w  #100,(Special_stage_ring_count).w
                blo.s   S3SStage_PlayRingOrLifeSoundAndReturn
                bset    #1,(Special_stage_extra_life_flags).w
                beq.s   S3SS_AddLifeAndSelectSound
                cmpi.w  #200,(Special_stage_ring_count).w
                blo.s   S3SStage_PlayRingOrLifeSoundAndReturn
                bset    #2,(Special_stage_extra_life_flags).w
                bne.s   S3SStage_PlayRingOrLifeSoundAndReturn

S3SS_AddLifeAndSelectSound:
                addq.b  #1,(Life_count).w
                moveq   #signextendB(sfx_RingLoss),d0

S3SStage_PlayRingOrLifeSoundAndReturn:
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

S3SS_GridContactReturn:
                rts
; End of function SStage_HandlePlayerGridCell

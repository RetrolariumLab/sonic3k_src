; Owner: game/special_stage/sk
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
                move.l  #SKSS_TailFollowAndSelectRate,(a0)

SKSS_TailFollowAndSelectRate:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #$2AAA,d0
                move.w  (Special_stage_velocity).w,d1
                bmi.s   SKSS_TailAdvanceFrameOnCarry
                add.w   d1,d0

SKSS_TailAdvanceFrameOnCarry:
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

; =============== S U B R O U T I N E =======================================

Draw_SSShadows:
                lea     (SStageShadows_HardwareSpriteTemplates).l,a3
                move.w  (a3)+,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a3
                addq.w  #1,a6
                move.w  (a3)+,(a6)+
                move.w  (a3)+,(a6)+
                tst.w   (Player_mode).w
                bne.s   SStageShadows_ReturnAfterHardwareSprites
                move.w  (a3)+,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a3
                addq.w  #1,a6
                move.w  (a3)+,(a6)+
                move.w  (a3)+,(a6)+

SStageShadows_ReturnAfterHardwareSprites:
                rts
; End of function Draw_SSShadows

; ---------------------------------------------------------------------------
SStageShadows_HardwareSpriteTemplates:
                dc.w    $116, $F0A, make_art_tile(ArtTile_SStage_Shadow,3,1), $110
                dc.w    $127, $F0B, make_art_tile(ArtTile_SStage_Shadow,3,1), $110

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
                beq.s   SKSStage_SelectMotionAxisFromAngleBitSix
                cmpi.b  #$61,(Special_stage_fade_timer).w
                bhs.s   SKSS_CheckAlignmentAfterExitSpin
                moveq   #8,d1
                add.b   d1,(Special_stage_angle).w
                addq.b  #1,(Special_stage_fade_timer).w
                rts
; ---------------------------------------------------------------------------

SKSS_CheckAlignmentAfterExitSpin:
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                beq.s   SKSStage_SelectMotionAxisFromAngleBitSix
                move.b  #0,(Special_stage_fade_timer).w

SKSStage_SelectMotionAxisFromAngleBitSix:
                move.w  (Special_stage_X_pos).w,d3
                btst    #6,(Special_stage_angle).w
                bne.s   SKSS_TurnAtAlignedGroundCell
                move.w  (Special_stage_Y_pos).w,d3

SKSS_TurnAtAlignedGroundCell:
                moveq   #0,d2
                move.b  (Special_stage_turning).w,d1
                beq.s   SKSS_UnlockTurnOutsideCellCenter
                andi.w  #$E0,d3
                bne.s   SKSS_UnlockTurnOutsideCellCenter
                tst.b   (Special_stage_jumping).w
                bmi.s   SKSS_LoadControlsAndGateAcceleration
                add.b   d1,(Special_stage_angle).w
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   SKSS_GridMovementReturn
                move.b  #0,(Special_stage_turning).w
                tst.w   (Special_stage_velocity).w
                beq.s   SKSS_UnlockTurnOutsideCellCenter
                move.b  #1,(Special_stage_turn_lock).w

SKSS_UnlockTurnOutsideCellCenter:
                andi.w  #$E0,d3
                beq.s   SKSS_LoadControlsAndGateAcceleration
                move.b  #0,(Special_stage_turn_lock).w

SKSS_LoadControlsAndGateAcceleration:
                move.b  (Ctrl_1).w,d1
                move.w  (Special_stage_velocity).w,d2
                tst.b   (Special_stage_clear_routine).w
                bne.w   SKSStage_DoubleOnlySpringJumpWorkingStep
                tst.b   (Special_stage_bumper_lock).w
                bne.s   SKSStage_RequestLeftTurnUnlessTurnLocked
                btst    #button_up,d1
                beq.s   SKSS_AccelerateTowardReverseRate
                move.b  #1,(Special_stage_advancing).w
                move.b  #1,(Special_stage_started).w

SKSS_AccelerateTowardReverseRate:
                tst.b   (Special_stage_advancing).w
                bne.s   SKSS_AccelerateTowardForwardRate
                tst.b   (Special_stage_started).w
                beq.s   SKSStage_RequestLeftTurnUnlessTurnLocked
                tst.w   d2
                bpl.s   SKSS_AccelerateTowardForwardRate
                move.w  (Special_stage_rate).w,d3
                neg.w   d3
                subi.w  #$200,d2
                cmp.w   d3,d2
                bgt.s   SKSStage_RequestLeftTurnUnlessTurnLocked
                move.w  d3,d2
                bra.s   SKSStage_RequestLeftTurnUnlessTurnLocked
; ---------------------------------------------------------------------------

SKSS_AccelerateTowardForwardRate:
                move.w  (Special_stage_rate).w,d3
                addi.w  #$200,d2
                cmp.w   d3,d2
                blt.s   SKSStage_RequestLeftTurnUnlessTurnLocked
                move.w  d3,d2

SKSStage_RequestLeftTurnUnlessTurnLocked:
                tst.b   (Special_stage_turn_lock).w
                bne.s   SKSS_StoreVelocityAndCheckBumper
                btst    #button_left,d1
                beq.s   SKSS_GiveRightTurnPriority
                move.b  #4,(Special_stage_turning).w

SKSS_GiveRightTurnPriority:
                btst    #button_right,d1
                beq.s   SKSS_StoreVelocityAndCheckBumper
                move.b  #-4,(Special_stage_turning).w

SKSS_StoreVelocityAndCheckBumper:
                move.w  d2,(Special_stage_velocity).w
                tst.b   (Special_stage_bumper_lock).w
                beq.s   SKSStage_DoubleOnlySpringJumpWorkingStep
                move.w  (Special_stage_X_pos).w,d0
                btst    #6,(Special_stage_angle).w
                bne.s   SKSS_ReverseRateOnBumperExit
                move.w  (Special_stage_Y_pos).w,d0

SKSS_ReverseRateOnBumperExit:
                andi.w  #$E0,d0
                bne.s   SKSS_UpdateLockedBumperMotion
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
                beq.s   SKSS_UpdateLockedBumperMotion
                move.b  #0,(Special_stage_bumper_lock).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   SKSS_SetBumperExitRateAndReturn
                neg.w   d2

SKSS_SetBumperExitRateAndReturn:
                move.w  d2,(Special_stage_velocity).w
                rts
; ---------------------------------------------------------------------------

SKSS_UpdateLockedBumperMotion:
                move.w  (Special_stage_velocity).w,d2
                bne.s   SKSS_NegateBumperStepVelocity
                move.b  #0,(Special_stage_bumper_lock).w
                move.b  #1,(Special_stage_advancing).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   SKSS_RestartStationaryBumper
                neg.w   d2

SKSS_RestartStationaryBumper:
                move.w  d2,(Special_stage_velocity).w
                bra.s   SKSStage_DoubleOnlySpringJumpWorkingStep
; ---------------------------------------------------------------------------

; Reverse the local integration velocity while keeping the stored rate
SKSS_NegateBumperStepVelocity:
                neg.w   d2

SKSStage_DoubleOnlySpringJumpWorkingStep:
                cmpi.b  #$81,(Special_stage_jumping).w
                bne.s   SKSS_IntegrateGridAndHandleCell
                add.w   d2,d2

SKSS_IntegrateGridAndHandleCell:
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                swap    d0
                sub.w   d0,(Special_stage_X_pos).w
                swap    d1
                sub.w   d1,(Special_stage_Y_pos).w
                tst.b   (Special_stage_jumping).w
                bmi.s   SKSS_GridMovementReturn
                tst.b   (Special_stage_clear_routine).w
                bne.s   SKSS_GridMovementReturn
                bsr.s   SStage_HandlePlayerGridCell

SKSS_GridMovementReturn:
                rts
; End of function SStage_UpdatePlayerGridMotion

; =============== S U B R O U T I N E =======================================

SStage_HandlePlayerGridCell:
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
                move.b  (a1),d2
                beq.w   SKSS_GridContactReturn
                cmpi.b  #1,d2
                bne.s   SKSS_TryQueueBlueSphereContact
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   SKSS_RedSphereContactReturn
                tst.b   (Special_stage_fade_timer).w
                bne.s   SKSS_RedSphereContactReturn
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   SKSS_RestoreZoneAfterRedSphere
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

SKSS_RestoreZoneAfterRedSphere:
                tst.b   (Special_bonus_entry_flag).w
                beq.s   SKSS_PlayRedSphereExitSound
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

SKSS_PlayRedSphereExitSound:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

SKSS_RedSphereContactReturn:
                rts
; ---------------------------------------------------------------------------

SKSS_TryQueueBlueSphereContact:
                cmpi.b  #2,d2
                bne.s   SKSStage_LatchBumperCellAndStopAdvancing
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   SKSS_PlayBlueSphereSound
                move.b  #2,(a2)
                move.l  a1,4(a2)

; The sound still plays if the contact queue is full
SKSS_PlayBlueSphereSound:
                moveq   #signextendB(sfx_BlueSphere),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSStage_LatchBumperCellAndStopAdvancing:
                cmpi.b  #3,d2
                bne.s   SKSS_ArmSpringJumpAtCardinalAngle
                tst.b   (Special_stage_bumper_lock).w
                bne.s   SKSS_ArmSpringJumpAtCardinalAngle
                move.w  d1,(Special_stage_interact).w
                move.b  #1,(Special_stage_bumper_lock).w
                move.b  #0,(Special_stage_advancing).w
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSS_ArmSpringJumpAtCardinalAngle:
                cmpi.b  #5,d2
                bne.s   SKSS_TryQueueRingResponse
                tst.b   (Special_stage_clear_routine).w
                bne.s   SKSS_TryQueueRingResponse
                tst.b   (Special_stage_jumping).w
                bmi.s   SKSS_TryQueueRingResponse
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   SKSS_TryQueueRingResponse
                move.l  #$FFE80000,$40(a0)
                move.b  #$81,(Special_stage_jumping).w
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l

SKSS_TryQueueRingResponse:
                cmpi.b  #4,d2
                bne.w   SKSS_GridContactReturn
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   SKSS_TickRemainingRingsAndCheckPerfect
                move.b  #1,(a2)
                move.l  a1,4(a2)

SKSS_TickRemainingRingsAndCheckPerfect:
                tst.w   (Special_stage_rings_left).w
                beq.s   SKSS_AddRingAndCheckContinue
                subq.w  #1,(Special_stage_rings_left).w
                bne.s   SKSS_AddRingAndCheckContinue
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_Music).l

SKSS_AddRingAndCheckContinue:
                addi.w  #1,(Special_stage_ring_count).w
                bset    #7,(Special_stage_extra_life_flags).w
                moveq   #signextendB(sfx_RingRight),d0
                tst.b   (Blue_spheres_stage_flag).w
                bne.s   SKSS_PlayRingOrLifeSound
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   SKSS_Check100And200RingLifeLatches
                bset    #0,(Special_stage_extra_life_flags).w
                bne.s   SKSS_Check100And200RingLifeLatches
                addq.b  #1,(Continue_count).w
                move.w  #signextendB(sfx_Continue),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKSS_Check100And200RingLifeLatches:
                moveq   #signextendB(sfx_RingRight),d0
                cmpi.w  #100,(Special_stage_ring_count).w
                blo.s   SKSS_PlayRingOrLifeSound
                bset    #1,(Special_stage_extra_life_flags).w
                beq.s   SKSS_AddLifeAndSelectSound
                cmpi.w  #200,(Special_stage_ring_count).w
                blo.s   SKSS_PlayRingOrLifeSound
                bset    #2,(Special_stage_extra_life_flags).w
                bne.s   SKSS_PlayRingOrLifeSound

SKSS_AddLifeAndSelectSound:
                addq.b  #1,(Life_count).w
                moveq   #signextendB(sfx_RingLoss),d0

SKSS_PlayRingOrLifeSound:
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSS_GridContactReturn:
                rts
; End of function SStage_HandlePlayerGridCell

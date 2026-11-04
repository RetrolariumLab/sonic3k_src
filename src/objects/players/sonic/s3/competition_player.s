; Owner: objects/players/sonic/s3
; Responsibility: Competition Sonic object dispatch, player initialization and shared two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic2P:
                cmpa.w  #Player_1,a0
                bne.s   S3SonicCompetition_SelectSecondaryPlayerBasesAndToggleMatchingCharacterTopViewportMask
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   S3SonicCompetition_GatePrimaryPlayerDebugPlacementBeforeRoutineDispatch
                bchg    #3,render_flags(a0)

S3SonicCompetition_GatePrimaryPlayerDebugPlacementBeforeRoutineDispatch:
                tst.w   (Debug_placement_mode).w
                beq.s   S3SonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

S3SonicCompetition_SelectSecondaryPlayerBasesAndToggleMatchingCharacterTopViewportMask:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   S3SonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries
                bchg    #4,render_flags(a0)

S3SonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic2P_Index(pc,d0.w),d1
                jmp     Sonic2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic2P_Index:
                dc.w    S3SonicCompetition_InitializeCompactCompetitionGeometrySpeedsAndOptionalRespawnSnapshot-Sonic2P_Index
                dc.w    S3SonicCompetition_EnterPrimaryCompetitionDebugPlacementOnNewPhysicalB-Sonic2P_Index
                dc.w    S3Recovery_HurtState4-Sonic2P_Index
                dc.w    S3Recovery_DeathState6-Sonic2P_Index
                dc.w    S3Recovery_RestartState8-Sonic2P_Index
                dc.w    S3Recovery_ScrollWaitStateA-Sonic2P_Index
; ---------------------------------------------------------------------------

S3SonicCompetition_InitializeCompactCompetitionGeometrySpeedsAndOptionalRespawnSnapshot:
                addq.b  #2,routine(a0)
                move.b  #$B,y_radius(a0)
                move.b  #5,x_radius(a0)
                move.b  #$B,default_y_radius(a0)
                move.b  #5,default_x_radius(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #4,render_flags(a0)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed-Max_speed(a4)
                move.w  (a1)+,Acceleration-Max_speed(a4)
                move.w  (a1)+,Deceleration-Max_speed(a4)
                tst.b   (Last_star_post_hit).w
                bne.w   S3SonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   S3SonicCompetition_SelectSecondaryCompactMappingsPaletteAndArtTile
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   S3SonicCompetition_ApplyPrimaryZoneSpecificHighPriorityBeforeSavingRespawnState
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

S3SonicCompetition_ApplyPrimaryZoneSpecificHighPriorityBeforeSavingRespawnState:
                cmpi.b  #$12,(Current_zone).w
                bne.s   S3SonicCompetition_SavePrimaryCompetitionRespawnCoordinatesArtAndSolidity
                ori.w   #high_priority,art_tile(a0)

S3SonicCompetition_SavePrimaryCompetitionRespawnCoordinatesArtAndSolidity:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   S3SonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory
; ---------------------------------------------------------------------------

S3SonicCompetition_SelectSecondaryCompactMappingsPaletteAndArtTile:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   S3SonicCompetition_ApplySecondaryZoneSpecificHighPriorityBeforeSavingRespawnState
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

S3SonicCompetition_ApplySecondaryZoneSpecificHighPriorityBeforeSavingRespawnState:
                cmpi.b  #$12,(Current_zone).w
                bne.s   S3SonicCompetition_SaveSecondaryCompetitionRespawnCoordinatesArtAndSolidity
                ori.w   #high_priority,art_tile(a0)

S3SonicCompetition_SaveSecondaryCompetitionRespawnCoordinatesArtAndSolidity:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w

S3SonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                bsr.w   Reset_Player_Position_Array

S3SonicCompetition_EnterPrimaryCompetitionDebugPlacementOnNewPhysicalB:
                tst.w   (Debug_mode_flag).w
                beq.s   S3SonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                cmpa.w  #Player_1,a0
                bne.s   S3SonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3SonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked:
                cmpa.w  #Player_1,a0
                bne.s   S3SonicCompetition_CopySecondaryControllerWordIntoSharedLogicalInputUnlessLocked
                tst.b   (Ctrl_1_locked).w
                bne.s   S3SonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   S3SonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
; ---------------------------------------------------------------------------

S3SonicCompetition_CopySecondaryControllerWordIntoSharedLogicalInputUnlessLocked:
                tst.b   (Ctrl_2_locked).w
                bne.s   S3SonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
                move.w  (Ctrl_2).w,(Ctrl_1_logical).w

S3SonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero:
                bsr.w   Sonic_Display
                btst    #0,object_control(a0)
                bne.s   S3SonicCompetition_WrapIntegerPlayerYOnlyAtSharedMinusOneHundredCameraMinimum
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable(pc,d0.w),d1
                jsr     S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable(pc,d1.w)

S3SonicCompetition_WrapIntegerPlayerYOnlyAtSharedMinusOneHundredCameraMinimum:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3SonicCompetition_WrapIntegerXRecordPositionAndGateCompactAnimationPatterns
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3SonicCompetition_WrapIntegerXRecordPositionAndGateCompactAnimationPatterns:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   S3SonicCompetition_RunCompetitionTouchUnlessControlBitsFiveOrSevenSet
                bsr.w   Animate_SonicKnuckles_2P
                bsr.w   SonicKnuckles2P_Load_PLC

S3SonicCompetition_RunCompetitionTouchUnlessControlBitsFiveOrSevenSet:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   S3SonicCompetition_ReturnAfterCompetitionNormalTailAndOptionalTouch
                jsr     (TouchResponse_CompetitionMode).l

S3SonicCompetition_ReturnAfterCompetitionNormalTailAndOptionalTouch:
                rts
; ---------------------------------------------------------------------------
S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable:
                dc.w    S3SonicCompetition_GateGroundStepForLiteralExtendedIdleAnimationState-S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    S3SonicCompetition_UpdateCompetitionNonrollingAirWithOrdinaryIntegrator-S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    S3SonicCompetition_GateCompetitionRollingJumpBySpindashFlag-S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    S3SonicCompetition_UpdateCompetitionRollingAirWithOrdinaryIntegrator-S3SonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
; ---------------------------------------------------------------------------

S3SonicCompetition_GateGroundStepForLiteralExtendedIdleAnimationState:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   S3SonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                cmpi.b  #$A,anim(a0)
                beq.s   S3SonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass
                cmpi.b  #$B,anim(a0)
                beq.s   S3SonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass
                cmpi.b  #5,anim(a0)
                bne.s   S3SonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                cmpi.b  #$1E,anim_frame(a0)
                blo.s   S3SonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                bsr.w   Player_SlopeResist
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   S3SonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
                move.b  #$A,anim(a0)
                cmpi.b  #$AC,anim_frame(a0)
                blo.s   S3SonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
                move.b  #$B,anim(a0)
                bra.s   S3SonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
; ---------------------------------------------------------------------------

S3SonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller:
                bsr.w   SonicS3HandleCompetitionSpindashAndAbortGroundStep
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicS3TryCompetitionRollFromDown
                jsr     (MoveSprite2).l

S3SonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel:
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel

S3SonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass:
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_UpdateCompetitionNonrollingAirWithOrdinaryIntegrator:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3SonicCompetition_ResolveCompetitionAirTerrainWhilePreservingActorBaseRegisters
                subi.w  #$28,y_vel(a0)

S3SonicCompetition_ResolveCompetitionAirTerrainWhilePreservingActorBaseRegisters:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_GateCompetitionRollingJumpBySpindashFlag:
                tst.b   spin_dash_flag(a0)
                bne.s   S3SonicCompetition_AdvanceCompetitionGroundRollAndAttachWithoutLevelBounds
                bsr.w   Sonic_Jump

S3SonicCompetition_AdvanceCompetitionGroundRollAndAttachWithoutLevelBounds:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_UpdateCompetitionRollingAirWithOrdinaryIntegrator:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   S3SonicCompetition_ResolveCompetitionRollingAirTerrainWhilePreservingActorBases
                subi.w  #$28,y_vel(a0)

S3SonicCompetition_ResolveCompetitionRollingAirTerrainWhilePreservingActorBases:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

SonicS3TryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   S3SonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                move.w  ground_vel(a0),d0
                bpl.s   S3SonicCompetition_RequireCompetitionRollSpeedAndDownWithoutHorizontalInput
                neg.w   d0

S3SonicCompetition_RequireCompetitionRollSpeedAndDownWithoutHorizontalInput:
                cmpi.w  #$80,d0
                blo.s   S3SonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3SonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                btst    #button_down,(Ctrl_1_held_logical).w
                bne.s   S3SonicCompetition_AvoidRepeatingCompetitionRollGeometryWhenAlreadyRolling

S3SonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails:
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_AvoidRepeatingCompetitionRollGeometryWhenAlreadyRolling:
                btst    #2,status(a0)
                beq.s   S3SonicCompetition_EnterCompactRollAndApplyLiteralPositiveFourPixelYOffset
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_EnterCompactRollAndApplyLiteralPositiveFourPixelYOffset:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   S3SonicCompetition_ReturnAfterCompetitionRollEntryAndOptionalFallbackSpeed
                move.w  #$200,ground_vel(a0)

S3SonicCompetition_ReturnAfterCompetitionRollEntryAndOptionalFallbackSpeed:
                rts
; End of function SonicS3TryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

SonicS3HandleCompetitionSpindashAndAbortGroundStep:
                tst.b   spin_dash_flag(a0)
                bne.s   S3SonicCompetition_MaintainChargedSpindashOrReleaseUsingChargeIntegerByte
                cmpi.b  #8,anim(a0)
                bne.s   S3SonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3SonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3SonicCompetition_AttachAtSpindashStartAfterDiscardingGroundHelperReturn
                move.b  #2,anim(a6)

S3SonicCompetition_AttachAtSpindashStartAfterDiscardingGroundHelperReturn:
                bsr.w   Player_AnglePos

S3SonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart:
                rts
; ---------------------------------------------------------------------------

S3SonicCompetition_MaintainChargedSpindashOrReleaseUsingChargeIntegerByte:
                move.b  (Ctrl_1_held_logical).w,d0
                btst    #button_down,d0
                bne.w   S3SonicCompetition_DecayCompetitionChargeWordWhileDownRemainsHeld
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  S3SonicCompetition_NormalCompetitionSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicCompetition_ComputeReleasedSpindashCameraHistoryLagAndChoosePlayerWord
                move.w  S3SonicCompetition_RetainedPoweredCompetitionSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)

S3SonicCompetition_ComputeReleasedSpindashCameraHistoryLagAndChoosePlayerWord:
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   S3SonicCompetition_StorePlayerCameraHistoryLagAndSignLaunchByFacing
                lea     (H_scroll_frame_offset_P2).w,a1

S3SonicCompetition_StorePlayerCameraHistoryLagAndSignLaunchByFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   S3SonicCompetition_CommitReleasedRollStopChargeDustAndPlayDashSound
                neg.w   ground_vel(a0)

S3SonicCompetition_CommitReleasedRollStopChargeDustAndPlayDashSound:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   S3SonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
; ---------------------------------------------------------------------------
S3SonicCompetition_NormalCompetitionSpindashLaunchSpeedWords:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
S3SonicCompetition_RetainedPoweredCompetitionSpindashLaunchSpeedWords:
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

S3SonicCompetition_DecayCompetitionChargeWordWhileDownRemainsHeld:
                tst.w   spin_dash_counter(a0)
                beq.s   S3SonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   S3SonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation
                move.w  #0,spin_dash_counter(a0)

S3SonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3SonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   S3SonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
                move.w  #$800,spin_dash_counter(a0)

S3SonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   S3SonicCompetition_AttachChargedOrReleasedSpindashAndExitAbortedGroundMode
                bcc.s   S3SonicCompetition_SubtractCompetitionSpindashCameraRecoveryStep
                addq.w  #4,(a5)

S3SonicCompetition_SubtractCompetitionSpindashCameraRecoveryStep:
                subq.w  #2,(a5)

S3SonicCompetition_AttachChargedOrReleasedSpindashAndExitAbortedGroundMode:
                bsr.w   Player_AnglePos
                rts
; End of function SonicS3HandleCompetitionSpindashAndAbortGroundStep

; ---------------------------------------------------------------------------

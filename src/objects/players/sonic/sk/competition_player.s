; Owner: objects/players/sonic/sk
; Responsibility: Competition Sonic object dispatch, player initialization and shared two-player movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Sonic2P:
                cmpa.w  #Player_1,a0
                bne.s   SKSonicCompetition_SelectSecondaryPlayerBasesAndToggleMatchingCharacterTopViewportMask
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                move.b  (Player_2+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   SKSonicCompetition_GatePrimaryPlayerDebugPlacementBeforeRoutineDispatch
                bchg    #3,render_flags(a0)

SKSonicCompetition_GatePrimaryPlayerDebugPlacementBeforeRoutineDispatch:
                tst.w   (Debug_placement_mode).w
                beq.s   SKSonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

SKSonicCompetition_SelectSecondaryPlayerBasesAndToggleMatchingCharacterTopViewportMask:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                move.b  (Player_1+character_id).w,d0
                cmp.b   character_id(a0),d0
                bne.s   SKSonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries
                bchg    #4,render_flags(a0)

SKSonicCompetition_DispatchCompetitionRoutineByteThroughSixRelativeEntries:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sonic2P_Index(pc,d0.w),d1
                jmp     Sonic2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Sonic2P_Index:
                dc.w    SKSonicCompetition_InitializeCompactCompetitionGeometrySpeedsAndOptionalRespawnSnapshot-Sonic2P_Index
                dc.w    SKSonicCompetition_EnterPrimaryCompetitionDebugPlacementOnNewPhysicalB-Sonic2P_Index
                dc.w    SKPlayerRecovery_HurtStateFourWithDebugPlacementEscape-Sonic2P_Index
                dc.w    SKPlayerRecovery_DeathStateSixWithDebugPlacementEscape-Sonic2P_Index
                dc.w    SKPlayerRecovery_RestartStateEightCountsNonzeroWordTimerToExactZero-Sonic2P_Index
                dc.w    SKPlayerRecovery_ScrollWaitStateAResumesControlWhenBothGlobalDeltasZero-Sonic2P_Index
; ---------------------------------------------------------------------------

SKSonicCompetition_InitializeCompactCompetitionGeometrySpeedsAndOptionalRespawnSnapshot:
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
                bne.w   SKSonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpa.w  #Player_1,a0
                bne.s   SKSonicCompetition_SelectSecondaryCompactMappingsPaletteAndArtTile
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   SKSonicCompetition_ApplyPrimaryZoneSpecificHighPriorityBeforeSavingRespawnState
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

SKSonicCompetition_ApplyPrimaryZoneSpecificHighPriorityBeforeSavingRespawnState:
                cmpi.b  #$12,(Current_zone).w
                bne.s   SKSonicCompetition_SavePrimaryCompetitionRespawnCoordinatesArtAndSolidity
                ori.w   #high_priority,art_tile(a0)

SKSonicCompetition_SavePrimaryCompetitionRespawnCoordinatesArtAndSolidity:
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   SKSonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory
; ---------------------------------------------------------------------------

SKSonicCompetition_SelectSecondaryCompactMappingsPaletteAndArtTile:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Map_Sonic2P,mappings(a0)
                tst.b   character_id(a0)
                beq.s   SKSonicCompetition_ApplySecondaryZoneSpecificHighPriorityBeforeSavingRespawnState
                move.l  #Map_Knuckles2P,mappings(a0)
                addi.w  #palette_line_1,art_tile(a0)

SKSonicCompetition_ApplySecondaryZoneSpecificHighPriorityBeforeSavingRespawnState:
                cmpi.b  #$12,(Current_zone).w
                bne.s   SKSonicCompetition_SaveSecondaryCompetitionRespawnCoordinatesArtAndSolidity
                ori.w   #high_priority,art_tile(a0)

SKSonicCompetition_SaveSecondaryCompetitionRespawnCoordinatesArtAndSolidity:
                move.w  x_pos(a0),(Saved2_X_pos).w
                move.w  y_pos(a0),(Saved2_Y_pos).w
                move.w  art_tile(a0),(Saved2_art_tile).w
                move.w  top_solid_bit(a0),(Saved2_solid_bits).w

SKSonicCompetition_FinalizeCompetitionInitializationAndSeedPositionHistory:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                bsr.w   Reset_Player_Position_Array

SKSonicCompetition_EnterPrimaryCompetitionDebugPlacementOnNewPhysicalB:
                tst.w   (Debug_mode_flag).w
                beq.s   SKSonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                cmpa.w  #Player_1,a0
                bne.s   SKSonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKSonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_CopyPrimaryControllerWordUnlessItsInputIsLocked:
                cmpa.w  #Player_1,a0
                bne.s   SKSonicCompetition_CopySecondaryControllerWordIntoSharedLogicalInputUnlessLocked
                tst.b   (Ctrl_1_locked).w
                bne.s   SKSonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                bra.s   SKSonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
; ---------------------------------------------------------------------------

SKSonicCompetition_CopySecondaryControllerWordIntoSharedLogicalInputUnlessLocked:
                tst.b   (Ctrl_2_locked).w
                bne.s   SKSonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero
                move.w  (Ctrl_2).w,(Ctrl_1_logical).w

SKSonicCompetition_QueueBlinkDisplayAndGateCompetitionMovementByControlBitZero:
                bsr.w   Sonic_Display
                btst    #0,object_control(a0)
                bne.s   SKSonicCompetition_WrapIntegerPlayerYOnlyAtSharedMinusOneHundredCameraMinimum
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable(pc,d0.w),d1
                jsr     SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable(pc,d1.w)

SKSonicCompetition_WrapIntegerPlayerYOnlyAtSharedMinusOneHundredCameraMinimum:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKSonicCompetition_WrapIntegerXRecordPositionAndGateCompactAnimationPatterns
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKSonicCompetition_WrapIntegerXRecordPositionAndGateCompactAnimationPatterns:
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                bsr.w   Sonic_RecordPos
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                btst    #1,object_control(a0)
                bne.s   SKSonicCompetition_RunCompetitionTouchUnlessControlBitsFiveOrSevenSet
                bsr.w   Animate_SonicKnuckles_2P
                bsr.w   SonicKnuckles2P_Load_PLC

SKSonicCompetition_RunCompetitionTouchUnlessControlBitsFiveOrSevenSet:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   SKSonicCompetition_ReturnAfterCompetitionNormalTailAndOptionalTouch
                jsr     (TouchResponse_CompetitionMode).l

SKSonicCompetition_ReturnAfterCompetitionNormalTailAndOptionalTouch:
                rts
; ---------------------------------------------------------------------------
SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable:
                dc.w    SKSonicCompetition_GateGroundStepForLiteralExtendedIdleAnimationState-SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    SKSonicCompetition_UpdateCompetitionNonrollingAirWithOrdinaryIntegrator-SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    SKSonicCompetition_GateCompetitionRollingJumpBySpindashFlag-SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
                dc.w    SKSonicCompetition_UpdateCompetitionRollingAirWithOrdinaryIntegrator-SKSonicCompetition_CompetitionGroundAirRollJumpRelativeModeTable
; ---------------------------------------------------------------------------

SKSonicCompetition_GateGroundStepForLiteralExtendedIdleAnimationState:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   SKSonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                cmpi.b  #$A,anim(a0)
                beq.s   SKSonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass
                cmpi.b  #$B,anim(a0)
                beq.s   SKSonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass
                cmpi.b  #5,anim(a0)
                bne.s   SKSonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                cmpi.b  #$1E,anim_frame(a0)
                blo.s   SKSonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller
                bsr.w   Player_SlopeResist
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
                move.b  #$A,anim(a0)
                cmpi.b  #$AC,anim_frame(a0)
                blo.s   SKSonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
                move.b  #$B,anim(a0)
                bra.s   SKSonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel
; ---------------------------------------------------------------------------

SKSonicCompetition_RunCompetitionGroundStepUnlessSpindashOrJumpAbortsCaller:
                bsr.w   SonicSKHandleCompetitionSpindashAndAbortGroundStep
                bsr.w   Sonic_Jump
                bsr.w   Player_SlopeResist
                bsr.w   Sonic_Move
                bsr.w   SonicSKTryCompetitionRollFromDown
                jsr     (MoveSprite2).l

SKSonicCompetition_AttachCompetitionGroundActorAndApplySlopeRepel:
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel

SKSonicCompetition_ReturnAfterGroundAttachmentOrIdleAnimationBypass:
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_UpdateCompetitionNonrollingAirWithOrdinaryIntegrator:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicCompetition_ResolveCompetitionAirTerrainWhilePreservingActorBaseRegisters
                subi.w  #$28,y_vel(a0)

SKSonicCompetition_ResolveCompetitionAirTerrainWhilePreservingActorBaseRegisters:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_GateCompetitionRollingJumpBySpindashFlag:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicCompetition_AdvanceCompetitionGroundRollAndAttachWithoutLevelBounds
                bsr.w   Sonic_Jump

SKSonicCompetition_AdvanceCompetitionGroundRollAndAttachWithoutLevelBounds:
                bsr.w   Player_RollRepel
                bsr.w   Sonic_RollSpeed
                jsr     (MoveSprite2).l
                bsr.w   Player_AnglePos
                bsr.w   Player_SlopeRepel
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_UpdateCompetitionRollingAirWithOrdinaryIntegrator:
                bsr.w   Sonic_JumpHeight
                bsr.w   Sonic_ChgJumpDir
                jsr     (MoveSprite).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicCompetition_ResolveCompetitionRollingAirTerrainWhilePreservingActorBases
                subi.w  #$28,y_vel(a0)

SKSonicCompetition_ResolveCompetitionRollingAirTerrainWhilePreservingActorBases:
                bsr.w   Player_JumpAngle
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                rts

; =============== S U B R O U T I N E =======================================

SonicSKTryCompetitionRollFromDown:
                tst.b   status_secondary(a0)
                bmi.s   SKSonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                move.w  ground_vel(a0),d0
                bpl.s   SKSonicCompetition_RequireCompetitionRollSpeedAndDownWithoutHorizontalInput
                neg.w   d0

SKSonicCompetition_RequireCompetitionRollSpeedAndDownWithoutHorizontalInput:
                cmpi.w  #$80,d0
                blo.s   SKSonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKSonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails
                btst    #button_down,(Ctrl_1_held_logical).w
                bne.s   SKSonicCompetition_AvoidRepeatingCompetitionRollGeometryWhenAlreadyRolling

SKSonicCompetition_ReturnWhenCompetitionDownRollEligibilityFails:
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_AvoidRepeatingCompetitionRollGeometryWhenAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   SKSonicCompetition_EnterCompactRollAndApplyLiteralPositiveFourPixelYOffset
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_EnterCompactRollAndApplyLiteralPositiveFourPixelYOffset:
                bset    #Status_Roll,status(a0)
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   SKSonicCompetition_ReturnAfterCompetitionRollEntryAndOptionalFallbackSpeed
                move.w  #$200,ground_vel(a0)

SKSonicCompetition_ReturnAfterCompetitionRollEntryAndOptionalFallbackSpeed:
                rts
; End of function SonicSKTryCompetitionRollFromDown

; =============== S U B R O U T I N E =======================================

SonicSKHandleCompetitionSpindashAndAbortGroundStep:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicCompetition_MaintainChargedSpindashOrReleaseUsingChargeIntegerByte
                cmpi.b  #8,anim(a0)
                bne.s   SKSonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicCompetition_AttachAtSpindashStartAfterDiscardingGroundHelperReturn
                move.b  #2,anim(a6)

SKSonicCompetition_AttachAtSpindashStartAfterDiscardingGroundHelperReturn:
                bsr.w   Player_AnglePos

SKSonicCompetition_ReturnFromSpindashGateOrFinishAbortedStart:
                rts
; ---------------------------------------------------------------------------

SKSonicCompetition_MaintainChargedSpindashOrReleaseUsingChargeIntegerByte:
                move.b  (Ctrl_1_logical).w,d0
                btst    #button_down,d0
                bne.w   SKSonicCompetition_DecayCompetitionChargeWordWhileDownRemainsHeld
                move.b  #7,y_radius(a0)
                move.b  #3,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #4,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  SKSonicCompetition_NormalCompetitionSpindashLaunchSpeedWords(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   SKSonicCompetition_StorePlayerCameraHistoryLagAndSignLaunchByFacing
                lea     (H_scroll_frame_offset_P2).w,a1

SKSonicCompetition_StorePlayerCameraHistoryLagAndSignLaunchByFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicCompetition_CommitReleasedRollStopChargeDustAndPlayDashSound
                neg.w   ground_vel(a0)

SKSonicCompetition_CommitReleasedRollStopChargeDustAndPlayDashSound:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   SKSonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
; ---------------------------------------------------------------------------
SKSonicCompetition_NormalCompetitionSpindashLaunchSpeedWords:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
SKSonicCompetition_RetainedPoweredCompetitionSpindashLaunchSpeedWords:
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

SKSonicCompetition_DecayCompetitionChargeWordWhileDownRemainsHeld:
                tst.w   spin_dash_counter(a0)
                beq.s   SKSonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   SKSonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation
                move.w  #0,spin_dash_counter(a0)

SKSonicCompetition_AddCompetitionSpindashChargeOnNewJumpButtonAndRestartAnimation:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   SKSonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment
                move.w  #$800,spin_dash_counter(a0)

SKSonicCompetition_DiscardGroundStepReturnAndRecoverCameraDistanceBeforeAttachment:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   SKSonicCompetition_AttachChargedOrReleasedSpindashAndExitAbortedGroundMode
                bcc.s   SKSonicCompetition_SubtractCompetitionSpindashCameraRecoveryStep
                addq.w  #4,(a5)

SKSonicCompetition_SubtractCompetitionSpindashCameraRecoveryStep:
                subq.w  #2,(a5)

SKSonicCompetition_AttachChargedOrReleasedSpindashAndExitAbortedGroundMode:
                bsr.w   Player_AnglePos
                rts
; End of function SonicSKHandleCompetitionSpindashAndAbortGroundStep

; ---------------------------------------------------------------------------

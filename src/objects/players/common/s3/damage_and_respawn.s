; Owner: objects/players/common/s3
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

S3PlayerRecovery_HurtStateFourWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   S3PlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3PlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   S3PlayerRecovery_WrapHurtYWordAtMinusOneHundredCameraMinimum
                subi.w  #$20,y_vel(a0)

S3PlayerRecovery_WrapHurtYWordAtMinusOneHundredCameraMinimum:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3PlayerRecovery_ResolveHurtLandingThenRunBoundsHistoryAnimationAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3PlayerRecovery_ResolveHurtLandingThenRunBoundsHistoryAnimationAndDraw:
                bsr.w   PlayerS3ResolveCommonHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3ResolveCommonHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   S3PlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   S3PlayerRecovery_TailCallCharacterKillFromHurtDeathPlane

S3PlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded:
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   S3PlayerRecovery_ReturnAfterHurtCollisionOrGroundedRecoveryReset
                moveq   #0,d0
                move.w  d0,y_vel(a0)
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #$100,priority(a0)
                move.b  #2,routine(a0)
                move.b  #2*60,invulnerability_timer(a0)
                move.b  #0,spin_dash_flag(a0)

S3PlayerRecovery_ReturnAfterHurtCollisionOrGroundedRecoveryReset:
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_TailCallCharacterKillFromHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function PlayerS3ResolveCommonHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

S3PlayerRecovery_DeathStateSixWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   S3PlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3PlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw:
                bsr.w   PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn:
                cmpa.w  #Player_1,a0
                bne.s   S3PlayerRecovery_LockNonprimaryScrollUsingPrimaryCameraYForDeathThreshold
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   S3PlayerRecovery_PrepareDeathExitDepthWithProfileGravityPolicy
; ---------------------------------------------------------------------------

S3PlayerRecovery_LockNonprimaryScrollUsingPrimaryCameraYForDeathThreshold:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

S3PlayerRecovery_PrepareDeathExitDepthWithProfileGravityPolicy:
                move.b  #0,spin_dash_flag(a0)
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   S3PlayerRecovery_CompareNormalDeathDepthBeforeFollowerOrLifeResolution
                subi.w  #$70,d0

S3PlayerRecovery_CompareNormalDeathDepthBeforeFollowerOrLifeResolution:
                cmp.w   y_pos(a0),d0
                bge.w   S3PlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation
                tst.w   (Competition_mode).w
                bne.w   S3PlayerRecovery_RestorePrimaryCompetitionSpawnOrSelectSecondarySlot
                cmpi.b  #1,character_id(a0)
                bne.s   S3PlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver
                cmpi.w  #2,(Player_mode).w
                beq.s   S3PlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver
                move.b  #2,routine(a0)
                bra.w   TailsS3ResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

S3PlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   S3PlayerRecovery_SelectTimeOverOverlayWhenLivesRemainAfterCharge
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

S3PlayerRecovery_StopBothHudTimersAndStartGameOverMusicAndArt:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

S3PlayerRecovery_SelectTimeOverOverlayWhenLivesRemainAfterCharge:
                tst.b   (Time_over_flag).w
                beq.s   S3PlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   S3PlayerRecovery_StopBothHudTimersAndStartGameOverMusicAndArt
; ---------------------------------------------------------------------------

S3PlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation:
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_RestorePrimaryCompetitionSpawnOrSelectSecondarySlot:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   S3PlayerRecovery_RestoreSecondaryCompetitionSpawnAndRingLapState
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   S3PlayerRecovery_ResetCompetitionMovementAndReloadCharacterSpeedTriplet
; ---------------------------------------------------------------------------

S3PlayerRecovery_RestoreSecondaryCompetitionSpawnAndRingLapState:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

S3PlayerRecovery_ResetCompetitionMovementAndReloadCharacterSpeedTriplet:
                move.b  #0,object_control(a0)
                move.b  #5,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #2,status(a0)
                move.w  #0,move_lock(a0)
                move.w  #0,spin_dash_counter(a0)
                clr.b   speed_shoes_timer(a0)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed-Max_speed(a4)
                move.w  (a1)+,Acceleration-Max_speed(a4)
                move.w  (a1)+,Deceleration-Max_speed(a4)
                rts
; End of function PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn

; ---------------------------------------------------------------------------

S3PlayerRecovery_RestartStateEightCountsNonzeroWordTimerToExactZero:
                tst.w   $3E(a0)
                beq.s   S3PlayerRecovery_ReturnFromRestartTimerHoldOrCompletion
                subq.w  #1,$3E(a0)
                bne.s   S3PlayerRecovery_ReturnFromRestartTimerHoldOrCompletion
                move.w  #1,(Restart_level_flag).w

S3PlayerRecovery_ReturnFromRestartTimerHoldOrCompletion:
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_ScrollWaitStateAResumesControlWhenBothGlobalDeltasZero:
                tst.w   (H_scroll_amount).w
                bne.s   S3PlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume
                tst.w   (V_scroll_amount).w
                bne.s   S3PlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume
                move.b  #2,routine(a0)

S3PlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume:
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlayerRecovery_DrowningStateCWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   S3PlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3PlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3PlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns:
                tst.w   (Competition_mode).w
                bne.s   S3PlayerRecovery_AnimateCompetitionRecoveryAndTailLoadSharedPatterns
                bsr.s   Animate_Sonic
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

S3PlayerRecovery_AnimateCompetitionRecoveryAndTailLoadSharedPatterns:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns

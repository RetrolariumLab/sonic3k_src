; Owner: objects/players/common/sk
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SKPlayerRecovery_HurtStateFourWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   SKPlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKPlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_IntegrateHurtVelocityThenAddWaterAdjustedGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKPlayerRecovery_WrapHurtYWordAtMinusOneHundredCameraMinimum
                subi.w  #$20,y_vel(a0)

SKPlayerRecovery_WrapHurtYWordAtMinusOneHundredCameraMinimum:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKPlayerRecovery_ResolveHurtLandingThenRunBoundsHistoryAnimationAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKPlayerRecovery_ResolveHurtLandingThenRunBoundsHistoryAnimationAndDraw:
                bsr.w   PlayerSKResolveCommonHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerSKResolveCommonHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   SKPlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKPlayerRecovery_CheckUpperHurtDeathPlaneWithInclusiveReverseGravityBoundary
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKPlayerRecovery_TailCallCharacterKillFromHurtDeathPlane
                bra.s   SKPlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded
; ---------------------------------------------------------------------------

SKPlayerRecovery_CheckUpperHurtDeathPlaneWithInclusiveReverseGravityBoundary:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKPlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded
                bra.w   SKPlayerRecovery_TailCallCharacterKillFromHurtDeathPlane
; ---------------------------------------------------------------------------

SKPlayerRecovery_RunTerrainCollisionAndResetHurtStateWhenGrounded:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKPlayerRecovery_ReturnAfterHurtCollisionOrGroundedRecoveryReset
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

SKPlayerRecovery_ReturnAfterHurtCollisionOrGroundedRecoveryReset:
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_TailCallCharacterKillFromHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function PlayerSKResolveCommonHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

SKPlayerRecovery_DeathStateSixWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   SKPlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKPlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_ResolveDeathOutcomeThenIntegrateOldVelocityAndDraw:
                bsr.w   PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn:
                cmpa.w  #Player_1,a0
                bne.s   SKPlayerRecovery_LockNonprimaryScrollUsingPrimaryCameraYForDeathThreshold
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   SKPlayerRecovery_PrepareDeathExitDepthWithProfileGravityPolicy
; ---------------------------------------------------------------------------

SKPlayerRecovery_LockNonprimaryScrollUsingPrimaryCameraYForDeathThreshold:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

SKPlayerRecovery_PrepareDeathExitDepthWithProfileGravityPolicy:
                move.b  #0,spin_dash_flag(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKPlayerRecovery_PrepareNormalGravityDeathExitThreshold
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bge.w   SKPlayerRecovery_ResolveAdmittedDeathAsCompetitionFollowerResetOrLifeCharge
                bra.w   SKPlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation
; ---------------------------------------------------------------------------

SKPlayerRecovery_PrepareNormalGravityDeathExitThreshold:
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   SKPlayerRecovery_CompareNormalDeathDepthBeforeFollowerOrLifeResolution
                subi.w  #$70,d0

SKPlayerRecovery_CompareNormalDeathDepthBeforeFollowerOrLifeResolution:
                cmp.w   y_pos(a0),d0
                bge.w   SKPlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation

SKPlayerRecovery_ResolveAdmittedDeathAsCompetitionFollowerResetOrLifeCharge:
                tst.w   (Competition_mode).w
                bne.w   SKPlayerRecovery_RestorePrimaryCompetitionSpawnOrSelectSecondarySlot
                cmpi.b  #1,character_id(a0)
                bne.s   SKPlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver
                cmpi.w  #2,(Player_mode).w
                beq.s   SKPlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver
                move.b  #2,routine(a0)
                bra.w   TailsSKResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

SKPlayerRecovery_ChargeLifeAndPrepareSixtyTickRestartOrGameOver:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   SKPlayerRecovery_SelectTimeOverOverlayWhenLivesRemainAfterCharge
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

SKPlayerRecovery_StopBothHudTimersAndStartGameOverMusicAndArt:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

SKPlayerRecovery_SelectTimeOverOverlayWhenLivesRemainAfterCharge:
                tst.b   (Time_over_flag).w
                beq.s   SKPlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   SKPlayerRecovery_StopBothHudTimersAndStartGameOverMusicAndArt
; ---------------------------------------------------------------------------

SKPlayerRecovery_ReturnFromDeathFinishWhileWaitingOrAfterRestartPreparation:
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_RestorePrimaryCompetitionSpawnOrSelectSecondarySlot:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   SKPlayerRecovery_RestoreSecondaryCompetitionSpawnAndRingLapState
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   SKPlayerRecovery_ResetCompetitionMovementAndReloadCharacterSpeedTriplet
; ---------------------------------------------------------------------------

SKPlayerRecovery_RestoreSecondaryCompetitionSpawnAndRingLapState:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

SKPlayerRecovery_ResetCompetitionMovementAndReloadCharacterSpeedTriplet:
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
; End of function PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn

; ---------------------------------------------------------------------------

SKPlayerRecovery_RestartStateEightCountsNonzeroWordTimerToExactZero:
                tst.w   $3E(a0)
                beq.s   SKPlayerRecovery_ReturnFromRestartTimerHoldOrCompletion
                subq.w  #1,$3E(a0)
                bne.s   SKPlayerRecovery_ReturnFromRestartTimerHoldOrCompletion
                move.w  #1,(Restart_level_flag).w

SKPlayerRecovery_ReturnFromRestartTimerHoldOrCompletion:
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_ScrollWaitStateAResumesControlWhenBothGlobalDeltasZero:
                tst.w   (H_scroll_amount).w
                bne.s   SKPlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume
                tst.w   (V_scroll_amount).w
                bne.s   SKPlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume
                move.b  #2,routine(a0)

SKPlayerRecovery_AnimateAndQueueScrollWaitFrameAfterOptionalControlResume:
                bsr.w   PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKPlayerRecovery_DrowningStateCWithDebugPlacementEscape:
                tst.w   (Debug_mode_flag).w
                beq.s   SKPlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKPlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKPlayerRecovery_IntegrateDrowningVelocityThenAddOneSixteenthGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns:
                tst.w   (Competition_mode).w
                bne.s   SKPlayerRecovery_AnimateCompetitionRecoveryAndTailLoadSharedPatterns
                bsr.s   Animate_Sonic
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKPlayerRecovery_TailLoadSonicPatternsAfterRecoveryGravityFlip
                eori.b  #2,render_flags(a0)

SKPlayerRecovery_TailLoadSonicPatternsAfterRecoveryGravityFlip:
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

SKPlayerRecovery_AnimateCompetitionRecoveryAndTailLoadSharedPatterns:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function PlayerSKAnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns

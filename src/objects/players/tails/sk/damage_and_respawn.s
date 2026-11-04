; Owner: objects/players/tails/sk
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SKTailsRecovery_EnterSoloDebugFromHurtWithPhysicalBPress:
                cmpi.w  #2,(Player_mode).w
                bne.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement
                tst.w   (Debug_mode_flag).w
                beq.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_IntegrateOldHurtVelocityThenAddStoredGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_IntegrateOldHurtVelocityThenAddStoredGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsRecovery_MaskHurtIntegerYOnlyInWrappingCameraMode
                subi.w  #$20,y_vel(a0)

SKTailsRecovery_MaskHurtIntegerYOnlyInWrappingCameraMode:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKTailsRecovery_ResolveHurtThenBoundsRecordAnimateAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKTailsRecovery_ResolveHurtThenBoundsRecordAnimateAndDraw:
                bsr.w   TailsSKResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsSKResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   SKTailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsRecovery_CheckReverseGravityHurtDeathPlaneAtCameraMinimum
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKTailsRecovery_TailKillCharacterAfterHurtDeathPlaneCrossing
                bra.s   SKTailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding
; ---------------------------------------------------------------------------

SKTailsRecovery_CheckReverseGravityHurtDeathPlaneAtCameraMinimum:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKTailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding
                bra.w   SKTailsRecovery_TailKillCharacterAfterHurtDeathPlaneCrossing
; ---------------------------------------------------------------------------

SKTailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsRecovery_ReturnAfterHurtAirOrLandingDecision
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

SKTailsRecovery_ReturnAfterHurtAirOrLandingDecision:
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_TailKillCharacterAfterHurtDeathPlaneCrossing:
                jmp     (Kill_Character).l
; End of function TailsSKResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

SKTailsRecovery_EnterSoloDebugFromDeathWithPhysicalBPress:
                cmpi.w  #2,(Player_mode).w
                bne.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement
                tst.w   (Debug_mode_flag).w
                beq.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKTailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_FinishDeathBeforeGravityMovementAndRecoveryDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_FinishDeathBeforeGravityMovementAndRecoveryDraw:
                bsr.w   PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTailsRecovery_CountNonzeroRestartWordDownToRestartRequest:
                tst.w   $3E(a0)
                beq.s   SKTailsRecovery_ReturnAfterRestartCountdownWithoutDrawing
                subq.w  #1,$3E(a0)
                bne.s   SKTailsRecovery_ReturnAfterRestartCountdownWithoutDrawing
                move.w  #1,(Restart_level_flag).w

SKTailsRecovery_ReturnAfterRestartCountdownWithoutDrawing:
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_WaitForBothSecondaryScrollAmountsBeforeNormalRoutine:
                tst.w   (H_scroll_amount_P2).w
                bne.s   SKTailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll
                tst.w   (V_scroll_amount_P2).w
                bne.s   SKTailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll
                move.b  #2,routine(a0)

SKTailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll:
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseCarriedPrimaryBeforeDrowningMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_IntegrateOldDrowningVelocityThenAddSmallGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_IntegrateOldDrowningVelocityThenAddSmallGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsSKAnimateRecoveryStateAndDispatchPatternLoader:
                tst.w   (Competition_mode).w
                bne.s   SKTailsRecovery_AnimateCompetitionRecoveryAndTailTwoPlayerPatternLoader
                bsr.s   Animate_Tails
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsRecovery_TailNormalRecoveryPatternLoaderAfterGravityRenderFlip
                eori.b  #2,render_flags(a0)

SKTailsRecovery_TailNormalRecoveryPatternLoaderAfterGravityRenderFlip:
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

SKTailsRecovery_AnimateCompetitionRecoveryAndTailTwoPlayerPatternLoader:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function TailsSKAnimateRecoveryStateAndDispatchPatternLoader

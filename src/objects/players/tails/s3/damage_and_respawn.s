; Owner: objects/players/tails/s3
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_IntegrateOldHurtVelocityThenAddStoredGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_IntegrateOldHurtVelocityThenAddStoredGravity:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsRecovery_MaskHurtIntegerYOnlyInWrappingCameraMode
                subi.w  #$20,y_vel(a0)

S3TailsRecovery_MaskHurtIntegerYOnlyInWrappingCameraMode:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3TailsRecovery_ResolveHurtThenBoundsRecordAnimateAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3TailsRecovery_ResolveHurtThenBoundsRecordAnimateAndDraw:
                bsr.w   TailsS3ResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3ResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   S3TailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   S3TailsRecovery_TailKillCharacterAfterHurtDeathPlaneCrossing

S3TailsRecovery_ResolveTerrainAndRestoreNormalRoutineAfterHurtLanding:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   S3TailsRecovery_ReturnAfterHurtAirOrLandingDecision
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

S3TailsRecovery_ReturnAfterHurtAirOrLandingDecision:
                rts
; ---------------------------------------------------------------------------

S3TailsRecovery_TailKillCharacterAfterHurtDeathPlaneCrossing:
                jmp     (Kill_Character).l
; End of function TailsS3ResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_FinishDeathBeforeGravityMovementAndRecoveryDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_FinishDeathBeforeGravityMovementAndRecoveryDraw:
                bsr.w   PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TailsRecovery_CountNonzeroRestartWordDownToRestartRequest:
                tst.w   $3E(a0)
                beq.s   S3TailsRecovery_ReturnAfterRestartCountdownWithoutDrawing
                subq.w  #1,$3E(a0)
                bne.s   S3TailsRecovery_ReturnAfterRestartCountdownWithoutDrawing
                move.w  #1,(Restart_level_flag).w

S3TailsRecovery_ReturnAfterRestartCountdownWithoutDrawing:
                rts
; ---------------------------------------------------------------------------

S3TailsRecovery_WaitForBothSecondaryScrollAmountsBeforeNormalRoutine:
                tst.w   (H_scroll_amount_P2).w
                bne.s   S3TailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll
                tst.w   (V_scroll_amount_P2).w
                bne.s   S3TailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll
                move.b  #2,routine(a0)

S3TailsRecovery_AnimateAndDrawWhileWaitingForSecondaryScroll:
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseCarriedPrimaryBeforeDrowningMovement:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_IntegrateOldDrowningVelocityThenAddSmallGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_IntegrateOldDrowningVelocityThenAddSmallGravity:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3AnimateRecoveryStateAndDispatchPatternLoader:
                tst.w   (Competition_mode).w
                bne.s   S3TailsRecovery_AnimateCompetitionRecoveryAndTailTwoPlayerPatternLoader
                bsr.s   Animate_Tails
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

S3TailsRecovery_AnimateCompetitionRecoveryAndTailTwoPlayerPatternLoader:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function TailsS3AnimateRecoveryStateAndDispatchPatternLoader

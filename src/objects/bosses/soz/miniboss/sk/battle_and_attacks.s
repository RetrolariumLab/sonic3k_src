; Owner: objects/bosses/soz/miniboss/sk
; Responsibility: Sandopolis miniboss battle controller, attack actors, collision and defeat progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZMiniboss:
                move.l  #Obj_Wait,(a0)
                move.w  #$439D,x_pos(a0)
                move.w  #$9F7,y_pos(a0)
                lea     (Pal_SOZMinibossFade).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SOZMini_CopyFadePaletteToLineTwo:
                move.l  (a1)+,(a2)+
                dbf     d6,SOZMini_CopyFadePaletteToLineTwo
                lea     (Pal_SOZMinibossMain).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SOZMini_CopyTargetPaletteAndLoadArt:
                move.l  (a1)+,(a2)+
                dbf     d6,SOZMini_CopyTargetPaletteAndLoadArt
                move.l  #SOZMinibossEntry_InstallRootDispatcher,$34(a0)
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     (ArtKosM_SOZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_SOZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SOZSand).l,a1
                move.w  #tiles_to_bytes(ArtTile_SOZSand),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

SOZMinibossEntry_InstallRootDispatcher:
                move.l  #SOZMini_BattleDispatchHitAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SOZMinibossRoot_StateOffsets(pc,d0.w),d1
                jsr     SOZMinibossRoot_StateOffsets(pc,d1.w)
                bsr.w   SOZMini_HandleKnockbackOrSink
                bsr.w   SOZMini_SetLayerFromWorldX
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SOZMinibossRoot_StateOffsets:
                dc.w    SOZMini_InitArenaAndTryFade-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_TickInitialSpawnWait-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_WaitForPlayerProximity-SOZMinibossRoot_StateOffsets
                dc.w    SOZMinibossRoot_WaitThroughPreparation-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_MoveAndTickVerticalWait-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_MoveAndAnimateFirstLaunch-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_StopXAtRightBoundary-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_AnimateAndApplyRecoveryPose-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_AnimateArming-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_TickAlignmentOrChooseSide-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_TickAlignmentAndAnimateTurn-SOZMinibossRoot_StateOffsets
                dc.w    SOZMini_MoveAndAnimateSecondLaunch-SOZMinibossRoot_StateOffsets
                dc.w    SOZMinibossRoot_UnusedRoutineSlotReturn-SOZMinibossRoot_StateOffsets
; ---------------------------------------------------------------------------

SOZMini_InitArenaAndTryFade:
                lea     ObjDat_SOZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  priority(a0),$3C(a0)
                move.b  #$3B,y_radius(a0)
                move.l  #SOZMini_SpawnWeakspotPair,$34(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w
                move.w  #$3F,$2E(a0)
                move.l  #SOZMini_SpawnWeakspotPair,$34(a0)
                jsr     (AllocateObject).l
                bne.s   SOZMini_IntroFadeSpawnReturn
                move.l  #Obj_FadeSelectedFromBlack,(a1)
                move.w  #3,$3A(a1)
                move.w  #$F,$3C(a1)
                move.w  #Normal_palette_line_2,$30(a1)
                move.w  #Target_palette_line_2,$32(a1)

SOZMini_IntroFadeSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_TickInitialSpawnWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SOZMini_SpawnWeakspotPair:
                move.b  #4,routine(a0)
                st      (Events_bg+$02).w
                lea     SOZMini_WeakspotPairChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SOZMini_WaitForPlayerProximity:
                jsr     (Find_SonicTails).l
                cmpi.w  #$60,d2
                blo.s   SOZMini_BeginPreparationAndFace
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginPreparationAndFace:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   SOZMini_SetPrepWaitAndTryOverlay
                bset    #0,render_flags(a0)

SOZMini_SetPrepWaitAndTryOverlay:
                move.w  #$3E,$2E(a0)
                move.l  #SOZMini_BeginRiseAndSpawnPoseParts,$34(a0)
                lea     SOZMini_RisingOverlayChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SOZMinibossRoot_WaitThroughPreparation:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SOZMini_BeginRiseAndSpawnPoseParts:
                move.b  #8,routine(a0)
                move.w  #-$100,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #SOZMini_BeginShortVerticalPause,$34(a0)
                lea     SOZMini_PosePartChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SOZMini_MoveAndTickVerticalWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SOZMini_BeginShortVerticalPause:
                clr.w   y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #SOZMini_SettleBeforeLaunch,$34(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_SettleBeforeLaunch:
                move.w  #$80,y_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #SOZMini_BeginFirstLaunchPose,$34(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginFirstLaunchPose:
                move.b  #$A,routine(a0)
                move.l  #SOZMini_BeginFirstLandingFlight,$34(a0)
                clr.w   y_vel(a0)

SOZMini_SharedReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_MoveAndAnimateFirstLaunch:
                jsr     (MoveSprite2).l
                lea     SOZMini_FirstLaunchPoseAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                tst.w   d2
                beq.s   SOZMini_FirstLaunchUpdateReturn
                bmi.s   SOZMini_FirstLaunchUpdateReturn
                move.b  mapping_frame(a0),$39(a0)
                cmpi.b  #7,mapping_frame(a0)
                bne.s   SOZMini_HideLaunchTokenFrame
                move.w  #-$700,y_vel(a0)

SOZMini_HideLaunchTokenFrame:
                move.b  #0,mapping_frame(a0)

SOZMini_FirstLaunchUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginFirstLandingFlight:
                move.b  #$C,routine(a0)
                move.l  #SOZMini_BeginFirstLandingRecovery,$34(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_StopXAtRightBoundary:
                tst.w   x_vel(a0)
                bmi.s   SOZMini_ApplyGravityAndProbeFloor
                cmpi.w  #$4438,x_pos(a0)
                blo.s   SOZMini_ApplyGravityAndProbeFloor
                clr.w   x_vel(a0)

SOZMini_ApplyGravityAndProbeFloor:
                moveq   #$60,d1
                jsr     (MoveSprite_CustomGravity).l
                tst.w   y_vel(a0)
                bmi.w   SOZMini_SharedReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SOZMini_BeginFirstLandingRecovery:
                move.b  #$E,routine(a0)
                move.b  #0,$3A(a0)
                move.l  #SOZMini_BeginArmingAnimation,$34(a0)

SOZMini_StartImpactPoseAndDust:
                move.l  #SOZMini_LandingRecoveryPoseAnim,$30(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                lea     SOZMini_LandingDustChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SOZMini_BeginRepeatLandingRecovery:
                move.b  #$E,routine(a0)
                move.l  #SOZMini_BeginSideAlignment,$34(a0)
                bra.s   SOZMini_StartImpactPoseAndDust
; ---------------------------------------------------------------------------

SOZMini_ResetAfterKnockbackLanding:
                move.b  #4,routine(a0)
                move.b  #$3B,y_radius(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #8,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                lea     SOZMini_KnockbackDustChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SOZMini_AnimateAndApplyRecoveryPose:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   SOZMini_RecoveryPoseReturn
                bmi.s   SOZMini_RecoveryPoseReturn
                move.b  mapping_frame(a0),$39(a0)
                move.b  $3A(a0),mapping_frame(a0)
                lea     SOZMini_PoseCursorDisplacements(pc),a1
                bsr.w   SOZMini_ApplyAnimStepOffset

SOZMini_RecoveryPoseReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginArmingAnimation:
                move.b  #$10,routine(a0)
                move.l  #SOZMinibossRoot_UniformArmingTokenStream,$30(a0)
                move.l  #SOZMini_ArmWeakspot,$34(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_AnimateArming:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SOZMini_ArmWeakspot:
                bset    #1,$38(a0)

SOZMini_BeginSideAlignment:
                move.b  #$12,routine(a0)
                move.b  #1,$3A(a0)
                move.w  #$60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_TickAlignmentOrChooseSide:
                subq.w  #1,$2E(a0)
                bmi.s   SOZMini_BeginSecondLaunchPose
                jsr     (Find_SonicTails).l
                btst    #0,render_flags(a0)
                beq.s   SOZMini_CheckFacingForAlignment
                subq.w  #2,d0

SOZMini_CheckFacingForAlignment:
                tst.w   d0
                bne.s   SOZMinibossRoot_SelectFlipTurnPoseTokens
                rts
; ---------------------------------------------------------------------------

SOZMinibossRoot_SelectFlipTurnPoseTokens:
                move.b  #$14,routine(a0)
                move.l  #SOZMinibossRoot_FlipTurnPoseTokenStream,$30(a0)
                move.l  #SOZMini_ResumeAlignmentAfterTurn,$34(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginSecondLaunchPose:
                move.b  #$16,routine(a0)
                move.l  #SOZMini_SecondLaunchPoseAnim,$30(a0)
                move.l  #SOZMini_BeginRepeatLandingFlight,$34(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_TickAlignmentAndAnimateTurn:
                subq.w  #1,$2E(a0)
                jsr     (Animate_RawMultiDelayFlipX).l
                tst.w   d2
                beq.s   SOZMinibossRoot_ReturnAfterTurnTokenGate
                bmi.s   SOZMinibossRoot_ReturnAfterTurnTokenGate
                move.b  mapping_frame(a0),d0
                move.b  d0,$39(a0)
                move.b  #1,mapping_frame(a0)
                cmpi.b  #9,d0
                bne.s   SOZMinibossRoot_ReturnAfterTurnTokenGate
                move.b  #$19,mapping_frame(a0)

SOZMinibossRoot_ReturnAfterTurnTokenGate:
                rts
; ---------------------------------------------------------------------------

SOZMini_ResumeAlignmentAfterTurn:
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_MoveAndAnimateSecondLaunch:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   SOZMini_SecondLaunchUpdateReturn
                bmi.s   SOZMini_SecondLaunchUpdateReturn
                move.b  mapping_frame(a0),$39(a0)
                cmpi.b  #7,mapping_frame(a0)
                bne.s   SOZMini_ApplySecondLaunchPoseOffset
                move.w  #-$700,y_vel(a0)

SOZMini_ApplySecondLaunchPoseOffset:
                move.b  $3A(a0),mapping_frame(a0)
                lea     SOZMini_PoseCursorDisplacements(pc),a1
                bsr.w   SOZMini_ApplyAnimStepOffset

SOZMini_SecondLaunchUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginRepeatLandingFlight:
                move.b  #$C,routine(a0)
                move.l  #SOZMini_BeginRepeatLandingRecovery,$34(a0)
                move.w  #$180,d0
                btst    #0,render_flags(a0)
                bne.s   SOZMini_StoreFacingFlightSpeed
                neg.w   d0

SOZMini_StoreFacingFlightSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SOZMinibossRoot_UnusedRoutineSlotReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_SinkAndDraw:
                subq.w  #1,$2E(a0)
                bmi.s   SOZMini_MarkDeadAndTryExitController
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZMini_MarkDeadAndTryExitController:
                bset    #5,$38(a0)
                bset    #7,status(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                bclr    #7,render_flags(a0)
                jsr     (AllocateObject).l
                bne.s   SOZMini_StartEndSign
                move.l  #SOZMini_WaitForSignActivation,(a1)

SOZMini_StartEndSign:
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

SOZMini_WaitForSignActivation:
                tst.b   (ActCompletionHandshake).w
                beq.w   SOZMini_SharedReturn
                move.l  #SOZMini_WaitSignThenLockControls,(a0)

SOZMini_WaitSignThenLockControls:
                tst.b   (ActCompletionHandshake).w
                bne.w   SOZMini_SharedReturn
                move.l  #SOZMini_WalkTowardAlignmentX,(a0)
                lea     SOZMini_ExitCameraBoundsChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   SOZMini_SavePlayerAlignmentSide
                move.l  #SKInput_LockP2IfActive,(a1)

SOZMini_SavePlayerAlignmentSide:
                cmpi.w  #$43A0,(Player_1+x_pos).w
                blo.s   SOZMini_WalkTowardAlignmentX
                bset    #3,$38(a0)

SOZMini_WalkTowardAlignmentX:
                lea     (Ctrl_1_logical).w,a1
                lea     (Player_1).w,a2
                move.w  #$43A0,d0
                tst.w   x_vel(a0)
                btst    #3,$38(a0)
                bne.s   SOZMini_CheckLeftWalkAndJump
                cmp.w   x_pos(a2),d0
                bls.s   SOZMini_StopPlayerAndSignalScene
                moveq   #0,d1
                btst    #Status_Push,status(a2)
                beq.s   SOZMini_SetRightAndJumpInput
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

SOZMini_SetRightAndJumpInput:
                ori.w   #(button_right_mask<<8)|button_right_mask,d1
                move.w  d1,(a1)
                rts
; ---------------------------------------------------------------------------

SOZMini_CheckLeftWalkAndJump:
                cmp.w   x_pos(a2),d0
                bhs.s   SOZMini_StopPlayerAndSignalScene
                moveq   #0,d1
                btst    #Status_Push,status(a2)
                beq.s   SOZMini_SetLeftAndJumpInput
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

SOZMini_SetLeftAndJumpInput:
                ori.w   #(button_left_mask<<8)|button_left_mask,d1
                move.w  d1,(a1)
                rts
; ---------------------------------------------------------------------------

SOZMini_StopPlayerAndSignalScene:
                move.w  d0,x_pos(a2)
                clr.w   (a1)
                bclr    #0,render_flags(a2)
                bclr    #Status_Facing,status(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)
                move.w  #$55,(Events_fg_5).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SOZMini_InitPosePartPriority:
                lea     SOZMinibossPosePart_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  priority(a0),$3C(a0)
                move.l  #SOZMini_PosePartFollowOrBreak,(a0)

SOZMini_PosePartFollowOrBreak:
                bsr.w   SOZMini_SetLayerFromWorldX
                movea.w parent3(a0),a1
                moveq   #8,d0
                btst    #6,status(a1)
                bne.s   SOZMini_BeginPosePartBreakaway
                bsr.w   SOZMiniPart_SyncFromRootPose
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

SOZMini_BeginPosePartBreakaway:
                jmp     (SKChild_StartFlickerAndDraw).l
; ---------------------------------------------------------------------------

SOZMini_CollisionPartFollowDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SOZMinibossCollisionChild_StateOffsets(pc,d0.w),d1
                jsr     SOZMinibossCollisionChild_StateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SOZMinibossCollisionChild_StateOffsets:
                dc.w    SOZMini_InitCollisionPartBySubtype-SOZMinibossCollisionChild_StateOffsets
                dc.w    SOZMini_StaticCompanionIdle-SOZMinibossCollisionChild_StateOffsets
                dc.w    SOZMini_WeakspotWaitUntilArmed-SOZMinibossCollisionChild_StateOffsets
                dc.w    SOZMini_WeakspotCheckAttackOrHurt-SOZMinibossCollisionChild_StateOffsets
                dc.w    SOZMini_WeakspotAnimateHit-SOZMinibossCollisionChild_StateOffsets
; ---------------------------------------------------------------------------

SOZMini_InitCollisionPartBySubtype:
                lea     SOZMini_WeakspotPairAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                tst.b   subtype(a0)
                bne.s   SOZMini_CollisionPartInitReturn
                clr.b   collision_flags(a0)
                move.b  #4,routine(a0)

SOZMini_CollisionPartInitReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_StaticCompanionIdle:
                rts
; ---------------------------------------------------------------------------

SOZMini_WeakspotWaitUntilArmed:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SOZMini_WeakspotArmingReturn
                move.b  #6,routine(a0)
                move.b  #$D7,collision_flags(a0)
                clr.b   collision_property(a0)

SOZMini_WeakspotArmingReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_WeakspotCheckAttackOrHurt:
                jsr     (Check_PlayerCollision).l
                beq.s   SOZMini_WeakspotContactReturn
                jsr     (Check_PlayerAttack).l
                bne.s   SOZMini_WeakspotReflectAndSignalHit
                tst.b   invulnerability_timer(a1)
                bne.s   SOZMini_WeakspotContactReturn
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

; Reflect all three player speeds and store the attacker for root knockback
SOZMini_WeakspotReflectAndSignalHit:
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)
                move.b  #8,routine(a0)
                move.l  #SOZMini_WeakspotHitAnim,$30(a0)
                move.l  #SOZMini_WeakspotResetAfterHit,$34(a0)
                movea.w parent3(a0),a2
                move.w  a1,$44(a2)
                bset    #6,status(a2)
                bset    #7,$38(a2)

SOZMini_WeakspotContactReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_WeakspotResetAfterHit:
                move.b  #$1A,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #6,status(a1)
                bclr    #1,$38(a1)
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_WeakspotAnimateHit:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SOZMini_InitRisingOverlay:
                lea     SOZMini_RisingOverlayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  priority(a0),$3C(a0)
                movea.w parent3(a0),a1
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   SOZMini_RisingOverlayBeginMotion
                bset    #0,render_flags(a0)

SOZMini_RisingOverlayBeginMotion:
                move.l  #SOZMini_RisingOverlayMoveAndDraw,(a0)
                move.w  #-$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

SOZMini_RisingOverlayMoveAndDraw:
                bsr.w   SOZMini_SetLayerFromWorldX
                jmp     (MoveDraw_SpriteTimed).l
; ---------------------------------------------------------------------------

SOZMini_InitDustAndFacingOffset:
                lea     SOZMinibossLandingDust_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SOZMini_DustTickBeforeDraw,(a0)
                movea.w parent3(a0),a1
                move.b  child_dx(a0),d0
                btst    #0,render_flags(a1)
                beq.s   SOZMini_DustLoadOffsetAndDelay
                neg.b   d0

SOZMini_DustLoadOffsetAndDelay:
                ext.w   d0
                move.w  x_pos(a1),d1
                add.w   d0,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     SOZMini_DustOffsetDelayPairs(pc,d0.w),a2
                move.b  (a2)+,d0
                bmi.s   SOZMini_DustStoreOffsetAndDelay
                bset    #0,render_flags(a0)

SOZMini_DustStoreOffsetAndDelay:
                ext.w   d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a2)+,$2E(a0)
                rts
; ---------------------------------------------------------------------------
SOZMini_DustOffsetDelayPairs:
                dc.b    -$18,  $B
                dc.b    $18,  $B
                dc.b    -$10,   5
                dc.b    $10,   5
                dc.b    -8, $FF
                dc.b    8, $FF
; ---------------------------------------------------------------------------

SOZMini_DustTickBeforeDraw:
                subq.b  #1,$2E(a0)
                bpl.s   SOZMini_DustDelayReturn
                move.l  #SOZMini_DustAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

SOZMini_DustDelayReturn:
                rts
; ---------------------------------------------------------------------------

SOZMini_DustAnimateAndDraw:
                lea     SOZMini_DustDeleteAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l

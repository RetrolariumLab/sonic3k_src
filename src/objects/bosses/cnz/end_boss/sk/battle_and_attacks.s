; Owner: objects/bosses/cnz/end_boss/sk
; Responsibility: Carnival Night end-boss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZEndBoss:
                lea     CNZEndBoss_ActivationCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #CNZEndBoss_WaitForArenaAndMusic,(a0)
                move.l  #CNZEndBoss_InstallBattleUpdate,$34(a0)
                lea     CNZEndBoss_ArenaTransitionBounds(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                moveq   #PLCID_6E,d0
                jsr     (Load_PLC).l
                lea     Pal_CNZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

CNZEndBoss_WaitForArenaAndMusic:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

CNZEndBoss_InstallBattleUpdate:
                move.l  #CNZBossSK_BattleDispatchAndInteract,(a0)

CNZEndBoss_Return:
                rts
; ---------------------------------------------------------------------------

CNZBossSK_BattleDispatchAndInteract:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CNZEndBoss_StateOffsets(pc,d0.w),d1
                jsr     CNZEndBoss_StateOffsets(pc,d1.w)
                bsr.w   PullBothPlayersWithCNZBossMagnet
                bsr.w   HandleCNZEndBossFourColorHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
CNZEndBoss_StateOffsets:
                dc.w    CNZEndBoss_InitializeBattleActors-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_HoverDuringInitialDelay-CNZEndBoss_StateOffsets
                dc.w    CNZBossSK_PursueNearestPlayerX-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_HoverUntilCoreSettles-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_AlignHorizontallyOverCore-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_WaitForMagnetPhaseCallback-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_DescendTowardCore-CNZEndBoss_StateOffsets
                dc.w    CNZEndBoss_AscendToSavedHoverHeight-CNZEndBoss_StateOffsets
; ---------------------------------------------------------------------------

CNZEndBoss_InitializeBattleActors:
                lea     ObjDat_CNZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$7F,$2E(a0)
                move.l  #CNZEndBoss_BeginTimedPlayerPursuit,$34(a0)
                move.w  #-$100,x_vel(a0)
                jsr     Swing_Setup1(pc)
                lea     (Child1_MakeRoboShip4).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   CNZEndBoss_CreateCoreAndMagnetChildren
                move.b  #9,subtype(a1)

CNZEndBoss_CreateCoreAndMagnetChildren:
                lea     CNZEndBoss_CoreChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     CNZEndBoss_RepeatedMagnetChildRecord(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

CNZEndBoss_HoverDuringInitialDelay:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CNZEndBoss_ResetSwingAndBeginPursuit:
                jsr     Swing_Setup1(pc)

CNZEndBoss_BeginTimedPlayerPursuit:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.l  #CNZEndBoss_RequestCoreDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossSK_PursueNearestPlayerX:
                jsr     (Find_SonicTails).l
                addi.w  #$10,d2
                cmpi.w  #$20,d2
                blo.s   CNZEndBoss_BobMoveAndWaitForCoreDrop
                move.w  #$100,d1
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   CNZEndBoss_StorePursuitXVelocity
                neg.w   d1
                bclr    #0,render_flags(a0)

CNZEndBoss_StorePursuitXVelocity:
                move.w  d1,x_vel(a0)

CNZEndBoss_BobMoveAndWaitForCoreDrop:
                jmp     (Swing_MoveWaitNoFall).l
; ---------------------------------------------------------------------------

CNZEndBoss_RequestCoreDrop:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_HoverUntilCoreSettles:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #1,$38(a0)
                beq.s   CNZEndBoss_BeginCoreHorizontalAlignment
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_BeginCoreHorizontalAlignment:
                move.b  #8,routine(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_AlignHorizontallyOverCore:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                movea.w $44(a0),a1
                cmp.w   x_pos(a1),d0
                beq.s   CNZEndBoss_BeginMagnetActivationDelay
                bhi.s   CNZEndBoss_StepLeftTowardCore
                addq.w  #1,d0
                move.w  d0,x_pos(a0)
                bset    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_StepLeftTowardCore:
                subq.w  #1,d0
                bclr    #0,render_flags(a0)
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_BeginMagnetActivationDelay:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$BF,$2E(a0)
                move.l  #CNZBossSK_EnableMagnetAndSpawnSparks,$34(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_WaitForMagnetPhaseCallback:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CNZBossSK_EnableMagnetAndSpawnSparks:
                bset    #2,$38(a0)
                move.w  #$FF,$2E(a0)
                move.l  #CNZBossSK_StopMagnetAndBeginRelease,$34(a0)
                lea     CNZEndBoss_ElectricPairChildRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

CNZBossSK_StopMagnetAndBeginRelease:
                bclr    #2,$38(a0)
                bset    #7,$38(a0)
                move.w  #$FF,$2E(a0)
                move.l  #CNZEndBoss_BeginCoreRetrievalDescent,$34(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_BeginCoreRetrievalDescent:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_DescendTowardCore:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                movea.w $44(a0),a1
                move.w  y_pos(a1),d1
                subi.w  #$14,d1
                cmp.w   d1,d0
                bhs.s   CNZEndBoss_BeginAscentWithCore
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_BeginAscentWithCore:
                move.b  #$E,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_AscendToSavedHoverHeight:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3A(a0),d0
                bls.s   CNZBossSK_ClampHoverAndResumePursuit
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossSK_ClampHoverAndResumePursuit:
                move.w  $3A(a0),y_pos(a0)
                bra.w   CNZEndBoss_ResetSwingAndBeginPursuit
; ---------------------------------------------------------------------------

CNZEndBoss_BeginDefeatBreakup:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #CNZEndBoss_OpenArenaExitAfterDefeat,$34(a0)
                lea     CNZEndBoss_ShellFragmentChildRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

CNZEndBoss_OpenArenaExitAfterDefeat:
                move.l  #CNZBossSK_RestoreControlsForExit,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                move.w  (_unkFAB4).w,d0
                addi.w  #$190,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   CNZBossSK_SpawnArenaExitCamera
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4990,x_pos(a1)
                move.w  #$2E0,y_pos(a1)

CNZBossSK_SpawnArenaExitCamera:
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

CNZBossSK_RestoreControlsForExit:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   CNZEndBoss_Return
                move.l  #CNZBossSK_SpawnCannonAtExitGate,(a0)
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                move.w  #$200,(Camera_stored_min_Y_pos).w
                lea     (Child6_DecLevY).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  (_unkFAB4).w,d0
                addi.w  #$310,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

CNZBossSK_SpawnCannonAtExitGate:
                cmpi.w  #$4A30,(Player_1+x_pos).w
                blo.s   CNZEndBoss_ReturnFromExitCannonAttempt
                move.l  #CNZEndBoss_WaitForExitCannonOccupancy,(a0)
                lea     (ArtKosM_BadnikExplosion).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jsr     (Queue_Kos_Module).l
                jsr     (AllocateObject).l
                bne.s   CNZEndBoss_ReturnFromExitCannonAttempt
                move.w  a1,$44(a0)
                move.l  #Obj_CNZCannon,(a1)
                move.w  #$4B20,x_pos(a1)
                move.w  #$2A8,y_pos(a1)

CNZEndBoss_ReturnFromExitCannonAttempt:
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_WaitForExitCannonOccupancy:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                movea.w $44(a0),a1
                cmpi.b  #1,$30(a1)
                bne.w   CNZEndBoss_Return
                move.l  #CNZBossSK_TriggerTimedCannonJump,(a0)
                move.w  #$200,d0
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$BF,$2E(a0)
                st      (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

CNZBossSK_TriggerTimedCannonJump:
                subq.w  #1,$2E(a0)
                bpl.w   CNZEndBoss_Return
                movea.w $44(a0),a1
                cmpi.b  #$12,angle(a1)
                bne.w   CNZEndBoss_Return
                move.l  #CNZBossSK_StartIceCapAtScreenTop,(a0)
                move.w  #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

CNZBossSK_StartIceCapAtScreenTop:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.w   CNZEndBoss_Return
                move.w  #$500,d0
                jsr     (StartNewLevel).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

CNZBossCore_DispatchStateAndHandleDefeat:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CNZBossCore_StateOffsets(pc,d0.w),d1
                jsr     CNZBossCore_StateOffsets(pc,d1.w)
                bsr.w   BreakCNZBossDroppedCoreWhenParentDefeats
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
CNZBossCore_StateOffsets:
                dc.w    CNZBossCore_Initialize-CNZBossCore_StateOffsets
                dc.w    CNZBossCore_FollowParentUntilDropRequest-CNZBossCore_StateOffsets
                dc.w    CNZBossCore_FallAndCheckFloor-CNZBossCore_StateOffsets
                dc.w    CNZBossCore_WaitForMagnetActivation-CNZBossCore_StateOffsets
                dc.w    CNZBossCore_AnimateWhileParentActive-CNZBossCore_StateOffsets
                dc.w    CNZBossCore_ConsumeReattachmentSignal-CNZBossCore_StateOffsets
; ---------------------------------------------------------------------------

CNZBossCore_Initialize:
                lea     CNZBossCore_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$10,y_radius(a0)
                move.l  #CNZBossCore_RawFrameDelayScript,$30(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossCore_FollowParentUntilDropRequest:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   CNZBossCore_BeginDropTowardNearestPlayer
                rts
; ---------------------------------------------------------------------------

CNZBossCore_BeginDropTowardNearestPlayer:
                move.b  #4,routine(a0)
                move.l  #CNZBossCore_BounceOrReportSettled,$34(a0)
                jsr     (Find_SonicTails).l
                move.w  #$100,d1
                tst.w   d0
                bne.s   CNZBossCore_StoreDropXVelocity
                neg.w   d1

CNZBossCore_StoreDropXVelocity:
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossCore_FallAndCheckFloor:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   CNZEndBoss_Return
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

CNZBossCore_BounceOrReportSettled:
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                cmpi.w  #$80,d0
                blo.s   CNZBossCore_ReportSettledToParent
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossCore_ReportSettledToParent:
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

CNZBossCore_WaitForMagnetActivation:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   CNZBossCore_BeginActivationAnimation
                rts
; ---------------------------------------------------------------------------

CNZBossCore_BeginActivationAnimation:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossCore_AnimateWhileParentActive:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   CNZBossSK_EndActivationAndResetAnim
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

CNZBossSK_EndActivationAndResetAnim:
                move.b  #$A,routine(a0)
                move.b  #4,mapping_frame(a0)
                bra.w   CNZBossChildren_ResetRawAnimationCursor
; ---------------------------------------------------------------------------

CNZBossCore_ConsumeReattachmentSignal:
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                bne.s   CNZBossCore_ResumeParentAttachment
                rts
; ---------------------------------------------------------------------------

CNZBossCore_ResumeParentAttachment:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossCoreFragment_Initialize:
                lea     CNZBossCoreFragment_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                tst.b   subtype(a0)
                beq.s   CNZBossCoreFragment_SetIndexedVelocity
                bset    #0,render_flags(a0)

CNZBossCoreFragment_SetIndexedVelocity:
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

CNZBossSK_OrbitDispatchAndMove:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CNZBossMagnet_StateOffsets(pc,d0.w),d1
                jsr     CNZBossMagnet_StateOffsets(pc,d1.w)
                lea     (CNZEndBossMagnet_AngleX).l,a1
                jsr     (MoveSprite_AngleXLookupOffset).l
                bsr.w   SetCNZBossMagnetDepthFromPhase
                bsr.w   SelectCNZBossMagnetPhaseFrame
                bsr.w   DetachCNZBossMagnetAfterParentDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
CNZBossMagnet_StateOffsets:
                dc.w    CNZBossSK_InitOrbitPhaseAndAnim-CNZBossMagnet_StateOffsets
                dc.w    CNZBossMagnet_WaitForParentActivation-CNZBossMagnet_StateOffsets
                dc.w    CNZBossSK_AccelerateBeforeAttraction-CNZBossMagnet_StateOffsets
                dc.w    CNZBossMagnet_SustainAttractionSpin-CNZBossMagnet_StateOffsets
                dc.w    CNZBossMagnet_DecelerateWithTimer-CNZBossMagnet_StateOffsets
                dc.w    CNZBossMagnet_ReturnToSavedPhase-CNZBossMagnet_StateOffsets
                dc.w    CNZBossSK_AnimateUntilParentStops-CNZBossMagnet_StateOffsets
; ---------------------------------------------------------------------------

CNZBossSK_InitOrbitPhaseAndAnim:
                lea     CNZBossMagnet_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                move.l  #CNZBossMagnet_RawFrameDelayScript,$30(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_WaitForParentActivation:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   CNZBossMagnet_BeginAcceleration
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_BeginAcceleration:
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                move.l  #CNZBossMagnet_IncreasePhaseRate,$34(a0)
                move.b  $3C(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossSK_AccelerateBeforeAttraction:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   CNZBossSK_SpawnElectricChildAndHold
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CNZBossSK_SpawnElectricChildAndHold:
                move.b  #6,routine(a0)
                lea     CNZBossMagnet_ElectricChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  subtype(a0),subtype(a1)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_IncreasePhaseRate:
                addq.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_SustainAttractionSpin:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   CNZBossMagnet_BeginDeceleration
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

CNZBossMagnet_BeginDeceleration:
                move.b  #8,routine(a0)
                bset    #7,$38(a0)
                move.w  #$40,$2E(a0)
                move.l  #CNZBossMagnet_DecreasePhaseRateOrFinish,$34(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_DecelerateWithTimer:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CNZBossMagnet_DecreasePhaseRateOrFinish:
                cmpi.b  #1,$40(a0)
                beq.s   CNZBossMagnet_BeginSavedPhaseReturn
                subq.b  #1,$40(a0)
                move.w  #$40,$2E(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_BeginSavedPhaseReturn:
                move.b  #$A,routine(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_ReturnToSavedPhase:
                jsr     (Animate_RawMultiDelay).l
                move.b  $3C(a0),d0
                addq.b  #1,d0
                move.b  d0,$3C(a0)
                cmp.b   $3A(a0),d0
                beq.s   CNZBossMagnet_WaitAtSavedPhase
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_WaitAtSavedPhase:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossSK_AnimateUntilParentStops:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   CNZBossMagnet_ResetForNextActivation
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

CNZBossMagnet_ResetForNextActivation:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)

CNZBossChildren_ResetRawAnimationCursor:
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

CNZBossElectricEffect_Initialize:
                lea     CNZBossElectricEffect_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #5,shield_reaction(a0)
                move.l  #CNZBossSK_CallbackAnimation,$30(a0)
                move.l  #CNZBossSK_CycleFrameNineFlips,$34(a0)
                btst    #1,subtype(a0)
                beq.s   CNZBossSK_InstallActiveFollow
                move.l  #CNZBossSK_InstallActiveFollow,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

CNZBossSK_InstallActiveFollow:
                move.l  #CNZBossSK_ActiveFollowAnimateTouch,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

CNZBossSK_ActiveFollowAnimateTouch:
                moveq   #signextendB(sfx_GravityMachine),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                bsr.w   CNZBossSpark_TryDelete
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

CNZBossSK_CycleFrameNineFlips:
                move.b  #9,mapping_frame(a0)
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                lea     CNZBossElectricEffect_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #5,shield_reaction(a0)
                move.l  #CNZBossSK_CycleFrameNineFlips,$34(a0)
                move.b  subtype(a0),d0
                beq.s   CNZBossSK_SelectLegacyShortAnim
                move.l  #CNZBossSK_LegacyLongDelayAnim,$30(a0)
                move.l  #CNZBossSK_InstallLegacyFollow,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

CNZBossSK_SelectLegacyShortAnim:
                move.l  #CNZBossSK_LegacyShortDelayAnim,$30(a0)

CNZBossSK_InstallLegacyFollow:
                move.l  #CNZBossSK_LegacyFollowAndAnimate,(a0)
                bra.w   CNZBossSpark_TryDelete
; ---------------------------------------------------------------------------

CNZBossSK_LegacyFollowAndAnimate:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                bsr.w   CNZBossSpark_TryDelete
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

CNZBossShellFragment_InitializeAndDraw:
                lea     CNZBossShellFragment_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; End of function CNZBossSK_CycleFrameNineFlips

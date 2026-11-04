; Owner: objects/bosses/lbz/end_boss/sk
; Responsibility: Launch Base end-boss controller, attached attack actors and battle progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZEndBoss:
                lea     LBZBoss1SK_EarlierBossCameraTrigger(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZEndBoss_Index(pc,d0.w),d1
                jsr     LBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleLBZEndBossSingleColorHitOrEscape
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZEndBoss_Index:
                dc.w    LBZBossSK_InitBossAndArena-LBZEndBoss_Index
                dc.w    LBZBossSK_TickCameraTransition-LBZEndBoss_Index
                dc.w    LBZEndBossSK_Root_PollRunnerReadyFlag-LBZEndBoss_Index
                dc.w    LBZBossSK_CloseCameraToBattleX-LBZEndBoss_Index
                dc.w    LBZEndBossSK_Root_MoveSlowRiseThenWait-LBZEndBoss_Index
                dc.w    LBZBossSK_TickAttackPreparation-LBZEndBoss_Index
                dc.w    LBZBossSK_WaitForPlatformCycle-LBZEndBoss_Index
; ---------------------------------------------------------------------------

LBZBossSK_InitBossAndArena:
                lea     ObjDat_LBZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.l  #LBZBossSK_SpawnPlatformsAndRunner,$34(a0)
                lea     LBZBoss1SK_EarlierBossCameraTarget(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                lea     LBZBossSK_OperatorAndCoverChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                moveq   #PLCID_77,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_LBZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

LBZBossSK_TickCameraTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

LBZBossSK_SpawnPlatformsAndRunner:
                move.b  #4,routine(a0)
                lea     LBZBossSK_LinkedPlatformChildren(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                lea     LBZEndBossSK_Runner_NormalOneChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZEndBossSK_Root_PollRunnerReadyFlag:
                btst    #7,$38(a0)
                bne.s   LBZEndBossSK_Root_SelectCameraClosure
                rts
; ---------------------------------------------------------------------------

LBZEndBossSK_Root_SelectCameraClosure:
                move.b  #6,routine(a0)
                move.b  #1,(Scroll_lock).w
                move.w  #$39F0,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

LBZBossSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossSK_CloseCameraToBattleX:
                move.w  #$39F0,d0
                move.w  (Camera_X_pos).w,d1
                subq.w  #2,d1
                cmp.w   d0,d1
                bls.s   LBZBossSK_BeginRiseAndSpawnTrim
                move.w  d1,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

LBZBossSK_BeginRiseAndSpawnTrim:
                move.w  d0,(Camera_X_pos).w
                move.b  #8,routine(a0)
                clr.b   (Scroll_lock).w
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                move.w  #-$40,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #LBZBossSK_EnableCollisionAfterRise,$34(a0)
                lea     LBZEndBossSK_Trim_NormalThreeChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZEndBossSK_Root_MoveSlowRiseThenWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_EnableCollisionAfterRise:
                bset    #2,$38(a0)
                move.b  #$F,$28(a0)
                bset    #3,$38(a0)

LBZBossSK_BeginAttackPreparation:
                move.b  #$A,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #LBZBossSK_RequestPlatformsAndDelayShot,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_TickAttackPreparation:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_RequestPlatformsAndDelayShot:
                bset    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZBossSK_LaunchShotAndPollPlatforms,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LaunchShotAndPollPlatforms:
                move.b  #$C,routine(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                bra.w   LBZBossSK_SpawnShotAndSetPattern
; ---------------------------------------------------------------------------

LBZBossSK_WaitForPlatformCycle:
                btst    #1,$38(a0)
                beq.s   LBZBossSK_BeginAttackPreparation
                rts
; ---------------------------------------------------------------------------

LBZBossSK_EscapeMoveAndDraw:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_FinishEscapeAndRestoreMusic:
                bset    #5,$38(a0)
                bclr    #7,render_flags(a0)
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                move.l  #Go_Delete_Sprite_2,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_ShotDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossSK_ShotStateOffsets(pc,d0.w),d1
                jsr     LBZBossSK_ShotStateOffsets(pc,d1.w)
                jsr     (Animate_Raw).l
                btst    #7,status(a0)
                bne.s   LBZBossSK_ShotDrawIfParentAlive
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   LBZBossSK_ShotDrawIfParentAlive
                bsr.w   LBZBossSK_ShotBreakUpAndDelete

LBZBossSK_ShotDrawIfParentAlive:
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
LBZBossSK_ShotStateOffsets:
                dc.w    LBZBossSK_InitShotPatternMotion-LBZBossSK_ShotStateOffsets
                dc.w    LBZBossSK_ShotMoveAndTickLaunch-LBZBossSK_ShotStateOffsets
                dc.w    LBZBossSK_ShotFallAndProbeFloor-LBZBossSK_ShotStateOffsets
                dc.w    LBZBossSK_ShotCheckWallsAndSlope-LBZBossSK_ShotStateOffsets
; ---------------------------------------------------------------------------

LBZBossSK_InitShotPatternMotion:
                lea     LBZBossSK_ShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZBossSK_ShotLoopAnim,$30(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$F,$2E(a0)
                move.l  #LBZBossSK_ShotBeginFloorApproach,$34(a0)
                bra.w   LBZBossSK_ApplyShotOffsetAndVelocity
; ---------------------------------------------------------------------------

LBZBossSK_ShotMoveAndTickLaunch:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_ShotBeginFloorApproach:
                move.b  #4,routine(a0)
                move.l  #LBZBossSK_ShotBeginRolling,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_ShotFallAndProbeFloor:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

LBZBossSK_ShotBeginRolling:
                move.b  #6,routine(a0)
                move.l  #LBZBossSK_ShotBreakUpAndDelete,$34(a0)
                move.w  angle(a0),d0
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_ShotCheckWallsAndSlope:
                move.w  #$10,d3
                jsr     (ObjHitWall_DoRoutine).l
                jsr     (ObjHitFloor2_DoRoutine).l
                tst.b   d3
                beq.s   LBZBossSK_ShotMoveAndTryFloorEffects
                addi.w  #$10,x_vel(a0)

; Emit effects every fourth V-int tick when X speed lies outside the signed low-speed window
LBZBossSK_ShotMoveAndTryFloorEffects:
                jsr     (MoveSprite2).l
                move.w  x_vel(a0),d0
                addi.w  #$200,d0
                cmpi.w  #$400,d0
                blo.w   LBZBossSK_SharedReturn
                move.w  (V_int_run_count+2).w,d0
                andi.w  #3,d0
                bne.w   LBZBossSK_SharedReturn
                lea     LBZEndBossSK_SmallEffect_NormalOneChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBossSK_ShotBreakUpAndDelete:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     LBZBossSK_ShotBreakupChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBossSK_InitSmallEffectAndDelay:
                lea     LBZBossSK_SmallEffectAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #LBZBossSK_EffectTickMoveAndDraw,(a0)
                move.l  #LBZBossSK_SmallEffectDeleteAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bne.s   LBZBossSK_EffectStoreNegativeDelay
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_EffectStoreNegativeDelay:
                subi.w  #$10,d0
                add.w   d0,d0
                neg.w   d0
                move.w  d0,$2E(a0)

LBZBossSK_EffectTickMoveAndDraw:
                addq.w  #1,$2E(a0)
                bmi.w   LBZBossSK_SharedReturn
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_InitShotDebris:
                lea     LBZBossSK_ShotDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #Obj_FlickerMove,(a0)
                bra.w   LBZBossSK_DebrisSelectFrameAndMotion
; ---------------------------------------------------------------------------

LBZBossSK_TrimFollowDispatchAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossSK_TrimStateOffsets(pc,d0.w),d1
                jsr     LBZBossSK_TrimStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossSK_TrimStateOffsets:
                dc.w    LBZBossSK_InitTrimFrame-LBZBossSK_TrimStateOffsets
                dc.w    LBZBossSK_TrimWaitForBossRise-LBZBossSK_TrimStateOffsets
                dc.w    LBZBossSK_TrimCheckDefeat-LBZBossSK_TrimStateOffsets
; ---------------------------------------------------------------------------

LBZBossSK_InitTrimFrame:
                lea     LBZEndBossSK_Trim_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addq.w  #2,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_TrimWaitForBossRise:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   LBZBossSK_TrimApplyYJitter
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_TrimApplyYJitter:
                move.w  $2E(a0),d0
                addq.w  #1,$2E(a0)
                andi.w  #3,d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_TrimCheckDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBossSK_TrimSpawnDebris
                rts
; ---------------------------------------------------------------------------

LBZBossSK_TrimSpawnDebris:
                lea     LBZBossSK_TrimDebrisChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBossSK_InitTrimDebris:
                lea     LBZBossSK_TrimDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZBossSK_TrimDebrisXSpeeds(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossSK_TrimDebrisXSpeeds:
                dc.w    -$100
                dc.w    $200
                dc.w    -$200
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformDispatchAndDraw:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossSK_LeadPlatformStateOffsets(pc,d0.w),d1
                jsr     LBZBossSK_LeadPlatformStateOffsets(pc,d1.w)
                lea     LBZBossSK_SharedReturn(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   LBZBossSK_PlatformDrawOrBreakAway
; ---------------------------------------------------------------------------
LBZBossSK_LeadPlatformStateOffsets:
                dc.w    LBZBossSK_InitPlatformAndChooseLeader-LBZBossSK_LeadPlatformStateOffsets
                dc.w    LBZBossSK_LeadPlatformWaitRotation-LBZBossSK_LeadPlatformStateOffsets
                dc.w    LBZBossSK_LeadPlatformTurnOutbound-LBZBossSK_LeadPlatformStateOffsets
                dc.w    LBZBossSK_LeadPlatformTickHold-LBZBossSK_LeadPlatformStateOffsets
                dc.w    LBZBossSK_LeadPlatformTurnToZero-LBZBossSK_LeadPlatformStateOffsets
; ---------------------------------------------------------------------------

LBZBossSK_InitPlatformAndChooseLeader:
                lea     LBZEndBossSK_Platform_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                subi.w  #$14,x_pos(a0)
                addi.w  #$40,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   LBZBossSK_PlatformLeaderInitReturn
                move.l  #LBZBossSK_FollowerPlatformSolidAndDraw,(a0)

LBZBossSK_PlatformLeaderInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformWaitRotation:
                btst    #1,$38(a1)
                bne.s   LBZBossSK_LeadPlatformBeginOutbound
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformBeginOutbound:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformTurnOutbound:
                subq.b  #1,$3C(a0)
                cmpi.b  #-$40,$3C(a0)
                bls.s   LBZBossSK_LeadPlatformHoldQuarterTurn
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformHoldQuarterTurn:
                move.b  #6,routine(a0)
                move.w  #$80,$2E(a0)
                move.l  #LBZBossSK_LeadPlatformBeginReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformTickHold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformBeginReturn:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformTurnToZero:
                addq.b  #1,$3C(a0)
                beq.s   LBZBossSK_LeadPlatformClearRequest
                rts
; ---------------------------------------------------------------------------

LBZBossSK_LeadPlatformClearRequest:
                move.b  #2,routine(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_FollowerPlatformSolidAndDraw:
                lea     LBZBossSK_FollowerPlatformCopyPhase(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   LBZBossSK_PlatformDrawOrBreakAway
; ---------------------------------------------------------------------------

LBZBossSK_FollowerPlatformCopyPhase:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                moveq   #4,d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

LBZBossSK_RunnerDispatchAndCull:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossSK_RunnerStateOffsets(pc,d0.w),d1
                jsr     LBZBossSK_RunnerStateOffsets(pc,d1.w)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
LBZBossSK_RunnerStateOffsets:
                dc.w    LBZBossSK_InitRunnerAndJumpDelay-LBZBossSK_RunnerStateOffsets
                dc.w    LBZBossSK_RunnerMoveAnimateAndWait-LBZBossSK_RunnerStateOffsets
                dc.w    LBZBossSK_RunnerMoveJumpAndWait-LBZBossSK_RunnerStateOffsets
; ---------------------------------------------------------------------------

LBZBossSK_InitRunnerAndJumpDelay:
                lea     LBZEndBossSK_Runner_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$180,x_vel(a0)
                move.l  #LBZEndBossSK_Runner_UniformRawRunFrames,$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBossSK_RunnerBeginJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_RunnerMoveAnimateAndWait:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_RunnerBeginJump:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #LBZBossSK_RunnerSignalReadyAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_RunnerMoveJumpAndWait:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBossSK_RunnerSignalReadyAndDelete:
                move.l  #Delete_Current_Sprite,(a0)
                move.b  #0,mapping_frame(a0)
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorFollowDispatchDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossSK_OperatorStateOffsets(pc,d0.w),d1
                jsr     LBZBossSK_OperatorStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossSK_OperatorStateOffsets:
                dc.w    LBZBossSK_InitOperatorInShip-LBZBossSK_OperatorStateOffsets
                dc.w    LBZBossSK_OperatorWaitForRunner-LBZBossSK_OperatorStateOffsets
                dc.w    LBZBossSK_OperatorChooseBattleFrame-LBZBossSK_OperatorStateOffsets
                dc.w    LBZBossSK_OperatorWaitForEscape-LBZBossSK_OperatorStateOffsets
; ---------------------------------------------------------------------------

LBZBossSK_InitOperatorInShip:
                lea     LBZEndBossSK_Operator_FullAttributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

LBZBossSK_OperatorWaitForRunner:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   LBZBossSK_OperatorBeginBattleAnim
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorBeginBattleAnim:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #LBZBossSK_OperatorBattleAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorChooseBattleFrame:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBossSK_OperatorShowHitFrame
                btst    #7,status(a1)
                bne.s   LBZBossSK_OperatorShowDefeatFrame
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZBossSK_OperatorShowHitFrame:
                move.b  #2,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorShowDefeatFrame:
                move.b  #6,routine(a0)
                move.b  #3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorWaitForEscape:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   LBZBossSK_OperatorQueueDeletion
                rts
; ---------------------------------------------------------------------------

LBZBossSK_OperatorQueueDeletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_InitSolidCover:
                lea     LBZEndBossSK_Cover_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBossSK_CoverCheckFlagsAndSolid,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossSK_CoverCheckFlagsAndSolid:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   LBZBossSK_CoverReleaseRidersAndDelete
                btst    #3,$38(a1)
                bne.s   LBZBossSK_CoverLowerToShortSolid
                moveq   #$13,d1
                move.w  #$80,d2
                move.w  #$120,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_CoverLowerToShortSolid:
                move.l  #LBZBossSK_CoverShortSolidUntilDefeat,(a0)
                addi.w  #$60,y_pos(a0)

LBZBossSK_CoverShortSolidUntilDefeat:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   LBZBossSK_CoverReleaseRidersAndDelete
                moveq   #$13,d1
                moveq   #$14,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_CoverReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Write the subtype to the returned child pointer without a separate allocation check
LBZBossSK_SpawnShotAndSetPattern:
                lea     LBZEndBossSK_Projectile_NormalOneChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                andi.w  #7,d0
                move.b  LBZBossSK_ShotSubtypePattern(pc,d0.w),subtype(a1)
                rts
; ---------------------------------------------------------------------------
LBZBossSK_ShotSubtypePattern:
                dc.b    0,   2,   1,   2,   0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

LBZBossSK_ApplyShotOffsetAndVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                lea     LBZBossSK_ShotOffsetVelocityRecords(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
LBZBossSK_ShotOffsetVelocityRecords:
                dc.w    -$10,   $60, -$600, -$200
                dc.w    -$10,   $60, -$400, -$100
                dc.w    -$10,   $90, -$400,     0
; ---------------------------------------------------------------------------

LBZBossSK_DebrisSelectFrameAndMotion:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  d0,d2
                cmpi.b  #8,d0
                blo.s   LBZBossSK_DebrisApplySubtypeMotion
                move.b  #$B,mapping_frame(a0)
                subi.w  #8,d2
                move.w  d2,d1

LBZBossSK_DebrisApplySubtypeMotion:
                add.w   d0,d0
                lea     LBZBossSK_DebrisVelocityPairs(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                lsr.w   #1,d1
                or.b    d1,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
LBZBossSK_DebrisVelocityPairs:
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$400, -$400
                dc.w    $400, -$400
                dc.w    -$400, -$300
                dc.w    $400, -$300

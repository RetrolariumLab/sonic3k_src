; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZEndBoss:
                lea     LBZBossS3_ArenaActivationBounds(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZEndBoss_Index(pc,d0.w),d1
                jsr     LBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleLBZEndBossSingleColorHitOrEscape
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZEndBoss_Index:
                dc.w    LBZBossS3_InitBossAndArena-LBZEndBoss_Index
                dc.w    LBZBossS3_TickCameraTransition-LBZEndBoss_Index
                dc.w    LBZEndBossS3_Root_PollRunnerReadyFlag-LBZEndBoss_Index
                dc.w    LBZBossS3_CloseCameraToBattleX-LBZEndBoss_Index
                dc.w    LBZEndBossS3_Root_MoveSlowRiseThenWait-LBZEndBoss_Index
                dc.w    LBZBossS3_TickAttackPreparation-LBZEndBoss_Index
                dc.w    LBZBossS3_WaitForPlatformCycle-LBZEndBoss_Index
LBZBossS3_ArenaActivationBounds:
                dc.w    $480,  $660, $3900, $3A20
; ---------------------------------------------------------------------------

LBZBossS3_InitBossAndArena:
                lea     ObjDat_LBZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  #$5A0,(Camera_target_max_Y_pos).w
                move.w  #$3A20,$1C(a0)
                move.w  #$3A20,(Camera_max_X_pos).w
                move.l  #LBZBossS3_SpawnPlatformsAndRunner,$34(a0)
                lea     LBZBossS3_OperatorAndCoverChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                moveq   #PLCID_77,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_LBZEndBoss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

LBZBossS3_TickCameraTransition:
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

LBZBossS3_SpawnPlatformsAndRunner:
                move.b  #4,routine(a0)
                lea     LBZBossS3_LinkedPlatformChildren(pc),a2
                jsr     CreateChild4_LinkListRepeated(pc)
                lea     LBZEndBossS3_Runner_NormalOneChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZEndBossS3_Root_PollRunnerReadyFlag:
                btst    #7,$38(a0)
                bne.s   LBZEndBossS3_Root_SelectCameraClosure
                rts
; ---------------------------------------------------------------------------

LBZEndBossS3_Root_SelectCameraClosure:
                move.b  #6,routine(a0)

LBZBossS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossS3_CloseCameraToBattleX:
                move.w  (Camera_max_X_pos).w,d0
                subq.w  #1,d0
                cmpi.w  #$39F0,d0
                bls.s   LBZBossS3_BeginRiseAndSpawnTrim
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

LBZBossS3_BeginRiseAndSpawnTrim:
                move.b  #8,routine(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                move.w  #-$40,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #LBZBossS3_EnableCollisionAfterRise,$34(a0)
                lea     LBZEndBossS3_Trim_NormalThreeChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZEndBossS3_Root_MoveSlowRiseThenWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBossS3_EnableCollisionAfterRise:
                bset    #2,$38(a0)
                move.b  #$F,$28(a0)

LBZBossS3_BeginAttackPreparation:
                move.b  #$A,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #LBZBossS3_RequestPlatformsAndDelayShot,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_TickAttackPreparation:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBossS3_RequestPlatformsAndDelayShot:
                bset    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZBossS3_LaunchShotAndPollPlatforms,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LaunchShotAndPollPlatforms:
                move.b  #$C,routine(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                bra.w   LBZBossS3_SpawnShotAndSetPattern
; ---------------------------------------------------------------------------

LBZBossS3_WaitForPlatformCycle:
                btst    #1,$38(a0)
                beq.s   LBZBossS3_BeginAttackPreparation
                rts
; ---------------------------------------------------------------------------

LBZBossS3_EscapeMoveAndDraw:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossS3_FinishEscapeAndRestoreMusic:
                bset    #5,$38(a0)
                bclr    #7,render_flags(a0)
                clr.b   (Boss_flag).w
                jsr     Restore_LevelMusic(pc)
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                move.l  #Go_Delete_Sprite_2,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_ShotDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossS3_ShotStateOffsets(pc,d0.w),d1
                jsr     LBZBossS3_ShotStateOffsets(pc,d1.w)
                jsr     Animate_Raw(pc)
                btst    #7,status(a0)
                bne.s   LBZBossS3_ShotDrawIfParentAlive
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   LBZBossS3_ShotDrawIfParentAlive
                bsr.w   LBZBossS3_ShotBreakUpAndDelete

LBZBossS3_ShotDrawIfParentAlive:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZBossS3_ShotStateOffsets:
                dc.w    LBZBossS3_InitShotPatternMotion-LBZBossS3_ShotStateOffsets
                dc.w    Move_WaitNoFall-LBZBossS3_ShotStateOffsets
                dc.w    LBZBossS3_ShotFallAndProbeFloor-LBZBossS3_ShotStateOffsets
                dc.w    LBZBossS3_ShotCheckWallsAndSlope-LBZBossS3_ShotStateOffsets
; ---------------------------------------------------------------------------

LBZBossS3_InitShotPatternMotion:
                lea     LBZBossS3_ShotAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZBossS3_ShotLoopAnim,$30(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$F,$2E(a0)
                move.l  #LBZBossS3_ShotBeginFloorApproach,$34(a0)
                bra.w   LBZBossS3_ApplyShotOffsetAndVelocity
; ---------------------------------------------------------------------------

LBZBossS3_ShotBeginFloorApproach:
                move.b  #4,routine(a0)
                move.l  #LBZBossS3_ShotBeginRolling,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_ShotFallAndProbeFloor:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

LBZBossS3_ShotBeginRolling:
                move.b  #6,routine(a0)
                move.l  #LBZBossS3_ShotBreakUpAndDelete,$34(a0)
                move.w  angle(a0),d0
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_ShotCheckWallsAndSlope:
                move.w  #$10,d3
                jsr     ObjHitWall_DoRoutine(pc)
                jsr     ObjHitFloor2_DoRoutine(pc)
                tst.b   d3
                beq.s   LBZBossS3_ShotMoveAndTryFloorEffects
                addi.w  #$10,x_vel(a0)

; Emit effects every fourth V-int tick when X speed lies outside the signed low-speed window
LBZBossS3_ShotMoveAndTryFloorEffects:
                jsr     (MoveSprite2).l
                move.w  x_vel(a0),d0
                addi.w  #$200,d0
                cmpi.w  #$400,d0
                blo.w   LBZBossS3_SharedReturn
                move.w  (V_int_run_count+2).w,d0
                andi.w  #3,d0
                bne.w   LBZBossS3_SharedReturn
                lea     LBZEndBossS3_SmallEffect_NormalOneChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBossS3_ShotBreakUpAndDelete:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     LBZBossS3_ShotBreakupChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBossS3_InitSmallEffectAndDelay:
                lea     LBZBossS3_SmallEffectAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #LBZBossS3_EffectTickMoveAndDraw,(a0)
                move.l  #LBZBossS3_SmallEffectDeleteAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bne.s   LBZBossS3_EffectStoreNegativeDelay
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_EffectStoreNegativeDelay:
                subi.w  #$10,d0
                add.w   d0,d0
                neg.w   d0
                move.w  d0,$2E(a0)

LBZBossS3_EffectTickMoveAndDraw:
                addq.w  #1,$2E(a0)
                bmi.w   LBZBossS3_SharedReturn
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossS3_InitShotDebris:
                lea     LBZBossS3_ShotDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #Obj_FlickerMove,(a0)
                bra.w   LBZBossS3_DebrisSelectFrameAndMotion
; ---------------------------------------------------------------------------

LBZBossS3_TrimFollowDispatchAndDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossS3_TrimStateOffsets(pc,d0.w),d1
                jsr     LBZBossS3_TrimStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
LBZBossS3_TrimStateOffsets:
                dc.w    LBZBossS3_InitTrimFrame-LBZBossS3_TrimStateOffsets
                dc.w    LBZBossS3_TrimWaitForBossRise-LBZBossS3_TrimStateOffsets
                dc.w    LBZBossS3_TrimCheckDefeat-LBZBossS3_TrimStateOffsets
; ---------------------------------------------------------------------------

LBZBossS3_InitTrimFrame:
                lea     LBZEndBossS3_Trim_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addq.w  #2,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_TrimWaitForBossRise:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   LBZBossS3_TrimApplyYJitter
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_TrimApplyYJitter:
                move.w  $2E(a0),d0
                addq.w  #1,$2E(a0)
                andi.w  #3,d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_TrimCheckDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBossS3_TrimSpawnDebris
                rts
; ---------------------------------------------------------------------------

LBZBossS3_TrimSpawnDebris:
                lea     LBZBossS3_TrimDebrisChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBossS3_InitTrimDebris:
                lea     LBZBossS3_TrimDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZBossS3_TrimDebrisXSpeeds(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossS3_TrimDebrisXSpeeds:
                dc.w    -$100
                dc.w    $200
                dc.w    -$200
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformDispatchAndDraw:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossS3_LeadPlatformStateOffsets(pc,d0.w),d1
                jsr     LBZBossS3_LeadPlatformStateOffsets(pc,d1.w)
                lea     LBZBossS3_SharedReturn(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   LBZBossS3_PlatformDrawOrBreakAway
; ---------------------------------------------------------------------------
LBZBossS3_LeadPlatformStateOffsets:
                dc.w    LBZBossS3_InitPlatformAndChooseLeader-LBZBossS3_LeadPlatformStateOffsets
                dc.w    LBZBossS3_LeadPlatformWaitRotation-LBZBossS3_LeadPlatformStateOffsets
                dc.w    LBZBossS3_LeadPlatformTurnOutbound-LBZBossS3_LeadPlatformStateOffsets
                dc.w    LBZBossS3_LeadPlatformTickHold-LBZBossS3_LeadPlatformStateOffsets
                dc.w    LBZBossS3_LeadPlatformTurnToZero-LBZBossS3_LeadPlatformStateOffsets
; ---------------------------------------------------------------------------

LBZBossS3_InitPlatformAndChooseLeader:
                lea     LBZEndBossS3_Platform_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                subi.w  #$14,x_pos(a0)
                addi.w  #$40,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   LBZBossS3_PlatformLeaderInitReturn
                move.l  #LBZBossS3_FollowerPlatformSolidAndDraw,(a0)

LBZBossS3_PlatformLeaderInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformWaitRotation:
                btst    #1,$38(a1)
                bne.s   LBZBossS3_LeadPlatformBeginOutbound
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformBeginOutbound:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformTurnOutbound:
                subq.b  #1,$3C(a0)
                cmpi.b  #-$40,$3C(a0)
                bls.s   LBZBossS3_LeadPlatformHoldQuarterTurn
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformHoldQuarterTurn:
                move.b  #6,routine(a0)
                move.w  #$80,$2E(a0)
                move.l  #LBZBossS3_LeadPlatformBeginReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformTickHold:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformBeginReturn:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformTurnToZero:
                addq.b  #1,$3C(a0)
                beq.s   LBZBossS3_LeadPlatformClearRequest
                rts
; ---------------------------------------------------------------------------

LBZBossS3_LeadPlatformClearRequest:
                move.b  #2,routine(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_FollowerPlatformSolidAndDraw:
                lea     LBZBossS3_FollowerPlatformCopyPhase(pc),a2
                bsr.w   MoveAndSolidifyLBZEndBossTopPlatform
                bra.w   LBZBossS3_PlatformDrawOrBreakAway
; ---------------------------------------------------------------------------

LBZBossS3_FollowerPlatformCopyPhase:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                moveq   #4,d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

LBZBossS3_RunnerDispatchAndCull:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossS3_RunnerStateOffsets(pc,d0.w),d1
                jsr     LBZBossS3_RunnerStateOffsets(pc,d1.w)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
LBZBossS3_RunnerStateOffsets:
                dc.w    LBZBossS3_InitRunnerAndJumpDelay-LBZBossS3_RunnerStateOffsets
                dc.w    Move_AnimateRaw_Wait-LBZBossS3_RunnerStateOffsets
                dc.w    LBZBossS3_RunnerMoveJumpAndWait-LBZBossS3_RunnerStateOffsets
; ---------------------------------------------------------------------------

LBZBossS3_InitRunnerAndJumpDelay:
                lea     LBZEndBossS3_Runner_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$180,x_vel(a0)
                move.l  #LBZEndBossS3_Runner_UniformRawRunFrames,$30(a0)
                move.w  #$15,$2E(a0)
                move.l  #LBZBossS3_RunnerBeginJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_RunnerBeginJump:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #LBZBossS3_RunnerSignalReadyAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_RunnerMoveJumpAndWait:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBossS3_RunnerSignalReadyAndDelete:
                move.l  #Delete_Current_Sprite,(a0)
                move.b  #0,mapping_frame(a0)
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorFollowDispatchDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBossS3_OperatorStateOffsets(pc,d0.w),d1
                jsr     LBZBossS3_OperatorStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossS3_OperatorStateOffsets:
                dc.w    LBZBossS3_InitOperatorInShip-LBZBossS3_OperatorStateOffsets
                dc.w    LBZBossS3_OperatorWaitForRunner-LBZBossS3_OperatorStateOffsets
                dc.w    LBZBossS3_OperatorChooseBattleFrame-LBZBossS3_OperatorStateOffsets
                dc.w    LBZBossS3_OperatorWaitForEscape-LBZBossS3_OperatorStateOffsets
; ---------------------------------------------------------------------------

LBZBossS3_InitOperatorInShip:
                lea     LBZEndBossS3_Operator_FullAttributes(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

LBZBossS3_OperatorWaitForRunner:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   LBZBossS3_OperatorBeginBattleAnim
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorBeginBattleAnim:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #LBZBossS3_OperatorBattleAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorChooseBattleFrame:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBossS3_OperatorShowHitFrame
                btst    #7,status(a1)
                bne.s   LBZBossS3_OperatorShowDefeatFrame
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

LBZBossS3_OperatorShowHitFrame:
                move.b  #2,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorShowDefeatFrame:
                move.b  #6,routine(a0)
                move.b  #3,$22(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorWaitForEscape:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   LBZBossS3_OperatorQueueDeletion
                rts
; ---------------------------------------------------------------------------

LBZBossS3_OperatorQueueDeletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LBZBossS3_InitSolidCover:
                lea     LBZEndBossS3_Cover_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBossS3_CoverCheckFlagsAndSolid,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBossS3_CoverCheckFlagsAndSolid:
                moveq   #$13,d1
                moveq   #$14,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   LBZBossS3_CoverReleaseRidersAndDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossS3_CoverReleaseRidersAndDelete:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Write the subtype to the returned child pointer without a separate allocation check
LBZBossS3_SpawnShotAndSetPattern:
                lea     LBZEndBossS3_Projectile_NormalOneChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                andi.w  #7,d0
                move.b  LBZBossS3_ShotSubtypePattern(pc,d0.w),subtype(a1)
                rts
; ---------------------------------------------------------------------------
LBZBossS3_ShotSubtypePattern:
                dc.b    0,   2,   1,   2,   0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

LBZBossS3_ApplyShotOffsetAndVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                lea     LBZBossS3_ShotOffsetVelocityRecords(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
LBZBossS3_ShotOffsetVelocityRecords:
                dc.w    -$10,   $60, -$600, -$200
                dc.w    -$10,   $60, -$400, -$100
                dc.w    -$10,   $90, -$400,     0
; ---------------------------------------------------------------------------

LBZBossS3_DebrisSelectFrameAndMotion:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  d0,d2
                cmpi.b  #8,d0
                blo.s   LBZBossS3_DebrisApplySubtypeMotion
                move.b  #$B,mapping_frame(a0)
                subi.w  #8,d2
                move.w  d2,d1

LBZBossS3_DebrisApplySubtypeMotion:
                add.w   d0,d0
                lea     LBZBossS3_DebrisVelocityPairs(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                lsr.w   #1,d1
                or.b    d1,render_flags(a0)
                rts
; ---------------------------------------------------------------------------
LBZBossS3_DebrisVelocityPairs:
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$400, -$400
                dc.w    $400, -$400
                dc.w    -$400, -$300
                dc.w    $400, -$300

; =============== S U B R O U T I N E =======================================

MoveAndSolidifyLBZEndBossTopPlatform:
                move.w  x_pos(a0),-(sp)
                jsr     (a2)
                moveq   #$12,d1
                moveq   #7,d2
                moveq   #7,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectTop).l
; End of function MoveAndSolidifyLBZEndBossTopPlatform

; =============== S U B R O U T I N E =======================================

HandleLBZEndBossSingleColorHitOrEscape:
                tst.l   (a0)
                beq.s   LBZBossS3_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   LBZBossS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   LBZBossS3_BeginDefeatEscape
                tst.b   $20(a0)
                bne.s   LBZBossS3_HitChooseFlashColor
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

LBZBossS3_HitChooseFlashColor:
                bset    #6,status(a0)
                lea     (Normal_palette_line_2+$16).w,a1
                move.w  #$222,d0
                btst    #0,$20(a0)
                bne.s   LBZBossS3_HitWriteColorAndTick
                move.w  #$EEE,d0

LBZBossS3_HitWriteColorAndTick:
                move.w  d0,(a1)
                subq.b  #1,$20(a0)
                bne.s   LBZBossS3_HitUpdateReturn
                bclr    #6,status(a0)
                move.w  #$222,(a1)
                move.b  $25(a0),collision_flags(a0)

LBZBossS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossS3_BeginDefeatEscape:
                move.l  #LBZBossS3_EscapeMoveAndDraw,(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bset    #4,$38(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #LBZBossS3_FinishEscapeAndRestoreMusic,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   LBZBossS3_ExpandRightCameraBound
                move.b  #4,subtype(a1)

LBZBossS3_ExpandRightCameraBound:
                move.w  #$3AB8,(Camera_stored_max_X_pos).w
                lea     Child6_IncLevX(pc),a2
                jmp     CreateChild6_Simple(pc)
; End of function HandleLBZEndBossSingleColorHitOrEscape

; ---------------------------------------------------------------------------

LBZBossS3_PlatformDrawOrBreakAway:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBossS3_PlatformDetachAndRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossS3_PlatformDetachAndRelease:
                move.l  #MoveChkDel,(a0)
                bset    #7,status(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZBossS3_PlatformDefeatXSpeeds(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jsr     Displace_PlayerOffObject(pc)
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossS3_PlatformDefeatXSpeeds:
                dc.w    $300,  $200, -$200, -$300
ObjDat_LBZEndBoss:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $280
                dc.b    $20, $10,   0, $18
LBZEndBossS3_Runner_FullAttributes:
                dc.l    Map_FBZRobotnikRun
                dc.w    make_art_tile(ArtTile_FBZRobotnikRun,0,0)
                dc.w    $280
                dc.b    $20, $20,   0,   0
LBZEndBossS3_Operator_FullAttributes:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $300
                dc.b    $10,   8,   4,   0
LBZEndBossS3_Cover_FullAttributes:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,0)
                dc.w    $300
                dc.b    8, $20,  $C,   0
LBZEndBossS3_Trim_PartialAttributes:
                dc.w    $280
                dc.b    8, $18,   2,   0
LBZBossS3_TrimDebrisAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $D,   0
LBZBossS3_ShotAttributes:
                dc.w    $280
                dc.b    $10, $10,   5, $9A
LBZBossS3_SmallEffectAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
LBZBossS3_ShotDebrisAttributes:
                dc.w    make_art_tile(ArtTile_LBZEndBoss,1,1)
                dc.w    $200
                dc.b    8,   8,  $A,   0
LBZEndBossS3_Platform_FullAttributes:
                dc.l    Map_LBZEndBoss
                dc.w    make_art_tile(ArtTile_LBZEndBoss,2,0)
                dc.w    $280
                dc.b    8,   8,  $E,   0
LBZBossS3_OperatorAndCoverChildren:
                dc.w    2-1
                dc.l    LBZBossS3_OperatorFollowDispatchDraw
                dc.b    0,  -8
                dc.l    LBZBossS3_InitSolidCover
                dc.b    -$18,-$10
LBZEndBossS3_Runner_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossS3_RunnerDispatchAndCull
                dc.b    $60,-$18
LBZEndBossS3_Trim_NormalThreeChildren:
                dc.w    3-1
                dc.l    LBZBossS3_TrimFollowDispatchAndDraw
                dc.b    -$18, $38
                dc.l    LBZBossS3_TrimFollowDispatchAndDraw
                dc.b    $18, $38
                dc.l    LBZBossS3_TrimFollowDispatchAndDraw
                dc.b    0, $38
LBZBossS3_TrimDebrisChildren:
                dc.w    3-1
                dc.l    LBZBossS3_InitTrimDebris
                dc.b    0,-$18
                dc.l    LBZBossS3_InitTrimDebris
                dc.b    0,  -8
                dc.l    LBZBossS3_InitTrimDebris
                dc.b    0,   8
LBZBossS3_LinkedPlatformChildren:
                dc.w    4-1
                dc.l    LBZBossS3_LeadPlatformDispatchAndDraw
LBZEndBossS3_Projectile_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossS3_ShotDispatchAndDraw
                dc.b    0,   0
LBZEndBossS3_SmallEffect_NormalOneChild:
                dc.w    1-1
                dc.l    LBZBossS3_InitSmallEffectAndDelay
                dc.b    0, $10
LBZBossS3_ShotBreakupChildren:
                dc.w    $C-1
                dc.l    LBZBossS3_InitShotDebris
                dc.b    -8,  -8
                dc.l    LBZBossS3_InitShotDebris
                dc.b    8,  -8
                dc.l    LBZBossS3_InitShotDebris
                dc.b    -8,   8
                dc.l    LBZBossS3_InitShotDebris
                dc.b    8,   8
                dc.l    LBZBossS3_InitShotDebris
                dc.b    -$10,-$10
                dc.l    LBZBossS3_InitShotDebris
                dc.b    $10,-$10
                dc.l    LBZBossS3_InitShotDebris
                dc.b    -$10, $10
                dc.l    LBZBossS3_InitShotDebris
                dc.b    $10, $10
                dc.l    LBZBossS3_InitSmallEffectAndDelay
                dc.b    -8,   6
                dc.l    LBZBossS3_InitSmallEffectAndDelay
                dc.b    6,   8
                dc.l    LBZBossS3_InitSmallEffectAndDelay
                dc.b    -8,  -6
                dc.l    LBZBossS3_InitSmallEffectAndDelay
                dc.b    6,  -8
LBZEndBossS3_Runner_UniformRawRunFrames:
                dc.b    7,   0,   1,   2,   1, $FC
LBZBossS3_OperatorBattleAnim:
                dc.b    7,   0,   1, $FC
LBZBossS3_ShotLoopAnim:
                dc.b    0,   5,   6, $FC
LBZBossS3_SmallEffectDeleteAnim:
                dc.b    5,   7,   7,   8,   9, $F4
                even
Pal_LBZEndBoss:
                binclude "data/Levels/LBZ/Palettes/End Boss.bin"
                even

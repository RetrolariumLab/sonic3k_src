; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss controller, player interaction and coordinated attack state progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZEndBoss:
                lea     DEZEndBoss_ActivationCameraRectangle(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #DEZBoss_TickCameraMusicTransition,(a0)
                move.l  #DEZBoss_InstallBattleDispatcher,$34(a0)
                lea     DEZEndBoss_TargetCameraBounds(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     Boss_BeginCameraTransition(pc)
                clr.b   (_unkFAB8).w
                moveq   #PLCID_76,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_DEZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_DEZEndBoss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     DEZBoss_ExitSceneChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
DEZEndBoss_ActivationCameraRectangle:
                dc.w    $198,  $498, $33E0, $3480
DEZEndBoss_TargetCameraBounds:
                dc.w    $218,  $288, $3400, $34E0
; ---------------------------------------------------------------------------

DEZBoss_TickCameraMusicTransition:
                jmp     SKEndCamera_TickAndSaveMusic(pc)
; ---------------------------------------------------------------------------

DEZBoss_InstallBattleDispatcher:
                move.l  #DEZBoss_BattleDispatchAndCheckHit,(a0)

DEZBoss_SharedReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_BattleDispatchAndCheckHit:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZEndBoss_BattleStateOffsets(pc,d0.w),d1
                jsr     DEZEndBoss_BattleStateOffsets(pc,d1.w)
                bsr.w   ConsumeDEZEndBossReturnedCapsuleHitLatch
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$3F,d0
                bne.s   DEZBoss_BattleTouchDraw
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

DEZBoss_BattleTouchDraw:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
DEZEndBoss_BattleStateOffsets:
                dc.w    DEZBoss_InitBossAndPlayerBumpers-DEZEndBoss_BattleStateOffsets
                dc.w    DEZEndBoss_DescendAndWaitForSwingSetup-DEZEndBoss_BattleStateOffsets
                dc.w    DEZEndBoss_SwingPatrolReverseAndWait-DEZEndBoss_BattleStateOffsets
                dc.w    DEZEndBoss_SwingPatrolReverseAndAnimate-DEZEndBoss_BattleStateOffsets
                dc.w    DEZEndBoss_SwingPatrolReverseAndWait-DEZEndBoss_BattleStateOffsets
                dc.w    DEZEndBoss_SwingPatrolReverseAndAnimate-DEZEndBoss_BattleStateOffsets
; ---------------------------------------------------------------------------

DEZBoss_InitBossAndPlayerBumpers:
                lea     ObjDat_DEZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #DEZEndBoss_StartSwingAndHorizontalPatrol,$34(a0)
                lea     DEZEndBoss_SingleTargetBumperSimpleChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                tst.l   (Player_2).w
                beq.s   DEZBoss_BumperSpawnReturn
                lea     DEZEndBoss_SingleTargetBumperSimpleChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.s   DEZBoss_BumperSpawnReturn
                move.b  #2,subtype(a1)

DEZBoss_BumperSpawnReturn:
                rts
; ---------------------------------------------------------------------------

DEZEndBoss_DescendAndWaitForSwingSetup:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZEndBoss_StartSwingAndHorizontalPatrol:
                jsr     (Swing_Setup1).l
                move.w  #$100,x_vel(a0)

DEZEndBoss_BeginPreReleasePatrolWait:
                move.b  #4,routine(a0)
                andi.b  #$F3,$38(a0)
                move.w  #$B3,$2E(a0)
                move.l  #DEZBoss_TryOpenCapsule,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZEndBoss_SwingPatrolReverseAndWait:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

; Defer the attack while three capsules are active
DEZBoss_TryOpenCapsule:
                cmpi.b  #3,$39(a0)
                bhs.s   DEZBoss_RetryCapsuleAfterWait
                move.b  #6,routine(a0)
                addq.b  #1,$39(a0)
                bset    #3,$38(a0)
                move.l  #DEZEndBoss_SetCapsuleReleaseFlagAndHold,$34(a0)
                lea     DEZEndBossAttack_FixedDelayOpenSequence(pc),a1
                jsr     Set_Raw_Animation(pc)
                lea     DEZBoss_SleeveAndCapsuleChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

DEZBoss_RetryCapsuleAfterWait:
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

DEZEndBoss_SwingPatrolReverseAndAnimate:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

DEZEndBoss_SetCapsuleReleaseFlagAndHold:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #DEZBoss_CloseCapsuleAndResumePatrol,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_CloseCapsuleAndResumePatrol:
                move.b  #$A,routine(a0)
                move.l  #DEZEndBoss_BeginPreReleasePatrolWait,$34(a0)
                lea     DEZEndBossAttack_FixedDelayCloseSequence(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

DEZBoss_BeginDefeatFall:
                move.l  #DEZBoss_FallToAftermathHeight,(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_FallToAftermathHeight:
                jsr     (MoveSprite_LightGravity).l
                cmpi.w  #$318,y_pos(a0)
                bhs.s   DEZBoss_SpawnDefeatFxAndFadeMusic
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_SpawnDefeatFxAndFadeMusic:
                move.l  #DEZBoss_WaitRightEmitterAndRelease,(a0)
                bclr    #7,render_flags(a0)
                lea     DEZBoss_DefeatSweepChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     DEZBoss_DefeatFragmentChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                rts
; ---------------------------------------------------------------------------

DEZBoss_WaitRightEmitterAndRelease:
                btst    #1,(_unkFAB8).w
                beq.s   DEZBoss_EmitterGateReturn
                move.l  #DEZBoss_TickAftermathReleaseWait,(a0)
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                move.w  #$35D0,x_pos(a0)
                move.w  #$328,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l

DEZBoss_EmitterGateReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_TickAftermathReleaseWait:
                move.w  $2E(a0),d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                beq.s   DEZBoss_RestoreMusicAndOpenCamera
                cmpi.w  #$30,$2E(a0)
                bne.s   DEZBoss_AftermathCameraReturn
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

DEZBoss_RestoreMusicAndOpenCamera:
                move.l  #DEZBoss_AdvanceCameraAndLockExit,(a0)
                clr.b   (Boss_flag).w
                moveq   #signextendB(mus_DEZ2),d0
                jsr     (Play_Music).l
                move.w  #$3620,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   DEZBoss_AftermathCameraReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

DEZBoss_AftermathCameraReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_AdvanceCameraAndLockExit:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$3620,(Camera_X_pos).w
                blo.s   DEZBoss_ExitCameraGateReturn
                move.l  #DEZBoss_WaitForPlayerAtExit,(a0)
                move.b  #1,(Scroll_lock).w
                addi.w  #$40,(Camera_max_X_pos).w

DEZBoss_ExitCameraGateReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_WaitForPlayerAtExit:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$160,d0
                cmp.w   (Player_1+x_pos).w,d0
                bls.w   DEZBoss_SaveActThreeStateAndStart
                rts
; ---------------------------------------------------------------------------

DEZBoss_SaveActThreeStateAndStart:
                st      (Act3_flag).w
                move.w  (Ring_count).w,(Act3_ring_count).w
                move.l  (Timer).w,(Act3_timer).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                move.w  #$1700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_InitBumperAndTarget:
                lea     DEZBossBumper_PartialAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZBossBumper_SelectPlayerBySubtype,(a0)

DEZBossBumper_SelectPlayerBySubtype:
                lea     (Player_1).w,a2
                tst.b   subtype(a0)
                beq.s   DEZBoss_BumperAimOutsideOpening
                lea     (Player_2).w,a2

DEZBoss_BumperAimOutsideOpening:
                movea.w parent3(a0),a1
                jsr     GetApproximateObjectBearing(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   DEZBoss_BumperPlaceLaunchAndDraw
                move.b  d0,d1
                smi     d2
                addi.b  #$30,d1
                cmpi.b  #$60,d1
                bhs.s   DEZBoss_BumperPlaceLaunchAndDraw
                moveq   #$30,d0
                tst.b   d2
                beq.s   DEZBoss_BumperPlaceLaunchAndDraw
                moveq   #-$30,d0

DEZBoss_BumperPlaceLaunchAndDraw:
                move.b  d0,$3C(a0)
                lea     (DEZBoss_BumperQuarterTurnLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                bsr.w   LaunchPlayerFromDEZBossBumperContact
                bsr.w   SelectDEZBossBumperFrameAndFlipFromAngle
                moveq   #8,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

DEZBoss_InitAttachedCapsule:
                lea     DEZBossCapsule_PartialAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZBoss_CapsuleFollowUntilRelease,(a0)
                move.b  #$B,y_radius(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_CapsuleFollowUntilRelease:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   DEZBoss_CapsuleBeginExtension
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_CapsuleBeginExtension:
                move.l  #DEZBoss_CapsuleTickExtension,(a0)
                move.w  #$10,$2E(a0)

; Increase the child offset on alternate updates
DEZBoss_CapsuleTickExtension:
                subq.w  #1,$2E(a0)
                bmi.s   DEZBoss_BeginTetheredGravity
                bchg    #2,$38(a0)
                bne.s   DEZBoss_CapsuleDrawDuringExtension
                addq.b  #1,child_dy(a0)

DEZBoss_CapsuleDrawDuringExtension:
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_BeginTetheredGravity:
                move.l  #DEZBoss_TickTetheredGravity,(a0)
                move.w  #7,$2E(a0)

DEZBoss_TickTetheredGravity:
                subq.w  #1,$2E(a0)
                bpl.s   DEZBoss_CopyParentXBeforeRelease
                move.l  #DEZBoss_MoveWithGravityAndLand,(a0)
                moveq   #signextendB(sfx_MushroomBounce),d0
                jsr     (Play_SFX).l

DEZBoss_CopyParentXBeforeRelease:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)

DEZBoss_MoveWithGravityAndLand:
                bsr.w   DEZCapsule_MoveWithGravity
                tst.w   y_vel(a0)
                bpl.s   DEZBoss_CapsuleCheckInitialLanding
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   DEZBoss_CapsuleCheckDeleteAndDraw
                bsr.w   LandDEZBossCapsuleAgainstCeiling
                bra.w   DEZBoss_CapsuleCheckDeleteAndDraw
; ---------------------------------------------------------------------------

DEZBoss_CapsuleCheckInitialLanding:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   DEZBoss_CapsuleCheckDeleteAndDraw
                bsr.w   LandDEZBossCapsuleAgainstFloor

DEZBoss_CapsuleCheckDeleteAndDraw:
                movea.w parent3(a0),a1
                btst    #7,status(a0)
                bne.s   DEZCapsule_ExplodeThenDelete
                btst    #0,(V_int_run_count+3).w
                bne.w   DEZBoss_SharedReturn
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LandDEZBossCapsuleAgainstCeiling:
                sub.w   d1,y_pos(a0)
                move.b  #0,routine(a0)
                move.b  #$C6,collision_flags(a0)
                st      $3A(a0)
                bra.w   DEZBoss_InitRestingCapsule
; End of function LandDEZBossCapsuleAgainstCeiling

; =============== S U B R O U T I N E =======================================

LandDEZBossCapsuleAgainstFloor:
                add.w   d1,y_pos(a0)
                move.b  #2,routine(a0)
                move.b  #$C6,collision_flags(a0)
                clr.b   $3A(a0)

DEZBoss_InitRestingCapsule:
                move.l  #DEZBoss_CapsuleDispatchAndCheckHit,(a0)
                move.w  #(10*60)-1,$2E(a0)
                jsr     (Random_Number).l
                move.w  #$80,d1
                tst.b   d0
                bpl.s   DEZBoss_StoreLandingDriftAndStopY
                neg.w   d1

DEZBoss_StoreLandingDriftAndStopY:
                move.w  d1,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; End of function LandDEZBossCapsuleAgainstFloor

; =============== S U B R O U T I N E =======================================

DEZCapsule_ExplodeThenDelete:
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.w   DEZBoss_CapsuleTryBreakupExplosion
; End of function DEZCapsule_ExplodeThenDelete

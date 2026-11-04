; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss stage initialization, player control, world motion, battle progression and completion events
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZ3_Boss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZ3_Boss_Index(pc,d0.w),d1
                jsr     DEZ3_Boss_Index(pc,d1.w)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
DEZ3_Boss_Index:
                dc.w    DEZFinal_InitWorldIntroAndActors-DEZ3_Boss_Index
                dc.w    DEZFinal_AdvanceIntroToCameraGate-DEZ3_Boss_Index
                dc.w    DEZFinal_AdvanceIntroToPlayerStop-DEZ3_Boss_Index
                dc.w    DEZFinal_WaitForIntroDetail-DEZ3_Boss_Index
                dc.w    DEZFinalWorld_RaiseForTimedIntroInterval-DEZ3_Boss_Index
                dc.w    DEZFinal_WaitCameraAndSpawnBattle-DEZ3_Boss_Index
                dc.w    DEZFinalWorld_StepHopOrImpact-DEZ3_Boss_Index
                dc.w    DEZFinalWorld_WaitForImpactCallback-DEZ3_Boss_Index
                dc.w    DEZFinal_WaitArmsOrBeginReposition-DEZ3_Boss_Index
                dc.w    DEZFinalWorld_LowerToRepositionThreshold-DEZ3_Boss_Index
                dc.w    DEZFinal_RiseIntoHeadPhase-DEZ3_Boss_Index
                dc.w    DEZFinal_LateHopCheckDefeatAndFire-DEZ3_Boss_Index
                dc.w    DEZFinal_LateImpactWaitAndFire-DEZ3_Boss_Index
; ---------------------------------------------------------------------------

DEZFinal_InitWorldIntroAndActors:
                move.b  #2,routine(a0)
                bset    #2,render_flags(a0)
                move.w  a0,(SceneControllerObjectAddress).w
                clr.l   (SceneCreditIndexOrBossMotionPlanAngle).w
                lea     (ArtKosM_DEZFinalBossMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZFinalBossMisc),d2
                jsr     (Queue_Kos_Module).l
                jsr     (AllocateObject).l
                bne.s   DEZFinalWorld_AttemptIntroDetailActor
                move.l  #DEZFinalIntroRunner_Initialize,(a1)

DEZFinalWorld_AttemptIntroDetailActor:
                jsr     (AllocateObject).l
                bne.s   DEZFinal_PlaceIntroPlayers
                move.l  #DEZFinal_InitIntroPanel,(a1)
                move.w  a0,parent3(a1)

DEZFinal_PlaceIntroPlayers:
                lea     (Player_1).w,a1
                move.w  #$30,x_pos(a1)
                move.w  #$CD,y_pos(a1)
                bsr.w   SetDEZFinalIntroPlayerRunControl
                lea     (Player_2).w,a1
                move.w  #$10,x_pos(a1)
                move.w  #$CD,y_pos(a1)

; =============== S U B R O U T I N E =======================================

SetDEZFinalIntroPlayerRunControl:
                move.b  #$81,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #$600,x_vel(a1)
                move.w  #$600,ground_vel(a1)
                cmpi.b  #1,character_id(a1)
                bne.s   DEZFinalIntroPlayer_ReturnAfterRunSetup
                addq.w  #4,y_pos(a1)

DEZFinalIntroPlayer_ReturnAfterRunSetup:
                rts
; End of function SetDEZFinalIntroPlayerRunControl

; ---------------------------------------------------------------------------

DEZFinal_AdvanceIntroToCameraGate:
                bsr.w   AdvanceBothDEZIntroPlayersSixPixels
                move.w  (Camera_X_pos).w,d1
                addi.w  #$98,d1
                cmp.w   d1,d0
                blo.s   DEZFinalWorld_ReturnAfterIntroCameraGate
                move.b  #4,routine(a0)
                clr.b   (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   DEZFinalWorld_ReturnAfterIntroCameraGate
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

DEZFinalWorld_ReturnAfterIntroCameraGate:
                rts

; =============== S U B R O U T I N E =======================================

AdvanceBothDEZIntroPlayersSixPixels:
                lea     (Player_2).w,a1
                bsr.w   AdvanceDEZIntroPlayerSixPixels
                lea     (Player_1).w,a1
; End of function AdvanceBothDEZIntroPlayersSixPixels

; =============== S U B R O U T I N E =======================================

AdvanceDEZIntroPlayerSixPixels:
                move.w  x_pos(a1),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a1)
                rts
; End of function AdvanceDEZIntroPlayerSixPixels

; ---------------------------------------------------------------------------

DEZFinal_AdvanceIntroToPlayerStop:
                bsr.s   AdvanceBothDEZIntroPlayersSixPixels
                cmpi.w  #$360,d0
                blo.s   DEZFinal_IntroPlayerStopReturn
                move.b  #6,routine(a0)
                bsr.w   StopDEZIntroPlayerAndSetWaitingAnimation
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

StopDEZIntroPlayerAndSetWaitingAnimation:
                jsr     Stop_Object(pc)
                move.b  #5,anim(a1)

DEZFinal_IntroPlayerStopReturn:
                rts
; End of function StopDEZIntroPlayerAndSetWaitingAnimation

; ---------------------------------------------------------------------------

DEZFinal_WaitForIntroDetail:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                beq.s   DEZFinal_IntroReleaseReturn
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.w  #-$80,y_vel(a0)
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                jsr     (AllocateObject).l
                bne.s   DEZFinal_LoadExplosionArtAndTryGate
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

DEZFinal_LoadExplosionArtAndTryGate:
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   DEZFinal_IntroReleaseReturn
                move.l  #DEZFinal_LockBattleCameraAtThreshold,(a1)

DEZFinal_IntroReleaseReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinalWorld_RaiseForTimedIntroInterval:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   DEZFinalWorld_ReturnAfterRiseTimerUpdate
                move.b  #$A,routine(a0)

DEZFinalWorld_ReturnAfterRiseTimerUpdate:
                rts
; ---------------------------------------------------------------------------

DEZFinal_WaitCameraAndSpawnBattle:
                btst    #2,(SceneSyncFlagsOrMHZState).w
                beq.s   DEZFinal_BattleSetupGateReturn
                move.b  #$C,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #1,$40(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinalWorld_AttemptMasterEmeraldActor
                move.l  #DEZFinal_InitHeadHealthAndOffsets,(a1)
                move.w  a0,parent3(a1)

DEZFinalWorld_AttemptMasterEmeraldActor:
                jsr     (AllocateObject).l
                bne.s   DEZFinalWorld_AttemptArmControllerPair
                move.l  #DEZFinal_InitMasterEmerald,(a1)
                move.w  a0,parent3(a1)

DEZFinalWorld_AttemptArmControllerPair:
                lea     DEZFinalArmControllers_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)

DEZFinal_BattleSetupGateReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Use a half-sine lift while moving horizontally, then dispatch the impact phase
DEZFinalWorld_StepHopOrImpact:
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                move.b  angle(a0),d0
                addq.b  #2,d0
                andi.b  #$7F,d0
                move.b  d0,angle(a0)
                beq.s   DEZFinal_LandHopAndDispatch
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.w  $3A(a0),d1
                sub.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_LandHopAndDispatch:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.b  $30(a0),d0
                jmp     DEZFinalWorld_ImpactPhaseBranchTable(pc,d0.w)
; End of function DEZFinalWorld_StepHopOrImpact

; ---------------------------------------------------------------------------

DEZFinalWorld_ImpactPhaseBranchTable:
                bra.w   DEZFinal_ChooseHopAndArmAttack
; ---------------------------------------------------------------------------
                bra.w   DEZFinal_ChooseArmAttackAfterImpact
; ---------------------------------------------------------------------------
                bra.w   DEZFinalWorld_BeginLatePhaseImpactWait
; ---------------------------------------------------------------------------

DEZFinal_ChooseHopAndArmAttack:
                move.l  #DEZFinal_ChooseHopFromPlayerRegion,$34(a0)
                cmpi.w  #$540,x_pos(a0)
                blo.s   DEZFinal_ImpactSetupReturn
                move.b  #4,$30(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ChooseArmAttackAfterImpact:
                move.l  #DEZFinalWorld_RequestArmAttackAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinalWorld_BeginLatePhaseImpactWait:
                move.b  #$18,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #DEZFinal_BeginRightwardLateHop,$34(a0)

DEZFinal_ImpactSetupReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinalWorld_WaitForImpactCallback:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

DEZFinal_ChooseHopFromPlayerRegion:
                move.b  #$C,routine(a0)
                moveq   #1,d2
                move.w  (Player_1+x_pos).w,d0
                cmpi.w  #$610,d0
                bhs.s   DEZFinal_CheckRightRegionHop
                move.w  x_pos(a0),d1
                subi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   DEZFinalWorld_StoreIntegerHopStep
                bra.w   DEZFinalWorld_NegateSelectedHopStep
; ---------------------------------------------------------------------------

DEZFinal_CheckRightRegionHop:
                move.w  x_pos(a0),d1
                addi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   DEZFinalWorld_StoreIntegerHopStep

DEZFinalWorld_NegateSelectedHopStep:
                neg.w   d2

DEZFinalWorld_StoreIntegerHopStep:
                move.w  d2,$40(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinalWorld_RequestArmAttackAndWait:
                move.b  #$10,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_WaitArmsOrBeginReposition:
                cmpi.w  #-1,(SceneTimerOrSharedMotionRecordBase).w
                beq.s   DEZFinal_BeginArmDefeatReposition
                btst    #1,$38(a0)
                beq.w   DEZFinal_ChooseHopFromPlayerRegion
                rts
; ---------------------------------------------------------------------------

DEZFinal_BeginArmDefeatReposition:
                move.b  #$12,routine(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_LockCameraAfterArmPhase
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

DEZFinal_LockCameraAfterArmPhase:
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

DEZFinalWorld_LowerToRepositionThreshold:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18F,d0
                blo.s   DEZFinalWorld_ReturnAfterLoweringStep
                move.b  #$14,routine(a0)
                move.w  #$6C0,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,x_pos(a0)

DEZFinalWorld_ReturnAfterLoweringStep:
                rts
; ---------------------------------------------------------------------------

DEZFinal_RiseIntoHeadPhase:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$AF,d0
                bhi.w   DEZFinalAttackActors_SharedReturn
                move.b  #8,$30(a0)
                move.w  #$80,$1C(a0)
                move.w  y_pos(a0),$3A(a0)
                clr.w   angle(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   DEZFinal_QueueHeadPhaseEmeraldArt
                move.l  #DEZFinal_InitHeadTrigger,(a1)
                move.w  a0,parent3(a1)

DEZFinal_QueueHeadPhaseEmeraldArt:
                lea     (ArtKosM_BossMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_BossMasterEmerald),d2
                jsr     (Queue_Kos_Module).l

DEZFinal_BeginRightwardLateHop:
                move.b  #$16,routine(a0)
                move.w  #1,$40(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_LateHopCheckDefeatAndFire:
                bsr.w   DEZFinalWorld_TryBeginDefeat
                bsr.w   DEZFinal_TryTimedFireball
                bsr.w   DEZFinalWorld_StepHopOrImpact
                bra.w   DEZFinal_LockBoundsAndNudgeCamera
; ---------------------------------------------------------------------------

DEZFinal_LateImpactWaitAndFire:
                bsr.w   DEZFinalWorld_TryBeginDefeat
                bsr.w   DEZFinal_TryTimedFireball
                addq.w  #1,x_pos(a0)
                bsr.w   DEZFinal_LockBoundsAndNudgeCamera
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZFinal_MoveDefeatedWorldToExitY:
                jsr     (MoveSprite2).l
                cmpi.w  #$18F,y_pos(a0)
                bhs.s   DEZFinal_StopShakeAndTryEscapeShip
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

DEZFinal_StopShakeAndTryEscapeShip:
                clr.w   (Screen_shake_flag).w
                clr.w   (Events_bg+$00).w
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_QueueEscapeArtAndDelete
                move.l  #DEZFinal_EscapeDispatchHitAndDraw,(a1)

DEZFinal_QueueEscapeArtAndDelete:
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_DEZFinalBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZFinalBossDebris),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Go_Delete_Sprite_2).l
; End of function DEZFinal_LateHopCheckDefeatAndFire

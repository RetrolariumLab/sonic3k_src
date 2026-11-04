; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss battle controller, attacks, parent actors and stage completion progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZEndBoss:
                move.w  a0,(_unkFAA4).w
                move.l  #LRZEndBoss_WaitForArenaPlatformReady,(a0)
                lea     (ArtKosM_LRZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LRZ3PlatformDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3PlatformDebris),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_LRZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

LRZEndBoss_WaitForArenaPlatformReady:
                btst    #0,(_unkFA88).w
                beq.w   LRZBoss_SharedReturn
                move.b  #1,(Boss_flag).w
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #LRZBoss_InstallBattleAndMusicID,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZBoss_InstallBattleAndMusicID:
                move.l  #LRZEndBoss_DispatchConsumeSelfHitAndDraw,(a0)
                move.b  #mus_EndBoss,(Current_music+1).w

LRZBoss_SharedReturn:
                rts
; ---------------------------------------------------------------------------

LRZEndBoss_DispatchConsumeSelfHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LRZEndBoss_StateOffsets(pc,d0.w),d1
                jsr     LRZEndBoss_StateOffsets(pc,d1.w)
                bsr.w   LRZBoss_HandleSelfHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LRZEndBoss_StateOffsets:
                dc.w    LRZBoss_InitBossAndEmerge-LRZEndBoss_StateOffsets
                dc.w    LRZBoss_FallToLavaSurface-LRZEndBoss_StateOffsets
                dc.w    LRZBoss_TickStreamAgeAndFollowLava-LRZEndBoss_StateOffsets
                dc.w    LRZBoss_WaitPressureThenSubmerge-LRZEndBoss_StateOffsets
                dc.w    LRZBoss_DescendAndTickHold-LRZEndBoss_StateOffsets
                dc.w    LRZBoss_TickSubmergedHold-LRZEndBoss_StateOffsets
; ---------------------------------------------------------------------------

LRZBoss_InitBossAndEmerge:
                lea     ObjDat_LRZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$B10,x_pos(a0)
                move.w  #$640,y_pos(a0)
                move.b  #$E,collision_property(a0)
                move.w  #-$12,angle(a0)
                move.w  #-$580,y_vel(a0)
                moveq   #signextendB(sfx_BossMagma),d0
                jsr     (Play_SFX).l
                lea     LRZBoss_SurfaceAndDisplayChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LRZBoss_FallToLavaSurface:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   LRZBoss_EmergenceUpdateReturn
                move.w  #$600,d0
                cmp.w   y_pos(a0),d0
                bls.s   LRZBoss_ClampLavaYAndArmShotCycle

LRZBoss_EmergenceUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LRZBoss_ClampLavaYAndArmShotCycle:
                move.w  d0,y_pos(a0)
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$7F,d0
                move.w  d0,$2E(a0)
                move.w  d0,$3A(a0)
                move.l  #LRZBoss_FireAndShortenShotInterval,$34(a0)
                moveq   #1,d0
                btst    #0,render_flags(a0)
                bne.s   LRZBoss_SetStreamDirectionAndSpawn
                moveq   #-1,d0

LRZBoss_SetStreamDirectionAndSpawn:
                move.w  d0,(_unkFAA2).w
                move.w  d0,(Events_bg+$08).w
                jsr     (AllocateObject).l
                bne.s   LRZBoss_StreamControllerSpawnReturn
                move.l  #LRZBoss_InitStreamPlatformSpawner,(a1)

LRZBoss_StreamControllerSpawnReturn:
                rts
; ---------------------------------------------------------------------------

LRZBoss_TickStreamAgeAndFollowLava:
                addq.w  #1,(_unkFA84).w
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZBoss_FireAndShortenShotInterval:
                subq.b  #1,$39(a0)
                bmi.s   LRZEndBoss_StartPostVolleyStreamHold
                subi.w  #$10,$3A(a0)
                move.w  $3A(a0),$2E(a0)
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     LRZBoss_ShotAndEffectChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LRZEndBoss_StartPostVolleyStreamHold:
                move.w  #$F7,$2E(a0)
                move.l  #LRZBoss_StopPressureAndResetStream,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZBoss_StopPressureAndResetStream:
                move.b  #6,routine(a0)
                clr.b   (Events_bg+$09).w
                clr.w   (_unkFA84).w
                rts
; ---------------------------------------------------------------------------

LRZBoss_WaitPressureThenSubmerge:
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                tst.w   (Events_bg+$0A).w
                bne.w   LRZBoss_SharedReturn
                move.b  #8,routine(a0)
                clr.b   (_unkFAA3).w
                move.w  #$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LRZEndBoss_StartSubmergedPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZBoss_DescendAndTickHold:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZEndBoss_StartSubmergedPause:
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LRZBoss_ChooseNextEmergenceSide,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZBoss_TickSubmergedHold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZBoss_ChooseNextEmergenceSide:
                move.b  #2,routine(a0)
                move.w  #-$580,y_vel(a0)
                move.w  #$A30,d1
                bchg    #0,render_flags(a0)
                beq.s   LRZBoss_SetEmergenceXAndPlaySound
                move.w  #$B10,d1

LRZBoss_SetEmergenceXAndPlaySound:
                move.w  d1,x_pos(a0)
                moveq   #signextendB(sfx_BossMagma),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

LRZBoss_SinkDuringDefeat:
                subq.w  #1,$2E(a0)
                bmi.s   LRZBoss_SignalAndSpawnInvertedCapsule
                addq.w  #1,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_SignalAndSpawnInvertedCapsule:
                move.l  #LRZBoss_WaitEndFlagAndRestoreRoute,(a0)
                ori.b   #$30,$38(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   LRZBoss_TryCapsulePaletteActor
                move.l  #Obj_EggCapsule,(a1)
                bset    #1,render_flags(a1)

LRZBoss_TryCapsulePaletteActor:
                jsr     (AllocateObject).l
                bne.s   LRZEndBossDefeat_LoadEggCapsulePatterns
                move.l  #LRZBoss_WaitCapsuleAndInitPalette,(a1)

LRZEndBossDefeat_LoadEggCapsulePatterns:
                lea     (PLC_EggCapsule).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

LRZBoss_WaitEndFlagAndRestoreRoute:
                tst.b   (_unkFAA8).w
                bne.w   LRZBoss_SharedReturn
                move.l  #LRZEndBossCompletion_PermanentIdleReturn,(a0)
                bset    #1,(_unkFA88).w
                jsr     (AllocateObject).l
                bne.s   LRZBoss_RestorePlayersAndOpenCamera
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_LRZ2,subtype(a1)

LRZBoss_RestorePlayersAndOpenCamera:
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                clr.w   (Ctrl_1_logical).w
                move.w  #$EC0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   LRZEndBossCompletion_TryExitLevelTrigger
                move.l  #Obj_IncLevEndXGradual,(a1)

LRZEndBossCompletion_TryExitLevelTrigger:
                jsr     (AllocateObject).l
                bne.s   LRZBoss_ExitTriggerSpawnReturn
                move.l  #Obj_StartNewLevel,(a1)
                move.b  #$2D,subtype(a1)
                move.w  #$FE8,x_pos(a1)
                move.w  #$5E0,y_pos(a1)

LRZBoss_ExitTriggerSpawnReturn:
                rts
; ---------------------------------------------------------------------------

LRZEndBossCompletion_PermanentIdleReturn:
                rts
; ---------------------------------------------------------------------------

LRZBoss_InitStreamPlatformSpawner:
                move.l  #LRZBoss_WaitPlatformSeparation,(a0)
                move.w  #$9E0,d0
                tst.b   (_unkFAA3).w
                bmi.s   LRZBoss_StoreEdgeAndTryFirstPlatform
                move.w  #$B60,d0

LRZBoss_StoreEdgeAndTryFirstPlatform:
                move.w  d0,x_pos(a0)
                bsr.w   LRZBossStream_SpawnPlatform

LRZBoss_WaitPlatformSeparation:
                tst.b   (_unkFAA3).w
                beq.s   LRZBoss_DeleteCurrentActor
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   LRZBoss_CheckSpacingAndTryPlatform
                neg.w   d0

LRZBoss_CheckSpacingAndTryPlatform:
                cmpi.w  #$80,d0
                blo.w   LRZBoss_SharedReturn

; =============== S U B R O U T I N E =======================================

; Save the allocated slot for the next platform spacing test
LRZBossStream_SpawnPlatform:
                jsr     (AllocateObject).l
                bne.s   LRZBoss_PlatformSpawnReturn
                move.l  #LRZBoss_InitStreamPlatform,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  a1,$44(a0)

LRZBoss_PlatformSpawnReturn:
                rts
; End of function LRZBossStream_SpawnPlatform

; ---------------------------------------------------------------------------

LRZBoss_DeleteCurrentActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LRZBossProjectile_InitializeUpwardLaunch:
                lea     LRZBossProjectile_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZBoss_ShotChooseLavaLane,(a0)
                move.w  #-$800,y_vel(a0)

LRZBoss_ShotChooseLavaLane:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                tst.w   y_vel(a0)
                bmi.s   LRZBoss_ShotTryPeriodicTrail
                move.l  #LRZBoss_ShotFallToLaneSurface,(a0)
                move.w  #$100,priority(a0)
                moveq   #$40,d0
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   LRZBoss_ShotBindLaneAndLavaSample
                move.w  #$140,d0

; Cache the horizontal-scroll table address for this lane before the shot descends
LRZBoss_ShotBindLaneAndLavaSample:
                move.w  d0,d1
                addi.w  #$9E0,d0
                move.w  d0,x_pos(a0)
                lsr.w   #1,d1
                lea     (HScroll_table+$100).w,a1
                adda.w  d1,a1
                move.w  a1,$44(a0)

LRZBoss_ShotTryPeriodicTrail:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   LRZBoss_ShotFallAndTouchCull
                lea     LRZBossProjectile_SingleTrailNormalChild(pc),a2
                jsr     (CreateChild1_Normal).l

LRZBoss_ShotFallAndTouchCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

LRZBoss_ShotFallToLaneSurface:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                jsr     (MoveSprite_LightGravity).l
                movea.w $44(a0),a1
                moveq   #0,d0
                move.b  (a1),d0
                subi.w  #$30,d0
                neg.w   d0
                addi.w  #$612,d0
                cmp.w   y_pos(a0),d0
                bls.s   LRZBoss_ShotBeginLavaRide
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

LRZBoss_ShotBeginLavaRide:
                move.l  #LRZBoss_ShotCheckParentAndStream,(a0)
                clr.w   y_vel(a0)

LRZBoss_ShotCheckParentAndStream:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                tst.b   (_unkFAA3).w
                bne.s   LRZBoss_ShotRideLavaAndCheckSelfHit
                tst.b   render_flags(a0)
                bpl.w   LRZBoss_DeleteCurrentActor

LRZBoss_ShotRideLavaAndCheckSelfHit:
                bsr.w   SetLRZLavaRiderHorizontalStreamVelocity
                jsr     (MoveSprite2).l
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                bsr.w   LRZBoss_ShotCheckBossSelfHit
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

LRZBoss_InitShotEffect:
                lea     LRZBossShotEffect_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZBossShotEffect_FollowAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

LRZBossShotEffect_FollowAnimateAndDraw:
                jsr     (Refresh_ChildPosition).l
                lea     LRZBoss_ShotEffectDeleteAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_InitShotTrailAndMotion:
                lea     LRZBossProjectileTrail_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZBoss_ShotTrailRiseAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$100,y_vel(a0)

LRZBoss_ShotTrailRiseAndDraw:
                lea     LRZBoss_ShotTrailDeleteAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZBoss_InitSurfaceEffect:
                lea     LRZBossSurfaceEffect_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZBoss_SurfaceEffectFollowAndDraw,(a0)

LRZBoss_SurfaceEffectFollowAndDraw:
                jsr     (Refresh_ChildPosition).l
                lea     LRZBossSurfaceEffect_UniformFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

LRZBoss_InitStatusDisplay:
                lea     LRZBoss_StatusDisplayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #LRZBoss_StatusDisplayChooseHitFrame,(a0)

; The hit frame takes precedence over the defeat frame
LRZBoss_StatusDisplayChooseHitFrame:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                move.b  #$F,mapping_frame(a0)
                btst    #6,status(a1)
                beq.s   LRZBoss_StatusDisplayCheckDefeat
                move.b  #$10,mapping_frame(a0)
                bra.w   LRZBoss_StatusDisplayDrawOrDiscard
; ---------------------------------------------------------------------------

LRZBoss_StatusDisplayCheckDefeat:
                btst    #7,status(a1)
                beq.s   LRZBoss_StatusDisplayDrawOrDiscard
                move.b  #$11,mapping_frame(a0)

LRZBoss_StatusDisplayDrawOrDiscard:
                jmp     (Child_Draw_Sprite2).l
; End of function LRZBoss_DeleteCurrentActor

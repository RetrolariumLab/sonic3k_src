; Owner: objects/bosses/aiz/s3
; Responsibility: Angel Island miniboss arrival cutscene, flame actors and scene transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMinibossCutscene:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossCutscene_Index(pc,d0.w),d1
                jsr     AIZMinibossCutscene_Index(pc,d1.w)
                bra.w   AIZMiniS3_CheckHitFlashOrDefeat
; ---------------------------------------------------------------------------
AIZMinibossCutscene_Index:
                dc.w    AIZMiniS3_InitArrivalBoss-AIZMinibossCutscene_Index
                dc.w    AIZMiniS3_WaitForArrivalCamera-AIZMinibossCutscene_Index
                dc.w    AIZMiniS3_TickCallbackWait-AIZMinibossCutscene_Index
                dc.w    AIZMiniS3_DescendAndDraw-AIZMinibossCutscene_Index
                dc.w    AIZMiniS3_SwingMoveAndDraw-AIZMinibossCutscene_Index
; ---------------------------------------------------------------------------

AIZMiniS3_InitArrivalBoss:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$60,collision_property(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jmp     (Load_PLC).l
; ---------------------------------------------------------------------------

AIZMiniS3_WaitForArrivalCamera:
                move.w  (Camera_X_pos).w,d0
                move.w  #$2F10,d5
                cmp.w   d5,d0
                bhs.s   AIZMiniS3_SpawnFlybysAndLoadPalette
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_SpawnFlybysAndLoadPalette:
                move.l  #AIZMiniS3_SpawnBodyAndStartDescent,$34(a0)
                lea     AIZMiniS3_FlybyChildren(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l

AIZMiniS3_LockCameraAndFadeMusic:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.w  d5,(Camera_min_X_pos).w
                move.w  d5,(Camera_max_X_pos).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

AIZMiniS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_TickCallbackWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_SpawnBodyAndStartDescent:
                move.l  #AIZMiniS3_ArmBarrelsAndBeginSwing,$34(a0)
                move.b  #6,routine(a0)
                lea     AIZMiniS3_BodyAndTrimChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     AIZMiniS3_ArrivalBarrelChildren(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

StartAIZMinibossDescentAndMusic:
                move.w  #$100,y_vel(a0)
                move.w  #$AF,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                rts
; End of function StartAIZMinibossDescentAndMusic

; ---------------------------------------------------------------------------

AIZMiniS3_DescendAndDraw:
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArmBarrelsAndBeginSwing:
                move.w  #$7F,$2E(a0)
                move.l  #AIZMiniS3_WaitAndSpawnDepartureBlast,$34(a0)
                move.b  #3,$39(a0)
                bset    #1,$38(a0)

AIZMiniS3_BeginVerticalSwing:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)

; =============== S U B R O U T I N E =======================================

Swing_Setup1:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function Swing_Setup1

; ---------------------------------------------------------------------------

AIZMiniS3_SwingMoveAndDraw:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------
; unused
                subq.b  #1,$39(a0)
                bpl.s   AIZMiniS3_LegacySpawnArrivalFlames
                move.l  #AIZMiniS3_WaitAndSpawnDepartureBlast,$34(a0)

AIZMiniS3_LegacySpawnArrivalFlames:
                move.w  #$40,$2E(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_WaitAndSpawnDepartureBlast:
                move.w  #$10,$2E(a0)
                move.l  #AIZMiniS3_BeginRightwardDeparture,$34(a0)
                lea     AIZMiniS3_DepartureBlastChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_BeginRightwardDeparture:
                move.l  #AIZMiniS3_MoveAndTickDeparture,(a0)
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                move.b  #$F,collision_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$40,$2E(a0)
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   AIZMiniS3_SetDepartureEventAndCallback
                move.w  #$120,$2E(a0)

AIZMiniS3_SetDepartureEventAndCallback:
                move.l  #Go_Delete_Sprite,$34(a0)
                st      (Events_fg_5).w
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_MoveAndTickDeparture:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   AIZMiniS3_RestoreLevelAndQueueCleanup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_RestoreLevelAndQueueCleanup:
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

AIZMiniS3_InitArrivalRotor:
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     AIZMiniS3_RotorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #AIZMiniS3_RotorLoopAnimation,$30(a0)
                move.l  #AIZMiniS3_RotorFollowAndCheckBossDeath,(a0)
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniS3_RotorFollowAndCheckBossDeath:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   AIZMiniS3_RotorDrawUntilDeparture
                clr.b   collision_flags(a0)

AIZMiniS3_RotorDrawUntilDeparture:
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniS3_InitArrivalTrim:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #AIZMiniS3_TrimFollowUntilDeparture,(a0)
                lea     AIZMiniS3_TrimAttributes(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

AIZMiniS3_TrimFollowUntilDeparture:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelFollowDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniS3_ArrivalBarrelStateOffsets(pc,d0.w),d1
                jsr     AIZMiniS3_ArrivalBarrelStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
AIZMiniS3_ArrivalBarrelStateOffsets:
                dc.w    AIZMiniS3_InitBarrelAttributes-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_ArrivalBarrelWaitRequest-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_ArrivalBarrelTickStagger-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_BarrelAnimatePairs-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_ArrivalBarrelTickShots-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_BarrelAnimatePairs-AIZMiniS3_ArrivalBarrelStateOffsets
                dc.w    AIZMiniS3_SharedReturn-AIZMiniS3_ArrivalBarrelStateOffsets
; ---------------------------------------------------------------------------

AIZMiniS3_InitBarrelAttributes:
                lea     AIZMiniS3_BarrelAttributes(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZMiniS3_ArrivalBarrelSetStagger
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelSetStagger:
                move.b  #4,routine(a0)
                move.l  #AIZMiniS3_ArrivalBarrelArmShotCycle,$34(a0)
                bra.w   AIZMiniS3_LoadBarrelStagger
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelTickStagger:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelArmShotCycle:
                move.l  #AIZMiniS3_ArrivalBarrelBeginShots,$34(a0)

AIZMiniS3_BarrelBeginOpening:
                move.b  #6,routine(a0)
                move.l  #AIZMiniS3_BarrelOpenAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_BarrelAnimatePairs:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelBeginShots:
                move.b  #8,routine(a0)
                move.b  #3,$39(a0)
                move.l  #AIZMiniS3_ArrivalBarrelSelectShot,$34(a0)

AIZMiniS3_ArrivalBarrelSelectShot:
                move.w  #$1C,$2E(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   AIZMiniS3_ArrivalBarrelFireFloorShot
                lea     AIZMiniS3_BurstAndTimedMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Only counter value 1 selects the floor-seeking missile
AIZMiniS3_ArrivalBarrelFireFloorShot:
                lea     AIZMiniS3_BurstAndFloorMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelTickShots:
                jsr     (Obj_Wait).l
                tst.b   $39(a0)
                bmi.s   AIZMiniS3_ArrivalBarrelBeginClosing
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelBeginClosing:
                move.b  #$A,routine(a0)
                move.l  #AIZMiniS3_BarrelCloseAnimation,$30(a0)
                move.l  #AIZMiniS3_ArrivalBarrelSetIdle,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_ArrivalBarrelSetIdle:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_BarrelBurstFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniS3_BarrelBurstStateOffsets(pc,d0.w),d1
                jsr     AIZMiniS3_BarrelBurstStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZMiniS3_BarrelBurstStateOffsets:
                dc.w    AIZMiniS3_InitBarrelBurst-AIZMiniS3_BarrelBurstStateOffsets
                dc.w    AIZMiniS3_BarrelAnimatePairs-AIZMiniS3_BarrelBurstStateOffsets
; ---------------------------------------------------------------------------

AIZMiniS3_InitBarrelBurst:
                lea     AIZMiniS3_BurstAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AIZMiniS3_BurstAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_TimedMissileDispatch:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniS3_TimedMissileStateOffsets(pc,d0.w),d1
                jmp     AIZMiniS3_TimedMissileStateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniS3_TimedMissileStateOffsets:
                dc.w    InitializeAIZMinibossRisingMissile-AIZMiniS3_TimedMissileStateOffsets
                dc.w    AIZMiniS3_TimedMissileMoveAndDraw-AIZMiniS3_TimedMissileStateOffsets
                dc.w    AIZMiniS3_TickCallbackWait-AIZMiniS3_TimedMissileStateOffsets
                dc.w    AIZMiniS3_TimedMissileMoveAndDraw-AIZMiniS3_TimedMissileStateOffsets

; =============== S U B R O U T I N E =======================================

InitializeAIZMinibossRisingMissile:
                lea     AIZMiniS3_MissileAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.l  #AIZMiniS3_MissileLoopAnimation,$30(a0)
                move.l  #AIZMiniS3_TimedMissileBeginApexPause,$34(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$60,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function InitializeAIZMinibossRisingMissile

; ---------------------------------------------------------------------------

AIZMiniS3_TimedMissileMoveAndDraw:
                jsr     (Move_AnimateRaw_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_TimedMissileBeginApexPause:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #AIZMiniS3_TimedMissileBeginDescent,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_TimedMissileBeginDescent:
                move.b  #6,routine(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                move.w  #$80,priority(a0)
                bset    #1,render_flags(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$60,$2E(a0)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a1),d0
                bsr.w   AIZMiniS3_AdvanceDescentLanePattern
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Obj_AIZMiniboss_Flame:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniboss_Flame_Index(pc,d0.w),d1
                jmp     AIZMiniboss_Flame_Index(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniboss_Flame_Index:
                dc.w    InitializeAIZMinibossStaggeredFlame-AIZMiniboss_Flame_Index
                dc.w    AIZMiniS3_TickCallbackWait-AIZMiniboss_Flame_Index
                dc.w    AIZMiniS3_FlameAnimateAndDraw-AIZMiniboss_Flame_Index

; =============== S U B R O U T I N E =======================================

InitializeAIZMinibossStaggeredFlame:
                lea     ObjDat_AIZMiniboss_Flame(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                move.l  #AIZMiniS3_FlameStartAnimation,$34(a0)
                moveq   #6,d1

; Double the subtype-adjusted delay in the low byte before storing the timer word
AIZMiniS3_SetFlameStaggerFromSubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                sub.w   d0,d1
                add.b   d1,d1
                move.w  d1,$2E(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_FlameStartAnimation:
                move.b  #4,routine(a0)
                move.l  #AIZMinibossS3_Flame_HoldFrameDelayStream,$30(a0)
                move.l  #AIZMiniS3_FlameExplodeAndTryTrail,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FlameAnimateAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

; Only the final flame subtype spawns the advancing ground effect
AIZMiniS3_FlameExplodeAndTryTrail:
                move.l  #Map_BossExplosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)
                move.l  #AIZMiniS3_FlameExplosionAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                cmpi.b  #6,subtype(a0)
                bne.w   AIZMiniS3_SharedReturn
                lea     AIZMiniS3_AdvancingFlameChild(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function InitializeAIZMinibossStaggeredFlame

; ---------------------------------------------------------------------------

AIZMiniS3_FlameTrailDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniS3_FlameTrailStateOffsets(pc,d0.w),d1
                jsr     AIZMiniS3_FlameTrailStateOffsets(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZMiniS3_FlameTrailStateOffsets:
                dc.w    AIZMiniS3_InitFlameTrailAtBoss-AIZMiniS3_FlameTrailStateOffsets
                dc.w    AIZMiniS3_FlameTrailAnimateAndStep-AIZMiniS3_FlameTrailStateOffsets
; ---------------------------------------------------------------------------

AIZMiniS3_InitFlameTrailAtBoss:
                bsr.w   InitializeAIZMinibossStaggeredFlame
                move.w  #$100,priority(a0)
                move.l  #AIZMiniS3_AdvancingFlameAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #-$60,d0
                btst    #0,render_flags(a1)
                beq.s   AIZMiniS3_FlameTrailSetInitialX
                neg.w   d0
                bset    #0,render_flags(a0)

AIZMiniS3_FlameTrailSetInitialX:
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

; Use the animation cursor to select the X step only when the decoder returns positive D2
AIZMiniS3_FlameTrailAnimateAndStep:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   AIZMiniS3_FlameTrailUpdateReturn
                bmi.s   AIZMiniS3_FlameTrailUpdateReturn
                move.w  AIZMiniS3_FlameTrailXSteps(pc,d0.w),d0
                btst    #0,render_flags(a0)
                bne.s   AIZMiniS3_FlameTrailApplyXStep
                neg.w   d0

AIZMiniS3_FlameTrailApplyXStep:
                add.w   d0,x_pos(a0)

AIZMiniS3_FlameTrailUpdateReturn:
                rts
; ---------------------------------------------------------------------------
AIZMiniS3_FlameTrailXSteps:
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    8
                dc.w    8

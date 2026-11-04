; Owner: objects/bosses/aiz/sk
; Responsibility: Angel Island miniboss arrival cutscene, fire effects, movement helpers and private scene resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMinibossCutscene:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossCutscene_Index(pc,d0.w),d1
                jsr     AIZMinibossCutscene_Index(pc,d1.w)
                bra.w   AIZMiniSK_CheckHitFlashOrDefeat
; ---------------------------------------------------------------------------
AIZMinibossCutscene_Index:
                dc.w    AIZMiniSK_InitArrivalBoss-AIZMinibossCutscene_Index
                dc.w    AIZMiniSK_WaitForArrivalCamera-AIZMinibossCutscene_Index
                dc.w    AIZMiniSK_TickCallbackWait-AIZMinibossCutscene_Index
                dc.w    AIZMiniSK_DescendAndDraw-AIZMinibossCutscene_Index
                dc.w    AIZMiniSK_SwingMoveAndDraw-AIZMinibossCutscene_Index
; ---------------------------------------------------------------------------

AIZMiniSK_InitArrivalBoss:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$60,collision_property(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jmp     (Load_PLC).l
; ---------------------------------------------------------------------------

AIZMiniSK_WaitForArrivalCamera:
                move.w  (Camera_X_pos).w,d0
                move.w  #$2F10,d5
                cmp.w   d5,d0
                bhs.s   AIZMiniSK_SpawnFlybysAndLoadPalette
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_SpawnFlybysAndLoadPalette:
                move.l  #AIZMiniSK_SpawnBodyAndStartDescent,$34(a0)
                lea     AIZMiniSK_FlybyChildren(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l

AIZMiniSK_LockCameraAndFadeMusic:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.w  d5,(Camera_min_X_pos).w
                move.w  d5,(Camera_max_X_pos).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

AIZMiniSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_TickCallbackWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_SpawnBodyAndStartDescent:
                move.l  #AIZMiniSK_ArmBarrelsAndBeginSwing,$34(a0)
                move.b  #6,routine(a0)
                lea     AIZMiniSK_BodyAndTrimChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     AIZMiniSK_ArrivalBarrelChildren(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

StartAIZMinibossDescentAndMusic:
                move.w  #$100,y_vel(a0)
                move.w  #$AF,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w
                rts
; End of function StartAIZMinibossDescentAndMusic

; ---------------------------------------------------------------------------

AIZMiniSK_DescendAndDraw:
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArmBarrelsAndBeginSwing:
                move.w  #$7F,$2E(a0)
                move.l  #AIZMiniSK_WaitAndSpawnDepartureBlast,$34(a0)
                move.b  #3,$39(a0)
                bset    #1,$38(a0)

AIZMiniSK_BeginVerticalSwing:
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

AIZMiniSK_SwingMoveAndDraw:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------
; unused
                subq.b  #1,$39(a0)
                bpl.s   AIZMiniSK_LegacySpawnArrivalFlames
                move.l  #AIZMiniSK_WaitAndSpawnDepartureBlast,$34(a0)

AIZMiniSK_LegacySpawnArrivalFlames:
                move.w  #$40,$2E(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_WaitAndSpawnDepartureBlast:
                move.w  #$10,$2E(a0)
                move.l  #AIZMiniSK_BeginRightwardDeparture,$34(a0)
                lea     AIZMiniSK_DepartureBlastChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_BeginRightwardDeparture:
                move.l  #AIZMiniSK_MoveAndTickDeparture,(a0)
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                move.b  #$F,collision_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$40,$2E(a0)
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   AIZMiniSK_SetDepartureEventAndCallback
                move.w  #$120,$2E(a0)

AIZMiniSK_SetDepartureEventAndCallback:
                move.l  #Go_Delete_Sprite,$34(a0)
                st      (Events_fg_5).w
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_MoveAndTickDeparture:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   AIZMiniSK_RestoreLevelAndQueueCleanup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_RestoreLevelAndQueueCleanup:
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

AIZMiniSK_InitArrivalRotor:
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     AIZMiniSK_RotorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #AIZMiniSK_RotorLoopAnimation,$30(a0)
                move.l  #AIZMiniSK_RotorFollowAndCheckBossDeath,(a0)
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniSK_RotorFollowAndCheckBossDeath:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   AIZMiniSK_RotorDrawUntilDeparture
                clr.b   collision_flags(a0)

AIZMiniSK_RotorDrawUntilDeparture:
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniSK_InitArrivalTrim:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #AIZMiniSK_TrimFollowUntilDeparture,(a0)
                lea     AIZMiniSK_TrimAttributes(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

AIZMiniSK_TrimFollowUntilDeparture:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelFollowDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniSK_ArrivalBarrelStateOffsets(pc,d0.w),d1
                jsr     AIZMiniSK_ArrivalBarrelStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
AIZMiniSK_ArrivalBarrelStateOffsets:
                dc.w    AIZMiniSK_InitBarrelAttributes-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_ArrivalBarrelWaitRequest-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_ArrivalBarrelTickStagger-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_BarrelAnimatePairs-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_ArrivalBarrelTickShots-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_BarrelAnimatePairs-AIZMiniSK_ArrivalBarrelStateOffsets
                dc.w    AIZMiniSK_SharedReturn-AIZMiniSK_ArrivalBarrelStateOffsets
; ---------------------------------------------------------------------------

AIZMiniSK_InitBarrelAttributes:
                lea     AIZMiniSK_BarrelAttributes(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZMiniSK_ArrivalBarrelSetStagger
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelSetStagger:
                move.b  #4,routine(a0)
                move.l  #AIZMiniSK_ArrivalBarrelArmShotCycle,$34(a0)
                bra.w   AIZMiniSK_LoadBarrelStagger
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelTickStagger:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelArmShotCycle:
                move.l  #AIZMiniSK_ArrivalBarrelBeginShots,$34(a0)

AIZMiniSK_BarrelBeginOpening:
                move.b  #6,routine(a0)
                move.l  #AIZMiniSK_BarrelOpenAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_BarrelAnimatePairs:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelBeginShots:
                move.b  #8,routine(a0)
                move.b  #3,$39(a0)
                move.l  #AIZMiniSK_ArrivalBarrelSelectShot,$34(a0)

AIZMiniSK_ArrivalBarrelSelectShot:
                move.w  #$1C,$2E(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   AIZMiniSK_ArrivalBarrelFireFloorShot
                lea     AIZMiniSK_BurstAndTimedMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Only counter value 1 selects the floor-seeking missile
AIZMiniSK_ArrivalBarrelFireFloorShot:
                lea     AIZMiniSK_BurstAndFloorMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelTickShots:
                jsr     (Obj_Wait).l
                tst.b   $39(a0)
                bmi.s   AIZMiniSK_ArrivalBarrelBeginClosing
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelBeginClosing:
                move.b  #$A,routine(a0)
                move.l  #AIZMiniSK_BarrelCloseAnimation,$30(a0)
                move.l  #AIZMiniSK_ArrivalBarrelSetIdle,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_ArrivalBarrelSetIdle:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_BarrelBurstFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniSK_BarrelBurstStateOffsets(pc,d0.w),d1
                jsr     AIZMiniSK_BarrelBurstStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZMiniSK_BarrelBurstStateOffsets:
                dc.w    AIZMiniSK_InitBarrelBurst-AIZMiniSK_BarrelBurstStateOffsets
                dc.w    AIZMiniSK_BarrelAnimatePairs-AIZMiniSK_BarrelBurstStateOffsets
; ---------------------------------------------------------------------------

AIZMiniSK_InitBarrelBurst:
                lea     AIZMiniSK_BurstAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AIZMiniSK_BurstAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_TimedMissileDispatch:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniSK_TimedMissileStateOffsets(pc,d0.w),d1
                jmp     AIZMiniSK_TimedMissileStateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniSK_TimedMissileStateOffsets:
                dc.w    InitializeAIZMinibossRisingMissile-AIZMiniSK_TimedMissileStateOffsets
                dc.w    AIZMiniSK_TimedMissileMoveAndDraw-AIZMiniSK_TimedMissileStateOffsets
                dc.w    AIZMiniSK_TickCallbackWait-AIZMiniSK_TimedMissileStateOffsets
                dc.w    AIZMiniSK_TimedMissileMoveAndDraw-AIZMiniSK_TimedMissileStateOffsets

; =============== S U B R O U T I N E =======================================

InitializeAIZMinibossRisingMissile:
                lea     AIZMiniSK_MissileAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.l  #AIZMiniSK_MissileLoopAnimation,$30(a0)
                move.l  #AIZMiniSK_TimedMissileBeginApexPause,$34(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$60,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function InitializeAIZMinibossRisingMissile

; ---------------------------------------------------------------------------

AIZMiniSK_TimedMissileMoveAndDraw:
                jsr     (Move_AnimateRaw_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_TimedMissileBeginApexPause:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #AIZMiniSK_TimedMissileBeginDescent,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_TimedMissileBeginDescent:
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
                bsr.w   SelectAIZMinibossMissileDescentLane
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
                dc.w    AIZMiniSK_TickCallbackWait-AIZMiniboss_Flame_Index
                dc.w    AIZMiniSK_FlameAnimateAndDraw-AIZMiniboss_Flame_Index

; =============== S U B R O U T I N E =======================================

InitializeAIZMinibossStaggeredFlame:
                lea     ObjDat_AIZMiniboss_Flame(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                move.l  #AIZMiniSK_FlameStartAnimation,$34(a0)
                moveq   #6,d1

; Double the subtype-adjusted delay in the low byte before storing the timer word
AIZMiniSK_SetFlameStaggerFromSubtype:
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

AIZMiniSK_FlameStartAnimation:
                move.b  #4,routine(a0)
                move.l  #AIZMinibossSK_Flame_HoldFrameDelayStream,$30(a0)
                move.l  #AIZMiniSK_FlameExplodeAndTryTrail,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FlameAnimateAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

; Only the final flame subtype spawns the advancing ground effect
AIZMiniSK_FlameExplodeAndTryTrail:
                move.l  #Map_BossExplosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)
                move.l  #AIZMiniSK_FlameExplosionAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                cmpi.b  #6,subtype(a0)
                bne.w   AIZMiniSK_SharedReturn
                lea     AIZMiniSK_AdvancingFlameChild(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function InitializeAIZMinibossStaggeredFlame

; ---------------------------------------------------------------------------

AIZMiniSK_FlameTrailDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniSK_FlameTrailStateOffsets(pc,d0.w),d1
                jsr     AIZMiniSK_FlameTrailStateOffsets(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZMiniSK_FlameTrailStateOffsets:
                dc.w    AIZMiniSK_InitFlameTrailAtBoss-AIZMiniSK_FlameTrailStateOffsets
                dc.w    AIZMiniSK_FlameTrailAnimateAndStep-AIZMiniSK_FlameTrailStateOffsets
; ---------------------------------------------------------------------------

AIZMiniSK_InitFlameTrailAtBoss:
                bsr.w   InitializeAIZMinibossStaggeredFlame
                move.w  #$100,priority(a0)
                move.l  #AIZMiniSK_AdvancingFlameAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #-$60,d0
                btst    #0,render_flags(a1)
                beq.s   AIZMiniSK_FlameTrailSetInitialX
                neg.w   d0
                bset    #0,render_flags(a0)

AIZMiniSK_FlameTrailSetInitialX:
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

; Use the animation cursor to select the X step only when the decoder returns positive D2
AIZMiniSK_FlameTrailAnimateAndStep:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   AIZMiniSK_FlameTrailUpdateReturn
                bmi.s   AIZMiniSK_FlameTrailUpdateReturn
                move.w  AIZMiniSK_FlameTrailXSteps(pc,d0.w),d0
                btst    #0,render_flags(a0)
                bne.s   AIZMiniSK_FlameTrailApplyXStep
                neg.w   d0

AIZMiniSK_FlameTrailApplyXStep:
                add.w   d0,x_pos(a0)

AIZMiniSK_FlameTrailUpdateReturn:
                rts
; ---------------------------------------------------------------------------
AIZMiniSK_FlameTrailXSteps:
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    8
                dc.w    8

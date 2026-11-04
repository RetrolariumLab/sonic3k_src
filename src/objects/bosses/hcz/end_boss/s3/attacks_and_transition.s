; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss attack actors, movement states, geyser effects and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HCZBossS3_VortexDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossS3_Vortex_ThreeStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossS3_Vortex_ThreeStateOffsets(pc,d1.w)
                bsr.w   MarkHCZBossVortexDetachedWhenColumnDies
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
HCZEndBossS3_Vortex_ThreeStateOffsets:
                dc.w    HCZBossS3_InitColumnVortex-HCZEndBossS3_Vortex_ThreeStateOffsets
                dc.w    HCZBossS3_VortexCaptureAndFollow-HCZEndBossS3_Vortex_ThreeStateOffsets
                dc.w    HCZBossS3_VortexDriftWithColumn-HCZEndBossS3_Vortex_ThreeStateOffsets
; ---------------------------------------------------------------------------

HCZBossS3_InitColumnVortex:
                lea     HCZBossS3_VortexAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossS3_VortexHeight0Anim,$30(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_VortexCaptureAndFollow:
                bsr.w   CaptureBothPlayersInHCZBossVortex
                bsr.w   PullBothPlayersTowardHCZBossVortex
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   HCZBossS3_VortexDetachAndRelease
                rts
; ---------------------------------------------------------------------------

HCZBossS3_VortexDetachAndRelease:
                move.b  #4,routine(a0)
                move.w  x_vel(a1),x_vel(a0)
                bra.w   HCZBossS3_VortexReleaseTrackedP1
; ---------------------------------------------------------------------------

HCZBossS3_VortexDriftWithColumn:
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                move.w  x_vel(a1),x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

HCZBossS3_InitSurfaceEdge:
                lea     HCZBossS3_SurfaceEdgeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossS3_SurfaceEdgeFollowAndAnimate,(a0)
                move.l  #HCZBossS3_SurfaceEdgeAnim,$30(a0)

HCZBossS3_PlaceEdgeAboveWater:
                move.w  (Water_level).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_SurfaceEdgeFollowAndAnimate:
                jsr     (Animate_Raw).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZBossS3_SurfaceEdgeXOffsets(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
HCZBossS3_SurfaceEdgeXOffsets:
                dc.w    -4,     4
; ---------------------------------------------------------------------------

HCZBossS3_InitBombSplashAtWater:
                lea     HCZBossS3_BombSplashAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AnimateRaw_DrawTouch,(a0)
                move.l  #HCZBossS3_BombSplashAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.s   HCZBossS3_PlaceEdgeAboveWater
; ---------------------------------------------------------------------------

HCZBossS3_InitGeyserLayerAndEdges:
                lea     HCZBossS3_GeyserLayerAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #HCZBossS3_GeyserLayerBeginLaunch,$34(a0)
                bsr.w   ConfigureHCZBossGeyserLayerFromSubtype
                tst.b   subtype(a0)
                bne.w   HCZBossS3_SharedReturn
                lea     HCZEndBossS3_Surface_TwoNormalEdgeRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossS3_GeyserLayerBeginLaunch:
                move.l  #HCZBossS3_GeyserLayerLaunchAndDraw,(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_GeyserLayerLaunchAndDraw:
                bsr.w   ApplyHCZBossGeyserToBothPlayers
                jmp     (AnimateRaw_DrawTouch).l
; ---------------------------------------------------------------------------

HCZBossS3_InitRandomColumnBubble:
                lea     HCZEndBossS3_Bubble_FullAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZBossS3_BubbleMoveAnimateAndDraw,(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                swap    d0
                move.w  (Water_level).w,d1
                andi.w  #$1F,d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                move.l  HCZBossS3_BubbleMinibossAnimations(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZBossS3_BubbleFreezeFirstFrame,$34(a0)
                rts
; ---------------------------------------------------------------------------
HCZBossS3_BubbleMinibossAnimations:
                dc.l    HCZMiniS3_ParticleAnimBase0
                dc.l    HCZMiniS3_ParticleAnimBase1
                dc.l    HCZMiniS3_ParticleAnimBase2
                dc.l    HCZMiniS3_ParticleAnimBase3
; ---------------------------------------------------------------------------

HCZBossS3_BubbleMoveAnimateAndDraw:
                movea.w parent3(a0),a3
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZBossS3_BubbleFreezeFirstFrame:
                move.l  #HCZBossS3_BubbleWaitForColumnDrift,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BubbleWaitForColumnDrift:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   HCZBossS3_BubbleBeginFinalAnimation
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZBossS3_BubbleBeginFinalAnimation:
                move.l  #HCZBossS3_BubbleMoveAnimateAndDraw,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossS3_Bomb_SevenStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossS3_Bomb_SevenStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossS3_Bomb_SevenStateOffsets:
                dc.w    HCZBossS3_InitStackBomb-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombFollowAndWaitRequest-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombFollowUntilRequestClears-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombStepOffsetsAndWait-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombCheckWaterEntry-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombFallAndProbeFloor-HCZEndBossS3_Bomb_SevenStateOffsets
                dc.w    HCZBossS3_BombAnimateDetonation-HCZEndBossS3_Bomb_SevenStateOffsets
; ---------------------------------------------------------------------------

HCZBossS3_InitStackBomb:
                lea     HCZEndBossS3_Bomb_PartialAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                bsr.w   SetHCZBossBombStackPriority
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

HCZBossS3_BombFollowAndWaitRequest:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   HCZBossS3_BombArmAndCheckFrontSlot
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombArmAndCheckFrontSlot:
                move.b  #4,routine(a0)
                tst.b   subtype(a0)
                beq.s   HCZBossS3_BombBeginFrontSlide
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombBeginFrontSlide:
                move.b  #6,routine(a0)
                move.w  #3,$2E(a0)
                move.l  #HCZBossS3_BombBeginFallAndClearRequest,$34(a0)
                move.b  #1,$40(a0)
                move.b  #0,$41(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombFollowUntilRequestClears:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   HCZBossS3_BombBeginStackCompaction
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombBeginStackCompaction:
                move.b  #6,routine(a0)
                subq.b  #2,subtype(a0)
                move.w  #7,$2E(a0)
                move.l  #HCZBossS3_BombCompactAndTryReplacement,$34(a0)
                bsr.w   SetHCZBossBombStackPriority
                bra.w   HCZBossS3_BombLoadCompactionSteps
; ---------------------------------------------------------------------------

HCZBossS3_BombStepOffsetsAndWait:
                move.b  $40(a0),d0
                add.b   d0,$42(a0)
                move.b  $41(a0),d0
                add.b   d0,$43(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossS3_BombCompactAndTryReplacement:
                move.b  #2,routine(a0)
                tst.b   subtype(a0)
                bne.s   HCZBossS3_BombReplacementReturn
                lea     HCZBossS3_ReplacementBombChild(pc),a2
                jsr     (CreateChild7_Normal2).l
                bne.s   HCZBossS3_BombReplacementReturn
                move.w  parent3(a0),parent3(a1)
                move.b  #4,subtype(a1)

HCZBossS3_BombReplacementReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombBeginFallAndClearRequest:
                move.b  #8,routine(a0)
                move.l  #HCZBossS3_BombBeginDetonation,$34(a0)
                move.w  #$100,x_vel(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                btst    #0,render_flags(a1)
                beq.s   HCZBossS3_BombLaunchReturn
                neg.w   x_vel(a0)

HCZBossS3_BombLaunchReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombCheckWaterEntry:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                bhs.s   HCZBossS3_BombEnterWaterAndSplash
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombEnterWaterAndSplash:
                move.b  #$A,routine(a0)
                lea     HCZBossS3_BombSplashChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossS3_BombFallAndProbeFloor:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombBeginDetonation:
                move.b  #$C,routine(a0)
                move.l  #HCZBossS3_BombDetonationAnim,$30(a0)
                move.l  #HCZBossS3_BombSpawnGeysersAndExplode,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BombAnimateDetonation:
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

HCZBossS3_BombSpawnGeysersAndExplode:
                lea     HCZBossS3_BombGeyserChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     HCZBossS3_ExplosionChild(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_InitFixedPlate:
                lea     HCZBossS3_FixedPlateAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossS3_FixedPlateFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_FixedPlateFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

HCZBossS3_InitExplosion:
                lea     HCZBossS3_ExplosionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZBossS3_ExplosionAnimateAndCheckTouch,(a0)
                move.l  #HCZEndBossS3_Explosion_UniformRawStream,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

; Submit collision only while the mapping frame is below 3
HCZBossS3_ExplosionAnimateAndCheckTouch:
                jsr     (Animate_Raw).l
                cmpi.b  #3,mapping_frame(a0)
                bhs.s   HCZBossS3_ExplosionDraw
                jsr     (Add_SpriteToCollisionResponseList).l

HCZBossS3_ExplosionDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_ExitQueueGeyserArt:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZCutsceneGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #HCZBossS3_ExitWaitForArtModules,(a0)

HCZBossS3_ExitWaitForArtModules:
                tst.b   (Kos_modules_left).w
                bne.w   HCZBossS3_SharedReturn
                move.l  #HCZBossS3_ExitTickRumbleWait,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #HCZBossS3_ExitInstallGeyserInitializer,$34(a0)
                st      (Screen_shake_flag).w
                rts
; ---------------------------------------------------------------------------

HCZBossS3_ExitTickRumbleWait:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   HCZEndBossS3_Exit_TickRumbleWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

HCZEndBossS3_Exit_TickRumbleWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossS3_ExitInstallGeyserInitializer:
                move.l  #HCZBossS3_InitExitGeyserAtP1,(a0)

HCZBossS3_InitExitGeyserAtP1:
                lea     HCZBossS3_ExitGeyserAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                st      (Screen_shake_flag).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$130,d1
                move.w  d1,y_pos(a0)
                clr.w   $44(a0)
                lea     (Player_2).w,a1
                addi.w  #$30,d0
                sub.w   x_pos(a1),d0
                cmpi.w  #$60,d0
                bcc.s   HCZBossS3_ExitGeyserBeginRiseAndPalette
                move.w  a1,$44(a0)

HCZBossS3_ExitGeyserBeginRiseAndPalette:
                jsr     (SpawnS3HCZExitGeyserEightDebrisPieces).l
                move.l  #HCZBossS3_ExitRiseToCaptureHeight,(a0)
                st      (Palette_cycle_counters+$00).w

HCZBossS3_ExitRiseToCaptureHeight:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                subq.w  #6,d0
                move.w  d0,y_pos(a0)
                subi.w  #$60,d0
                cmp.w   y_pos(a1),d0
                bhs.s   HCZBossS3_ExitLiftP2AndDraw
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                move.l  #HCZBossS3_ExitLiftP1AndTickLevelWait,(a0)
                move.w  #$5F,$2E(a0)

HCZBossS3_ExitLiftP2AndDraw:
                bsr.w   S3HCZGeyser_CaptureAndLiftP2
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_ExitLiftP1AndTickLevelWait:
                lea     (Player_1).w,a1
                move.b  #$1A,anim(a1)
                subq.w  #6,y_pos(a0)
                subq.w  #6,(Player_1+y_pos).w
                bsr.w   S3HCZGeyser_CaptureAndLiftP2
                subq.w  #1,$2E(a0)
                bmi.s   HCZBossS3_StartMarbleGardenAndDelete
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_StartMarbleGardenAndDelete:
                move.w  #$200,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l

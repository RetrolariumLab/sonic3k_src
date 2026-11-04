; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss attack actors, movement states, geyser effects and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HCZBossSK_VortexDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossSK_Vortex_ThreeStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossSK_Vortex_ThreeStateOffsets(pc,d1.w)
                bsr.w   MarkHCZBossVortexDetachedWhenColumnDies
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
HCZEndBossSK_Vortex_ThreeStateOffsets:
                dc.w    HCZBossSK_InitColumnVortex-HCZEndBossSK_Vortex_ThreeStateOffsets
                dc.w    HCZBossSK_VortexCaptureAndFollow-HCZEndBossSK_Vortex_ThreeStateOffsets
                dc.w    HCZBossSK_VortexDriftWithColumn-HCZEndBossSK_Vortex_ThreeStateOffsets
; ---------------------------------------------------------------------------

HCZBossSK_InitColumnVortex:
                lea     HCZBossSK_VortexAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossSK_VortexHeight0Anim,$30(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_VortexCaptureAndFollow:
                bsr.w   CaptureBothPlayersInHCZBossVortex
                bsr.w   PullBothPlayersTowardHCZBossVortex
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   HCZBossSK_VortexDetachAndRelease
                rts
; ---------------------------------------------------------------------------

HCZBossSK_VortexDetachAndRelease:
                move.b  #4,routine(a0)
                move.w  x_vel(a1),x_vel(a0)
                bra.w   HCZBossSK_VortexReleaseTrackedP1
; ---------------------------------------------------------------------------

HCZBossSK_VortexDriftWithColumn:
                bsr.w   SynchronizeHCZBossVortexHeightVisual
                move.w  x_vel(a1),x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

HCZBossSK_InitSurfaceEdge:
                lea     HCZBossSK_SurfaceEdgeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossSK_SurfaceEdgeFollowAndAnimate,(a0)
                move.l  #HCZBossSK_SurfaceEdgeAnim,$30(a0)

HCZBossSK_PlaceEdgeAboveWater:
                move.w  (Water_level).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_SurfaceEdgeFollowAndAnimate:
                jsr     (Animate_Raw).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZBossSK_SurfaceEdgeXOffsets(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
HCZBossSK_SurfaceEdgeXOffsets:
                dc.w    -4,     4
; ---------------------------------------------------------------------------

HCZBossSK_InitBombSplashAtWater:
                lea     HCZBossSK_BombSplashAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AnimateRaw_DrawTouch,(a0)
                move.l  #HCZBossSK_BombSplashAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bra.s   HCZBossSK_PlaceEdgeAboveWater
; ---------------------------------------------------------------------------

HCZBossSK_InitGeyserLayerAndEdges:
                lea     HCZBossSK_GeyserLayerAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #HCZBossSK_GeyserLayerBeginLaunch,$34(a0)
                bsr.w   ConfigureHCZBossGeyserLayerFromSubtype
                tst.b   subtype(a0)
                bne.w   HCZBossSK_SharedReturn
                lea     HCZEndBossSK_Surface_TwoNormalEdgeRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossSK_GeyserLayerBeginLaunch:
                move.l  #HCZBossSK_GeyserLayerLaunchAndDraw,(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_GeyserLayerLaunchAndDraw:
                bsr.w   ApplyHCZBossGeyserToBothPlayers
                jmp     (AnimateRaw_DrawTouch).l
; ---------------------------------------------------------------------------

HCZBossSK_InitRandomColumnBubble:
                lea     HCZEndBossSK_Bubble_FullAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZBossSK_BubbleMoveAnimateAndDraw,(a0)
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
                move.l  HCZBossSK_BubbleMinibossAnimations(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZBossSK_BubbleFreezeFirstFrame,$34(a0)
                rts
; ---------------------------------------------------------------------------
HCZBossSK_BubbleMinibossAnimations:
                dc.l    HCZMiniSK_ParticleAnimBase0
                dc.l    HCZMiniSK_ParticleAnimBase1
                dc.l    HCZMiniSK_ParticleAnimBase2
                dc.l    HCZMiniSK_ParticleAnimBase3
; ---------------------------------------------------------------------------

HCZBossSK_BubbleMoveAnimateAndDraw:
                movea.w parent3(a0),a3
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZBossSK_BubbleFreezeFirstFrame:
                move.l  #HCZBossSK_BubbleWaitForColumnDrift,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BubbleWaitForColumnDrift:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   HCZBossSK_BubbleBeginFinalAnimation
                bsr.w   AccelerateHCZBossBubbleTowardParentX
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

HCZBossSK_BubbleBeginFinalAnimation:
                move.l  #HCZBossSK_BubbleMoveAnimateAndDraw,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossSK_Bomb_SevenStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossSK_Bomb_SevenStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossSK_Bomb_SevenStateOffsets:
                dc.w    HCZBossSK_InitStackBomb-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombFollowAndWaitRequest-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombFollowUntilRequestClears-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombStepOffsetsAndWait-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombCheckWaterEntry-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombFallAndProbeFloor-HCZEndBossSK_Bomb_SevenStateOffsets
                dc.w    HCZBossSK_BombAnimateDetonation-HCZEndBossSK_Bomb_SevenStateOffsets
; ---------------------------------------------------------------------------

HCZBossSK_InitStackBomb:
                lea     HCZEndBossSK_Bomb_PartialAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                bsr.w   SetHCZBossBombStackPriority
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

HCZBossSK_BombFollowAndWaitRequest:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   HCZBossSK_BombArmAndCheckFrontSlot
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombArmAndCheckFrontSlot:
                move.b  #4,routine(a0)
                tst.b   subtype(a0)
                beq.s   HCZBossSK_BombBeginFrontSlide
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombBeginFrontSlide:
                move.b  #6,routine(a0)
                move.w  #3,$2E(a0)
                move.l  #HCZBossSK_BombBeginFallAndClearRequest,$34(a0)
                move.b  #1,$40(a0)
                move.b  #0,$41(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombFollowUntilRequestClears:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   HCZBossSK_BombBeginStackCompaction
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombBeginStackCompaction:
                move.b  #6,routine(a0)
                subq.b  #2,subtype(a0)
                move.w  #7,$2E(a0)
                move.l  #HCZBossSK_BombCompactAndTryReplacement,$34(a0)
                bsr.w   SetHCZBossBombStackPriority
                bra.w   HCZBossSK_BombLoadCompactionSteps
; ---------------------------------------------------------------------------

HCZBossSK_BombStepOffsetsAndWait:
                move.b  $40(a0),d0
                add.b   d0,$42(a0)
                move.b  $41(a0),d0
                add.b   d0,$43(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossSK_BombCompactAndTryReplacement:
                move.b  #2,routine(a0)
                tst.b   subtype(a0)
                bne.s   HCZBossSK_BombReplacementReturn
                lea     HCZBossSK_ReplacementBombChild(pc),a2
                jsr     (CreateChild7_Normal2).l
                bne.s   HCZBossSK_BombReplacementReturn
                move.w  parent3(a0),parent3(a1)
                move.b  #4,subtype(a1)

HCZBossSK_BombReplacementReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombBeginFallAndClearRequest:
                move.b  #8,routine(a0)
                move.l  #HCZBossSK_BombBeginDetonation,$34(a0)
                move.w  #$100,x_vel(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                btst    #0,render_flags(a1)
                beq.s   HCZBossSK_BombLaunchReturn
                neg.w   x_vel(a0)

HCZBossSK_BombLaunchReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombCheckWaterEntry:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                bhs.s   HCZBossSK_BombEnterWaterAndSplash
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombEnterWaterAndSplash:
                move.b  #$A,routine(a0)
                lea     HCZBossSK_BombSplashChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossSK_BombFallAndProbeFloor:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjHitFloor_DoRoutine).l
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombBeginDetonation:
                move.b  #$C,routine(a0)
                move.l  #HCZBossSK_BombDetonationAnim,$30(a0)
                move.l  #HCZBossSK_BombSpawnGeysersAndExplode,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BombAnimateDetonation:
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

HCZBossSK_BombSpawnGeysersAndExplode:
                lea     HCZBossSK_BombGeyserChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     HCZBossSK_ExplosionChild(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

HCZBossSK_InitFixedPlate:
                lea     HCZBossSK_FixedPlateAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HCZBossSK_FixedPlateFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_FixedPlateFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

HCZBossSK_InitExplosion:
                lea     HCZBossSK_ExplosionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZBossSK_ExplosionAnimateAndCheckTouch,(a0)
                move.l  #HCZEndBossSK_Explosion_UniformRawStream,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

; Submit collision only while the mapping frame is below 3
HCZBossSK_ExplosionAnimateAndCheckTouch:
                jsr     (Animate_Raw).l
                cmpi.b  #3,mapping_frame(a0)
                bhs.s   HCZBossSK_ExplosionDraw
                jsr     (Add_SpriteToCollisionResponseList).l

HCZBossSK_ExplosionDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossSK_ExitQueueArtAndRumble:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZCutsceneGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #HCZBossSK_ExitBeginRumble,(a0)

HCZBossSK_ExitBeginRumble:
                move.l  #HCZBossSK_ExitTickRumbleWait,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #HCZBossSK_ExitTrySecondGeyser,$34(a0)
                st      (Screen_shake_flag).w
                rts
; ---------------------------------------------------------------------------

HCZBossSK_ExitTickRumbleWait:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   HCZEndBossSK_Exit_TickRumbleWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

HCZEndBossSK_Exit_TickRumbleWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossSK_ExitTrySecondGeyser:
                jsr     (AllocateObject).l
                bne.s   HCZBossSK_ExitInstallGeyserInitializer
                move.l  #HCZBossSK_ExitDelaySecondGeyser,(a1)
                st      subtype(a1)
                move.w  #4,$2E(a1)

HCZBossSK_ExitInstallGeyserInitializer:
                lea     HCZBossSK_InitExitGeyserAndChoosePlayer(pc),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

HCZBossSK_ExitDelaySecondGeyser:
                subq.w  #1,$2E(a0)
                bpl.w   HCZBossSK_SharedReturn
                move.l  #HCZBossSK_InitExitGeyserAndChoosePlayer,(a0)

HCZBossSK_InitExitGeyserAndChoosePlayer:
                lea     HCZBossSK_ExitGeyserAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HCZBossSK_ExitRiseToCaptureHeight,(a0)
                tst.b   subtype(a0)
                bne.s   HCZBossSK_ExitGeyserSelectP2
                st      (Palette_cycle_counters+$00).w
                st      (Screen_shake_flag).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                bra.w   HCZBossSK_ExitGeyserBindPlayerAndDebris
; ---------------------------------------------------------------------------

HCZBossSK_ExitGeyserSelectP2:
                lea     (Player_2).w,a1

HCZBossSK_ExitGeyserBindPlayerAndDebris:
                move.w  a1,$44(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$130,d1
                move.w  d1,y_pos(a0)
                jmp     (HCZBossSK_ExitDebrisInitEightPieces).l
; ---------------------------------------------------------------------------

HCZBossSK_ExitRiseToCaptureHeight:
                movea.w $44(a0),a1
                move.w  y_pos(a0),d0
                subq.w  #6,d0
                move.w  d0,y_pos(a0)
                subi.w  #$60,d0
                cmp.w   y_pos(a1),d0
                bhs.s   HCZBossSK_ExitUpdatePrimaryPalette
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                move.l  #HCZBossSK_ExitLiftPlayerAndTick,(a0)
                move.w  #$5F,$2E(a0)

HCZBossSK_ExitUpdatePrimaryPalette:
                tst.b   subtype(a0)
                bne.s   HCZBossSK_ExitGeyserDraw
                move.l  a0,-(sp)
                jsr     (AnPal_HCZ1).l
                movea.l (sp)+,a0

HCZBossSK_ExitGeyserDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Only the primary geyser counts down to the Marble Garden transition
HCZBossSK_ExitLiftPlayerAndTick:
                movea.w $44(a0),a1
                subq.w  #6,y_pos(a0)
                subq.w  #6,y_pos(a1)
                tst.b   subtype(a0)
                bne.s   HCZBossSK_ExitGeyserDraw
                subq.w  #1,$2E(a0)
                bpl.s   HCZBossSK_ExitUpdatePrimaryPalette
                move.w  #$200,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l

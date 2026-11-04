; Owner: objects/cutscenes/sk
; Responsibility: Standalone Knuckles opening sequence, skip input and startup scene actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_SKIntro:
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   CutsceneKnux_Delete
                tst.b   (Last_star_post_hit).w
                bne.w   CutsceneKnux_Delete
                tst.w   (SK_alone_flag).w
                beq.w   CutsceneKnux_Delete
                move.l  #KnuxOpening_DispatchLoadArtAndDraw,(a0)

KnuxOpening_DispatchLoadArtAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  KnuxOpening_RoutineOffsets(pc,d0.w),d1
                jsr     KnuxOpening_RoutineOffsets(pc,d1.w)
                move.w  $42(a0),d0
                move.w  KnuxOpening_GraphicsOffsets(pc,d0.w),d0
                jsr     KnuxOpening_GraphicsOffsets(pc,d0.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
KnuxOpening_RoutineOffsets:
                dc.w    KnuxOpening_InitStandaloneAndTrySkip-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_WaitForImpactOrSpawnTimer-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_AnimateUntilExplosion-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_DriftUntilPaletteReady-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_FallAndSetLandingCallback-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_AnimateLanding-KnuxOpening_RoutineOffsets
                dc.w    KnuxOpening_AccelerateExitTo400-KnuxOpening_RoutineOffsets
KnuxOpening_GraphicsOffsets:
                dc.w    KnuxOpening_SelectLyingMapAndArt-KnuxOpening_GraphicsOffsets
                dc.w    KnuxOpening_SelectNormalMapAndArt-KnuxOpening_GraphicsOffsets
                dc.w    KnuxOpening_SelectGrabMapAndArt-KnuxOpening_GraphicsOffsets
; ---------------------------------------------------------------------------

KnuxOpening_SelectLyingMapAndArt:
                move.l  #Map_KnuxIntroLay,mappings(a0)
                lea     DPLCPtr_KnuxIntroLay(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

KnuxOpening_SelectNormalMapAndArt:
                move.l  #Map_Knuckles,mappings(a0)
                bra.w   SKScene_LoadKnuxArtToP2Tiles
; ---------------------------------------------------------------------------

KnuxOpening_SelectGrabMapAndArt:
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                lea     DPLCPtr_HPZKnucklesGrab(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

KnuxOpening_InitStandaloneAndTrySkip:
                lea     ObjSlot_KnuxIntroLay(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$EF,$2E(a0)
                move.b  #$83,(Player_1+object_control).w
                move.w  #$560,(Camera_X_pos).w
                move.w  #$948,(Camera_Y_pos).w
                st      (Scroll_lock).w
                move.l  (V_int_run_count).w,(RNG_seed).w
                clr.b   (Level_started_flag).w
                jsr     (AllocateObject).l
                bne.s   KnuxOpening_TryAnimalsAndPrepBombColors
                move.l  #Obj_SkipIntro,(a1)

KnuxOpening_TryAnimalsAndPrepBombColors:
                lea     SKOpeningCutscene_EightAnimalSpawnList(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     (Pal_SKIntroBomb).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

KnuxOpening_CopyBombPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,KnuxOpening_CopyBombPalette
                rts
; ---------------------------------------------------------------------------

KnuxOpening_WaitForImpactOrSpawnTimer:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                bne.s   KnuxOpening_BeginImpactReaction
                subq.w  #1,$2E(a0)
                bne.s   KnuxOpening_AnimateIdleAfterBombAttempt
                jsr     (AllocateObject).l
                bne.s   KnuxOpening_AnimateIdleAfterBombAttempt
                move.l  #KnuxOpening_InitFallingBombAndArt,(a1)

KnuxOpening_AnimateIdleAfterBombAttempt:
                lea     SKSceneAnim_OpeningLyingFrames0And1(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

KnuxOpening_BeginImpactReaction:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                lea     SKSceneAnim_OpeningLyingFrames423(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

KnuxOpening_AnimateUntilExplosion:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                bne.s   KnuxOpening_SetNormalArtAndDrift
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

KnuxOpening_SetNormalArtAndDrift:
                move.b  #6,routine(a0)
                move.w  #2,$42(a0)
                move.b  #$8D,mapping_frame(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #-$100,y_vel(a0)

KnuxOpening_DriftUntilPaletteReady:
                btst    #2,(SceneSyncFlagsOrMHZState).w
                bne.s   KnuxOpening_SetGrabArtAndStartFall
                addi.w  #8,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

KnuxOpening_SetGrabArtAndStartFall:
                move.b  #8,routine(a0)
                move.w  #4,$42(a0)
                move.b  #3,mapping_frame(a0)
                subq.w  #8,y_pos(a0)
                move.b  #$13,y_radius(a0)
                move.w  #-$100,x_vel(a0)
                clr.w   y_vel(a0)

KnuxOpening_FallAndSetLandingCallback:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SKAIZScene_SharedSceneReturn
                add.w   d1,y_pos(a0)
                move.b  #$A,routine(a0)
                move.l  #KnuxOpening_RestoreArtAndBeginExitRun,$34(a0)
                lea     SKSceneAnim_OpeningGrabFrames3To10(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

KnuxOpening_AnimateLanding:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

KnuxOpening_RestoreArtAndBeginExitRun:
                move.b  #$C,routine(a0)
                move.w  #2,$42(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     SKKnucklesCutscene_SharedTravelBodyLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

KnuxOpening_AccelerateExitTo400:
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$400,d0
                bhi.s   KnuxOpening_MoveAndCheckRightCameraExit
                move.w  d0,x_vel(a0)

KnuxOpening_MoveAndCheckRightCameraExit:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawCheckResult).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                bhs.w   SKAIZScene_SharedSceneReturn

KnuxOpening_SaveCheckpointAndRestartMHZ:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$6F4,(Saved_X_pos).w
                move.w  #$9EC,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                clr.l   (Saved_timer).w
                move.w  #$700,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  #1,(Restart_level_flag).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_SkipIntro:
                btst    #button_start,(Ctrl_1_pressed).w
                bne.s   KnuxOpening_SaveCheckpointAndRestartMHZ
                btst    #button_start,(Ctrl_2_pressed).w
                bne.s   KnuxOpening_SaveCheckpointAndRestartMHZ
                rts
; ---------------------------------------------------------------------------

KnuxOpening_SelectAnimalPosAndBounds:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  KnuxOpening_AnimalInitialXTable(pc,d0.w),x_pos(a0)
                move.w  #$9F4,y_pos(a0)
                moveq   #0,d1
                cmpi.w  #8,d0
                blo.s   KnuxOpening_LoadBoundsAndSelectAnimal
                moveq   #4,d1

KnuxOpening_LoadBoundsAndSelectAnimal:
                move.l  KnuxOpening_AnimalHorizontalBounds(pc,d1.w),$3A(a0)
                lea     KnuxOpening_AnimalProfileRecords(pc),a1
                move.b  #$C,y_radius(a0)
                andi.w  #2,d0
                beq.s   KnuxOpening_InstallAnimalCodeAndArt
                adda.w  #$A,a1
                move.b  #$A,y_radius(a0)

KnuxOpening_InstallAnimalCodeAndArt:
                move.l  (a1)+,(a0)
                move.l  (a1)+,mappings(a0)
                move.w  (a1)+,art_tile(a0)
                bset    #2,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                rts
; ---------------------------------------------------------------------------
KnuxOpening_AnimalInitialXTable:
                dc.w    $5F0
                dc.w    $600
                dc.w    $610
                dc.w    $620
                dc.w    $660
                dc.w    $670
                dc.w    $680
                dc.w    $690
KnuxOpening_AnimalHorizontalBounds:
                dc.w    $5E8
                dc.w    $628
                dc.w    $658
                dc.w    $698
KnuxOpening_AnimalProfileRecords:
                dc.l    KnuxOpening_BounceGravityAnimalAndFrame
                dc.l    Map_Animals2
                dc.w    make_art_tile(ArtTile_Animals1,0,0)
                dc.l    KnuxOpening_BounceLightAnimal
                dc.l    Map_Animals1
                dc.w    make_art_tile(ArtTile_Animals2,0,0)
; ---------------------------------------------------------------------------

KnuxOpening_BounceGravityAnimalAndFrame:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   KnuxOpening_DrawGravityAnimal
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   KnuxOpening_DrawGravityAnimal
                add.w   d1,y_pos(a0)
                bsr.w   OpeningAnimal_ChooseBounceVel

KnuxOpening_DrawGravityAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_BounceLightAnimal:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   KnuxOpening_TickLightAnimalFrame
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   KnuxOpening_TickLightAnimalFrame
                add.w   d1,y_pos(a0)
                bsr.w   OpeningAnimal_ChooseBounceVel

KnuxOpening_TickLightAnimalFrame:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   KnuxOpening_DrawLightAnimal
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

KnuxOpening_DrawLightAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_InitFallingBombAndArt:
                lea     SKOpeningCutscene_BombAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #KnuxOpening_BounceVisibleBombAndArm,(a0)
                move.b  #$10,y_radius(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     SKOpeningBomb_FlameChildSpawnList(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (ArtKosM_KnuxIntroBomb).l,a1
                move.w  #tiles_to_bytes(ArtTile_KnuxIntroBomb),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

KnuxOpening_BounceVisibleBombAndArm:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   KnuxOpening_DrawBombAfterBounceCheck
                tst.w   y_vel(a0)
                bmi.s   KnuxOpening_DrawBombAfterBounceCheck
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   KnuxOpening_DrawBombAfterBounceCheck
                add.w   d1,y_pos(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                cmpi.w  #-$100,d0
                blt.s   KnuxOpening_DrawBombAfterBounceCheck
                move.l  #KnuxOpening_TickBombAndBeginExplosion,(a0)
                move.w  #(2*60)-1,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

KnuxOpening_DrawBombAfterBounceCheck:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_TickBombAndBeginExplosion:
                subq.w  #1,$2E(a0)
                bpl.s   KnuxOpening_DrawBombDuringCountdown
                move.l  #KnuxOpening_WaitForFlashAndSignalRelease,(a0)
                bset    #7,status(a0)
                bset    #1,(SceneSyncFlagsOrMHZState).w
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

KnuxOpening_CopyFlashPaletteAndTryActor:
                move.l  (a1)+,(a2)+
                dbf     d6,KnuxOpening_CopyFlashPaletteAndTryActor
                jsr     (AllocateObject).l
                bne.s   KnuxOpening_DrawBombDuringCountdown
                move.w  a1,$44(a0)
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  #7,$3A(a1)
                st      subtype(a1)
                lea     SKSceneData_OpeningBombExplosionChildren(pc),a2
                jsr     (CreateChild6_Simple).l

KnuxOpening_DrawBombDuringCountdown:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; The flash handle is dereferenced without checking for zero
KnuxOpening_WaitForFlashAndSignalRelease:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                beq.w   SKAIZScene_SharedSceneReturn
                bset    #2,(SceneSyncFlagsOrMHZState).w
                jsr     (AllocateObject).l
                bne.s   KnuxOpening_PrepSSZReleasePalette
                move.l  #KnuxOpening_InitEggRoboExitAndArt,(a1)

KnuxOpening_PrepSSZReleasePalette:
                lea     (Pal_SSZ1).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

KnuxOpening_CopyPaletteAndDeleteBomb:
                move.l  (a1)+,(a2)+
                dbf     d6,KnuxOpening_CopyPaletteAndDeleteBomb
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_InitAttachedBombFlame:
                move.l  #KnuxOpening_FollowBombAndTrySmoke,(a0)
                lea     SKOpeningBomb_FlamePartialAttributes(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

KnuxOpening_FollowBombAndTrySmoke:
                lea     SKOpeningBomb_FlameFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   KnuxOpening_DrawFlameIfParentActive
                lea     SKOpeningBomb_EmittedSmokeSpawnList(pc),a2
                jsr     (CreateChild6_Simple).l

KnuxOpening_DrawFlameIfParentActive:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_InitSmokeDrift:
                lea     SKOpeningBomb_SmokePartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #KnuxOpening_MoveSmokeAndAnimate,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                subi.w  #$3F,d0
                move.w  d0,x_vel(a0)
                move.w  #-$100,y_vel(a0)

KnuxOpening_MoveSmokeAndAnimate:
                jsr     (MoveSprite2).l
                lea     SKOpeningBomb_EmittedSmokeFrameSequence(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_InitDelayedExplosion:
                lea     (ObjDat_BossExplosion1).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     KnuxOpening_ExplosionOffsetPairs(pc,d0.w),a1
                lsr.w   #1,d0
                move.w  d0,$2E(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                lea     (KnuxOpening_TickDelayThenRunExplosion).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------
KnuxOpening_ExplosionOffsetPairs:
                dc.b    0,   0
                dc.b    8,  -8
                dc.b    -6, -$C
                dc.b    -$A,   4
                dc.b    8,  $A
                dc.b    0, $18
                dc.b    8,-$18
                dc.b    -$C,-$20
                dc.b    -$16,  -4
                dc.b    $18,   0
                even
; ---------------------------------------------------------------------------

KnuxOpening_TickDelayThenRunExplosion:
                subq.w  #1,$2E(a0)
                bpl.w   SKAIZScene_SharedSceneReturn
                lea     (Obj_BossExplosionAnim).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

KnuxOpening_InitEggRoboExitAndArt:
                lea     (EggRoboSK_Hover_FullAttributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #KnuxOpening_MoveEggRoboPastCameraY,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                lea     (SKEggRobo_HoverAttachmentChildren).l,a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EggRoboBadnik).l,a1
                move.w  #tiles_to_bytes(ArtTile_EggRoboBadnik),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

KnuxOpening_MoveEggRoboPastCameraY:
                addq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bge.s   KnuxOpening_DrawEggRoboParityFrame
                move.l  #KnuxOpening_SetEggRoboXSpeedAtZero,(a0)
                move.w  #$7F,$2E(a0)
                jsr     (Swing_Setup1).l

KnuxOpening_DrawEggRoboParityFrame:
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

KnuxOpening_SetEggRoboXSpeedAtZero:
                subq.w  #1,$2E(a0)
                bne.s   KnuxOpening_SwingMoveAndCullEggRobo
                move.w  #$400,x_vel(a0)

KnuxOpening_SwingMoveAndCullEggRobo:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Sprite_CheckDelete).l
; End of function KnuxOpening_SelectAnimalPosAndBounds

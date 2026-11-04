; Owner: objects/bosses/lrz/miniboss/sk
; Responsibility: Lava Reef miniboss startup, battle controller, attack state and attached actor updates
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZMiniboss:
                lea     LRZMiniboss_CameraTriggerBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #LRZMini_TickCameraMusicTransition,(a0)
                move.l  #LRZMini_InstallBattleAndPalette,$34(a0)
                lea     LRZMiniboss_CameraTargetBounds(pc),a1
                move.b  #mus_Miniboss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                lea     Pal_LRZMiniboss1(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

LRZMini_TickCameraMusicTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

LRZMini_InstallBattleAndPalette:
                move.l  #LRZMinibossRoot_DispatchStateAndDraw,(a0)
                lea     Pal_LRZMiniboss2(pc),a1
                bsr.w   CopyLRZMinibossPaletteLinesThreeAndFour

LRZMini_SharedReturn:
                rts
; ---------------------------------------------------------------------------

LRZMinibossRoot_DispatchStateAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LRZMinibossRoot_StateOffsets(pc,d0.w),d1
                jsr     LRZMinibossRoot_StateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LRZMinibossRoot_StateOffsets:
                dc.w    LRZMini_InitBodyAndArmChains-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_WaitNemesisThenQueueArt-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_EnableArmRise-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_TickPhaseWait-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_TickPhaseWait-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_RiseAndTrackPlayer-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_HoverTrackAndWait-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_TickPhaseWait-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_StepSlamAndSubmitTouch-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_ImpactSolidHitAndWait-LRZMinibossRoot_StateOffsets
                dc.w    LRZMini_AnimateRetractAndCheckHit-LRZMinibossRoot_StateOffsets
; ---------------------------------------------------------------------------

LRZMini_InitBodyAndArmChains:
                lea     ObjDat_LRZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.w  #$7A8,(SceneMinimumYOrEmeraldSelectionBytes).w
                move.w  y_pos(a0),(SceneMaximumYOrEmeraldSelectionTail).w
                lea     LRZMinibossLeftArm_TwelveLinkTreeRecord(pc),a2
                jsr     (CreateChild8_TreeListRepeated).l
                lea     LRZMinibossRightArm_TwelveLinkTreeRecord(pc),a2
                jmp     (CreateChild8_TreeListRepeated).l
; ---------------------------------------------------------------------------

LRZMini_WaitNemesisThenQueueArt:
                tst.l   (Nem_decomp_queue).w
                bne.w   LRZMini_SharedReturn
                move.b  #4,routine(a0)
                move.w  #$2F,$2E(a0)
                lea     (ArtKosM_LRZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

LRZMini_EnableArmRise:
                subq.w  #1,$2E(a0)
                bpl.s   LRZMini_ArmRiseDelayReturn
                move.b  #6,routine(a0)
                bset    #3,$38(a0)
                move.w  #$15F,$2E(a0)
                move.l  #LRZMinibossRoot_RequestArmReturnAndWait,$34(a0)

LRZMini_ArmRiseDelayReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_TickPhaseWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZMinibossRoot_RequestArmReturnAndWait:
                move.b  #8,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$4F,$2E(a0)
                move.l  #LRZMini_BeginUpwardTracking,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_BeginUpwardTracking:
                move.b  #$A,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_BossHand),d0
                jsr     (Play_SFX).l
                lea     LRZMinibossRoot_RiseFrameDelayLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

LRZMini_RiseAndTrackPlayer:
                jsr     (Animate_RawMultiDelay).l
                bsr.w   LRZMini_RetargetXVelEvery16
                jsr     (MoveSprite2).l
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                cmp.w   y_pos(a0),d0
                blo.w   LRZMini_SharedReturn
                move.w  d0,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #LRZMini_BeginPreSlamPause,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

LRZMini_HoverTrackAndWait:
                jsr     (Swing_UpAndDown).l
                bsr.w   LRZMini_RetargetXVelEvery16
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l

; =============== S U B R O U T I N E =======================================

; Pursue Player 1 outside an eight-pixel dead zone
LRZMini_RetargetXVelEvery16:
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$F,d0
                bne.s   LRZMini_TrackingUpdateReturn
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                clr.w   x_vel(a0)
                cmpi.w  #8,d2
                bls.s   LRZMini_TrackingUpdateReturn
                move.w  LRZMini_TrackingSideSpeeds(pc,d0.w),x_vel(a0)

LRZMini_TrackingUpdateReturn:
                rts
; End of function LRZMini_RetargetXVelEvery16

; ---------------------------------------------------------------------------
LRZMini_TrackingSideSpeeds:
                dc.w    -$200,  $200
; ---------------------------------------------------------------------------

LRZMini_BeginPreSlamPause:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LRZMini_EnableSlamAndAnimate,$34(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_EnableSlamAndAnimate:
                move.b  #$10,routine(a0)
                move.b  #$B5,collision_flags(a0)
                move.l  #LRZMini_BeginSolidImpactHold,$34(a0)
                lea     LRZMini_SlamImpactAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

LRZMini_StepSlamAndSubmitTouch:
                addq.w  #4,y_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

LRZMini_BeginSolidImpactHold:
                move.b  #$12,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.b  #6,collision_flags(a0)
                move.w  #$5F,$2E(a0)
                move.l  #LRZMini_RetractAndReleaseRiders,$34(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

LRZMini_ImpactSolidHitAndWait:
                moveq   #$33,d1
                moveq   #4,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.w   LRZMini_HandleHitFlashOrDefeat
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZMini_RetractAndReleaseRiders:
                move.b  #$14,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #LRZMini_ReloadArmCycleByDefeatFlags,$34(a0)
                clr.w   x_vel(a0)
                move.w  #$400,y_vel(a0)
                lea     LRZMinibossRoot_RetractionFrameDelayLoop(pc),a1
                jsr     (Set_Raw_Animation).l
                jmp     (Displace_PlayerOffObject).l
; ---------------------------------------------------------------------------

LRZMini_AnimateRetractAndCheckHit:
                jsr     (Animate_RawMultiDelay).l
                cmpi.b  #6,anim_frame(a0)
                bhs.s   LRZMini_TickFlashAndDisableRetract
                bsr.w   LRZMini_HandleHitFlashOrDefeat
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   LRZMini_MoveWaitAndClampBaseline
; ---------------------------------------------------------------------------

LRZMini_TickFlashAndDisableRetract:
                bsr.w   LRZMini_TickFlashWhileRetracting
                clr.b   collision_flags(a0)

LRZMini_MoveWaitAndClampBaseline:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                move.w  (SceneMaximumYOrEmeraldSelectionTail).w,d0
                cmp.w   y_pos(a0),d0
                bhi.s   LRZMini_BaselineUpdateReturn
                move.w  d0,y_pos(a0)
                move.b  #6,routine(a0)

LRZMini_BaselineUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_ReloadArmCycleByDefeatFlags:
                move.l  #LRZMinibossRoot_RequestArmReturnAndWait,$34(a0)
                move.b  $38(a0),d0
                andi.b  #-$40,d0
                cmpi.b  #-$40,d0
                beq.s   LRZMini_ShortWaitAfterBothArms
                move.w  #$15F,$2E(a0)
                bset    #3,$38(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_ShortWaitAfterBothArms:
                move.w  #$1F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_TryPostSignPaletteActor:
                jsr     (AllocateObject).l
                bne.s   LRZMini_SpawnDebrisAndStartSign
                move.l  #LRZMini_WaitSignAndInitExitPalette,(a1)

LRZMini_SpawnDebrisAndStartSign:
                lea     LRZMini_DefeatDebrisChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

LRZMini_InitRightArmChain:
                bset    #0,render_flags(a0)
                move.w  #$10,$2E(a0)

LRZMini_ChooseArmLinkInitializer:
                moveq   #0,d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                beq.s   LRZMini_InstallLinkAndApplyDelay
                cmpi.b  #$16,d1
                bne.s   LRZMini_LoadNonbaseInitializer
                addq.w  #4,d0

LRZMini_LoadNonbaseInitializer:
                addq.w  #4,d0

LRZMini_InstallLinkAndApplyDelay:
                movea.l LRZMini_ArmInitializerOffsets(pc,d0.w),a1
                move.l  a1,(a0)
                add.w   d1,d1
                add.w   d1,$2E(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------
LRZMini_ArmInitializerOffsets:
                dc.l    LRZMini_ArmBaseDispatchAndCheckLife
                dc.l    LRZMini_InitMiddleLinkAndWait
                dc.l    LRZMini_InitTerminalLinkAndWait
; ---------------------------------------------------------------------------

LRZMini_ArmBaseDispatchAndCheckLife:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LRZMinibossArmBase_StateOffsets(pc,d0.w),d1
                jsr     LRZMinibossArmBase_StateOffsets(pc,d1.w)
                bsr.w   LRZMiniArm_TryBreakSegmentBySide
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LRZMinibossArmBase_StateOffsets:
                dc.w    LRZMini_InitArmBaseAtCameraSide-LRZMinibossArmBase_StateOffsets
                dc.w    LRZMini_ArmBaseWaitForRise-LRZMinibossArmBase_StateOffsets
                dc.w    LRZMini_ArmBaseMoveAndWait-LRZMinibossArmBase_StateOffsets
                dc.w    LRZMini_ArmBaseWaitForReturn-LRZMinibossArmBase_StateOffsets
                dc.w    LRZMini_ArmBaseMoveAndWait-LRZMinibossArmBase_StateOffsets
; ---------------------------------------------------------------------------

LRZMini_InitArmBaseAtCameraSide:
                lea     LRZMini_ArmBaseAndMiddleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bsr.w   PlaceLRZMinibossArmBaseAtCameraSide

LRZMini_ArmBaseWaitForRise:
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   LRZMini_ArmBaseRiseSetupReturn
                move.b  #4,routine(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$6F,$2E(a0)
                move.l  #LRZMinibossArmBase_SelectRaisedWaitState,$34(a0)

LRZMini_ArmBaseRiseSetupReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_ArmBaseMoveAndWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LRZMinibossArmBase_SelectRaisedWaitState:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_ArmBaseWaitForReturn:
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                bne.s   LRZMini_ArmBaseReturnSetupDone
                move.b  #8,routine(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$6F,$2E(a0)
                move.l  #LRZMini_ArmBaseSignalReturn,$34(a0)

LRZMini_ArmBaseReturnSetupDone:
                rts
; ---------------------------------------------------------------------------

LRZMini_ArmBaseSignalReturn:
                move.b  #2,routine(a0)
                movea.w $44(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

LRZMini_InitMiddleLinkAndWait:
                lea     LRZMini_ArmBaseAndMiddleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bsr.w   LRZMiniArm_DeferInitContinuation
                move.l  #LRZMini_MiddleLinkAdvancePhase,(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_MiddleLinkAdvancePhase:
                move.b  $3C(a0),d0
                add.b   $40(a0),d0
                cmpi.b  #$70,d0
                blo.s   LRZMini_MiddleLinkReversePhaseStep
                cmpi.b  #-$70,d0
                bls.s   LRZMini_MiddleLinkStorePhaseAndDraw

LRZMini_MiddleLinkReversePhaseStep:
                neg.b   $40(a0)

LRZMini_MiddleLinkStorePhaseAndDraw:
                move.b  d0,$3C(a0)
                moveq   #4,d2
                jsr     (MoveSprite_CircularSimple).l
                bsr.w   LRZMiniArm_TryBreakSegmentBySide
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZMini_InitTerminalLinkAndWait:
                lea     LRZMinibossArmTerminal_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bsr.w   LRZMiniArm_DeferInitContinuation
                move.l  #LRZMini_TerminalWaitRiseAndArm,(a0)
                move.l  #LRZMinibossArmTerminal_UniformFrameLoop,$30(a0)
                move.b  #4,collision_property(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_TerminalWaitRiseAndArm:
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   LRZMini_TerminalCheckIdleDefeat
                move.l  #LRZMini_TerminalCheckReturn,(a0)
                moveq   #$7F,d0
                btst    #0,render_flags(a0)
                beq.s   LRZMini_TerminalSetFirstShotDelay
                move.w  #$DF,d0

LRZMini_TerminalSetFirstShotDelay:
                move.w  d0,$2E(a0)
                move.l  #LRZMini_TerminalTickBurstAndReload,$34(a0)
                clr.b   $39(a0)

LRZMini_TerminalCheckIdleDefeat:
                bra.w   LRZMiniArm_TryBreakSegmentBySide
; ---------------------------------------------------------------------------

LRZMini_TerminalCheckReturn:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   LRZMini_TerminalAnimateWaitAndHit
                move.l  #LRZMini_TerminalWaitRiseAndArm,(a0)

LRZMini_TerminalAnimateWaitAndHit:
                jsr     (Animate_Raw).l
                lea     (AngleLookup_2).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                jsr     (Obj_Wait).l
                bsr.w   LRZMiniArm_TryBreakSegmentBySide
                bsr.w   LRZMiniArmTip_HandleHitOrDefeat
                move.b  $20(a0),d0
                beq.s   LRZMini_TerminalSubmitTouch
                btst    #0,d0
                bne.w   LRZMini_SharedReturn
                bra.w   LRZMini_TerminalDraw
; ---------------------------------------------------------------------------

LRZMini_TerminalSubmitTouch:
                jsr     (Add_SpriteToCollisionResponseList).l

LRZMini_TerminalDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Switch to the long delay once the third shot is reached
LRZMini_TerminalTickBurstAndReload:
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                move.w  #$13,$2E(a0)
                cmpi.b  #3,d0
                blo.s   LRZMini_TerminalTryShotAndSound
                move.w  #$FFF,$2E(a0)

LRZMini_TerminalTryShotAndSound:
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     LRZMini_ArmShotChild(pc),a2
                jsr     (CreateChild10_NormalAdjusted).l
                bne.s   LRZMini_TerminalShotSpawnReturn
                move.b  $39(a0),subtype(a1)

LRZMini_TerminalShotSpawnReturn:
                rts
; ---------------------------------------------------------------------------

LRZMini_InitArmShot:
                lea     LRZMini_ArmShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZMini_ArmShotMoveAndCull,(a0)
                bset    #3,$2B(a0)
                bsr.w   SeedLRZMinibossArmProjectileVelocity

LRZMini_ArmShotMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

LRZMini_InitArmHitOverlay:
                lea     LRZMini_ArmHitOverlayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LRZMini_ArmHitOverlayFollowAndWait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

LRZMini_ArmHitOverlayFollowAndWait:
                jsr     (Obj_Wait).l
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #7,status(a1)
                bne.s   LRZMini_DeleteArmHitOverlay
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZMini_DeleteArmHitOverlay:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LRZMini_InitDefeatDebris:
                lea     LRZMinibossRootDebris_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  LRZMini_DefeatDebrisFrames(pc,d0.w),mapping_frame(a0)
                moveq   #$5C,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LRZMini_DefeatDebrisFrames:
                dc.b    $C,  $C,  $C, $11, $11, $12, $13,  $D,  $E,  $F, $10
                even
; ---------------------------------------------------------------------------

LRZMini_WaitSignAndInitExitPalette:
                tst.b   (End_of_level_flag).w
                beq.w   LRZMini_SharedReturn
                move.l  #LRZMini_RunExitPaletteAndCheckCamera,(a0)
                lea     LRZMini_CompletionPaletteScript(pc),a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #LRZMini_StopCompletedPaletteProgram,(Palette_rotation_custom).w
                move.w  #$7FFF,(Palette_cycle_counter1).w
                jsr     (AllocateObject).l
                bne.s   LRZMini_RunExitPaletteAndCheckCamera
                move.l  #LRZMini_WaitCameraForZonePalette,(a1)

LRZMini_RunExitPaletteAndCheckCamera:
                jsr     (Run_PalRotationScript).l

LRZMini_ClampExitCameraAndResumePal:
                cmpi.w  #$940,(Camera_X_pos).w
                blo.w   LRZMini_SharedReturn
                move.w  #$940,(Camera_min_X_pos).w
                clr.w   (Palette_cycle_counter1).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LRZMini_StopCompletedPaletteProgram:
                move.l  #LRZMini_ClampExitCameraAndResumePal,(a0)
                rts
; ---------------------------------------------------------------------------

LRZMini_WaitCameraForZonePalette:
                cmpi.w  #$2C0,(Camera_X_pos).w
                blo.w   LRZMini_SharedReturn
                move.w  #$2C0,(Camera_min_X_pos).w
                lea     (Pal_LRZ2).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

LRZMini_RestoreZonePaletteLines:
                move.l  (a1)+,(a2)+
                dbf     d6,LRZMini_RestoreZonePaletteLines
                lea     Pal_LRZMiniboss3(pc),a1
                bsr.w   CopyLRZMinibossPaletteLinesThreeAndFour
                jmp     (Delete_Current_Sprite).l

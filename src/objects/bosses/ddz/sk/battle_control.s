; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday final-boss battle controller, chase stages, damage state, world scrolling and completion progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZEndBoss:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZEndBoss_Index(pc,d0.w),d1
                jsr     DDZEndBoss_Index(pc,d1.w)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
DDZEndBoss_Index:
                dc.w    DDZ_InitBossPhase1AndAttachments-DDZEndBoss_Index
                dc.w    DDZ_Phase1ApproachAndEnableAttacks-DDZEndBoss_Index
                dc.w    DDZ_Phase1ChaseUntilTargetDefeated-DDZEndBoss_Index
                dc.w    DDZBoss_WaitBeforeFirstStageDescent-DDZEndBoss_Index
                dc.w    DDZ_Phase1TickDescentPaletteSteps-DDZEndBoss_Index
                dc.w    DDZ_WaitAndResetForPhase2Entrance-DDZEndBoss_Index
                dc.w    DDZ_Phase2RiseAndStartEntrance-DDZEndBoss_Index
                dc.w    DDZ_FinalChaseSwingAndReadRecoil-DDZEndBoss_Index
; ---------------------------------------------------------------------------

DDZ_InitBossPhase1AndAttachments:
                move.b  #2,routine(a0)
                bset    #1,(_unkFAB8).w
                move.w  #$200,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,x_pos(a0)
                move.w  #$A0,y_pos(a0)
                move.w  #$8F,$2E(a0)
                jsr     (Swing_Setup1).l
                lea     DDZ_Phase1VulnerableBodyChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     DDZ_Phase1FlickerDetailChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     DDZFirstPhaseTurrets_SimpleChildRecord(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

DDZ_Phase1ApproachAndEnableAttacks:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_Phase1ApproachReturn
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  (Camera_min_X_pos).w,d0
                subi.w  #$100,d0
                move.w  d0,(Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   DDZ_Phase1TrySpawnMissileLauncher
                move.l  #Obj_DecLevStartXGradual,(a1)

DDZ_Phase1TrySpawnMissileLauncher:
                jsr     (AllocateObject).l
                bne.s   DDZ_Phase1ApproachReturn
                move.l  #DDZ_MissileLauncherWaitForPlayerX,(a1)
                move.w  a0,parent3(a1)
                st      $39(a1)
                move.w  #$D8,$42(a1)
                move.w  #$80,$44(a1)

DDZ_Phase1ApproachReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_Phase1ChaseUntilTargetDefeated:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                move.w  (_unkFAA4).w,d0
                beq.s   DDZ_Phase1ChaseReturn
                movea.w d0,a1
                btst    #7,status(a1)
                beq.s   DDZ_Phase1ChaseReturn
                move.b  #6,routine(a0)
                bset    #7,status(a0)
                move.w  #(5*60)-1,$2E(a0)
                move.l  #-$20,(_unkFA8A).w
                jsr     (AllocateObject).l
                bne.s   DDZ_Phase1ChaseReturn
                move.l  #DDZ_Phase1UpdateTenBurstSequence,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,parent3(a1)

DDZ_Phase1ChaseReturn:
                rts
; ---------------------------------------------------------------------------

DDZBoss_WaitBeforeFirstStageDescent:
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_Phase1DefeatWaitReturn
                move.b  #8,routine(a0)
                move.w  #60-1,$3A(a0)
                move.b  #3,$39(a0)
                move.w  #-$300,x_vel(a0)
                move.w  #$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   DDZ_Phase1DefeatWaitReturn
                move.l  #DDZ_InitPhase1ExplosionAnchor,(a1)
                move.w  a0,parent3(a1)

DDZ_Phase1DefeatWaitReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_Phase1TickDescentPaletteSteps:
                subq.w  #1,$3A(a0)
                bpl.s   DDZ_Phase1DescendAndSelectPhase2
                move.w  #$59,$3A(a0)
                subq.b  #1,$39(a0)
                bmi.s   DDZ_Phase1DescendAndSelectPhase2
                lea     (Normal_palette_line_3).w,a1
                moveq   #$10-1,d0
                moveq   #$E,d1
                moveq   #-$20,d2

DDZBoss_DarkenOneFirstStagePaletteLine:
                jsr     DecColor_Obj(pc)
                dbf     d0,DDZBoss_DarkenOneFirstStagePaletteLine

DDZ_Phase1DescendAndSelectPhase2:
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX_Continuous).l
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                jsr     (MoveSprite2).l
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bhs.w   DDZ_MotionHelpersReturn
                move.b  #$A,routine(a0)
                ori.b   #$30,$38(a0)
                move.w  #$1F,$2E(a0)
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   DDZBoss_PrepareSecondStagePaletteCopy
                move.l  #DDZ_StageFlashInitFivePasses,(a1)

DDZBoss_PrepareSecondStagePaletteCopy:
                lea     (Pal_DDZ+$20).l,a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

DDZBoss_CopySecondStagePaletteLine:
                move.l  (a1)+,(a2)+
                dbf     d6,DDZBoss_CopySecondStagePaletteLine
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

DDZ_SavePaletteAndQueueEmeraldArt:
                move.l  (a1)+,(a2)+
                dbf     d6,DDZ_SavePaletteAndQueueEmeraldArt
                lea     (ArtKosM_BossMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_BossMasterEmerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

DDZ_WaitAndResetForPhase2Entrance:
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                move.b  #$C,routine(a0)
                bclr    #7,status(a0)
                andi.b  #$CF,$38(a0)
                move.w  (_unkFA8E).w,d0
                beq.s   DDZ_Phase2LockCameraAndSpawnParts
                movea.w d0,a1
                andi.b  #$F3,$38(a1)

DDZ_Phase2LockCameraAndSpawnParts:
                move.w  #$600,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                subi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                addi.w  #$E0,d0
                move.w  d0,y_pos(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                lea     DDZ_Phase2AttachedPartChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     DDZ_Phase2FlickerDetailChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

DDZ_Phase2RiseAndStartEntrance:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                cmp.w   y_pos(a0),d0
                blo.s   DDZ_Phase2EnterAndBeginFinalChase
                bset    #7,$38(a0)
                bne.s   DDZ_Phase2EnterAndBeginFinalChase
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                clr.w   y_vel(a0)

DDZ_Phase2EnterAndBeginFinalChase:
                addi.w  #$10,x_vel(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$1C0,d0
                cmp.w   x_pos(a0),d0
                bhi.s   DDZ_Phase2EntranceReturn
                move.b  #$E,routine(a0)
                bclr    #4,$38(a0)
                move.l  #$800,(_unkFA8A).w
                bset    #0,(_unkFAB8).w
                move.b  #7,collision_property(a0)
                clr.w   $2E(a0)
                clr.w   x_vel(a0)
                jsr     (Swing_Setup1).l
                move.w  #0,d0
                move.w  d0,(Camera_stored_min_Y_pos).w
                addi.w  #$C0,d0
                move.w  d0,y_pos(a0)
                jsr     (AllocateObject).l
                bne.s   DDZBoss_SetSecondStageMaximumYTarget
                move.l  #Obj_DecLevStartYGradual,(a1)

DDZBoss_SetSecondStageMaximumYTarget:
                move.w  #$120,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   DDZ_EnableFlightForFinalChase
                move.l  #Obj_IncLevEndYGradual,(a1)

DDZ_EnableFlightForFinalChase:
                move.w  (_unkFA8E).w,d0
                beq.s   DDZ_Phase2EntranceReturn
                movea.w d0,a1
                bset    #2,$38(a1)

DDZ_Phase2EntranceReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_FinalChaseSwingAndReadRecoil:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  #$40,d2
                move.w  #$60,d3
                movea.w (_unkFA8E).w,a1
                move.b  x_vel(a1),d1
                bmi.s   DDZ_FinalChaseAdjustXWithoutRight
                moveq   #0,d1

DDZ_FinalChaseAdjustXWithoutRight:
                ext.w   d1
                neg.w   d1
                asr.w   #1,d1
                btst    #button_right,(Ctrl_1_held).w
                bne.s   DDZBoss_FinalChaseAdjustXWithRightInput
                move.w  x_pos(a0),d0
                addi.w  #2,d0
                add.w   d1,d0
                move.w  (Camera_max_X_pos).w,d1
                add.w   d2,d1
                cmp.w   d1,d0
                blo.s   DDZ_FinalChaseStoreCandidateX
                rts
; ---------------------------------------------------------------------------

DDZBoss_FinalChaseAdjustXWithRightInput:
                move.w  x_pos(a0),d0
                addi.w  #-2,d0
                add.w   d1,d0
                move.w  (Camera_min_X_pos).w,d1
                add.w   d3,d1
                cmp.w   d1,d0
                bls.s   DDZ_FinalChaseAddForwardStepAndRecoil

; Swapping the register carries its previous high word into the position fraction
DDZ_FinalChaseStoreCandidateX:
                swap    d0
                move.l  d0,x_pos(a0)

DDZ_FinalChaseAddForwardStepAndRecoil:
                move.l  x_pos(a0),d0
                addi.l  #$70000,d0
                tst.b   $20(a0)
                beq.s   DDZ_FinalChaseClampXToCamera
                addi.l  #$80000,d0

; The longword load reads Camera_min_X_pos together with the following word
DDZ_FinalChaseClampXToCamera:
                move.l  (Camera_min_X_pos).w,d1
                addi.l  #$600000,d1
                cmp.l   d1,d0
                blo.s   DDZBoss_SelectFinalChaseLongBoundary
                addi.l  #$1500000,d1
                cmp.l   d1,d0
                blo.s   DDZ_FinalChaseStoreXSpawnAndHitCheck

DDZBoss_SelectFinalChaseLongBoundary:
                move.l  d1,d0

DDZ_FinalChaseStoreXSpawnAndHitCheck:
                move.l  d0,x_pos(a0)
                bsr.w   DDZBoss_TryFourShotBurst
                bra.w   DDZ_ChaseCheckSuperHitOrFlash
; ---------------------------------------------------------------------------

DDZ_FinalDefeatDispatchAndCarry:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZBoss_FinalDefeatStateOffsets(pc,d0.w),d1
                jsr     DDZBoss_FinalDefeatStateOffsets(pc,d1.w)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
DDZBoss_FinalDefeatStateOffsets:
                dc.w    DDZ_FinalDefeatCameraCatchup-DDZBoss_FinalDefeatStateOffsets
                dc.w    DDZBoss_FinalDefeatGateExplosionSound-DDZBoss_FinalDefeatStateOffsets
                dc.w    DDZ_FinalDefeatCarryPlayerUntilFade-DDZBoss_FinalDefeatStateOffsets
                dc.w    DDZ_SaveAndStartEndingLevel-DDZBoss_FinalDefeatStateOffsets
; ---------------------------------------------------------------------------

DDZ_FinalDefeatCameraCatchup:
                move.w  (Camera_X_pos).w,d0
                addq.w  #1,d0
                move.w  d0,(Camera_X_pos).w
                addi.w  #$40,d0
                cmp.w   x_pos(a0),d0
                blo.s   DDZ_FinalDefeatCameraReturn
                move.b  #2,routine(a0)
                bset    #4,$38(a0)
                move.w  #$40,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   DDZ_FinalDefeatCameraReturn
                move.l  #DDZ_InitFinalAnchorAndTryExplosion,(a1)
                move.w  a0,parent3(a1)

DDZ_FinalDefeatCameraReturn:
                rts
; ---------------------------------------------------------------------------

DDZBoss_FinalDefeatGateExplosionSound:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   DDZ_FinalDefeatFallAndTryWhiteFade
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

DDZ_FinalDefeatFallAndTryWhiteFade:
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_FinalDefeatFallReturn
                move.b  #4,routine(a0)
                jsr     (AllocateObject).l
                bne.s   DDZ_FinalDefeatFallReturn
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  a1,$44(a0)
                move.w  #7,$3A(a1)

DDZ_FinalDefeatFallReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_FinalDefeatCarryPlayerUntilFade:
                movea.w (_unkFA8E).w,a1
                addq.w  #8,x_pos(a1)
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   DDZ_MotionHelpersReturn
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                clr.b   (Super_palette_status).w
                rts
; ---------------------------------------------------------------------------

DDZ_SaveAndStartEndingLevel:
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$D01,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DDZ_InitMasterEmeraldAndCheckPalette:
                lea     DDZMasterEmerald_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_MasterEmeraldFollowAndCycleColors,(a0)
                move.b  $43(a0),$3C(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

DDZ_MasterEmeraldCheckSevenEmeralds:
                cmp.b   (a1)+,d0
                bne.s   DDZ_MasterEmeraldInitReturn
                dbf     d1,DDZ_MasterEmeraldCheckSevenEmeralds
                st      $3A(a0)
                lea     (DDZMasterEmerald_TwoSlotPalettePrograms).l,a1
                lea     (Palette_rotation_data).w,a2
                moveq   #bytesToLcnt($10),d0

DDZ_MasterEmeraldCopyPaletteSlots:
                move.l  (a1)+,(a2)+
                dbf     d0,DDZ_MasterEmeraldCopyPaletteSlots
                clr.w   (a2)

DDZ_MasterEmeraldInitReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_MasterEmeraldFollowAndCycleColors:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),d0
                subi.b  #$3A,d0
                move.b  $3C(a0),d1
                add.b   d0,d1
                move.b  d1,$43(a0)
                jsr     Refresh_ChildPosition(pc)
                tst.b   $3A(a0)
                beq.s   DDZMasterEmerald_TestRootReleaseOrDraw
                jsr     Run_PalRotationScript(pc)

DDZMasterEmerald_TestRootReleaseOrDraw:
                movea.w $44(a0),a1
                btst    #4,$38(a1)
                bne.s   DDZ_MasterEmeraldBeginReleasedScroll
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DDZ_MasterEmeraldBeginReleasedScroll:
                move.l  #DDZ_MasterEmeraldClampReleasedX,(a0)

DDZ_MasterEmeraldClampReleasedX:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                blo.s   DDZ_MasterEmeraldCarryAndDraw
                move.w  d0,x_pos(a0)

DDZ_MasterEmeraldCarryAndDraw:
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DDZ_InitPhase2PartAndEmeraldChild:
                lea     DDZSecondPhaseAttachedParts_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_Phase2PartAnimateOptionalStream,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     DDZ_Phase2PartVariantOffsets(pc,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                move.l  DDZ_Phase2PartOptionalAnimPointers(pc,d0.w),$30(a0)
                lsr.w   #2,d0
                move.b  DDZ_Phase2PartInitialFrames(pc,d0.w),mapping_frame(a0)
                tst.w   d0
                bne.w   DDZ_MotionHelpersReturn
                lea     DDZMasterEmerald_NormalChildRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
DDZ_Phase2PartInitialFrames:
                dc.b    $3A
                dc.b    5
                dc.b    $3D
                even
DDZ_Phase2PartVariantOffsets:
                dc.w    $64,   $4C
                dc.w    $10,   $20
                dc.w    $1C,   $8C
DDZ_Phase2PartOptionalAnimPointers:
                dc.l    DDZ_Phase2AttachedPart0Anim
                dc.l    0
                dc.l    DDZ_Phase2AttachedPart4Anim
; ---------------------------------------------------------------------------

DDZ_Phase2PartAnimateOptionalStream:
                move.l  $30(a0),d0
                beq.s   DDZ_Phase2PartFollowOrDetach
                movea.l d0,a1
                jsr     Animate_RawNoSSTMultiDelay(pc)

DDZ_Phase2PartFollowOrDetach:
                bsr.w   DDZChild_SetPosFromParent
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   DDZ_Phase2PartDraw
                move.l  #DDZ_Phase2PartCarryAndFlicker,(a0)
                bset    #7,status(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  DDZ_Phase2PartDetachedVelocities(pc,d0.w),x_vel(a0)  ; and y_vel
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DDZ_Phase2PartDraw
                move.b  #4,subtype(a1)

DDZ_Phase2PartDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
DDZ_Phase2PartDetachedVelocities:
                dc.w    $80, -$200
                dc.w    -$100, -$100
                dc.w    -$200, -$300
; ---------------------------------------------------------------------------

DDZ_Phase2PartCarryAndFlicker:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                jmp     Obj_FlickerMove(pc)
; ---------------------------------------------------------------------------

DDZ_Phase1TargetDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZFirstStageHitTarget_StateOffsets(pc,d0.w),d1
                jsr     DDZFirstStageHitTarget_StateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
DDZFirstStageHitTarget_StateOffsets:
                dc.w    DDZ_InitPhase1TargetHandleAndHealth-DDZFirstStageHitTarget_StateOffsets
                dc.w    DDZ_Phase1TargetFollowAndResolveHit-DDZFirstStageHitTarget_StateOffsets
; ---------------------------------------------------------------------------

DDZ_InitPhase1TargetHandleAndHealth:
                lea     DDZFirstPhaseVulnerableBody_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.w  #$C0,$42(a0)
                move.w  #$4B,$44(a0)
                move.b  #7,collision_property(a0)

DDZ_Phase1TargetFollowAndResolveHit:
                bsr.w   DDZChild_SetPosFromParent
                bra.w   DDZ_Phase1ReceiverCheckHit
; ---------------------------------------------------------------------------

DDZ_Phase1TargetFollowUntilDiscard:
                bsr.w   DDZChild_SetPosFromParent
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

DDZ_InitTurretOffsetAndShotTimer:
                lea     DDZFirstPhaseTurret_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZTurret_WaitForRootAttackEnable,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     DDZTurret_ParentWordOffsetsByVariant(pc,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------
DDZTurret_ParentWordOffsetsByVariant:
                dc.w    $90,   $60
                dc.w    $B0,   $58
                dc.w    $A8,   $78
; ---------------------------------------------------------------------------

DDZTurret_WaitForRootAttackEnable:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   DDZ_TurretAimEvery16Frames
                move.l  #DDZTurret_CountDownAndTryOneAimedShot,(a0)

DDZTurret_CountDownAndTryOneAimedShot:
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_TurretAimEvery16Frames
                move.w  #$60,$2E(a0)
                lea     DDZTurretShot_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)

DDZ_TurretAimEvery16Frames:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   DDZTurret_PositionMuzzleAndDrawOrDetach
                movea.l a0,a1
                lea     (Player_1).w,a2
                jsr     GetApproximateObjectBearing(pc)
                addi.b  #$10,d0
                lsr.b   #4,d0
                andi.w  #$FE,d0
                move.w  d0,angle(a0)
                lsr.w   #1,d0
                addi.b  #$1C,d0
                move.b  d0,mapping_frame(a0)

DDZTurret_PositionMuzzleAndDrawOrDetach:
                bsr.w   PositionDDZTurretWithEightWayMuzzleNudge
                moveq   #0,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

DDZ_InitTurretShotAndVelocity:
                lea     DDZTurretShot_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DDZ_TurretShotMoveAndCollide,(a0)
                bsr.w   DDZTurretShot_SetVelFromParentAngle

DDZ_TurretShotMoveAndCollide:
                jsr     (MoveSprite2).l
                jsr     (DDZTurretShot_CheckContactOrRetire).l
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

DDZ_InitPhase1FlickerPart:
                lea     DDZ_Phase1DetailAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     DDZ_Phase1FlickerPartOffsets(pc),a1

DDZ_FlickerPartStoreOffsets:
                move.l  #DDZ_FlickerPartFollowAndDrawByTick,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                rts
; ---------------------------------------------------------------------------
DDZ_Phase1FlickerPartOffsets:
                dc.w    $10,   $38
                dc.w    $10,   $87
                dc.w    $28,   $60
; ---------------------------------------------------------------------------

DDZ_FlickerPartFollowAndDrawByTick:
                bsr.w   DDZChild_SetPosFromParent
                btst    #1,(V_int_run_count+3).w
                bne.s   DDZ_FlickerPartCheckHiddenParent
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DDZ_FlickerPartCheckHiddenParent:
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DDZ_InitPhase2FlickerPart:
                lea     DDZ_Phase2DetailAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     DDZ_Phase2FlickerPartOffsets(pc),a1
                bra.s   DDZ_FlickerPartStoreOffsets
; ---------------------------------------------------------------------------
DDZ_Phase2FlickerPartOffsets:
                dc.w    -$20,   $24
                dc.w    -$10,   $44
; ---------------------------------------------------------------------------

DDZ_MissileLauncherWaitForPlayerX:
                bsr.w   DDZChild_SetPosFromParent
                tst.b   $39(a0)
                bpl.s   DDZ_MissileCheckParentAndRetire
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                blo.s   DDZ_MissileCheckParentAndRetire
                moveq   #2,d1
                move.b  d1,$39(a0)
                moveq   #0,d2

DDZ_MissileLauncherTryThreeHoming:
                jsr     (AllocateObject).l
                bne.s   DDZ_MissileCheckParentAndRetire
                move.l  #Obj_DDZMissile,(a1)
                move.b  #1,subtype(a1)
                move.w  a0,parent3(a1)
                move.b  d2,$39(a1)
                addq.w  #1,d2
                dbf     d1,DDZ_MissileLauncherTryThreeHoming
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l

DDZ_MissileCheckParentAndRetire:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   DDZ_MotionHelpersReturn
                jmp     (Go_Delete_Sprite).l

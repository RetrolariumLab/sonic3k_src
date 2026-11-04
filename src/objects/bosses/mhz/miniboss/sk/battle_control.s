; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss controller, attacks, parent actors and battle progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MHZMiniboss_Index(pc,d0.w),d1
                jsr     MHZMiniboss_Index(pc,d1.w)
                move.w  (Level_repeat_offset).w,d0
                beq.s   MHZMini_CheckHitFrameAndDraw
                sub.w   d0,x_pos(a0)

MHZMini_CheckHitFrameAndDraw:
                bsr.w   HandleMHZMinibossFourColorHitOrDefeat
                bsr.w   MHZMini_SetPriorityFromFrame
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MHZMiniboss_Index:
                dc.w    MHZMini_InitBossAndLinkedChildren-MHZMiniboss_Index
                dc.w    MHZMinibossRoot_AnimateMoveAndWait-MHZMiniboss_Index
                dc.w    MHZMini_SwingThenBeginRightRun-MHZMiniboss_Index
                dc.w    MHZMinibossRoot_AnimateMoveAndWait-MHZMiniboss_Index
                dc.w    MHZMini_MoveAndWaitOnscreen-MHZMiniboss_Index
                dc.w    MHZMini_DecelerateToZero-MHZMiniboss_Index
                dc.w    MHZMini_SwingToChopWindow-MHZMiniboss_Index
                dc.w    MHZMini_SwingAndChopTree-MHZMiniboss_Index
                dc.w    MHZMini_WaitForLoweringTurn-MHZMiniboss_Index
                dc.w    MHZMini_MoveAndTickPhaseWait-MHZMiniboss_Index
                dc.w    MHZMini_AnimateStuckChopAndSound-MHZMiniboss_Index
                dc.w    MHZMini_RecoilAndCheckFloor-MHZMiniboss_Index
                dc.w    MHZMini_MoveToRecoverySpeed-MHZMiniboss_Index
                dc.w    MHZMini_MoveAndTickPhaseWait-MHZMiniboss_Index
                dc.w    MHZMini_MoveReturnArcToBaseline-MHZMiniboss_Index
                dc.w    MHZMini_MoveAndTickPhaseWait-MHZMiniboss_Index
                dc.w    MHZMini_KnucklesChopAndThrow-MHZMiniboss_Index
                dc.w    MHZMini_AnimateThrownPhase-MHZMiniboss_Index
                dc.w    MHZMini_MoveAndTickPhaseWait-MHZMiniboss_Index
                dc.w    MHZMini_SwingUntilThrownActorReturns-MHZMiniboss_Index
                dc.w    MHZMini_MoveToUpperCameraBand-MHZMiniboss_Index
                dc.w    MHZMini_AnimateAndTickWait-MHZMiniboss_Index
                dc.w    MHZMini_AnimateAndLimitYAcceleration-MHZMiniboss_Index
                dc.w    MHZMini_SlowDiagonalYToZero-MHZMiniboss_Index
; ---------------------------------------------------------------------------

MHZMini_InitBossAndLinkedChildren:
                lea     ObjDat_MHZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$78,d0
                move.w  d0,y_pos(a0)
                move.b  #6,collision_property(a0)
                move.w  a0,(SceneControllerObjectAddress).w
                move.b  #5,$42(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                move.b  #1,(Boss_flag).w
                move.w  #$100,y_vel(a0)
                move.w  #$97,$2E(a0)
                move.l  #MHZMini_SaveXAndBeginCountedSwing,$34(a0)
                move.l  #MHZMinibossRoot_DefaultFrameDelayLoop,$30(a0)
                move.b  #$18,y_radius(a0)
                lea     MHZMini_LinkedBodyChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   MHZMini_QueueBossArtAndPalette
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

MHZMini_QueueBossArtAndPalette:
                lea     (ArtKosM_MHZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MHZMinibossLog).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZMinibossLog),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_MHZMiniboss_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_MHZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

MHZMinibossRoot_AnimateMoveAndWait:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_SaveXAndBeginCountedSwing:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.b  x_pos+1(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                move.b  #3,$39(a0)

MHZMini_ResetSwingAndVelocity:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_SwingThenBeginRightRun:
                jsr     (Animate_RawMultiDelay).l
                jsr     (Swing_UpAndDown_Count).l
                bne.s   MHZMini_ClampAndBeginShortRun
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MHZMini_ClampAndBeginShortRun:
                move.b  #6,routine(a0)
                move.w  $3C(a0),y_pos(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MHZMini_BeginRunAndOpenCamera,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginRunAndOpenCamera:
                move.b  #8,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  #$4F,$2E(a0)
                move.l  #MHZMini_BeginRunDeceleration,$34(a0)
                move.w  #$6000,(Camera_target_max_X_pos).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   MHZMini_CameraHelperSpawnReturn
                move.l  #MHZMini_AdvanceCameraIfSameOwner,(a1)
                move.w  (Camera_max_X_pos).w,$34(a1)

MHZMini_CameraHelperSpawnReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_MoveAndWaitOnscreen:
                tst.b   render_flags(a0)
                bpl.s   MHZMini_RunUpdateReturn
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_BeginRunDeceleration:
                move.b  #$A,routine(a0)
                move.b  #4,mapping_frame(a0)
                addq.w  #2,x_pos(a0)

MHZMini_RunUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_DecelerateToZero:
                move.w  x_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,x_vel(a0)
                beq.s   MHZMini_RestoreXAndSwing
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MHZMini_RestoreXAndSwing:
                move.b  #$C,routine(a0)
                move.b  $3A(a0),x_pos+1(a0)
                clr.w   x_vel(a0)
                bra.w   MHZMini_ResetSwingAndVelocity
; ---------------------------------------------------------------------------

MHZMini_SwingToChopWindow:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                cmpi.w  #$110,d0
                bls.s   MHZMini_BeginChopAnimation
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginChopAnimation:
                move.b  #$E,routine(a0)
                move.l  #MHZMini_ChopAnim,$30(a0)
                move.l  #MHZMinibossRoot_SelectWaitForSwingTurn,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

; Advance the tree damage only when the decoder steps to cursor $A
MHZMini_SwingAndChopTree:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                beq.s   MHZMini_ChopAnimationReturn
                cmpi.b  #$A,anim_frame(a0)
                bne.s   MHZMini_ChopAnimationReturn
                subq.b  #1,$42(a0)
                moveq   #signextendB(sfx_ChopTree),d0
                jsr     (Play_SFX).l

MHZMini_ChopAnimationReturn:
                rts
; ---------------------------------------------------------------------------

MHZMinibossRoot_SelectWaitForSwingTurn:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_WaitForLoweringTurn:
                jsr     (Swing_UpAndDown).l
                tst.w   d3
                bne.s   MHZMini_BeginLoweringAndCheckTrees
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MHZMini_BeginLoweringAndCheckTrees:
                move.b  #$12,routine(a0)
                move.w  #$200,y_vel(a0)
                cmpi.b  #1,$42(a0)
                beq.s   MHZMini_ChooseLastTreeCallback
                move.w  #$F,$2E(a0)
                move.l  #MHZMini_ReturnToChopSwing,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_ChooseLastTreeCallback:
                move.w  #7,$2E(a0)
                move.l  #MHZMini_BeginStuckChop,$34(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   MHZMini_LastTreeSetupReturn
                move.l  #MHZMini_BeginKnucklesThrowSwing,$34(a0)

MHZMini_LastTreeSetupReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_MoveAndTickPhaseWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_ReturnToChopSwing:
                move.b  #$E,routine(a0)
                move.l  #MHZMinibossRoot_SelectWaitForSwingTurn,$34(a0)
                bra.w   MHZMini_ResetSwingAndVelocity
; ---------------------------------------------------------------------------

MHZMini_BeginStuckChop:
                move.b  #$14,routine(a0)
                move.l  #MHZMini_StuckChopAnim,$30(a0)
                move.l  #MHZMini_BeginRecoilAndHideLinks,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginKnucklesThrowSwing:
                move.b  #$20,routine(a0)
                bra.w   MHZMini_ResetSwingAndVelocity
; ---------------------------------------------------------------------------

MHZMini_AnimateStuckChopAndSound:
                jsr     (Animate_RawMultiDelay).l
                beq.s   MHZMini_StuckChopUpdateReturn
                cmpi.b  #$12,mapping_frame(a0)
                bne.s   MHZMinibossRoot_NudgeXAtStuckRawCursor
                moveq   #signextendB(sfx_ChopStuck),d0
                jsr     (Play_SFX).l

MHZMinibossRoot_NudgeXAtStuckRawCursor:
                cmpi.b  #$C,anim_frame(a0)
                bne.s   MHZMini_StuckChopUpdateReturn
                subi.w  #$20,x_pos(a0)

MHZMini_StuckChopUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginRecoilAndHideLinks:
                move.b  #$16,routine(a0)
                bset    #6,$38(a0)
                move.l  #MHZMini_RecoilAnim,$30(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_ChopStuck),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

MHZMini_RecoilAndCheckFloor:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   MHZMini_RecoilFloorReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   MHZMini_SetSecondRecoilVelocity

MHZMini_RecoilFloorReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_SetSecondRecoilVelocity:
                move.b  #$18,routine(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_MoveToRecoverySpeed:
                jsr     (MoveSprite).l
                move.w  y_vel(a0),d0
                bmi.s   MHZMini_RecoverySpeedReturn
                cmpi.w  #$100,d0
                bhs.s   MHZMini_BeginVisibleRecovery

MHZMini_RecoverySpeedReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginVisibleRecovery:
                move.b  #$1A,routine(a0)
                bclr    #6,$38(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$10,$2E(a0)
                move.l  #MHZMini_BeginReturnArcAndHideLinks,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginReturnArcAndHideLinks:
                move.b  #$1C,routine(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_MoveReturnArcToBaseline:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   MHZMini_ReturnArcGateReturn
                move.w  y_pos(a0),d0
                cmp.w   $3C(a0),d0
                bhs.s   MHZMini_ClampAndBeginRecoveryRun

MHZMini_ReturnArcGateReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_ClampAndBeginRecoveryRun:
                move.b  #$1E,routine(a0)
                move.b  #5,mapping_frame(a0)
                bclr    #6,$38(a0)
                move.w  $3C(a0),y_pos(a0)
                clr.w   y_pos+2(a0)
                clr.w   y_vel(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$2A,$2E(a0)
                move.l  #MHZMini_ClampAndBeginShortRun,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #MHZMinibossRoot_LongFrameFivePairLoop,$30(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_KnucklesChopAndThrow:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                beq.s   MHZMini_KnucklesChopReturn
                cmpi.b  #$A,anim_frame(a0)
                bne.s   MHZMini_KnucklesChopReturn
                move.b  #$22,routine(a0)
                move.b  #$F,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #MHZMini_ThrowAnim,$30(a0)
                move.l  #MHZMini_BeginPostThrowDrift,$34(a0)
                subq.b  #1,$42(a0)
                lea     MHZMinibossRoot_SingleThrownNormalChild(pc),a2
                jsr     (CreateChild1_Normal).l

MHZMini_KnucklesChopReturn:
                rts
; ---------------------------------------------------------------------------

MHZMini_AnimateThrownPhase:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

MHZMini_BeginPostThrowDrift:
                move.b  #$24,routine(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MHZMini_BeginWaitingSwing,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginWaitingSwing:
                move.b  #$26,routine(a0)
                bra.w   MHZMini_ResetSwingAndVelocity
; ---------------------------------------------------------------------------

MHZMini_SwingUntilThrownActorReturns:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #2,$38(a0)
                bne.s   MHZMinibossRoot_StartUpwardCameraExit
                rts
; ---------------------------------------------------------------------------

MHZMinibossRoot_StartUpwardCameraExit:
                move.b  #$28,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #MHZMinibossRoot_DefaultFrameDelayLoop,$30(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_MoveToUpperCameraBand:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                cmp.w   y_pos(a0),d0
                bhs.s   MHZMini_ClampUpperBandAndPause
                rts
; ---------------------------------------------------------------------------

MHZMini_ClampUpperBandAndPause:
                move.b  #$2A,routine(a0)
                move.w  d0,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MHZMini_BeginDownLeftArc,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_AnimateAndTickWait:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_BeginDownLeftArc:
                move.b  #$2C,routine(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #$700,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_AnimateAndLimitYAcceleration:
                jsr     (Animate_RawMultiDelay).l
                move.w  y_vel(a0),d0
                addi.w  #-$48,d0
                cmpi.w  #-$700,d0
                blt.s   MHZMini_MoveArcAndCheckExit
                move.w  d0,y_vel(a0)

MHZMini_MoveArcAndCheckExit:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   MHZMini_BeginDiagonalRecoveryRun
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginDiagonalRecoveryRun:
                move.b  #$2E,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$30,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$5C,d0
                move.w  d0,y_pos(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #MHZMini_ClampAndBeginShortRun,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #MHZMinibossRoot_LongFrameFivePairLoop,$30(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_SlowDiagonalYToZero:
                move.w  y_vel(a0),d0
                addi.w  #-$10,d0
                bmi.s   MHZMini_MoveAndTickRecovery
                move.w  d0,y_vel(a0)

MHZMini_MoveAndTickRecovery:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_StartEndSign:
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

MHZMini_InitLeafSpawner:
                move.l  #MHZMini_FollowAndTryLeaf,(a0)
                bset    #4,shield_reaction(a0)
                lea     MHZMini_ArtPriorityBounds(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

MHZMini_FollowAndTryLeaf:
                bsr.w   MHZMiniPart_SetFramePriorityOffsets
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.w   MHZMini_LeafSpawnerCheckParent
                move.b  (V_int_run_count+3).w,d0
                btst    #0,d0
                bne.w   MHZMini_LeafSpawnerCheckParent
                andi.b  #$F,d0
                bne.s   MHZMini_LeafSpawnerTouchDraw
                tst.b   render_flags(a0)
                bpl.s   MHZMini_LeafSpawnerTouchDraw
                jsr     (AllocateObject).l
                bne.s   MHZMini_LeafSpawnerTouchDraw
                move.l  #MHZMini_InitCameraRelativeMotion,(a1)
                move.w  a0,parent3(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)

MHZMini_LeafSpawnerTouchDraw:
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

MHZMini_LeafSpawnerCheckParent:
                btst    #7,status(a1)
                bne.s   MHZMini_DeleteLeafSpawner
                rts
; ---------------------------------------------------------------------------

MHZMini_DeleteLeafSpawner:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZMini_ThrownActorDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MHZMinibossThrownActor_StateOffsets(pc,d0.w),d1
                jsr     MHZMinibossThrownActor_StateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
MHZMinibossThrownActor_StateOffsets:
                dc.w    MHZMini_InitPlayerAimedThrow-MHZMinibossThrownActor_StateOffsets
                dc.w    MHZMini_ThrownActorFallAndBounce-MHZMinibossThrownActor_StateOffsets
                dc.w    MHZMini_AnimateAndWait-MHZMinibossThrownActor_StateOffsets
                dc.w    MHZMini_MoveAnimateAndWait-MHZMinibossThrownActor_StateOffsets
                dc.w    MHZMini_AnimateAndWait-MHZMinibossThrownActor_StateOffsets
                dc.w    MHZMini_FallAndCheckCatchHeight-MHZMinibossThrownActor_StateOffsets
; ---------------------------------------------------------------------------

MHZMini_InitPlayerAimedThrow:
                lea     MHZMinibossThrownActor_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #6,y_radius(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #MHZMinibossThrownActor_FrameDelayLoop,$30(a0)
                moveq   #0,d0
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.s   MHZMini_StoreThrowXSpeed
                smi     d1
                bpl.s   MHZMini_DivideThrowXDistance
                neg.w   d0

MHZMini_DivideThrowXDistance:
                swap    d0
                divu.w  #$3800,d0
                tst.b   d1
                beq.s   MHZMini_StoreThrowXSpeed
                neg.w   d0

MHZMini_StoreThrowXSpeed:
                move.w  d0,x_vel(a0)

MHZMini_ThrownActorFallAndBounce:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   MHZMini_AnimateAfterThrow
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   MHZMini_AnimateAfterThrow
                bsr.w   MHZMiniThrown_BounceOrStartRecovery

MHZMini_AnimateAfterThrow:
                jmp     (Animate_RawMultiDelay).l
; End of function MHZMini_SlowDiagonalYToZero

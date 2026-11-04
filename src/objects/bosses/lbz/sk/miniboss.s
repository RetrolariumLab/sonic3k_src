; Owner: objects/bosses/lbz/sk
; Responsibility: Launch Base miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniboss_Index(pc,d0.w),d1
                jsr     LBZMiniboss_Index(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZMiniboss_Index:
                dc.w    LBZMiniSK_InitBodyCoverAndArms-LBZMiniboss_Index
                dc.w    LBZMiniSK_TickInitialMotionWait-LBZMiniboss_Index
                dc.w    LBZMiniSK_MoveAndTickInitialHold-LBZMiniboss_Index
                dc.w    LBZMiniSK_AnimateAndTickSpinUp-LBZMiniboss_Index
                dc.w    LBZMiniSK_ChasePlayerWithDeadbands-LBZMiniboss_Index
                dc.w    LBZMiniSK_RiseDuringHitFlash-LBZMiniboss_Index
; ---------------------------------------------------------------------------

LBZMiniSK_InitBodyCoverAndArms:
                lea     ObjDat_LBZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  x_pos(a0),$3C(a0)
                move.w  #$10,$2E(a0)
                move.l  #LBZMiniSK_BeginVerticalHold,$34(a0)
                lea     Pal_LBZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     LBZMiniSK_CoverChild(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     LBZMiniSK_FixedArmLinkedChildren(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                lea     LBZMiniSK_RemovableArmLinkedChildren(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

LBZMiniSK_TickInitialMotionWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZMiniSK_BeginVerticalHold:
                move.b  #4,routine(a0)
                move.w  #0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZMiniSK_BeginSpinUpAndSignalCover,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_MoveAndTickInitialHold:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZMiniSK_BeginSpinUpAndSignalCover:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                lea     (LBZMiniSK_RamAnimationSeed).l,a1
                lea     (SceneTimerOrSharedMotionRecordBase).w,a2
                moveq   #6-1,d6

LBZMiniSK_SeedSharedRamAnimation:
                move.b  (a1)+,(a2)+
                dbf     d6,LBZMiniSK_SeedSharedRamAnimation
                move.l  #SceneTimerOrSharedMotionRecordBase,$30(a0)
                move.b  #$10,anim_frame_timer(a0)
                move.l  #LBZMiniSK_ShortenRamAnimDelay,$34(a0)

LBZMiniSK_ReloadSpinUpDelay:
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_AnimateAndTickSpinUp:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

; Decrease the shared animation delay until it reaches 2, then switch to pursuit
LBZMiniSK_ShortenRamAnimDelay:
                lea     (SceneTimerOrSharedMotionRecordBase).w,a1
                subq.b  #1,(a1)
                cmpi.b  #2,(a1)
                bhi.s   LBZMiniSK_ReloadSpinUpDelay
                move.b  #8,routine(a0)
                move.b  #6,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ChasePlayerWithDeadbands:
                lea     (Player_1).w,a1
                moveq   #0,d0
                moveq   #0,d1
                move.w  x_pos(a0),d2
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   LBZMiniSK_CalcPlayerXDistance
                moveq   #$20,d4
                tst.b   subtype(a0)
                beq.s   LBZMiniSK_AddKnucklesChaseBias
                neg.w   d4

LBZMiniSK_AddKnucklesChaseBias:
                add.w   d4,d2

LBZMiniSK_CalcPlayerXDistance:
                sub.w   x_pos(a1),d2
                bpl.s   LBZMiniSK_CalcChaseYDistance
                neg.w   d2
                addq.w  #2,d0

; Aim $38 pixels above player one
LBZMiniSK_CalcChaseYDistance:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                move.w  y_pos(a1),d4
                subi.w  #$38,d4
                sub.w   d4,d3
                bpl.s   LBZMiniSK_SetChaseXOutsideDeadband
                neg.w   d3
                addq.w  #2,d1

LBZMiniSK_SetChaseXOutsideDeadband:
                move.w  LBZMiniSK_ChaseSpeedWords(pc,d0.w),x_vel(a0)
                move.w  LBZMiniSK_ChaseSpeedWords(pc,d1.w),y_vel(a0)
                cmpi.w  #4,d2
                bhi.s   LBZMiniSK_SetChaseYOutsideDeadband
                clr.w   x_vel(a0)

LBZMiniSK_SetChaseYOutsideDeadband:
                cmpi.w  #4,d3
                bhi.s   LBZMiniSK_MoveAndAnimateChase
                clr.w   y_vel(a0)

LBZMiniSK_MoveAndAnimateChase:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (LBZMiniSK_CheckHitAndArmLoss).l
; ---------------------------------------------------------------------------
LBZMiniSK_ChaseSpeedWords:
                dc.w    -$100,  $100
; ---------------------------------------------------------------------------

LBZMiniSK_RiseDuringHitFlash:
                subq.w  #2,y_pos(a0)
                jmp     (LBZMiniSK_CheckHitAndArmLoss).l
; ---------------------------------------------------------------------------

LBZMiniSK_FinishDefeatByProfile:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZMiniSK_SignalKnucklesCoordinator
                jsr     (AllocateObject).l
                bne.s   LBZMiniSK_RestoreXAndStartEndSign
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

LBZMiniSK_RestoreXAndStartEndSign:
                move.w  $3C(a0),x_pos(a0)
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

LBZMiniSK_SignalKnucklesCoordinator:
                movea.w parent3(a0),a1
                move.b  subtype(a0),d0
                bset    d0,$38(a1)
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

LBZMiniSK_CoverFollowDispatchAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniSK_CoverStateOffsets(pc,d0.w),d1
                jsr     LBZMiniSK_CoverStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
LBZMiniSK_CoverStateOffsets:
                dc.w    LBZMiniSK_InitCoverAndAnim-LBZMiniSK_CoverStateOffsets
                dc.w    LBZMiniSK_CoverWaitForOpening-LBZMiniSK_CoverStateOffsets
                dc.w    LBZMiniSK_CoverAnimateOpening-LBZMiniSK_CoverStateOffsets
; ---------------------------------------------------------------------------

LBZMiniSK_InitCoverAndAnim:
                lea     LBZMiniSK_CoverAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZMiniSK_CoverOpeningAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_CoverWaitForOpening:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   LBZMiniSK_CoverBeginOpening
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_CoverBeginOpening:
                move.b  #4,routine(a0)
                move.l  #LBZMiniSK_CoverOpeningAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_CoverAnimateOpening:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZMiniSK_MarkRemovableChain:
                bset    #2,$38(a0)

LBZMiniSK_ArmDispatchAndCheckLife:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniSK_ArmStateOffsets(pc,d0.w),d1
                jsr     LBZMiniSK_ArmStateOffsets(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   LBZMiniSK_ArmCheckLinkedLifetime
                jmp     LBZMiniSK_ArmCheckBossDeathOrLoss(pc)
; ---------------------------------------------------------------------------

LBZMiniSK_ArmCheckLinkedLifetime:
                jmp     LBZMiniSK_ArmCheckPropagatedDetach(pc)
; ---------------------------------------------------------------------------
LBZMiniSK_ArmStateOffsets:
                dc.w    LBZMiniSK_InitArmGeometry-LBZMiniSK_ArmStateOffsets
                dc.w    LBZMiniSK_ArmRefreshFirstNode-LBZMiniSK_ArmStateOffsets
                dc.w    LBZMiniSK_ArmRotateWhileActive-LBZMiniSK_ArmStateOffsets
                dc.w    LBZMiniSK_ArmFollowPreviousAngle-LBZMiniSK_ArmStateOffsets
                dc.w    LBZMiniSK_ArmAdvanceAndPlace-LBZMiniSK_ArmStateOffsets
                dc.w    LBZMiniSK_ArmPlaceStoppedEndNode-LBZMiniSK_ArmStateOffsets
; ---------------------------------------------------------------------------

LBZMiniSK_InitArmGeometry:
                lea     LBZMinibossSK_Arm_PartialAttributePrefix(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  #$100,$2E(a0)
                move.l  #LBZMiniSK_ArmBeginActivationDelay,$34(a0)
                move.b  #4,$3D(a0)
                move.w  #5,$3E(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   LBZMiniSK_ArmApplySubtypeAppearance
                move.w  #4,$3E(a0)
                bset    #1,$38(a0)

LBZMiniSK_ArmApplySubtypeAppearance:
                bra.w   LBZMiniSK_ArmLoadSubtypePose
; ---------------------------------------------------------------------------

LBZMiniSK_ArmRefreshFirstNode:
                tst.b   subtype(a0)
                bne.s   LBZMiniSK_ArmPlaceAndTickInitialWait
                jsr     (Refresh_ChildPositionAdjusted).l

LBZMiniSK_ArmPlaceAndTickInitialWait:
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmBeginActivationDelay:
                move.b  #4,routine(a0)
                bsr.w   SetLBZMinibossArmActivationDelay
                move.l  #LBZMiniSK_ArmStartAndActivatePrev,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ArmRotateWhileActive:
                btst    #1,$38(a0)
                beq.s   LBZMiniSK_ArmPlaceDormantNode
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmPlaceDormantNode:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmStartAndActivatePrev:
                bsr.w   SetLBZMinibossArmRotationDelay
                move.l  #LBZMiniSK_ArmReverseAndResetPhase,$34(a0)
                tst.b   subtype(a0)
                beq.s   LBZMiniSK_ArmFirstNodeRotate
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)
                move.b  $3C(a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ArmFirstNodeRotate:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ArmFollowPreviousAngle:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   LBZMiniSK_ArmRotateAfterPrevStops
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ArmRotateAfterPrevStops:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_ArmAdvanceAndPlace:
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                jsr     (Obj_Wait).l
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmReverseAndResetPhase:
                bclr    #1,$38(a0)
                neg.b   $3D(a0)
                bsr.w   LBZMiniSK_ArmBeginActivationDelay
                cmpi.b  #$A,subtype(a0)
                bne.s   LBZMiniSK_ArmChooseChainPhaseBank
                move.b  #$A,routine(a0)
                move.w  #$3C,$2E(a0)
                move.l  #LBZMiniSK_ArmBeginActivationDelay,$34(a0)
                bset    #1,$38(a0)

LBZMiniSK_ArmChooseChainPhaseBank:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                moveq   #0,d1
                btst    #2,$38(a0)
                beq.s   LBZMiniSK_ArmChooseReversePhaseBank
                addq.w  #8,d1

LBZMiniSK_ArmChooseReversePhaseBank:
                tst.b   $3D(a0)
                bpl.s   LBZMiniSK_ArmLoadResetPhase
                addq.w  #4,d1

LBZMiniSK_ArmLoadResetPhase:
                movea.l LBZMiniSK_ArmResetPhaseBankPointers(pc,d1.w),a1
                move.b  (a1,d0.w),$3C(a0)
                rts
; ---------------------------------------------------------------------------
LBZMiniSK_ArmResetPhaseBankPointers:
                dc.l    LBZMiniSK_FixedArmPositivePhases
                dc.l    LBZMiniSK_FixedArmNegativePhases
                dc.l    LBZMiniSK_RemovableArmPositivePhases
                dc.l    LBZMiniSK_RemovableArmNegativePhases
; ---------------------------------------------------------------------------

LBZMiniSK_ArmPlaceStoppedEndNode:
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZMiniSK_DetachedArmFallAndDraw:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmLoadSubtypePose:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMiniSK_ArmPrioritiesBySubtype(pc,d0.w),priority(a0)
                lsr.w   #1,d0
                move.b  LBZMiniSK_ArmFramesBySubtype(pc,d0.w),mapping_frame(a0)
                move.b  LBZMiniSK_FixedArmPositivePhases(pc,d0.w),$3C(a0)
                btst    #2,$38(a0)
                beq.s   LBZMiniSK_ArmPlaceInitialPose
                move.b  LBZMiniSK_RemovableArmPositivePhases(pc,d0.w),$3C(a0)

LBZMiniSK_ArmPlaceInitialPose:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------
LBZMiniSK_ArmPrioritiesBySubtype:
                dc.w    $300,  $380,  $300,  $380,  $300,  $280
LBZMiniSK_ArmFramesBySubtype:
                dc.b    7,   8,   7,   8,   7,   6
LBZMiniSK_FixedArmPositivePhases:
                dc.b    $55,   0, $D5, $AA, $80, $68
LBZMiniSK_FixedArmNegativePhases:
                dc.b    $2A, $7A, $B0, $DA,   0, $18
LBZMiniSK_RemovableArmPositivePhases:
                dc.b    $D5, $80, $55, $2A,   0, $F4
LBZMiniSK_RemovableArmNegativePhases:
                dc.b    $AA,   0, $2A, $55, $80, $8C
                even

; =============== S U B R O U T I N E =======================================

SetLBZMinibossArmActivationDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMinibossSK_Arm_SixActivationWaitWords(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmActivationDelay

; ---------------------------------------------------------------------------
LBZMinibossSK_Arm_SixActivationWaitWords:
                dc.w    0
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    5

; =============== S U B R O U T I N E =======================================

SetLBZMinibossArmRotationDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMinibossSK_Arm_SixRotationWaitWords(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmRotationDelay

; ---------------------------------------------------------------------------
LBZMinibossSK_Arm_SixRotationWaitWords:
                dc.w    $34
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    3
; ---------------------------------------------------------------------------

; Set the removable-chain flag when the boss reaches three remaining hits
LBZMiniSK_CheckHitAndArmLoss:
                tst.b   collision_flags(a0)
                bne.s   LBZMiniSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   LBZMiniSK_BeginDefeatExplosion
                cmpi.b  #3,collision_property(a0)
                bne.s   LBZMiniSK_SaveRoutineAndBeginHitRise
                bset    #0,$38(a0)

LBZMiniSK_SaveRoutineAndBeginHitRise:
                tst.b   $20(a0)
                bne.s   LBZMiniSK_TickFlashAndRestoreRoutine
                move.b  routine(a0),$3A(a0)
                move.b  #$A,routine(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

LBZMiniSK_TickFlashAndRestoreRoutine:
                jsr     (BossFlash).l
                subq.b  #1,$20(a0)
                bne.s   LBZMiniSK_HitUpdateReturn
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)

LBZMiniSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZMiniSK_BeginDefeatExplosion:
                move.l  #Wait_NewDelay,(a0)
                move.l  #LBZMiniSK_FinishDefeatByProfile,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                cmpi.w  #3,(Player_mode).w
                beq.s   LBZMiniSK_AwardScoreWithoutStoppingTimer
                jmp     (BossDefeated_StopTimer).l
; ---------------------------------------------------------------------------

LBZMiniSK_AwardScoreWithoutStoppingTimer:
                jmp     (BossDefeated).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmCheckBossDeathOrLoss:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZMiniSK_ArmPropagateDetach
                btst    #0,$38(a1)
                beq.s   LBZMiniSK_ArmTouchDraw
                btst    #2,$38(a0)
                bne.s   LBZMiniSK_ArmPropagateDetach

LBZMiniSK_ArmTouchDraw:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

; Mark the next linked segment before detaching the current one
LBZMiniSK_ArmPropagateDetach:
                move.w  $44(a0),d0
                beq.s   LBZMiniSK_ArmDetachAndDraw
                movea.w d0,a1
                bset    #7,status(a1)

LBZMiniSK_ArmDetachAndDraw:
                bsr.w   DetachLBZMinibossArmSegmentWithGravity
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

LBZMiniSK_ArmCheckPropagatedDetach:
                btst    #7,status(a0)
                bne.s   LBZMiniSK_ArmPropagateDetach
                jmp     (Draw_And_Touch_Sprite).l

; =============== S U B R O U T I N E =======================================

DetachLBZMinibossArmSegmentWithGravity:
                move.l  #LBZMiniSK_DetachedArmFallAndDraw,(a0)
                clr.b   collision_flags(a0)
                move.w  #$80,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     LBZMiniSK_DetachVelocityPairs(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function DetachLBZMinibossArmSegmentWithGravity

; ---------------------------------------------------------------------------
LBZMiniSK_DetachVelocityPairs:
                dc.w    $100, -$100
                dc.w    -$200, -$200
                dc.w    $300, -$200
                dc.w    $200, -$100
                dc.w    -$100, -$200
                dc.w    -$80, -$100
ObjDat_LBZMiniboss:
                dc.l    Map_LBZMiniboss
                dc.w    make_art_tile(ArtTile_LBZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
LBZMiniSK_CoverAttributes:
                dc.w    $200
                dc.b    $20, $20,   3,   0
LBZMinibossSK_Arm_PartialAttributePrefix:
                dc.w    $180
                dc.b    8,   8,   6, $98
LBZMiniSK_CoverChild:
                dc.w    1-1
                dc.l    LBZMiniSK_CoverFollowDispatchAndDraw
                dc.b    0,   0
LBZMiniSK_FixedArmLinkedChildren:
                dc.w    6-1
                dc.l    LBZMiniSK_ArmDispatchAndCheckLife
LBZMiniSK_RemovableArmLinkedChildren:
                dc.w    6-1
                dc.l    LBZMiniSK_MarkRemovableChain
LBZMiniSK_RamAnimationSeed:
                dc.b    $F,   0,   1,   0,   2, $FC
LBZMiniSK_CoverOpeningAnimation:
                dc.b    7,   3,   4,   5
                dc.b    $F8, .jump-LBZMiniSK_CoverOpeningAnimation

                .jump:
                dc.b    $3F,   5,   5,   5
                dc.b    $F8, .jump2-.jump

                .jump2:
                dc.b    7,   5,   4,   3,   4, $FC
Pal_LBZMiniboss:
                binclude "data/Levels/LBZ/Palettes/Miniboss.bin"
                even

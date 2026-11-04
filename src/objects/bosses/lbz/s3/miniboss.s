; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniboss_Index(pc,d0.w),d1
                jsr     LBZMiniboss_Index(pc,d1.w)
                bsr.w   HandleLBZMinibossHitRiseArmLossOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZMiniboss_Index:
                dc.w    LBZMiniS3_InitBodyCoverAndArms-LBZMiniboss_Index
                dc.w    LBZMiniS3_TickInitialMotionWait-LBZMiniboss_Index
                dc.w    LBZMiniS3_MoveAndTickInitialHold-LBZMiniboss_Index
                dc.w    LBZMiniS3_AnimateAndTickSpinUp-LBZMiniboss_Index
                dc.w    LBZMiniS3_ChasePlayerWithDeadbands-LBZMiniboss_Index
                dc.w    LBZMiniS3_RiseDuringHitFlash-LBZMiniboss_Index
; ---------------------------------------------------------------------------

LBZMiniS3_InitBodyCoverAndArms:
                lea     ObjDat_LBZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$10,$2E(a0)
                move.l  #LBZMiniS3_BeginVerticalHold,$34(a0)
                lea     Pal_LBZMiniboss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     LBZMiniS3_CoverChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     LBZMiniS3_FixedArmLinkedChildren(pc),a2
                jsr     CreateChild4_LinkListRepeated(pc)
                lea     LBZMiniS3_RemovableArmLinkedChildren(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_TickInitialMotionWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_BeginVerticalHold:
                move.b  #4,routine(a0)
                move.w  #0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZMiniS3_BeginSpinUpAndSignalCover,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_MoveAndTickInitialHold:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_BeginSpinUpAndSignalCover:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                lea     (LBZMiniS3_RamAnimationSeed).l,a1
                lea     (_unkFA82).w,a2
                moveq   #6-1,d6

LBZMiniS3_SeedSharedRamAnimation:
                move.b  (a1)+,(a2)+
                dbf     d6,LBZMiniS3_SeedSharedRamAnimation
                move.l  #_unkFA82,$30(a0)
                move.b  #$10,anim_frame_timer(a0)
                move.l  #LBZMiniS3_ShortenRamAnimDelay,$34(a0)

LBZMiniS3_ReloadSpinUpDelay:
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_AnimateAndTickSpinUp:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

; Decrease the shared animation delay until it reaches 2, then switch to pursuit
LBZMiniS3_ShortenRamAnimDelay:
                lea     (_unkFA82).w,a1
                subq.b  #1,(a1)
                cmpi.b  #2,(a1)
                bhi.s   LBZMiniS3_ReloadSpinUpDelay
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ChasePlayerWithDeadbands:
                lea     (Player_1).w,a1
                moveq   #0,d0
                moveq   #0,d1
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   LBZMiniS3_CalcChaseYDistance
                neg.w   d2
                addq.w  #2,d0

; Aim $38 pixels above player one
LBZMiniS3_CalcChaseYDistance:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                move.w  y_pos(a1),d4
                subi.w  #$38,d4
                sub.w   d4,d3
                bpl.s   LBZMiniS3_SetChaseXOutsideDeadband
                neg.w   d3
                addq.w  #2,d1

LBZMiniS3_SetChaseXOutsideDeadband:
                move.w  LBZMiniS3_ChaseSpeedWords(pc,d0.w),x_vel(a0)
                move.w  LBZMiniS3_ChaseSpeedWords(pc,d1.w),y_vel(a0)
                cmpi.w  #4,d2
                bhi.s   LBZMiniS3_SetChaseYOutsideDeadband
                clr.w   x_vel(a0)

LBZMiniS3_SetChaseYOutsideDeadband:
                cmpi.w  #4,d3
                bhi.s   LBZMiniS3_MoveAndAnimateChase
                clr.w   y_vel(a0)

LBZMiniS3_MoveAndAnimateChase:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------
LBZMiniS3_ChaseSpeedWords:
                dc.w    -$100,  $100
; ---------------------------------------------------------------------------

LBZMiniS3_RiseDuringHitFlash:
                subq.w  #2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_FinishDefeatByProfile:
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

LBZMiniS3_CoverFollowDispatchAndDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniS3_CoverStateOffsets(pc,d0.w),d1
                jsr     LBZMiniS3_CoverStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
LBZMiniS3_CoverStateOffsets:
                dc.w    LBZMiniS3_InitCoverAndAnim-LBZMiniS3_CoverStateOffsets
                dc.w    LBZMiniS3_CoverWaitForOpening-LBZMiniS3_CoverStateOffsets
                dc.w    LBZMiniS3_CoverAnimateOpening-LBZMiniS3_CoverStateOffsets
; ---------------------------------------------------------------------------

LBZMiniS3_InitCoverAndAnim:
                lea     LBZMiniS3_CoverAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZMiniS3_CoverOpeningAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_CoverWaitForOpening:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   LBZMiniS3_CoverBeginOpening
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_CoverBeginOpening:
                move.b  #4,routine(a0)
                move.l  #LBZMiniS3_CoverOpeningAnimation,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_CoverAnimateOpening:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_MarkRemovableChain:
                bset    #2,$38(a0)

LBZMiniS3_ArmDispatchAndCheckLife:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniS3_ArmStateOffsets(pc,d0.w),d1
                jsr     LBZMiniS3_ArmStateOffsets(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   LBZMiniS3_ArmCheckLinkedLifetime
                jmp     LBZMiniS3_ArmCheckBossDeathOrLoss(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmCheckLinkedLifetime:
                jmp     LBZMiniS3_ArmCheckPropagatedDetach(pc)
; ---------------------------------------------------------------------------
LBZMiniS3_ArmStateOffsets:
                dc.w    LBZMiniS3_InitArmGeometry-LBZMiniS3_ArmStateOffsets
                dc.w    LBZMiniS3_ArmRefreshFirstNode-LBZMiniS3_ArmStateOffsets
                dc.w    LBZMiniS3_ArmRotateWhileActive-LBZMiniS3_ArmStateOffsets
                dc.w    LBZMiniS3_ArmFollowPreviousAngle-LBZMiniS3_ArmStateOffsets
                dc.w    LBZMiniS3_ArmAdvanceAndPlace-LBZMiniS3_ArmStateOffsets
                dc.w    LBZMiniS3_ArmPlaceStoppedEndNode-LBZMiniS3_ArmStateOffsets
; ---------------------------------------------------------------------------

LBZMiniS3_InitArmGeometry:
                lea     LBZMinibossS3_Arm_PartialAttributePrefix(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  #$100,$2E(a0)
                move.l  #LBZMiniS3_ArmBeginActivationDelay,$34(a0)
                move.b  #4,$3D(a0)
                move.w  #5,$3E(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   LBZMiniS3_ArmApplySubtypeAppearance
                move.w  #4,$3E(a0)
                bset    #1,$38(a0)

LBZMiniS3_ArmApplySubtypeAppearance:
                bra.w   LBZMiniS3_ArmLoadSubtypePose
; ---------------------------------------------------------------------------

LBZMiniS3_ArmRefreshFirstNode:
                tst.b   subtype(a0)
                bne.s   LBZMiniS3_ArmPlaceAndTickInitialWait
                jsr     Refresh_ChildPositionAdjusted(pc)

LBZMiniS3_ArmPlaceAndTickInitialWait:
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmBeginActivationDelay:
                move.b  #4,routine(a0)
                bsr.w   SetLBZMinibossArmActivationDelay
                move.l  #LBZMiniS3_ArmStartAndActivatePrev,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ArmRotateWhileActive:
                btst    #1,$38(a0)
                beq.s   LBZMiniS3_ArmPlaceDormantNode
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmPlaceDormantNode:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

LBZMiniS3_ArmStartAndActivatePrev:
                bsr.w   SetLBZMinibossArmRotationDelay
                move.l  #LBZMiniS3_ArmReverseAndResetPhase,$34(a0)
                tst.b   subtype(a0)
                beq.s   LBZMiniS3_ArmFirstNodeRotate
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)
                move.b  $3C(a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ArmFirstNodeRotate:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ArmFollowPreviousAngle:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   LBZMiniS3_ArmRotateAfterPrevStops
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ArmRotateAfterPrevStops:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_ArmAdvanceAndPlace:
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                jsr     Obj_Wait(pc)
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmReverseAndResetPhase:
                bclr    #1,$38(a0)
                neg.b   $3D(a0)
                bsr.w   LBZMiniS3_ArmBeginActivationDelay
                cmpi.b  #$A,subtype(a0)
                bne.s   LBZMiniS3_ArmChooseChainPhaseBank
                move.b  #$A,routine(a0)
                move.w  #$3C,$2E(a0)
                move.l  #LBZMiniS3_ArmBeginActivationDelay,$34(a0)
                bset    #1,$38(a0)

LBZMiniS3_ArmChooseChainPhaseBank:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                moveq   #0,d1
                btst    #2,$38(a0)
                beq.s   LBZMiniS3_ArmChooseReversePhaseBank
                addq.w  #8,d1

LBZMiniS3_ArmChooseReversePhaseBank:
                tst.b   $3D(a0)
                bpl.s   LBZMiniS3_ArmLoadResetPhase
                addq.w  #4,d1

LBZMiniS3_ArmLoadResetPhase:
                movea.l LBZMiniS3_ArmResetPhaseBankPointers(pc,d1.w),a1
                move.b  (a1,d0.w),$3C(a0)
                rts
; ---------------------------------------------------------------------------
LBZMiniS3_ArmResetPhaseBankPointers:
                dc.l    LBZMiniS3_FixedArmPositivePhases
                dc.l    LBZMiniS3_FixedArmNegativePhases
                dc.l    LBZMiniS3_RemovableArmPositivePhases
                dc.l    LBZMiniS3_RemovableArmNegativePhases
; ---------------------------------------------------------------------------

LBZMiniS3_ArmPlaceStoppedEndNode:
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_DetachedArmFallAndDraw:
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZMiniS3_ArmLoadSubtypePose:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMiniS3_ArmPrioritiesBySubtype(pc,d0.w),priority(a0)
                lsr.w   #1,d0
                move.b  LBZMiniS3_ArmFramesBySubtype(pc,d0.w),mapping_frame(a0)
                move.b  LBZMiniS3_FixedArmPositivePhases(pc,d0.w),$3C(a0)
                btst    #2,$38(a0)
                beq.s   LBZMiniS3_ArmPlaceInitialPose
                move.b  LBZMiniS3_RemovableArmPositivePhases(pc,d0.w),$3C(a0)

LBZMiniS3_ArmPlaceInitialPose:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------
LBZMiniS3_ArmPrioritiesBySubtype:
                dc.w    $300,  $380,  $300,  $380,  $300,  $280
LBZMiniS3_ArmFramesBySubtype:
                dc.b    7,   8,   7,   8,   7,   6
LBZMiniS3_FixedArmPositivePhases:
                dc.b    $55,   0, $D5, $AA, $80, $68
LBZMiniS3_FixedArmNegativePhases:
                dc.b    $2A, $7A, $B0, $DA,   0, $18
LBZMiniS3_RemovableArmPositivePhases:
                dc.b    $D5, $80, $55, $2A,   0, $F4
LBZMiniS3_RemovableArmNegativePhases:
                dc.b    $AA,   0, $2A, $55, $80, $8C
                even

; =============== S U B R O U T I N E =======================================

SetLBZMinibossArmActivationDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMinibossS3_Arm_SixActivationWaitWords(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmActivationDelay

; ---------------------------------------------------------------------------
LBZMinibossS3_Arm_SixActivationWaitWords:
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
                move.w  LBZMinibossS3_Arm_SixRotationWaitWords(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmRotationDelay

; ---------------------------------------------------------------------------
LBZMinibossS3_Arm_SixRotationWaitWords:
                dc.w    $34
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    3
; ---------------------------------------------------------------------------

HandleLBZMinibossHitRiseArmLossOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   LBZMiniS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   LBZMiniS3_BeginDefeatExplosion
                cmpi.b  #3,collision_property(a0)
                bne.s   LBZMiniS3_SaveRoutineAndBeginHitRise
                bset    #0,$38(a0)

LBZMiniS3_SaveRoutineAndBeginHitRise:
                tst.b   $20(a0)
                bne.s   LBZMiniS3_TickFlashAndRestoreRoutine
                move.b  routine(a0),$3A(a0)
                move.b  #$A,routine(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

LBZMiniS3_TickFlashAndRestoreRoutine:
                jsr     BossFlash(pc)
                subq.b  #1,$20(a0)
                bne.s   LBZMiniS3_HitUpdateReturn
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)

LBZMiniS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZMiniS3_BeginDefeatExplosion:
                move.l  #Wait_Draw,(a0)
                move.l  #LBZMiniS3_FinishDefeatByProfile,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmCheckBossDeathOrLoss:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZMiniS3_ArmPropagateDetach
                btst    #0,$38(a1)
                beq.s   LBZMiniS3_ArmTouchDraw
                btst    #2,$38(a0)
                bne.s   LBZMiniS3_ArmPropagateDetach

LBZMiniS3_ArmTouchDraw:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

; Mark the next linked segment before detaching the current one
LBZMiniS3_ArmPropagateDetach:
                move.w  $44(a0),d0
                beq.s   LBZMiniS3_ArmDetachAndDraw
                movea.w d0,a1
                bset    #7,status(a1)

LBZMiniS3_ArmDetachAndDraw:
                bsr.w   DetachLBZMinibossArmSegmentWithGravity
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZMiniS3_ArmCheckPropagatedDetach:
                btst    #7,status(a0)
                bne.s   LBZMiniS3_ArmPropagateDetach
                jmp     Draw_And_Touch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

DetachLBZMinibossArmSegmentWithGravity:
                move.l  #LBZMiniS3_DetachedArmFallAndDraw,(a0)
                clr.b   collision_flags(a0)
                move.w  #$80,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     LBZMiniS3_DetachVelocityPairs(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function DetachLBZMinibossArmSegmentWithGravity

; ---------------------------------------------------------------------------
LBZMiniS3_DetachVelocityPairs:
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
                dc.b    $20, $20,   0,   6
LBZMiniS3_CoverAttributes:
                dc.w    $200
                dc.b    $20, $20,   3,   0
LBZMinibossS3_Arm_PartialAttributePrefix:
                dc.w    $180
                dc.b    8,   8,   6, $98
LBZMiniS3_CoverChild:
                dc.w    1-1
                dc.l    LBZMiniS3_CoverFollowDispatchAndDraw
                dc.b    0,   0
LBZMiniS3_FixedArmLinkedChildren:
                dc.w    6-1
                dc.l    LBZMiniS3_ArmDispatchAndCheckLife
LBZMiniS3_RemovableArmLinkedChildren:
                dc.w    6-1
                dc.l    LBZMiniS3_MarkRemovableChain
LBZMiniS3_RamAnimationSeed:
                dc.b    $F,   0,   1,   0,   2, $FC
LBZMiniS3_CoverOpeningAnimation:
                dc.b    7,   3,   4,   5
                dc.b    $F8, .jump-LBZMiniS3_CoverOpeningAnimation

                .jump:
                dc.b    $3F,   5,   5,   5
                dc.b    $F8, .jump2-.jump

                .jump2:
                dc.b    7,   5,   4,   3,   4, $FC
Pal_LBZMiniboss:
                binclude "data/Levels/LBZ/Palettes/Miniboss.bin"
                even

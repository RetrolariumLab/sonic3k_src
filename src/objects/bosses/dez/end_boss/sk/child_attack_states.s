; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss child attacks, destruction effects, attached actors and battle callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; The delayed callback spawns three fragments before deleting the capsule
DEZCapsule_ExplodeThenSpawnDebris:
                move.l  #DEZBoss_CapsuleSpawnDebrisAndDelete,$34(a0)

DEZBoss_CapsuleTryBreakupExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZBoss_CapsuleDecCountAndWait
                move.b  #6,subtype(a1)

DEZBoss_CapsuleDecCountAndWait:
                move.l  #Wait_Draw,(a0)
                movea.w parent3(a0),a1
                subq.b  #1,$39(a1)
                move.w  #7,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function DEZCapsule_ExplodeThenSpawnDebris

; ---------------------------------------------------------------------------

DEZBoss_CapsuleSpawnDebrisAndDelete:
                lea     DEZBoss_CapsuleFragmentChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_CapsuleDispatchAndCheckHit:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZBossCapsule_LandedStateOffsets(pc,d0.w),d1
                jsr     DEZBossCapsule_LandedStateOffsets(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   DEZCapsule_ExplodeThenDelete
                bsr.w   DEZCapsule_CheckBossHitAndShatter
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
DEZBossCapsule_LandedStateOffsets:
                dc.w    DEZBoss_CapsuleCheckRestAndGravity-DEZBossCapsule_LandedStateOffsets
                dc.w    DEZBoss_CapsuleRollAndCheckLifetime-DEZBossCapsule_LandedStateOffsets
                dc.w    DEZBoss_CapsuleMoveDroppedState-DEZBossCapsule_LandedStateOffsets
                dc.w    DEZBoss_CapsuleTickLaunchFlip-DEZBossCapsule_LandedStateOffsets
                dc.w    DEZBoss_CapsuleExpireAndAbortTail-DEZBossCapsule_LandedStateOffsets
; ---------------------------------------------------------------------------

DEZBoss_CapsuleCheckRestAndGravity:
                bsr.w   DEZCapsule_CheckRestingContact
                bsr.w   DEZCapsule_DropIfGravityReversed
                subq.w  #1,$2E(a0)
                bmi.s   DEZBoss_CapsuleBeginExpiryWait
                rts
; ---------------------------------------------------------------------------

DEZBoss_CapsuleRollAndCheckLifetime:
                jsr     (MoveSprite2).l
                bsr.w   HandleRollingDEZCapsulePlayerContact
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                lea     DEZRollingCapsule_FixedDelayTwoFrameLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                bsr.w   DEZCapsule_DropIfGravityReversed
                subq.w  #1,$2E(a0)
                bpl.w   DEZBoss_SharedReturn

DEZBoss_CapsuleBeginExpiryWait:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_CapsuleMoveDroppedState:
                jsr     (DEZCapsule_MoveWithGravity).l

DEZBoss_CapsuleCheckCeilingLanding:
                bsr.w   DEZCapsule_CheckFallingContact
                tst.w   y_vel(a0)
                bpl.s   DEZBoss_CapsuleCheckFloorAndRoll
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   DEZBoss_CapsuleLandingCheckReturn
                sub.w   d1,y_pos(a0)
                st      $3A(a0)
                btst    #1,render_flags(a0)
                bne.s   DEZBoss_CapsuleRestoreRollSpeed

DEZBoss_CapsuleEnterRestingState:
                move.b  #0,routine(a0)
                move.b  #$C6,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_CapsuleCheckFloorAndRoll:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   DEZBoss_CapsuleLandingCheckReturn
                add.w   d1,y_pos(a0)
                clr.b   $3A(a0)
                btst    #1,render_flags(a0)
                bne.s   DEZBoss_CapsuleEnterRestingState

DEZBoss_CapsuleRestoreRollSpeed:
                move.b  #2,routine(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  $3C(a0),x_vel(a0)
                clr.w   y_vel(a0)

DEZBoss_CapsuleLandingCheckReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_CapsuleTickLaunchFlip:
                subq.w  #1,child_dx(a0)
                bne.s   DEZBoss_CapsuleMoveAndChooseDrift
                bchg    #1,render_flags(a0)

DEZBoss_CapsuleMoveAndChooseDrift:
                jsr     (DEZCapsule_MoveWithGravity).l
                bsr.w   ReverseDEZEndBossAtInclusiveWorldXBounds
                move.w  #$80,d0
                tst.w   x_vel(a0)
                bpl.s   DEZBoss_CapsuleStoreLaunchDrift
                neg.w   d0

DEZBoss_CapsuleStoreLaunchDrift:
                move.w  d0,$3C(a0)
                bra.w   DEZBoss_CapsuleCheckCeilingLanding
; ---------------------------------------------------------------------------

; After expiry, discard the dispatcher's return address to skip its draw and hit checks
DEZBoss_CapsuleExpireAndAbortTail:
                subq.w  #1,$2E(a0)
                bpl.s   DEZBoss_CapsuleExpiryReturn
                bsr.w   DEZCapsule_ExplodeThenSpawnDebris
                addq.w  #4,sp

DEZBoss_CapsuleExpiryReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_InitFragmentAndReparent:
                lea     DEZBoss_CapsuleFragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZBoss_FragmentMoveAndCull,(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   DEZCapsuleDebris_InitFrameAndVel
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_FragmentMoveAndCull:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   DEZBoss_DeleteCapsuleFragment
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

DEZBoss_DeleteCapsuleFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_InitSleeveAndOverlay:
                lea     DEZBoss_SleeveAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZBoss_SleeveFollowAndTouch,(a0)
                move.l  #DEZBoss_SleeveLoopAnim,$30(a0)
                lea     DEZBoss_SleeveOverlayChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_SleeveFollowAndTouch:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   DEZCapsuleSleeve_StartExtensionCountdown
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZCapsuleSleeve_StartExtensionCountdown:
                move.l  #DEZBoss_SleeveTickExtension,(a0)
                move.w  #$10,$2E(a0)

DEZBoss_SleeveTickExtension:
                subq.w  #1,$2E(a0)
                bmi.s   DEZBoss_SleeveHoldBeforeRetract
                bchg    #2,$38(a0)
                bne.s   DEZBoss_SleeveDrawDuringExtension
                addq.b  #1,child_dy(a0)

DEZBoss_SleeveDrawDuringExtension:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_SleeveHoldBeforeRetract:
                move.l  #DEZBoss_SleeveTickHold,(a0)
                move.w  #7,$2E(a0)

DEZBoss_SleeveTickHold:
                subq.w  #1,$2E(a0)
                bmi.s   DEZBoss_SleeveBeginRetraction
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_SleeveBeginRetraction:
                move.l  #DEZBoss_SleeveTickRetraction,(a0)

DEZBoss_SleeveTickRetraction:
                bchg    #2,$38(a0)
                bne.s   DEZBoss_SleeveAnimateAndCheckOpen
                subq.b  #1,child_dy(a0)

DEZBoss_SleeveAnimateAndCheckOpen:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   DEZBoss_DeleteSleeveAfterClose
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_DeleteSleeveAfterClose:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_InitSleeveOverlay:
                lea     DEZBoss_SleeveOverlayAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZBoss_SleeveOverlayFollowDraw,(a0)

DEZBoss_SleeveOverlayFollowDraw:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZBoss_InitEscapingRobotnik:
                lea     DEZBossExitRobotnik_FullAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #FBZAct2SK_OperatorIdleAndCheckFeedback,(a0)
                move.l  #DEZBoss_RobotnikKeepAheadOfPlayer,$34(a0)
                move.l  #DEZBossExitRobotnik_FrameDelayLoop,$30(a0)
                move.w  #$3610,x_pos(a0)
                move.w  #$324,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_RobotnikKeepAheadOfPlayer:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                sub.w   d1,d0
                bmi.s   DEZBoss_RobotnikRunAndCull
                cmpi.w  #$40,d0
                bhs.s   DEZBoss_RobotnikRunAndCull
                addi.w  #$40,d1
                move.w  d1,x_pos(a0)

DEZBoss_RobotnikRunAndCull:
                lea     (FBZAct2SK_OperatorRunAnim).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

DEZBoss_InitAftermathPiece:
                lea     DEZBossExitPanel_FullAttributeRecord(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DEZBoss_AftermathPieceReleaseFx,(a0)
                move.w  #$3600,x_pos(a0)
                move.w  #$32C,y_pos(a0)

DEZBoss_AftermathPieceReleaseFx:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   DEZBoss_AftermathPieceDraw
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #$15,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZBoss_AftermathPieceDraw
                move.b  #6,subtype(a1)

DEZBoss_AftermathPieceDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_InitDefeatFragment:
                lea     DEZBoss_DefeatFragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$22,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZBoss_InitExplosionSweep:
                move.l  #DEZBoss_TryHorizontalSweepExplosion,(a0)
                addi.w  #$38,y_pos(a0)
                move.w  #$1010,$3A(a0)
                moveq   #2,d0
                moveq   #4,d1
                tst.b   subtype(a0)
                beq.s   DEZBoss_ExplosionSweepSetStep
                neg.w   d0
                moveq   #2,d1

DEZBoss_ExplosionSweepSetStep:
                move.w  d0,x_vel(a0)
                move.b  d1,$39(a0)

DEZBoss_TryHorizontalSweepExplosion:
                subq.b  #1,$39(a0)
                bpl.s   DEZBoss_SweepMoveAndCheckRight
                move.b  #3,$39(a0)
                jsr     (BossExplosionSKSpawnAtMaskedRandomOffset).l

DEZBoss_SweepMoveAndCheckRight:
                move.w  x_vel(a0),d0
                move.w  x_pos(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                tst.w   d0
                bmi.s   DEZBoss_SweepCheckLeft
                move.w  #$35D0,d2
                cmp.w   d2,d1
                bhs.s   DEZBoss_SweepBeginRiseAndSignal
                rts
; ---------------------------------------------------------------------------

DEZBoss_SweepCheckLeft:
                move.w  #$3450,d2
                cmp.w   d2,d1
                bhi.s   DEZBoss_SweepBoundaryReturn

DEZBoss_SweepBeginRiseAndSignal:
                move.w  d2,x_pos(a0)
                move.l  #DEZBoss_TryVerticalSweepExplosion,(a0)
                move.w  #-2,y_vel(a0)
                tst.b   subtype(a0)
                bne.s   DEZBoss_SweepBoundaryReturn
                bset    #1,(SceneSyncFlagsOrMHZState).w

DEZBoss_SweepBoundaryReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_TryVerticalSweepExplosion:
                subq.b  #1,$39(a0)
                bpl.s   DEZBoss_SweepRiseAndDelete
                move.b  #3,$39(a0)
                jsr     (BossExplosionSKSpawnAtMaskedRandomOffset).l

DEZBoss_SweepRiseAndDelete:
                move.w  y_vel(a0),d0
                move.w  y_pos(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                cmpi.w  #$240,d1
                bhs.w   DEZBoss_SharedReturn
                jmp     (Delete_Current_Sprite).l

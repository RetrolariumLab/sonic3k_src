; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss attached actors, parent synchronization, movement and animation state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZBossS3_CarrierDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZBossS3_CarrierStateOffsets(pc,d0.w),d1
                jsr     MGZBossS3_CarrierStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
MGZBossS3_CarrierStateOffsets:
                dc.w    MGZBossS3_InitCarrierAndChooseDepth-MGZBossS3_CarrierStateOffsets
                dc.w    MGZBossS3_CarrierSyncAndCheckTrail-MGZBossS3_CarrierStateOffsets
; ---------------------------------------------------------------------------

MGZBossS3_InitCarrierAndChooseDepth:
                lea     MGZBossS3_CarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   MGZBossS3_CarrierSpawnDrill
                bclr    #7,art_tile(a0)

MGZBossS3_CarrierSpawnDrill:
                lea     MGZBossS3_CarrierDrillChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_CarrierSyncAndCheckTrail:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossS3_AttachmentQueueDeath
                cmpi.b  #2,subtype(a1)
                beq.s   MGZBossS3_CarrierApplyAnglePose
                btst    #1,$38(a1)
                beq.s   MGZBossS3_CarrierClearTrailLatch
                bset    #1,$38(a0)
                bne.s   MGZBossS3_CarrierApplyAnglePose
                lea     MGZBossS3_LeftTrailChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZBossS3_CarrierSpawnTrailBatch
                lea     MGZBossS3_RightTrailChildren(pc),a2

MGZBossS3_CarrierSpawnTrailBatch:
                jsr     (CreateChild3_NormalRepeated).l
                bra.w   MGZBossS3_CarrierApplyAnglePose
; ---------------------------------------------------------------------------

MGZBossS3_CarrierClearTrailLatch:
                bclr    #1,$38(a0)

MGZBossS3_CarrierApplyAnglePose:
                lea     MGZBossS3_CarrierAngleFrameDepth(pc),a2
                bsr.w   MGZBossPart_SelectFrameAndDepth
                lea     MGZBossS3_CarrierAngleOffsets(pc),a2
                bsr.w   MGZBossPart_SetOffsetsFromAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

MGZBossS3_AttachmentQueueDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZBossS3_DrillStateOffsets(pc,d0.w),d1
                jsr     MGZBossS3_DrillStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
MGZBossS3_DrillStateOffsets:
                dc.w    MGZBossS3_InitDrillAndCacheBoss-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillFollowUntilExtension-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillCheckAttackAndRetract-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillRetractAndFollow-MGZBossS3_DrillStateOffsets
                dc.w    MGZEndBossS3_Drill_MoveAnimateAndWait-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillAnimateAndTickWait-MGZBossS3_DrillStateOffsets
                dc.w    MGZEndBossS3_Drill_MoveAnimateAndWait-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillAnimateAndTickWait-MGZBossS3_DrillStateOffsets
                dc.w    MGZEndBossS3_Drill_MoveAnimateAndWait-MGZBossS3_DrillStateOffsets
                dc.w    MGZBossS3_DrillWaitForPairAck-MGZBossS3_DrillStateOffsets
; ---------------------------------------------------------------------------

MGZBossS3_InitDrillAndCacheBoss:
                lea     MGZBossS3_DrillAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillFollowUntilExtension:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossS3_AttachmentQueueDeath
                btst    #3,$38(a1)
                bne.s   MGZBossS3_DrillBeginExtension
                lea     MGZBossS3_DrillAngleFrameDepth(pc),a2
                bsr.w   MGZBossPart_SelectFrameAndDepth

MGZBossS3_DrillApplyCarrierPose:
                lea     MGZBossS3_DrillAngleOffsets(pc),a2
                bsr.w   MGZBossPart_SetOffsetsFromAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillBeginExtension:
                move.b  #4,routine(a0)
                bra.w   MGZBossS3_LoadDrillExtensionAnim
; ---------------------------------------------------------------------------

MGZBossS3_DrillCheckAttackAndRetract:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.w   MGZBossS3_AttachmentQueueDeath
                btst    #3,$38(a1)
                beq.s   MGZEndBossS3_Drill_StartRetractAnimation
                btst    #1,$38(a1)
                bne.s   MGZBossS3_DrillBeginOrdinaryPass
                jsr     (Animate_RawMultiDelay).l
                bra.s   MGZBossS3_DrillApplyCarrierPose
; ---------------------------------------------------------------------------

MGZEndBossS3_Drill_StartRetractAnimation:
                move.b  #6,routine(a0)
                move.l  #MGZBossS3_DrillFinishRetraction,$34(a0)
                bra.w   MGZBossS3_LoadDrillRetractionAnim
; ---------------------------------------------------------------------------

MGZBossS3_DrillBeginOrdinaryPass:
                cmpi.b  #2,subtype(a1)
                beq.s   MGZBossS3_DrillBeginUpperPass
                move.b  #8,routine(a0)
                move.w  #$27,$2E(a0)
                move.l  #MGZBossS3_DrillPauseAndSignalCarrier,$34(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bclr    #5,$38(a0)
                lea     MGZBossS3_DrillPoseCoverChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillBeginUpperPass:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #MGZBossS3_DrillPauseAfterUpperPass,$34(a0)
                bclr    #2,$38(a0)
                bsr.w   LaunchMGZBossUpperDrillPassAndRecordPlan
                lea     MGZBossS3_DrillPassEmitterChild(pc),a2
                jsr     (CreateChild1_Normal).l

MGZBossS3_DrillSpawnTemporaryCover:
                bclr    #5,$38(a0)
                lea     MGZBossS3_DrillPoseCoverChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillRetractAndFollow:
                jsr     (Animate_RawMultiDelay).l
                bra.w   MGZBossS3_DrillApplyCarrierPose
; ---------------------------------------------------------------------------

MGZBossS3_DrillFinishRetraction:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                movea.w $44(a0),a1
                move.l  #MGZBossS3_DrillPauseAndSignalCarrier,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossS3_Drill_MoveAnimateAndWait:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillPauseAndSignalCarrier:
                move.b  #$A,routine(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.w  #0,$2E(a0)
                move.l  #MGZBossS3_DrillReverseForReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillAnimateAndTickWait:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_DrillReverseForReturn:
                move.b  #8,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                neg.w   x_vel(a0)
                move.w  #$27,$2E(a0)
                move.l  #MGZBossS3_DrillFinishOrdinaryPass,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillFinishOrdinaryPass:
                move.b  #4,routine(a0)
                movea.w $44(a0),a1
                bset    #5,$38(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillPauseAfterUpperPass:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossS3_DrillBeginLowerPass,$34(a0)
                bset    #5,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillBeginLowerPass:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #MGZBossS3_DrillSignalPairComplete,$34(a0)
                bsr.w   LaunchMGZBossLowerDrillPassFromUpperPlan
                lea     MGZBossS3_DrillPassEmitterChild(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   MGZBossS3_DrillFinishLowerPassSetup
                move.b  #2,subtype(a1)

MGZBossS3_DrillFinishLowerPassSetup:
                bra.w   MGZBossS3_DrillSpawnTemporaryCover
; ---------------------------------------------------------------------------

; Signal the boss after both passes and move the drill up $80 pixels while it waits
MGZBossS3_DrillSignalPairComplete:
                move.b  #$12,routine(a0)
                ori.b   #$24,$38(a0)
                movea.w $44(a0),a1
                bset    #2,$38(a1)
                bclr    #1,$38(a1)
                subi.w  #$80,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DrillWaitForPairAck:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossS3_DrillPairPollReturn
                move.b  #4,routine(a0)

MGZBossS3_DrillPairPollReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_InitRootCover:
                lea     MGZBossS3_RootCoverAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossS3_RootCoverFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_RootCoverFollowAndDraw:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   MGZBossS3_AttachmentQueueDeath
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

MGZBossS3_InitTemporaryCoverPose:
                lea     MGZBossS3_DrillAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                clr.b   collision_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #MGZBossS3_TemporaryCoverFollow,(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  MGZBossS3_TemporaryCoverOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                lsr.w   #1,d0
                move.b  MGZBossS3_TemporaryCoverFrames(pc,d0.w),mapping_frame(a0)
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------
MGZBossS3_TemporaryCoverOffsets:
                dc.b    $C,   0
                dc.b    3,  -7
                dc.b    0,-$10
                dc.b    -3,  -7
                dc.b    -$C,   0
                dc.b    -3,   7
                dc.b    0, $10
                dc.b    $C,   0
MGZBossS3_TemporaryCoverFrames:
                dc.b    $1C, $15, $2C, $2A, $2D, $2B, $29, $1C
                even
; ---------------------------------------------------------------------------

MGZBossS3_TemporaryCoverFollow:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZEndBossS3_PoseMarker_ScheduleDeletion
                btst    #4,$38(a1)
                bne.s   MGZEndBossS3_PoseMarker_ScheduleDeletion
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZEndBossS3_PoseMarker_ScheduleDeletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_InitPassEmitter:
                move.l  #MGZBossS3_PassEmitterWaitOrDelete,(a0)
                move.l  #MGZBossS3_PassEmitterTryProjectile,$34(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  render_flags(a1),render_flags(a0)
                move.w  #4,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_PassEmitterWaitOrDelete:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossS3_DeletePassEmitter
                btst    #4,$38(a1)
                bne.s   MGZBossS3_DeletePassEmitter
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_DeletePassEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_PassEmitterTryProjectile:
                move.w  #4,$2E(a0)
                lea     MGZBossS3_EmitterProjectileChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_InitPassShotAndCacheDrill:
                lea     MGZBossS3_TrailAndShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossS3_PassShotMoveUntilPassEnd,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),angle(a0)
                move.w  subtype(a1),subtype(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bra.w   MGZBossS3_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

MGZBossS3_PassShotMoveUntilPassEnd:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossS3_PassShotTrackCarrier
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   MGZBossS3_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

MGZBossS3_PassShotTrackCarrier:
                move.l  #MGZBossS3_PassShotCheckCleanupY,(a0)
                movea.w $44(a0),a1
                move.w  parent3(a1),$44(a0)
                bra.w   MGZBossS3_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

; Use the carrier height only when the boss is in the shot's pass subtype
MGZBossS3_PassShotCheckCleanupY:
                movea.w $44(a0),a1
                movea.w parent3(a1),a2
                move.w  y_pos(a1),d0
                move.b  subtype(a2),d1
                cmp.b   subtype(a0),d1
                bne.s   MGZBossS3_PassShotDraw
                tst.b   d1
                bne.s   MGZBossS3_PassShotCheckLowerPass
                moveq   #$10,d1
                btst    #1,(SceneTimerLowByteOrSecondAttackDone).w
                bne.s   MGZBossS3_PassShotCheckUpperY
                moveq   #$18,d1

MGZBossS3_PassShotCheckUpperY:
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bcs.s   MGZBossS3_PassShotDraw

MGZBossS3_PassShotQueueDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_PassShotCheckLowerPass:
                moveq   #$14,d1
                btst    #1,(DDZScrollAccelOrSceneMotion+1).w
                bne.s   MGZBossS3_PassShotCheckLowerY
                moveq   #$1C,d1

MGZBossS3_PassShotCheckLowerY:
                sub.w   d1,d0
                cmp.w   y_pos(a0),d0
                bls.s   MGZBossS3_PassShotQueueDeath

MGZBossS3_PassShotDraw:
                bra.w   MGZBossS3_PassShotCheckBossDefeat

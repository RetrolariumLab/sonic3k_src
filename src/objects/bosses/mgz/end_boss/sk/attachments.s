; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss attached actors, parent synchronization, movement and animation state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZBossSK_CarrierDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZBossSK_CarrierStateOffsets(pc,d0.w),d1
                jsr     MGZBossSK_CarrierStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
MGZBossSK_CarrierStateOffsets:
                dc.w    MGZBossSK_InitCarrierAndChooseDepth-MGZBossSK_CarrierStateOffsets
                dc.w    MGZBossSK_CarrierSyncAndCheckTrail-MGZBossSK_CarrierStateOffsets
; ---------------------------------------------------------------------------

MGZBossSK_InitCarrierAndChooseDepth:
                lea     MGZBossSK_CarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   MGZBossSK_CarrierSpawnDrill
                bclr    #7,art_tile(a0)

MGZBossSK_CarrierSpawnDrill:
                lea     MGZBossSK_CarrierDrillChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_CarrierSyncAndCheckTrail:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossSK_AttachmentQueueDeath
                cmpi.b  #2,subtype(a1)
                beq.s   MGZBossSK_CarrierApplyAnglePose
                btst    #1,$38(a1)
                beq.s   MGZBossSK_CarrierClearTrailLatch
                bset    #1,$38(a0)
                bne.s   MGZBossSK_CarrierApplyAnglePose
                lea     MGZBossSK_LeftTrailChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZBossSK_CarrierSpawnTrailBatch
                lea     MGZBossSK_RightTrailChildren(pc),a2

MGZBossSK_CarrierSpawnTrailBatch:
                jsr     (CreateChild3_NormalRepeated).l
                bra.w   MGZBossSK_CarrierApplyAnglePose
; ---------------------------------------------------------------------------

MGZBossSK_CarrierClearTrailLatch:
                bclr    #1,$38(a0)

MGZBossSK_CarrierApplyAnglePose:
                lea     MGZBossSK_CarrierAngleFrameDepth(pc),a2
                bsr.w   MGZBossPart_SelectFrameAndDepth
                lea     MGZBossSK_CarrierAngleOffsets(pc),a2
                bsr.w   MGZBossPart_SetOffsetsFromAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

MGZBossSK_AttachmentQueueDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBossSK_Drill_StateOffsets(pc,d0.w),d1
                jsr     MGZEndBossSK_Drill_StateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
MGZEndBossSK_Drill_StateOffsets:
                dc.w    MGZBossSK_InitDrillAndCacheBoss-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillFollowUntilExtension-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillCheckAttackAndRetract-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillRetractAndFollow-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZEndBossSK_Drill_MoveAnimateThenWait-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillAnimateAndTickWait-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZEndBossSK_Drill_MoveAnimateThenWait-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillAnimateAndTickWait-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZEndBossSK_Drill_MoveAnimateThenWait-MGZEndBossSK_Drill_StateOffsets
                dc.w    MGZBossSK_DrillWaitForPairAck-MGZEndBossSK_Drill_StateOffsets
; ---------------------------------------------------------------------------

MGZBossSK_InitDrillAndCacheBoss:
                lea     MGZBossSK_DrillAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillFollowUntilExtension:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossSK_AttachmentQueueDeath
                btst    #3,$38(a1)
                bne.s   MGZBossSK_DrillBeginExtension
                lea     MGZEndBossSK_Drill_FrameDepthPairs(pc),a2
                bsr.w   MGZBossPart_SelectFrameAndDepth

MGZBossSK_DrillApplyCarrierPose:
                lea     MGZBossSK_DrillAngleOffsets(pc),a2
                bsr.w   MGZBossPart_SetOffsetsFromAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillBeginExtension:
                move.b  #4,routine(a0)
                bra.w   MGZBossSK_LoadDrillExtensionAnim
; ---------------------------------------------------------------------------

MGZBossSK_DrillCheckAttackAndRetract:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.w   MGZBossSK_AttachmentQueueDeath
                btst    #3,$38(a1)
                beq.s   MGZBossSK_DrillBeginRetraction
                btst    #1,$38(a1)
                bne.s   MGZBossSK_DrillBeginOrdinaryPass
                jsr     (Animate_RawMultiDelay).l
                bra.s   MGZBossSK_DrillApplyCarrierPose
; ---------------------------------------------------------------------------

MGZBossSK_DrillBeginRetraction:
                move.b  #6,routine(a0)
                move.l  #MGZBossSK_DrillFinishRetraction,$34(a0)
                bra.w   MGZBossSK_LoadDrillRetractionAnim
; ---------------------------------------------------------------------------

MGZBossSK_DrillBeginOrdinaryPass:
                cmpi.b  #2,subtype(a1)
                beq.s   MGZBossSK_DrillBeginUpperPass
                move.b  #8,routine(a0)
                move.w  #$27,$2E(a0)
                move.l  #MGZBossSK_DrillPauseAndSignalCarrier,$34(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bclr    #5,$38(a0)
                lea     MGZBossSK_DrillPoseCoverChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillBeginUpperPass:
                move.b  #8,routine(a0)
                move.w  #$37,$2E(a0)
                move.l  #MGZBossSK_DrillPauseAfterUpperPass,$34(a0)
                bclr    #2,$38(a0)
                bsr.w   LaunchMGZBossUpperDrillPassAndRecordPlan
                lea     MGZEndBossSK_Drill_OneTrailEmitterRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     MGZBossSK_CollapseEmitterChild(pc),a2
                jsr     (CreateChild6_Simple).l

MGZBossSK_DrillSpawnTemporaryCover:
                bclr    #5,$38(a0)
                lea     MGZBossSK_DrillPoseCoverChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillRetractAndFollow:
                jsr     (Animate_RawMultiDelay).l
                bra.w   MGZBossSK_DrillApplyCarrierPose
; ---------------------------------------------------------------------------

MGZBossSK_DrillFinishRetraction:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                movea.w $44(a0),a1
                move.l  #MGZBossSK_DrillPauseAndSignalCarrier,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossSK_Drill_MoveAnimateThenWait:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillPauseAndSignalCarrier:
                move.b  #$A,routine(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.w  #0,$2E(a0)
                move.l  #MGZBossSK_DrillReverseForReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillAnimateAndTickWait:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_DrillReverseForReturn:
                move.b  #8,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                neg.w   x_vel(a0)
                move.w  #$27,$2E(a0)
                move.l  #MGZBossSK_DrillFinishOrdinaryPass,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillFinishOrdinaryPass:
                move.b  #4,routine(a0)
                movea.w $44(a0),a1
                bset    #5,$38(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillPauseAfterUpperPass:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossSK_DrillBeginLowerPass,$34(a0)
                bset    #5,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillBeginLowerPass:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #MGZBossSK_DrillSignalPairComplete,$34(a0)
                bsr.w   LaunchMGZBossLowerDrillPassFromUpperPlan
                lea     MGZEndBossSK_Drill_OneTrailEmitterRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   MGZBossSK_DrillFinishLowerPassSetup
                move.b  #2,subtype(a1)

MGZBossSK_DrillFinishLowerPassSetup:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     MGZBossSK_CollapseEmitterChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bra.w   MGZBossSK_DrillSpawnTemporaryCover
; ---------------------------------------------------------------------------

; Signal the boss after both passes and move the drill up $80 pixels while it waits
MGZBossSK_DrillSignalPairComplete:
                move.b  #$12,routine(a0)
                ori.b   #$24,$38(a0)
                movea.w $44(a0),a1
                bset    #2,$38(a1)
                bclr    #1,$38(a1)
                subi.w  #$80,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_DrillWaitForPairAck:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossSK_DrillPairPollReturn
                move.b  #4,routine(a0)

MGZBossSK_DrillPairPollReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossSK_InitRootCover:
                lea     MGZBossSK_RootCoverAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossSK_RootCoverFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_RootCoverFollowAndDraw:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   MGZBossSK_AttachmentQueueDeath
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

MGZBossSK_InitTemporaryCoverPose:
                lea     MGZBossSK_DrillAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                clr.b   collision_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #MGZBossSK_TemporaryCoverFollow,(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  MGZBossSK_TemporaryCoverOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                lsr.w   #1,d0
                move.b  MGZBossSK_TemporaryCoverFrames(pc,d0.w),mapping_frame(a0)
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------
MGZBossSK_TemporaryCoverOffsets:
                dc.b    $C,   0
                dc.b    3,  -7
                dc.b    0,-$10
                dc.b    -3,  -7
                dc.b    -$C,   0
                dc.b    -3,   7
                dc.b    0, $10
                dc.b    $C,   0
MGZBossSK_TemporaryCoverFrames:
                dc.b    $1C, $15, $2C, $2A, $2D, $2B, $29, $1C
                even
; ---------------------------------------------------------------------------

MGZBossSK_TemporaryCoverFollow:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossSK_TemporaryCoverQueueDeath
                btst    #4,$38(a1)
                bne.s   MGZBossSK_TemporaryCoverQueueDeath
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_TemporaryCoverQueueDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_InitPassEmitter:
                move.l  #MGZBossSK_PassEmitterWaitOrDelete,(a0)
                move.l  #MGZBossSK_PassEmitterTryProjectile,$34(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  render_flags(a1),render_flags(a0)
                bclr    #7,render_flags(a0)
                move.w  #4,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_PassEmitterWaitOrDelete:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossSK_DeletePassEmitter
                btst    #4,$38(a1)
                bne.s   MGZBossSK_DeletePassEmitter
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_DeletePassEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_PassEmitterTryProjectile:
                move.w  #4,$2E(a0)
                lea     MGZBossSK_EmitterProjectileChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_InitPassShotAndCacheDrill:
                lea     MGZBossSK_TrailShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossSK_PassShotMoveUntilPassEnd,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),angle(a0)
                move.w  subtype(a1),subtype(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bra.w   MGZBossSK_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

MGZBossSK_PassShotMoveUntilPassEnd:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   MGZBossSK_PassShotTrackCarrier
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   MGZBossSK_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

MGZBossSK_PassShotTrackCarrier:
                move.l  #MGZBossSK_PassShotCheckCleanupY,(a0)
                movea.w $44(a0),a1
                move.w  parent3(a1),$44(a0)
                bra.w   MGZBossSK_PassShotCheckBossDefeat
; ---------------------------------------------------------------------------

; Use the carrier height only when the boss is in the shot's pass subtype
MGZBossSK_PassShotCheckCleanupY:
                movea.w $44(a0),a1
                movea.w parent3(a1),a2
                move.w  y_pos(a1),d0
                move.b  subtype(a2),d1
                cmp.b   subtype(a0),d1
                bne.s   MGZBossSK_PassShotDraw
                tst.b   d1
                bne.s   MGZBossSK_PassShotCheckLowerPass
                moveq   #8,d1
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                blt.s   MGZBossSK_PassShotDraw

MGZBossSK_PassShotQueueDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_PassShotCheckLowerPass:
                moveq   #8,d1
                sub.w   d1,d0
                cmp.w   y_pos(a0),d0
                ble.s   MGZBossSK_PassShotQueueDeath

MGZBossSK_PassShotDraw:
                bra.w   MGZBossSK_PassShotCheckBossDefeat

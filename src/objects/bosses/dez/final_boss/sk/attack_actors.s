; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss secondary attack and defeat actors, scene callbacks and child state progression
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

DEZFinal_FlameDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZFinalFlameSegment_StateOffsets(pc,d0.w),d1
                jsr     DEZFinalFlameSegment_StateOffsets(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   DEZFinal_FlameSetXAndTouch
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZFinal_FlameSetXAndTouch:
                bsr.s   DEZFinalAttack_SetXFromParent
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
DEZFinalFlameSegment_StateOffsets:
                dc.w    DEZFinal_InitFlameAndChooseScript-DEZFinalFlameSegment_StateOffsets
                dc.w    DEZFinal_FlameAdvanceFrameAndOffsets-DEZFinalFlameSegment_StateOffsets
; ---------------------------------------------------------------------------

DEZFinal_InitFlameAndChooseScript:
                lea     DEZFinalScriptedAttack_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #2,d0
                bne.s   DEZFinal_FlameStoreScript
                bset    #0,render_flags(a0)

DEZFinal_FlameStoreScript:
                lsl.w   #2,d0
                move.l  DEZFinal_FlameScriptsBySubtype(pc,d0.w),$30(a0)
                rts
; ---------------------------------------------------------------------------
DEZFinal_FlameScriptsBySubtype:
                dc.l    DEZFinal_FlameParentXYScript
                dc.l    DEZFinal_FlameParentXScript
                dc.l    DEZFinal_FlameFlippedParentXScript
; ---------------------------------------------------------------------------

DEZFinal_FlameAdvanceFrameAndOffsets:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   DEZFinal_FlameStepReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #4,d0
                move.b  d0,anim_frame(a0)
                movea.l $30(a0),a1
                lea     (a1,d0.w),a1
                move.b  (a1)+,d1
                bmi.s   DEZFinal_FlameDeleteOnNegativeFrame
                move.b  d1,mapping_frame(a0)
                move.b  (a1)+,anim_frame_timer(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$42(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$44(a0)

DEZFinal_FlameStepReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_FlameDeleteOnNegativeFrame:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
DEZFinal_FlameParentXYScript:
                dc.b    6,   0,   0,   0
                dc.b    7,   1,   0,   4
                dc.b    8,   4,   0,   4
                dc.b    9,   4,   0,   0
                dc.b    $A,   5,   0,   4
                dc.b    $B,   5,   0,   0
                dc.b    $FF, $F4
DEZFinal_FlameParentXScript:
                dc.b    $C,   0,   0,   0
                dc.b    $D,   1,   4,  -4
                dc.b    $E,   4,   4,  -4
                dc.b    $F,   4,   0,   0
                dc.b    $10,   5,   0,   0
                dc.b    $11,   5,   0,   4
                dc.b    $FF, $F4
DEZFinal_FlameFlippedParentXScript:
                dc.b    $C,   0,   0,   0
                dc.b    $D,   1,   4,  -4
                dc.b    $E,   4,   4,  -4
                dc.b    $F,   4,   0,   0
                dc.b    $10,   5,   0,   0
                dc.b    $12,   5,   4,  -4
                dc.b    $FF, $F4
; ---------------------------------------------------------------------------

DEZFinal_ArmDispatchOrSignalDefeat:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZFinalArmController_StateOffsets(pc,d0.w),d1
                jsr     DEZFinalArmController_StateOffsets(pc,d1.w)
                move.b  $3A(a0),d0
                andi.b  #7,d0
                cmpi.b  #7,d0
                beq.s   DEZFinal_ArmChooseDefeatSide
                bra.w   DEZFinalAttack_SetXFromParent
; ---------------------------------------------------------------------------

DEZFinal_ArmChooseDefeatSide:
                lea     (SceneTimerOrSharedMotionRecordBase).w,a1
                tst.b   subtype(a0)
                beq.s   DEZFinal_ArmSignalDefeatAndDelete
                lea     (SceneTimerLowByteOrSecondAttackDone).w,a1

DEZFinal_ArmSignalDefeatAndDelete:
                st      (a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
DEZFinalArmController_StateOffsets:
                dc.w    DEZFinal_InitArmSegmentsAndSide-DEZFinalArmController_StateOffsets
                dc.w    DEZFinal_ArmTrackOrBeginImpact-DEZFinalArmController_StateOffsets
                dc.w    DEZFinalArmController_MoveAndWait-DEZFinalArmController_StateOffsets
                dc.w    DEZFinalArmController_AnimateImpact-DEZFinalArmController_StateOffsets
                dc.w    DEZFinal_ArmWaitBeforeRetract-DEZFinalArmController_StateOffsets
                dc.w    DEZFinalArmController_AnimateRetraction-DEZFinalArmController_StateOffsets
                dc.w    DEZFinalArmController_MoveAndWait-DEZFinalArmController_StateOffsets
; ---------------------------------------------------------------------------

DEZFinal_InitArmSegmentsAndSide:
                move.b  #2,routine(a0)
                move.b  #3,$39(a0)
                lea     DEZFinalArmSegments_NormalChildRecords(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #-$80,d0
                tst.b   subtype(a0)
                beq.s   DEZFinal_ArmSetOffsetAndStartY
                neg.w   d0

DEZFinal_ArmSetOffsetAndStartY:
                move.w  d0,$42(a0)
                move.w  #$E3,y_pos(a0)

DEZFinal_ArmTrackOrBeginImpact:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   DEZFinal_ArmBeginImpactRise
                move.w  (Player_1+x_pos).w,d0
                move.w  x_pos(a0),d1
                move.b  $3A(a0),d2
                moveq   #0,d3
                lsr.b   #1,d2
                bcc.s   DEZFinal_ArmCalcPlayerDelta
                moveq   #-$20,d3
                lsr.b   #1,d2
                bcc.s   DEZFinal_ArmCalcPlayerDelta
                moveq   #$20,d3

DEZFinal_ArmCalcPlayerDelta:
                add.w   d3,d1
                sub.w   d1,d0
                smi     d1
                bpl.s   DEZFinal_ArmCheckDistanceAndSide
                neg.w   d0

DEZFinal_ArmCheckDistanceAndSide:
                cmpi.w  #$80,d0
                bhs.s   DEZFinal_ArmTrackingReturn
                cmpi.w  #4,d0
                bls.s   DEZFinal_ArmTrackingReturn
                move.w  #-$80,d0
                tst.b   subtype(a0)
                beq.s   DEZFinal_ArmInitTrackingStep
                neg.w   d0

DEZFinal_ArmInitTrackingStep:
                move.w  $42(a0),d2
                move.b  $3A(a0),d3
                moveq   #2,d4
                moveq   #2,d5

DEZFinal_ArmScaleStepByLostSegments:
                lsr.b   #1,d3
                bcc.s   DEZFinal_ArmMoveOffsetTowardPlayer
                addq.w  #2,d4

DEZFinal_ArmMoveOffsetTowardPlayer:
                dbf     d5,DEZFinal_ArmScaleStepByLostSegments
                tst.b   d1
                bne.s   DEZFinal_ArmMoveOffsetLeft
                addi.w  #$40,d0
                cmp.w   d0,d2
                bge.s   DEZFinal_ArmTrackingReturn
                add.w   d4,$42(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmMoveOffsetLeft:
                subi.w  #$40,d0
                cmp.w   d0,d2
                blt.s   DEZFinal_ArmTrackingReturn
                sub.w   d4,$42(a0)

DEZFinal_ArmTrackingReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmBeginImpactRise:
                move.b  #4,routine(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #DEZFinal_ArmStopBeforeImpact,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinalArmController_MoveAndWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZFinal_ArmStopBeforeImpact:
                move.w  #$10,$2E(a0)
                clr.w   y_vel(a0)
                move.l  #DEZFinal_ArmBeginImpactAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmBeginImpactAnimation:
                move.b  #6,routine(a0)
                move.l  #DEZFinal_ArmBeginImpactHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinalArmController_AnimateImpact:
                lea     DEZFinalArm_ImpactExtensionRawAnimation(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

DEZFinal_ArmBeginImpactHold:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                bset    #1,$38(a0)
                move.b  $39(a0),d0
                lsl.w   #2,d0
                andi.w  #$C,d0
                move.w  d0,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l

DEZFinalAttackActors_SharedReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmWaitBeforeRetract:
                subq.w  #1,$2E(a0)
                bpl.s   DEZFinal_ArmImpactHoldReturn
                move.b  #$A,routine(a0)
                bclr    #1,$38(a0)
                move.l  #DEZFinalArmController_BeginReturnDescent,$34(a0)

DEZFinal_ArmImpactHoldReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinalArmController_AnimateRetraction:
                lea     DEZFinalArm_ImpactRetractionRawAnimation(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

DEZFinalArmController_BeginReturnDescent:
                move.b  #$C,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #DEZFinal_ArmResetAndClearRequest,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmResetAndClearRequest:
                move.b  #2,routine(a0)
                move.w  #$E3,y_pos(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

DEZFinal_InitArmSegmentHealth:
                lea     DEZFinalArmSegment_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinal_SegmentFollowAndRecover,(a0)
                move.b  #3,collision_property(a0)

DEZFinal_SegmentFollowAndRecover:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                btst    #1,$38(a1)
                bne.s   DEZFinal_SegmentEnableImpactTouch
                jsr     Refresh_ChildPosition(pc)
                bsr.w   DEZArmSegment_ContinueFlashOrBreak
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_SegmentEnableImpactTouch:
                move.l  #DEZFinal_SegmentFollowCheckHitDraw,(a0)
                move.b  #$1A,collision_flags(a0)
                bset    #7,art_tile(a0)
                move.w  #$80,priority(a0)

DEZFinal_SegmentFollowCheckHitDraw:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                btst    #1,$38(a1)
                beq.s   DEZFinal_SegmentRestoreInactive
                jsr     Refresh_ChildPosition(pc)
                bsr.w   RecognizeDEZArmSegmentHitAtImpactFrame
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_SegmentRestoreInactive:
                move.l  #DEZFinal_SegmentFollowAndRecover,(a0)
                bclr    #7,art_tile(a0)
                move.w  #$280,priority(a0)
                bra.s   DEZFinal_SegmentFollowAndRecover
; ---------------------------------------------------------------------------

DEZFinal_SegmentFollowBeforeBreakup:
                jsr     Refresh_ChildPosition(pc)
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_InitIntroPanel:
                lea     DEZFinalIntroSlidingPiece_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinal_PanelWaitForRunner,(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                subi.w  #$3C,d0
                move.w  d0,y_pos(a0)

DEZFinal_PanelWaitForRunner:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                beq.s   DEZFinalIntroPanel_DrawWhileWaiting
                move.l  #DEZFinal_PanelMoveAndTickDelay,(a0)
                move.w  #$1F,$2E(a0)
                move.w  #-$80,x_vel(a0)

DEZFinalIntroPanel_DrawWhileWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_PanelMoveAndTickDelay:
                subq.w  #1,$2E(a0)
                bmi.s   DEZFinalIntroPanel_SignalStageAndDelete
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalIntroPanel_SignalStageAndDelete:
                bset    #1,(SceneSyncFlagsOrMHZState).w
                st      (Events_fg_5).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalIntroRunner_Initialize:
                lea     DEZFinalIntroRobotnikRun_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinalIntroRunner_AnimateAndMoveRight,(a0)
                move.w  #$70,x_pos(a0)
                move.w  #$C0,y_pos(a0)
                bset    #0,render_flags(a0)

DEZFinalIntroRunner_AnimateAndMoveRight:
                lea     DEZFinal_IntroRobotnikRunAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$3D0,d0
                bhs.s   DEZFinalIntroRunner_SignalPanelAndDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalIntroRunner_SignalPanelAndDelete:
                bset    #0,(SceneSyncFlagsOrMHZState).w
                jmp     (Delete_Current_Sprite).l

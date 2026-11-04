; Owner: objects/enemies/aiz/s3
; Responsibility: Monkey Dude patrol and projectile states, helper callbacks and private child data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MonkeyDude:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MonkeyDude_Index(pc,d0.w),d1
                jsr     MonkeyDude_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MonkeyDude_Index:
                dc.w    S3MonkeyDude_InitBodyAndArm-MonkeyDude_Index
                dc.w    S3MonkeyDude_TickBodyIdle-MonkeyDude_Index
                dc.w    S3MonkeyDude_AnimateClimbAndTryStepDown-MonkeyDude_Index
; ---------------------------------------------------------------------------

S3MonkeyDude_InitBodyAndArm:
                lea     ObjDat_MonkeyDude(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                move.b  d0,subtype(a0)
                lsr.w   #1,d0
                move.b  d0,$39(a0)
                move.l  #MonkeyDudeS3_Body_UniformIdleFrames,$30(a0)
                move.w  #60-1,$2E(a0)
                move.l  #S3MonkeyDude_StartClimbAnim,$34(a0)
                btst    #0,render_flags(a0)
                bne.w   S3MonkeyDude_CreateFlippedArm
                lea     S3MonkeyDude_NormalArmChain(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_CreateFlippedArm:
                lea     S3MonkeyDude_FlippedArmChain(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_TickBodyIdle:
                jmp     (S3RawWait_AnimateAndTickTimer).l
; ---------------------------------------------------------------------------

S3MonkeyDude_StartClimbAnim:
                move.b  #4,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #MonkeyDudeS3_Body_ClimbFrameDelayPairs,$30(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_AnimateClimbAndTryStepDown:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   S3MonkeyDude_ClimbReturn
                btst    #2,$38(a0)
                bne.s   S3MonkeyDude_TryClimbStepUp
                cmpi.b  #0,mapping_frame(a0)
                bne.s   S3MonkeyDude_ClimbReturn
                addq.w  #8,y_pos(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   S3MonkeyDude_FinishClimbAndReverse

S3MonkeyDude_ClimbReturn:
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_TryClimbStepUp:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   S3MonkeyDude_ClimbReturn
                subq.b  #1,$39(a0)
                beq.s   S3MonkeyDude_FinishClimbAndReverse
                subq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_FinishClimbAndReverse:
                move.b  #2,routine(a0)
                move.b  subtype(a0),$39(a0)
                bchg    #2,$38(a0)
                move.w  #60-1,$2E(a0)
                move.l  #MonkeyDudeS3_Body_UniformIdleFrames,$30(a0)
                move.b  #0,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_MarkFlippedArmNode:
                bset    #3,$38(a0)

S3MonkeyDude_InitArmNode:
                lea     MonkeyDudeS3_ArmNode_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                clr.b   routine(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                tst.b   subtype(a0)
                bne.s   S3MonkeyDude_PickArmNodeHandler
                move.l  #S3MonkeyDude_UpdatePivot,(a0)
                moveq   #$E,d0
                btst    #3,$38(a0)
                bne.s   S3MonkeyDude_PlaceArmPivot
                neg.w   d0

S3MonkeyDude_PlaceArmPivot:
                add.w   d0,x_pos(a0)
                subq.w  #2,y_pos(a0)
                move.w  y_pos(a0),$3E(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_PickArmNodeHandler:
                cmpi.b  #8,subtype(a0)
                beq.s   S3MonkeyDude_InitArmTip
                move.l  #S3MonkeyDude_UpdateArmLink,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_InitArmTip:
                move.l  #S3MonkeyDude_UpdateArmTip,(a0)
                move.b  #6,mapping_frame(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,$3E(a0)
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_UpdatePivot:
                bsr.w   FollowMonkeyArmPivotYFromBodyPose
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3MonkeyDude_PivotStateOffsets(pc,d0.w),d1
                jsr     S3MonkeyDude_PivotStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3MonkeyDude_PivotStateOffsets:
                dc.w    S3MonkeyDude_CenterPivot-S3MonkeyDude_PivotStateOffsets
                dc.w    S3MonkeyDude_CheckPlayerBeforeWobble-S3MonkeyDude_PivotStateOffsets
                dc.w    S3MonkeyDude_WindUpPivot-S3MonkeyDude_PivotStateOffsets
                dc.w    S3MonkeyDude_SwingPivot-S3MonkeyDude_PivotStateOffsets
                dc.w    S3MonkeyDude_RecoverPivot-S3MonkeyDude_PivotStateOffsets
                dc.w    S3MonkeyDude_WobblePivot-S3MonkeyDude_PivotStateOffsets
; ---------------------------------------------------------------------------

S3MonkeyDude_CenterPivot:
                move.b  $3C(a0),d0
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_CenterPivotDecreasing
                addq.b  #4,d0
                cmpi.b  #$80,d0
                bhs.s   MonkeyDudeS3_Pivot_SelectPlayerGatedIdle
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_CenterPivotDecreasing:
                subq.b  #4,d0
                cmpi.b  #$80,d0
                bls.s   MonkeyDudeS3_Pivot_SelectPlayerGatedIdle
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

MonkeyDudeS3_Pivot_SelectPlayerGatedIdle:
                move.b  #2,routine(a0)

S3MonkeyDude_InitPivotIdle:
                bsr.w   RandomizeMonkeyArmIdleStepAndWait
                move.l  #S3MonkeyDude_RerollPivotWobble,$34(a0)

S3MonkeyDude_PivotOrThrowReturn:
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_CheckPlayerBeforeWobble:
                bsr.w   TestMonkeyDudePlayerInThrowDirection
                beq.s   S3MonkeyDude_StartPivotWindup

S3MonkeyDude_WobblePivot:
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_WobblePivotUnflipped
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$20,d0
                cmpi.b  #$60,d0
                bhs.s   S3MonkeyDude_ReversePivotWobble
                bra.w   MonkeyDudeS3_Pivot_CountRandomIdleWait
; ---------------------------------------------------------------------------

S3MonkeyDude_WobblePivotUnflipped:
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$80,d0
                cmpi.b  #$60,d0
                blo.s   MonkeyDudeS3_Pivot_CountRandomIdleWait

S3MonkeyDude_ReversePivotWobble:
                neg.w   $40(a0)
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep

MonkeyDudeS3_Pivot_CountRandomIdleWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3MonkeyDude_RerollPivotWobble:
                bra.w   RandomizeMonkeyArmIdleStepAndWait
; ---------------------------------------------------------------------------

S3MonkeyDude_StartPivotWindup:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_WindUpPivot:
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_WindUpPivotUnflipped
                moveq   #4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #-$40,d0
                bhs.s   S3MonkeyDude_StartFastSwing
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_WindUpPivotUnflipped:
                moveq   #-4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #$40,d0
                bls.s   S3MonkeyDude_StartFastSwing
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_StartFastSwing:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_SwingPivot:
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_SwingPivotUnflipped
                moveq   #-8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #$60,d1
                cmp.b   d1,d0
                bls.s   S3MonkeyDude_FinishSwingAndClearSignal
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_SwingPivotUnflipped:
                moveq   #8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$60,d1
                cmp.b   d1,d0
                bhs.s   S3MonkeyDude_FinishSwingAndClearSignal
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_FinishSwingAndClearSignal:
                move.b  #8,routine(a0)
                move.b  d1,$3C(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_RecoverPivot:
                btst    #3,$38(a0)
                bne.s   S3MonkeyDude_RecoverPivotFlipped
                moveq   #-2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bls.s   S3MonkeyDude_FinishPivotRecovery
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_RecoverPivotFlipped:
                moveq   #2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bhs.s   S3MonkeyDude_FinishPivotRecovery
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_FinishPivotRecovery:
                move.b  #$A,routine(a0)
                move.b  d1,$3C(a0)
                bra.w   S3MonkeyDude_InitPivotIdle
; ---------------------------------------------------------------------------

S3MonkeyDude_UpdateArmLink:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3MonkeyDude_LinkStateOffsets(pc,d0.w),d1
                jsr     S3MonkeyDude_LinkStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3MonkeyDude_LinkStateOffsets:
                dc.w    S3MonkeyDude_TryActivateLink-S3MonkeyDude_LinkStateOffsets
                dc.w    S3MonkeyDude_CheckLinkReleaseAndOrbit-S3MonkeyDude_LinkStateOffsets
                dc.w    S3MonkeyDude_RunLinkDelayedOrbit-S3MonkeyDude_LinkStateOffsets
; ---------------------------------------------------------------------------

S3MonkeyDude_TryActivateLink:
                moveq   #2,d1
                bsr.w   MonkeyArmLink_TryEnterAttack

S3MonkeyDude_RunLinkDelayedOrbit:
                bra.w   S3MonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

S3MonkeyDude_CheckLinkReleaseAndOrbit:
                moveq   #4,d1
                bsr.w   MonkeyArmLink_TryLeaveAttack
                bra.w   S3MonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

S3MonkeyDude_UpdateArmTip:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3MonkeyDude_TipStateOffsets(pc,d0.w),d1
                jsr     S3MonkeyDude_TipStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3MonkeyDude_TipStateOffsets:
                dc.w    S3MonkeyDude_TryActivateTip-S3MonkeyDude_TipStateOffsets
                dc.w    S3MonkeyDude_TryTipThrowAndRelease-S3MonkeyDude_TipStateOffsets
                dc.w    S3MonkeyDude_RunTipDelayedOrbit-S3MonkeyDude_TipStateOffsets
; ---------------------------------------------------------------------------

S3MonkeyDude_TryActivateTip:
                moveq   #2,d1
                bsr.w   MonkeyArmLink_TryEnterAttack

S3MonkeyDude_RunTipDelayedOrbit:
                bra.w   S3MonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

S3MonkeyDude_TryTipThrowAndRelease:
                bsr.w   TryThrowMonkeyDudeProjectileAtArmPhase
                moveq   #4,d1
                bsr.w   MonkeyArmLink_TryLeaveAttack
                bra.w   S3MonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

S3MonkeyDude_InitRetainedShot:
                lea     S3MonkeyDude_RetainedShotAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #S3MonkeyDude_UpdateRetainedShot,(a0)
                move.l  #S3MonkeyDude_RetainedShotAnim,$30(a0)
                move.l  #S3MonkeyDude_StopRetainedShot,$34(a0)
                move.b  #8,y_radius(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

S3MonkeyDude_UpdateRetainedShot:
                jsr     (MoveSprite_LightGravity).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     ObjHitFloor_DoRoutine(pc)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

S3MonkeyDude_StopRetainedShot:
                move.l  #S3MonkeyDude_DrawRetainedStoppedShot,(a0)
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_DrawRetainedStoppedShot:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
; unused
                movea.w parent3(a0),a1
                move.b  render_flags(a1),d0
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_PickRetainedPriority
                bchg    #0,d0

S3MonkeyDude_PickRetainedPriority:
                move.w  #$200,priority(a0)
                btst    #0,d0
                beq.s   S3MonkeyDude_RetainedPriorityReturn
                move.w  #$300,priority(a0)

S3MonkeyDude_RetainedPriorityReturn:
                rts

; =============== S U B R O U T I N E =======================================

FollowMonkeyArmPivotYFromBodyPose:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #2,d0
                tst.b   mapping_frame(a1)
                beq.s   S3MonkeyDude_StorePivotY
                subq.w  #2,d0

S3MonkeyDude_StorePivotY:
                move.w  d0,y_pos(a0)
                rts
; End of function FollowMonkeyArmPivotYFromBodyPose

; =============== S U B R O U T I N E =======================================

CopyMonkeyArmLinkParentPriority:
                movea.w parent3(a0),a1
                move.w  priority(a1),priority(a0)
                rts
; End of function CopyMonkeyArmLinkParentPriority

; =============== S U B R O U T I N E =======================================

TestMonkeyDudePlayerInThrowDirection:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   S3MonkeyDude_ReturnThrowTooFar
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_ReturnThrowSideTest
                subq.w  #2,d0

S3MonkeyDude_ReturnThrowSideTest:
                tst.w   d0
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_ReturnThrowTooFar:
                moveq   #1,d4
                rts
; End of function TestMonkeyDudePlayerInThrowDirection

; =============== S U B R O U T I N E =======================================

AdvanceMonkeyArmAngleByByteStep:
                move.b  $3C(a0),d0
                add.b   d1,d0
                move.b  d0,$3C(a0)
                rts
; End of function AdvanceMonkeyArmAngleByByteStep

; ---------------------------------------------------------------------------

S3MonkeyDude_TickLinkPhaseDelay:
                subq.b  #1,$3B(a0)
                bne.s   S3MonkeyDude_OrbitLinkParent
                move.b  $3A(a0),$3B(a0)
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)

S3MonkeyDude_OrbitLinkParent:
                moveq   #5,d2
                jsr     MoveSprite_CircularSimple(pc)
                rts

; =============== S U B R O U T I N E =======================================

; On the predecessor's attack flag, enter the supplied state, halve the follow interval and propagate the angle immediately
MonkeyArmLink_TryEnterAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   S3MonkeyDude_LinkActivationReturn
                move.b  d1,routine(a0)
                bset    #1,$38(a0)
                move.b  $3A(a0),d0
                lsr.b   #1,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

S3MonkeyDude_LinkActivationReturn:
                rts
; End of function MonkeyArmLink_TryEnterAttack

; =============== S U B R O U T I N E =======================================

; When the predecessor clears its flag, enter the supplied state, double the follow interval and propagate immediately
MonkeyArmLink_TryLeaveAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   S3MonkeyDude_LinkReleaseReturn
                move.b  d1,routine(a0)
                move.b  $3A(a0),d0
                add.b   d0,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

S3MonkeyDude_LinkReleaseReturn:
                rts
; End of function MonkeyArmLink_TryLeaveAttack

; =============== S U B R O U T I N E =======================================

TryThrowMonkeyDudeProjectileAtArmPhase:
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_CheckUnflippedThrow
                btst    #0,$38(a0)
                bne.w   S3MonkeyDude_PivotOrThrowReturn
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   S3MonkeyDude_TipThrowReturn
                movea.w $3E(a0),a1
                cmpi.b  #-$7C,$3C(a1)
                blo.s   S3MonkeyDude_LatchThrowAndTrySpawnShot

S3MonkeyDude_TipThrowReturn:
                rts
; ---------------------------------------------------------------------------

S3MonkeyDude_CheckUnflippedThrow:
                btst    #0,$38(a0)
                bne.w   S3MonkeyDude_PivotOrThrowReturn
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   S3MonkeyDude_TipThrowReturn
                movea.w $3E(a0),a1
                cmpi.b  #$7C,$3C(a1)
                blo.w   S3MonkeyDude_PivotOrThrowReturn
                move.w  #make_art_tile(ArtTile_MonkeyDude,1,0),art_tile(a0)

; Set the one-shot latch before allocating the projectile
S3MonkeyDude_LatchThrowAndTrySpawnShot:
                bset    #0,$38(a0)
                move.b  #4,mapping_frame(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     (S3MonkeyDude_ThrownShotChildRecord).l,a2
                jsr     CreateChild2_Complex(pc)
                bne.s   S3MonkeyDude_TipThrowReturn
                btst    #3,$38(a0)
                beq.s   S3MonkeyDude_TipThrowReturn
                neg.w   x_vel(a1)
                rts
; End of function TryThrowMonkeyDudeProjectileAtArmPhase

; =============== S U B R O U T I N E =======================================

RandomizeMonkeyArmIdleStepAndWait:
                jsr     (Random_Number).l
                move.w  (RNG_seed).w,d0
                moveq   #1,d1
                btst    #0,d0
                beq.s   S3MonkeyDude_StorePivotIdleStepAndWait
                neg.w   d1

S3MonkeyDude_StorePivotIdleStepAndWait:
                move.w  d1,$40(a0)
                andi.w  #$3C,d0
                move.w  d0,$2E(a0)
                rts
; End of function RandomizeMonkeyArmIdleStepAndWait

; ---------------------------------------------------------------------------
ObjDat_MonkeyDude:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,0)
                dc.w    $280
                dc.b    $20, $20,   0,  $B
MonkeyDudeS3_ArmNode_PartialAttributes:
                dc.w    $300
                dc.b    4,   4,   3,   0
S3MonkeyDude_RetainedShotAttrs:
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    $20, $20,   6,  $B
MonkeyDudeS3_Projectile_FullAttributes:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,0,0)
                dc.w    $280
                dc.b    $20, $20,   6, $98
S3MonkeyDude_NormalArmChain:
                dc.w    5-1
                dc.l    S3MonkeyDude_InitArmNode
; The linked-chain count uses five nodes. Retain the trailing child records
S3MonkeyDude_FlippedArmChain:
                dc.w    5-1
                dc.l    S3MonkeyDude_MarkFlippedArmNode
                dc.w    1-1
                dc.l    S3MonkeyDude_InitArmNode
                dc.b    0,   8
                dc.w    1-1
                dc.l    S3MonkeyDude_InitRetainedShot
                dc.b    0,   0
S3MonkeyDude_ThrownShotChildRecord:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    MonkeyDudeS3_Projectile_FullAttributes
                dc.l    0
                dc.l    MoveSprite_LightGravity
                dc.b    0,   0
                dc.w    -$200, -$400
MonkeyDudeS3_Body_UniformIdleFrames:
                dc.b    7,   0,   1, $FC
MonkeyDudeS3_Body_ClimbFrameDelayPairs:
                dc.b    0,   7
                dc.b    2,   7
                dc.b    $FC
S3MonkeyDude_RetainedShotAnim:
                dc.b    8,  $F
                dc.b    8,  $F
                dc.b    9,  $F
                dc.b    $A,  $F
                dc.b    $F8, .jump-S3MonkeyDude_RetainedShotAnim

                .jump:
                dc.b    6, $7E
                dc.b    $FC
                even

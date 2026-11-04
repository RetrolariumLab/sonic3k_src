; Owner: objects/enemies/aiz/sk
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
                dc.w    SKMonkeyDude_InitBodyAndArm-MonkeyDude_Index
                dc.w    SKMonkeyDude_TickBodyIdle-MonkeyDude_Index
                dc.w    SKMonkeyDude_AnimateClimbAndTryStepDown-MonkeyDude_Index
; ---------------------------------------------------------------------------

SKMonkeyDude_InitBodyAndArm:
                lea     ObjDat_MonkeyDude(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                move.b  d0,subtype(a0)
                lsr.w   #1,d0
                move.b  d0,$39(a0)
                move.l  #MonkeyDudeSK_Body_UniformIdleFrames,$30(a0)
                move.w  #60-1,$2E(a0)
                move.l  #SKMonkeyDude_StartClimbAnim,$34(a0)
                btst    #0,render_flags(a0)
                bne.w   SKMonkeyDude_CreateFlippedArm
                lea     SKMonkeyDude_NormalArmChain(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_CreateFlippedArm:
                lea     SKMonkeyDude_FlippedArmChain(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_TickBodyIdle:
                jmp     (SKRawWait_AnimateAndTickTimer).l
; ---------------------------------------------------------------------------

SKMonkeyDude_StartClimbAnim:
                move.b  #4,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #MonkeyDudeSK_Body_ClimbFrameDelayPairs,$30(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_AnimateClimbAndTryStepDown:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   SKMonkeyDude_ClimbReturn
                btst    #2,$38(a0)
                bne.s   SKMonkeyDude_TryClimbStepUp
                cmpi.b  #0,mapping_frame(a0)
                bne.s   SKMonkeyDude_ClimbReturn
                addq.w  #8,y_pos(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   SKMonkeyDude_FinishClimbAndReverse

SKMonkeyDude_ClimbReturn:
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_TryClimbStepUp:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   SKMonkeyDude_ClimbReturn
                subq.b  #1,$39(a0)
                beq.s   SKMonkeyDude_FinishClimbAndReverse
                subq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_FinishClimbAndReverse:
                move.b  #2,routine(a0)
                move.b  subtype(a0),$39(a0)
                bchg    #2,$38(a0)
                move.w  #60-1,$2E(a0)
                move.l  #MonkeyDudeSK_Body_UniformIdleFrames,$30(a0)
                move.b  #0,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_MarkFlippedArmNode:
                bset    #3,$38(a0)

SKMonkeyDude_InitArmNode:
                lea     MonkeyDudeSK_ArmNode_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                clr.b   routine(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                tst.b   subtype(a0)
                bne.s   SKMonkeyDude_PickArmNodeHandler
                move.l  #SKMonkeyDude_UpdatePivot,(a0)
                moveq   #$E,d0
                btst    #3,$38(a0)
                bne.s   SKMonkeyDude_PlaceArmPivot
                neg.w   d0

SKMonkeyDude_PlaceArmPivot:
                add.w   d0,x_pos(a0)
                subq.w  #2,y_pos(a0)
                move.w  y_pos(a0),$3E(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_PickArmNodeHandler:
                cmpi.b  #8,subtype(a0)
                beq.s   SKMonkeyDude_InitArmTip
                move.l  #SKMonkeyDude_UpdateArmLink,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_InitArmTip:
                move.l  #SKMonkeyDude_UpdateArmTip,(a0)
                move.b  #6,mapping_frame(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,$3E(a0)
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_UpdatePivot:
                bsr.w   FollowMonkeyArmPivotYFromBodyPose
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMonkeyDude_PivotStateOffsets(pc,d0.w),d1
                jsr     SKMonkeyDude_PivotStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKMonkeyDude_PivotStateOffsets:
                dc.w    SKMonkeyDude_CenterPivot-SKMonkeyDude_PivotStateOffsets
                dc.w    SKMonkeyDude_CheckPlayerBeforeWobble-SKMonkeyDude_PivotStateOffsets
                dc.w    SKMonkeyDude_WindUpPivot-SKMonkeyDude_PivotStateOffsets
                dc.w    SKMonkeyDude_SwingPivot-SKMonkeyDude_PivotStateOffsets
                dc.w    SKMonkeyDude_RecoverPivot-SKMonkeyDude_PivotStateOffsets
                dc.w    SKMonkeyDude_WobblePivot-SKMonkeyDude_PivotStateOffsets
; ---------------------------------------------------------------------------

SKMonkeyDude_CenterPivot:
                move.b  $3C(a0),d0
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_CenterPivotDecreasing
                addq.b  #4,d0
                cmpi.b  #$80,d0
                bhs.s   MonkeyDudeSK_Pivot_SelectPlayerGatedIdle
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_CenterPivotDecreasing:
                subq.b  #4,d0
                cmpi.b  #$80,d0
                bls.s   MonkeyDudeSK_Pivot_SelectPlayerGatedIdle
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

MonkeyDudeSK_Pivot_SelectPlayerGatedIdle:
                move.b  #2,routine(a0)

SKMonkeyDude_InitPivotIdle:
                bsr.w   RandomizeMonkeyArmIdleStepAndWait
                move.l  #SKMonkeyDude_RerollPivotWobble,$34(a0)

SKMonkeyDude_PivotOrThrowReturn:
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_CheckPlayerBeforeWobble:
                bsr.w   TestMonkeyDudePlayerInThrowDirection
                beq.s   SKMonkeyDude_StartPivotWindup

SKMonkeyDude_WobblePivot:
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_WobblePivotUnflipped
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$20,d0
                cmpi.b  #$60,d0
                bhs.s   SKMonkeyDude_ReversePivotWobble
                bra.w   MonkeyDudeSK_Pivot_CountRandomIdleWait
; ---------------------------------------------------------------------------

SKMonkeyDude_WobblePivotUnflipped:
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$80,d0
                cmpi.b  #$60,d0
                blo.s   MonkeyDudeSK_Pivot_CountRandomIdleWait

SKMonkeyDude_ReversePivotWobble:
                neg.w   $40(a0)
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep

MonkeyDudeSK_Pivot_CountRandomIdleWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKMonkeyDude_RerollPivotWobble:
                bra.w   RandomizeMonkeyArmIdleStepAndWait
; ---------------------------------------------------------------------------

SKMonkeyDude_StartPivotWindup:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_WindUpPivot:
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_WindUpPivotUnflipped
                moveq   #4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #-$40,d0
                bhs.s   SKMonkeyDude_StartFastSwing
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_WindUpPivotUnflipped:
                moveq   #-4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #$40,d0
                bls.s   SKMonkeyDude_StartFastSwing
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_StartFastSwing:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_SwingPivot:
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_SwingPivotUnflipped
                moveq   #-8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #$60,d1
                cmp.b   d1,d0
                bls.s   SKMonkeyDude_FinishSwingAndClearSignal
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_SwingPivotUnflipped:
                moveq   #8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$60,d1
                cmp.b   d1,d0
                bhs.s   SKMonkeyDude_FinishSwingAndClearSignal
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_FinishSwingAndClearSignal:
                move.b  #8,routine(a0)
                move.b  d1,$3C(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_RecoverPivot:
                btst    #3,$38(a0)
                bne.s   SKMonkeyDude_RecoverPivotFlipped
                moveq   #-2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bls.s   SKMonkeyDude_FinishPivotRecovery
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_RecoverPivotFlipped:
                moveq   #2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bhs.s   SKMonkeyDude_FinishPivotRecovery
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_FinishPivotRecovery:
                move.b  #$A,routine(a0)
                move.b  d1,$3C(a0)
                bra.w   SKMonkeyDude_InitPivotIdle
; ---------------------------------------------------------------------------

SKMonkeyDude_UpdateArmLink:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMonkeyDude_LinkStateOffsets(pc,d0.w),d1
                jsr     SKMonkeyDude_LinkStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKMonkeyDude_LinkStateOffsets:
                dc.w    SKMonkeyDude_TryActivateLink-SKMonkeyDude_LinkStateOffsets
                dc.w    SKMonkeyDude_CheckLinkReleaseAndOrbit-SKMonkeyDude_LinkStateOffsets
                dc.w    SKMonkeyDude_RunLinkDelayedOrbit-SKMonkeyDude_LinkStateOffsets
; ---------------------------------------------------------------------------

SKMonkeyDude_TryActivateLink:
                moveq   #2,d1
                bsr.w   MonkeyArmLink_TryEnterAttack

SKMonkeyDude_RunLinkDelayedOrbit:
                bra.w   SKMonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

SKMonkeyDude_CheckLinkReleaseAndOrbit:
                moveq   #4,d1
                bsr.w   MonkeyArmLink_TryLeaveAttack
                bra.w   SKMonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

SKMonkeyDude_UpdateArmTip:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMonkeyDude_TipStateOffsets(pc,d0.w),d1
                jsr     SKMonkeyDude_TipStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKMonkeyDude_TipStateOffsets:
                dc.w    SKMonkeyDude_TryActivateTip-SKMonkeyDude_TipStateOffsets
                dc.w    SKMonkeyDude_TryTipThrowAndRelease-SKMonkeyDude_TipStateOffsets
                dc.w    SKMonkeyDude_RunTipDelayedOrbit-SKMonkeyDude_TipStateOffsets
; ---------------------------------------------------------------------------

SKMonkeyDude_TryActivateTip:
                moveq   #2,d1
                bsr.w   MonkeyArmLink_TryEnterAttack

SKMonkeyDude_RunTipDelayedOrbit:
                bra.w   SKMonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

SKMonkeyDude_TryTipThrowAndRelease:
                bsr.w   TryThrowMonkeyDudeProjectileAtArmPhase
                moveq   #4,d1
                bsr.w   MonkeyArmLink_TryLeaveAttack
                bra.w   SKMonkeyDude_TickLinkPhaseDelay
; ---------------------------------------------------------------------------

SKMonkeyDude_InitRetainedShot:
                lea     SKMonkeyDude_RetainedShotAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKMonkeyDude_UpdateRetainedShot,(a0)
                move.l  #SKMonkeyDude_RetainedShotAnim,$30(a0)
                move.l  #SKMonkeyDude_StopRetainedShot,$34(a0)
                move.b  #8,y_radius(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKMonkeyDude_UpdateRetainedShot:
                jsr     (MoveSprite_LightGravity).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     ObjHitFloor_DoRoutine(pc)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKMonkeyDude_StopRetainedShot:
                move.l  #SKMonkeyDude_DrawRetainedStoppedShot,(a0)
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_DrawRetainedStoppedShot:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
; unused
                movea.w parent3(a0),a1
                move.b  render_flags(a1),d0
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_PickRetainedPriority
                bchg    #0,d0

SKMonkeyDude_PickRetainedPriority:
                move.w  #$200,priority(a0)
                btst    #0,d0
                beq.s   SKMonkeyDude_RetainedPriorityReturn
                move.w  #$300,priority(a0)

SKMonkeyDude_RetainedPriorityReturn:
                rts

; =============== S U B R O U T I N E =======================================

FollowMonkeyArmPivotYFromBodyPose:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #2,d0
                tst.b   mapping_frame(a1)
                beq.s   SKMonkeyDude_StorePivotY
                subq.w  #2,d0

SKMonkeyDude_StorePivotY:
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
                bhs.s   SKMonkeyDude_ReturnThrowTooFar
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_ReturnThrowSideTest
                subq.w  #2,d0

SKMonkeyDude_ReturnThrowSideTest:
                tst.w   d0
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_ReturnThrowTooFar:
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

SKMonkeyDude_TickLinkPhaseDelay:
                subq.b  #1,$3B(a0)
                bne.s   SKMonkeyDude_OrbitLinkParent
                move.b  $3A(a0),$3B(a0)
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)

SKMonkeyDude_OrbitLinkParent:
                moveq   #5,d2
                jsr     MoveSprite_CircularSimple(pc)
                rts

; =============== S U B R O U T I N E =======================================

; On the predecessor's attack flag, enter the supplied state, halve the follow interval and propagate the angle immediately
MonkeyArmLink_TryEnterAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SKMonkeyDude_LinkActivationReturn
                move.b  d1,routine(a0)
                bset    #1,$38(a0)
                move.b  $3A(a0),d0
                lsr.b   #1,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

SKMonkeyDude_LinkActivationReturn:
                rts
; End of function MonkeyArmLink_TryEnterAttack

; =============== S U B R O U T I N E =======================================

; When the predecessor clears its flag, enter the supplied state, double the follow interval and propagate immediately
MonkeyArmLink_TryLeaveAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   SKMonkeyDude_LinkReleaseReturn
                move.b  d1,routine(a0)
                move.b  $3A(a0),d0
                add.b   d0,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

SKMonkeyDude_LinkReleaseReturn:
                rts
; End of function MonkeyArmLink_TryLeaveAttack

; =============== S U B R O U T I N E =======================================

TryThrowMonkeyDudeProjectileAtArmPhase:
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_CheckUnflippedThrow
                btst    #0,$38(a0)
                bne.w   SKMonkeyDude_PivotOrThrowReturn
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   SKMonkeyDude_TipThrowReturn
                movea.w $3E(a0),a1
                cmpi.b  #-$7C,$3C(a1)
                blo.s   SKMonkeyDude_LatchThrowAndTrySpawnShot

SKMonkeyDude_TipThrowReturn:
                rts
; ---------------------------------------------------------------------------

SKMonkeyDude_CheckUnflippedThrow:
                btst    #0,$38(a0)
                bne.w   SKMonkeyDude_PivotOrThrowReturn
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   SKMonkeyDude_TipThrowReturn
                movea.w $3E(a0),a1
                cmpi.b  #$7C,$3C(a1)
                blo.w   SKMonkeyDude_PivotOrThrowReturn
                move.w  #make_art_tile(ArtTile_MonkeyDude,1,0),art_tile(a0)

; Set the one-shot latch before allocating the projectile
SKMonkeyDude_LatchThrowAndTrySpawnShot:
                bset    #0,$38(a0)
                move.b  #4,mapping_frame(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     (SKMonkeyDude_ThrownShotChildRecord).l,a2
                jsr     CreateChild2_Complex(pc)
                bne.s   SKMonkeyDude_TipThrowReturn
                btst    #3,$38(a0)
                beq.s   SKMonkeyDude_TipThrowReturn
                neg.w   x_vel(a1)
                rts
; End of function TryThrowMonkeyDudeProjectileAtArmPhase

; =============== S U B R O U T I N E =======================================

RandomizeMonkeyArmIdleStepAndWait:
                jsr     (Random_Number).l
                move.w  (RNG_seed).w,d0
                moveq   #1,d1
                btst    #0,d0
                beq.s   SKMonkeyDude_StorePivotIdleStepAndWait
                neg.w   d1

SKMonkeyDude_StorePivotIdleStepAndWait:
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
MonkeyDudeSK_ArmNode_PartialAttributes:
                dc.w    $300
                dc.b    4,   4,   3,   0
SKMonkeyDude_RetainedShotAttrs:
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    $20, $20,   6,  $B
MonkeyDudeSK_Projectile_FullAttributes:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,0,0)
                dc.w    $280
                dc.b    $20, $20,   6, $98
SKMonkeyDude_NormalArmChain:
                dc.w    5-1
                dc.l    SKMonkeyDude_InitArmNode
; The linked-chain count uses five nodes. Retain the trailing child records
SKMonkeyDude_FlippedArmChain:
                dc.w    5-1
                dc.l    SKMonkeyDude_MarkFlippedArmNode
                dc.w    1-1
                dc.l    SKMonkeyDude_InitArmNode
                dc.b    0,   8
                dc.w    1-1
                dc.l    SKMonkeyDude_InitRetainedShot
                dc.b    0,   0
SKMonkeyDude_ThrownShotChildRecord:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    MonkeyDudeSK_Projectile_FullAttributes
                dc.l    0
                dc.l    MoveSprite_LightGravity
                dc.b    0,   0
                dc.w    -$200, -$400
MonkeyDudeSK_Body_UniformIdleFrames:
                dc.b    7,   0,   1, $FC
MonkeyDudeSK_Body_ClimbFrameDelayPairs:
                dc.b    0,   7
                dc.b    2,   7
                dc.b    $FC
SKMonkeyDude_RetainedShotAnim:
                dc.b    8,  $F
                dc.b    8,  $F
                dc.b    9,  $F
                dc.b    $A,  $F
                dc.b    $F8, .jump-SKMonkeyDude_RetainedShotAnim

                .jump:
                dc.b    6, $7E
                dc.b    $FC
                even

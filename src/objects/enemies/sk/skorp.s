; Owner: objects/enemies/sk
; Responsibility: Skorp enemy attack states, linked children, helper callbacks and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Skorp:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Skorp_Index(pc,d0.w),d1
                jsr     Skorp_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Skorp_Index:
                dc.w    SKSkorp_InitBodyPatrol-Skorp_Index
                dc.w    SKSkorp_CheckPlayerFacingForAttack-Skorp_Index
                dc.w    SKSkorp_WaitForTailAttack-Skorp_Index
; ---------------------------------------------------------------------------

SKSkorp_InitBodyPatrol:
                lea     ObjDat_Skorp(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$B,y_radius(a0)
                move.l  #SKSkorp_ReversePatrol,$34(a0)
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   SKSkorp_InitPatrolTimersAndTail
                neg.w   d0

SKSkorp_InitPatrolTimersAndTail:
                move.w  d0,x_vel(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                addq.w  #1,d0
                move.w  d0,$3A(a0)
                lea     SKSkorp_BodyTailLinkChildren(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

SKSkorp_CheckPlayerFacingForAttack:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                btst    #0,render_flags(a0)
                sne     d4
                tst.w   d0
                beq.s   SKSkorp_CheckAttackDistance
                not.b   d4

; Require the player ahead, at least $20 and less than $80 pixels away horizontally, before testing height
SKSkorp_CheckAttackDistance:
                tst.b   d4
                bne.s   SKSkorp_PatrolMoveAndCheckFloor
                cmpi.w  #$20,d2
                blo.s   SKSkorp_PatrolMoveAndCheckFloor
                cmpi.w  #$80,d2
                bhs.s   SKSkorp_PatrolMoveAndCheckFloor
                cmpi.w  #$28,d3
                blo.s   SKSkorp_BeginTailAttackAtPlayer

; Advance the patrol wait only when the floor check accepts the move
SKSkorp_PatrolMoveAndCheckFloor:
                lea     SkorpSK_Body_UniformPatrolFrames(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jsr     (ObjHitFloor2_DoRoutine).l
                bne.w   SKSkorp_PatrolFloorReturn
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSkorp_ReversePatrol:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)

SKSkorp_PatrolFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKSkorp_BeginTailAttackAtPlayer:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                move.w  x_pos(a1),$3E(a0)
                move.w  y_pos(a1),$40(a0)
                rts
; ---------------------------------------------------------------------------

SKSkorp_WaitForTailAttack:
                btst    #1,$38(a0)
                beq.s   SKSkorp_ResumePatrol
                rts
; ---------------------------------------------------------------------------

SKSkorp_ResumePatrol:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

; The cached body controls each link's lifetime, and only the tip enters the touch list
SKSkorp_TailDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SkorpSK_TailNode_TenRelativeStateOffsets(pc,d0.w),d1
                jsr     SkorpSK_TailNode_TenRelativeStateOffsets(pc,d1.w)
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   SKSkorp_TailDeleteWhenBodyDies
                cmpi.b  #$A,subtype(a0)
                bne.s   SKSkorp_TailDraw
                jsr     (Add_SpriteToCollisionResponseList).l

SKSkorp_TailDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSkorp_TailDeleteWhenBodyDies:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SkorpSK_TailNode_TenRelativeStateOffsets:
                dc.w    SKSkorp_TailInitAndCheckAnchor-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailRestOrDeploy-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailDeployTowardLimit-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailWaitForTipDeployment-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailSweepAndBeginLunge-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailTickWait-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailMoveAndTick-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailMoveAndTick-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailRecoverTowardRest-SkorpSK_TailNode_TenRelativeStateOffsets
                dc.w    SKSkorp_TailWaitForTipRecovery-SkorpSK_TailNode_TenRelativeStateOffsets
; ---------------------------------------------------------------------------

SKSkorp_TailInitAndCheckAnchor:
                lea     SkorpSK_TailNode_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                move.b  subtype(a0),d0
                bne.s   SKSkorp_TailInheritBodyAndCheckTip
                move.b  #8,child_dx(a0)
                move.b  #-$10,child_dy(a0)
                move.w  parent3(a0),$44(a1)

SKSkorp_TailInheritBodyAndCheckTip:
                move.w  $44(a1),$44(a0)
                cmpi.b  #$A,d0
                bne.s   SKSkorp_TailInitRestAngle
                move.b  #4,mapping_frame(a0)
                move.w  #$100,priority(a0)
                move.b  #$87,collision_flags(a0)

SKSkorp_TailInitRestAngle:
                bsr.w   InitializeSkorpTailLinkRestAngle

SKSkorp_TailRestOrDeploy:
                jsr     (Change_FlipXUseParent).l
                tst.b   subtype(a0)
                beq.s   SKSkorp_AnchorFollowBody
                movea.w $44(a0),a1
                btst    #1,$38(a1)
                bne.s   SKSkorp_TailBeginDeployment
                bsr.w   OscillateSkorpTailLinkRestAngle
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------

; Offset the anchor vertically by the body's mapping frame so it follows the walking animation
SKSkorp_AnchorFollowBody:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailBeginDeployment:
                move.b  #4,routine(a0)
                move.l  #SkorpSK_TailNode_SelectSweepIntoLunge,$34(a0)
                movea.w $44(a0),a1
                andi.b  #$F3,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailDeployTowardLimit:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  SKSkorp_TailDeployAngles(pc,d0.w),d1
                move.b  $3C(a0),d2
                subq.b  #8,d2
                cmp.b   d1,d2
                bhi.s   SKSkorp_TailStoreDeployAngle
                move.b  #6,routine(a0)
                move.b  d1,d2
                cmpi.b  #5,d0
                bne.s   SKSkorp_TailStoreDeployAngle
                movea.w $44(a0),a1
                bset    #3,$38(a1)

SKSkorp_TailStoreDeployAngle:
                move.b  d2,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------
SKSkorp_TailDeployAngles:
                dc.b    0, $68, $58, $48, $38, $38
                even
; ---------------------------------------------------------------------------

SKSkorp_TailWaitForTipDeployment:
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                bne.s   SKSkorp_TailRunSyncCallback
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailRunSyncCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

SkorpSK_TailNode_SelectSweepIntoLunge:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

SkorpSK_TailNode_SelectAngleRecovery:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

; When the angle crosses into the negative half of the byte, aim at the saved player position and lunge for 16 calls
SKSkorp_TailSweepAndBeginLunge:
                move.b  $3C(a0),d0
                addi.b  #$10,d0
                bpl.s   SKSkorp_TailStoreSweepAngle
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKSkorp_TailBeginLungePause,$34(a0)
                bsr.w   SkorpTailLink_AimLungeAtSnapshot
                move.b  #$80,d0

SKSkorp_TailStoreSweepAngle:
                move.b  d0,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------

SKSkorp_TailMoveAndTick:
                jsr     (MoveSprite2).l

SKSkorp_TailTickWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSkorp_TailBeginLungePause:
                move.b  #$A,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKSkorp_TailReverseLunge,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailReverseLunge:
                move.b  #$E,routine(a0)
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKSkorp_TailBeginRecoverySync,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailBeginRecoverySync:
                move.b  #4,routine(a0)
                move.l  #SkorpSK_TailNode_SelectAngleRecovery,$34(a0)
                movea.w $44(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailRecoverTowardRest:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  SkorpSK_TailNode_SixRecoveryPhaseLimits(pc,d0.w),d1
                move.b  $3C(a0),d2
                addq.b  #8,d2
                cmp.b   d1,d2
                blo.s   SKSkorp_TailStoreRecoveryAngle
                move.b  #$12,routine(a0)
                move.b  d1,d2
                cmpi.b  #5,d0
                bne.s   SKSkorp_TailStoreRecoveryAngle
                movea.w $44(a0),a1
                bset    #2,$38(a1)

SKSkorp_TailStoreRecoveryAngle:
                move.b  d2,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------
SkorpSK_TailNode_SixRecoveryPhaseLimits:
                dc.b    0, $90, $A0, $B0, $B8, $C0
                even
; ---------------------------------------------------------------------------

SKSkorp_TailWaitForTipRecovery:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   SKSkorp_TailResetRestOscillator
                rts
; ---------------------------------------------------------------------------

SKSkorp_TailResetRestOscillator:
                move.b  #2,routine(a0)
                movea.w $44(a0),a1
                bclr    #1,$38(a1)
                clr.b   $3B(a0)
                bclr    #0,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

InitializeSkorpTailLinkRestAngle:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  SkorpSK_TailNode_SixInitialRestAngles(pc,d0.w),$3C(a0)
                rts
; End of function InitializeSkorpTailLinkRestAngle

; ---------------------------------------------------------------------------
SkorpSK_TailNode_SixInitialRestAngles:
                dc.b    0, $90, $A0, $B0, $B8, $C0
                even
; ---------------------------------------------------------------------------
; unused
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,$2E(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Use the root's saved player position and scale the launch by link index
SkorpTailLink_AimLungeAtSnapshot:
                movea.w $44(a0),a1
                move.w  $3E(a1),d0
                sub.w   x_pos(a0),d0
                smi     d2
                bpl.s   SKSkorp_TailCalcTargetYDelta
                neg.w   d0

SKSkorp_TailCalcTargetYDelta:
                move.w  $40(a1),d1
                sub.w   y_pos(a0),d1
                smi     d3
                bpl.s   SKSkorp_TailSelectLungeFraction
                neg.w   d1

SKSkorp_TailSelectLungeFraction:
                moveq   #0,d4
                move.b  subtype(a0),d4
                move.w  SKSkorp_TailLungeFractionOffsets(pc,d4.w),d4
                jmp     SKSkorp_TailLungeFractionOffsets(pc,d4.w)
; End of function SkorpTailLink_AimLungeAtSnapshot

; ---------------------------------------------------------------------------
SKSkorp_TailLungeFractionOffsets:
                dc.w    SKSkorp_TailLungeOneFifth-SKSkorp_TailLungeFractionOffsets
                dc.w    SKSkorp_TailLungeOneFifth-SKSkorp_TailLungeFractionOffsets
                dc.w    SKSkorp_TailLungeTwoFifths-SKSkorp_TailLungeFractionOffsets
                dc.w    SKSkorp_TailLungeThreeFifths-SKSkorp_TailLungeFractionOffsets
                dc.w    SKSkorp_TailLungeFourFifths-SKSkorp_TailLungeFractionOffsets
                dc.w    SKSkorp_TailSetLungeXSign-SKSkorp_TailLungeFractionOffsets
; ---------------------------------------------------------------------------

SKSkorp_TailLungeOneFifth:
                move.w  #$3333,d4
                bra.w   SKSkorp_TailScaleTargetDeltas
; ---------------------------------------------------------------------------

SKSkorp_TailLungeTwoFifths:
                move.w  #$6666,d4
                bra.w   SKSkorp_TailScaleTargetDeltas
; ---------------------------------------------------------------------------

SKSkorp_TailLungeThreeFifths:
                move.w  #$9999,d4
                bra.w   SKSkorp_TailScaleTargetDeltas
; ---------------------------------------------------------------------------

SKSkorp_TailLungeFourFifths:
                move.w  #$CCCC,d4

; Use the high words of the unsigned products to apply the selected 0.16 fraction
SKSkorp_TailScaleTargetDeltas:
                mulu.w  d4,d0
                swap    d0
                mulu.w  d4,d1
                swap    d1

SKSkorp_TailSetLungeXSign:
                asl.w   #4,d0
                tst.b   d2
                beq.s   SKSkorp_TailStoreXAndSetYSign
                neg.w   d0

SKSkorp_TailStoreXAndSetYSign:
                move.w  d0,x_vel(a0)
                asl.w   #4,d1
                tst.b   d3
                beq.s   SKSkorp_TailStoreLungeY
                neg.w   d1

SKSkorp_TailStoreLungeY:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

OscillateSkorpTailLinkRestAngle:
                subq.b  #1,$3B(a0)
                bpl.s   SKSkorp_TailStepRestAngleOnEvenTick
                move.b  #$10,$3B(a0)
                bchg    #0,$38(a0)

SKSkorp_TailStepRestAngleOnEvenTick:
                btst    #0,$3B(a0)
                bne.s   SKSkorp_TailRestOscillatorReturn
                moveq   #1,d0
                btst    #0,$38(a0)
                bne.s   SKSkorp_TailApplyRestAngleStep
                neg.w   d0

SKSkorp_TailApplyRestAngleStep:
                add.b   d0,$3C(a0)

SKSkorp_TailRestOscillatorReturn:
                rts
; End of function OscillateSkorpTailLinkRestAngle

; ---------------------------------------------------------------------------
ObjDat_Skorp:
                dc.l    Map_Skorp
                dc.w    make_art_tile(ArtTile_Skorp,1,0)
                dc.w    $180
                dc.b    $10, $14,   0,   6
SkorpSK_TailNode_PartialAttributes:
                dc.w    $180
                dc.b    $10, $14,   3,   0
SKSkorp_BodyTailLinkChildren:
                dc.w    6-1
                dc.l    SKSkorp_TailDispatchAndDraw
SkorpSK_Body_UniformPatrolFrames:
                dc.b    9,   1,   0,   1,   2, $FC
                even

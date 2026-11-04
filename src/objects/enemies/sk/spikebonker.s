; Owner: objects/enemies/sk
; Responsibility: Spikebonker enemy controller, linked attack parts, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spikebonker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Spikebonker_Index(pc,d0.w),d1
                jsr     Spikebonker_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Spikebonker_Index:
                dc.w    SKSpikebonker_InitPatrol-Spikebonker_Index
                dc.w    SKSpikebonker_CheckP1AttackRange-Spikebonker_Index
                dc.w    SKSpikebonker_WaitForAttackEnd-Spikebonker_Index
; ---------------------------------------------------------------------------

SKSpikebonker_InitPatrol:
                lea     ObjDat_Spikebonker(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   SKSpikebonker_InitPatrolTimerAndPivot
                neg.w   d0

SKSpikebonker_InitPatrolTimerAndPivot:
                move.w  d0,x_vel(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                add.w   d1,d1
                subq.w  #1,d1
                move.w  d1,$3A(a0)
                move.l  #SKSpikebonker_ReversePatrol,$34(a0)
                lea     SpikebonkerSK_Root_OneNormalPivotRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  #$40,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #4,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikebonker_CheckP1AttackRange:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$60,d2
                bhs.s   SKSpikebonker_MoveAndTickPatrol
                btst    #0,render_flags(a0)
                beq.s   SKSpikebonker_CheckP1FacingSide
                subq.w  #2,d0

SKSpikebonker_CheckP1FacingSide:
                tst.w   d0
                beq.s   SKSpikebonker_RequestBallAttack

SKSpikebonker_MoveAndTickPatrol:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSpikebonker_RequestBallAttack:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSpikebonker_ReversePatrol:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikebonker_WaitForAttackEnd:
                btst    #3,$38(a0)
                bne.s   SKSpikebonker_AttackWaitReturn
                move.b  #2,routine(a0)

SKSpikebonker_AttackWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_InitPivotAndSpawnBall:
                lea     SKSpikebonker_PivotAndBallAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKSpikebonkerPivot_FollowAndCheckAttack,(a0)
                lea     SpikebonkerSK_Pivot_OneNormalBallRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_FollowAndCheckAttack:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                bne.s   SKSpikebonkerPivot_StepBallPhase
                movea.w parent3(a0),a2
                btst    #3,$38(a2)
                bne.s   SKSpikebonkerPivot_BeginOutwardTravel

SKSpikebonkerPivot_StepBallPhase:
                subq.b  #8,d0
                move.b  d0,$3C(a1)
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_BeginOutwardTravel:
                move.l  #SKSpikebonkerPivot_MoveAndTickTravel,(a0)
                moveq   #-4,d0
                btst    #0,render_flags(a0)
                beq.s   SKSpikebonkerPivot_SetOutwardTravelTimer
                neg.w   d0

SKSpikebonkerPivot_SetOutwardTravelTimer:
                move.w  d0,x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKSpikebonkerPivot_BeginHalfTurnWait,$34(a0)
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_MoveAndTickTravel:
                move.w  x_pos(a0),d0
                add.w   x_vel(a0),d0
                move.w  d0,x_pos(a0)
                jsr     (Obj_Wait).l
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_ResumeFollowAndAck:
                move.l  #SKSpikebonkerPivot_FollowAndCheckAttack,(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_BeginHalfTurnWait:
                move.l  #SKSpikebonkerPivot_WaitForBallHalfTurn,(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_WaitForBallHalfTurn:
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                cmpi.b  #$80,d0
                beq.s   SKSpikebonkerPivot_BeginReturnTravel
                subq.b  #8,d0
                move.b  d0,$3C(a1)
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKSpikebonkerPivot_BeginReturnTravel:
                move.l  #SKSpikebonkerPivot_MoveAndTickTravel,(a0)
                neg.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKSpikebonkerPivot_ResumeFollowAndAck,$34(a0)
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKSpikebonkerBall_DispatchBallAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSpikebonkerBall_BallStateOffsets(pc,d0.w),d1
                jsr     SKSpikebonkerBall_BallStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SKSpikebonkerBall_BallStateOffsets:
                dc.w    SKSpikebonkerBall_InitAndPublishHandle-SKSpikebonkerBall_BallStateOffsets
                dc.w    SKSpikebonkerBall_SelectFrameAndPriority-SKSpikebonkerBall_BallStateOffsets
; ---------------------------------------------------------------------------

SKSpikebonkerBall_InitAndPublishHandle:
                lea     SKSpikebonker_PivotAndBallAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                rts
; ---------------------------------------------------------------------------

SKSpikebonkerBall_SelectFrameAndPriority:
                move.b  $3C(a0),d0
                bsr.w   SelectSpikebonkerBallFrameByAngle
                move.w  #$200,priority(a0)
                addi.b  #$40,d0
                bpl.s   SKSpikebonkerBall_PlaceBallX
                move.w  #$280,priority(a0)

SKSpikebonkerBall_PlaceBallX:
                lea     (AngleLookup_1).l,a1
                jmp     (MoveSprite_AngleXLookupOffset).l

; =============== S U B R O U T I N E =======================================

SelectSpikebonkerBallFrameByAngle:
                moveq   #0,d1

SKSpikebonkerBall_ScanFrameThresholds:
                lea     SKSpikebonkerBall_PhaseFramePairs(pc,d1.w),a1
                cmp.b   (a1)+,d0
                bls.s   SKSpikebonkerBall_ApplySelectedFrame
                addq.w  #2,d1
                bra.s   SKSpikebonkerBall_ScanFrameThresholds
; ---------------------------------------------------------------------------

SKSpikebonkerBall_ApplySelectedFrame:
                move.b  (a1),mapping_frame(a0)
                rts
; End of function SelectSpikebonkerBallFrameByAngle

; ---------------------------------------------------------------------------
SKSpikebonkerBall_PhaseFramePairs:
                dc.b    0,   1
                dc.b    $30,   1
                dc.b    $50,   2
                dc.b    $B0,   3
                dc.b    $D0,   2
                dc.b    $FF,   1
                even
ObjDat_Spikebonker:
                dc.l    Map_Spikebonker
                dc.w    make_art_tile(ArtTile_Spikebonker,1,1)
                dc.w    $280
                dc.b    $10, $14,   0, $1A
SKSpikebonker_PivotAndBallAttributes:
                dc.w    $200
                dc.b    $10, $10,   1, $9A
SpikebonkerSK_Root_OneNormalPivotRecord:
                dc.w    1-1
                dc.l    SKSpikebonkerPivot_InitPivotAndSpawnBall
                dc.b    0, $14
SpikebonkerSK_Pivot_OneNormalBallRecord:
                dc.w    1-1
                dc.l    SKSpikebonkerBall_DispatchBallAndDraw
                dc.b    0,   0

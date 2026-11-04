; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace transient effects, fragments, timed motion and chain child construction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZEffect_InitSparkAndTickDelay:
                lea     SKHpzEmeraldLift_InitialSparkAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZEffect_SparkWaitHidden,(a0)
                addi.w  #$30,y_pos(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)

HPZEffect_SparkWaitHidden:
                subq.w  #1,$2E(a0)
                bmi.s   HPZEffect_RandomizeSparkAndStartAnim
                rts
; ---------------------------------------------------------------------------

HPZEffect_RandomizeSparkAndStartAnim:
                move.l  #HPZEffect_AnimateInitialSpark,(a0)
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                subi.w  #$20,d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$3F,d0
                subi.w  #$20,d0
                add.w   d0,y_pos(a0)
                move.l  #HPZEffect_StartRisingSpark,$34(a0)

HPZEffect_AnimateInitialSpark:
                lea     SKSceneAnim_HPZEmeraldSparkInitial(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZEffect_StartRisingSpark:
                move.l  #HPZEffect_AnimateAndMoveRisingSpark,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

HPZEffect_AnimateAndMoveRisingSpark:
                lea     SKSceneAnim_HPZEmeraldSparkRising(pc),a1
                jsr     (Animate_RawNoSST).l
                subi.w  #$80,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZEffect_InitEmeraldPiece:
                lea     SKSceneData_HPZEmeraldFragmentAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZEffect_PieceFollowAndTickRelease,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  HPZEffect_EmeraldPieceOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                move.w  SKHPZAux_EmeraldPieceFiveReleaseDelays(pc,d0.w),$2E(a0)
                lsr.w   #1,d1
                move.b  SKHPZAux_EmeraldPieceFiveSubtypeFrames(pc,d1.w),mapping_frame(a0)
                move.l  #HPZEffect_ReleasePieceWithPriority,$34(a0)
                rts
; ---------------------------------------------------------------------------
SKHPZAux_EmeraldPieceFiveSubtypeFrames:
                dc.b    $1C, $1B, $1A, $19, $18
                even
HPZEffect_EmeraldPieceOffsets:
                dc.b    4, $2C
                dc.b    -2, $2A
                dc.b    6, $22
                dc.b    -8, $24
                dc.b    -2, $1C
SKHPZAux_EmeraldPieceFiveReleaseDelays:
                dc.w    $20
                dc.w    $30
                dc.w    $40
                dc.w    $50
                dc.w    $60
; ---------------------------------------------------------------------------

HPZEffect_PieceFollowAndTickRelease:
                jsr     (Refresh_ChildPosition).l
                jsr     (Obj_Wait).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

HPZEffect_ReleasePieceWithPriority:
                move.l  #HPZEffect_MoveAndCullReleasedPiece,(a0)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

HPZEffect_MoveAndCullReleasedPiece:
                jsr     (MoveSprite).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

HPZEffect_InitDelayedExplosion:
                move.l  #HPZEffect_TickDelayThenInitExplosion,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     HPZEffect_DelayedExplosionOffsets(pc,d0.w),a1
                move.w  (Camera_X_pos).w,d1
                addi.w  #$140,d1
                move.w  (Camera_Y_pos).w,d2
                addi.w  #$C0,d2
                move.b  (a1)+,d3
                ext.w   d3
                add.w   d3,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,y_pos(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------
HPZEffect_DelayedExplosionOffsets:
                dc.b    -$10, -$58
                dc.b    -$18, -$30
                dc.b    -8, -$10
                dc.b    -$10, -$70
                dc.b    -$20, -$60
                dc.b    -8, -$38
                dc.b    -$20, -$10
                dc.b    -$20, -$40
                dc.b    -$40, -$58
                dc.b    -$30, -$30
                dc.b    -$40,   -8
                dc.b    -$48, -$38
                dc.b    -$38, -$20
                dc.b    -$60, -$40
                dc.b    -$58, -$20
                dc.b    -$70,   -8
                even
; ---------------------------------------------------------------------------

HPZEffect_TickDelayThenInitExplosion:
                subq.w  #1,$2E(a0)
                bpl.w   SKAIZScene_SharedSceneReturn
                lea     (Obj_Explosion).l,a1
                move.l  a1,(a0)
                move.b  #2,routine(a0)
                jsr     (a1)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

HPZEffect_InitCraneRootAndSelectGroup:
                lea     SKHpzCrane_ChainBranchRootAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZEffect_SignalCraneReleaseAtZero,(a0)
                move.w  #4*60,$2E(a0)
                lea     SKHpzCrane_NegativePhaseChainSpawnList(pc),a2
                tst.b   subtype(a0)
                beq.s   HPZEffect_BuildCraneSegmentChain
                lea     SKHpzCrane_PositivePhaseChainSpawnList(pc),a2

; Each segment links to the previous one and keeps a separate pointer to the root
HPZEffect_BuildCraneSegmentChain:
                jmp     (CreateChild8_TreeListRepeated).l
; ---------------------------------------------------------------------------

HPZEffect_SignalCraneReleaseAtZero:
                subq.w  #1,$2E(a0)
                bne.s   HPZEffect_FollowShipOrDeleteRoot
                bset    #7,$38(a0)

HPZEffect_FollowShipOrDeleteRoot:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l

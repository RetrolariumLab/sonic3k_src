; Owner: objects/enemies/sk
; Responsibility: Dragonfly enemy flight, attack states, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Dragonfly:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Dragonfly_Index(pc,d0.w),d1
                jsr     Dragonfly_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Dragonfly_Index:
                dc.w    SKDragonfly_InitBodyWingAndTail-Dragonfly_Index
                dc.w    SKDragonfly_MoveAndCheckSwingApex-Dragonfly_Index
                dc.w    SKDragonfly_SwingXAndTickPause-Dragonfly_Index
; ---------------------------------------------------------------------------

SKDragonfly_InitBodyWingAndTail:
                lea     SKDragonfly_BodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKDragonfly_TransformReverseAnim,$30(a0)
                lea     SKMHZDragonfly_Root_OneNormalWingRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     SKDragonfly_TailLinkChildren(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                move.w  #$200,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)

SKDragonfly_ResetHorizontalSwing:
                move.w  #$200,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonfly_MoveAndCheckSwingApex:
                jsr     (Animate_Raw).l
                jsr     (Swing_LeftAndRight).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                beq.s   SKDragonfly_PauseVerticalAndSignalTail
                rts
; ---------------------------------------------------------------------------

SKDragonfly_PauseVerticalAndSignalTail:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKDragonfly_ResumeSwingAndSwapAnim,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonfly_SwingXAndTickPause:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKDragonfly_ResumeSwingAndSwapAnim:
                move.b  #2,routine(a0)
                bclr    #2,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #SKDragonfly_TransformForwardAnim,$30(a0)
                bchg    #1,$38(a0)
                bne.s   SKDragonfly_AnimationSelectReturn
                move.l  #SKDragonfly_TransformReverseAnim,$30(a0)

SKDragonfly_AnimationSelectReturn:
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_DispatchLinkAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKDragonflyLink_LinkStateOffsets(pc,d0.w),d1
                jsr     SKDragonflyLink_LinkStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SKDragonflyLink_LinkStateOffsets:
                dc.w    SKDragonflyLink_InitTailLink-SKDragonflyLink_LinkStateOffsets
                dc.w    SKDragonflyLink_FollowAndTickStartDelay-SKDragonflyLink_LinkStateOffsets
                dc.w    SKDragonflyLink_FollowAndCheckSignal-SKDragonflyLink_LinkStateOffsets
                dc.w    SKDragonflyLink_SwingAndApproachPrevY-SKDragonflyLink_LinkStateOffsets
                dc.w    SKDragonflyLink_SwingAndCheckReturnY-SKDragonflyLink_LinkStateOffsets
; ---------------------------------------------------------------------------

SKDragonflyLink_InitTailLink:
                lea     SKDragonflyLink_LinkAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #1,render_flags(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #$C,d0
                bne.s   SKDragonflyLink_InitDelayAndYStep
                move.b  #6,mapping_frame(a0)

SKDragonflyLink_InitDelayAndYStep:
                move.w  d0,$2E(a0)
                move.b  #1,child_dx(a0)
                bra.w   SKDragonflyLink_InitFollowOffset
; ---------------------------------------------------------------------------

SKDragonflyLink_FollowAndTickStartDelay:
                bsr.w   FollowDragonflyLinkPredecessorY
                subq.w  #1,$2E(a0)
                bmi.s   SKDragonflyLink_BeginHorizontalSwing
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_BeginHorizontalSwing:
                move.b  #4,routine(a0)
                bra.w   SKDragonfly_ResetHorizontalSwing
; ---------------------------------------------------------------------------

SKDragonflyLink_FollowAndCheckSignal:
                bsr.w   FollowDragonflyLinkPredecessorY
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   SKDragonflyLink_RelaySignalAndAlignY
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_RelaySignalAndAlignY:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_SwingAndApproachPrevY:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a0),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d1,d0
                cmp.w   y_pos(a1),d0
                beq.s   SKDragonflyLink_BeginReturnToOffset
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_BeginReturnToOffset:
                move.w  y_pos(a1),y_pos(a0)
                move.b  #8,routine(a0)
                neg.b   child_dx(a0)
                neg.b   child_dy(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_SwingAndCheckReturnY:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bmi.s   SKDragonflyLink_CheckNegativeReturnY
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bls.s   SKDragonflyLink_FinishOffsetReturn
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_CheckNegativeReturnY:
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKDragonflyLink_FinishOffsetReturn
                rts
; ---------------------------------------------------------------------------

SKDragonflyLink_FinishOffsetReturn:
                move.b  #4,routine(a0)
                move.w  d0,y_pos(a0)
                bchg    #1,render_flags(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKDragonflyWing_InitWing:
                lea     SKDragonflyWing_WingAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKDragonflyWing_FollowAndAnimateWing,(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDragonflyWing_FollowAndAnimateWing:
                jsr     (Refresh_ChildPosition).l
                lea     SKDragonflyWing_FlapAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDragonflyLink_InitFollowOffset:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  SKDragonflyLink_InitialFollowOffsets(pc,d0.w),child_dy(a0)
                rts
; ---------------------------------------------------------------------------
SKDragonflyLink_InitialFollowOffsets:
                dc.b    -$C,  -5,  -5,  -5,  -5,  -5,  -5
                even

; =============== S U B R O U T I N E =======================================

FollowDragonflyLinkPredecessorY:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function FollowDragonflyLinkPredecessorY

; ---------------------------------------------------------------------------
SKDragonfly_BodyAttributes:
                dc.l    Map_Dragonfly
                dc.w    make_art_tile(ArtTile_Dragonfly,1,1)
                dc.w    $280
                dc.b    8,   8,   4, $17
SKDragonflyWing_WingAttributes:
                dc.w    $280
                dc.b    $20,   8,   7,   0
SKDragonflyLink_LinkAttributes:
                dc.w    $280
                dc.b    4,   4,   5, $98
SKMHZDragonfly_Root_OneNormalWingRecord:
                dc.w    1-1
                dc.l    SKDragonflyWing_InitWing
                dc.b    0,   0
SKDragonfly_TailLinkChildren:
                dc.w    7-1
                dc.l    SKDragonflyLink_DispatchLinkAndDraw
SKDragonflyWing_FlapAnimation:
                dc.b    0,   7,   9,   8,   9, $FC
SKDragonfly_TransformForwardAnim:
                dc.b    3,   0,   1,   2,   3,   4
                dc.b    $F8, .jump-SKDragonfly_TransformForwardAnim

                .jump:
                dc.b    $7F,   4,   4, $FC
SKDragonfly_TransformReverseAnim:
                dc.b    3,   4,   3,   2,   1,   0
                dc.b    $F8, .jump-SKDragonfly_TransformReverseAnim

                .jump:
                dc.b    $7F,   0,   0, $FC
                even
Map_Dragonfly:
                include "src/objects/shared/dragonfly/mappings/dragonfly.s"

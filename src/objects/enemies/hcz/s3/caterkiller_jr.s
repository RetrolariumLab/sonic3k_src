; Owner: objects/enemies/hcz/s3
; Responsibility: Caterkiller Junior controller, following segments and child construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CaterKillerJr:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CaterKillerJr_Index(pc,d0.w),d1
                jsr     CaterKillerJr_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
CaterKillerJr_Index:
                dc.w    S3CaterkillerJr_InitRootAndTrySegments-CaterKillerJr_Index
                dc.w    S3CaterkillerJr_StepSmallBob-CaterKillerJr_Index
                dc.w    S3CaterkillerJr_StepSmallBob-CaterKillerJr_Index
                dc.w    S3CaterkillerJr_TurnAtLargeBobReversal-CaterKillerJr_Index
                dc.w    S3CaterkillerJr_FinishLargeBob-CaterKillerJr_Index
; ---------------------------------------------------------------------------

S3CaterkillerJr_InitRootAndTrySegments:
                lea     ObjDat_CaterKillerJr(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$100,x_vel(a0)
                lea     S3CaterkillerJr_RepeatedSegmentRecord(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)

S3CaterkillerJr_BeginSmallBob:
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3CaterkillerJr_StepSmallBob:
                jsr     Swing_UpAndDown_Count(pc)
                bne.s   S3CaterkillerJr_BeginLargeBob
                jsr     (MoveSprite2).l
                bra.w   S3CaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

S3CaterkillerJr_BeginLargeBob:
                move.b  #6,routine(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3CaterkillerJr_TurnAtLargeBobReversal:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   S3CaterkillerJr_MoveAndCheckEffect
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3CaterkillerJr_MoveAndCheckEffect:
                jsr     (MoveSprite2).l
                bra.w   S3CaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

S3CaterkillerJr_FinishLargeBob:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                bne.s   S3CaterkillerJr_BeginSmallBob
                jsr     (MoveSprite2).l
                bra.w   S3CaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

S3CaterkillerJr_UpdateSegment:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3CaterkillerJr_SegmentStateOffsets(pc,d0.w),d1
                jsr     S3CaterkillerJr_SegmentStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
S3CaterkillerJr_SegmentStateOffsets:
                dc.w    S3CaterkillerJr_InitSegmentAttrsAndDelay-S3CaterkillerJr_SegmentStateOffsets
                dc.w    S3CaterkillerJr_WaitSegmentStart-S3CaterkillerJr_SegmentStateOffsets
                dc.w    S3CaterkillerJr_StepSmallBob-S3CaterkillerJr_SegmentStateOffsets
                dc.w    S3CaterkillerJr_TurnAtLargeBobReversal-S3CaterkillerJr_SegmentStateOffsets
                dc.w    S3CaterkillerJr_FinishLargeBob-S3CaterkillerJr_SegmentStateOffsets
; ---------------------------------------------------------------------------

S3CaterkillerJr_InitSegmentAttrsAndDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3CaterkillerJr_SegmentAttrOffsets(pc,d0.w),d1
                lea     S3CaterkillerJr_SegmentAttrOffsets(pc,d1.w),a1
                lsr.w   #1,d0
                move.b  S3CaterkillerJr_SegmentStartDelays(pc,d0.w),$2F(a0)
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------
S3CaterkillerJr_SegmentAttrOffsets:
                dc.w    S3CaterkillerJr_LeadingSegmentAttrs-S3CaterkillerJr_SegmentAttrOffsets
                dc.w    S3CaterkillerJr_LeadingSegmentAttrs-S3CaterkillerJr_SegmentAttrOffsets
                dc.w    S3CaterkillerJr_LeadingSegmentAttrs-S3CaterkillerJr_SegmentAttrOffsets
                dc.w    S3CaterkillerJr_FourthSegmentAttrs-S3CaterkillerJr_SegmentAttrOffsets
                dc.w    S3CaterkillerJr_TailMonkeyDudeAttrs-S3CaterkillerJr_SegmentAttrOffsets
                dc.w    S3CaterkillerJr_TailMonkeyDudeAttrs-S3CaterkillerJr_SegmentAttrOffsets
S3CaterkillerJr_SegmentStartDelays:
                dc.b    $B, $17, $23, $2F, $37, $3F
                even
; ---------------------------------------------------------------------------

S3CaterkillerJr_WaitSegmentStart:
                subq.w  #1,$2E(a0)
                bmi.s   S3CaterkillerJr_StartSegmentMotion
                rts
; ---------------------------------------------------------------------------

S3CaterkillerJr_StartSegmentMotion:
                move.b  #4,routine(a0)
                moveq   #$40,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #2,d0
                lsl.w   #2,d0
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #S3CaterkillerJr_RearmAndTryEffect,$34(a0)
                move.w  #-$100,x_vel(a0)
                bra.w   S3CaterkillerJr_BeginSmallBob
; ---------------------------------------------------------------------------

S3CaterkillerJr_InitAttachedEffect:
                lea     S3CaterkillerJr_AttachedEffectAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3CaterkillerJr_UpdateAttachedEffect,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bset    #4,shield_reaction(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

S3CaterkillerJr_UpdateAttachedEffect:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     S3CaterkillerJr_AttachedEffectAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

S3CaterkillerJr_TryTickPeriodicEffect:
                cmpi.l  #S3CaterkillerJr_UpdateSegment,(a0)
                bne.s   S3CaterkillerJr_PeriodicEffectReturn
                cmpi.b  #6,subtype(a0)
                bhs.s   S3CaterkillerJr_PeriodicEffectReturn
                jsr     Obj_Wait(pc)

S3CaterkillerJr_PeriodicEffectReturn:
                rts
; ---------------------------------------------------------------------------

S3CaterkillerJr_RearmAndTryEffect:
                move.w  #$1A,$2E(a0)
                lea     S3CaterkillerJr_AttachedEffectRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
ObjDat_CaterKillerJr:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   0, $17
S3CaterkillerJr_LeadingSegmentAttrs:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,  $C,   1, $97
S3CaterkillerJr_FourthSegmentAttrs:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   2, $97
S3CaterkillerJr_TailMonkeyDudeAttrs:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    4,   4,   3, $98
S3CaterkillerJr_AttachedEffectAttrs:
                dc.w    $200
                dc.b    $10, $10,   3,   0
S3CaterkillerJr_RepeatedSegmentRecord:
                dc.w    6-1
                dc.l    S3CaterkillerJr_UpdateSegment
                dc.b    0,   0
S3CaterkillerJr_AttachedEffectRecord:
                dc.w    1-1
                dc.l    S3CaterkillerJr_InitAttachedEffect
                dc.b    0,   0
S3CaterkillerJr_AttachedEffectAnim:
                dc.b    3,   2
                dc.b    3,   2
                dc.b    4,   3
                dc.b    5,   4
                dc.b    $F4
                even

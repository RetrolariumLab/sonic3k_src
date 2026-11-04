; Owner: objects/enemies/hcz/sk
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
                dc.w    SKCaterkillerJr_InitRootAndTrySegments-CaterKillerJr_Index
                dc.w    SKCaterkillerJr_StepSmallBob-CaterKillerJr_Index
                dc.w    SKCaterkillerJr_StepSmallBob-CaterKillerJr_Index
                dc.w    SKCaterkillerJr_TurnAtLargeBobReversal-CaterKillerJr_Index
                dc.w    SKCaterkillerJr_FinishLargeBob-CaterKillerJr_Index
; ---------------------------------------------------------------------------

SKCaterkillerJr_InitRootAndTrySegments:
                lea     ObjDat_CaterKillerJr(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$100,x_vel(a0)
                lea     SKCaterkillerJr_RepeatedSegmentRecord(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)

SKCaterkillerJr_BeginSmallBob:
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKCaterkillerJr_StepSmallBob:
                jsr     Swing_UpAndDown_Count(pc)
                bne.s   SKCaterkillerJr_BeginLargeBob
                jsr     (MoveSprite2).l
                bra.w   SKCaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

SKCaterkillerJr_BeginLargeBob:
                move.b  #6,routine(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKCaterkillerJr_TurnAtLargeBobReversal:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   SKCaterkillerJr_MoveAndCheckEffect
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKCaterkillerJr_MoveAndCheckEffect:
                jsr     (MoveSprite2).l
                bra.w   SKCaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

SKCaterkillerJr_FinishLargeBob:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                bne.s   SKCaterkillerJr_BeginSmallBob
                jsr     (MoveSprite2).l
                bra.w   SKCaterkillerJr_TryTickPeriodicEffect
; ---------------------------------------------------------------------------

SKCaterkillerJr_UpdateSegment:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKCaterkillerJr_SegmentStateOffsets(pc,d0.w),d1
                jsr     SKCaterkillerJr_SegmentStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SKCaterkillerJr_SegmentStateOffsets:
                dc.w    SKCaterkillerJr_InitSegmentAttrsAndDelay-SKCaterkillerJr_SegmentStateOffsets
                dc.w    SKCaterkillerJr_WaitSegmentStart-SKCaterkillerJr_SegmentStateOffsets
                dc.w    SKCaterkillerJr_StepSmallBob-SKCaterkillerJr_SegmentStateOffsets
                dc.w    SKCaterkillerJr_TurnAtLargeBobReversal-SKCaterkillerJr_SegmentStateOffsets
                dc.w    SKCaterkillerJr_FinishLargeBob-SKCaterkillerJr_SegmentStateOffsets
; ---------------------------------------------------------------------------

SKCaterkillerJr_InitSegmentAttrsAndDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKCaterkillerJr_SegmentAttrOffsets(pc,d0.w),d1
                lea     SKCaterkillerJr_SegmentAttrOffsets(pc,d1.w),a1
                lsr.w   #1,d0
                move.b  SKCaterkillerJr_SegmentStartDelays(pc,d0.w),$2F(a0)
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------
SKCaterkillerJr_SegmentAttrOffsets:
                dc.w    SKCaterkillerJr_LeadingSegmentAttrs-SKCaterkillerJr_SegmentAttrOffsets
                dc.w    SKCaterkillerJr_LeadingSegmentAttrs-SKCaterkillerJr_SegmentAttrOffsets
                dc.w    SKCaterkillerJr_LeadingSegmentAttrs-SKCaterkillerJr_SegmentAttrOffsets
                dc.w    SKCaterkillerJr_FourthSegmentAttrs-SKCaterkillerJr_SegmentAttrOffsets
                dc.w    SKCaterkillerJr_TailMonkeyDudeAttrs-SKCaterkillerJr_SegmentAttrOffsets
                dc.w    SKCaterkillerJr_TailMonkeyDudeAttrs-SKCaterkillerJr_SegmentAttrOffsets
SKCaterkillerJr_SegmentStartDelays:
                dc.b    $B, $17, $23, $2F, $37, $3F
                even
; ---------------------------------------------------------------------------

SKCaterkillerJr_WaitSegmentStart:
                subq.w  #1,$2E(a0)
                bmi.s   SKCaterkillerJr_StartSegmentMotion
                rts
; ---------------------------------------------------------------------------

SKCaterkillerJr_StartSegmentMotion:
                move.b  #4,routine(a0)
                moveq   #$40,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #2,d0
                lsl.w   #2,d0
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #SKCaterkillerJr_RearmAndTryEffect,$34(a0)
                move.w  #-$100,x_vel(a0)
                bra.w   SKCaterkillerJr_BeginSmallBob
; ---------------------------------------------------------------------------

SKCaterkillerJr_InitAttachedEffect:
                lea     SKCaterkillerJr_AttachedEffectAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKCaterkillerJr_UpdateAttachedEffect,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bset    #4,shield_reaction(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCaterkillerJr_UpdateAttachedEffect:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     SKCaterkillerJr_AttachedEffectAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCaterkillerJr_TryTickPeriodicEffect:
                cmpi.l  #SKCaterkillerJr_UpdateSegment,(a0)
                bne.s   SKCaterkillerJr_PeriodicEffectReturn
                cmpi.b  #6,subtype(a0)
                bhs.s   SKCaterkillerJr_PeriodicEffectReturn
                jsr     Obj_Wait(pc)

SKCaterkillerJr_PeriodicEffectReturn:
                rts
; ---------------------------------------------------------------------------

SKCaterkillerJr_RearmAndTryEffect:
                move.w  #$1A,$2E(a0)
                lea     SKCaterkillerJr_AttachedEffectRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
ObjDat_CaterKillerJr:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   0, $17
SKCaterkillerJr_LeadingSegmentAttrs:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,  $C,   1, $97
SKCaterkillerJr_FourthSegmentAttrs:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   2, $97
SKCaterkillerJr_TailMonkeyDudeAttrs:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    4,   4,   3, $98
SKCaterkillerJr_AttachedEffectAttrs:
                dc.w    $200
                dc.b    $10, $10,   3,   0
SKCaterkillerJr_RepeatedSegmentRecord:
                dc.w    6-1
                dc.l    SKCaterkillerJr_UpdateSegment
                dc.b    0,   0
SKCaterkillerJr_AttachedEffectRecord:
                dc.w    1-1
                dc.l    SKCaterkillerJr_InitAttachedEffect
                dc.b    0,   0
SKCaterkillerJr_AttachedEffectAnim:
                dc.b    3,   2
                dc.b    3,   2
                dc.b    4,   3
                dc.b    5,   4
                dc.b    $F4
                even

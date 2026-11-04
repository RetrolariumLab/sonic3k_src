; Owner: objects/runtime/sk
; Responsibility: Gravity variants and circular or angle-indexed object motion with their private lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

MoveSprite_LightGravity:
                moveq   #$20,d1

MoveSprite_CustomGravity:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a0)
                move.w  y_vel(a0),d0
                add.w   d1,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                rts
; End of function MoveSprite_LightGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_NormGravity:
                moveq   #$38,d1
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                add.w   d1,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                rts
; End of function MoveSprite_NormGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_Circular:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                move.w  $3A(a0),d2
                move.w  d2,d3
                muls.w  d0,d2
                swap    d2
                muls.w  d1,d3
                swap    d3
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                add.w   d2,d0
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d1
                add.w   d3,d1
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d1
                move.w  d1,y_pos(a0)
                rts
; End of function MoveSprite_Circular

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimple:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimple

; ---------------------------------------------------------------------------

MoveSprite_CircularSimpleCheckFlip:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                btst    #0,render_flags(a1)
                beq.s   SKRuntimeCurve_CommitParentFlippedFullPrecisionSimpleCircularPosition
                neg.l   d0

SKRuntimeCurve_CommitParentFlippedFullPrecisionSimpleCircularPosition:
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimpleOffset:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                swap    d4
                clr.w   d4
                add.l   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                swap    d4
                clr.w   d4
                add.l   d4,d3
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimpleOffset

; =============== S U B R O U T I N E =======================================

MoveSprite_AtAngleLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AtAngle_LookupIndex(pc,d1.w),d1
                jsr     AtAngle_LookupIndex(pc,d1.w)
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AtAngleLookup

; ---------------------------------------------------------------------------
AtAngle_LookupIndex:
                dc.w    AtAngle_00_3F-AtAngle_LookupIndex
                dc.w    AtAngle_40_7F-AtAngle_LookupIndex
                dc.w    AtAngle_80_BF-AtAngle_LookupIndex
                dc.w    AtAngle_C0_FF-AtAngle_LookupIndex
; ---------------------------------------------------------------------------

AtAngle_00_3F:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                rts
; ---------------------------------------------------------------------------

AtAngle_40_7F:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_80_BF:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_C0_FF:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                btst    #0,render_flags(a0)
                beq.s   SKRuntimeCurve_AddChildOffsetsAndDispatchCircularLookupQuadrant
                neg.w   d4

SKRuntimeCurve_AddChildOffsetsAndDispatchCircularLookupQuadrant:
                add.w   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                move.w  d0,d4
                not.w   d4
                lea     AtAngle_LookupIndex(pc),a4
                move.w  (a4,d1.w),d1
                jsr     (a4,d1.w)
                btst    #0,render_flags(a0)
                beq.s   SKRuntimeCurve_CommitChildCircularLookupIntegerCoordinates
                neg.w   d5

SKRuntimeCurve_CommitChildCircularLookupIntegerCoordinates:
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularLookup

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleYLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AngleY_LookupIndex(pc,d1.w),d1
                jsr     AngleY_LookupIndex(pc,d1.w)
                add.w   d1,d3
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AngleYLookup

; ---------------------------------------------------------------------------
AngleY_LookupIndex:
                dc.w    SKRuntimeCurve_SampleReversePositiveYForPhaseFirstQuarter-AngleY_LookupIndex
                dc.w    SKRuntimeCurve_SampleForwardNegativeYForPhaseSecondQuarter-AngleY_LookupIndex
                dc.w    SKRuntimeCurve_SampleReverseNegativeYForPhaseThirdQuarter-AngleY_LookupIndex
                dc.w    SKRuntimeCurve_SampleForwardPositiveYForPhaseFourthQuarter-AngleY_LookupIndex
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleReversePositiveYForPhaseFirstQuarter:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleForwardNegativeYForPhaseSecondQuarter:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleReverseNegativeYForPhaseThirdQuarter:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleForwardPositiveYForPhaseFourthQuarter:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleXLookupOffset:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  AngleX_LookupIndex(pc,d1.w),d2
                jmp     AngleX_LookupIndex(pc,d2.w)
; End of function MoveSprite_AngleXLookupOffset

; ---------------------------------------------------------------------------
AngleX_LookupIndex:
                dc.w    SKRuntimeCurve_SampleForwardPositiveXForPhaseFirstQuarter-AngleX_LookupIndex
                dc.w    SKRuntimeCurve_SampleReversePositiveXForPhaseSecondQuarter-AngleX_LookupIndex
                dc.w    SKRuntimeCurve_SampleForwardNegativeXForPhaseThirdQuarter-AngleX_LookupIndex
                dc.w    SKRuntimeCurve_SampleReverseNegativeXForPhaseFourthQuarter-AngleX_LookupIndex
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleForwardPositiveXForPhaseFirstQuarter:
                move.b  (a1,d0.w),d1
                bra.w   SKRuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleReversePositiveXForPhaseSecondQuarter:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                bra.w   SKRuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleForwardNegativeXForPhaseThirdQuarter:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   SKRuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleReverseNegativeXForPhaseFourthQuarter:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   SKRuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

SKRuntimeCurve_BuildParentOffsetCoordinatesForSampledX:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                btst    #0,render_flags(a1)
                beq.s   SKRuntimeCurve_CommitSampleMirroredByParentFacingToIntegerOffsetPosition
                neg.w   d1

SKRuntimeCurve_CommitSampleMirroredByParentFacingToIntegerOffsetPosition:
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
                moveq   #0,d0                           ; Same as above but unused
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets(pc,d1.w),d2
                jmp     SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets(pc,d2.w)
; ---------------------------------------------------------------------------
SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets:
                dc.w    SKRuntimeCurve_SampleByteForwardPositiveYInMixedWidthLookup-SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    SKRuntimeCurve_SampleWordReverseYInMixedWidthSecondQuarter-SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    SKRuntimeCurve_SampleWordForwardNegativeYInMixedWidthThirdQuarter-SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    SKRuntimeCurve_SampleWordReverseNegativeYInMixedWidthFourthQuarter-SKRuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleByteForwardPositiveYInMixedWidthLookup:
                move.b  (a1,d0.w),d1
                bra.w   SKRuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleWordReverseYInMixedWidthSecondQuarter:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                bra.w   SKRuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleWordForwardNegativeYInMixedWidthThirdQuarter:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   SKRuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

SKRuntimeCurve_SampleWordReverseNegativeYInMixedWidthFourthQuarter:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   SKRuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY

SKRuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts

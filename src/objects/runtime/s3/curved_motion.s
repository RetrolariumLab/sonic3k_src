; Owner: objects/runtime/s3
; Responsibility: Light gravity and circular, angle and indexed coordinate motion with their inseparable lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

MoveSprite_LightGravity:
                moveq   #$20,d1
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

MoveSprite_CircularSimple:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                asr.w   d2,d0
                asr.w   d2,d1
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   d0,d2
                add.w   d1,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimple

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimpleOffset:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                asr.w   d2,d0
                asr.w   d2,d1
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                add.w   d0,d2
                add.w   d1,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
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
                beq.s   S3RuntimeCurve_AddChildOffsetsAndDispatchCircularLookupQuadrant
                neg.w   d4

S3RuntimeCurve_AddChildOffsetsAndDispatchCircularLookupQuadrant:
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
                beq.s   S3RuntimeCurve_CommitChildCircularLookupIntegerCoordinates
                neg.w   d5

S3RuntimeCurve_CommitChildCircularLookupIntegerCoordinates:
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
                dc.w    S3RuntimeCurve_SampleReversePositiveYForPhaseFirstQuarter-AngleY_LookupIndex
                dc.w    S3RuntimeCurve_SampleForwardNegativeYForPhaseSecondQuarter-AngleY_LookupIndex
                dc.w    S3RuntimeCurve_SampleReverseNegativeYForPhaseThirdQuarter-AngleY_LookupIndex
                dc.w    S3RuntimeCurve_SampleForwardPositiveYForPhaseFourthQuarter-AngleY_LookupIndex
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleReversePositiveYForPhaseFirstQuarter:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleForwardNegativeYForPhaseSecondQuarter:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleReverseNegativeYForPhaseThirdQuarter:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleForwardPositiveYForPhaseFourthQuarter:
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
                dc.w    S3RuntimeCurve_SampleForwardPositiveXForPhaseFirstQuarter-AngleX_LookupIndex
                dc.w    S3RuntimeCurve_SampleReversePositiveXForPhaseSecondQuarter-AngleX_LookupIndex
                dc.w    S3RuntimeCurve_SampleForwardNegativeXForPhaseThirdQuarter-AngleX_LookupIndex
                dc.w    S3RuntimeCurve_SampleReverseNegativeXForPhaseFourthQuarter-AngleX_LookupIndex
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleForwardPositiveXForPhaseFirstQuarter:
                move.b  (a1,d0.w),d1
                bra.w   S3RuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleReversePositiveXForPhaseSecondQuarter:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                bra.w   S3RuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleForwardNegativeXForPhaseThirdQuarter:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   S3RuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleReverseNegativeXForPhaseFourthQuarter:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   S3RuntimeCurve_BuildParentOffsetCoordinatesForSampledX
; ---------------------------------------------------------------------------

S3RuntimeCurve_BuildParentOffsetCoordinatesForSampledX:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
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
                move.w  S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets(pc,d1.w),d2
                jmp     S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets(pc,d2.w)
; ---------------------------------------------------------------------------
S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets:
                dc.w    S3RuntimeCurve_SampleByteForwardPositiveYInMixedWidthLookup-S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    S3RuntimeCurve_SampleWordReverseYInMixedWidthSecondQuarter-S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    S3RuntimeCurve_SampleWordForwardNegativeYInMixedWidthThirdQuarter-S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
                dc.w    S3RuntimeCurve_SampleWordReverseNegativeYInMixedWidthFourthQuarter-S3RuntimeCurve_MixedWidthYLookupQuarterRelativeWordOffsets
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleByteForwardPositiveYInMixedWidthLookup:
                move.b  (a1,d0.w),d1
                bra.w   S3RuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleWordReverseYInMixedWidthSecondQuarter:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                bra.w   S3RuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleWordForwardNegativeYInMixedWidthThirdQuarter:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   S3RuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

S3RuntimeCurve_SampleWordReverseNegativeYInMixedWidthFourthQuarter:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   S3RuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY
; ---------------------------------------------------------------------------

S3RuntimeCurve_CommitParentOffsetXAndMixedWidthSampledY:
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

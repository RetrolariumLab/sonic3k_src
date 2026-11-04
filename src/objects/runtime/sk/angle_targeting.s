; Owner: objects/runtime/sk
; Responsibility: Object-to-player angular targeting and angle calculation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

GetApproximateObjectBearing:
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                moveq   #0,d4
                move.w  x_pos(a2),d0
                move.w  y_pos(a2),d1
                sub.w   x_pos(a1),d0
                bpl.s   SKRuntime_Bearing_ExtractVerticalSignAfterHorizontalMagnitude
                neg.w   d0
                moveq   #8,d2

SKRuntime_Bearing_ExtractVerticalSignAfterHorizontalMagnitude:
                sub.w   y_pos(a1),d1
                bpl.s   SKRuntime_Bearing_OrderUnsignedMinorAndMajorAxisMagnitudes
                neg.w   d1
                moveq   #4,d3

SKRuntime_Bearing_OrderUnsignedMinorAndMajorAxisMagnitudes:
                cmp.w   d0,d1
                bhs.s   SKRuntime_Bearing_DivideWordShiftedMinorAndDispatchQuadrant
                exg     d0,d1
                moveq   #2,d4

SKRuntime_Bearing_DivideWordShiftedMinorAndDispatchQuadrant:
                tst.w   d1
                beq.s   SKRuntime_Bearing_ReturnZeroOrPositiveXYVerticalRatio
                lsl.w   #5,d0
                divu.w  d1,d0
                add.w   d2,d3
                add.w   d3,d4
                move.w  SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets(pc,d4.w),d4
                jmp     SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets(pc,d4.w)
; ---------------------------------------------------------------------------
SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets:
                dc.w    SKRuntime_Bearing_ReturnZeroOrPositiveXYVerticalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_ComplementPositiveXYHorizontalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_ComplementNegativeYVerticalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_AddQuarterTurnForNegativeYHorizontalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_NegateNegativeXVerticalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_AddThreeQuarterTurnForNegativeXHorizontalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_AddHalfTurnForNegativeXYVerticalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
                dc.w    SKRuntime_Bearing_ComplementNegativeXYHorizontalRatio-SKRuntime_Bearing_QuadrantMajorAxisHandlerOffsets
; ---------------------------------------------------------------------------

SKRuntime_Bearing_ReturnZeroOrPositiveXYVerticalRatio:
                rts
; End of function GetApproximateObjectBearing

; ---------------------------------------------------------------------------

SKRuntime_Bearing_ComplementPositiveXYHorizontalRatio:
                subi.w  #$40,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_ComplementNegativeYVerticalRatio:
                subi.w  #$80,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_AddQuarterTurnForNegativeYHorizontalRatio:
                addi.w  #$40,d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_NegateNegativeXVerticalRatio:
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_AddThreeQuarterTurnForNegativeXHorizontalRatio:
                addi.w  #$C0,d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_AddHalfTurnForNegativeXYVerticalRatio:
                addi.w  #$80,d0
                rts
; ---------------------------------------------------------------------------

SKRuntime_Bearing_ComplementNegativeXYHorizontalRatio:
                subi.w  #$C0,d0
                neg.w   d0
                rts

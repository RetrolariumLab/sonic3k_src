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
                bpl.s   SKBearing_GetDYAndSign
                neg.w   d0
                moveq   #8,d2

SKBearing_GetDYAndSign:
                sub.w   y_pos(a1),d1
                bpl.s   SKBearing_OrderAxisMagnitudes
                neg.w   d1
                moveq   #4,d3

SKBearing_OrderAxisMagnitudes:
                cmp.w   d0,d1
                bhs.s   SKBearing_DivideAndSelectOctant
                exg     d0,d1
                moveq   #2,d4

; Shift the minor magnitude within a word before unsigned division
SKBearing_DivideAndSelectOctant:
                tst.w   d1
                beq.s   SKBearing_PosXYVertReturn
                lsl.w   #5,d0
                divu.w  d1,d0
                add.w   d2,d3
                add.w   d3,d4
                move.w  SKBearing_OctantOffsets(pc,d4.w),d4
                jmp     SKBearing_OctantOffsets(pc,d4.w)
; ---------------------------------------------------------------------------
SKBearing_OctantOffsets:
                dc.w    SKBearing_PosXYVertReturn-SKBearing_OctantOffsets
                dc.w    SKBearing_PosXYHoriz-SKBearing_OctantOffsets
                dc.w    SKBearing_NegYVert-SKBearing_OctantOffsets
                dc.w    SKBearing_NegYHoriz-SKBearing_OctantOffsets
                dc.w    SKBearing_NegXVert-SKBearing_OctantOffsets
                dc.w    SKBearing_NegXHoriz-SKBearing_OctantOffsets
                dc.w    SKBearing_NegXYVert-SKBearing_OctantOffsets
                dc.w    SKBearing_NegXYHoriz-SKBearing_OctantOffsets
; ---------------------------------------------------------------------------

SKBearing_PosXYVertReturn:
                rts
; End of function GetApproximateObjectBearing

; ---------------------------------------------------------------------------

SKBearing_PosXYHoriz:
                subi.w  #$40,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegYVert:
                subi.w  #$80,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegYHoriz:
                addi.w  #$40,d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegXVert:
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegXHoriz:
                addi.w  #$C0,d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegXYVert:
                addi.w  #$80,d0
                rts
; ---------------------------------------------------------------------------

SKBearing_NegXYHoriz:
                subi.w  #$C0,d0
                neg.w   d0
                rts

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
                bpl.s   loc_86248
                neg.w   d0
                moveq   #8,d2

loc_86248:
                sub.w   y_pos(a1),d1
                bpl.s   loc_86252
                neg.w   d1
                moveq   #4,d3

loc_86252:
                cmp.w   d0,d1
                bhs.s   loc_8625A
                exg     d0,d1
                moveq   #2,d4

loc_8625A:
                tst.w   d1
                beq.s   locret_8627E
                lsl.w   #5,d0
                divu.w  d1,d0
                add.w   d2,d3
                add.w   d3,d4
                move.w  off_8626E(pc,d4.w),d4
                jmp     off_8626E(pc,d4.w)
; ---------------------------------------------------------------------------
off_8626E:
                dc.w    locret_8627E-off_8626E
                dc.w    loc_86280-off_8626E
                dc.w    loc_86288-off_8626E
                dc.w    loc_86290-off_8626E
                dc.w    loc_86296-off_8626E
                dc.w    loc_8629A-off_8626E
                dc.w    loc_862A0-off_8626E
                dc.w    loc_862A6-off_8626E
; ---------------------------------------------------------------------------

locret_8627E:
                rts
; End of function GetApproximateObjectBearing

; ---------------------------------------------------------------------------

loc_86280:
                subi.w  #$40,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

loc_86288:
                subi.w  #$80,d0
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

loc_86290:
                addi.w  #$40,d0
                rts
; ---------------------------------------------------------------------------

loc_86296:
                neg.w   d0
                rts
; ---------------------------------------------------------------------------

loc_8629A:
                addi.w  #$C0,d0
                rts
; ---------------------------------------------------------------------------

loc_862A0:
                addi.w  #$80,d0
                rts
; ---------------------------------------------------------------------------

loc_862A6:
                subi.w  #$C0,d0
                neg.w   d0
                rts

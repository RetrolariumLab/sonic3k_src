; Owner: rendering/s3
; Responsibility: Vertical deformation tile drawing, range selection and bottom-up plane operations
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Get_DeformDrawPosVert:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   FindVerticalDeformationBand
                addi.w  #$E0,d0
; End of function Get_DeformDrawPosVert

; =============== S U B R O U T I N E =======================================

FindVerticalDeformationBand:
                cmp.w   d2,d0
                bmi.s   loc_39D18
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   FindVerticalDeformationBand
; ---------------------------------------------------------------------------

loc_39D18:
                move.w  (a5),d1
                swap    d1
                rts
; End of function FindVerticalDeformationBand

; ---------------------------------------------------------------------------

DrawTilesVDeform:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_rounded).w,d6
                bra.s   loc_39D58

; ---------------------------------------------------------------------------

DrawTilesVDeform2:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_BG_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_BG_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_BG_rounded).w,d6

loc_39D58:
                move.w  d6,d1

loc_39D5A:
                sub.w   (a4)+,d6
                bcs.s   loc_39D6A
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                subq.w  #1,d5
                bra.s   loc_39D5A
; ---------------------------------------------------------------------------

loc_39D6A:
                neg.w   d6
                lsr.w   #4,d6
                moveq   #$15,d4
                sub.w   d6,d4
                bcc.s   loc_39D78
                moveq   #0,d4
                moveq   #$15,d6

loc_39D78:
                movem.w d1/d4-d6,-(sp)
                movem.l a4/a6,-(sp)
                lea     2(a6),a5
                jsr     Draw_TileRow(pc)
                movem.l (sp)+,a4/a6
                movem.w (sp)+,d1/d4-d6
                addq.w  #4,a6
                tst.w   d4
                beq.s   loc_39DAC
                lsl.w   #4,d6
                add.w   d6,d1
                subq.w  #1,d5
                move.w  (a4)+,d6
                lsr.w   #4,d6
                move.w  d4,d0
                sub.w   d6,d4
                bcc.s   loc_39D78
                move.w  d0,d6
                moveq   #0,d4
                bra.s   loc_39D78
; ---------------------------------------------------------------------------

loc_39DAC:
                subq.w  #1,d5
                beq.s   locret_39DBA
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                bra.s   loc_39DAC
; ---------------------------------------------------------------------------

locret_39DBA:
                rts

; =============== S U B R O U T I N E =======================================

Get_XDeformRange:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   FindHorizontalDeformationBand
                addi.w  #$140,d0
; End of function Get_XDeformRange

; =============== S U B R O U T I N E =======================================

FindHorizontalDeformationBand:
                cmp.w   d2,d0
                blo.s   loc_39DD0
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   FindHorizontalDeformationBand
; ---------------------------------------------------------------------------

loc_39DD0:
                move.w  (a5),d1
                swap    d1
                rts
; End of function FindHorizontalDeformationBand

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertBottomUp:
                movem.w d1-d2,-(sp)
                bsr.s   Draw_PlaneVertSingleBottomUp
                movem.w (sp)+,d1-d2
                bpl.s   Draw_PlaneVertSingleBottomUp
                rts
; End of function Draw_PlaneVertBottomUp

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertSingleBottomUp:
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  d2,d3
                addi.w  #$F0,d3
                and.w   (Camera_Y_pos_mask).w,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   loc_39E04
                cmp.w   d3,d0
                bhi.s   loc_39E04
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

loc_39E04:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function Draw_PlaneVertSingleBottomUp

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertBottomUpComplex:
                movem.l d1/a4-a5,-(sp)
                bsr.s   DrawDeformedPlaneBottomUpStep
                movem.l (sp)+,d1/a4-a5
                bpl.s   DrawDeformedPlaneBottomUpStep
                rts
; End of function Draw_PlaneVertBottomUpComplex

; =============== S U B R O U T I N E =======================================

DrawDeformedPlaneBottomUpStep:
                and.w   (Camera_Y_pos_mask).w,d1
                move.w  d1,d2
                addi.w  #$F0,d2
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d1,d0
                blo.s   loc_39E46
                cmp.w   d2,d0
                bhi.s   loc_39E46

loc_39E38:
                addq.w  #4,a5
                cmp.w   (a4)+,d0
                bpl.s   loc_39E38
                move.w  (a5),d1
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

loc_39E46:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function DrawDeformedPlaneBottomUpStep
